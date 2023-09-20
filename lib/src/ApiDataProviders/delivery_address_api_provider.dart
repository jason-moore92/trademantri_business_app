import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class DeliveryAddressApiProvider {
  static addDeliveryAddress({@required Map<String, dynamic>? deliveryAddressData}) async {
    String apiUrl = 'deliveryAddress/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(deliveryAddressData),
      );
      return json.decode(response.body);
    });
  }

  static updateDeliveryAddress({@required String? id, @required Map<String, dynamic>? deliveryAddressData}) async {
    String apiUrl = 'deliveryAddress/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + id!;

      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(deliveryAddressData),
      );
      return json.decode(response.body);
    });
  }

  static getDeliveryAddressData({@required String? userId}) async {
    String apiUrl = 'deliveryAddress/getDeliveryAddressData/' + userId!;
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
}
