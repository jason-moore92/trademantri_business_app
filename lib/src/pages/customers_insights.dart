import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/customers_age_group_widget.dart';
import 'package:trapp/src/elements/customers_frequent_orders_widget.dart';
import 'package:trapp/src/elements/customers_monetary_orders_widget.dart';
import 'package:trapp/src/elements/customers_recent_orders_widget.dart';
import 'package:trapp/src/providers/index.dart';

class CustomersInsightsPage extends StatefulWidget {
  final bool haveAppBar;

  CustomersInsightsPage({this.haveAppBar = true});

  @override
  _CustomersInsightsPageState createState() => _CustomersInsightsPageState();
}

class _CustomersInsightsPageState extends State<CustomersInsightsPage> {
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
    return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
      return Scaffold(
        appBar: widget.haveAppBar
            ? AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                centerTitle: true,
                title: Text(
                  "Customers Insights",
                  style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      refreshProvider.refresh();
                    },
                    icon: Icon(Icons.refresh),
                  )
                ],
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: heightDp * 20),
              CustomersAgeGroupWidget(),
              SizedBox(height: heightDp * 20),
              CustomersRecentOrdersWidget(),
              SizedBox(height: heightDp * 20),
              CustomersFrequentOrdersWidget(),
              SizedBox(height: heightDp * 20),
              CustomersMonetaryOrdersWidget(),
              SizedBox(height: heightDp * 20),
            ],
          ),
        ),
      );
    });
  }
}
