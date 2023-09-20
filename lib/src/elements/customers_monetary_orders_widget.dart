import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CustomerMonetaryOrders/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/pages/customer_insights.dart';
import 'package:trapp/src/providers/index.dart';

class CustomersMonetaryOrdersWidget extends StatelessWidget {
  final UserModel? user;
  CustomersMonetaryOrdersWidget({
    this.user,
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

  CustomersProvider? customersProvider;
  AuthProvider? authProvider;
  int itemsToShow = 5;

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

    customersProvider = CustomersProvider.of(context);
    authProvider = AuthProvider.of(context);

    Widget _shimmerWidget = Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      period: Duration(milliseconds: 1000),
      child: Center(
        child: Text("Loading . . . "),
      ),
    );

    return Card(
      margin: EdgeInsets.only(
        left: widthDp * 16,
        right: widthDp * 16,
        top: heightDp * 3,
        bottom: heightDp * 17,
      ),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(heightDp * 10),
      ),
      child: Container(
        width: heightDp * 370,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(heightDp * 10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      user == null ? "${itemsToShow} Monetary Orders" : "${itemsToShow} Highest Paid Orders",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => CustomerMonetaryOrdersPage(
                            user: user,
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.launch),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<OrderModel>>(
                future: customersProvider!.getMonetaryOrders(
                  storeId: authProvider!.authState.storeModel!.id,
                  userId: user != null ? user!.id : null,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return _shimmerWidget;
                  }

                  List<OrderModel>? orders = snapshot.data;

                  if (orders == null) {
                    return Center(
                      child: Text("No data"),
                    );
                  }
                  if (orders.length == 0) {
                    return Center(
                      child: Text("No data"),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: orders.length > itemsToShow ? itemsToShow : orders.length,
                    itemBuilder: (context, int index) {
                      OrderModel order = orders[index];

                      if (user != null) {
                        return GestureDetector(
                          onTap: () async {
                            var result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => OrderDetailNewPage(
                                  orderModel: order,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.remove_red_eye),
                                SizedBox(
                                  width: widthDp * 8,
                                ),
                                Expanded(
                                  child: Text("${order.orderId}"),
                                ),
                                Text("₹ ${order.paymentDetail!.toPay.toString()}"),
                              ],
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => CustomerInsightsPage(
                                user: order.userModel,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.assessment),
                              SizedBox(
                                width: widthDp * 8,
                              ),
                              Expanded(
                                child: Text("${order.userModel!.firstName} ${order.userModel!.lastName}"),
                              ),
                              Text("₹ ${order.paymentDetail!.toPay.toString()}"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
