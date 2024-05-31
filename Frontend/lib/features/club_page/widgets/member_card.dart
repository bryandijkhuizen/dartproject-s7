import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final String memberName;

  const MemberCard({super.key, required this.memberName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(memberName),
      ),
    );
  }
}
