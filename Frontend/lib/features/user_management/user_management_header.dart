import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserManagementHeader extends StatelessWidget {
  const UserManagementHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Select a user"),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name"),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Role"),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a search term',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FilledButton(
                onPressed: () {},
                child: const Text("Search"),
              ),
            )
          ],
        ),
      ],
    );
  }
}
