import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class DeliveryPartnerApiProvider {
  static getDeliveryPartners({@required String? zipCode}) async {
    String apiUrl = 'deliverypartners/get';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "?zipCode=$zipCode";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getDeliveryPartnerList({
    @required String? zipCode,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'deliverypartners/getDeliveryPartnerData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?zipCode=$zipCode";
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
