import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  var now = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showTimePicker(context: context, initialTime: now).then((value) {
            if (value != null) {
              setState(() {
                now = value;
              });
            }
          });
        },
        child: Text('${now.hour}:${now.minute}'));
  }
}