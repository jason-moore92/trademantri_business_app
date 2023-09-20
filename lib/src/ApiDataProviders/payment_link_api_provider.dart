import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class PaymentLinkApiProvider {
  static addPaymentLink({@required Map<String, dynamic>? paymentData}) async {
    String apiUrl = 'payment_link/add/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      for (var i = 0; i < paymentData!["products"].length; i++) {
        if (paymentData["products"][i]["imageFile"] != null) {
          var result = await UploadFileApiProvider.uploadFile(
            file: paymentData["products"][i]["imageFile"],
            bucketName: "PRODUCTS_BUCKET_NAME",
            directoryName: "payment_link/",
            fileName: paymentData["products"][i]["name"] + "_" + DateTime.now().millisecondsSinceEpoch.toString(),
          );

          if (result["success"]) {
            paymentData["products"][i]["images"] = [result["data"]];
            paymentData["products"][i].remove("imageFile");
          } else {
            paymentData["products"][i].remove("imageFile");
          }
        }
      }

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(paymentData),
      );
      return json.decode(response.body);
    });
  }

  static getPaymentData({@required String? id, @required String? paymentLinkId, @required String? status}) async {
    String apiUrl = 'payment_link/get';
    apiUrl += "?id=" + id!;
    apiUrl += "&status=" + status!;
    apiUrl += "&paymentLinkId=" + paymentLinkId!;
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

  static getPaymentLinks({@required String? storeId, String searchKey = "", int page = 1}) async {
    String apiUrl = 'payment_link/getPaymentLinks/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "searchKey": searchKey,
          "limit": 5,
          "page": page,
        }),
      );
      return json.decode(response.body);
    });
  }
}
