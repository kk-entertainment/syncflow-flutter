import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/api/query.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/status/status.dart';

class ProjectDetailAddTaskSelectStatusPage extends StatefulWidget {
  const ProjectDetailAddTaskSelectStatusPage({super.key, required this.projectID});

  final String projectID;

  @override
  State<ProjectDetailAddTaskSelectStatusPage> createState() => _ProjectDetailAddTaskSelectStatusPageState();
}

class _ProjectDetailAddTaskSelectStatusPageState extends State<ProjectDetailAddTaskSelectStatusPage> {
  List<Status> statusList = [noStatusStatus];
  Status? selectedStatus;

  @override
  void initState() {
    super.initState();

    setStatusList();

    selectedStatus = statusBloc.projectDetailAddTaskStatus;
  }

  setStatusList() async {
    final statusListViaAPI = await queryStatusListViaAPI(widget.projectID);

    setState(() {
      statusList.addAll(statusListViaAPI);
    });
  }

  Future<void> onDonePressed(BuildContext context) async {
    if (selectedStatus != null) {
      statusBloc.setProjectDetailAddTaskStatus(selectedStatus!);
    }

    context.pop();
  }

  onStatusTap(Status status) {
    setState(() {
      selectedStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Status"),
          previousPageTitle: "Back",
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              onDonePressed(context);
            },
            child: const Text('Done'),
          ),
        ),
        child: SafeArea(
            child: Column(children: <Widget>[
          CupertinoFormSection.insetGrouped(
              children: statusList.map((status) {
            bool isSelected = selectedStatus!.id == status.id;

            return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  onStatusTap(status);
                },
                child: CupertinoFormRow(
                  prefix: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      CupertinoIcons.circle,
                      color: HexColor.fromHex(status.color),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(status.label)
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Visibility.maintain(visible: isSelected, child: const Icon(CupertinoIcons.check_mark))
                    ],
                  ),
                ));
          }).toList()),
        ])));
  }
}
