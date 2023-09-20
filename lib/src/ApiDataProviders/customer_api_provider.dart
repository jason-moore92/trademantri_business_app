import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class CustomerApiProvider {
  static groupByAge({
    @required String? storeId,
    String? from,
    String? to,
  }) async {
    String apiUrl = 'customers/groupByAge/';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "from": from,
          "to": to,
        }),
      );
      return json.decode(response.body);
    });
  }

  static recentOrders({
    @required String? storeId,
    String? userId,
    String? from,
    String? to,
  }) async {
    String apiUrl = 'customers/recentOrders/';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "userId": userId,
          "from": from,
          "to": to,
        }),
      );
      return json.decode(response.body);
    });
  }

  static frequentOrders({
    @required String? storeId,
    String? from,
    String? to,
  }) async {
    String apiUrl = 'customers/frequentOrders/';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "from": from,
          "to": to,
        }),
      );
      return json.decode(response.body);
    });
  }

  static monetaryOrders({
    @required String? storeId,
    String? userId,
    String? from,
    String? to,
  }) async {
    String apiUrl = 'customers/monetaryOrders/';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "userId": userId,
          "from": from,
          "to": to,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getOrdersByStatus({
    @required String? storeId,
    String? userId,
    String? from,
    String? to,
  }) async {
    String apiUrl = 'customers/groupByStatus/';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "userId": userId,
          "from": from,
          "to": to,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getQuickInsights({
    @required String? storeId,
    @required String? userId,
  }) async {
    String apiUrl = 'customers/quickInsights/';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "userId": userId,
        }),
      );
      return json.decode(response.body);
    });
  }
}
