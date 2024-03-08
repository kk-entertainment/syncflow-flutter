import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/api/query.dart';
import 'package:syncflow/project/project.dart';
import 'package:syncflow/project/project_list_tile.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  void initState() {
    super.initState();

    setProjects();
  }

  setProjects() async {
    final projectsViaAPI = await queryProjectsViaAPI();

    projectBloc.setProjects(projectsViaAPI);
  }

  void onAddProjectIconButtonPressed(BuildContext context) {
    context.go("/projects/new");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: const Text("Projects"),
            trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => onAddProjectIconButtonPressed(context),
                child: const Icon(CupertinoIcons.add)),
          ),
          SliverFillRemaining(
              child: Container(
            margin: const EdgeInsets.only(top: 18, bottom: 18),
            child: Column(
              children: <Widget>[
                StreamBuilder(
                    stream: projectBloc.projectsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final projectsOption = snapshot.data;

                        List<Project> projects = projectsOption != null
                            ? projectsOption.where((project) => project.success == "1").toList()
                            : [];

                        if (projects.isNotEmpty) {
                          return CupertinoListSection.insetGrouped(
                            children: projects.map((project) {
                              return ProjectListTile(
                                  key: ValueKey(project.id),
                                  id: project.id,
                                  name: project.name,
                                  description: project.description,
                                  imageBase64: project.imageAsBase64);
                            }).toList(),
                          );
                        } else {
                          return Container();
                        }
                      }

                      return const Center(child: CupertinoActivityIndicator());
                    })
              ],
            ),
          ))
        ],
      ),
    );
  }
}
