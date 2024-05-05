import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  const DatePicker({super.key, required this.onDateSelected});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(2024),
          lastDate: DateTime(2034),
        ).then((value) {
          if (value != null) {
            setState(() {
              now = value;
            });
            widget.onDateSelected(now);
          }
        });
      },
      child: Text('${now.day}/${now.month}/${now.year}'),
    );
  }
}