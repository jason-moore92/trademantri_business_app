import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class StoreJobPostingsApiProvider {
  static getStoreJobPostingsData({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'store_job_posings/getAll/';
    apiUrl += "?storeId=$storeId";
    apiUrl += "&status=$status";
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

  static addJobPosting({@required Map<String, dynamic>? jobPostData}) async {
    String apiUrl = 'store_job_posings/add';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jobPostData),
      );
      return json.decode(response.body);
    });
  }

  static updateJobPosting({@required Map<String, dynamic>? jobPostData}) async {
    String apiUrl = 'store_job_posings/update';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jobPostData),
      );
      return json.decode(response.body);
    });
  }
}
