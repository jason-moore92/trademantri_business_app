import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class AnnouncementsApiProvider {
  static addAnnouncements({@required Map<String, dynamic>? announcementData}) async {
    String apiUrl = 'announcements/add/';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(announcementData!),
      );
      return json.decode(response.body);
    });
  }

  static updateAnnouncements({@required Map<String, dynamic>? announcementData}) async {
    String apiUrl = 'announcements/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(announcementData!),
      );
      return json.decode(response.body);
    });
  }

  static enableAnnouncements({@required String? announcementId, @required bool? enabled}) async {
    String apiUrl = 'announcements/enable/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "announcementId": announcementId,
          "enabled": enabled,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getAnnouncement({@required String? announcementId}) async {
    String apiUrl = 'announcements/getWithStore?announcementId=$announcementId';
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

  static getAnnouncementList({
    @required String? storeId,
    @required String? announcementto,
    bool? active,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'announcements/getAnnouncements/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "announcementto": announcementto,
          "active": active,
          "searchKey": searchKey,
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getOtherAnnouncements({
    @required String? storeId,
    String? city,
    String? category,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'announcements/getOtherAnnouncements/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "storeId": storeId,
          "city": city,
          "category": category,
          "searchKey": searchKey,
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getCategories({@required String? storeId}) async {
    String apiUrl = 'announcements/getCategories/$storeId';
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
