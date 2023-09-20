import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/pages/BusinessCardPage/Components/product_service_panel.dart';
import 'package:trapp/src/pages/BusinessCardPage/index.dart';

class BusinessCardView extends StatefulWidget {
  BusinessCardView({Key? key}) : super(key: key);

  @override
  _BusinessCardViewState createState() => _BusinessCardViewState();
}

class _BusinessCardViewState extends State<BusinessCardView> with SingleTickerProviderStateMixin {
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

  TabController? _tabController;

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

    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Digital Business Card",
            style: TextStyle(fontSize: fontSp * 16),
          ),
        ),
        body: Column(
          children: [
            _tabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  YourDetailPanel(),
                  ProductServicePanel(),
                  GalleryPanel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      width: deviceWidth,
      height: heightDp * 40,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      // decoration: BoxDecoration(
      //   border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      // ),
      alignment: Alignment.center,
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        indicatorWeight: 1,
        indicator: BoxDecoration(
          color: config.Colors().mainColor(1),
          borderRadius: BorderRadius.circular(heightDp * 50),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 0),
        labelStyle: TextStyle(fontSize: fontSp * 14),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(
            text: "Your Details",
          ),
          Tab(
            text: "Product/Service",
          ),
          Tab(
            text: "Gallery",
          ),
        ],
      ),
    );
  }
}
