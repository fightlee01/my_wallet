import 'package:flutter/material.dart';
import 'package:my_wallet/models/gift_out_event.dart';
import 'package:my_wallet/pages/gift_out/widgets/gift_out_event_form_sheet.dart';
import 'package:my_wallet/providers/gift_out_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/widgets/confirm_dialog.dart';
import 'widgets/gift_out_event_item.dart';
import 'widgets/gift_out_add_event_item.dart';

class GiftOutEventManagePage extends StatelessWidget {
  const GiftOutEventManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F1),
      appBar: AppBar(
        title: const Text('管理送礼事件'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Consumer<GiftOutProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              ...provider.events.map((event) => Dismissible(
                key: ValueKey(event.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await _confirmDelete(context);
                },
                onDismissed: (_) {
                  provider.deleteEvent(event.id!);
                },
                child: GiftOutEventItem(
                  event: event,
                  onTap: () {
                    _showEventFormSheet(
                      context,
                      provider,
                      event: event,
                    );
                  },
                ),
              )),
              const SizedBox(height: 12),
              AddEventItem(
                onTap: () => _showEventFormSheet(context, provider),
              ),
            ],
          );
        }
      )
    );
  }

  /// 新增 / 编辑 统一入口
  static void _showEventFormSheet(
    BuildContext context, GiftOutProvider provider, {
    GiftOutEvent? event,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GiftOutEventFormSheet(event: event, provider: provider),
    );
  }

/// 删除确认对话框
  static Future<bool> _confirmDelete(BuildContext context) async {
    return await ConfirmDialog.show(
      context,
      title: '确认删除该送礼事件？',
      content: '删除后，相关的送礼记录不会被删除，但该事件将无法恢复。',
      confirmText: '删除',
      cancelText: '取消',
    );
  }
}
