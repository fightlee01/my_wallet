import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/providers/gift_out_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_wallet/pages/gift_out/gift_out_record_item.dart';
import 'package:my_wallet/pages/gift_out/gift_out_summary_card.dart';
import 'package:my_wallet/pages/gift_out/gift_out_search_bar.dart';
import 'package:my_wallet/lib/common/enums/gift_search_type.dart';
import 'package:my_wallet/pages/gift_out/gift_out_popupmenuitem.dart';
import 'package:my_wallet/pages/gift_out/gift_out_manage_event.dart';
import 'package:my_wallet/pages/gift_out/gift_out_add_page.dart';

class GiftOutPage extends StatelessWidget {
  const GiftOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GiftOutProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildBody(context, provider);
      },
    );
  }
}

Widget _buildBody(BuildContext context, GiftOutProvider provider) {

  return Scaffold(
    backgroundColor: const Color(0xFFF7F4F1),
    appBar: AppBar(
      title: const Text('送礼'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      actions: [
        PopupMenuButton<GiftMenuAction>(
          icon: const Icon(Icons.add),
          tooltip: '新增',
          offset: Offset(0, 45),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          onSelected: (action) {
            switch (action) {
              case GiftMenuAction.addRecord:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GiftOutAddPage(),
                  ),
                );
                break;
              case GiftMenuAction.manageEvent:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GiftOutEventManagePage(),
                  ),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: GiftMenuAction.addRecord,
              child: MenuItem(
                icon: Icons.edit,
                iconColor: Color(0xFFEF6C00),
                title: '新增送礼',
                isPrimary: true,
                ),
            ),
            const PopupMenuItem(
              value: GiftMenuAction.manageEvent,
              child: MenuItem(
                icon: Icons.event,
                iconColor: Colors.grey,
                title: '管理事件',
              ),
            ),
          ],
        ),
        const SizedBox(width: 4), // 右侧留一点呼吸空间
      ],
    ),
    body: Column(
      children: [
        /// 汇总卡片
        GiftOutSummaryCard(
          giftOutAmount: 8888888,
          giftOutPersonCount: 20,
        ),

        /// 搜索栏
        GiftOutSearchBar(
          controller: provider.searchController,
          searchType: provider.searchType,
          onSearchTypeChanged: (type) {
            provider.setSearchType(type);
          },
          onChanged: (text) {
          },
          onFilterTap: () {},
        ),
        /// 下面内容：只有在选中事件时才显示

          const SizedBox(height: 8),

          Expanded(
            child: SlidableAutoCloseBehavior(
              child: ListView.builder(
                itemCount: provider.filteredDetails.length,
                itemBuilder: (_, i) {
                  final e = provider.filteredDetails[i];
                  return GiftOutDetailItem(
                    name: e.personName,
                    relation: e.relation ?? '',
                    amount: e.giftOutAmount,
                    key: ValueKey(e.id),
                    // onEdit: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => (null),
                    //     ),
                    //   );
                    // },
                    onDelete: () {},
                    avatarColor:
                        Colors.primaries[i % Colors.primaries.length],
                  );
                },
              ),
            )
          ),
        ],
    ),
  );
}