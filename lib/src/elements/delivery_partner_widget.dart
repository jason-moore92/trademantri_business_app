import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DeliveryPartnerWidget extends StatelessWidget {
  final Map<String, dynamic>? deliveryPartnerData;
  final bool? isLoading;
  final Function()? tapHandler;

  DeliveryPartnerWidget({
    @required this.deliveryPartnerData,
    @required this.isLoading,
    @required this.tapHandler,
  });

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
  Widget build(BuildContext context) {
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

    return Card(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(heightDp * 8),
        ),
        child: isLoading! ? _shimmerWidget() : _notificationWidget(context),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: isLoading!,
      period: Duration(milliseconds: 1000),
      child: Row(
        children: [
          Container(width: heightDp * 80, height: heightDp * 80, color: Colors.black),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "notification storeName",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "2021-09-23",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "deliveryPartnerData title",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "deliveryPartnerData body\ndeliveryPartnerData body body body body",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationWidget(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${deliveryPartnerData!["name"]}",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: heightDp * 5),
            Text(
              "${deliveryPartnerData!["email"]}",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            ),
            SizedBox(height: heightDp * 5),
            Text(
              "${deliveryPartnerData!["address"]}",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
