import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class StoreGalleryApiProvider {
  static update({@required Map<String, dynamic>? galleryData}) async {
    String apiUrl = 'store_gallery/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(galleryData),
      );
      return json.decode(response.body);
    });
  }

  static get({@required String? storeId}) async {
    String apiUrl = 'store_gallery/get';
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
