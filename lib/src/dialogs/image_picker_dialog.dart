import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trapp/src/dialogs/index.dart';

class ImageFilePickDialog {
  static Future<void> show(
    BuildContext context, {
    double? maxWidth,
    double? maxHeight,
    double? limitSize,
    Function(List<File>?)? callback,
    bool allowMultiple = true,
  }) async {
    double deviceWidth = 1.sw;
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    ImagePicker picker = ImagePicker();

    Future _getFile(ImageSource source) async {
      var pickedFile = await picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFile != null && callback != null) {
        if (limitSize != null) {
          double size = (await pickedFile.readAsBytes()).length / 1024 / 1024;
          if (size > limitSize) {
            ErrorDialog.show(
              context,
              widthDp: widthDp,
              heightDp: heightDp,
              fontSp: fontSp,
              text: "This file size is ${size.toStringAsFixed(2)} Mb.\nYou can select the file at most ${limitSize} Mb",
            );
            return;
          }
        }
        callback([File(pickedFile.path)]);
      } else {
        FlutterLogs.logWarn("image_picker_dialog", "_getFile", "No image selected.");
      }
    }

    Future _getFiles() async {
      List<XFile>? pickedFiles = await picker.pickMultiImage(
        // source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFiles == null) {
        return;
      }
      List<XFile> finalizedPickedFiles = [];
      List<XFile> nonFinalizedPickedFiles = [];

      for (var i = 0; i < pickedFiles.length; i++) {
        var pickedFile = pickedFiles[i];

        if (limitSize != null) {
          double size = (await pickedFile.readAsBytes()).length / 1024 / 1024;

          if (size > limitSize) {
            // ErrorDialog.show(
            //   context,
            //   widthDp: widthDp,
            //   heightDp: heightDp,
            //   fontSp: fontSp,
            //   text: "This file size is ${size.toStringAsFixed(2)} Mb.\nYou can select the file at most ${limitSize} Mb",
            // );
            // return;
            nonFinalizedPickedFiles.add(pickedFile);
          } else {
            finalizedPickedFiles.add(pickedFile);
          }
        } else {
          finalizedPickedFiles.add(pickedFile);
        }
      }

      if (nonFinalizedPickedFiles.length > 0) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          // text: "This file size is ${size.toStringAsFixed(2)} Mb.\nYou can select the file at most ${limitSize} Mb",
          text: "Files that are exceded ${limitSize} Mb are filtered out",
        );
      }

      if (callback != null) {
        callback(finalizedPickedFiles.map((e) => File(e.path)).toList());
      }
    }

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              Container(
                child: Container(
                  padding: EdgeInsets.all(heightDp * 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: deviceWidth,
                        padding: EdgeInsets.all(heightDp * 10.0),
                        child: Text(
                          "Choose Option",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _getFile(ImageSource.camera);
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black.withOpacity(0.7),
                                size: heightDp * 25.0,
                              ),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Camera",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (allowMultiple) {
                            _getFiles();
                          } else {
                            _getFile(ImageSource.gallery);
                          }
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.photo, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Gallery",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
