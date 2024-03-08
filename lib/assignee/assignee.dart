import 'package:rxdart/rxdart.dart';

class Assignee {
  String id;
  String taskID;
  String userID;

  Assignee(this.id, this.taskID, this.userID);
}

class AssigneeBloc {
  final _projectAssigneesStore = BehaviorSubject<List<Assignee>>.seeded([]);

  List<Assignee> get projectAssignees => _projectAssigneesStore.value;
  Stream<List<Assignee>> get projectAssigneesStream => _projectAssigneesStore.stream;

  void setProjectAssignees(List<Assignee> assignees) {
    _projectAssigneesStore.add(assignees);
  }

  dispose() {
    _projectAssigneesStore.close();
  }
}

AssigneeBloc assigneeBloc = AssigneeBloc();
