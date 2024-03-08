import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:syncflow/api/api.dart';

Future<bool> updateProjectViaAPI(String id, {String? success}) async {
  final uri = Uri.https(apiBaseURL, "$projectAPIPath/$editEndpoint");
  final body = <String, dynamic>{"id": id};

  if (success != null) {
    body["success"] = success;
  }

  try {
    final response = await http.post(uri, body: body);
    utf8.decode(response.bodyBytes);

    return true;
  } catch (error) {
    return false;
  }
}
