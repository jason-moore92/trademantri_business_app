import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';

class BargainRequestWidget extends StatefulWidget {
  final BargainRequestModel? bargainRequestModel;
  final bool? loadingStatus;
  final Function()? rejectCallback;
  final Function()? acceptCallback;
  final Function()? counterCallback;
  final Function()? detailCallback;

  BargainRequestWidget({
    @required this.bargainRequestModel,
    @required this.loadingStatus,
    this.rejectCallback,
    this.acceptCallback,
    this.counterCallback,
    this.detailCallback,
  });

  @override
  _BargainRequestWidgetState createState() => _BargainRequestWidgetState();
}

class _BargainRequestWidgetState extends State<BargainRequestWidget> {
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
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 3), blurRadius: 6)],
        borderRadius: BorderRadius.circular(heightDp * 8),
      ),
      child: widget.loadingStatus! ? _shimmerWidget() : _orderWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "reverseAuctionId",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "2021-05-15 14:34",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),

          ///
          Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "User Name:",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "fist name last name",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),

          ///
          Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Reverse Auction Status:   ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "store offer",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 7),
          Container(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "Bidding Start Date:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Text(
                    "2021-05-12 45:45",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: heightDp * 7),
          Container(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "Bidding End Date:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Text(
                    "2021-05-12 45:45",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: heightDp * 7),
          Container(
            width: deviceWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "Bidding Price:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Text(
                    "₹ 100",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderWidget() {
    String bargainRequestStatus = "";
    if (widget.bargainRequestModel!.status != widget.bargainRequestModel!.subStatus) {
      for (var i = 0; i < AppConfig.bargainSubStatusData.length; i++) {
        if (AppConfig.bargainSubStatusData[i]["id"] == widget.bargainRequestModel!.subStatus) {
          bargainRequestStatus = AppConfig.bargainSubStatusData[i]["name"];
          break;
        }
      }
    } else {
      for (var i = 0; i < AppConfig.bargainRequestStatusData.length; i++) {
        if (AppConfig.bargainRequestStatusData[i]["id"] == widget.bargainRequestModel!.status) {
          bargainRequestStatus = AppConfig.bargainRequestStatusData[i]["name"];
          break;
        }
      }
    }

    double? originPrice;

    if (widget.bargainRequestModel!.products!.isNotEmpty && widget.bargainRequestModel!.products![0].productModel!.price != 0) {
      originPrice = widget.bargainRequestModel!.products![0].productModel!.price! - widget.bargainRequestModel!.products![0].productModel!.discount!;
    } else if (widget.bargainRequestModel!.services!.isNotEmpty && widget.bargainRequestModel!.services![0].serviceModel!.price != 0) {
      originPrice = widget.bargainRequestModel!.services![0].serviceModel!.price! - widget.bargainRequestModel!.services![0].serviceModel!.discount!;
    }

    return GestureDetector(
      onTap: widget.detailCallback!,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.bargainRequestModel!.bargainRequestId}",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  KeicyDateTime.convertDateTimeToDateString(
                    dateTime: widget.bargainRequestModel!.updatedAt,
                    formats: "Y-m-d H:i",
                    isUTC: false,
                  ),
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ],
            ),

            ///
            Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User Name:",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.bargainRequestModel!.userModel!.firstName} ${widget.bargainRequestModel!.userModel!.lastName}",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ],
            ),
            Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bargain Request Status:   ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Text(
                  bargainRequestStatus,
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ],
            ),

            SizedBox(height: heightDp * 7),
            Container(
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bargain Request Date:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: widget.bargainRequestModel!.bargainDateTime,
                      formats: 'Y-m-d h:i A',
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: heightDp * 7),
            Container(
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Offer Price:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${widget.bargainRequestModel!.offerPrice}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: heightDp * 7),
            Container(
              width: deviceWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Original Price:  ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    originPrice == null ? "" : "$originPrice",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
            ),

            Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

            ///
            if (AppConfig.bargainRequestStatusData[1]["id"] == widget.bargainRequestModel!.status) _userOfferButtonGroup() else SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _userOfferButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp * 120,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Counter Offer",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: widget.counterCallback,
        ),
        KeicyRaisedButton(
          width: widthDp * 100,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Accept",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: widget.acceptCallback,
        ),
        KeicyRaisedButton(
          width: widthDp * 100,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Reject",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: widget.rejectCallback,
        ),
      ],
    );
  }
}
