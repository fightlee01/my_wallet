import 'package:flutter/material.dart';
import 'package:my_wallet/models/gift_out_event.dart';
import '../db/gift_out_dao.dart';
import '../models/gift_out_detail.dart';
import '../models/gift_out.dart';
import 'package:my_wallet/lib/common/enums/gift_search_type.dart';
import 'package:my_wallet/db/database_helper.dart';
import 'package:my_wallet/models/relation.dart';

class GiftOutProvider extends ChangeNotifier {
  final GiftOutDao _dao = GiftOutDao();
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Map<String, dynamic>> list = [];
  bool loading = false;

  List<GiftOutDetail> filteredDetails = [
    GiftOutDetail(
      id: 1,
      eventId: 1,
      personId: 1,
      giftOutAmount: 100,
      gift: '礼物A',
      remark: '备注A',
      personName: '张三',
      relation: '朋友',
      relationId: 1,
      phone: '1234567890',
      personRemark: '好朋友',
      giftOutDate: '2024-01-01',
    ),
    GiftOutDetail(
      id: 2,
      eventId: 1,
      personId: 2,
      giftOutAmount: 200,
      gift: '礼物B',
      remark: '备注B',
      personName: '李四',
      relation: '同事',
      relationId: 2,
      phone: '0987654321',
      personRemark: '好同事',
      giftOutDate: '2024-01-02',
    ),
  ];

  List<GiftOutEvent> events = [];

  GiftSearchType searchType = GiftSearchType.name;

  final searchController = TextEditingController();

  List<Relation> oriRelations = [];
  List<String> relations = [];

  Future<void> load() async {
    // list = await _dao.getListWithPerson();
    events = await getGiftOutEventAll();
    oriRelations = await _db.getRelations();
    print(oriRelations.map((e) => e.name).toList());
    relations = oriRelations.map((e) => e.name).toList();
    notifyListeners();
  }

  Future<void> loadEvents() async {
    events = await getGiftOutEventAll();
    print(events.map((e) => e.title).toList());
    notifyListeners();
  }

  void setSearchType(GiftSearchType type) {
    searchType = type;
    notifyListeners();
  }

  Future<void> add(GiftOut item) async {
    await _dao.insert(item);
    await load();
  }
  // 新增送礼事件
  Future<int> insertGiftOutEvent(Map<String, dynamic> giftOutEvent) async {
    int res = await _db.insertGiftOutEvent(giftOutEvent);
    await loadEvents();
    notifyListeners();
    return res;
  }
  // 删除送礼事件
  Future<void> deleteEvent(int eventId) async {
    await _db.deleteEvent(eventId);
    await loadEvents();
    notifyListeners();
  }
  // 获取所有送礼事件
  Future<List<GiftOutEvent>> getGiftOutEventAll() async {
    events = await _db.getGiftOutEventAll();
    return events;
  }
  Future<int> getPersonIdByName(String name) async {
    return await _db.getPersonIdByName(name);
  }
  // 
  Future<int> insertPerson(Map<String, dynamic> person) async {
    int res = await _db.insertPerson(person);
    return res;
  }
}
