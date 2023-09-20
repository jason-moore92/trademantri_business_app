import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class SettlementApiProvider {
  static getSettlements({
    @required String? storeId,
    @required int? limit,
    int page = 1,
    String? method,
    String? mode,
    String? status,
    String? referenceId,
    String? rrn,
    String? fromDate,
    String? toDate,
  }) async {
    String apiUrl = 'wallet/getSettlements';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        body: {
          "storeId": storeId,
          "method": method,
          "page": page,
          "limit": limit,
          "mode": mode,
          "status": status,
          "referenceId": referenceId,
          "rrn": rrn,
          "fromDate": fromDate,
          "toDate": toDate,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }
}
