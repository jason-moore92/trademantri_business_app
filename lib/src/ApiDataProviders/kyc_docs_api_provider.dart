import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

import 'index.dart';

//TODO:: remove storeUserId, because making all docs store specific.
class KYCDocsApiProvider {
  static getKYCDocs({@required String? storeUserId, @required String? storeId}) async {
    String apiUrl = 'kyc_docs/get' + "?storeUserId=$storeUserId&storeId=$storeId";
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

  static updateKYCDocs({@required String? storeUserId, @required String? storeId, @required Map<String, dynamic>? kycDocs}) async {
    String apiUrl = Environment.apiBaseUrl! + 'kyc_docs/update';
    return httpExceptionWrapper(() async {
      Map<String, dynamic> requestData = Map<String, dynamic>();
      kycDocs!.forEach((type, data) {
        requestData[type] = Map<String, dynamic>();
        data.forEach((key, vale) {
          if (key != "file") requestData[type][key] = vale;
        });
      });

      int uploadedCount = 0;
      for (var i = 0; i < kycDocs.length; i++) {
        String type = kycDocs.keys.toList()[i];
        if (kycDocs[type]["file"] != null) {
          var result = await UploadFileApiProvider.uploadFile(
            file: kycDocs[type]["file"],
            directoryName: "StoreId-$storeId/",
            fileName: kycDocs[type]["fileName"],
            bucketName: "KYC_DOCS_BUCKET_NAME",
          );

          if (result["success"]) {
            requestData[type]["path"] = result["data"];
            requestData[type]["status"] = "Uploaded";
            uploadedCount++;
          }
        }
      }

      if (uploadedCount == 0) {
        return {
          "success": false,
          "messages": "File upload Failed",
        };
      } else {
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "storeUserId": storeUserId,
            "storeId": storeId,
            "documents": requestData,
          }),
        );
        return json.decode(response.body);
      }
    });
  }
}
