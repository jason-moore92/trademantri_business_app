import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/models/index.dart';

class AppointmentApiProvider {
  static updateAppointment({@required AppointmentModel? appointmentModel}) async {
    String apiUrl = 'updateAppointment';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(appointmentModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }

  static addAppointment({@required AppointmentModel? appointmentModel}) async {
    String apiUrl = 'appointmentdetails';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(appointmentModel!.toJsonForAdd()),
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "message": json.decode(response.body) ?? "",
          "data": json.decode(response.body),
        };
      }
    });
  }

  static getAppointments({
    @required String? storeId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'getAppointments';
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
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static eventAction({
    @required String? eventid,
    @required bool? eventenable,
  }) async {
    String apiUrl = 'eventenable';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "eventid": eventid,
          "eventenable": eventenable,
        }),
      );
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": json.decode(response.body),
        };
      } else {
        return {
          "success": false,
          "message": json.decode(response.body)["message"] ?? "Something was wrong",
          "data": json.decode(response.body),
        };
      }
    });
  }

  static deleteAppointment({@required String? id}) async {
    String apiUrl = 'appointment/delete';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "?id=$id";

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
          "message": json.decode(response.body)["message"] ?? "Something was wrong",
          "data": json.decode(response.body),
        };
      }
    });
  }

  static get({@required String? id}) async {
    String apiUrl = 'appointment/get';
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
