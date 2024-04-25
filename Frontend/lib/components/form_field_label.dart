import 'package:flutter/material.dart';

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({super.key, required this.label, this.height = 12});

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(
          height: height,
        )
      ],
    );
  }
}
