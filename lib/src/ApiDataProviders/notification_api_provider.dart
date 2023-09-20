import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class NotificationApiProvider {
  static getNotificationData({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'app_notifications/getAll/';
    apiUrl += "?storeId=$storeId";
    apiUrl += "&status=$status";
    apiUrl += "&searchKey=$searchKey";
    apiUrl += "&page=$page";
    apiUrl += "&limit=$limit";
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }
}
