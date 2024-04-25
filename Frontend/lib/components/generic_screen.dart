import 'package:flutter/material.dart';

class GenericScreen extends StatelessWidget {
  const GenericScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        36.0,
        12.0,
        36.0,
        12.0,
      ),
      child: child,
    );
  }
}
