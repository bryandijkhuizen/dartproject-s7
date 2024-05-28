import 'package:flutter/material.dart';

class DropdownSelection extends StatelessWidget {
  final List<int> setIds;
  final Map<int, List<Map<String, dynamic>>> legDataBySet;
  final int currentSet;
  final int currentLeg;
  final ValueChanged<int?> onSetChanged;
  final ValueChanged<int?> onLegChanged;

  const DropdownSelection({
    super.key,
    required this.setIds,
    required this.legDataBySet,
    required this.currentSet,
    required this.currentLeg,
    required this.onSetChanged,
    required this.onLegChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Set: ',
          style: TextStyle(color: Colors.white),
        ),
        DropdownButton<int>(
          value: currentSet,
          items: setIds.map((id) {
            int index = setIds.indexOf(id);
            return DropdownMenuItem<int>(
              value: index,
              child: Text(
                'Set ${index + 1}',
              ),
            );
          }).toList(),
          onChanged: onSetChanged,
          dropdownColor: Colors.black, // Ensure dropdown background is white
        ),
        const SizedBox(width: 16),
        const Text(
          'Leg: ',
        ),
        DropdownButton<int>(
          value: currentLeg,
          items: legDataBySet[setIds[currentSet]]!.map((leg) {
            int index = legDataBySet[setIds[currentSet]]!.indexOf(leg);
            return DropdownMenuItem<int>(
              value: index,
              child: Text(
                'Leg ${index + 1}',
              ),
            );
          }).toList(),
          onChanged: onLegChanged,
          dropdownColor: Colors.black, // Ensure dropdown background is white
        ),
      ],
    );
  }
}
