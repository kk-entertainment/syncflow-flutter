import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/api/create.dart';
import 'package:syncflow/api/query.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/contributor/contributor.dart';
import 'package:syncflow/project/project.dart';
import 'package:syncflow/status/status.dart';
import 'package:syncflow/tag/tag.dart';

class ProjectDetailAddTaskPage extends StatefulWidget {
  const ProjectDetailAddTaskPage({super.key, required this.projectID});

  final String projectID;

  @override
  State<ProjectDetailAddTaskPage> createState() => _ProjectDetailAddTaskPageState();
}

class _ProjectDetailAddTaskPageState extends State<ProjectDetailAddTaskPage> {
  String initialName = "";

  late String name;

  bool isCreating = false;

  @override
  void initState() {
    super.initState();

    name = initialName;
  }

  onNameChanged(String value) {
    setState(() {
      name = value;
    });
  }

  Future<void> onDonePressed(BuildContext context) async {
    final status = statusBloc.projectDetailAddTaskStatus;
    final tags = tagBloc.projectDetailAddTaskSelectedTags;
    final assignees = contributorBloc.projectDetailAddTaskSelectedAssignees;

    final statusID = status.id == noStatusStatus.id ? "-1" : status.id;
    final tagIDs = tags.map((tag) => tag.id);

    setState(() {
      isCreating = true;
    });

    final task = await createTaskViaAPI(widget.projectID, statusID, tagIDs.toList(), name);

    if (task != null) {
      projectBloc.updateProjectDetail();

      if (mounted) {
        context.pop();
      }
    }

    setState(() {
      isCreating = false;
    });
  }

  onStatusTap(BuildContext context) {
    context.go("/projects/${widget.projectID}/tasks/new/status");
  }

  onTagsTap(BuildContext context) {
    context.go("/projects/${widget.projectID}/tasks/new/tags");
  }

  onAssigneesTap(BuildContext context) {
    context.go("/projects/${widget.projectID}/tasks/new/assignees");
  }

  @override
  Widget build(BuildContext context) {
    bool canNew = name != initialName;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Add Task"),
          previousPageTitle: "Back",
          trailing: canNew
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: isCreating
                      ? null
                      : () {
                          onDonePressed(context);
                        },
                  child: const Text('Done'),
                )
              : null,
        ),
        child: SafeArea(
            child: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 18),
          ),
          CupertinoFormSection.insetGrouped(children: [
            CupertinoTextFormFieldRow(
              prefix: const Text("Name"),
              textAlign: TextAlign.right,
              initialValue: initialName,
              onChanged: (value) {
                onNameChanged(value);
              },
            ),
          ]),
          CupertinoFormSection.insetGrouped(children: [
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  onStatusTap(context);
                },
                child: CupertinoFormRow(
                    prefix: const Text("Status"),
                    child: StreamBuilder(
                        stream: statusBloc.projectDetailAddTaskStatusStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final statusOption = snapshot.data;

                            if (statusOption != null) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    CupertinoIcons.circle,
                                    color: HexColor.fromHex(statusOption.color),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(statusOption.label),
                                  const SizedBox(width: 5),
                                  const Icon(CupertinoIcons.forward)
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }

                          return const Center(child: CupertinoActivityIndicator());
                        }))),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  onTagsTap(context);
                },
                child: CupertinoFormRow(
                    prefix: const Text("Tags"),
                    child: StreamBuilder(
                        stream: tagBloc.projectDetailAddTaskSelectedTagsStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final tagsOption = snapshot.data;

                            if (tagsOption != null) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  ...(tagsOption.isNotEmpty
                                      ? [
                                          Text("${tagsOption.length} Selected"),
                                        ]
                                      : []),
                                  const SizedBox(width: 5),
                                  const Icon(CupertinoIcons.forward)
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }

                          return const Center(child: CupertinoActivityIndicator());
                        }))),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  onAssigneesTap(context);
                },
                child: CupertinoFormRow(
                    prefix: const Text("Assignees"),
                    child: StreamBuilder(
                        stream: contributorBloc.projectDetailAddTaskSelectedAssigneesStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final contributorsOption = snapshot.data;

                            if (contributorsOption != null) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  ...(contributorsOption.isNotEmpty
                                      ? [
                                          Text("${contributorsOption.length} Assigned"),
                                        ]
                                      : []),
                                  const SizedBox(width: 5),
                                  const Icon(CupertinoIcons.forward)
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }

                          return const Center(child: CupertinoActivityIndicator());
                        }))),
          ])
        ])));
  }
}
