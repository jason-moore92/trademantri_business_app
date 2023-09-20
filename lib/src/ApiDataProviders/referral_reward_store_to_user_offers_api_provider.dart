import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ReferralRewardS2UOffersApiProvider {
  static getReferralRewardOffersData({
    @required String? referredByStoreId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'referralRewardStoreToUserOffers/getList/';
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
