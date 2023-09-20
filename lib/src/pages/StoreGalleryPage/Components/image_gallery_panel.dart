import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:json_diff/json_diff.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/full_image_widget.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/helpers/helper.dart';

class ImageGalleryPanel extends StatefulWidget {
  ImageGalleryPanel({Key? key}) : super(key: key);

  @override
  _ImageGalleryPanelState createState() => _ImageGalleryPanelState();
}

class _ImageGalleryPanelState extends State<ImageGalleryPanel> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  AuthProvider? _authProvider;

  KeicyProgressDialog? _keicyProgressDialog;

  double galleryWidth = 0;
  double galleryHeight = 0;
  double galleryPadding = 0;

  Map<String, dynamic> _imageGalleryData = Map<String, dynamic>();

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    if (_authProvider!.authState.galleryData!["images"] == null) _authProvider!.authState.galleryData!["images"] = Map<String, dynamic>();
    _authProvider!.authState.galleryData!["images"].forEach((date, imageData) {
      if (imageData.isNotEmpty) _imageGalleryData[date] = List.from(imageData);
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool checkUpdating() {
    for (var i = 0; i < _imageGalleryData.length; i++) {
      String date = _imageGalleryData.keys.toList()[i];
      List<dynamic> imageList = _imageGalleryData[date];

      for (var i = 0; i < imageList.length; i++) {
        if (imageList[i]["file"] != null) {
          return true;
        }
      }
    }

    JsonDiffer jsonDiffer = JsonDiffer.fromJson(
      _imageGalleryData,
      _authProvider!.authState.galleryData == null
          ? Object()
          : _authProvider!.authState.galleryData!["images"] == null
              ? Object()
              : _authProvider!.authState.galleryData!["images"],
    );

    return !jsonDiffer.diff().hasNothing;
  }

  void _saveHandler() async {
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    int length = _imageGalleryData.length;

    int totalCount = 0;

    for (var i = 0; i < length; i++) {
      String date = _imageGalleryData.keys.toList()[i];
      List<dynamic> imageList = [];

      for (var i = 0; i < _imageGalleryData[date].length; i++) {
        if (_imageGalleryData[date][i]["file"] != null) {
          String fileName = _imageGalleryData[date][i]["file"].path.split('/').last;

          var result = await UploadFileApiProvider.uploadFile(
            file: _imageGalleryData[date][i]["file"],
            directoryName: "StoreGallery/Images/",
            fileName: fileName,
            bucketName: "STORE_GALLERY_BUCKET",
          );

          if (result["success"]) {
            //TODO:: add file size to `_videoGalleryData[date][i]`
            _imageGalleryData[date][i]["path"] = result["data"];
            _imageGalleryData[date][i].remove("file");
            imageList.add(_imageGalleryData[date][i]);
            totalCount++;
          } else {
            _imageGalleryData[date][i].remove("file");
          }
        } else {
          totalCount++;
          imageList.add(_imageGalleryData[date][i]);
        }
      }
      _imageGalleryData[date] = imageList;
    }

    var result = await StoreGalleryApiProvider.update(galleryData: {
      "storeId": _authProvider!.authState.galleryData!["storeId"],
      "images": _imageGalleryData,
      "videos": _authProvider!.authState.galleryData!["videos"],
    });

    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _authProvider!.setAuthState(_authProvider!.authState.update(
        galleryData: result["data"],
      ));

      String message = "";
      if (totalCount == 0) {
        message = "Image Deleted Successfully";
      } else if (totalCount == 1) {
        message = "Image Uploaded Successfully";
      } else if (totalCount > 1) {
        message = "Images Uploaded Successfully";
      }

      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: message,
      );
      setState(() {});
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"] ?? "Something was wrong",
      );
    }
  }

  void _deleteImage(String date, int index) async {
    _imageGalleryData[date].removeAt(_imageGalleryData[date].length - 1 - index);
    if (_imageGalleryData[date].isEmpty) {
      _imageGalleryData.remove(date);
    }
    await _keicyProgressDialog!.show();
    var result = await StoreGalleryApiProvider.update(
      galleryData: {
        "storeId": _authProvider!.authState.galleryData!["storeId"],
        "images": _imageGalleryData,
        "videos": _authProvider!.authState.galleryData!["videos"],
      },
    );

    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _authProvider!.setAuthState(_authProvider!.authState.update(
        galleryData: result["data"],
      ));

      String message = "";
      message = "Image Deleted Successfully";
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: message,
      );
      setState(() {});
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"] ?? "Something was wrong",
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    galleryPadding = widthDp * 5;
    galleryWidth = ((deviceWidth - widthDp * 40) - galleryPadding * 2) / 3;
    galleryHeight = galleryWidth;

    return Scaffold(
      body: Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
        child: _mainPanel(),
      ),
    );
  }

  Widget _mainPanel() {
    return Column(
      children: [
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Add Images that can be used for your business marketing",
                      style: TextStyle(fontSize: fontSp * 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "You can uploaded images at most 100 ",
                        style: TextStyle(
                          fontSize: fontSp * 12,
                          color: _imageGalleryData.length >= 100 ? Colors.red : Colors.transparent,
                        ),
                      ),
                      KeicyRaisedButton(
                        width: widthDp * 100,
                        height: heightDp * 35,
                        color: _imageGalleryData.length >= 100 ? Colors.grey : config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        child: Text(
                          "Add",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                        onPressed: _imageGalleryData.length >= 100
                            ? null
                            : () async {
                                ImageFilePickDialog.show(
                                  context,
                                  limitSize: AppConfig.galleryImageLimitSize,
                                  callback: (List<File>? files) {
                                    if (files == null) {
                                      return;
                                    }
                                    for (var i = 0; i < files.length; i++) {
                                      File file = files[i];

                                      String date = KeicyDateTime.convertDateTimeToDateString(dateTime: DateTime.now(), isUTC: false);
                                      if (_imageGalleryData[date] == null) _imageGalleryData[date] = [];
                                      _imageGalleryData[date].add({
                                        "file": file,
                                        "date": DateTime.now().toUtc().toIso8601String(),
                                      });
                                    }
                                    setState(() {});
                                  },
                                  allowMultiple: true,
                                );
                              },
                      ),
                    ],
                  ),

                  ///
                  SizedBox(height: heightDp * 20),
                  Container(
                    width: deviceWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_imageGalleryData.length, (index) {
                        String date = _imageGalleryData.keys.toList()[_imageGalleryData.length - 1 - index];
                        List<dynamic> imageList = _imageGalleryData[date];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(height: heightDp * 2, thickness: 2, color: Colors.grey.withOpacity(0.4)),
                            SizedBox(height: heightDp * 10),
                            Text(
                              KeicyDateTime.convertDateTimeToDateString(
                                dateTime: DateTime.tryParse(date)!.toLocal(),
                                formats: "D, d M Y",
                                isUTC: false,
                              ),
                              style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: heightDp * 15),
                            Wrap(
                              spacing: galleryPadding,
                              runSpacing: galleryPadding,
                              children: List.generate(imageList.length, (index) {
                                Map<String, dynamic> imageData = imageList[imageList.length - 1 - index];

                                if (imageData["file"] != null) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) => FullImageWidget(
                                                bytes: imageData["file"].readAsBytesSync(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: KeicyAvatarImage(
                                          url: "",
                                          width: galleryWidth,
                                          height: galleryHeight,
                                          imageFile: imageData["file"],
                                          backColor: Colors.grey.withOpacity(0.6),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.all(heightDp * 2),
                                        icon: Icon(Icons.delete, size: heightDp * 25, color: Colors.black),
                                        onPressed: () {
                                          _imageGalleryData[date].removeAt(imageList.length - 1 - index);
                                          if (_imageGalleryData[date].isEmpty) _imageGalleryData.remove(date);

                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await _keicyProgressDialog!.show();
                                          Uint8List? bytes = await bytesFromImageUrl(imageData["path"]);
                                          await _keicyProgressDialog!.hide();
                                          if (bytes != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder: (BuildContext context) => FullImageWidget(
                                                  bytes: bytes,
                                                ),
                                              ),
                                            );
                                          } else {
                                            ErrorDialog.show(
                                              context,
                                              widthDp: widthDp,
                                              heightDp: heightDp,
                                              fontSp: fontSp,
                                              text: "Loading Image Byte Data error",
                                            );
                                          }
                                        },
                                        child: KeicyAvatarImage(
                                          url: imageData["path"],
                                          width: galleryWidth,
                                          height: galleryHeight,
                                          backColor: Colors.grey.withOpacity(0.6),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.all(heightDp * 2),
                                        icon: Icon(Icons.delete, size: heightDp * 25, color: Colors.black),
                                        onPressed: () {
                                          // _imageGalleryData[date].removeAt(imageList.length - 1 - index);
                                          // if (_imageGalleryData[date].isEmpty) _imageGalleryData.remove(date);

                                          // setState(() {});
                                          _deleteImage(date, index);
                                        },
                                      ),
                                    ],
                                  );
                                }
                              }),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        ///
        SizedBox(height: heightDp * 20),
        Center(
          child: KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            color: checkUpdating() ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
            borderRadius: heightDp * 6,
            child: Text(
              "Save",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
            ),
            onPressed: checkUpdating() ? _saveHandler : null,
          ),
        ),
      ],
    );
  }
}
