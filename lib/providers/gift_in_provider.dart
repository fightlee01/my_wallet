import 'package:flutter/material.dart';
import 'package:my_wallet/db/database_helper.dart';
import 'package:my_wallet/models/gift_in_event.dart';
import 'package:my_wallet/models/git_in_detail.dart';
import 'package:my_wallet/models/relation.dart';
import 'package:my_wallet/models/person.dart';

class GiftInProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  /// 收礼事件
  List<GiftInEvent> events = [];
  GiftInEvent? selectedEvent;

  /// 原始明细（数据库数据）
  List<GiftInDetail> allDetails = [];

  /// 过滤后的明细（UI 用）
  List<GiftInDetail> filteredDetails = [];

  /// 搜索控制器
  final TextEditingController searchController = TextEditingController();

  /// 当前关系筛选
  String? selectedRelation;

  /// 可选关系列表
  // final List<String> relations = ['同事', '亲戚', '朋友', '同学'];
  List<Relation> oriRelations = [];
  List<String> relations = [];

  bool loading = false;

  /// 当前添加宾客时选择的关系
  String? selectedRelationForAdd;
  int? selectedRelationIdForAdd;

  /// 初始化
  Future<void> load() async {
    loading = true;
    notifyListeners();

    events = await _db.getGiftInEvents();
    oriRelations = await _db.getRelations();
    relations = oriRelations.map((e) => e.name).toList();

    if (events.isNotEmpty) {
      await selectEvent(events.first);
    }

    loading = false;
    notifyListeners();
  }

  /// 选择事件
  Future<void> selectEvent(GiftInEvent event) async {
    selectedEvent = event;

    allDetails = await _db.getGiftInDetails(event.id!);

    /// 每次切换事件，重置筛选条件
    selectedRelation = null;
    searchController.clear();

    _applyFilter();
  }

  /// 添加收礼事件
  Future<void> addGiftInEvent(GiftInEvent event) async {
    final id = await _db.insertGiftInEvent(event);
    final newEvent = GiftInEvent(
      id: id,
      title: event.title,
      eventDate: event.eventDate,
      location: event.location,
      totalAmount: event.totalAmount,
      costAmount: event.costAmount,
      remark: event.remark,
    );
    // 插入列表
    events.insert(0, newEvent);

    // 选中新建事件
    selectedEvent = newEvent;

    // 清空并初始化相关状态
    filteredDetails.clear();
    searchController.clear();
    selectedRelation = null;

    // 通知 UI
    notifyListeners();
  }

  /// 搜索（供 TextField 调用）
  void search(String keyword) {
    _applyFilter();
  }

  /// 设置关系
  void setRelation(String? relation) {
    selectedRelation = relation;
    _applyFilter();
  }

  /// 统一过滤逻辑
  void _applyFilter() {
    final keyword = searchController.text.trim();

    filteredDetails = allDetails.where((e) {
      final matchName =
          keyword.isEmpty || (e.personName.contains(keyword));

      final matchRelation =
          selectedRelation == null || e.relation == selectedRelation;

      return matchName && matchRelation;
    }).toList();

    notifyListeners();
  }

  void setSelectRelationForAdd(String relationName, int? relationId) {
    selectedRelationForAdd = relationName;
    selectedRelationIdForAdd = relationId;
    notifyListeners();
  }
}
