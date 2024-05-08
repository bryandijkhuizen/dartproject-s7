import 'package:flutter/material.dart';

class GenericScreen extends StatelessWidget {
  const GenericScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: child,
    );
  }
}
