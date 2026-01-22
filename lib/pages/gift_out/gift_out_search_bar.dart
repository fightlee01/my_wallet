import 'package:flutter/material.dart';
import 'package:my_wallet/lib/common/enums/gift_search_type.dart';

class GiftOutSearchBar extends StatelessWidget {
  final TextEditingController controller;

  /// 当前搜索类型
  final GiftSearchType searchType;

  /// 切换搜索类型
  final ValueChanged<GiftSearchType> onSearchTypeChanged;

  /// 输入变化
  final ValueChanged<String> onChanged;

  /// 右侧高级筛选
  final VoidCallback onFilterTap;

  // 当前搜索类型标签
  // String value;

  const GiftOutSearchBar({
    super.key,
    required this.controller,
    required this.searchType,
    // required this.value,
    required this.onSearchTypeChanged,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          /// 搜索框（含分类）
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  /// 分类选择
                  _SearchTypeSelector(
                    value: searchType,
                    onChanged: onSearchTypeChanged,
                  ),

                  const VerticalDivider(width: 1),

                  /// 输入框
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: '搜索${searchType.label}',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          /// 高级筛选
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onFilterTap,
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchTypeSelector extends StatelessWidget {
  final GiftSearchType value;
  final ValueChanged<GiftSearchType> onChanged;

  const _SearchTypeSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<GiftSearchType>(
      onSelected: onChanged,
      itemBuilder: (context) {
        return GiftSearchType.values
            .map(
              (e) => PopupMenuItem(
                value: e,
                child: Text(e.label),
              ),
            )
            .toList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Text(
              value.label,
              style: const TextStyle(fontSize: 14),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

