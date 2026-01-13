import 'database_helper.dart';
import '../models/gift_out.dart';

class GiftOutDao {
  final _dbHelper = DatabaseHelper.instance;

  Future<int> insert(GiftOut item) async {
    final db = await _dbHelper.database;
    return await db.insert('gift_out', item.toMap());
  }

  Future<List<Map<String, dynamic>>> getListWithPerson() async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT g.*, p.name, p.relation
      FROM gift_out g
      JOIN person p ON g.person_id = p.id
      ORDER BY g.date DESC
    ''');
  }
}
