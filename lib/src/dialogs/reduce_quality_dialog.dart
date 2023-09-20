import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;

class ReduceQualityDialog {
  static show(
    BuildContext context, {
    @required double? widthDp,
    @required double? heightDp,
    @required double? fontSp,
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    String text = "Failed!",
    bool barrierDismissible = false,
    Function? callBack,
    Function? cancelCallback,
    int delaySecondes = 2,
  }) async {
    var result = await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
          titlePadding: titlePadding ?? EdgeInsets.zero,
          contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: widthDp! * 20, vertical: heightDp * 20),
          children: [
            Text(
              "You are changing the quantity of items that your customer ordered. You dont have enough quantity available in the store?",
              style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightDp * 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KeicyRaisedButton(
                  width: heightDp * 130,
                  height: heightDp * 40,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 6,
                  padding: EdgeInsets.symmetric(horizontal: widthDp! * 5),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    if (callBack != null) {
                      callBack();
                    }
                  },
                  child: Text(
                    'Reduce Quantity',
                    style: TextStyle(color: Colors.white, fontSize: fontSp * 12),
                  ),
                ),
                SizedBox(width: widthDp * 15),
                KeicyRaisedButton(
                  width: heightDp * 130,
                  height: heightDp * 40,
                  borderRadius: heightDp * 6,
                  color: Colors.white,
                  borderColor: Colors.grey.withOpacity(0.6),
                  borderWidth: 1,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black, fontSize: fontSp * 12),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result == null && cancelCallback != null) {
      cancelCallback();
    }
  }
}
