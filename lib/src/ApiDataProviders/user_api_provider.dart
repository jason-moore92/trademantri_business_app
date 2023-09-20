import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class UserApiProvider {
  static login(String name, String password) async {
    String apiUrl = 'auth/login';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "userName": name,
          "password": password,
        }),
      );

      var result = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": result,
        };
      } else {
        return {
          "success": false,
          "message": result["errors"]["msg"],
          "errorCode": response.statusCode,
        };
      }
    });
  }

  static logout({@required String? token}) async {
    String apiUrl = 'auth/logout';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "authorization": token!,
        },
      );
      return json.decode(response.body);
    });
  }

  static getOtherCreds() async {
    String apiUrl = 'auth/otherCreds';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return {
        "success": true,
        "data": json.decode(response.body),
      };
    });
  }

  static updateFreshChatRestoreId({@required String? restoreId}) async {
    String apiUrl = 'freshChat/updateRestoreId/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "restoreId": restoreId,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getMaintenance() async {
    String apiUrl = 'maintenance/active';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return json.decode(response.body);
    });
  }
}
