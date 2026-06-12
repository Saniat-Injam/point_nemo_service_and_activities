import 'package:flutter/material.dart';

class DefaultProfileAvatar extends StatelessWidget {
  final double iconSize;

  const DefaultProfileAvatar({super.key, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: Color(0xFFF3F4F6),
        color: Color(0xFFE5E7EB),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: iconSize,
        // color: const Color(0xFFE5E7EB),
        color: const Color(0xFF9CA3AF),
      ),
    );
  }
}
