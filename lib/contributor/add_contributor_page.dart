import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/api/query.dart';
import 'package:syncflow/contributor/contributor.dart';
import 'package:syncflow/user/user.dart';
import 'package:syncflow/user/user_list_tile.dart';
import 'package:syncflow/uuid/uuid.dart';

class AddContributorPage extends StatefulWidget {
  const AddContributorPage({super.key});

  @override
  State<AddContributorPage> createState() => _AddContributorPageState();
}

class _AddContributorPageState extends State<AddContributorPage> {
  List<User> users = [];
  List<String> addingUserIDs = [];

  @override
  void initState() {
    super.initState();

    setUsers();
  }

  setUsers() async {
    final usersViaAPI = await queryUsersViaAPI();

    setState(() {
      users = usersViaAPI;
    });
  }

  void onDone(BuildContext context) {
    final addingContributors =
        addingUserIDs.map((userID) => Contributor(generateUniqueID(), generateUniqueID(), userID, false));

    final newProjectContributors = contributorBloc.newProjectContributors;

    List<Contributor> newContributors = [...newProjectContributors, ...addingContributors];

    contributorBloc.setNewProjectContributors(newContributors);

    context.pop();
  }

  void onUserListTileTap(String userID, UserListTileState userListTileState) {
    if (userListTileState == UserListTileState.add) {
      setState(() {
        addingUserIDs.add(userID);
      });
    } else if (userListTileState == UserListTileState.remove) {
      setState(() {
        addingUserIDs.remove(userID);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Invite Contributor"),
          previousPageTitle: "Back",
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Done'),
            onPressed: () {
              onDone(context);
            },
          ),
        ),
        child: SafeArea(
            child: Column(children: <Widget>[
          ...(users.isNotEmpty
              ? [
                  StreamBuilder(
                      stream: contributorBloc.newProjectContributorsStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final contributorsOption = snapshot.data;

                          final contributorUserIDs =
                              (contributorsOption ?? []).map((contributor) => contributor.userID);

                          return Expanded(
                              child: SingleChildScrollView(
                                  child: CupertinoListSection.insetGrouped(
                            children: users.map((user) {
                              UserListTileState userListTileState = contributorUserIDs.contains(user.id)
                                  ? UserListTileState.selected
                                  : addingUserIDs.contains(user.id)
                                      ? UserListTileState.remove
                                      : UserListTileState.add;

                              return UserListTile(
                                key: ValueKey(user.id),
                                username: user.name,
                                email: user.email,
                                image: user.imageAsBase64,
                                state: userListTileState,
                                onTap: () {
                                  onUserListTileTap(user.id, userListTileState);
                                },
                              );
                            }).toList(),
                          )));
                        }

                        return const Center(child: CupertinoActivityIndicator());
                      }),
                ]
              : [])
        ])));
  }
}
