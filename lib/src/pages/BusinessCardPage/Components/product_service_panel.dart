import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;

class ProductServicePanel extends StatefulWidget {
  ProductServicePanel({Key? key}) : super(key: key);

  @override
  _ProductServicePanelState createState() => _ProductServicePanelState();
}

class _ProductServicePanelState extends State<ProductServicePanel> with SingleTickerProviderStateMixin {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
            child: _mainPanel(),
          ),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    return Column(
      children: [
        Center(
          child: Text(
            "Products or Servcies",
            style: TextStyle(fontSize: fontSp * 24, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: heightDp * 10),
        // Center(
        //   child: Text(
        //     "Manage products/services of your business",
        //     style: TextStyle(fontSize: fontSp * 14),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        // SizedBox(height: heightDp * 30),
        Center(
          child: Text(
            // "Your top selling 25 products are display by default in your business card.",
            "Your best selling products or services are displayed in digital business card.",
            style: TextStyle(fontSize: fontSp * 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
