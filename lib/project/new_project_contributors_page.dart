import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/api/query.dart';
import 'package:syncflow/contributor/contributor.dart';
import 'package:syncflow/user/user.dart';
import 'package:syncflow/user/user_list_tile.dart';

class NewProjectContributorsPage extends StatefulWidget {
  const NewProjectContributorsPage({super.key});

  @override
  State<NewProjectContributorsPage> createState() => _NewProjectContributorsPageState();
}

class _NewProjectContributorsPageState extends State<NewProjectContributorsPage> {
  User? ownerUser;
  List<User> memberUsers = [];

  bool isEditing = false;

  StreamSubscription<List<Contributor>>? newProjectContributorsStreamSubscription;

  @override
  void initState() {
    super.initState();

    List<User>? users;

    newProjectContributorsStreamSubscription =
        contributorBloc.newProjectContributorsStream.listen((contributors) async {
      users ??= await queryUsersViaAPI();

      final ownerContributor = contributors.firstWhereOrNull((contributor) => contributor.isOwner);
      final memberContributorUserIDs =
          contributors.where((contributor) => !contributor.isOwner).map((contributor) => contributor.userID).toList();

      setState(() {
        ownerUser = users?.firstWhere((user) => user.id == ownerContributor?.userID);
        memberUsers = (users?.where((user) => memberContributorUserIDs.contains(user.id)).toList()) ?? [];
      });
    });
  }

  @override
  void dispose() {
    newProjectContributorsStreamSubscription?.cancel();

    super.dispose();
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

  void onMemberUserTap(String userID) {
    if (isEditing) {
      final newProjectContributors = contributorBloc.newProjectContributors;
      newProjectContributors.removeWhere((contributor) => contributor.userID == userID);

      contributorBloc.setNewProjectContributors(newProjectContributors);
    }
  }

  void onInviteContributorsListTileTap(BuildContext context) {
    context.go("/projects/new/contributors/new");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Contributors"),
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
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          ...(ownerUser != null
              ? [
                  CupertinoListSection.insetGrouped(
                    header: const Text('Owner'),
                    children: <UserListTile>[
                      UserListTile(
                        username: ownerUser!.name,
                        email: ownerUser!.email,
                        image: ownerUser!.imageAsBase64,
                      )
                    ],
                  ),
                ]
              : []),
          ...(memberUsers.isNotEmpty
              ? [
                  CupertinoListSection.insetGrouped(
                      header: const Text('Members'),
                      children: memberUsers.map((memberUser) {
                        return UserListTile(
                          key: ValueKey(memberUser.id),
                          username: memberUser.name,
                          email: memberUser.email,
                          image: memberUser.imageAsBase64,
                          state: isEditing ? UserListTileState.remove : null,
                          onTap: () {
                            onMemberUserTap(memberUser.id);
                          },
                        );
                      }).toList())
                ]
              : []),
          ...(!isEditing
              ? [
                  CupertinoListSection.insetGrouped(
                    children: <CupertinoListTile>[
                      CupertinoListTile.notched(
                          title: const Text('Invite Contributors'),
                          padding: const EdgeInsets.only(left: 20, right: 14),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () => {onInviteContributorsListTileTap(context)}),
                    ],
                  ),
                ]
              : [])
        ]))));
  }
}
