import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/relation.dart';

class RelationProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  List<Relation> relations = [];

  Future<void> load() async {
    relations = await _db.getRelations();
    notifyListeners();
  }

  /// 新增关系
  Future<void> addRelation(Relation relation) async {
    await _db.insertRelation(relation);
    notifyListeners();
  }

  /// 更新关系
  Future<void> updateRelation(Relation relation) async {
    await _db.updateRelation(relation);
    notifyListeners();
  }

  Future<void> deleteRelation(int id) async {
    await _db.deleteRelation(id);
    await load();
  }
}
