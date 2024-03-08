import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/status/status.dart';

class StatusListTile extends StatelessWidget {
  const StatusListTile(
      {super.key, required this.id, required this.color, required this.label, required this.isEditing});

  final String id;
  final String color;
  final String label;
  final bool isEditing;

  void onTap(BuildContext context) {
    if (isEditing) {
      final newProjectStatusList = statusBloc.newProjectStatusList;
      final newStatusList = newProjectStatusList.where((status) => status.id != id).toList();

      statusBloc.setNewProjectStatusList(newStatusList);
    } else {
      context.go("/projects/new/status/$id");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: isEditing
          ? const Icon(
              CupertinoIcons.minus_circle_fill,
              color: CupertinoColors.systemRed,
            )
          : null,
      title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Icon(
          CupertinoIcons.circle,
          color: HexColor.fromHex(color),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(label)
      ]),
      trailing: !isEditing ? const CupertinoListTileChevron() : null,
      onTap: () => onTap(context),
    );
  }
}
