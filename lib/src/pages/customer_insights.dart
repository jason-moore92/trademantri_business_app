import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/customer_quicky_insights_widget.dart';
import 'package:trapp/src/elements/customers_age_group_widget.dart';
import 'package:trapp/src/elements/customers_frequent_orders_widget.dart';
import 'package:trapp/src/elements/customers_monetary_orders_widget.dart';
import 'package:trapp/src/elements/customers_recent_orders_widget.dart';
import 'package:trapp/src/elements/order_status_group_widget.dart';
import 'package:trapp/src/elements/top_selling_products_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class CustomerInsightsPage extends StatefulWidget {
  final bool haveAppBar;
  final UserModel? user;

  CustomerInsightsPage({
    this.haveAppBar = true,
    @required this.user,
  });

  @override
  _CustomerInsightsPageState createState() => _CustomerInsightsPageState();
}

class _CustomerInsightsPageState extends State<CustomerInsightsPage> {
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
                  "${widget.user!.firstName} ${widget.user!.lastName}",
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SizedBox(height: heightDp * 20),
                CustomerQuickInsightsWidget(
                  user: widget.user,
                ),
                SizedBox(height: heightDp * 20),
                OrderStatusGroupWidget(
                  storeId: AuthProvider.of(context).authState.storeModel!.id,
                  user: widget.user,
                ),
                SizedBox(height: heightDp * 20),
                TopSellingProductsWidget(
                  storeId: AuthProvider.of(context).authState.storeModel!.id,
                  user: widget.user,
                ),
                SizedBox(height: heightDp * 20),
                CustomersRecentOrdersWidget(
                  user: widget.user,
                ),
                SizedBox(height: heightDp * 20),
                CustomersMonetaryOrdersWidget(
                  user: widget.user,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
