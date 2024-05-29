import 'package:flutter/material.dart';

class FormSaveButton extends StatelessWidget {
  const FormSaveButton(
      {super.key,
      required this.onCancel,
      required this.onSave,
      this.loading = false});

  final void Function()? onCancel;
  final void Function()? onSave;
  final bool loading;

  WidgetStateProperty<Color?> getMaterialStateOverlayColor(ThemeData theme) =>
      WidgetStateProperty.resolveWith(
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

    Color? cancelBackgroundColorResolver(states) {
      if (states.contains(WidgetState.disabled)) {
        return theme.colorScheme.primary.withAlpha(128);
      }
      return theme.colorScheme.primary;
    }

    Color? saveBackgroundColorResolver(states) {
      if (states.contains(WidgetState.disabled)) {
        return theme.colorScheme.secondary.withAlpha(128);
      }
      return theme.colorScheme.secondary;
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith(
                  cancelBackgroundColorResolver),
              overlayColor: getMaterialStateOverlayColor(theme),
              shape: WidgetStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                  borderRadius: leftButtonBorderRadius,
                ),
              ),
            ),
            onPressed: loading
                ? null
                : () {
                    onCancel?.call();
                  },
            child: const Text('Cancel'),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith(
                  saveBackgroundColorResolver),
              overlayColor: getMaterialStateOverlayColor(theme),
              shape: WidgetStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                  borderRadius: rightButtonBorderRadius,
                ),
              ),
            ),
            onPressed: loading
                ? null
                : () {
                    onSave?.call();
                  },
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}
