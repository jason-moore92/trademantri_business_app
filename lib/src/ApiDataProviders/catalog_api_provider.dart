import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class CatalogApiProvider {
  static getCatalogProducts({
    String businessType = "store",
    @required String? searchTerm,
    @required String? cat,
    @required String? subCat,
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'catalog';
    apiUrl += "?businessType=$businessType";
    apiUrl += "&searchTerm=$searchTerm";
    apiUrl += "&cat=$cat";
    apiUrl += "&subCat=$subCat";
    apiUrl += "&limit=$limit";
    apiUrl += "&page=$page";
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "data": json.decode(response.body),
        };
      }
    });
  }

  static getCatalogServices({
    String businessType = "services",
    @required String? searchTerm,
    @required String? cat,
    @required String? subCat,
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'catalog';
    apiUrl += "?businessType=$businessType";
    apiUrl += "&searchTerm=$searchTerm";
    apiUrl += "&cat=$cat";
    apiUrl += "&subCat=$subCat";
    apiUrl += "&limit=$limit";
    apiUrl += "&page=$page";
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "data": json.decode(response.body),
        };
      }
    });
  }

  static getProductCatalogCategories() async {
    String apiUrl = 'catalog/getCategories';
    apiUrl += "?businessType=store";
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      apiUrl += "?businessType=store";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "data": json.decode(response.body),
        };
      }
    });
  }

  static getProductCatalogSubCategories() async {
    String apiUrl = 'catalog/getSubCategories';
    apiUrl += "?businessType=store";
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "data": json.decode(response.body),
        };
      }
    });
  }

  static getServiceCatalogCategories() async {
    String apiUrl = 'catalog/getCategories';
    apiUrl += "?businessType=services";
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "data": json.decode(response.body),
        };
      }
    });
  }

  static getServiceCatalogSubCategories() async {
    String apiUrl = 'catalog/getSubCategories';
    apiUrl += "?businessType=services";
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "data": json.decode(response.body),
        };
      }
    });
  }
}
