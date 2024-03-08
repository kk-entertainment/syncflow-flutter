import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/tag/tag.dart';

class TagDetailPage extends StatefulWidget {
  const TagDetailPage({super.key, required this.tagID});

  final String tagID;

  @override
  State<TagDetailPage> createState() => _TagDetailPageState();
}

class _TagDetailPageState extends State<TagDetailPage> {
  late Tag initialTag;
  late Tag tag;

  @override
  void initState() {
    super.initState();

    final newProjectTagList = tagBloc.newProjectTagList;

    initialTag = newProjectTagList.firstWhere((tag) => tag.id == widget.tagID);
    tag = Tag(initialTag.id, initialTag.projectID, initialTag.color, initialTag.label);
  }

  bool getIsSelected(String value) {
    return tag.color == value;
  }

  void onColorTap(String value) {
    setState(() {
      tag.color = value;
    });
  }

  void onLabelChanged(String value) {
    setState(() {
      tag.label = value;
    });
  }

  void onDone(BuildContext context) {
    initialTag.color = tag.color;
    initialTag.label = tag.label;

    tagBloc.setNewProjectTagList(tagBloc.newProjectTagList);

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(initialTag.label),
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
          CupertinoFormSection.insetGrouped(
            header: const Text("Color"),
            children: [
              ...tagColorList.map((tagColor) {
                final isSelected = getIsSelected(tagColor.value);

                return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onColorTap(tagColor.value);
                    },
                    child: CupertinoFormRow(
                      prefix: Text(tagColor.label),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.circle_fill,
                            color: HexColor.fromHex(tagColor.value),
                          ),
                          const SizedBox(width: 5),
                          Visibility.maintain(visible: isSelected, child: const Icon(CupertinoIcons.check_mark))
                        ],
                      ),
                    ));
              }),
            ],
          ),
          CupertinoFormSection.insetGrouped(children: [
            CupertinoTextFormFieldRow(
              prefix: const Text("Label"),
              textAlign: TextAlign.right,
              initialValue: tag.label,
              onChanged: (value) {
                onLabelChanged(value);
              },
            )
          ])
        ])));
  }
}
