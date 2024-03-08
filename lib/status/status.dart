import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncflow/color/color.dart';
import 'package:syncflow/uuid/uuid.dart';

class Status {
  String id;
  String projectID;
  String color;
  String label;

  Status(this.id, this.projectID, this.color, this.label);
}

class StatusBloc {
  final _newProjectStatusListStore = BehaviorSubject<List<Status>>.seeded([]);
  final _projectDetailAddTaskStatusStore = BehaviorSubject<Status>.seeded(noStatusStatus);

  List<Status> get newProjectStatusList => _newProjectStatusListStore.value;
  Stream<List<Status>> get newProjectStatusListStream => _newProjectStatusListStore.stream;

  Status get projectDetailAddTaskStatus => _projectDetailAddTaskStatusStore.value;
  Stream<Status> get projectDetailAddTaskStatusStream => _projectDetailAddTaskStatusStore.stream;

  void setNewProjectStatusList(List<Status> statusList) {
    _newProjectStatusListStore.add(statusList);
  }

  void setProjectDetailAddTaskStatus(Status status) {
    _projectDetailAddTaskStatusStore.add(status);
  }

  dispose() {
    _newProjectStatusListStore.close();
    _projectDetailAddTaskStatusStore.close();
  }
}

StatusBloc statusBloc = StatusBloc();

class StatusColor {
  String label;
  String value;

  StatusColor(this.label, this.value);
}

List<StatusColor> statusColorList = [
  StatusColor("Red", CupertinoColors.systemRed.toHex()),
  StatusColor("Orange", CupertinoColors.systemOrange.toHex()),
  StatusColor("Yellow", CupertinoColors.systemYellow.toHex()),
  StatusColor("Green", CupertinoColors.systemGreen.toHex()),
  StatusColor("Blue", CupertinoColors.systemBlue.toHex()),
  StatusColor("Indigo", CupertinoColors.systemIndigo.toHex()),
  StatusColor("Purple", CupertinoColors.systemPurple.toHex()),
];

Status noStatusStatus = Status(generateUniqueID(), generateUniqueID(), CupertinoColors.systemGrey.toHex(), "No Status");
