import 'package:flutter/material.dart';
import '../db/gift_out_dao.dart';
import '../models/gift_out.dart';

class GiftOutProvider extends ChangeNotifier {
  final GiftOutDao _dao = GiftOutDao();
  List<Map<String, dynamic>> list = [];

  Future<void> load() async {
    list = await _dao.getListWithPerson();
    notifyListeners();
  }

  Future<void> add(GiftOut item) async {
    await _dao.insert(item);
    await load();
  }
}
