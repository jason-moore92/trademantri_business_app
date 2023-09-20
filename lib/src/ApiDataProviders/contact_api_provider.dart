import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/environment.dart';

class ContactApiProvider {
  static createContact({@required ContactModel? contactModel}) async {
    String apiUrl = 'contact/add';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(contactModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }
}
