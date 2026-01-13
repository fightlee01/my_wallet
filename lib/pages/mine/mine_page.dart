import 'package:flutter/material.dart';
import 'relation_setting/relation_setting_page.dart';
import 'relation_setting/relation_add_edit_page.dart';
// import 'event_setting/event_setting_page.dart';

class MinePageDetail extends StatelessWidget {
  const MinePageDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildSettingGroup(context),
        ],
      ),
    );
  }

  /// ================== 头像 & 昵称 ==================
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(
              Icons.person,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '昵称',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// ================== 设置入口 ==================
  Widget _buildSettingGroup(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSettingItem(
            context,
            title: '关系设置',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RelationSettingPage(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingItem(
            context,
            title: '事件设置',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Center(child: Text('事件设置页面 Placeholder')),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
