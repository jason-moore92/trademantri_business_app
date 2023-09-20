import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:trapp/config/config.dart';
import 'package:http/http.dart' as httpold;
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class StoreApiProvider {
  static getStoreList({
    @required String? storeId,
    @required List<dynamic>? types,
    @required List<dynamic>? categoryIds,
    @required Map<String, dynamic>? location,
    int page = 1,
    int? limit,
    String searchKey = "",
    bool isPaginated = true,
  }) async {
    String apiUrl = 'store/getStoreByCondition';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "types": types,
          "categoryIds": categoryIds,
          "location": location,
          "page": page,
          "limit": limit ?? AppConfig.countLimitForList,
          "searchKey": searchKey,
          "isPaginated": isPaginated,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getMyStore() async {
    String apiUrl = "getMyStore";
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        return {"success": true, "data": result};
      } else {
        return {"success": false, "data": "unaable to get store"};
      }
    });
  }

  static getStoreData({@required String? id}) async {
    String apiUrl = 'getStore/' + id!;
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      var result = json.decode(response.body);
      return {"success": true, "data": result};
    });
  }

  static registerStore({@required Map<String, dynamic>? storeData}) async {
    String apiUrl = 'auth/registerstore';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(storeData),
      );

      var result = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": result,
        };
      } else {
        return {
          "success": false,
          "message": result["message"],
          "errorCode": response.statusCode,
        };
      }
    });
  }

  static updateStoreData({@required String? id, @required Map<String, dynamic>? storeData, File? imageFile}) async {
    String apiUrl = 'store/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + id!;

      var request = httpold.MultipartRequest("POST", Uri.parse(url));
      request.fields.addAll({"data": json.encode(storeData)});

      var cmnHeaders = await commonHeaders();
      request.headers.addAll(cmnHeaders);

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

  static getFCMTokenByStoreUserId({@required String? storeId}) async {
    String apiUrl = 'store/getStoreTokens?storeId=' + storeId!;
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
