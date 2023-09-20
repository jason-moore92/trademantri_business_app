import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/config.dart';

class KeicyDateTime {
  static const String initFormat = "Y-m-d";

  static DateTime? convertDateStringToDateTime({
    @required String? dateString,
    datePattern = '-',
    timePattern = ":",
    @required bool? isUTC,
  }) {
    try {
      if (dateString == "" || dateString == null) return null;

      List<String>? listDateTime = dateString.split(" ");
      List<String>? listDate = listDateTime[0].split(datePattern);
      List<String>? listTime = (listDateTime.length == 2) ? listDateTime[1].split(timePattern) : null;

      DateTime dt = DateTime(
        int.parse((listDate.length >= 1 && listDate[0] != "") ? listDate[0].toString() : "0"),
        int.parse((listDate.length >= 2 && listDate[1] != "") ? listDate[1].toString() : "0"),
        int.parse((listDate.length >= 3 && listDate[2] != "") ? listDate[2].toString() : "0"),
        int.parse((listTime != null && listTime.length >= 1 && listTime[0] != "") ? listTime[0].toString() : "0"),
        int.parse((listTime != null && listTime.length >= 2 && listTime[1] != "") ? listTime[1].toString() : "0"),
        int.parse((listTime != null && listTime.length >= 3 && listTime[2] != "") ? listTime[2].toString() : "0"),
      );

      if (isUTC!)
        return dt.toUtc();
      else
        return dt.toLocal();
    } catch (e) {
      return null;
    }
  }

  static String? convertDateStringToDateString({
    @required String? dateString,
    datePattern = '-',
    timePattern = ":",
    String formats = initFormat,
    @required bool? isUTC,
  }) {
    try {
      if (dateString == "" || dateString == null) return null;

      List<String>? listDateTime = dateString.split(" ");
      List<String>? listDate = listDateTime[0].split(datePattern);
      List<String>? listTime = (listDateTime.length == 2) ? listDateTime[1].split(timePattern) : null;

      DateTime dt = DateTime(
        int.parse((listDate.length >= 1 && listDate[0] != "") ? listDate[0].toString() : "0"),
        int.parse((listDate.length >= 2 && listDate[1] != "") ? listDate[1].toString() : "0"),
        int.parse((listDate.length >= 3 && listDate[2] != "") ? listDate[2].toString() : "0"),
        int.parse((listTime != null && listTime.length >= 1 && listTime[0] != "") ? listTime[0].toString() : "0"),
        int.parse((listTime != null && listTime.length >= 2 && listTime[1] != "") ? listTime[1].toString() : "0"),
        int.parse((listTime != null && listTime.length >= 3 && listTime[2] != "") ? listTime[2].toString() : "0"),
      );

      if (isUTC!)
        return DateTimeFormat.format(dt.toUtc(), format: formats);
      else
        return DateTimeFormat.format(dt.toLocal(), format: formats);
    } catch (e) {
      return null;
    }
  }

  static int? convertDateStringToMilliseconds({
    @required String? dateString,
    datePattern = '-',
    timePattern = ":",
    @required bool? isUTC,
  }) {
    try {
      if (dateString == null || dateString == "") return null;
      return convertDateStringToDateTime(
        dateString: dateString,
        datePattern: datePattern,
        timePattern: timePattern,
        isUTC: isUTC,
      )!
          .millisecondsSinceEpoch;
    } catch (e) {
      return null;
    }
  }

  static String convertDateTimeToDateString({
    @required DateTime? dateTime,
    String formats = initFormat,
    @required bool? isUTC,
  }) {
    try {
      if (dateTime == null) return "";
      if (isUTC!)
        return DateTimeFormat.format(dateTime.toUtc(), format: formats);
      else
        return DateTimeFormat.format(dateTime.toLocal(), format: formats);
    } catch (e) {
      return "";
    }
  }

  static String convertMillisecondsToDateString({@required int? ms, String formats = initFormat, @required bool? isUTC}) {
    try {
      if (ms == null) return "";
      return convertDateTimeToDateString(
        dateTime: DateTime.fromMillisecondsSinceEpoch(ms),
        formats: formats,
        isUTC: isUTC,
      );
    } catch (e) {
      return "";
    }
  }

  static List<DateTime> getDateTimesForWeek({DateTime? dateTime}) {
    if (dateTime == null) dateTime = DateTime.now();
    switch (dateTime.weekday) {
      case 1:
        return [dateTime, dateTime.add(Duration(days: 6))];
      case 2:
        return [dateTime.subtract(Duration(days: 1)), dateTime.add(Duration(days: 5))];
      case 3:
        return [dateTime.subtract(Duration(days: 2)), dateTime.add(Duration(days: 4))];
      case 4:
        return [dateTime.subtract(Duration(days: 3)), dateTime.add(Duration(days: 3))];
      case 5:
        return [dateTime.subtract(Duration(days: 4)), dateTime.add(Duration(days: 2))];
      case 6:
        return [dateTime.subtract(Duration(days: 5)), dateTime.add(Duration(days: 1))];
      case 7:
        return [dateTime.subtract(Duration(days: 6)), dateTime];
      default:
    }

    return [dateTime, dateTime];
  }

  static List<DateTime> getDateTimesForMonth({DateTime? dateTime}) {
    if (dateTime == null) dateTime = DateTime.now();

    return [
      DateTime(dateTime.year, dateTime.month, 1),
      DateTime(dateTime.year, dateTime.month + 1, 1).subtract(Duration(days: 1)),
    ];
  }

  static generateYears() {
    int establishedYear = AppConfig.establishedYear;
    DateTime now = DateTime.now();
    int diff = now.year - establishedYear + 1;
    return List<int>.generate(diff, (index) => index + establishedYear);
  }

  static generateMonths() {
    return List<int>.generate(12, (index) => index + 1);
  }

  static generateWeekNumbers() {
    return List<int>.generate(5, (index) => index + 1);
  }

  static String getMonthFromNumber(int monthNumber) {
    return DateFormat('MMM').format(DateTime(0, monthNumber));
  }

  static List<Map<String, String>> yearsForDropDown() {
    List<int> data = generateYears();
    return data
        .map((e) => {
              "text": e.toString(),
              "value": e.toString(),
            })
        .toList();
  }

  static List<Map<String, String>> monthsForDropDown() {
    List<int> data = generateMonths();
    return data
        .map((e) => {
              "text": KeicyDateTime.getMonthFromNumber(e),
              "value": e.toString(),
            })
        .toList();
  }

  static List<Map<String, String>> weekNumbersForDropDown() {
    List<int> data = generateWeekNumbers();
    return data
        .map((e) => {
              "text": e.toString(),
              "value": e.toString(),
            })
        .toList();
  }
}
