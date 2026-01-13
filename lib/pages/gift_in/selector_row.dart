import 'package:flutter/material.dart';

class GiftInSelectorRow extends StatelessWidget {
  final String eventName;
  final VoidCallback onSelectEvent;
  final VoidCallback onAdd;

  const GiftInSelectorRow({
    super.key,
    required this.eventName,
    required this.onSelectEvent,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _selector(
              text: eventName,
              onTap: onSelectEvent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _selector(
              text: '新增宾客/事件',
              onTap: onAdd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selector({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(width: 8),
            const Icon(Icons.filter_list),
            // const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );
  }
}
