import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class CartApiProvider {
  static addCart({@required Map<String, dynamic>? cartData}) async {
    String apiUrl = 'cart/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(cartData),
      );
      return json.decode(response.body);
    });
  }

  static getCartData({@required String? userId, String status = ""}) async {
    String apiUrl = 'cart/getCartData' + "?userId=$userId" + "&status=$status";
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

  static setStatus({@required String? id, @required String? status}) async {
    String apiUrl = 'cart/setStatus';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "id": id,
          "status": status,
        }),
      );
      return json.decode(response.body);
    });
  }
}
