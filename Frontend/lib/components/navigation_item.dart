import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationItem extends StatelessWidget {
  NavigationItem({
    super.key,
    required this.label,
    required this.location,
    this.active = false,
  });

  final String label;
  final String location;
  bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(location);
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'Poppins',
              decoration: active ? TextDecoration.underline : null,
              decorationColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
