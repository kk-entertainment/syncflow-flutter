import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:syncflow/api/api.dart';
import 'package:syncflow/contributor/contributor.dart';
import 'package:syncflow/image/image.dart';
import 'package:syncflow/project/project.dart';
import 'package:syncflow/status/status.dart';
import 'package:syncflow/tag/tag.dart';
import 'package:syncflow/task/task.dart';
import 'package:syncflow/user/user.dart';

Future<List<Project>> queryProjectsViaAPI() async {
  final uri = Uri.https(apiBaseURL, "$projectAPIPath/$queryEndpoint");

  final imageAsByteData = await rootBundle.load(defaultProjectImagePath);
  final imageAsBytes = Uint8List.view(imageAsByteData.buffer);
  final imageAsBase64 = base64String(imageAsBytes);

  try {
    final response = await http.post(uri);
    final responseProjects =
        (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).cast<Map<String, dynamic>>();

    List<Project> projects = responseProjects.map((responseProject) {
      String id = responseProject['id'];
      String name = responseProject['name'];
      String description = responseProject['description'];
      String ownerUserID = responseProject['owner'];
      //   String imageAsBase64 = responseProject['img'];
      String success = responseProject['success'];

      Project project = Project(id, name, description, ownerUserID, imageAsBase64, success);
      return project;
    }).toList();

    return projects;
  } catch (error) {
    return [];
  }
}

Future<Project?> queryProjectViaAPI(String id) async {
  final uri = Uri.https(apiBaseURL, "$projectAPIPath/$queryEndpoint");
  final body = <String, dynamic>{"id": id};

  final imageAsByteData = await rootBundle.load(defaultProjectImagePath);
  final imageAsBytes = Uint8List.view(imageAsByteData.buffer);
  final imageAsBase64 = base64String(imageAsBytes);

  try {
    final response = await http.post(uri, body: body);
    final responseProjects =
        (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).cast<Map<String, dynamic>>();
    final responseProject = responseProjects[0];

    String id = responseProject['id'];
    String name = responseProject['name'];
    String description = responseProject['description'];
    String ownerUserID = responseProject['owner'];
    //   String imageAsBase64 = responseProject['img'];
    String success = responseProject['success'];

    Project project = Project(id, name, description, ownerUserID, imageAsBase64, success);
    return project;
  } catch (error) {
    return null;
  }
}

Future<List<Contributor>> queryContributorsViaAPI(String projectID) async {
  final uri = Uri.https(apiBaseURL, "$contributorAPIPath/$queryEndpoint");
  final body = <String, dynamic>{"id": "", "proid": projectID};

  try {
    final response = await http.post(uri, body: body);
    final responseContributors =
        (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).cast<Map<String, dynamic>>();

    List<Contributor> contributors = responseContributors.map((responseContributor) {
      String id = responseContributor['id'];
      String projectID = responseContributor['proid'];
      String userID = responseContributor['memid'];

      final contributor = Contributor(id, projectID, userID, false);
      return contributor;
    }).toList();

    return contributors;
  } catch (error) {
    return [];
  }
}

Future<List<Status>> queryStatusListViaAPI(String projectID) async {
  final uri = Uri.https(apiBaseURL, "$statusAPIPath/$queryEndpoint");
  final body = <String, dynamic>{"id": "", "proid": projectID};

  try {
    final response = await http.post(uri, body: body);
    final responseStatusList =
        (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).cast<Map<String, dynamic>>();

    List<Status> statusList = responseStatusList.map((responseStatus) {
      String id = responseStatus['id'];
      String projectID = responseStatus['proid'];
      String color = responseStatus['color'];
      String label = responseStatus['label'];

      final status = Status(id, projectID, color, label);
      return status;
    }).toList();

    return statusList;
  } catch (error) {
    return [];
  }
}

Future<List<Tag>> queryTagsViaAPI(String projectID) async {
  final uri = Uri.https(apiBaseURL, "$tagAPIPath/$queryEndpoint");
  final body = <String, dynamic>{"id": "", "proid": projectID};

  try {
    final response = await http.post(uri, body: body);
    final responseTags = (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).cast<Map<String, dynamic>>();

    List<Tag> tags = responseTags.map((responseTag) {
      String id = responseTag['id'];
      String projectID = responseTag['proid'];
      String color = responseTag['color'];
      String label = responseTag['label'];

      final tag = Tag(id, projectID, color, label);
      return tag;
    }).toList();

    return tags;
  } catch (error) {
    return [];
  }
}

Future<List<User>> queryUsersViaAPI() async {
  final uri = Uri.https(apiBaseURL, "$memberAPIPath/$queryEndpoint");

  final imageAsByteData = await rootBundle.load(defaultUserImagePath);
  final imageAsBytes = Uint8List.view(imageAsByteData.buffer);
  final imageAsBase64 = base64String(imageAsBytes);

  try {
    final response = await http.post(uri);
    final responseUsers = (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).cast<Map<String, dynamic>>();

    List<User> users = responseUsers.map((responseUser) {
      String id = responseUser['id'];
      String name = responseUser['name'];
      String email = responseUser['email'];

      User user = User(id, name, email, imageAsBase64);
      return user;
    }).toList();

    return users;
  } catch (error) {
    return [];
  }
}

Future<User?> queryUserViaAPI(String id) async {
  final uri = Uri.https(apiBaseURL, "$memberAPIPath/$queryEndpoint");
  final body = <String, dynamic>{"id": id};

  final imageAsByteData = await rootBundle.load(defaultUserImagePath);
  final imageAsBytes = Uint8List.view(imageAsByteData.buffer);
  final imageAsBase64 = base64String(imageAsBytes);

  try {
    final response = await http.post(uri, body: body);
    final responseUsers = (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).cast<Map<String, dynamic>>();
    final responseUser = responseUsers[0];

    String userID = responseUser['id'];
    String userName = responseUser['name'];
    String userEmail = responseUser['email'];

    User user = User(userID, userName, userEmail, imageAsBase64);
    return user;
  } catch (error) {
    return null;
  }
}

Future<List<Task>> queryTasksViaAPI(String projectID) async {
  final uri = Uri.https(apiBaseURL, "$taskAPIPath/$queryEndpoint");
  final body = <String, dynamic>{"id": "", "proid": projectID};

  try {
    final response = await http.post(uri, body: body);
    final responseTasks = (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).cast<Map<String, dynamic>>();

    List<Task> tasks = responseTasks.map((responseTask) {
      String id = responseTask['id'];
      String projectID = responseTask['proid'];
      String statusID = responseTask['statusid'];
      String tagIDsAsString = responseTask['tagids'];
      String name = responseTask['name'];

      List<String> tagIDs = tagIDsAsString.split(",");

      final task = Task(id, projectID, statusID, tagIDs, name);
      return task;
    }).toList();

    return tasks;
  } catch (error) {
    return [];
  }
}
