import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class StoreFavoriteApiProvider {
  static getStoreFavorite({@required String? userId}) async {
    String apiUrl = 'storeFavorite/getStoreFavorite/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + userId!;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getStoreFavoriteData({
    @required String? userId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'storeFavorite/getStoreFavoriteData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?userId=$userId";
      url += "&searchKey=$searchKey";
      url += "&page=$page";
      url += "&limit=$limit";
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static setStoreFavorite({@required String? userId, @required String? id, @required bool? isFavorite}) async {
    String apiUrl = 'storeFavorite/setStoreFavorite/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"userId": userId, "id": id, "isFavorite": isFavorite}),
      );
      return json.decode(response.body);
    });
  }
}
