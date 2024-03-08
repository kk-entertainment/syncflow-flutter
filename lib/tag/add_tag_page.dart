import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/tag/tag.dart';
import 'package:syncflow/uuid/uuid.dart';

class AddTagPage extends StatefulWidget {
  const AddTagPage({super.key});

  @override
  State<AddTagPage> createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  late Tag tag;

  @override
  void initState() {
    super.initState();

    tag = Tag(generateUniqueID(), generateUniqueID(), CupertinoColors.systemPurple.toHex(), "");
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
    final newProjectTagList = tagBloc.newProjectTagList;
    final newTagList = [...newProjectTagList, tag];

    tagBloc.setNewProjectTagList(newTagList);

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Add Tag"),
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
