import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;

class OrderStatusDialog {
  static show(
    BuildContext context, {
    @required String? title,
    @required String? content,
    String okayButtonString = "Ok",
    String cancelButtonString = "Cancel",
    Function()? callback,
  }) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title ?? "",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Text(
            content ?? "",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              color: config.Colors().mainColor(1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              onPressed: () {
                Navigator.of(context).pop();
                if (callback != null) callback();
              },
              child: Text(
                okayButtonString,
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Color(0xFFB3B3B3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Text(
                cancelButtonString,
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
