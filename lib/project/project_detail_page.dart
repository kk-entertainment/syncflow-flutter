import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/api/query.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/image/image.dart';
import 'package:syncflow/project/project.dart';
import 'package:syncflow/status/project_detail_status_form_row.dart';
import 'package:syncflow/status/status.dart';
import 'package:syncflow/task/task.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({super.key, required this.id});

  final String id;

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  Project? project;
  List<Status> statusList = [];
  List<Task> tasks = [];

  StreamSubscription<Null>? updateProjectDetailStreamSubscription;

  @override
  void initState() {
    super.initState();

    initProject();

    updateProjectDetailStreamSubscription = projectBloc.updateProjectDetailStream.listen((event) async {
      await initProject();
    });
  }

  @override
  void dispose() {
    updateProjectDetailStreamSubscription?.cancel();

    super.dispose();
  }

  initProject() async {
    await setProject();
    await setStatusList();
    await setTasks();
  }

  setProject() async {
    final projectViaAPI = await queryProjectViaAPI(widget.id);

    setState(() {
      project = projectViaAPI;
    });
  }

  setStatusList() async {
    if (project == null) return;

    final projectID = project!.id;

    final statusListViaAPI = await queryStatusListViaAPI(projectID);

    setState(() {
      statusList = statusListViaAPI;
    });
  }

  setTasks() async {
    if (project == null) return;

    final projectID = project!.id;

    final tasksViaAPI = await queryTasksViaAPI(projectID);

    setState(() {
      tasks = tasksViaAPI;
    });
  }

  void onEditPressed(BuildContext context) {
    context.go("/projects/${widget.id}/edit");
  }

  void onAddTaskPressed(BuildContext context) {
    context.go("/projects/${widget.id}/tasks/new");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Details"),
          previousPageTitle: "Projects",
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Edit'),
            onPressed: () {
              onEditPressed(context);
            },
          ),
        ),
        child: SafeArea(
            child: Column(children: <Widget>[
          ...(project != null
              ? [
                  CupertinoListSection.insetGrouped(children: [
                    CupertinoListTile.notched(
                      leading: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(fit: BoxFit.cover, image: imageFromBase64String(project!.imageAsBase64)),
                        ),
                      ),
                      title: Text(project!.name),
                      subtitle: Text(project!.description),
                    ),
                    CupertinoListTile.notched(
                      title: const Text("Add Task"),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => {onAddTaskPressed(context)},
                    )
                  ])
                ]
              : []),
          ...(statusList.isNotEmpty
              ? [
                  CupertinoFormSection(
                    children: [
                      ProjectDetailStatusFormRow(
                        color: noStatusStatus.color,
                        label: noStatusStatus.label,
                        tasks: tasks.where((task) => task.statusID == "-1").toList(),
                      ),
                      ...statusList.map((status) {
                        return ProjectDetailStatusFormRow(
                            key: ValueKey(status.id),
                            color: status.color,
                            label: status.label,
                            tasks: tasks.where((task) => task.statusID == status.id).toList());
                      }),
                    ],
                  ),
                ]
              : [])
        ])));
  }
}
