import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';

class NewCustomerWidget extends StatefulWidget {
  final Map<String, dynamic>? customerData;
  final bool? loadingStatus;
  final Function(String? operation)? callback;

  NewCustomerWidget({
    @required this.customerData,
    @required this.loadingStatus,
    this.callback,
  });

  @override
  _StoreWidgetState createState() => _StoreWidgetState();
}

class _StoreWidgetState extends State<NewCustomerWidget> {
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
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      color: Colors.transparent,
      child: widget.loadingStatus! ? _shimmerWidget() : _storeWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Row(
        children: [
          Container(
            width: heightDp * 60,
            height: heightDp * 60,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightDp * 60)),
          ),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "firstName lastName",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.bold, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "email@email.com",
                    style: TextStyle(fontSize: fontSp * 12, fontWeight: FontWeight.bold, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "12345677",
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeWidget() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          elevation: 0.5,
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Chat"),
                  leading: Icon(Icons.chat),
                  onTap: () {
                    widget.callback!(null);
                  },
                ),
                ListTile(
                  title: Text("Create Invoice"),
                  leading: Transform.rotate(
                    angle: pi / 4,
                    child: Icon(
                      Icons.link,
                      color: Colors.black.withOpacity(0.7),
                      size: heightDp * 25.0,
                    ),
                  ),
                  onTap: () {
                    widget.callback!("Invoice");
                  },
                ),
                ListTile(
                  title: Text("Create Coupon"),
                  // leading: Image.asset(
                  //   "img/coupons.png",
                  //   height: heightDp * 35,
                  //   fit: BoxFit.fitHeight,
                  // ),
                  leading: Icon(Icons.redeem),
                  onTap: () {
                    widget.callback!("Coupon");
                  },
                ),
                ListTile(
                  title: Text("Insights"),
                  leading: Icon(Icons.assessment),
                  onTap: () {
                    widget.callback!("Insights");
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          children: [
            KeicyAvatarImage(
              url: widget.customerData!["imageUrl"],
              width: widthDp * 50,
              height: widthDp * 50,
              backColor: Colors.grey.withOpacity(0.4),
              borderRadius: widthDp * 50,
              borderColor: Colors.grey.withOpacity(0.2),
              borderWidth: 1,
              shimmerEnable: widget.loadingStatus!,
              userName: (widget.customerData!["firstName"] + " " + widget.customerData!["lastName"]).toString().toUpperCase(),
              textStyle: TextStyle(fontSize: fontSp * 20),
            ),
            SizedBox(width: widthDp * 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.customerData!["firstName"]} ${widget.customerData!["lastName"]}",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.bold, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: widthDp * 15),
            Icon(
              Icons.more_vert,
              size: heightDp * 25,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
