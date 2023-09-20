import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class PushSubscriptionApiProvider {
  static add({@required String? fcmToken}) async {
    String apiUrl = 'notifications';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"token": fcmToken, "vendor": "FCMTOKEN"}),
      );
      return json.decode(response.body);
    });
  }
}
