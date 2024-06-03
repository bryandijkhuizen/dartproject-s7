import 'package:flutter/material.dart';
import '../widgets/member_card.dart';

class ClubMembersView extends StatelessWidget {
  const ClubMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        MemberCard(memberName: 'John Doe'),
        SizedBox(height: 20),
        MemberCard(memberName: 'John Doe'),
      ],
    );
  }
}
