import '../models/person.dart';
import 'database_helper.dart';

class PersonDao {
  final _dbHelper = DatabaseHelper.instance;

  Future<int> insert(Person person) async {
    final db = await _dbHelper.database;
    return await db.insert('person', person.toMap());
  }

  Future<List<Person>> getAll() async {
    final db = await _dbHelper.database;
    final result = await db.query('person', orderBy: 'id DESC');
    return result.map((e) => Person.fromMap(e)).toList();
  }

  Future<int> update(Person person) async {
    final db = await _dbHelper.database;
    return await db.update(
      'person',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'person',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
