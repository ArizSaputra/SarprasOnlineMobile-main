import 'package:flutter/material.dart';

class CircularContainerWidget extends StatelessWidget {
  final Color backgroundColor;

  const CircularContainerWidget({super.key, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
    );
  }
}
