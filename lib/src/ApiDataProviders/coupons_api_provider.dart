import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/index.dart';

class CouponsApiProvider {
  static addCoupons({@required CouponModel? couponModel}) async {
    String apiUrl = 'coupons/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      Map<String, dynamic> data = couponModel!.toJson();

      data.remove("_id");

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

  static updateCoupons({@required CouponModel? couponModel}) async {
    String apiUrl = 'coupons/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(couponModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }

  static enableCoupons({@required String? couponId, @required bool? enabled}) async {
    String apiUrl = 'coupons/enable/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "couponId": couponId,
          "enabled": enabled,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getCouponList({
    @required String? storeId,
    @required String? status,
    String? eligibility,
    bool? enabled,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'coupons/getCoupons/';
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
          "enabled": enabled,
          "eligibility": eligibility,
          "searchKey": searchKey,
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getCoupon({@required String? couponId}) async {
    String apiUrl = 'coupons/get?couponId=$couponId';
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
