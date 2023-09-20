import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/index.dart';

class BargainRequestApiProvider {
  static addBargainRequest({@required BargainRequestModel? bargainRequestModel}) async {
    String apiUrl = 'bargain_request/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(bargainRequestModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }

  static getBargainRequestData({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'bargain_request/getBargainRequestData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
      url += "&status=$status";
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

  static updateBargainRequestData({
    @required BargainRequestModel? bargainRequestModel,
    @required String? status,
    @required String? subStatus,
    @required String? storeId,
    String toWhome = "user",
  }) async {
    String apiUrl = 'bargain_request/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "bargainRequestData": bargainRequestModel!.toJson(),
          "status": status,
          "subStatus": subStatus,
          // "toWhome": toWhome,
          "storeId": storeId
        }),
      );
      return json.decode(response.body);
    });
  }

  static getBargainRequest({
    @required String? storeId,
    @required String? userId,
    @required String? bargainRequestId,
  }) async {
    String apiUrl = 'bargain_request/get';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
      url += "&userId=$userId";
      url += "&bargainRequestId=$bargainRequestId";
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getTotalBargainByStore({@required String? storeId}) async {
    String apiUrl = 'bargain_request/getTotal';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";

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
