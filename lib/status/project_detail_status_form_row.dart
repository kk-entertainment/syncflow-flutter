import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/status/status.dart';
import 'package:syncflow/task/task.dart';

class ProjectDetailStatusFormRow extends StatefulWidget {
  const ProjectDetailStatusFormRow({super.key, required this.color, required this.label, required this.tasks});

  final String color;
  final String label;
  final List<Task> tasks;

  @override
  State<ProjectDetailStatusFormRow> createState() => _ProjectDetailStatusFormRowState();
}

class _ProjectDetailStatusFormRowState extends State<ProjectDetailStatusFormRow> {
  bool isExpanding = true;

  void onTap() {
    setState(() {
      isExpanding = !isExpanding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTap();
        },
        child: CupertinoFormRow(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          prefix: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              CupertinoIcons.circle,
              color: HexColor.fromHex(widget.color),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(widget.label)
          ]),
          helper: isExpanding
              ? Container(
                  color: CupertinoColors.systemGrey.withOpacity(0.1),
                  margin: EdgeInsets.only(top: widget.tasks.isNotEmpty ? 12 : 0),
                  child: Column(
                    children: widget.tasks.map((task) {
                      return CupertinoFormRow(
                        key: ValueKey(task.id),
                        prefix: Text(task.name),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(width: 5),
                            Icon(
                              CupertinoIcons.chevron_right,
                              color: CupertinoColors.systemGrey,
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("${widget.tasks.length}"),
              const SizedBox(width: 5),
              Icon(isExpanding ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_right)
            ],
          ),
        ));
  }
}
