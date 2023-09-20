library keicy_text_form_field;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BargainRequestDetailPage_new/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/pages/OrderDetailPage/index.dart';
import 'package:trapp/src/pages/ReverseAuctionDetailPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';
import 'package:url_launcher/url_launcher.dart';

class QRCodeIconWidget extends StatefulWidget {
  final bool? isOnlyStore;
  final Function? invitationHandler;
  final Function? connectionHandler;

  QRCodeIconWidget({this.isOnlyStore = false, this.invitationHandler, this.connectionHandler});

  @override
  _QRCodeIconWidgetState createState() => _QRCodeIconWidgetState();
}

class _QRCodeIconWidgetState extends State<QRCodeIconWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  KeicyProgressDialog? _keicyProgressDialog;

  @override
  Widget build(BuildContext context) {
    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    return Container(
      width: heightDp * 40,
      height: heightDp * 30,
      child: GestureDetector(
        onTap: () async {
          qrcodeHandler();
        },
        child: Container(
          width: heightDp * 40,
          height: heightDp * 30,
          padding: EdgeInsets.only(left: widthDp * 10),
          color: Colors.transparent,
          child: Image.asset("img/qrcode_scan.png", width: heightDp * 30, height: heightDp * 30, fit: BoxFit.cover),
        ),
      ),
    );
  }

  void qrcodeHandler() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      var newStatus = await Permission.camera.request();
      if (!newStatus.isGranted) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "Your camera permission isn't granted",
          isTryButton: false,
          callBack: () {
            Navigator.of(context).pop();
          },
        );
        return;
      }
    }
    NormalDialog.show(
      context,
      content: "Scan Order QR-code/Bargain QR-code/Reverse auction QR-code to open the details",
      callback: () async {
        var result = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
        if (result == "-1") return;
        String qrCodeString = Encrypt.decryptString(result);

        if (qrCodeString.contains("http")) {
          await _keicyProgressDialog!.show();
          Uri url = (await DynamicLinkService.expandShortUrl(shortUrl: qrCodeString));
          await _keicyProgressDialog!.hide();
          if (url.path == "/store") {
            if (url.query.split('=').last == AuthProvider.of(context).authState.storeModel!.id) {
              ErrorDialog.show(
                context,
                widthDp: widthDp,
                heightDp: heightDp,
                fontSp: fontSp,
                text: "This is your store Qr code.",
              );
            } else {
              _getStoreInfoHandler(url.query.split('=').last);
            }
            return;
          } else {
            if (await canLaunch(qrCodeString)) {
              await launch(
                qrCodeString,
                forceSafariVC: false,
                forceWebView: false,
              );
              return;
            } else {
              throw 'Could not launch $qrCodeString';
            }
            return;
          }
          return;
        }

        if (widget.isOnlyStore!) return;

        String type = qrCodeString.split("_").first;

        if (type == "Order") {
          String orderId = qrCodeString.split("_")[1];
          String storeId = qrCodeString.split("_")[2].split("-").last;
          String userId = qrCodeString.split("_")[3].split("-").last;
          if (storeId == AuthProvider.of(context).authState.storeModel!.id) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => OrderDetailNewPage(
                  orderId: orderId,
                  storeId: storeId,
                  userId: userId,
                ),
              ),
            );
            return;
          } else {
            ErrorDialog.show(
              context,
              widthDp: widthDp,
              heightDp: heightDp,
              fontSp: fontSp,
              text: "This order does not belong to you, please try a different QR code",
              callBack: () {
                qrcodeHandler();
              },
            );
            return;
          }
        } else if (type == "BargainRequest") {
          String bargainRequestId = qrCodeString.split("_")[1];
          String storeId = qrCodeString.split("_")[2].split("-").last;
          String userId = qrCodeString.split("_")[3].split("-").last;

          if (storeId == AuthProvider.of(context).authState.storeModel!.id) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => BargainRequestDetailNewPage(
                  bargainRequestId: bargainRequestId,
                  userId: userId,
                  storeId: storeId,
                ),
              ),
            );
            return;
          } else {
            ErrorDialog.show(
              context,
              widthDp: widthDp,
              heightDp: heightDp,
              fontSp: fontSp,
              text: "This Bargain request does not belong to you, please try a different QR code",
              callBack: () {
                qrcodeHandler();
              },
            );
            return;
          }
        } else if (type == "ReverseAuction") {
          String reverseAuctionId = qrCodeString.split("_")[1];
          String userId = qrCodeString.split("_")[2].split("-").last;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ReverseAuctionDetailPage(
                reverseAuctionId: reverseAuctionId,
                userId: userId,
                storeId: AuthProvider.of(context).authState.storeModel!.id,
              ),
            ),
          );
          return;
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "This qr code is invalid. Please try again",
            callBack: () {
              qrcodeHandler();
            },
            isTryButton: true,
          );
        }
      },
    );
  }

  void _getStoreInfoHandler(String storeId) async {
    var result = await BusinessConnectionsApiProvider.getConnection(
      recepientId: storeId,
      requestedId: AuthProvider.of(context).authState.storeModel!.id,
    );

    if (!result["success"]) {
      await _keicyProgressDialog!.hide();
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"] ?? "Something was wrong",
      );
      return;
    }

    if (result["data"] == null) {
      await _keicyProgressDialog!.hide();
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "We can't find this business.",
      );
      return;
    }
    BusinessConnectionModel connectionModel = BusinessConnectionModel.fromJson(result["data"]);

    result = await StoreApiProvider.getStoreData(id: storeId);

    if (!result["success"]) {
      await _keicyProgressDialog!.hide();
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
      );
    }

    StoreModel storeModel = StoreModel.fromJson(result["data"]['store']);
    await _keicyProgressDialog!.hide();

    if (connectionModel.status == ConnectionStatus.active) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => StorePage(storeModel: storeModel),
        ),
      );
    } else {
      result = await StoreConnectionDialog.show(
        context,
        storeModel: storeModel,
        connectionModel: connectionModel,
        invitationCallback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
          if (widget.invitationHandler != null) {
            widget.invitationHandler!(connectionModel: connectionModel, storeModel: storeModel);
          }
        },
        connectionHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
          if (widget.connectionHandler != null) {
            widget.connectionHandler!(connectionModel: connectionModel, storeModel: storeModel);
          }
        },
      );
    }
  }
}
