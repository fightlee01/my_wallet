
import 'package:flutter/material.dart';

class GiftOutSummaryCard extends StatelessWidget {
  final int giftOutAmount;
  final int giftOutPersonCount;

  const GiftOutSummaryCard({
    super.key,
    required this.giftOutAmount,
    required this.giftOutPersonCount,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoColumn('送礼总额', '¥${giftOutAmount.toString()}'),
          _buildInfoColumn('送礼人数', giftOutPersonCount.toString()),  
        ],
        ),
      );
      }
  }

Widget _buildInfoColumn(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Text(
      title,
      style: const TextStyle(
      color: Colors.white70,
      fontSize: 18,
      ),
    ),
    const SizedBox(height: 8),
    Text(
      value,
      style: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      ),
    ),
    ],
  );
}
