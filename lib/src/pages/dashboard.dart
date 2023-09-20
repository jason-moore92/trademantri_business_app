import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/bargain_count_widget.dart';
import 'package:trapp/src/elements/order_dashboard_widget.dart';
import 'package:trapp/src/elements/order_graph_widget.dart';
import 'package:trapp/src/elements/reverse_auction_count_widget.dart';
import 'package:trapp/src/elements/top_selling_products_widget.dart';
import 'package:trapp/src/pages/ProductOrders/index.dart';
import 'package:trapp/src/providers/index.dart';

class DashboardPage extends StatefulWidget {
  final bool haveAppBar;

  DashboardPage({this.haveAppBar = true});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
              title: Text("Dashboard", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
            )
          : null,
      body: Consumer<OrderProvider>(builder: (context, orderProvider, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: heightDp * 20),
              OrderGraphWidget(),
              StreamBuilder<dynamic>(
                stream: Stream.fromFuture(
                  OrderProvider.of(context).getDashboardDataByStore(
                    storeId: AuthProvider.of(context).authState.storeModel!.id,
                  ),
                ),
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: heightDp * 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OrderDashboardWidget(fieldName: "totalOrderCount", description: "Total Orders"),
                            OrderDashboardWidget(fieldName: "totalPrice", description: "Total Sales", prefix: "₹"),
                          ],
                        ),
                      ),
                      SizedBox(height: heightDp * 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OrderDashboardWidget(fieldName: "totalCancelledOrderCount", description: "Cancelled Orders"),
                            OrderDashboardWidget(fieldName: "totalRejectedOrderCount", description: "Rejected Orders"),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: heightDp * 20),
              TopSellingProductsWidget(storeId: AuthProvider.of(context).authState.storeModel!.id),

              SizedBox(height: heightDp * 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                child: Card(
                  margin: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 3, bottom: heightDp * 17),
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
                  child: Container(
                    width: heightDp * 340,
                    padding: EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ProductOrdersPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("All products & orders"),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(Icons.launch),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: heightDp * 20),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BargainCountWidget(storeId: AuthProvider.of(context).authState.storeModel!.id),
                    ReverseAuctionCountWidget(storeId: AuthProvider.of(context).authState.storeModel!.id),
                  ],
                ),
              ),
              // SizedBox(height: heightDp * 20),
              // Center(
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
              //     child: Text(
              //       "Do You Want To See Category Wise Breakdown",
              //       style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.bold, color: Colors.black),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
              // SizedBox(height: heightDp * 20),
              // _categoryList(),
              SizedBox(height: heightDp * 20),
            ],
          ),
        );
      }),
    );
  }

  // Widget _categoryList() {
  //   return StreamBuilder<Object>(
  //     stream: Stream.fromFuture(
  //       OrderApiProvider.getCategoryOrderData(storeId: AuthProvider.of(context).authState.userData["storeData"]["_id"]),
  //     ),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData || snapshot.data == null)
  //         return Center(
  //           child: Padding(
  //             padding: EdgeInsets.all(heightDp * 50),
  //             child: CupertinoActivityIndicator(),
  //           ),
  //         );

  //       return Container();
  //     },
  //   );
  // }
}
