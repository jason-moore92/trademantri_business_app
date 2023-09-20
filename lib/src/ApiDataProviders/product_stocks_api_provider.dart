import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ProductStockApiProvider {
  static getAll({
    @required String? storeId,
    String? productId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'product_stock/getAll/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "storeId": storeId,
          "productId": productId,
          "searchKey": searchKey,
          "page": page,
          "limit": limit,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static add({
    @required Map<String, dynamic>? data,
  }) async {
    String apiUrl = 'product_stock/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }
}
