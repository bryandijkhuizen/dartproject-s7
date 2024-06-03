import 'package:darts_application/features/club_management/club_management_controller.dart';
import 'package:darts_application/models/club_approval.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewClubManagerView extends StatefulWidget {
  const NewClubManagerView({Key? key}) : super(key: key);

  @override
  _NewClubManagerViewState createState() => _NewClubManagerViewState();
}

class _NewClubManagerViewState extends State<NewClubManagerView> {
  late ClubManagementController controller;

  void loadData() {
    controller = ClubManagementController(Supabase.instance.client);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    loadData();
    return FutureBuilder(
      future: controller.newClubs,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('something went wrong');
        }

        if (snapshot.hasData) {
          List<ClubApproval> models = snapshot.data!;

          return Stack(children: [
            DataTable(
              headingRowColor:
                  WidgetStateProperty.all(theme.colorScheme.primary),
              headingTextStyle: const TextStyle(color: Colors.white),
              columnSpacing: 10,
              columns: const [
                DataColumn(
                  label: Text('Club name'),
                ),
                DataColumn(
                  label: Text('Email'),
                ),
                DataColumn(
                  label: Text('Note'),
                ),
                DataColumn(label: Text("")),
                DataColumn(label: Text("")),
              ],
              rows: [
                for (ClubApproval model in models)
                  DataRow(
                    color: WidgetStateProperty.all(Colors.grey.shade300),
                    cells: [
                      DataCell(
                        Text(model.name,
                            style: const TextStyle(color: Colors.black)),
                      ),
                      DataCell(
                        Text(model.email,
                            style: const TextStyle(color: Colors.black)),
                      ),
                      DataCell(
                        InkWell(
                          onHover: (value) {},
                          child: Container(
                            width: 500,
                            child: Tooltip(
                              
                              message: model.note,
                              child: Text(model.note,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        FilledButton(
                          onPressed: () async {
                            await Supabase.instance.client.rpc("approve_club",
                                params: {'current_club_id': model.clubID});
                            setState(() {});
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Colors.green.shade700)),
                          child: const Text('Accept'),
                        ),
                      ),
                      DataCell(FilledButton(
                        onPressed: () async {
                          // show the AlertDialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Notice",
                                    style: TextStyle(color: Colors.black)),
                                content: const Text(
                                  "Are you sure you want to reject this club?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  FilledButton(
                                    child: const Text("Confirm"),
                                    onPressed: () async {
                                      await Supabase.instance.client
                                          .rpc("delete_club_request", params: {
                                        'current_club_id': model.clubID
                                      });
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  ),
                                  FilledButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Reject'),
                      )),
                    ],
                  ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(
                  Icons.refresh,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ]);
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
