import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:syncflow/api/api.dart';
import 'package:syncflow/contributor/contributor.dart';
import 'package:syncflow/project/project.dart';
import 'package:syncflow/status/status.dart';
import 'package:syncflow/tag/tag.dart';
import 'package:syncflow/task/task.dart';

Future<Project?> createProjectViaAPI(String name, String description, String ownerUserID, String imageAsBase64) async {
  final uri = Uri.https(apiBaseURL, "$projectAPIPath/$createEndpoint");
  final body = <String, dynamic>{
    "name": name,
    "description": description,
    "owner": ownerUserID,
    "img": imageAsBase64,
    "success": "0"
  };

  try {
    final response = await http.post(uri, body: body);
    final responseProject = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    String id = responseProject['id'];
    String name = responseProject['name'];
    String description = responseProject['description'];
    String ownerUserID = responseProject['owner'];
    String imageAsBase64 = responseProject['img'];
    String success = responseProject['success'];

    final project = Project(id, name, description, ownerUserID, imageAsBase64, success);
    return project;
  } catch (error) {
    return null;
  }
}

Future<Contributor?> createContributorViaAPI(String projectID, String userID) async {
  final uri = Uri.https(apiBaseURL, "$contributorAPIPath/$createEndpoint");
  final body = <String, dynamic>{"proid": projectID, "memid": userID};

  try {
    final response = await http.post(uri, body: body);
    final responseStatus = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    String id = responseStatus['id'];
    String projectID = responseStatus['proid'];
    String userID = responseStatus['memid'];

    final contributor = Contributor(id, projectID, userID, false);
    return contributor;
  } catch (error) {
    return null;
  }
}

Future<Status?> createStatusViaAPI(String projectID, String color, String label) async {
  final uri = Uri.https(apiBaseURL, "$statusAPIPath/$createEndpoint");
  final body = <String, dynamic>{"proid": projectID, "color": color, "label": label};

  try {
    final response = await http.post(uri, body: body);
    final responseStatus = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    String id = responseStatus['id'];
    String projectID = responseStatus['proid'];
    String color = responseStatus['color'];
    String label = responseStatus['label'];

    final status = Status(id, projectID, color, label);
    return status;
  } catch (error) {
    return null;
  }
}

Future<Tag?> createTagViaAPI(String projectID, String color, String label) async {
  final uri = Uri.https(apiBaseURL, "$tagAPIPath/$createEndpoint");
  final body = <String, dynamic>{"proid": projectID, "color": color, "label": label};

  try {
    final response = await http.post(uri, body: body);
    final responseTag = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    String id = responseTag['id'];
    String projectID = responseTag['proid'];
    String color = responseTag['color'];
    String label = responseTag['label'];

    final tag = Tag(id, projectID, color, label);
    return tag;
  } catch (error) {
    return null;
  }
}

Future<Task?> createTaskViaAPI(String projectID, String statusID, List<String> tagIDs, String name) async {
  final uri = Uri.https(apiBaseURL, "$taskAPIPath/$createEndpoint");

  final tagIDsAsString = tagIDs.join(",");

  final body = <String, dynamic>{"proid": projectID, "statusid": statusID, "tagids": tagIDsAsString, "name": name};

  try {
    final response = await http.post(uri, body: body);
    final responseTask = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    String id = responseTask['id'];

    final task = Task(id, projectID, statusID, tagIDs, name);
    return task;
  } catch (error) {
    return null;
  }
}
