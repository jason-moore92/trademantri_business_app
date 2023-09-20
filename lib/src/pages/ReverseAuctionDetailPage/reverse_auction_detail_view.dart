import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/qr_code_widget.dart';
import 'package:trapp/src/elements/user_info_panel.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class ReverseAuctionDetailView extends StatefulWidget {
  Map<String, dynamic>? reverseAuctionData;

  ReverseAuctionDetailView({Key? key, this.reverseAuctionData}) : super(key: key);

  @override
  _ReverseAuctionDetailViewState createState() => _ReverseAuctionDetailViewState();
}

class _ReverseAuctionDetailViewState extends State<ReverseAuctionDetailView> {
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

  ReverseAuctionProvider? _reverseAuctionProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  Map<String, dynamic>? _reverseAuctionData;

  String? updatedOrderStatus;

  double leastOfferPrice = 0;
  double yourOfferPrice = 0;
  double biddingPrice = 0;
  String yourMessage = "";

  String reverseAuctionStatus = "";

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

    _reverseAuctionProvider = ReverseAuctionProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _reverseAuctionData = json.decode(json.encode(widget.reverseAuctionData));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _placeBidHandler(String offerPrice, String message) async {
    if (_reverseAuctionData!["storeBiddingPriceList"] == null) _reverseAuctionData!["storeBiddingPriceList"] = Map<String, dynamic>();
    _reverseAuctionData!["storeBiddingPriceList"][_reverseAuctionData!["storeId"]] = {
      "offerPrice": offerPrice,
      "message": message,
    };

    await _keicyProgressDialog!.show();
    var result = await _reverseAuctionProvider!.updateReverseAuctionData(
      reverseAuctionData: _reverseAuctionData,
      status: AppConfig.reverseAuctionStatusData[2]["id"],
      storeOfferData: {
        "storeId": _reverseAuctionData!["storeId"],
        "offerPrice": offerPrice,
        "message": message,
      },
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      // storeName: AuthProvider.of(context).authState.userData!["storeData"]["name"],
      // userName: "${_reverseAuctionData!["user"]["firstName"]} ${_reverseAuctionData!["user"]["lastName"]}",
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _reverseAuctionData!["status"] = AppConfig.reverseAuctionStatusData[2]["id"];
      updatedOrderStatus = AppConfig.reverseAuctionStatusData[2]["id"];
      leastOfferPrice = 0;
      yourOfferPrice = 0;
      yourMessage = "";
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "This Action placed bid",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _placeBidHandler(offerPrice, message);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < AppConfig.reverseAuctionStatusData.length; i++) {
      if (AppConfig.reverseAuctionStatusData[i]["id"] == _reverseAuctionData!["status"]) {
        reverseAuctionStatus = AppConfig.reverseAuctionStatusData[i]["name"];
        break;
      }
    }
    if ((DateTime.tryParse(_reverseAuctionData!['biddingEndDateTime'])!.toLocal()).isBefore(DateTime.now())) {
      reverseAuctionStatus = "Auction ended";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop(updatedOrderStatus);
          },
        ),
        centerTitle: true,
        title: Text("Reverse Auction Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: _mainPanel(),
      ),
    );
  }

  Widget _mainPanel() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: Column(
            children: [
              ///
              Text(
                "${_reverseAuctionData!["reverseAuctionId"]}",
                style: TextStyle(fontSize: fontSp * 21, color: Colors.black),
              ),

              ///
              SizedBox(height: heightDp * 5),
              QrCodeWidget(
                code: Encrypt.encryptString(
                  "ReverseAuction_${_reverseAuctionData!["reverseAuctionId"]}"
                  "_UserId-${_reverseAuctionData!["userId"]}",
                ),
                size: heightDp * 150,
              ),

              ///
              SizedBox(height: heightDp * 15),
              UserInfoPanel(userModel: UserModel.fromJson(_reverseAuctionData!["user"])),

              ///
              Divider(height: heightDp * 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              CartListPanel(reverseAuctionData: _reverseAuctionData),

              ///
              Divider(height: 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              _offerPanel(),

              ///
              Divider(height: 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              _storePricePanel(),

              ///
              Divider(height: 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              _messagePanel(),

              reverseAuctionStatus == AppConfig.reverseAuctionStatusData[1]["name"] ||
                      reverseAuctionStatus == AppConfig.reverseAuctionStatusData[2]["name"]
                  ? Column(
                      children: [
                        Divider(height: 20, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                        _placeBidButtonGrop(),
                      ],
                    )
                  : SizedBox(),

              ///

              SizedBox(height: heightDp * 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _offerPanel() {
    return Column(
      children: [
        Text(
          "Do you have this " + (_reverseAuctionData!["products"].isNotEmpty ? "Product" : "Service") + " Available in Store",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: heightDp * 20),
        Text(
          "User Offer Price Per Quantity",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: heightDp * 5),
        Text(
          "₹ ${_reverseAuctionData!["biddingPrice"]}",
          style: TextStyle(fontSize: fontSp * 35, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: heightDp * 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Auction Status:",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              reverseAuctionStatus,
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Auction Start Date:",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              KeicyDateTime.convertDateTimeToDateString(
                dateTime: DateTime.tryParse(_reverseAuctionData!['biddingStartDateTime'])!.toLocal(),
                formats: 'Y-m-d h:i A',
                isUTC: false,
              ),
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Auction End Date:",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            Text(
              KeicyDateTime.convertDateTimeToDateString(
                dateTime: DateTime.tryParse(_reverseAuctionData!['biddingEndDateTime'])!.toLocal(),
                formats: 'Y-m-d h:i A',
                isUTC: false,
              ),
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _storePricePanel() {
    if (_reverseAuctionData!["storeBiddingPriceList"] != null) {
      _reverseAuctionData!["storeBiddingPriceList"].forEach((key, value) {
        if (leastOfferPrice == 0) leastOfferPrice = double.parse(value["offerPrice"]);
        if (leastOfferPrice > double.parse(value["offerPrice"])) {
          leastOfferPrice = double.parse(value["offerPrice"]);
        }

        if (_reverseAuctionData!["storeId"] == key) {
          yourOfferPrice = double.parse(value["offerPrice"]);
          yourMessage = value["message"];
        }
      });
    }

    biddingPrice = double.parse(_reverseAuctionData!["biddingPrice"]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "Least Bid Price\nin the Auction",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightDp * 10),
            Text(
              leastOfferPrice == 0 ? "No Bid" : "₹ $leastOfferPrice",
              style: TextStyle(
                fontSize: leastOfferPrice == 0 ? fontSp * 16 : fontSp * 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Your Bid\n",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: heightDp * 10),
            Text(
              yourOfferPrice == 0 ? "No Bid" : "₹ $yourOfferPrice",
              style: TextStyle(
                fontSize: leastOfferPrice == 0 ? fontSp * 16 : fontSp * 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _placeBidButtonGrop() {
    return Column(
      children: [
        SizedBox(height: heightDp * 20),
        Text(
          "Grab your Lead",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: heightDp * 20),
        Row(
          mainAxisAlignment: biddingPrice != yourOfferPrice ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
          children: [
            biddingPrice != yourOfferPrice
                ? KeicyRaisedButton(
                    width: widthDp * 140,
                    height: heightDp * 35,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 6,
                    child: Text(
                      "Accept",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      NormalAskDialog.show(
                        context,
                        title: "Auction Accept",
                        content: "You are going to accept the auction for ${_reverseAuctionData!["biddingPrice"]}, would you like to accept?",
                        callback: () async {
                          _placeBidHandler(_reverseAuctionData!["biddingPrice"], "");
                        },
                      );
                    },
                  )
                : SizedBox(),
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 35,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Place your Bid",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                NormalAskDialog.show(
                  context,
                  title: "Auction Place Bid",
                  content: "Do you want a place a bid for this user auction?",
                  callback: () async {
                    StoreOfferPriceDialog.show(
                      context,
                      leastOfferPrice: leastOfferPrice,
                      yourOfferPrice: yourOfferPrice,
                      yourMessage: yourMessage,
                      callback: (price, message) {
                        _placeBidHandler(price, message);
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
      ],
    );
  }

  Widget _messagePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Messages: ", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
          ],
        ),
        SizedBox(height: heightDp * 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_reverseAuctionData!['messages'].length, (index) {
            return Text(
              _reverseAuctionData!['messages'][index]["text"],
              style: TextStyle(fontSize: fontSp * 17, color: Colors.black),
            );
            return Row(
              mainAxisAlignment: _reverseAuctionData!['messages'][index]["senderId"] == _reverseAuctionData!["userId"]
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: _reverseAuctionData!['messages'][index]["senderId"] == _reverseAuctionData!["userId"]
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: widthDp * 150),
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                      decoration: BoxDecoration(
                        color: _reverseAuctionData!['messages'][index]["senderId"] == _reverseAuctionData!["userId"]
                            ? config.Colors().mainColor(0.4)
                            : Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            _reverseAuctionData!['messages'][index]["senderId"] == _reverseAuctionData!["userId"] ? 0 : heightDp * 6,
                          ),
                          topRight: Radius.circular(
                            _reverseAuctionData!['messages'][index]["senderId"] != _reverseAuctionData!["userId"] ? 0 : heightDp * 6,
                          ),
                          bottomLeft: Radius.circular(heightDp * 6),
                          bottomRight: Radius.circular(heightDp * 6),
                        ),
                      ),
                      child: Text(
                        _reverseAuctionData!['messages'][index]["text"],
                        style: TextStyle(fontSize: fontSp * 17, color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
        ),
      ],
    );
  }
}
