import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class BookAppointmentApiProvider {
  static getBookData({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'book_appointment/getBookData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          // "storeId": storeId,
          "storeId": storeId,
          "status": status!.toLowerCase(),
          "searchKey": searchKey,
          "currentDate": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toIso8601String(),
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static rejectBook({
    @required String? bookAppointmentId,
    @required String? commentForRejected,
  }) async {
    String apiUrl = 'book_appointment/reject';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "bookAppointmentId": bookAppointmentId,
          "commentForRejected": commentForRejected,
        }),
      );
      return json.decode(response.body);
    });
  }

  static acceptBook({@required String? bookAppointmentId}) async {
    String apiUrl = 'book_appointment/accept';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"bookAppointmentId": bookAppointmentId}),
      );
      return json.decode(response.body);
    });
  }

  static get({@required String? id}) async {
    String apiUrl = 'book_appointment/get';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"id": id}),
      );
      return json.decode(response.body);
    });
  }
}
