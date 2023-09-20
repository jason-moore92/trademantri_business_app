import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentLocationDialog {
  static show(
    BuildContext context, {
    @required Function? okCallback,
    @required Function? cancelCallback,
  }) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "Do you want to find the stores in current location",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                okCallback!();
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                cancelCallback!();
              },
              child: Text(
                "Cancel",
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
