import 'package:flutter/cupertino.dart';
import 'package:syncflow/image/image.dart';

enum UserListTileState { selected, unSelected, add, remove }

class UserListTile extends StatelessWidget {
  const UserListTile(
      {super.key, required this.username, required this.email, required this.image, this.state, this.onTap});

  final String username;
  final String email;
  final String image;
  final UserListTileState? state;
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
      leading: state == UserListTileState.selected
          ? const Icon(
              CupertinoIcons.check_mark_circled_solid,
              color: CupertinoColors.systemBlue,
            )
          : state == UserListTileState.unSelected
              ? const Icon(
                  CupertinoIcons.circle,
                  color: CupertinoColors.systemGrey,
                )
              : state == UserListTileState.add
                  ? const Icon(
                      CupertinoIcons.plus_circle_fill,
                      color: CupertinoColors.systemGreen,
                    )
                  : state == UserListTileState.remove
                      ? const Icon(
                          CupertinoIcons.minus_circle_fill,
                          color: CupertinoColors.systemRed,
                        )
                      : null,
      title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          width: 44,
          height: 44,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image(fit: BoxFit.cover, image: imageFromBase64String(image)),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: const TextStyle(fontSize: 15, color: CupertinoColors.systemGrey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ))
      ]),
      onTap: () {
        _onTap();
      },
    );
  }
}
