import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:darts_application/features/club_page/stores/club_members_store.dart';

class ClubMembersView extends StatefulWidget {
  const ClubMembersView({super.key});

  @override
  _ClubMembersViewState createState() => _ClubMembersViewState();
}

class _ClubMembersViewState extends State<ClubMembersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clubMembersStore = Provider.of<ClubMembersStore>(context, listen: false);
      clubMembersStore.fetchMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final clubMembersStore = Provider.of<ClubMembersStore>(context);

    return Column(
      children: [
        Observer(
          builder: (_) {
            if (clubMembersStore.isLoading) {
              return const CircularProgressIndicator();
            }
            if (clubMembersStore.members.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("No members found",
                    style: Theme.of(context).textTheme.bodyMedium),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: clubMembersStore.members.length,
              itemBuilder: (_, index) {
                final member = clubMembersStore.members[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member.avatarUrl),
                  ),
                  title: Text(member.fullName),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
