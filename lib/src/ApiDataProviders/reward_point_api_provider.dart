import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class RewardPointApiProvider {
  static getRewardPointsListById({@required String? storeId}) async {
    String apiUrl = 'storerewardsList/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "$storeId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return {
        "success": true,
        "data": json.decode(response.body),
      };
    });
  }

  static createOrUpdateRewardPoints({@required Map<String, dynamic>? rewardPointData}) async {
    String apiUrl = 'rewardpoints/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(rewardPointData),
      );

      if (response.statusCode == 200)
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      else
        return {
          "success": false,
          "message": "Something was wrong",
        };
    });
  }
}
