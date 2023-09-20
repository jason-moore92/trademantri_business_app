import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;

class NormalAskDialog {
  static show(
    BuildContext context, {
    String title = "",
    String content = "",
    String okayButton = "Ok",
    String cancelButton = "Cancel",
    Function? callback,
  }) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          titlePadding: title == "" ? EdgeInsets.zero : null,
          content: Text(
            content,
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              color: config.Colors().mainColor(1),
              onPressed: () {
                Navigator.of(context).pop();
                if (callback != null) {
                  callback();
                }
              },
              child: Text(
                okayButton,
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                cancelButton,
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
