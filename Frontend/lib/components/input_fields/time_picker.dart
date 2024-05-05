import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;
  const TimePicker({super.key, required this.onTimeSelected});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  var now = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showTimePicker(
          context: context,
          initialTime: now,
        ).then((value) {
          if (value != null) {
            setState(() {
              now = value;
            });
            widget.onTimeSelected(now);
          }
        });
      },
      child: Text('${now.hour}:${now.minute}'),
    );
  }
}