import 'package:flutter/material.dart';

import 'home_page.dart';
// import 'gift_out/gift_out_add_page.dart';
import 'gift_in/gift_in_page.dart';
import 'mine_page.dart';
import 'package:my_wallet/pages/gift_out/gift_out_page.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const HomePage(),
    const GiftInPage(),
    const GiftOutPage(),
    const MinePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // 4 个必须用 fixed
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_received),
            label: '收礼',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_made),
            label: '送礼',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
