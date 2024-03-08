import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/status/status.dart';
import 'package:syncflow/uuid/uuid.dart';

class AddStatusPage extends StatefulWidget {
  const AddStatusPage({super.key});

  @override
  State<AddStatusPage> createState() => _AddStatusPageState();
}

class _AddStatusPageState extends State<AddStatusPage> {
  late Status status;

  @override
  void initState() {
    super.initState();

    status = Status(generateUniqueID(), generateUniqueID(), CupertinoColors.systemPurple.toHex(), "");
  }

  bool getIsSelected(String value) {
    return status.color == value;
  }

  void onColorTap(String value) {
    setState(() {
      status.color = value;
    });
  }

  void onLabelChanged(String value) {
    setState(() {
      status.label = value;
    });
  }

  void onDone(BuildContext context) {
    final newProjectStatusList = statusBloc.newProjectStatusList;
    final newStatusList = [...newProjectStatusList, status];

    statusBloc.setNewProjectStatusList(newStatusList);

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Add Status"),
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
              ...statusColorList.map((statusColor) {
                final isSelected = getIsSelected(statusColor.value);

                return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onColorTap(statusColor.value);
                    },
                    child: CupertinoFormRow(
                      prefix: Text(statusColor.label),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.circle_fill,
                            color: HexColor.fromHex(statusColor.value),
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
              initialValue: status.label,
              onChanged: (value) {
                onLabelChanged(value);
              },
            )
          ])
        ])));
  }
}
