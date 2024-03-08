import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/status/status.dart';

class StatusDetailPage extends StatefulWidget {
  const StatusDetailPage({super.key, required this.statusID});

  final String statusID;

  @override
  State<StatusDetailPage> createState() => _StatusDetailPageState();
}

class _StatusDetailPageState extends State<StatusDetailPage> {
  late Status initialStatus;
  late Status status;

  @override
  void initState() {
    super.initState();

    final newProjectStatusList = statusBloc.newProjectStatusList;

    initialStatus = newProjectStatusList.firstWhere((status) => status.id == widget.statusID);
    status = Status(initialStatus.id, initialStatus.projectID, initialStatus.color, initialStatus.label);
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
    initialStatus.color = status.color;
    initialStatus.label = status.label;

    statusBloc.setNewProjectStatusList(statusBloc.newProjectStatusList);

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(initialStatus.label),
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
