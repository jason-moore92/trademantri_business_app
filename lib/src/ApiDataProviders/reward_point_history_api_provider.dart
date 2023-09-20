import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class RewardPointHistoryApiProvider {
  static sumRewardPointsForStore({@required String? receiveStoreId, @required String? storeId}) async {
    String apiUrl = 'storerewards/sumRewardPointsForStore';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?receiveStoreId=$receiveStoreId";
      url += "&storeId=$storeId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getRewardPointsForStore({
    @required String? receiveStoreId,
    @required String? storeId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'storerewards/getRewardPointsForStore';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?receiveStoreId=$receiveStoreId";
      url += "&storeId=$storeId";
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

  static sumRewardPointsForCustomer({
    String userId = "",
    String storeId = "",
  }) async {
    String apiUrl = 'storerewards/sumRewardPointsForCustomer';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?userId=$userId";
      url += "&storeId=$storeId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getRewardPointsForCustomer({
    @required String? storeId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'storerewards/getRewardPointsForCustomer';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
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
}
