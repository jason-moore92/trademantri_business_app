import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CouponDetailPage/index.dart';
import 'package:trapp/src/pages/CouponViewPage/index.dart';

import 'keicy_avatar_image.dart';

class CouponWidget extends StatefulWidget {
  final CouponModel? couponModel;
  final StoreModel? storeModel;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Function()? editHandler;
  final Function()? shareHandler;
  final Function()? tapHandler;
  final Function(bool)? enableHandler;
  final bool? isForView;

  CouponWidget({
    @required this.couponModel,
    @required this.storeModel,
    this.isLoading = true,
    this.padding,
    this.margin,
    this.editHandler,
    this.shareHandler,
    this.tapHandler,
    this.enableHandler,
    this.isForView = false,
  });

  @override
  _ProductItemForSelectionWidgetState createState() => _ProductItemForSelectionWidgetState();
}

class _ProductItemForSelectionWidgetState extends State<CouponWidget> {
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
            left: widthDp * 10,
            right: widthDp * 10,
            top: heightDp * 5,
            bottom: heightDp * 10,
          ),
      elevation: 5,
      child: Container(
        width: widthDp * 175,
        color: Colors.transparent,
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: widthDp * 10),
        child: widget.isLoading ? _shimmerWidget() : _mainWidget(),
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
          SizedBox(height: heightDp * 10),
          Container(width: widthDp * 175, height: widthDp * 170, color: Colors.white),
          SizedBox(height: heightDp * 10),
          Container(
            color: Colors.white,
            child: Text(
              "discountType",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
          if (!widget.isForView!) SizedBox(height: heightDp * 10),
          if (!widget.isForView!)
            Container(
              height: heightDp * 25,
              color: Colors.white,
            ),
          SizedBox(height: heightDp * 10),
        ],
      ),
    );
  }

  Widget _mainWidget() {
    String validateString = KeicyDateTime.convertDateTimeToDateString(
      dateTime: widget.couponModel!.startDate,
      formats: "Y/m/d",
      isUTC: false,
    );

    Widget discountWidget = SizedBox();

    if (widget.couponModel!.endDate != null) {
      validateString += " - " +
          KeicyDateTime.convertDateTimeToDateString(
            dateTime: widget.couponModel!.endDate,
            formats: "Y/m/d",
            isUTC: false,
          );
    }

    /// percent
    if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[0]["value"]) {
      discountWidget = Container(
        height: heightDp * 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${widget.couponModel!.discountData!["discountValue"]} %",
              style: TextStyle(
                fontSize: fontSp * 16,
                color: config.Colors().mainColor(1),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              " OFF",
              style: TextStyle(
                fontSize: fontSp * 14,
                color: config.Colors().mainColor(1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    // fix amount
    else if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[1]["value"]) {
      discountWidget = Container(
        height: heightDp * 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${widget.couponModel!.discountData!["discountValue"]} ₹",
              style: TextStyle(
                fontSize: fontSp * 16,
                color: config.Colors().mainColor(1),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              " OFF",
              style: TextStyle(
                fontSize: fontSp * 14,
                color: config.Colors().mainColor(1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    // BOGO
    else if (widget.couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"]) {
      discountWidget = Container(
        height: heightDp * 50,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Buy ${widget.couponModel!.discountData!["customerBogo"]["buy"]["quantity"]}",
              style: TextStyle(
                fontSize: fontSp * 16,
                color: config.Colors().mainColor(1),
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Get ${widget.couponModel!.discountData!["customerBogo"]["get"]["quantity"]}",
                  style: TextStyle(
                    fontSize: fontSp * 16,
                    color: config.Colors().mainColor(1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: widthDp * 10),
                Text(
                  widget.couponModel!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]
                      ? "${AppConfig.discountBuyValueForCoupon[0]["text"].toString().toUpperCase()}"
                      : "${widget.couponModel!.discountData!["customerBogo"]["get"]["percentValue"]}% OFF",
                  style: TextStyle(
                    fontSize: fontSp * 12,
                    color: config.Colors().mainColor(1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: widget.tapHandler,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(height: heightDp * 10),
            KeicyAvatarImage(
              url: widget.couponModel!.images!.isNotEmpty
                  ? widget.couponModel!.images![0]
                  : AppConfig.discountTypeImages[widget.couponModel!.discountType],
              width: widthDp * 175,
              height: widthDp * 170,
              backColor: Colors.grey.withOpacity(0.6),
            ),
            SizedBox(height: heightDp * 10),
            Text(
              "${widget.couponModel!.discountCode}",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Center(child: discountWidget),
            Text(
              validateString,
              style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            if (!widget.isForView!)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: IconButton(
                      onPressed: widget.editHandler,
                      icon: Icon(Icons.edit, size: heightDp * 25, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        height: heightDp * 25,
                        child: Switch(
                          value: widget.couponModel!.enabled!,
                          onChanged: widget.enableHandler,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: IconButton(
                      onPressed: widget.shareHandler,
                      icon: Icon(Icons.share, size: heightDp * 25, color: Colors.black),
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: EdgeInsets.only(top: heightDp * 5, bottom: heightDp * 10),
                child: KeicyRaisedButton(
                  width: widthDp * 100,
                  height: heightDp * 30,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 6,
                  child: Text(
                    "View",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => CouponViewPage(
                          storeModel: widget.storeModel,
                          couponModel: widget.couponModel,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
