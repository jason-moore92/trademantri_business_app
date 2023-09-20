import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ContactUsRequestApiProvider {
  static addContactUsRequest({@required Map<String, dynamic>? contactUsRequestData}) async {
    String apiUrl = 'contactUsRequest/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      contactUsRequestData!["category"] = "store-app";

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(contactUsRequestData),
      );
      return json.decode(response.body);
    });
  }
}
