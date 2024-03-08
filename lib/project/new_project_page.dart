import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/api/create.dart';
import 'package:syncflow/api/query.dart';
import 'package:syncflow/api/update.dart';
import 'package:syncflow/contributor/contributor.dart';
import 'package:syncflow/project/project.dart';
import 'package:syncflow/status/status.dart';
import 'package:syncflow/tag/tag.dart';
import 'package:syncflow/uuid/uuid.dart';

class NewProjectPage extends StatefulWidget {
  const NewProjectPage({super.key});

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  String initialName = "";
  String initialDescription = "";

  late String name;
  late String description;

  bool isCreating = false;

  @override
  void initState() {
    super.initState();

    name = initialName;
    description = initialDescription;

    Contributor ownerContributor = getOwnerContributor("1", generateUniqueID());

    contributorBloc.setNewProjectContributors([ownerContributor]);
    statusBloc.setNewProjectStatusList([]);
    tagBloc.setNewProjectTagList([]);
  }

  onNameChanged(String value) {
    setState(() {
      name = value;
    });
  }

  onDescriptionChanged(String value) {
    setState(() {
      description = value;
    });
  }

  Future<Project?> createProject(
      String ownerUserID, List<Contributor> contributors, List<Status> statusList, List<Tag> tags) async {
    bool isFail = false;

    final project = await createProjectViaAPI(name, description, ownerUserID, "");

    if (project != null) {
      final projectID = project.id;

      for (final contributor in contributors) {
        final contributorViaAPI = await createContributorViaAPI(projectID, contributor.userID);

        if (contributorViaAPI == null) {
          isFail = true;
          break;
        }
      }
      for (final status in statusList) {
        final statusViaAPI = await createStatusViaAPI(projectID, status.color, status.label);

        if (statusViaAPI == null) {
          isFail = true;
          break;
        }
      }
      for (final tag in tags) {
        final tagViaAPI = await createTagViaAPI(projectID, tag.color, tag.label);

        if (tagViaAPI == null) {
          isFail = true;
          break;
        }
      }

      bool updated = await updateProjectViaAPI(projectID, success: "1");
      if (!updated) {
        isFail = true;
      }
    }

    if (isFail) {
      return await createProject(ownerUserID, contributors, statusList, tags);
    } else {
      return project;
    }
  }

  Future<void> onDonePressed(BuildContext context) async {
    final contributors = contributorBloc.newProjectContributors;
    final statusList = statusBloc.newProjectStatusList;
    final tags = tagBloc.newProjectTagList;

    final ownerContributor = contributors.firstWhere((contributor) => contributor.isOwner);
    final ownerUserID = ownerContributor.userID;

    setState(() {
      isCreating = true;
    });

    final project = await createProject(ownerUserID, contributors, statusList, tags);

    if (project != null) {
      final projectID = project.id;

      final projectsViaAPI = await queryProjectsViaAPI();
      projectBloc.setProjects(projectsViaAPI);

      if (mounted) {
        context.go("/projects/$projectID");
      }
    }

    setState(() {
      isCreating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool canNew = name != initialName;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("New Project"),
          previousPageTitle: "Projects",
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
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 18, bottom: 18),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(108),
                child: const Image(
                    width: 108, height: 108, fit: BoxFit.cover, image: AssetImage(defaultProjectImagePath))),
          ),
          CupertinoFormSection.insetGrouped(children: <CupertinoTextFormFieldRow>[
            CupertinoTextFormFieldRow(
              prefix: const Text("Name"),
              textAlign: TextAlign.right,
              initialValue: initialName,
              onChanged: (value) {
                onNameChanged(value);
              },
            ),
            CupertinoTextFormFieldRow(
              prefix: const Text("Description"),
              textAlign: TextAlign.right,
              initialValue: initialDescription,
              onChanged: (value) {
                onDescriptionChanged(value);
              },
            )
          ]),
          CupertinoListSection.insetGrouped(
            children: <CupertinoListTile>[
              CupertinoListTile.notched(
                  title: const Text('Contributors'),
                  padding: const EdgeInsets.only(left: 20, right: 14),
                  additionalInfo: StreamBuilder(
                      stream: contributorBloc.newProjectContributorsStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final contributorsOption = snapshot.data;

                          if (contributorsOption != null) {
                            return Text("${contributorsOption.length}");
                          } else {
                            return const Text("");
                          }
                        }

                        return const Text("");
                      }),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => {context.go("/projects/new/contributors")}),
              CupertinoListTile.notched(
                  title: const Text('Status'),
                  padding: const EdgeInsets.only(left: 20, right: 14),
                  additionalInfo: StreamBuilder(
                      stream: statusBloc.newProjectStatusListStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final statusListOption = snapshot.data;

                          if (statusListOption != null) {
                            return Text("${statusListOption.length}");
                          } else {
                            return const Text("");
                          }
                        }

                        return const Text("");
                      }),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => {context.go("/projects/new/status")}),
              CupertinoListTile.notched(
                  title: const Text('Tags'),
                  padding: const EdgeInsets.only(left: 20, right: 14),
                  additionalInfo: StreamBuilder(
                      stream: tagBloc.newProjectTagListStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final tagListOption = snapshot.data;

                          if (tagListOption != null) {
                            return Text("${tagListOption.length}");
                          } else {
                            return const Text("");
                          }
                        }

                        return const Text("");
                      }),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => {context.go("/projects/new/tags")}),
            ],
          )
        ])));
  }
}
