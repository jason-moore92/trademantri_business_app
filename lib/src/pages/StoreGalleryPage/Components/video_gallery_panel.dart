import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:json_diff/json_diff.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/video_media_widget.dart';
import 'package:trapp/src/elements/youtube_video_widget.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class VideoGalleryPanel extends StatefulWidget {
  VideoGalleryPanel({Key? key}) : super(key: key);

  @override
  _VideoGalleryPanelState createState() => _VideoGalleryPanelState();
}

class _VideoGalleryPanelState extends State<VideoGalleryPanel> with SingleTickerProviderStateMixin {
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

  Map<String, dynamic> _videoGalleryData = Map<String, dynamic>();

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

    if (_authProvider!.authState.galleryData!["videos"] == null) _authProvider!.authState.galleryData!["videos"] = Map<String, dynamic>();

    _authProvider!.authState.galleryData!["videos"].forEach((date, imageData) {
      if (imageData.isNotEmpty) _videoGalleryData[date] = List.from(imageData);
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool checkUpdating() {
    for (var i = 0; i < _videoGalleryData.length; i++) {
      String date = _videoGalleryData.keys.toList()[i];
      List<dynamic> videoList = _videoGalleryData[date];

      for (var i = 0; i < videoList.length; i++) {
        if (videoList[i]["file"] != null) {
          return true;
        }
      }
    }

    JsonDiffer jsonDiffer = JsonDiffer.fromJson(
      _videoGalleryData,
      _authProvider!.authState.galleryData == null
          ? Object()
          : _authProvider!.authState.galleryData!["videos"] == null
              ? Object()
              : _authProvider!.authState.galleryData!["videos"],
    );
    return !jsonDiffer.diff().hasNothing;
  }

  void _saveHandler() async {
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();

    int totalCount = 0;

    for (var i = 0; i < _videoGalleryData.length; i++) {
      String date = _videoGalleryData.keys.toList()[i];
      List<dynamic> videoList = [];

      for (var i = 0; i < _videoGalleryData[date].length; i++) {
        if (_videoGalleryData[date][i]["file"] != null) {
          String fileName = _videoGalleryData[date][i]["file"].path.split('/').last;
          var result = await UploadFileApiProvider.uploadFile(
            file: _videoGalleryData[date][i]["file"],
            directoryName: "StoreGallery/Videos/",
            fileName: fileName,
            bucketName: "STORE_GALLERY_BUCKET",
          );

          if (result["success"]) {
            //TODO:: add file size to `_videoGalleryData[date][i]`
            _videoGalleryData[date][i]["path"] = result["data"];
            _videoGalleryData[date][i].remove("file");
            totalCount++;
            videoList.add(_videoGalleryData[date][i]);
          } else {
            _videoGalleryData[date][i].remove("file");
          }
        } else {
          totalCount++;
          videoList.add(_videoGalleryData[date][i]);
        }
      }
      _videoGalleryData[date] = videoList;
    }

    var result = await StoreGalleryApiProvider.update(galleryData: {
      "storeId": _authProvider!.authState.galleryData!["storeId"],
      "images": _authProvider!.authState.galleryData!["images"],
      "videos": _videoGalleryData,
    });

    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _authProvider!.setAuthState(_authProvider!.authState.update(
        galleryData: result["data"],
      ));

      String message = "";
      if (totalCount == 0) {
        message = "Video Deleted Successfully";
      } else if (totalCount == 1) {
        message = "Video Uploaded Successfully";
      } else if (totalCount > 1) {
        message = "Videos Uploaded Successfully";
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

  void _deleteVideo(String date, int index) async {
    _videoGalleryData[date].removeAt(_videoGalleryData[date].length - 1 - index);
    if (_videoGalleryData[date].isEmpty) {
      _videoGalleryData.remove(date);
    }
    await _keicyProgressDialog!.show();
    var result = await StoreGalleryApiProvider.update(
      galleryData: {
        "storeId": _authProvider!.authState.galleryData!["storeId"],
        "images": _authProvider!.authState.galleryData!["images"],
        "videos": _videoGalleryData,
      },
    );

    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _authProvider!.setAuthState(_authProvider!.authState.update(
        galleryData: result["data"],
      ));

      String message = "";
      message = "Video Deleted Successfully";
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoPlayProvider()),
      ],
      child: Scaffold(
        body: Container(
          width: deviceWidth,
          child: _mainPanel(),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    int fileImageCount = 0;
    _videoGalleryData.forEach((date, galleryData) {
      for (var i = 0; i < galleryData.length; i++) {
        if (galleryData[i]["type"] == "file") {
          fileImageCount++;
        }
      }
    });

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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Add Videos that can be used for your business marketing",
                            style: TextStyle(fontSize: fontSp * 14),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        ///
                        SizedBox(height: heightDp * 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            KeicyRaisedButton(
                              width: widthDp * 100,
                              height: heightDp * 35,
                              color: config.Colors().mainColor(1),
                              borderRadius: heightDp * 6,
                              child: Text(
                                "Add",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                              ),
                              onPressed: () async {
                                VideoPickDialog.show(
                                  context,
                                  fileLengthLimit: fileImageCount,
                                  limitSize: AppConfig.galleryVideoLimitSize,
                                  callback: (Map<String, dynamic>? videoData) {
                                    if (videoData == null) return;
                                    videoData["date"] = DateTime.now().toUtc().toIso8601String();
                                    String date = KeicyDateTime.convertDateTimeToDateString(dateTime: DateTime.now(), isUTC: false);
                                    if (_videoGalleryData[date] == null) _videoGalleryData[date] = [];
                                    _videoGalleryData[date].add(videoData);
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ///
                  Container(
                    width: deviceWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_videoGalleryData.length, (index) {
                        String date = _videoGalleryData.keys.toList()[_videoGalleryData.length - 1 - index];
                        List<dynamic> videoList = _videoGalleryData[date];

                        return Column(
                          children: List.generate(videoList.length, (index) {
                            Map<String, dynamic> videoData = videoList[videoList.length - 1 - index];

                            return Column(
                              children: [
                                if (videoData["type"] == "youtube")
                                  YoutubeVideoWidget(
                                    videoData: videoData,
                                    index: index,
                                  )
                                else
                                  VideoMediaWidget(
                                    videoData: videoData,
                                    index: index,
                                  ),
                                IconButton(
                                  padding: EdgeInsets.all(heightDp * 2),
                                  icon: Icon(Icons.delete, size: heightDp * 25, color: Colors.black),
                                  onPressed: () {
                                    // _videoGalleryData[date].removeAt(index);
                                    // if (_videoGalleryData[date].isEmpty) _videoGalleryData.remove(date);
                                    // setState(() {});
                                    _deleteVideo(date, index);
                                  },
                                ),
                              ],
                            );
                          }),
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
        SizedBox(height: heightDp * 20),
      ],
    );
  }
}
