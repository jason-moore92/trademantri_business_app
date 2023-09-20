import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class GalleryPanel extends StatefulWidget {
  GalleryPanel({Key? key}) : super(key: key);

  @override
  _GalleryPanelState createState() => _GalleryPanelState();
}

class _GalleryPanelState extends State<GalleryPanel> with SingleTickerProviderStateMixin {
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

  BusinessCardModel? _businessCardModel;

  KeicyProgressDialog? _keicyProgressDialog;

  double galleryWidth = 0;
  double galleryHeight = 0;
  double galleryPadding = 0;

  List<dynamic> _gallery = [];

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

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _businessCardModel = BusinessCardModel.copy(AuthProvider.of(context).authState.businessCardModel!);
    _businessCardModel!.storeId = AuthProvider.of(context).authState.storeModel!.id;
    _businessCardModel!.userId = AuthProvider.of(context).authState.businessUserModel!.id;

    _gallery = [];
    for (var i = 0; i < _businessCardModel!.gallery!.length; i++) {
      _gallery.add(_businessCardModel!.gallery![i]);
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveHandler() async {
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    List<dynamic> newGallery = [];
    for (var i = 0; i < _gallery.length; i++) {
      var imageData = _gallery[i];
      String imageDataType = imageData.runtimeType.toString();
      if (imageDataType == "String") {
        newGallery.add(imageData);
        continue;
      }

      String fileName = _businessCardModel!.storeId!;
      fileName += "_" + _businessCardModel!.userId!;
      fileName += "_" + imageData.path.split('/').last;

      var result = await UploadFileApiProvider.uploadFile(
        file: imageData,
        directoryName: "BusinessCard/Gallery/",
        fileName: fileName,
        bucketName: "STORE_PROFILE_BUCKET_NAME",
      );

      if (result["success"]) {
        newGallery.add(result["data"]);
      }
    }

    _gallery = newGallery;

    var result = await BusinessCardApiProvider.updateGalleryOfMyBusinessCard(gallery: _gallery);

    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _businessCardModel = BusinessCardModel.fromJson(result["data"]);

      String message = "";
      if (_gallery.length == 0) {
        message = "Image deleted successfully";
      } else if (_gallery.length == 1) {
        message = "Image uploaded successfully";
      } else if (_gallery.length > 1) {
        message = "Images uploaded successfully";
      }
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: message,
      );
      AuthProvider.of(context).setAuthState(
        AuthProvider.of(context).authState.update(
              businessCardModel: _businessCardModel,
            ),
      );
      _gallery = [];
      for (var i = 0; i < _businessCardModel!.gallery!.length; i++) {
        _gallery.add(_businessCardModel!.gallery![i]);
      }
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

  void _deleteImage(int index) async {
    _gallery.removeAt(_gallery.length - 1 - index);
    await _keicyProgressDialog!.show();
    var result = await BusinessCardApiProvider.updateGalleryOfMyBusinessCard(gallery: _gallery);

    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _businessCardModel = BusinessCardModel.fromJson(result["data"]);

      String message = "";
      message = "Image Deleted Successfully";
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: message,
      );
      AuthProvider.of(context).setAuthState(
        AuthProvider.of(context).authState.update(
              businessCardModel: _businessCardModel,
            ),
      );
      _gallery = [];
      for (var i = 0; i < _businessCardModel!.gallery!.length; i++) {
        _gallery.add(_businessCardModel!.gallery![i]);
      }
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
    galleryWidth = ((deviceWidth - widthDp * 30) - galleryPadding * 2) / 3;
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
                      "Gallery",
                      style: TextStyle(fontSize: fontSp * 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: heightDp * 10),
                  Center(
                    child: Text(
                      "Add/Delete photos that can be used for business marketing",
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
                          color: _gallery.length >= 100 ? Colors.red : Colors.transparent,
                        ),
                      ),
                      KeicyRaisedButton(
                        width: widthDp * 100,
                        height: heightDp * 35,
                        color: _gallery.length >= 100 ? Colors.grey : config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        child: Text(
                          "Add",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                        onPressed: _gallery.length >= 100
                            ? null
                            : () async {
                                ImageFilePickDialog.show(
                                  context,
                                  callback: (List<File>? files) {
                                    if (files == null) return;
                                    setState(() {
                                      // _gallery.add(file);
                                      _gallery..addAll(files);
                                    });
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
                    child: Wrap(
                      spacing: galleryPadding,
                      // runSpacing: galleryPadding,
                      children: List.generate(_gallery.length, (index) {
                        int length = _gallery.length;
                        var imageData = _gallery[length - 1 - index];
                        String imageDataType = imageData.runtimeType.toString();

                        if (imageDataType == "String") {
                          return Column(
                            children: [
                              KeicyAvatarImage(
                                url: imageData,
                                width: galleryWidth,
                                height: galleryHeight,
                              ),
                              IconButton(
                                padding: EdgeInsets.all(heightDp * 2),
                                icon: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                                onPressed: () {
                                  _deleteImage(index);
                                },
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              KeicyAvatarImage(
                                url: "",
                                width: galleryWidth,
                                height: galleryHeight,
                                imageFile: imageData,
                              ),
                              IconButton(
                                padding: EdgeInsets.all(heightDp * 2),
                                icon: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                                onPressed: () {
                                  _gallery.removeAt(length - 1 - index);
                                  setState(() {});
                                },
                              ),
                            ],
                          );
                        }
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
            color: _gallery.length == AuthProvider.of(context).authState.businessCardModel!.gallery!.length
                ? Colors.grey.withOpacity(0.7)
                : config.Colors().mainColor(1),
            borderRadius: heightDp * 6,
            child: Text(
              "Save",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
            ),
            onPressed: _gallery.length == AuthProvider.of(context).authState.businessCardModel!.gallery!.length ? null : _saveHandler,
          ),
        ),
      ],
    );
  }
}
