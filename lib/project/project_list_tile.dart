import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:syncflow/image/image.dart';

class ProjectListTile extends StatelessWidget {
  const ProjectListTile(
      {super.key, required this.id, required this.name, required this.description, required this.imageBase64});

  final String id;
  final String name;
  final String description;
  final String imageBase64;

  void onTap(BuildContext context) {
    context.go("/projects/$id");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTap(context);
        },
        child: CupertinoFormRow(
          prefix: Expanded(
              child: Row(
            children: <Widget>[
              SizedBox(
                width: 52,
                height: 52,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(fit: BoxFit.cover, image: imageFromBase64String(imageBase64)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 15, color: CupertinoColors.systemGrey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ))
            ],
          )),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(CupertinoIcons.forward),
            ],
          ),
        ));
  }
}
