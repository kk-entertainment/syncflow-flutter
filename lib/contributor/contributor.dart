import 'package:rxdart/rxdart.dart';

class Contributor {
  String id;
  String projectID;
  String userID;
  bool isOwner;

  Contributor(this.id, this.projectID, this.userID, this.isOwner);
}

class ContributorBloc {
  final _newProjectContributorsStore = BehaviorSubject<List<Contributor>>.seeded([]);
  final _projectDetailAddTaskSelectedAssigneesStore = BehaviorSubject<List<Contributor>>.seeded([]);

  List<Contributor> get newProjectContributors => _newProjectContributorsStore.value;
  Stream<List<Contributor>> get newProjectContributorsStream => _newProjectContributorsStore.stream;

  List<Contributor> get projectDetailAddTaskSelectedAssignees => _projectDetailAddTaskSelectedAssigneesStore.value;
  Stream<List<Contributor>> get projectDetailAddTaskSelectedAssigneesStream =>
      _projectDetailAddTaskSelectedAssigneesStore.stream;

  void setNewProjectContributors(List<Contributor> contributors) {
    _newProjectContributorsStore.add(contributors);
  }

  void setProjectDetailAddTaskSelectedAssignees(List<Contributor> assignees) {
    _projectDetailAddTaskSelectedAssigneesStore.add(assignees);
  }

  dispose() {
    _newProjectContributorsStore.close();
    _projectDetailAddTaskSelectedAssigneesStore.close();
  }
}

ContributorBloc contributorBloc = ContributorBloc();

Contributor getOwnerContributor(String id, String projectID) {
  final contributor = Contributor(id, projectID, "1", true);

  return contributor;
}
