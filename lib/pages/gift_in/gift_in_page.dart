import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'gift_in_add_guest.dart';
import 'selector_row.dart';
import 'gift_in_guest_item.dart';
import 'gift_in_summary_card.dart';
import 'gift_in_search_bar.dart';
import 'package:my_wallet/providers/gift_in_provider.dart';
import 'gift_in_add_events.dart';
import 'gift_in_edit_add.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GiftInPage extends StatelessWidget {
  const GiftInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GiftInProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // if (provider.selectedEvent == null) {
        //   return const Center(
        //     child: Text('暂无收礼事件，请添加'),
        //   );
        // }

        return _buildBody(context, provider);
      },
    );
  }
}

Widget _buildBody(BuildContext context, GiftInProvider provider) {
  final hasEvent = provider.selectedEvent != null;

  return Scaffold(
    backgroundColor: const Color(0xFFF7F4F1),
    appBar: AppBar(
      title: const Text('收礼'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
    ),
    body: Column(
      children: [
        /// 汇总卡片
        GiftInSummaryCard(
          total: hasEvent ? provider.selectedEvent!.totalAmount : 0,
          guestCount: hasEvent ? provider.filteredDetails.length : 0,
          cost: hasEvent ? provider.selectedEvent!.costAmount : 0,
          date: hasEvent
              ? provider.selectedEvent!.eventDate
              : DateFormat('yyyy-MM-dd')
                  .format(DateTime.now())
                  .toString(),
        ),

        /// 顶部选择行
        GiftInSelectorRow(
          eventName:
              hasEvent ? provider.selectedEvent!.title : '暂无事件',
          onSelectEvent: hasEvent
              ? () => _showEventSelector(context, provider)
              : () {},
          onAdd: hasEvent
              ? () => _showAddSelector(context, provider)
              : () => _showAddSelectorEmpty(context),
        ),

        /// 下面内容：只有在选中事件时才显示
        if (hasEvent) ...[
          GiftInSearchBar(
            controller: provider.searchController,
            onChanged: provider.search,
            onFilterTap: () {
              _showRelationFilter(
                context,
                provider.selectedRelation,
                provider.relations,
                provider.setRelation,
              );
            },
          ),

          const SizedBox(height: 8),

          Expanded(
            child: SlidableAutoCloseBehavior(
              child: ListView.builder(
                itemCount: provider.filteredDetails.length,
                itemBuilder: (_, i) {
                  final e = provider.filteredDetails[i];
                  return GiftInGuestItem(
                    name: e.personName,
                    relation: e.relation ?? '',
                    amount: e.amount,
                    key: ValueKey(e.id),
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GiftInEditPage(detail: e),
                        ),
                      );
                    },
                    onDelete: () {provider.deleteGiftInDetail(e.id!);},
                    avatarColor:
                        Colors.primaries[i % Colors.primaries.length],
                  );
                },
              ),
            )
          ),
        ],
      ],
    ),
  );
}


void _showEventSelector(
  BuildContext context,
  GiftInProvider provider,
) {
  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          shrinkWrap: true,
          children: provider.events.map((e) {
            return ListTile(
              title: Text(e.title),
              onTap: () {
                provider.selectEvent(e);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
    },
  );
}

void _showAddSelectorEmpty(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('新增事件'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GiftInAddEventsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

void _showAddSelector(BuildContext context, GiftInProvider provider) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('新增事件'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GiftInAddEventsPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('添加宾客'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GiftInEditPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('批量添加宾客'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GiftInExcelImportPage(eventId: provider.selectedEvent!.id!),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}


void _showRelationFilter(
  BuildContext context,
  String? selected,
  List<String> relations,
  Function(String?) onSelected,
) {
  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('关系筛选',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...relations.map((r) => ListTile(
                  title: Text(r),
                  trailing: selected == r
                      ? const Icon(Icons.check, color: Colors.red)
                      : null,
                  onTap: () {
                    onSelected(r);
                    Navigator.pop(context);
                  },
                )),
            ListTile(
              title: const Text('全部'),
              onTap: () {
                onSelected(null);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}


