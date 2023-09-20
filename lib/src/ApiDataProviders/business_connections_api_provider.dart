import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/index.dart';

class BusinessConnectionsApiProvider {
  static create({@required BusinessConnectionModel? businessConnectionModel}) async {
    String apiUrl = 'business_connections/create/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(businessConnectionModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }

  static update({@required BusinessConnectionModel? businessConnectionModel}) async {
    String apiUrl = 'business_connections/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(businessConnectionModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }

  static requestedStores({
    @required String? recepientId,
    @required List<String>? status,
    String searchKey = "",
    int page = 1,
    int? limit = 5,
  }) async {
    String apiUrl = 'business_connections/requested/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "recepientId": recepientId,
          "status": status,
          "searchKey": searchKey,
          "page": page,
          "limit": limit ?? AppConfig.countLimitForList,
        }),
      );
      return json.decode(response.body);
    });
  }

  static recepientStores({
    @required String? requestedId,
    @required List<String>? status,
    String searchKey = "",
    int page = 1,
    int? limit = 5,
  }) async {
    String apiUrl = 'business_connections/recepients/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "requestedId": requestedId,
          "status": status,
          "searchKey": searchKey,
          "page": page,
          "limit": limit ?? AppConfig.countLimitForList,
        }),
      );
      return json.decode(response.body);
    });
  }

  static connectedStores({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
    int page = 1,
    int? limit = 5,
  }) async {
    String apiUrl = 'business_connections/connected/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "status": status,
          "searchKey": searchKey,
          "page": page,
          "limit": limit ?? AppConfig.countLimitForList,
        }),
      );
      return json.decode(response.body);
    });
  }

  static networkStatus({@required String? storeId}) async {
    String apiUrl = 'business_connections/networkStatus/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"storeId": storeId}),
      );
      return json.decode(response.body);
    });
  }

  static getConnection({
    String? requestType = "Store-Store",
    @required String? requestedId,
    @required String? recepientId,
  }) async {
    String apiUrl = 'business_connections/get/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "requestType": requestType,
          "requestedId": requestedId,
          "recepientId": recepientId,
        }),
      );
      return json.decode(response.body);
    });
  }
}
