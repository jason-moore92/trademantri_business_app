import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/print_widget.dart';
import 'package:trapp/src/elements/qr_code_widget.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class BusinessCardQRCodeView extends StatefulWidget {
  BusinessCardQRCodeView({Key? key}) : super(key: key);

  @override
  _BusinessCardQRCodeViewState createState() => _BusinessCardQRCodeViewState();
}

class _BusinessCardQRCodeViewState extends State<BusinessCardQRCodeView> {
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

  ScreenshotController screenshotController = ScreenshotController();

  Uint8List? _qrCodeImage;

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
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Business Card QR Code",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
        ),
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  PrintWidget(
                    path: "",
                    qrCodePageImage: _qrCodeImage,
                    size: heightDp * 30,
                    color: Colors.white,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String filePath = await createFileFromByteData(_qrCodeImage!);
                      Share.shareFiles([filePath]);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                      child: Icon(Icons.share, size: heightDp * 25, color: Colors.white),
                    ),
                  ),
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
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
            color: Colors.white,
            child: Column(
              children: [
                if (AuthProvider.of(context).authState.businessCardModel!.companyLogo != null &&
                    AuthProvider.of(context).authState.businessCardModel!.companyLogo != "")
                  Column(
                    children: [
                      KeicyAvatarImage(
                        url: AuthProvider.of(context).authState.businessCardModel!.companyLogo,
                        width: deviceWidth * 0.8,
                        height: null,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(height: heightDp * 20),
                    ],
                  ),
                Text(
                  "${AuthProvider.of(context).authState.businessCardModel!.businessName}",
                  style: TextStyle(fontSize: fontSp * 24),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: heightDp * 20),
                FutureBuilder<Uri>(
                  future: DynamicLinkService.createBusinessCardIDDynamicLink(
                    businessCardModel: AuthProvider.of(context).authState.businessCardModel,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        width: heightDp * 250,
                        height: heightDp * 250,
                        alignment: Alignment.center,
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
                        _qrCodeImage = await screenshotController.capture();
                        setState(() {});
                      });
                      return QrCodeWidget(
                        code: snapshot.data.toString(),
                        size: heightDp * 250,
                      );
                    }

                    return SizedBox();
                  },
                ),
                SizedBox(height: heightDp * 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, size: heightDp * 25),
                          SizedBox(width: widthDp * 10),
                          Text(
                            "${AuthProvider.of(context).authState.businessCardModel!.city != null && AuthProvider.of(context).authState.businessCardModel!.city != "" ? AuthProvider.of(context).authState.businessCardModel!.city : AuthProvider.of(context).authState.storeModel!.city}",
                            style: TextStyle(fontSize: fontSp * 20, height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 10),
                      Text(
                        "Powered By TradeMantri",
                        style: TextStyle(fontSize: fontSp * 20, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
