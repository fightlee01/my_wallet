import 'package:flutter/material.dart';
import '../db/gift_out_dao.dart';
import '../models/gift_out_event.dart';

class GiftOutEventProvider extends ChangeNotifier {
  final GiftOutDao _dao = GiftOutDao();

  List<GiftOutEvent> _events = [];
  List<GiftOutEvent> get events => _events;

  Future<void> loadEvents() async {
    
  }

  Future<void> addEvent(String title, String? remark) async {
    
  }

  Future<void> updateEvent(GiftOutEvent event) async {
    
  }

  Future<void> deleteEvent(int id) async {
    
  }
}
