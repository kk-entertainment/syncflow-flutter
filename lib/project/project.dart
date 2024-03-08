import 'package:rxdart/rxdart.dart';

const defaultProjectImagePath = "assets/default_project.png";

class Project {
  String id;
  String name;
  String description;
  String ownerUserID;
  String imageAsBase64;
  String success;

  Project(this.id, this.name, this.description, this.ownerUserID, this.imageAsBase64, this.success);
}

class ProjectBloc {
  final _projectsStore = BehaviorSubject<List<Project>>.seeded([]);
  final _updateProjectDetailEvent = PublishSubject<Null>();

  List<Project> get projects => _projectsStore.value;
  Stream<List<Project>> get projectsStream => _projectsStore.stream;

  Stream<Null> get updateProjectDetailStream => _updateProjectDetailEvent.stream;

  void setProjects(List<Project> projects) {
    _projectsStore.add(projects);
  }

  void updateProjectDetail() {
    _updateProjectDetailEvent.add(null);
  }

  dispose() {
    _projectsStore.close();
    _updateProjectDetailEvent.close();
  }
}

ProjectBloc projectBloc = ProjectBloc();
