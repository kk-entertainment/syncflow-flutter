import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/api/query.dart';
import 'package:syncflow/contributor/contributor.dart';
import 'package:syncflow/user/user.dart';
import 'package:syncflow/user/user_list_tile.dart';

class ProjectDetailAddTaskSelectAssigneesPage extends StatefulWidget {
  const ProjectDetailAddTaskSelectAssigneesPage({super.key, required this.projectID});

  final String projectID;

  @override
  State<ProjectDetailAddTaskSelectAssigneesPage> createState() => _ProjectDetailAddTaskSelectAssigneesPageState();
}

class _ProjectDetailAddTaskSelectAssigneesPageState extends State<ProjectDetailAddTaskSelectAssigneesPage> {
  List<User> assigneeUsers = [];
  List<Contributor> selectedAssignees = [];

  List<Contributor> contributorsViaAPI = [];

  @override
  void initState() {
    super.initState();

    setAssigneeUsers();

    selectedAssignees = contributorBloc.projectDetailAddTaskSelectedAssignees;
  }

  setAssigneeUsers() async {
    contributorsViaAPI = await queryContributorsViaAPI(widget.projectID);
    List<User> contributorUsers = [];

    for (final contributor in contributorsViaAPI) {
      final contributorUserID = contributor.userID;

      final userViaAPI = await queryUserViaAPI(contributorUserID);
      if (userViaAPI != null) {
        contributorUsers.add(userViaAPI);
      } else {
        contributorUsers = [];
        break;
      }
    }

    setState(() {
      assigneeUsers = contributorUsers;
    });
  }

  Future<void> onDonePressed(BuildContext context) async {
    contributorBloc.setProjectDetailAddTaskSelectedAssignees(selectedAssignees);

    context.pop();
  }

  onAssigneeTap(String assigneeUserID, UserListTileState userListTileState) {
    if (userListTileState == UserListTileState.selected) {
      setState(() {
        selectedAssignees.removeWhere((selectedAssignee) => selectedAssignee.userID == assigneeUserID);
      });
    } else {
      final assignee = contributorsViaAPI.firstWhere((contributor) => contributor.userID == assigneeUserID);

      setState(() {
        selectedAssignees.add(assignee);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Assignees"),
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
          ...(assigneeUsers.isNotEmpty
              ? [
                  CupertinoListSection.insetGrouped(
                      children: assigneeUsers.map((assigneeUser) {
                    final selectedAssigneeUserIDs =
                        selectedAssignees.map((selectedAssignee) => selectedAssignee.userID);

                    UserListTileState userListTileState = selectedAssigneeUserIDs.contains(assigneeUser.id)
                        ? UserListTileState.selected
                        : UserListTileState.unSelected;

                    return UserListTile(
                      key: ValueKey(assigneeUser.id),
                      username: assigneeUser.name,
                      email: assigneeUser.email,
                      image: assigneeUser.imageAsBase64,
                      state: userListTileState,
                      onTap: () {
                        onAssigneeTap(assigneeUser.id, userListTileState);
                      },
                    );
                  }).toList()),
                ]
              : [])
        ])));
  }
}
