import 'package:flutter/material.dart';

class AddEventItem extends StatelessWidget {
  final VoidCallback onTap;

  const AddEventItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFEF6C00).withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Color(0xFFEF6C00)),
              SizedBox(width: 6),
              Text(
                '添加送礼事件',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF6C00),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
