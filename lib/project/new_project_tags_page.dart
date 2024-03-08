import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/tag/tag.dart';
import 'package:syncflow/tag/tag_list_tile.dart';

class NewProjectTagsPage extends StatefulWidget {
  const NewProjectTagsPage({super.key});

  @override
  State<NewProjectTagsPage> createState() => _NewProjectTagsPageState();
}

class _NewProjectTagsPageState extends State<NewProjectTagsPage> {
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

  void onTagTap(BuildContext context, String tagID) {
    if (isEditing) {
      final newProjectTagList = tagBloc.newProjectTagList;
      final newTagList = newProjectTagList.where((tag) => tag.id != tagID).toList();

      tagBloc.setNewProjectTagList(newTagList);
    } else {
      context.go("/projects/new/tags/$tagID");
    }
  }

  void onAddTagListTileTap(BuildContext context) {
    context.go("/projects/new/tags/new");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Tag"),
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
              stream: tagBloc.newProjectTagListStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tagListOption = snapshot.data;

                  if (tagListOption != null && tagListOption.isNotEmpty) {
                    return CupertinoListSection.insetGrouped(
                      children: snapshot.data!.map((tag) {
                        TagListTileState? state = isEditing ? TagListTileState.remove : null;

                        return TagListTile(
                          key: ValueKey(tag.id),
                          id: tag.id,
                          color: tag.color,
                          label: tag.label,
                          state: state,
                          onTap: () {
                            onTagTap(context, tag.id);
                          },
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
                          title: const Text('Add Tag'),
                          padding: const EdgeInsets.only(left: 20, right: 14),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () => {onAddTagListTileTap(context)}),
                    ],
                  ),
                ]
              : [])
        ])));
  }
}
