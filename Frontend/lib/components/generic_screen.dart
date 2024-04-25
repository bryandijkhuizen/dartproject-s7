import 'package:flutter/material.dart';

class GenericScreen extends StatelessWidget {
  const GenericScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        36.0,
      ),
      child: child,
    );
  }
}
