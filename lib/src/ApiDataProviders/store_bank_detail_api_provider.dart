import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpold;
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class StoreBankDetailApiProvider {
  static getStoreBankDetail({@required String? storeId}) async {
    String apiUrl = 'storeBankDetail/get/' + storeId!;
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

  static updateStoreBankDetail({
    @required Map<String, dynamic>? storeBankDetail,
    File? imageFile,
    @required String? storeId,
  }) async {
    String apiUrl = 'storeBankDetail/update/' + storeId!;
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var request = httpold.MultipartRequest("POST", Uri.parse(url));

      var cmnHeaders = await commonHeaders();
      request.headers.addAll(cmnHeaders);

      request.fields.addAll({"data": json.encode(storeBankDetail)});

      if (imageFile != null) {
        Uint8List imageByteData = await imageFile.readAsBytes();
        request.files.add(
          httpold.MultipartFile.fromBytes(
            'image',
            imageByteData,
            filename: imageFile.path.split('/').last,
          ),
        );
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();

        return json.decode(result);
      } else {
        return {
          "success": false,
          "message": "failed",
          "errorCode": response.statusCode,
        };
      }
    });
  }
}
