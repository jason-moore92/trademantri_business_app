import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/helpers/http_plus.dart';

class ServiceApiProvider {
  static uploadImage({@required List<File>? imageFiles, @required String? token}) async {
    return httpExceptionWrapper(() async {
      String apiUrl = "services/uploadImage";
      String url = Environment.apiBaseUrl! + apiUrl;
      List<String> imagePath = [];
      for (var i = 0; i < imageFiles!.length; i++) {
        Uint8List imageByteData = await imageFiles[i].readAsBytes();

        var request = new http.MultipartRequest("POST", Uri.parse(url));
        String fileName = imageFiles[i].path.split('/').last;
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });
        request.files.add(
          http.MultipartFile.fromBytes(
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

  static addService({@required Map<String, dynamic>? serviceData, @required String? token, @required bool? isNew}) async {
    return httpExceptionWrapper(() async {
      String apiUrl = "services";
      String url = Environment.apiBaseUrl! + apiUrl;
      serviceData!["operation"] = isNew! ? "add" : "update";
      serviceData["sellingPrice"] = serviceData["priceAttributes"] != null && serviceData["priceAttributes"]["selling"] != null
          ? serviceData["priceAttributes"]["selling"]
          : null;
      serviceData["buyingPrice"] = serviceData["priceAttributes"] != null && serviceData["priceAttributes"]["buying"] != null
          ? serviceData["priceAttributes"]["buying"]
          : null;
      serviceData["minQuantityForBargainOrder"] = serviceData["bargainAttributes"] != null && serviceData["bargainAttributes"]["minQuantity"] != null
          ? serviceData["bargainAttributes"]["minQuantity"]
          : null;
      serviceData["minAmountForBargainOrder"] = serviceData["bargainAttributes"] != null && serviceData["bargainAttributes"]["minAmount"] != null
          ? serviceData["bargainAttributes"]["minAmount"]
          : null;
      serviceData["cessPercentage"] = serviceData["extraCharges"] != null &&
              serviceData["extraCharges"]["cess"] != null &&
              serviceData["extraCharges"]["cess"]["percentage"] != null
          ? serviceData["extraCharges"]["cess"]["percentage"]
          : null;
      serviceData["cessValue"] =
          serviceData["extraCharges"] != null && serviceData["extraCharges"]["cess"] != null && serviceData["extraCharges"]["cess"]["value"] != null
              ? serviceData["extraCharges"]["cess"]["value"]
              : null;
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(serviceData),
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

  static deleteService({@required String? serviceId, @required String? token}) async {
    return httpExceptionWrapper(() async {
      String apiUrl = "/services/delete/$serviceId";
      String url = Environment.apiBaseUrl! + apiUrl;
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

  static getService({@required String? id}) async {
    String apiUrl = 'services/getService/';
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
}
