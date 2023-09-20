import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpold;
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:http_parser/http_parser.dart';
import 'package:trapp/environment.dart';

class ProductApiProvider {
  static uploadImage({@required List<File>? imageFiles, @required String? token}) async {
    String apiUrl = "products/uploadImage";
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      List<String> imagePath = [];
      for (var i = 0; i < imageFiles!.length; i++) {
        Uint8List imageByteData = await imageFiles[i].readAsBytes();

        var request = new httpold.MultipartRequest("POST", Uri.parse(url));
        String fileName = imageFiles[i].path.split('/').last;
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });
        request.files.add(
          httpold.MultipartFile.fromBytes(
            'file',
            imageByteData,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

        var response = await request.send();
        if (response.statusCode == 200) {
          var result = await response.stream.bytesToString();

          imagePath.add(json.decode(result)["filePath"]);
        } else {
          throw new Exception(response);
        }
      }
      return {
        "success": true,
        "data": imagePath,
      };
    });
  }

  static addProduct({@required Map<String, dynamic>? productData, @required String? token, @required bool? isNew}) async {
    return httpExceptionWrapper(() async {
      //  String url = Environment.apiBaseUrl! + apiUrl;/products";
      String url = Environment.apiBaseUrl! + "products";
      productData!["operation"] = isNew! ? "add" : "update";
      productData["sellingPrice"] = productData["priceAttributes"] != null && productData["priceAttributes"]["selling"] != null
          ? productData["priceAttributes"]["selling"]
          : null;
      productData["buyingPrice"] = productData["priceAttributes"] != null && productData["priceAttributes"]["buying"] != null
          ? productData["priceAttributes"]["buying"]
          : null;
      productData["minQuantityForBargainOrder"] = productData["bargainAttributes"] != null && productData["bargainAttributes"]["minQuantity"] != null
          ? productData["bargainAttributes"]["minQuantity"]
          : null;
      productData["minAmountForBargainOrder"] = productData["bargainAttributes"] != null && productData["bargainAttributes"]["minAmount"] != null
          ? productData["bargainAttributes"]["minAmount"]
          : null;
      productData["cessPercentage"] = productData["extraCharges"] != null &&
              productData["extraCharges"]["cess"] != null &&
              productData["extraCharges"]["cess"]["percentage"] != null
          ? productData["extraCharges"]["cess"]["percentage"]
          : null;
      productData["cessValue"] =
          productData["extraCharges"] != null && productData["extraCharges"]["cess"] != null && productData["extraCharges"]["cess"]["value"] != null
              ? productData["extraCharges"]["cess"]["value"]
              : null;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(productData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var result = json.decode(response.body);
        result["success"] = true;
        return result;
      } else {
        var result = json.decode(response.body);
        result["success"] = false;
        return result;
      }
    });
  }

  static deleteProduct({@required String? productId, @required String? token}) async {
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + "products/delete/$productId";
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var result = json.decode(response.body);
      result["success"] = true;
      return result;
    });
  }

  static getProduct({@required String? id}) async {
    String apiUrl = 'products/getProduct/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + id!;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getTopSelling({
    @required String? storeId,
    String? userId,
    String? from,
    String? to,
  }) async {
    String apiUrl = 'products/topSelling/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "storeId": storeId,
          "userId": userId,
          "from": from,
          "to": to,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static getStatisticsByOrder({
    @required String? storeId,
    String? productId,
    String? from,
    String? to,
  }) async {
    String apiUrl = 'products/statisticsByOrder/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "storeId": storeId,
          "productId": productId,
          "from": from,
          "to": to,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }
}
