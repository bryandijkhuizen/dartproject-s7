import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;
  final TimeOfDay? initialTime;

  const TimePicker({super.key, required this.onTimeSelected, this.initialTime});

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime ?? TimeOfDay.now();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('HH:mm');
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Row(
            children: [
              Text(formatTimeOfDay(selectedTime)),
              const SizedBox(width: 8),
              const Icon(Icons.edit, size: 16),
            ],
          ),
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: selectedTime,
            );
            if (picked != null && picked != selectedTime) {
              setState(() {
                selectedTime = picked;
              });
              widget.onTimeSelected(picked);
            }
          },
        ),
      ],
    );
  }
}
