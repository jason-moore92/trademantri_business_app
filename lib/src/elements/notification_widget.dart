import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/AppointmentPage/appointment_page.dart';
import 'package:trapp/src/pages/B2BOrderDetailPage/index.dart';
import 'package:trapp/src/pages/BargainRequestDetailPage_new/index.dart';
import 'package:trapp/src/pages/BookAppointmentDetailPage/index.dart';
import 'package:trapp/src/pages/BusinessStoresPage/index.dart';
import 'package:trapp/src/pages/MyJobDetailPage/index.dart';
import 'package:trapp/src/pages/MyReferralListForStorePage/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/pages/OrderDetailPage/index.dart';
import 'package:trapp/src/pages/PurchaseOrderDetailPage/index.dart';
import 'package:trapp/src/pages/ReverseAuctionDetailPage/index.dart';
import 'package:trapp/src/pages/RewardPointsForStorePage/index.dart';
import 'package:trapp/src/pages/RewardPointsListPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class NotificationWidget extends StatelessWidget {
  final Map<String, dynamic>? notificationData;
  final bool? isLoading;

  NotificationWidget({
    @required this.notificationData,
    @required this.isLoading,
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      color: Colors.transparent,
      child: isLoading! ? _shimmerWidget() : _notificationWidget(context),
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
          Container(width: heightDp * 50, height: heightDp * 50, color: Colors.black),
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
                    "notificationData title",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "notificationData body\nnotificationData body body body body",
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
    /// icon part
    String assetString;
    if (notificationData!["type"] == "b2b_order" || notificationData!["type"] == "purchase_order") {
      assetString = "img/order/order.png";
    } else if (notificationData!["type"] == "referral_rewardpoint") {
      assetString = "img/order/reward_points.png";
    } else {
      assetString = "img/order/${notificationData!["type"]}.png";
    }

    String body = notificationData!["body"] ?? "";

    /// body repalcement part
    if (notificationData!["type"] == "b2b_order" &&
        notificationData!["myStore"].isNotEmpty &&
        notificationData!["myStore"][0] != null &&
        notificationData!["myStore"][0].isNotEmpty) {
      body = body.replaceAll("my_store_name", "${notificationData!["myStore"][0]["name"]}");
    }

    if (notificationData!["type"] == "b2b_order" &&
        notificationData!["businessStore"].isNotEmpty &&
        notificationData!["businessStore"][0] != null &&
        notificationData!["businessStore"][0].isNotEmpty) {
      body = body.replaceAll("business_store_name", "${notificationData!["businessStore"][0]["name"]}");
    }

    if (notificationData!["type"] == "business_connection" &&
        notificationData!["requestedStore"].isNotEmpty &&
        notificationData!["requestedStore"][0] != null &&
        notificationData!["requestedStore"][0].isNotEmpty) {
      body = body.replaceAll("requested_store_name", "${notificationData!["requestedStore"][0]["name"]}");
    }

    if (notificationData!["type"] == "business_connection" &&
        notificationData!["recepientStore"].isNotEmpty &&
        notificationData!["recepientStore"][0] != null &&
        notificationData!["recepientStore"][0].isNotEmpty) {
      body = body.replaceAll("recepient_store_name", "${notificationData!["recepientStore"][0]["name"]}");
    }

    body = body.replaceAll("store_name", AuthProvider.of(context).authState.storeModel!.name!);

    if (notificationData!["user"] != null && notificationData!["user"].isNotEmpty) {
      body = body.replaceAll("user_name", notificationData!["user"][0]["firstName"] + " " + notificationData!["user"][0]["lastName"]);
    }

    if (notificationData!["type"] == "order") {
      body = body.replaceAll("orderId", notificationData!["data"]["orderId"]);
      if (notificationData!["data"]["deliveryUserId"] != null && notificationData!["deliveryUser"] != null) {
        body = body.replaceAll(
          "delivery_person_name",
          "${notificationData!["deliveryUser"][0]["firstName"]} ${notificationData!["deliveryUser"][0]["lastName"]}",
        );

        body = body.replaceAll(
          "customerDeliveryCode",
          "${notificationData!["data"]["customerDeliveryCode"]}",
        );

        body = body.replaceAll(
          "storeDeliveryCode",
          "${notificationData!["data"]["storeDeliveryCode"]}",
        );
      }
    }
    if (notificationData!["type"] == "bargain") {
      body = body.replaceAll("bargainRequestId", notificationData!["data"]["bargainRequestId"]);
    }
    if (notificationData!["type"] == "reverse_auction") {
      body = body.replaceAll("reverseAuctionId", notificationData!["data"]["reverseAuctionId"]);
    }

    if (notificationData!["type"] == "job_posting") {
      if (notificationData!["user"] != null && notificationData!["user"].isNotEmpty) {
        body = body.replaceAll(
          "applicant_name",
          "${notificationData!["user"][0]["firstName"]} ${notificationData!["user"][0]["lastName"]}",
        );
      }
    }

    if (notificationData!["type"] == "referral_rewardpoint") {
      body = body.replaceAll("referralUserAmount", notificationData!["data"]["referralUserAmount"].toString());
      body = body.replaceAll("referralUserRewardPoints", notificationData!["data"]["referralUserRewardPoints"].toString());
      body = body.replaceAll("referredByUserAmount", notificationData!["data"]["referredByUserAmount"].toString());
      body = body.replaceAll("referredByUserRewardPoints", notificationData!["data"]["referredByUserRewardPoints"].toString());
    }

    if (notificationData!["type"] == "book_appointment") {
      body = body.replaceAll("booking_date", notificationData!["data"]["booking_date"].toString());
      body = body.replaceAll("booking_start_time", notificationData!["data"]["booking_start_time"].toString());
      body = body.replaceAll("appointment_name", notificationData!["data"]["appointment_name"].toString());
    }

    //////////////////////

    String name = "";
    if (notificationData!["user"] != null && notificationData!["user"].isNotEmpty) {
      name = "${notificationData!["user"][0]["firstName"]} ${notificationData!["user"][0]["lastName"]}";
    }

    if ((notificationData!["type"] == "referred_for_store_to_store" || notificationData!["type"] == "referral_for_store_to_store") &&
        notificationData!["store"].isNotEmpty &&
        notificationData!["store"][0] != null &&
        notificationData!["store"][0].isNotEmpty) {
      name = "${notificationData!["store"][0]["name"]}";
    }

    if (name == "" &&
        notificationData!["type"] == "referral_rewardpoint" &&
        notificationData!["store"].isNotEmpty &&
        notificationData!["store"][0] != null &&
        notificationData!["store"][0].isNotEmpty) {
      name = "${notificationData!["store"][0]["name"]}";
    }

    return GestureDetector(
      onTap: () {
        _tapHandler(context);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            if (notificationData!["type"] == "book_appointment")
              Icon(Icons.event, size: heightDp * 50, color: config.Colors().mainColor(1))
            else if (notificationData!["type"] == "business_connection")
              Icon(Icons.storefront_outlined, size: heightDp * 50, color: config.Colors().mainColor(1))
            else
              Image.asset(
                assetString,
                width: heightDp * 50,
                height: heightDp * 50,
                errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                  return Container(
                    width: heightDp * 80,
                    height: heightDp * 80,
                    color: Colors.grey.withOpacity(0.5),
                    child: Center(child: Icon(Icons.not_interested, size: heightDp * 25, color: Colors.black)),
                  );
                },
              ),
            SizedBox(width: widthDp * 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: heightDp * 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        KeicyDateTime.convertDateTimeToDateString(
                          dateTime: DateTime.tryParse("${notificationData!["updatedAt"]}"),
                          formats: "Y-m-d h:i A",
                          isUTC: false,
                        ),
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: heightDp * 5),
                  Text(
                    "${notificationData!["title"]}",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: heightDp * 5),
                  Text(
                    body,
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tapHandler(BuildContext context) async {
    if (notificationData!["type"] == "order") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OrderDetailNewPage(
            orderId: notificationData!["data"]["orderId"],
            storeId: notificationData!["data"]["storeId"],
            userId: notificationData!["data"]["userId"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "bargain") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BargainRequestDetailNewPage(
            bargainRequestId: notificationData!["data"]["bargainRequestId"],
            storeId: notificationData!["data"]["storeId"],
            userId: notificationData!["data"]["userId"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "reverse_auction") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ReverseAuctionDetailPage(
            storeId: notificationData!["data"]["storeId"],
            userId: notificationData!["data"]["userId"],
            reverseAuctionId: notificationData!["data"]["reverseAuctionId"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "job_posting") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => MyJobDetailPage(
            appliedJobData: null,
            jobId: notificationData!["data"]["id"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "purchase_order") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PurchaseDetailPage(
            purchaseModel: null,
            purchaseOrderId: notificationData!["data"]["id"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "b2b_order") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => B2BOrderDetailPage(
            orderId: notificationData!["data"]["orderId"],
            myStoreId: notificationData!["data"]["myStoreId"],
            businessStoreId: notificationData!["data"]["businessStoreId"],
          ),
        ),
      );
    } else if (notificationData!["type"] == "business_connection") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BusinessStoresPage(status: notificationData!["data"]["status"]),
        ),
      );
    } else if (notificationData!["type"] == "book_appointment") {
      if (notificationData!["data"]["id"] == null || notificationData!["data"]["id"] == "") {
        NormalDialog.show(
          context,
          content: "This notification is generated by initial.\nSo, this is old and have bad data.",
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => BookAppointmentDetailPage(
              bookAppointmentModel: null,
              id: notificationData!["data"]["id"],
            ),
          ),
        );
      }
    } else if (notificationData!["type"] == "referral_rewardpoint") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => RewardPointsForStorePage(),
        ),
      );
    }
  }
}
