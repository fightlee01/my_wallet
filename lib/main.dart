import 'package:flutter/material.dart';
import 'package:my_wallet/pages/main_tab_page.dart';
import 'package:my_wallet/providers/gift_in_provider.dart';
import 'package:provider/provider.dart';

import 'providers/person_provider.dart';
import 'providers/gift_out_provider.dart';
// import 'providers/gift_in_provider.dart';
import 'providers/relation_provider.dart';
import 'db/database_helper.dart';
// import 'pages/gift_out/gift_out_add_page.dart';
// import 'pages/home_page.dart';
// import 'pages/main_tab_page.dart';
// import 'db/fake_data_seeder.dart';
// import 'dart:developer' as developer;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  /// ⚠️ 只在 Debug 下插入 fake 数据
  // FakeDataSeeder.seedAll();
  // developer.log('person表插入数据。。。。。。。。。');
  // assert(() {
  //   FakeDataSeeder.seedAll();
  //   print('person表插入数据。。。。。。。。。shdjfslahsdfas');
  //   return true;
  // }());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PersonProvider>(
          create: (_) => PersonProvider()..load(),
        ),
        ChangeNotifierProvider<GiftInProvider>(
          create: (_) => GiftInProvider()..load(),
        ),
        ChangeNotifierProvider<GiftOutProvider>(
          create: (_) => GiftOutProvider()..load(),
        ),
        ChangeNotifierProvider<RelationProvider>(
          create: (_) => RelationProvider()..load(),
        ),
        // ChangeNotifierProvider<GiftInEditProvider>(
        //   create: (_) => GiftInEditProvider()..load(),
        // ),
      ],
      child: MaterialApp(
        title: '账本',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const MainTabPage(),
      )
    );
  }
}





  
  
