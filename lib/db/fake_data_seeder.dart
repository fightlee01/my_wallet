import 'dart:math';
import 'dart:developer' as developer;
import 'database_helper.dart';

class FakeDataSeeder {
  static final _random = Random();

  /// 入口方法
  static Future<void> seedAll() async {
    final db = await DatabaseHelper.instance.database;

    await _seedPersons(db);
    await _seedGiftInEvents(db);
    await _seedGiftInDetails(db);
    // await _seedGiftOut(db);
  }

  /// 人员
  static Future<void> _seedPersons(db) async {
    final names = ['张三', '李四', '王五', '赵六', '钱七', '孙八'];
    final relations = ['同事', '亲戚', '朋友', '同学'];

    for (var name in names) {
      await db.insert('person', {
        'name': name,
        'relation': relations[_random.nextInt(relations.length)],
      });
    }
    print('person表插入数据。。。。。。。。。');
  }

  /// 收礼事件
  static Future<void> _seedGiftInEvents(db) async {
    final events = ['结婚', '乔迁', '满月酒'];

    for (int i = 0; i < 3; i++) {
      await db.insert('gift_in_event', {
        'title': events[i],
        'event_date': DateTime.now()
            .subtract(Duration(days: i * 30))
            .millisecondsSinceEpoch,
        'total_amount': 0,
        'cost_amount': 0,
      });
    }
    print('event表插入数据。。。。。。。。。');
  }

  /// 收礼明细（多人）
  static Future<void> _seedGiftInDetails(db) async {
    final persons = await db.query('person');
    final events = await db.query('gift_in_event');

    for (var event in events) {
      for (int i = 0; i < 4; i++) {
        final person = persons[_random.nextInt(persons.length)];
        final amount = (_random.nextInt(10) + 2) * 100;

        await db.insert('gift_in_detail', {
          'event_id': event['id'],
          'person_id': person['id'],
          'amount': amount,
          'gift': '',
          'remark': '',
          'created_at': DateTime.now().microsecondsSinceEpoch
        });
      }
    }
    print('detail表插入数据。。。。。。。。。');
  }

  /// 送礼
  // static Future<void> _seedGiftOut(db) async {
  //   final persons = await db.query('person');

  //   for (var p in persons) {
  //     await db.insert('gift_out', {
  //       'person_name': p['name'],
  //       'relation': p['relation'],
  //       'amount': (_random.nextInt(10) + 1) * 100,
  //       'date': DateTime.now()
  //           .subtract(Duration(days: _random.nextInt(300)))
  //           .millisecondsSinceEpoch,
  //       'remark': '随礼',
  //     });
  //   }
  // }
}
