import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ProductListApiProvider {
  static getProductCategories({
    @required List<String>? storeIds,
    @required String? storeSubType,
  }) async {
    String apiUrl = 'product/getProductCategories/';
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

  static getProductBrands({
    @required List<String>? storeIds,
    @required String? storeSubType,
  }) async {
    String apiUrl = 'product/getProductBrands/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + storeIds!.join(',');

      if (storeSubType != null) {
        url = url + "/" + storeSubType;
      }

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getProductList({
    @required List<String>? storeIds,
    List<dynamic> categories = const [],
    List<dynamic> brands = const [],
    String searchKey = "",
    @required int? limit,
    int page = 1,
    @required bool? isDeleted,
    @required bool? listonline,
  }) async {
    String apiUrl = 'product/getProducts';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeIds![0],

          ///TODO:: change every where to String instead of List<String>
          "categories": categories,
          "brands": brands,
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
