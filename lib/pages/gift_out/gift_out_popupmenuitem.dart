import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool isPrimary;

  const MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
