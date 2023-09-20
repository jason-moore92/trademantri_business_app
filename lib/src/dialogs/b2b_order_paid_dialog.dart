import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/pages/transaction_item.dart';
import 'package:trapp/src/providers/RefreshProvider/refresh_provider.dart';

class B2BOrderPaidDialog {
  static show(
    BuildContext context, {
    @required String? title,
    @required String? content,
    Function(File?)? callback,
  }) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double heightDp = ScreenUtil().setWidth(1);
    double widthDp = ScreenUtil().setWidth(1);
    File? file;

    showDialog(
      context: context,
      builder: (context) {
        return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
          return SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
            title: Text(
              "${title}",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            titlePadding: EdgeInsets.only(
              left: heightDp * 10,
              right: heightDp * 10,
              top: heightDp * 20,
              bottom: heightDp * 5,
            ),
            contentPadding: EdgeInsets.only(
              left: heightDp * 15,
              right: heightDp * 15,
              top: heightDp * 5,
              bottom: heightDp * 20,
            ),
            children: [
              Text(
                "${content}",
                style: TextStyle(fontSize: fontSp * 15, color: Colors.black, height: 1.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heightDp * 20),
              Text(
                "Do you want to upload proof of payment for this order?",
                style: TextStyle(fontSize: fontSp * 13, color: Colors.black, height: 1.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heightDp * 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      file == null ? "Select Image File" : file!.path.split("/").last,
                      style: TextStyle(fontSize: fontSp * 13, color: Colors.black, height: 1.5),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: widthDp * 5),
                  KeicyRaisedButton(
                    width: widthDp * 100,
                    height: heightDp * 35,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 6,
                    child: Text(
                      "Select",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                    onPressed: () {
                      ImageFilePickDialog.show(context, callback: (List<File?>? fileList) {
                        if (fileList != null && fileList.isNotEmpty) {
                          file = fileList.first;
                          refreshProvider.refresh();
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: heightDp * 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (callback != null) callback(file);
                    },
                    color: config.Colors().mainColor(1),
                    child: Text(
                      "Payment Received",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }
}
