import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/status/status.dart';
import 'package:syncflow/status/status_list_tile.dart';

class NewProjectStatusPage extends StatefulWidget {
  const NewProjectStatusPage({super.key});

  @override
  State<NewProjectStatusPage> createState() => _NewProjectStatusPageState();
}

class _NewProjectStatusPageState extends State<NewProjectStatusPage> {
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
  }

  void onEditPressed() {
    setState(() {
      isEditing = true;
    });
  }

  void onDonePressed() {
    setState(() {
      isEditing = false;
    });
  }

  void onAddStatusListTileTap(BuildContext context) {
    context.go("/projects/new/status/new");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Status"),
          previousPageTitle: "Back",
          trailing: isEditing
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Done'),
                  onPressed: () {
                    onDonePressed();
                  },
                )
              : CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Edit'),
                  onPressed: () {
                    onEditPressed();
                  },
                ),
        ),
        child: SafeArea(
            child: Column(children: [
          StreamBuilder(
              stream: statusBloc.newProjectStatusListStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final statusListOption = snapshot.data;

                  if (statusListOption != null && statusListOption.isNotEmpty) {
                    return CupertinoListSection.insetGrouped(
                      children: snapshot.data!.map((status) {
                        return StatusListTile(
                          key: ValueKey(status.id),
                          id: status.id,
                          color: status.color,
                          label: status.label,
                          isEditing: isEditing,
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                }

                return const Center(child: CupertinoActivityIndicator());
              }),
          ...(!isEditing
              ? [
                  CupertinoListSection.insetGrouped(
                    children: <CupertinoListTile>[
                      CupertinoListTile.notched(
                          title: const Text('Add Status'),
                          padding: const EdgeInsets.only(left: 20, right: 14),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () => {onAddStatusListTileTap(context)}),
                    ],
                  ),
                ]
              : [])
        ])));
  }
}
