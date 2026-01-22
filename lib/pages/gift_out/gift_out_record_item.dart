import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GiftOutDetailItem extends StatelessWidget {
  final String name;
  final String relation;
  final int amount;
  final Color avatarColor;

  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  const GiftOutDetailItem({
    super.key,
    required this.name,
    required this.relation,
    required this.amount,
    required this.avatarColor,
    this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(name),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.38, // 两个按钮总宽度
        children: [
          CustomSlidableAction(
            onPressed: (_) {}, // 空实现，真正事件在按钮上
            backgroundColor: const Color(0xFFF7F4F1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// ✏️ 编辑
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.edit_outlined,
                              size: 20, color: Color(0xFF555555)),
                          SizedBox(height: 2),
                          Text(
                            '编辑',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8), 

                  /// 🗑 删除
                  GestureDetector(
                    onTap: () => _confirmDelete(context),
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.delete_outline,
                              color: Colors.white, size: 20),
                          SizedBox(height: 2),
                          Text(
                            '删除',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      child: GestureDetector(
        // onDoubleTap: onEdit,
        child: _content(),
      ),
    );
  }


  /// 原 UI 完全保留
  Widget _content() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: avatarColor,
            child: Text(
              name.characters.first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      relation,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '结婚',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '$amount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B1E1E),
                ),
              ),
              Text(
                '2026-1-10',
              )
            ],
          )
        ],
      ),
    );
  }

  /// 删除确认
  Future<void> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('确认删除？'),
        content: const Text('删除后不可恢复'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (result != true) return;
    if (!context.mounted) return;
    print('Confirmed delete===========');

    /// ⭐ 1️⃣ 先收起滑动
    Slidable.of(context)?.close();

    /// ⭐ 2️⃣ 删除数据（Provider / setState）
    onDelete();
  }
}