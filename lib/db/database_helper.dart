import 'package:my_wallet/models/gift_out_event.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:my_wallet/models/git_in_detail.dart';
import 'package:my_wallet/models/gift_in_event.dart';
import 'package:my_wallet/models/relation.dart';
import 'package:my_wallet/constants/error_codes.dart';

class DatabaseHelper {
  static const _dbName = 'gift_book.db';
  static const _dbVersion = 1;

  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    /// 创建人员表
    await db.execute(_createPersonTable);
    /// 创建收礼事件表
    await db.execute(_createGiftInEventTable);
    /// 创建收礼明细表
    await db.execute(_createGiftInDetailTable);
    // 创建送礼事件表
    await db.execute(_createGiftOutEventTable);
    // 创建送礼明细表
    await db.execute(_createGiftOutDetailTable);
    /// 创建关系表
    await db.execute(_createRelationTable);
    /// 插入默认关系数据
    await db.execute(_insertDefaultRelations);
  }

  Future<List<GiftInEvent>> getGiftInEvents() async {
    final db = await database;
    final res = await db.query('gift_in_event');
    return res.map(GiftInEvent.fromMap).toList();
  }

  Future<List<GiftInDetail>> getGiftInDetails(int eventId) async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT 
        d.*,
        p.name AS person_name,
        r.name AS relation,
        r.id AS relation_id,
        p.phone AS phone,
        p.remark AS person_remark
      FROM gift_in_detail d
      JOIN person p ON d.person_id = p.id
      LEFT JOIN relation r ON p.relation = r.id
      WHERE d.event_id = ?
    ''', [eventId]);


    // final result = await db.rawQuery('''
    //   SELECT d.*, p.name AS person_name, p.relation
    //   FROM gift_in_detail d
    //   JOIN person p ON d.person_id = p.id
    //   WHERE d.event_id = ?
    // ''', [eventId]);

    return result.map(GiftInDetail.fromMap).toList();
  }

  Future<int> insertGiftInEvent(GiftInEvent event) async {
    final db = await database;
    final id = await db.insert(
      'gift_in_event',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  /// 新增关系
  Future<int> insertRelation(Relation relation) async {
    final db = await database;
    return db.insert('relation', relation.toMap());
  }

  /// 更新关系
  Future<int> updateRelation(Relation relation) async {
    final db = await database;
    return db.update(
      'relation',
      relation.toMap(),
      where: 'id = ?',
      whereArgs: [relation.id],
    );
  }
  // 获取所有关系
  Future<List<Relation>> getRelations() async {
    final db = await database;
    final result = await db.query('relation');
    return result.map((e) => Relation.fromMap(e)).toList();
  }
  /// 删除关系
  Future<void> deleteRelation(int id) async {
    final db = await database;
    await db.delete(
      'relation',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // 插入人员，返回新插入的人员 ID
  Future<int> insertPerson(Map<String, dynamic> person) async {
    final db = await database;
    // 加入异常处理以防重复插入和其他数据库错误
    try {
      final List<Map<String, Object?>> existingPersons = await db.query('person', where: 'name = ?', whereArgs: [person['name']]);
      if (existingPersons.isNotEmpty) {
        return existingPersons.first['id'] as int;
      }
    } catch (e) {
      // 处理其他数据库错误
      print(e.toString());
      return DBErrorCodes.personInsertError;
    }
    // 正常插入
    return await db.insert(
      'person',
      person,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 删除入礼详情
  Future<int> deleteGiftInDetail(int detailId) async {
    final db = await database;
    int result = await db.delete(
      'gift_in_detail',
      where: 'id = ?',
      whereArgs: [detailId],
    );
    return result;
  }

  // 更新人员信息
  Future<int> updatePerson(int personId, Map<String, dynamic> changePerson) async {
    final db = await database;
    return await db.update(
      'person',
      changePerson,
      where: 'id = ?',
      whereArgs: [personId],
    );
  }
  // 新增入礼详情
  Future<int> insertGiftInDetail(Map<String, dynamic> detail, int? eventId, int personId) async {
    final db = await database;
    final List<Map<String, Object?>> existingDetails = await db.query('gift_in_detail', where: 'event_id = ? AND person_id = ?', whereArgs: [eventId, personId]);
    if (existingDetails.isNotEmpty) {
      return DBErrorCodes.detailExists;
    }
    try {
      // 其他可能的数据库错误处理
      return await db.insert(
        'gift_in_detail',
        detail,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e.toString());
      return DBErrorCodes.detailInsertError;
    }
  }
  // 更新入礼详情
  Future<int> updateGiftInDetail(int detailId, Map<String, dynamic> changeDetail) async {
    final db = await database;
    return await db.update(
      'gift_in_detail',
      changeDetail,
      where: 'id = ?',
      whereArgs: [detailId],
    );
  }

  // 
  Future<int> insertGiftOutEvent(Map<String, dynamic> giftOutEvent) async {
    final db = await database;
    return await db.insert(
      'gift_out_event',
      giftOutEvent,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteEvent(int eventId) async {
    final db = await database;
    await db.delete(
      'gift_out_event',
      where: 'id = ?',
      whereArgs: [eventId],
    );
  }

  Future<List<GiftOutEvent>> getGiftOutEventAll() async {
    final db = await database;
    final res = await db.query('gift_out_event');
    return res.map(GiftOutEvent.fromMap).toList();
  }




  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 预留升级
  }

  /// ================== 建表 SQL ==================
  // 人员表
  static const String _createPersonTable = '''
  CREATE TABLE person (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    relation INTEGER DEFAULT 0,
    phone TEXT,
    remark TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
  );
  ''';
  // 收礼明细表
  static const String _createGiftInDetailTable = '''
  CREATE TABLE gift_in_detail (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    amount INTEGER NOT NULL,
    gift TEXT,
    remark TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES gift_in_event(id),
    FOREIGN KEY (person_id) REFERENCES person(id)
  );
  ''';
  // 收礼事件表
  static const String _createGiftInEventTable = '''
  CREATE TABLE gift_in_event (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    event_date TEXT NOT NULL,
    location TEXT,
    total_amount INTEGER DEFAULT 0,
    cost_amount INTEGER DEFAULT 0,
    remark TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
  );
  ''';
  // 送礼事件表
  static const String _createGiftOutEventTable = '''
  CREATE TABLE gift_out_event (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    remark TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
  );
  ''';
  // 送礼明细表
  static const String _createGiftOutDetailTable = '''
  CREATE TABLE gift_out_detail (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    gift_out_amount INTEGER NOT NULL,
    gift TEXT,
    remark TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES gift_out_event(id),
    FOREIGN KEY (person_id) REFERENCES person(id)
  );
  ''';
  // 关系表
  static const String _createRelationTable = '''
  CREATE TABLE relation (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    sort INTEGER DEFAULT 0,
    remark TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
  );
  ''';
  /// 默认关系数据
  static const String _insertDefaultRelations = '''
  INSERT OR IGNORE INTO relation (name, sort) VALUES
    ('亲戚', 1),
    ('朋友', 2),
    ('同学', 3),
    ('同事', 4);
  ''';
}
