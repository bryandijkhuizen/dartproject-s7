import 'package:darts_application/theme.dart';
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
    ThemeData theme = Theme.of(context);
    if (enabled) {
      return TextButton(
        onPressed: () {
          callback?.call();
        },
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) {
                if (states.contains(WidgetState.focused)) {
                  return theme.colorScheme.secondary;
                }
                return theme.colorScheme.onPrimary;
              },
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              decoration: active ? TextDecoration.underline : null,
              decorationColor: Colors.white,
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
