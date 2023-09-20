import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:trapp/src/pages/BusinessCardQRCodePage/index.dart';
import 'package:trapp/src/pages/CouponListPage/index.dart';
import 'package:trapp/src/pages/OrderDashboardPage/index.dart';
import 'package:trapp/src/pages/OrderListPage/index.dart';
import 'package:trapp/src/pages/PurchaseOrderPage/purchase_page.dart';
import 'package:trapp/src/pages/ReverseAuctionListPage/index.dart';
import 'package:trapp/src/pages/OrderListPage/index.dart';
import 'package:trapp/src/pages/ReverseAuctionListPage/reverse_auction_list_page.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/elements/order_dashboard_widget.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'AnnouncementListPage/index.dart';
import 'AppointmentListPage/index.dart';
import 'B2BOrderListPage/index.dart';
import 'BargainRequestListPage/index.dart';
import 'BusinessDashboardPage/index.dart';
import 'BusinessCardPage/index.dart';
import 'InvoiceListPage/index.dart';
import 'NewCustomerForChatPage/index.dart';
import 'PurchaseOrderListPage/index.dart';
import 'RewardPointsListPage/index.dart';
import 'StoreGalleryPage/index.dart';
import 'StoreJobPostingsListPage/index.dart';
import 'StoreProductListPage/index.dart';
import 'StoreServiceListPage/index.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OrderProvider, AuthProvider>(builder: (context, orderProvider, authProvider, _) {
      return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ///
              StreamBuilder<dynamic>(
                stream: Stream.fromFuture(
                  OrderProvider.of(context).getDashboardDataByStore(
                    storeId: authProvider.authState.storeModel!.id,
                  ),
                ),
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          OrderDashboardWidget(
                            fieldName: "totalPrice",
                            description: "Total Sales",
                            prefix: "₹",
                          ),
                          OrderDashboardWidget(fieldName: "totalOrderCount", description: "Total Orders"),
                          OrderDashboardWidget(fieldName: "totalQuantity", description: "Total Units"),
                        ],
                      ),
                    ),
                  );
                },
              ),

              ///
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 5,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(heightDp * 10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Share about your business to generate new leads.",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: widthDp * 10),
                        GestureDetector(
                          onTap: () async {
                            Uri dynamicUrl = await DynamicLinkService.createStoreDynamicLink(
                              authProvider.authState.storeModel,
                            );
                            //+ "_storeId-" + authProvider.authState.storeModel!.id!
                            Share.share(dynamicUrl.toString());
                          },
                          child: Container(
                            width: widthDp * 90,
                            decoration: BoxDecoration(
                              color: config.Colors().mainColor(1),
                              borderRadius: BorderRadius.circular(heightDp * 8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share, size: heightDp * 20, color: Colors.white),
                                SizedBox(width: widthDp * 5),
                                Text(
                                  "Share",
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///
              SizedBox(height: heightDp * 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 5,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(heightDp * 10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Share your powerful and handy digital business card that offers comprehensive information about your business",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: widthDp * 10),
                        if (authProvider.authState.businessCardModel!.id == null)
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => BusinessCardPage(),
                                ),
                              );
                            },
                            child: Container(
                              width: widthDp * 90,
                              decoration: BoxDecoration(
                                color: config.Colors().mainColor(1),
                                borderRadius: BorderRadius.circular(heightDp * 8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                              alignment: Alignment.center,
                              child: Text(
                                "Create",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                              ),
                            ),
                          )
                        else
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => BusinessCardPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: widthDp * 120,
                                  decoration: BoxDecoration(
                                    color: config.Colors().mainColor(1),
                                    borderRadius: BorderRadius.circular(heightDp * 8),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Manage",
                                    style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: heightDp * 10),
                              GestureDetector(
                                onTap: () async {
                                  Uri dynamicUrl = await DynamicLinkService.createBusinessCardIDDynamicLink(
                                    businessCardModel: authProvider.authState.businessCardModel,
                                  );
                                  Share.share(dynamicUrl.toString());
                                },
                                child: Container(
                                  width: widthDp * 120,
                                  decoration: BoxDecoration(
                                    color: config.Colors().mainColor(1),
                                    borderRadius: BorderRadius.circular(heightDp * 8),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.share, size: heightDp * 20, color: Colors.white),
                                      SizedBox(width: widthDp * 5),
                                      Text(
                                        "Share",
                                        style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: heightDp * 10),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => BusinessCardQRCodePage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: widthDp * 120,
                                  decoration: BoxDecoration(
                                    color: config.Colors().mainColor(1),
                                    borderRadius: BorderRadius.circular(heightDp * 8),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.share, size: heightDp * 20, color: Colors.white),
                                      SizedBox(width: widthDp * 5),
                                      Text(
                                        "QR Code",
                                        style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              ///
              SizedBox(height: heightDp * 20),
              Container(
                width: deviceWidth,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runSpacing: heightDp * 20,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            // color: Colors.red.withOpacity(0.3),
                            color: config.Colors().mainColor(0.2),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            children: [
                              Image.asset("img/order/order.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Orders",
                                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => BargainRequestListPage(haveAppBar: true)),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            // color: Colors.red.withOpacity(0.3),
                            color: Color(0xFFE2BBAF),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset("img/order/bargain.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              Text(
                                "Bargain Request",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => ReverseAuctionListPage(haveAppBar: true)),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Colors.red.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset("img/order/reverse_auction.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              Text(
                                "Reverse Auction",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => NewCustomerForChatPage(fromSidebar: true),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Colors.blue.withOpacity(0.2),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            children: [
                              Icon(Icons.people, size: heightDp * 70),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Customers",
                                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => StoreProductListPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Colors.yellow.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("img/products.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Products",
                                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => StoreServiceListPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Colors.orange.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("img/services.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Services",
                                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => RewardPointsListPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Colors.purple.withOpacity(0.2),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset("img/reward_points_icon.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              Text(
                                "Configure Reward Points",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => InvoiceListPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Colors.green.withOpacity(0.2),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset("img/payment.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Invoices",
                                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => StoreJobPostingsListPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Colors.teal.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("img/jobs.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Jobs",
                                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => CouponListPage(
                              storeModel: authProvider.authState.storeModel,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("img/coupons.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Coupons",
                                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => AnnouncementListPage(
                              storeModel: authProvider.authState.storeModel,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Color(0xFFff9bb7).withOpacity(0.7),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("img/announcements.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Announcements",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => StoreGalleryPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Color(0xFF305c79).withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: heightDp * 70,
                                child: Center(child: Icon(Icons.perm_media, size: heightDp * 60)),
                              ),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Store Gallery",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => BusinessDashboardPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Color(0xFFB48FD9).withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("img/hand-shake.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Connected Business",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => PurchaseOrderListPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Colors.yellow.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("img/order/order.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "B2B Purchase Order",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => B2BOrderListPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Color(0xFFFFBDB4).withOpacity(0.7),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("img/order/order.png", width: heightDp * 70, height: heightDp * 70, fit: BoxFit.cover),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "B2B Invoices",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => AppointmentListPage()),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 5,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                        child: Container(
                          width: heightDp * 150,
                          height: heightDp * 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(heightDp * 10),
                            color: Color(0xFFADD8E6).withOpacity(0.7),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event, size: heightDp * 70),
                              SizedBox(height: heightDp * 20),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Appointment Booking",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: heightDp * 20),
            ],
          ),
        ),
      );
    });
  }
}
