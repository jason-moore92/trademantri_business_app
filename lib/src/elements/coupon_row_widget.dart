import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/favorite_icon_widget.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'keicy_avatar_image.dart';

class CouponRowWidget extends StatefulWidget {
  final Map<String, dynamic>? couponData;
  final bool isLoading;
  final bool isShowFavorite;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Function()? viewHandler;
  final Function()? shareHandler;

  CouponRowWidget({
    @required this.couponData,
    this.isLoading = true,
    this.isShowFavorite = true,
    this.padding,
    this.margin,
    this.viewHandler,
    this.shareHandler,
  });

  @override
  _ProductItemForSelectionWidgetState createState() => _ProductItemForSelectionWidgetState();
}

class _ProductItemForSelectionWidgetState extends State<CouponRowWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: widget.margin ??
          EdgeInsets.only(
            left: widthDp * 15,
            right: widthDp * 15,
            top: heightDp * 5,
            bottom: heightDp * 10,
          ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 12)),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(heightDp * 12),
        child: Container(
          color: Colors.transparent,
          child: widget.isLoading ? _shimmerWidget() : _mainWidget(),
        ),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          Container(
            height: heightDp * 50,
            color: Colors.white,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "discountValue",
                        style: TextStyle(fontSize: fontSp * 24, color: config.Colors().mainColor(1), fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: heightDp * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Validate : 202132",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  ],
                )),
                SizedBox(width: widthDp * 10),
                KeicyRaisedButton(
                  width: widthDp * 80,
                  height: heightDp * 35,
                  color: Colors.white,
                  borderRadius: heightDp * 10,
                  child: Text(
                    "View",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainWidget() {
    String validateString = KeicyDateTime.convertDateTimeToDateString(
      dateTime: DateTime.parse(widget.couponData!["startDate"]),
      formats: "Y/m/d",
      isUTC: false,
    );

    if (widget.couponData!["endDate"] != null && widget.couponData!["endDate"] != "") {
      validateString += " - " +
          KeicyDateTime.convertDateTimeToDateString(
            dateTime: DateTime.parse(widget.couponData!["endDate"]),
            formats: "Y/m/d",
            isUTC: false,
          );
    }

    Color backColor = Colors.white;

    Widget discountWidget = SizedBox();

    /// percent
    if (widget.couponData!["discountType"] == AppConfig.discountTypeForCoupon[0]["value"]) {
      backColor = Colors.green;
      discountWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${widget.couponData!["discountData"]["discountValue"]} % ",
            style: TextStyle(
              fontSize: fontSp * 24,
              color: config.Colors().mainColor(1),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " OFF",
            style: TextStyle(
              fontSize: fontSp * 18,
              color: config.Colors().mainColor(1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    // fix amount
    else if (widget.couponData!["discountType"] == AppConfig.discountTypeForCoupon[1]["value"]) {
      backColor = Colors.blue;
      discountWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${widget.couponData!["discountData"]["discountValue"]} ₹ ",
            style: TextStyle(
              fontSize: fontSp * 24,
              color: config.Colors().mainColor(1),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " OFF",
            style: TextStyle(
              fontSize: fontSp * 18,
              color: config.Colors().mainColor(1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    // BOGO
    else if (widget.couponData!["discountType"] == AppConfig.discountTypeForCoupon[2]["value"]) {
      backColor = Colors.red;
      discountWidget = Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Buy ${widget.couponData!["discountData"]["customerBogo"]["buy"]["quantity"]}",
                style: TextStyle(
                  fontSize: fontSp * 20,
                  color: config.Colors().mainColor(1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Get ${widget.couponData!["discountData"]["customerBogo"]["get"]["quantity"]}",
                    style: TextStyle(
                      fontSize: fontSp * 20,
                      color: config.Colors().mainColor(1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: widthDp * 10),
                  Text(
                    widget.couponData!["discountData"]["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]
                        ? "${AppConfig.discountBuyValueForCoupon[0]["text"].toString().toUpperCase()}"
                        : "${widget.couponData!["discountData"]["customerBogo"]["get"]["percentValue"]} %  OFF",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: config.Colors().mainColor(1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          color: backColor,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
          child: Row(
            children: [
              KeicyAvatarImage(
                url: widget.couponData!["images"].isNotEmpty
                    ? widget.couponData!["images"][0]
                    : AppConfig.discountTypeImages[widget.couponData!["discountType"]],
                width: heightDp * 50,
                height: heightDp * 50,
                borderRadius: heightDp * 50,
                backColor: Colors.grey.withOpacity(0.6),
              ),
              SizedBox(width: widthDp * 15),
              Expanded(
                child: Text(
                  "${widget.couponData!["discountCode"]}",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  discountWidget,
                  SizedBox(height: heightDp * 5),
                  Text(
                    "Validity : " + validateString,
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  )
                ],
              )),
              // SizedBox(width: widthDp * 10),
              // Column(
              //   children: [
              //     KeicyRaisedButton(
              //       width: widthDp * 80,
              //       height: heightDp * 35,
              //       color: config.Colors().mainColor(1),
              //       borderRadius: heightDp * 10,
              //       child: Text(
              //         "View",
              //         style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
              //       ),
              //       onPressed: widget.viewHandler,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
