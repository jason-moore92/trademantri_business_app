import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class OrderApiProvider {
  static addOrder({@required Map<String, dynamic>? orderData, @required String? qrCode}) async {
    String apiUrl = 'orders/add/';

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
    @required String? storeId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'orders/getAll';
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

  static getStoreInvoices({
    @required String? storeId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'orders/getStoreInvoices';
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

  static getOrder({
    @required String? orderId,
    @required String? storeId,
    @required String? userId,
  }) async {
    String apiUrl = 'orders/getOrder';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
      url += "&userId=$userId";
      url += "&orderId=$orderId";

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
    String apiUrl = 'orders/changeStatus/';
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
    @required String? storeId,
    @required bool? changedStatus,
  }) async {
    String apiUrl = 'orders/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"orderData": orderData, "status": status, "changedStatus": changedStatus, "storeId": storeId}),
      );
      return json.decode(response.body);
    });
  }

  static getGraphDataByStore({
    @required String? storeId,
    @required String? filter,
  }) async {
    String apiUrl = 'storeOrderGraphData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
      url += "&filter=$filter";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getDashboardDataByStore({@required String? storeId}) async {
    String apiUrl = 'storeOrderStats/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + storeId!;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getCategoryOrderData({@required String? storeId}) async {
    String apiUrl = 'order/getCategoryOrderData';
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

  static getUserListForChat({
    @required String? storeId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'orders/getUserListForChat';
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
