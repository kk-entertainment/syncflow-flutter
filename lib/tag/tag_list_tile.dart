import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/tag/tag.dart';

enum TagListTileState { selected, unSelected, remove }

class TagListTile extends StatelessWidget {
  const TagListTile({super.key, required this.id, required this.color, required this.label, this.state, this.onTap});

  final String id;
  final String color;
  final String label;
  final TagListTileState? state;
  final VoidCallback? onTap;

  void _onTap() {
    if (onTap != null) {
      onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: state == TagListTileState.selected
          ? const Icon(
              CupertinoIcons.check_mark_circled_solid,
              color: CupertinoColors.systemBlue,
            )
          : state == TagListTileState.unSelected
              ? const Icon(
                  CupertinoIcons.circle,
                  color: CupertinoColors.systemGrey,
                )
              : state == TagListTileState.remove
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
      trailing: state == null ? const CupertinoListTileChevron() : null,
      onTap: () => _onTap(),
    );
  }
}
