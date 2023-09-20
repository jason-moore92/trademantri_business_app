import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ServiceListApiProvider {
  static getServiceCategories({
    @required List<String>? storeIds,
    @required String? storeSubType,
  }) async {
    String apiUrl = 'service/getServiceCategories/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeIds": storeIds,
          "storeSubType": storeSubType,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getServiceProvided({@required List<String>? storeIds}) async {
    String apiUrl = 'service/getServiceProvided/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + storeIds!.join(',');

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getServiceList({
    @required List<String>? storeIds,
    List<dynamic> categories = const [],
    List<dynamic> provideds = const [],
    String searchKey = "",
    @required int? limit,
    int page = 1,
    @required bool? isDeleted,
    @required bool? listonline,
  }) async {
    String apiUrl = 'service/getServices';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeIds![0],
          "categories": categories,
          "provideds": provideds,
          "searchKey": searchKey,
          "page": page,
          "limit": limit,
          "isDeleted": isDeleted,
          "listonline": listonline,
        }),
      );
      return json.decode(response.body);
    });
  }
}
