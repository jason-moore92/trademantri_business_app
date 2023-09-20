import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ReverseAuctionApiProvider {
  static addReverseAuction({@required Map<String, dynamic>? reverseAuctionData}) async {
    String apiUrl = 'reverse_auction/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(reverseAuctionData),
      );
      return json.decode(response.body);
    });
  }

  static getReverseAuctionDataByStore({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'reverse_auction/getAll';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
      url += "&status=$status";
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

  static updateReverseAuctionData({
    @required Map<String, dynamic>? reverseAuctionData,
    @required Map<String, dynamic>? storeOfferData,
    @required String? status,
    // @required String storeName,
    // @required String userName,
    // String toWhome = "user",
    @required String? storeId,
  }) async {
    String apiUrl = 'reverse_auction/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "reverseAuctionData": reverseAuctionData,
          "storeOfferData": storeOfferData,
          "status": status,
          // "toWhome": toWhome,
          // "storeName": storeName,
          // "userName": userName,
          "storeId": storeId,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getReverseAuction({
    @required String? reverseAuctionId,
    @required String? userId,
    @required String? storeId,
  }) async {
    String apiUrl = 'reverse_auction/get';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?reverseAuctionId=$reverseAuctionId";
      url += "&userId=$userId";
      url += "&storeId=$storeId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getTotalReverseAuctionByStore({@required String? storeId}) async {
    String apiUrl = 'reverse_auction/getTotal';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";

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
