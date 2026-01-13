import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/person_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final persons = context.watch<PersonProvider>().list;

    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: Center(
        child: Text('当前人物数量：${persons.length}'),
      ),
    );
  }
}
