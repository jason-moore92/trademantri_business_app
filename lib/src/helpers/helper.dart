import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/environment.dart';
import 'dart:math';

bool isProd() {
  return Environment.envName == "production";
}

Future<String> createFileFromByteData(Uint8List data) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  String fullPath = '$dir/test.png';
  File file = File(fullPath);
  await file.writeAsBytes(data);
  return file.path;
}

Future<Uint8List?> bytesFromImageUrl(String path) async {
  try {
    var response = await http.get(Uri.parse(path));

    return response.bodyBytes;
  } catch (e) {
    return null;
  }
}

String getMonthStartDay({int? year, int? month}) {
  DateTime now = DateTime.now();

  if (year == null) {
    year = now.year;
  }
  if (month == null) {
    month = now.month;
  }

  return AppConfig.dateFormatter.format(DateTime(year, month, 1));
}

String getWeekStartDay({int? year, int? month, int? weekNumber}) {
  DateTime now = DateTime.now();

  if (year == null) {
    year = now.year;
  }
  if (month == null) {
    month = now.month;
  }

  if (weekNumber == null) {
    weekNumber = 1;
  }

  int date = (weekNumber * 7) - 6;

  return AppConfig.dateFormatter.format(DateTime(year, month, date));
}

String getMonthEndDay({int? year, int? month}) {
  DateTime now = DateTime.now();

  if (year == null) {
    year = now.year;
  }
  if (month == null) {
    month = now.month;
  }

  return AppConfig.dateFormatter.format(DateTime(year, month + 1, 0));
}

String getWeekEndDay({int? year, int? month, int? weekNumber}) {
  DateTime now = DateTime.now();

  if (year == null) {
    year = now.year;
  }
  if (month == null) {
    month = now.month;
  }

  if (weekNumber == null) {
    weekNumber = 1;
  }

  int date = (weekNumber * 7);
  int monthLastDay = DateTime(year, month + 1, 0).day;

  int finalDate = min(monthLastDay, date);

  return AppConfig.dateFormatter.format(DateTime(year, month, finalDate));
}

String getOrderStatusName(String status) {
  Map<String, String> statusData = AppConfig.orderStatusData.firstWhere((element) => element["id"] == status);
  return statusData["name"] ?? "Unknown";
}
