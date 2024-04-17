import 'package:flutter/material.dart';

class NavigationDivider extends StatelessWidget {
  const NavigationDivider({
    super.key,
    this.height = 30,
    this.width = 2,
    this.color = Colors.white,
  });

  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}
