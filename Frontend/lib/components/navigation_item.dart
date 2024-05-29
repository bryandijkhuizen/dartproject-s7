import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  const NavigationItem(
      {super.key,
      required this.label,
      required this.location,
      this.active = false,
      this.enabled = true,
      this.callback});

  final String label;
  final String location;
  final bool active;
  final bool enabled;
  final Function()? callback;

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return InkWell(
        onTap: () {
          callback?.call();
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
    return Container();
  }
}
