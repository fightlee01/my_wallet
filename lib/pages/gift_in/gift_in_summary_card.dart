
import 'package:flutter/material.dart';

class GiftInSummaryCard extends StatelessWidget {
  final int total;
  final int guestCount;
  final int cost;
  final String date;

  const GiftInSummaryCard({
    super.key,
    required this.total,
    required this.guestCount,
    required this.cost,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD96D5C),
            Color(0xFFE5B56F),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            '礼金总额',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '¥${total.toString()}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem('宾客 $guestCount'),
              _infoItem('花费 ¥$cost'),
              _infoItem(date),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoItem(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white),
    );
  }
}
