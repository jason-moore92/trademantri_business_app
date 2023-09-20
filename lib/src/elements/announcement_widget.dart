import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/AnnouncementViewPage/announcement_view_page.dart';

import 'keicy_raised_button.dart';

class AnnouncementWidget extends StatelessWidget {
  final Map<String, dynamic>? announcementData;
  final StoreModel? storeModel;
  final bool? isLoading;
  final bool? isForView;
  final Function()? editHandler;
  final Function()? shareHandler;
  final Function(bool)? enableHandler;

  AnnouncementWidget({
    @required this.announcementData,
    @required this.storeModel,
    @required this.isLoading,
    this.isForView = false,
    this.editHandler,
    this.shareHandler,
    this.enableHandler,
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
      margin: EdgeInsets.only(
        left: widthDp * 15,
        right: widthDp * 15,
        top: heightDp * 5,
        bottom: heightDp * 10,
      ),
      elevation: 5,
      child: Container(
        width: widthDp * 175,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
        child: isLoading! ? _shimmerWidget() : _announcementWidget(context),
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
                    "announcementData title",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "announcementData body\nannouncementData body body body body",
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

  Widget _announcementWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            KeicyAvatarImage(
              url: announcementData!["images"].isNotEmpty ? announcementData!["images"][0] : AppConfig.announcementImage[0],
              width: heightDp * 70,
              height: heightDp * 70,
              backColor: Colors.grey.withOpacity(0.7),
            ),
            SizedBox(width: widthDp * 5),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${announcementData!["title"]}",
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          KeicyDateTime.convertDateTimeToDateString(
                            dateTime: DateTime.tryParse("${announcementData!["datetobeposted"]}"),
                            formats: "Y-m-d",
                            isUTC: false,
                          ),
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${announcementData!["description"]}",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      children: [
                        Text(
                          "City:  ",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${announcementData!["city"]}",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ],
                    ),
                    if (announcementData!["coupon"].isNotEmpty) SizedBox(height: heightDp * 5),
                    if (announcementData!["coupon"].isNotEmpty)
                      Row(
                        children: [
                          Text(
                            "Coupon\nDiscount Code:  ",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Text(
                              "${announcementData!["coupon"][0]["discountCode"]}",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (!isForView!) SizedBox(height: heightDp * 5),
        if (!isForView!)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: heightDp * 25,
                child: Switch(
                  value: announcementData!["active"],
                  onChanged: enableHandler,
                ),
              ),
              GestureDetector(
                onTap: editHandler,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  color: Colors.transparent,
                  child: Icon(Icons.edit, size: heightDp * 25, color: Colors.black),
                ),
              ),
              if (announcementData!["announcementto"] == "CUSTOMERS_ONLY")
                GestureDetector(
                  onTap: shareHandler,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                    color: Colors.transparent,
                    child: Icon(Icons.share, size: heightDp * 25, color: Colors.black),
                  ),
                ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: heightDp * 5, bottom: heightDp * 0),
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
                        builder: (BuildContext context) => AnnouncementViewPage(
                          announcementData: announcementData,
                          storeModel: storeModel,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
}
