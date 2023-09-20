import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ReferralRewardS2SOffersApiProvider {
  static addRewardPoint({
    @required String? referredByStoreId,
    String referralStoreId = "",
    @required String? referredBy,
    @required String? appliedFor,
    @required String? storeName,
    @required String? storeMobile,
    @required String? storeAddress,
  }) async {
    String apiUrl = 'referralRewardStoreToStoreOffers/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "referredByStoreId": referredByStoreId,
          "referredBy": referredBy,
          "referralStoreId": referralStoreId,
          "appliedFor": appliedFor,
          "storeName": storeName,
          "storeMobile": storeMobile,
          "storeAddress": storeAddress,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getReferralRewardOffersData({
    @required String? referredByStoreId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'referralRewardStoreToStoreOffers/getList/';
    apiUrl += "?referredByStoreId=$referredByStoreId";
    apiUrl += "&searchKey=$searchKey";
    apiUrl += "&page=$page";
    apiUrl += "&limit=$limit";
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
