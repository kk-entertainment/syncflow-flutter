import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/api/query.dart';
import 'package:syncflow/tag/tag.dart';
import 'package:syncflow/tag/tag_list_tile.dart';

class ProjectDetailAddTaskSelectTagsPage extends StatefulWidget {
  const ProjectDetailAddTaskSelectTagsPage({super.key, required this.projectID});

  final String projectID;

  @override
  State<ProjectDetailAddTaskSelectTagsPage> createState() => _ProjectDetailAddTaskSelectTagsPageState();
}

class _ProjectDetailAddTaskSelectTagsPageState extends State<ProjectDetailAddTaskSelectTagsPage> {
  List<Tag> tags = [];
  List<Tag> selectedTags = [];

  @override
  void initState() {
    super.initState();

    setTags();

    selectedTags = tagBloc.projectDetailAddTaskSelectedTags;
  }

  setTags() async {
    final tagsViaAPI = await queryTagsViaAPI(widget.projectID);

    setState(() {
      tags = tagsViaAPI;
    });
  }

  Future<void> onDonePressed(BuildContext context) async {
    tagBloc.setProjectDetailAddTaskSelectedTags(selectedTags);

    context.pop();
  }

  onTagTap(Tag tag, TagListTileState tagListTileState) {
    if (tagListTileState == TagListTileState.selected) {
      setState(() {
        selectedTags.removeWhere((selectedTag) => selectedTag.id == tag.id);
      });
    } else {
      setState(() {
        selectedTags.add(tag);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Tags"),
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
          ...(tags.isNotEmpty
              ? [
                  CupertinoListSection.insetGrouped(
                      children: tags.map((tag) {
                    final selectedTagIDs = selectedTags.map((selectedTag) => selectedTag.id);

                    TagListTileState state =
                        selectedTagIDs.contains(tag.id) ? TagListTileState.selected : TagListTileState.unSelected;

                    return TagListTile(
                      key: ValueKey(tag.id),
                      id: tag.id,
                      color: tag.color,
                      label: tag.label,
                      state: state,
                      onTap: () {
                        onTagTap(tag, state);
                      },
                    );
                  }).toList()),
                ]
              : [])
        ])));
  }
}
