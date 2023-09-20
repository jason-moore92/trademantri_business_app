import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/index.dart';

class PurchaseOrderApiProvider {
  static addPurchaseOrder({@required PurchaseModel? purchaseModel}) async {
    String apiUrl = 'purchase_order/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      Map<String, dynamic> data = purchaseModel!.toJson();

      data["businessStore"] = purchaseModel.businessStoreModel!.toJson();
      data["myStore"] = purchaseModel.myStoreModel!.toJson();

      data.remove("_id");
      data["qrCodeData"] = Encrypt.encryptString(
        "PurchaseOrder_MyStoreId-${purchaseModel.myStoreModel!.id}_BusinessStoreId-${purchaseModel.businessStoreModel!.id}",
      );

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );
      return json.decode(response.body);
    });
  }

  static updatePurchaseOrder({@required PurchaseModel? purchaseModel}) async {
    String apiUrl = 'purchase_order/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(purchaseModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }

  static getPurchaseList({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'purchase_order/getPurchaseList/';
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
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getPurchaseOrder({@required String? id}) async {
    String apiUrl = 'purchase_order/get?id=$id';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getPurchaseHistory({
    @required String? myStoreId,
    @required String? businessStoreId,
    @required String? itemId,
    @required String? category,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'purchase_order/getPurchaseHistory/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "myStoreId": myStoreId,
          "businessStoreId": businessStoreId,
          "itemId": itemId,
          "category": category,
          "searchKey": searchKey,
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }
}
