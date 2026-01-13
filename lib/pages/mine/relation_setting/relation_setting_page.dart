import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/relation_provider.dart';
import 'relation_add_edit_page.dart';

class RelationSettingPage extends StatelessWidget {
  const RelationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关系设置'),
      ),
      body: Consumer<RelationProvider>(
        builder: (context, provider, _) {
          final relations = provider.relations;

          return ListView.separated(
            itemCount: relations.length + 1,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              /// 最后一行：添加关系
              if (index == relations.length) {
                return ListTile(
                  leading: const Icon(Icons.add, color: Colors.blue),
                  title: const Text(
                    '添加关系',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () async {
                    final changed = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RelationEditPage(),
                      ),
                    );
                    if (changed == true) {
                      provider.load();
                    }
                  },
                );
              }

              final relation = relations[index];

              return ListTile(
                title: Text(relation.name),
                subtitle: relation.remark?.isNotEmpty == true
                    ? Text(relation.remark!)
                    : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showActionSheet(context, provider, relation);
                },
              );
            },
          );
        },
      ),
    );
  }

  /// 长按 / 点击后的操作
  void _showActionSheet(
    BuildContext context,
    RelationProvider provider,
    relation,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('编辑'),
                onTap: () async {
                  Navigator.pop(context);
                  final changed = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RelationEditPage(relation: relation),
                      ),
                    );
                    if (changed == true) {
                      provider.load();
                    }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  '删除',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await provider.deleteRelation(relation.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
