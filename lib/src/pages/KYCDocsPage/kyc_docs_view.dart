import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/pages/DocViewPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class KYCDocsView extends StatefulWidget {
  KYCDocsView({Key? key}) : super(key: key);

  @override
  _KYCDocsViewState createState() => _KYCDocsViewState();
}

class _KYCDocsViewState extends State<KYCDocsView> {
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

  KYCDocsProvider? _kycDocsProvider;
  AuthProvider? _authProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  Map<String, dynamic>? _kycDocsData;

  bool _initialized = false;

  bool _isUploadable = false;

  TapGestureRecognizer? _tapGestureRecognizer;

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
    _kycDocsProvider = KYCDocsProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _initialized = false;
    _isUploadable = false;

    _tapGestureRecognizer = TapGestureRecognizer();
    _tapGestureRecognizer!.onTap = () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => DocViewPage(
            appBarTitle: "KYC	Documents	Help",
            doc: AppConfig.kycDocHelpLink,
          ),
        ),
      );
    };

    _kycDocsProvider!.setKYCDocsState(
      _kycDocsProvider!.kycDocsState.update(progressState: 0, kycDocsData: Map<String, dynamic>()),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _kycDocsProvider!.addListener(_kycDocsProviderListener);
      _kycDocsProvider!.setKYCDocsState(_kycDocsProvider!.kycDocsState.update(progressState: 1), isNotifiable: false);
      _kycDocsProvider!.getKYCDocs(
        storeUserId: _authProvider!.authState.businessUserModel!.id,
        storeId: _authProvider!.authState.storeModel!.id,
      );
    });
  }

  @override
  void dispose() {
    _kycDocsProvider!.removeListener(_kycDocsProviderListener);
    super.dispose();
  }

  void _kycDocsProviderListener() async {
    if (_kycDocsProvider!.kycDocsState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_kycDocsProvider!.kycDocsState.progressState == 2 && !_initialized) {
      _initialized = true;
    } else if (_kycDocsProvider!.kycDocsState.progressState == 2 && _initialized) {
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp);
      _kycDocsData = json.decode(json.encode(_kycDocsProvider!.kycDocsState.kycDocsData!["documents"]));
      _isUploadable = false;
      setState(() {});
    } else if (_kycDocsProvider!.kycDocsState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _kycDocsProvider!.kycDocsState.message!,
      );
    }
  }

  void _selectFileHandler(String type, Map<String, dynamic> documentType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null) {
      double size = result.files.single.size / 1024 / 1024;
      if (size > 3) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "The uploaded document is over 3mb size, please reduce the size and upload again",
        );
        return;
      }
      documentType["file"] = File(result.files.single.path!);
      setState(() {
        documentType["path"] = result.files.single.path!.split("/").last;
        documentType["status"] = "Selected";
      });
    }

    _kycDocsData!.forEach((type, data) {
      if (data["file"] != null) {
        _isUploadable = true;
      }
    });
    setState(() {});
  }

  void _uploadHandler() async {
    await _keicyProgressDialog!.show();
    _kycDocsProvider!.updateKYCDocs(
      storeUserId: _kycDocsProvider!.kycDocsState.kycDocsData!["storeUserId"],
      storeId: _kycDocsProvider!.kycDocsState.kycDocsData!["storeId"],
      kycDocs: _kycDocsData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: config.Colors().mainColor(1),
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          KYCDocsPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
        ),
        elevation: 0,
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: _isUploadable
                    ? () {
                        _uploadHandler();
                      }
                    : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  color: Colors.transparent,
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: fontSp * 18,
                      color: Colors.white.withOpacity(_isUploadable ? 1 : 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<KYCDocsProvider>(builder: (context, kycDocsProvider, _) {
        if (kycDocsProvider.kycDocsState.progressState == -1 && kycDocsProvider.kycDocsState.kycDocsData!.isEmpty) {
          return ErrorPage(
            message: kycDocsProvider.kycDocsState.message,
            callback: () {
              kycDocsProvider.setKYCDocsState(kycDocsProvider.kycDocsState.update(progressState: 1), isNotifiable: false);
              kycDocsProvider.getKYCDocs(
                storeUserId: _authProvider!.authState.businessUserModel!.id,
                storeId: _authProvider!.authState.storeModel!.id,
              );
            },
          );
        }

        if (kycDocsProvider.kycDocsState.kycDocsData!.isEmpty ||
            kycDocsProvider.kycDocsState.progressState == 0 ||
            kycDocsProvider.kycDocsState.progressState == 1) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (_kycDocsData == null) _kycDocsData = json.decode(json.encode(kycDocsProvider.kycDocsState.kycDocsData!["documents"]));

        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceWidth,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: KYCDocsPageString.description1, style: TextStyle(fontSize: fontSp * 15, color: Colors.black)),
                        TextSpan(
                          text: KYCDocsPageString.description2,
                          style: TextStyle(fontSize: fontSp * 15, color: Colors.blue, fontWeight: FontWeight.w500),
                          recognizer: _tapGestureRecognizer,
                        ),
                        TextSpan(text: KYCDocsPageString.description3, style: TextStyle(fontSize: fontSp * 15, color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: heightDp * 20),
                  Column(
                    children: List.generate(_kycDocsData!.length, (index) {
                      String type = _kycDocsData!.keys.toList()[index];
                      Map<String, dynamic> documentType = _kycDocsData![type];
                      return Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: fontSp * 15 / 2, bottom: heightDp * 20),
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(heightDp * 8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  documentType["path"] == null || documentType["path"] == "" ? KYCDocsPageString.choose : documentType["path"],
                                  style: TextStyle(
                                    fontSize: fontSp * 15,
                                    color: Colors.black,
                                    fontWeight: documentType["path"] == null || documentType["path"] == "" ? FontWeight.w400 : FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: heightDp * 20),
                                Text(
                                  "Status: ${documentType["status"]}",
                                  style: TextStyle(fontSize: fontSp * 15, color: Colors.black),
                                ),
                                SizedBox(height: heightDp * 20),
                                if (!(kycDocsProvider.kycDocsState.kycDocsData != null &&
                                    kycDocsProvider.kycDocsState.kycDocsData!['verified'] != null &&
                                    kycDocsProvider.kycDocsState.kycDocsData!["verified"]))
                                  KeicyRaisedButton(
                                    width: widthDp * 150,
                                    height: heightDp * 40,
                                    color: config.Colors().mainColor(1),
                                    borderRadius: heightDp * 8,
                                    child: Text(
                                      KYCDocsPageString.select,
                                      style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _selectFileHandler(type, documentType);
                                    },
                                  ),
                                if (type == "letterOfUndertaking")
                                  Column(
                                    children: [
                                      SizedBox(height: heightDp * 20),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => DocViewPage(
                                                doc: AppConfig.letterSampleDoc,
                                                appBarTitle: '',
                                                isShare: true,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: KYCDocsPageString.letterOfUndertakingDesc1,
                                                  style: TextStyle(fontSize: fontSp * 12, color: Colors.black, height: 1.5),
                                                ),
                                                TextSpan(
                                                  text: KYCDocsPageString.letterOfUndertakingDesc2,
                                                  style: TextStyle(
                                                    fontSize: fontSp * 14,
                                                    color: config.Colors().mainColor(1),
                                                    height: 1.5,
                                                    decoration: TextDecoration.underline,
                                                    decorationColor: config.Colors().mainColor(1),
                                                    decorationStyle: TextDecorationStyle.solid,
                                                    decorationThickness: 2,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: KYCDocsPageString.letterOfUndertakingDesc3,
                                                  style: TextStyle(fontSize: fontSp * 12, color: Colors.black, height: 1.5),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: widthDp * 20,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                              color: Colors.white,
                              child: Text(
                                documentType["title"],
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
