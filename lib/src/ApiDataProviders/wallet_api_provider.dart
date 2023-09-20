import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class WalletApiProvider {
  static getAccounts({
    @required String? storeId,
  }) async {
    String apiUrl = 'wallet/getAccounts';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "storeId": storeId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getAccount({
    @required String? storeId,
    @required String? accountId,
  }) async {
    String apiUrl = 'wallet/getAccount';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        body: json.encode({"storeId": storeId, "accountId": accountId}),
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

  static getTransactions({
    @required String? storeId,
    @required String? accountId,
    @required int? limit,
    int page = 1,
    bool? settled,
    bool? isRefund,
    String? narration,
    String? type,
    String? orderId,
    String? fromDate,
    String? toDate,
    String? reqReferenceId,
  }) async {
    String apiUrl = 'wallet/getTransactions';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "storeId": storeId,
          "accountId": accountId,
          "page": page,
          "limit": limit,
          "isRefund": isRefund,
          "type": type,
          "narration": narration,
          "orderId": orderId,
          "fromDate": fromDate,
          "toDate": toDate,
          "settled": settled,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static withdrawal({
    @required String? storeId,
    double? amount,
    String? notes,
  }) async {
    String apiUrl = 'wallet/withdrawal';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "storeId": storeId,
          "amount": amount,
          "notes": notes,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }
}
