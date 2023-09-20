import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/business_card_model.dart';

class BusinessCardApiProvider {
  static getMyBusinessCard() async {
    String apiUrl = 'mybusinesscard';
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

  static createOrUpdateBusinessCard({@required BusinessCardModel? businessCardModel}) async {
    String apiUrl = 'businesscard';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(businessCardModel!.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "message": json.decode(response.body)["message"] ?? "Something was wrong",
        };
      }
    });
  }

  static updateGalleryOfMyBusinessCard({@required List<dynamic>? gallery}) async {
    String apiUrl = 'businesscard/gallery';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"gallery": gallery}),
      );
      Map<String, dynamic> data = json.decode(response.body);
      if (response.statusCode == 200 && data["_id"] != null) {
        return {
          "success": true,
          "data": data,
        };
      } else {
        return {
          "success": false,
          "message": data["message"],
        };
      }
    });
  }
}
