import 'package:flutter/material.dart';
import 'package:minimo_video/services/utils.dart';

class SizeRow extends StatelessWidget {
  final String label;
  final int size;
  final MaterialColor color;

  const SizeRow({
    super.key,
    required this.label,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            label == 'Original' ? Icons.input : Icons.output,
            color: color.shade400,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(label,
            style: TextStyle(fontSize: 16, color: color.shade600, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Text(
            Utils.formatSize(size),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color.shade800),
          ),
        ],
      ),
    );
  }
}
