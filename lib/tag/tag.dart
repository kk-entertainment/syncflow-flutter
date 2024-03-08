import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncflow/color/color.dart';

class Tag {
  String id;
  String projectID;
  String color;
  String label;

  Tag(this.id, this.projectID, this.color, this.label);
}

class TagBloc {
  final _newProjectTagListStore = BehaviorSubject<List<Tag>>.seeded([]);
  final _projectDetailAddTaskSelectedTagsStore = BehaviorSubject<List<Tag>>.seeded([]);

  List<Tag> get newProjectTagList => _newProjectTagListStore.value;
  Stream<List<Tag>> get newProjectTagListStream => _newProjectTagListStore.stream;

  List<Tag> get projectDetailAddTaskSelectedTags => _projectDetailAddTaskSelectedTagsStore.value;
  Stream<List<Tag>> get projectDetailAddTaskSelectedTagsStream => _projectDetailAddTaskSelectedTagsStore.stream;

  void setNewProjectTagList(List<Tag> tagList) {
    _newProjectTagListStore.add(tagList);
  }

  void setProjectDetailAddTaskSelectedTags(List<Tag> tags) {
    _projectDetailAddTaskSelectedTagsStore.add(tags);
  }

  dispose() {
    _newProjectTagListStore.close();
    _projectDetailAddTaskSelectedTagsStore.close();
  }
}

TagBloc tagBloc = TagBloc();

class TagColor {
  String label;
  String value;

  TagColor(this.label, this.value);
}

List<TagColor> tagColorList = [
  TagColor("Red", CupertinoColors.systemRed.toHex()),
  TagColor("Orange", CupertinoColors.systemOrange.toHex()),
  TagColor("Yellow", CupertinoColors.systemYellow.toHex()),
  TagColor("Green", CupertinoColors.systemGreen.toHex()),
  TagColor("Blue", CupertinoColors.systemBlue.toHex()),
  TagColor("Indigo", CupertinoColors.systemIndigo.toHex()),
  TagColor("Purple", CupertinoColors.systemPurple.toHex()),
];
