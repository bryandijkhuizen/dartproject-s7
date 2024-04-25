import 'package:flutter/material.dart';

class FormSaveButton extends StatelessWidget {
  const FormSaveButton(
      {super.key, required this.onCancel, required this.onSave});

  final void Function()? onCancel;
  final void Function()? onSave;

  MaterialStateProperty<Color?> getMaterialStateOverlayColor(ThemeData theme) =>
      MaterialStateProperty.resolveWith(
        (states) => theme.colorScheme.onPrimary.withOpacity(0.1),
      );

  final BorderRadius leftButtonBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(10),
    bottomLeft: Radius.circular(10),
  );

  final BorderRadius rightButtonBorderRadius = const BorderRadius.only(
    topRight: Radius.circular(10),
    bottomRight: Radius.circular(10),
  );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              overlayColor: getMaterialStateOverlayColor(theme),
              shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                  borderRadius: leftButtonBorderRadius,
                ),
              ),
            ),
            onPressed: () {
              onCancel?.call();
            },
            child: const Text('Cancel'),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => theme.colorScheme.secondary,
              ),
              overlayColor: getMaterialStateOverlayColor(theme),
              shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                  borderRadius: rightButtonBorderRadius,
                ),
              ),
            ),
            onPressed: () {
              onSave?.call();
            },
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}
