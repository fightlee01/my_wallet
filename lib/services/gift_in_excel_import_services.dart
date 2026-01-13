import 'dart:io';
import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../db/database_helper.dart';

class ImportResult {
  final int success;
  final int skipped;

  ImportResult(this.success, this.skipped);
}

class GiftInExcelImportService {
  static Future<ImportResult?> import({
    required BuildContext context,
    required int eventId,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result == null) return null;

    final bytes = result.files.single.bytes ??
        await File(result.files.single.path!).readAsBytes();

    return _parseAndInsert(bytes, eventId);
  }

  static Future<ImportResult> _parseAndInsert(
    Uint8List bytes,
    int eventId,
  ) async {
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.first;

    int success = 0;
    int skipped = 0;

    if (sheet == null) {
      return ImportResult(0, 0);
    }

    final dbHelper = DatabaseHelper.instance;
    final database = await dbHelper.database;

    await database.transaction((txn) async {
      final relationIds = await txn.query('relation', columns: ['id']).then(
        (rows) => rows.map((row) => row['id'] as int).toList(),
      );
      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];

        final name = _parseString(row[0]?.value);
        final relation = _parseRelation(row[1]?.value, relationIds);
        final amount = _parseAmount(row[2]?.value);
        final gift = _parseString(row[3]?.value);
        final remark = _parseString(row[4]?.value);

        if (name == null || name.isEmpty) {
          skipped++;
          continue;
        }

        if (amount == null || amount <= 0) {
          skipped++;
          continue;
        }

        final personId = await _getOrCreatePerson(
          txn,
          name,
          relation,
          remark,
        );

        await txn.insert('gift_in_detail', {
          'event_id': eventId,
          'person_id': personId,
          'amount': amount,
          'gift': gift,
          'remark': remark,
        });

        success++;
      }
    });
    return ImportResult(success, skipped);
  }

  static int? _parseAmount(dynamic value) {
    if (value == null) return null;

    // Excel 数字单元格（最常见）
    if (value is num) {
      return value.round(); // 或 value.toInt()
    }

    // 字符串单元格
    if (value is String) {
      final v = value.trim();
      if (v.isEmpty) return null;

      // 兼容 "200.0"
      final d = double.tryParse(v);
      if (d != null) return d.round();

      return int.tryParse(v);
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  static int? _parseRelation(dynamic value, List<int> relationIds) {
    if (value == null) return 0;
    if (value is int) return value;
    final s = value.toString().trim();
    int? ss = int.tryParse(s);
    return ss != null && relationIds.contains(ss) ? ss : 0;
  }



  static Future<int> _getOrCreatePerson(
    DatabaseExecutor txn,
    String name,
    int? relation,
    String? remark,
  ) async {
    final res = await txn.query(
      'person',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );

    if (res.isNotEmpty) {
      return res.first['id'] as int;
    }
    return await txn.insert('person', {
      'name': name,
      'relation': relation,
      'remark': remark,
    });
  }
}
