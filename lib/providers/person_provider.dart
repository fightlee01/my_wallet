import 'package:flutter/material.dart';
import '../db/person_dao.dart';
import '../models/person.dart';

class PersonProvider extends ChangeNotifier {
  final PersonDao _dao = PersonDao();
  List<Person> _list = [];

  List<Person> get list => _list;

  Future<void> load() async {
    _list = await _dao.getAll();
    notifyListeners();
  }

  Future<void> add(Person person) async {
    await _dao.insert(person);
    await load();
  }

  Future<void> update(Person person) async {
    await _dao.update(person);
    await load();
  }

  Future<void> delete(int id) async {
    await _dao.delete(id);
    await load();
  }
}
