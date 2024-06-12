import 'package:darts_application/features/club_management/club_management_controller.dart';
import 'package:darts_application/models/club.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CurrentClubManagerView extends StatefulWidget {
  const CurrentClubManagerView({Key? key}) : super(key: key);

  @override
  _CurrentClubManagerViewState createState() => _CurrentClubManagerViewState();
}

class _CurrentClubManagerViewState extends State<CurrentClubManagerView> {
  late ClubManagementController controller;

  void loadData() {
    controller = ClubManagementController(Supabase.instance.client);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    loadData();
    return FutureBuilder(
      future: controller.clubs,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('something went wrong');
        }

        if (snapshot.hasData) {
          List<Club> models = snapshot.data!;

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
                DataColumn(label: Text("")),
              ],
              rows: [
                for (Club model in models)
                  DataRow(
                    color: WidgetStateProperty.all(Colors.grey.shade300),
                    cells: [
                      DataCell(
                        Text(model.name,
                            style: const TextStyle(color: Colors.black)),
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
                                  "Are you sure you want to archive this club?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  FilledButton(
                                    child: const Text("Confirm"),
                                    onPressed: () async {
                                      await Supabase.instance.client.rpc(
                                          "archive_club",
                                          params: {
                                            'current_club_id': model.id
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
                        child: const Text('Archive'),
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
