import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:trapp/src/elements/print_widget.dart';
import 'package:trapp/src/elements/qr_code_widget.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class UPIStandView extends StatefulWidget {
  UPIStandView({Key? key}) : super(key: key);

  @override
  _UPIStandViewState createState() => _UPIStandViewState();
}

class _UPIStandViewState extends State<UPIStandView> {
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

  ScreenshotController screenshotController = ScreenshotController();

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
  }

  @override
  void dispose() {
    super.dispose();
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
          UPIStandPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
        ),
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  if (AuthProvider.of(context).authState.storeModel!.iciciData != null) ...[
                    PrintWidget(
                      path: "",
                      // qrCodePageImage: _qrCodeImage,
                      qrCodeGen: () async {
                        Uint8List? qrCodeImage = await screenshotController.capture();
                        return qrCodeImage;
                      },
                      size: heightDp * 30,
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Uint8List? qrCodeImage = await screenshotController.capture();
                        if (qrCodeImage == null) {
                          return;
                        }
                        String filePath = await createFileFromByteData(qrCodeImage);
                        Share.shareFiles([filePath]);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
                        child: Icon(Icons.share, size: heightDp * 25, color: Colors.white),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: Container(
            width: deviceWidth,
            padding: EdgeInsets.symmetric(
              horizontal: widthDp * 20,
              vertical: heightDp * 20,
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  16,
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: heightDp * 10),
                  Image.asset(
                    "img/logo.png",
                    width: deviceWidth * 0.5,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(height: heightDp * 10),
                  if (AuthProvider.of(context).authState.storeModel!.iciciData == null)
                    Center(
                      child: Text("Your UPI address is not yet generated."),
                    ),
                  if (AuthProvider.of(context).authState.storeModel!.iciciData != null) ...[
                    // Text(
                    //   "Store UPI QR Code",
                    //   style: TextStyle(
                    //     fontSize: fontSp * 24,
                    //   ),
                    // ),
                    // SizedBox(height: heightDp * 20),
                    QrCodeWidget(
                      code: AuthProvider.of(context).authState.storeModel!.iciciData!["staticIntent"],
                      size: heightDp * 250,
                    ),
                    SizedBox(height: heightDp * 10),
                    Text(
                      AuthProvider.of(context).authState.storeModel!.name!,
                      style: TextStyle(
                        fontSize: fontSp * 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   AuthProvider.of(context).authState.storeModel!.mobile!,
                    //   style: TextStyle(
                    //     fontSize: fontSp * 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Text(
                      AuthProvider.of(context).authState.storeModel!.iciciData!["vpa"],
                      style: TextStyle(
                        fontSize: fontSp * 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 25),
                      child: Text(
                        "Scan and Pay with any UPI app",
                        style: TextStyle(fontSize: fontSp * 20, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Image.asset(
                              "img/upi_apps/paytm.png",
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Image.asset(
                              "img/upi_apps/phone_pe.png",
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Image.asset(
                              "img/upi_apps/gpay.png",
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Image.asset(
                              "img/upi_apps/amazon_pay.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              "img/upi_apps/bhim.png",
                              // height: 10,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Image.asset(
                              "img/upi_apps/upi.png",
                              // height: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: widthDp * 25),
                    //   child: Text(
                    //     "Powered by",
                    //     style: TextStyle(fontSize: fontSp * 20, height: 1.5),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
