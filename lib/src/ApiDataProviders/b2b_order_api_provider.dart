import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class B2BOrderApiProvider {
  static addOrder({@required Map<String, dynamic>? orderData, @required String? qrCode}) async {
    String apiUrl = 'b2b_orders/add/';

    orderData!["qrCodeData"] = qrCode;
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(orderData),
      );
      return json.decode(response.body);
    });
  }

  static getOrderData({
    @required String? myStoreId,
    @required String? businessStoreId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'b2b_orders/getAll';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?myStoreId=$myStoreId";
      url += "&businessStoreId=$businessStoreId";
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

  static getOrder({
    @required String? orderId,
    @required String? myStoreId,
    @required String? businessStoreId,
  }) async {
    String apiUrl = 'b2b_orders/getOrder';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?orderId=$orderId";
      url += "&myStoreId=$myStoreId";
      url += "&businessStoreId=$businessStoreId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static changeOrderStatus({
    @required String? orderId,
    @required String? userId,
    @required String? status,
    @required String? storeId,
    @required String? token,
  }) async {
    String apiUrl = 'b2b_orders/changeStatus/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode({
          "orderId": orderId,
          "userId": userId,
          "status": status,
          "storeId": storeId,
        }),
      );
      return json.decode(response.body);
    });
  }

  static updateOrderData({
    @required Map<String, dynamic>? orderData,
    @required String? status,
    @required bool? changedStatus,
  }) async {
    String apiUrl = 'b2b_orders/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "orderData": orderData,
          "status": status,
          "changedStatus": changedStatus,
        }),
      );
      return json.decode(response.body);
    });
  }
}
