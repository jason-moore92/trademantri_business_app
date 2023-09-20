import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/dto/order_status_group.dart';
import 'package:trapp/src/dto/top_selling_product.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ProductOrders/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class OrderStatusGroupWidget extends StatelessWidget {
  final String? storeId;
  final UserModel? user;

  OrderStatusGroupWidget({
    @required this.storeId,
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

  int itemsToShow = 9;
  var numFormat = NumberFormat.currency(symbol: "", name: "");

  CustomersProvider? customersProvider;

  List<String> onlyStatus = ["order_placed", "order_cancelled", "order_rejected"];

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    customersProvider = CustomersProvider.of(context);

    Widget _shimmerWidget = Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      period: Duration(milliseconds: 1000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.white,
            child: Text(
              "Orders status count",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            ),
          ),
          SizedBox(height: heightDp * 10),
          Container(
            color: Colors.white,
            child: Text(
              "₹ 82.56",
              style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return Card(
      margin: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 3, bottom: heightDp * 17),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
      child: Container(
        // width: double.infinity,
        width: widthDp * 355,
        padding: EdgeInsets.all(8.0),
        // height: heightDp * 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 10), color: Colors.white),
        child: StreamBuilder<List<OrderStatusGroup>>(
          stream: Stream.fromFuture(
            customersProvider!.getOrdersByStatus(
              storeId: storeId,
              userId: user != null ? user!.id : null,
              onlyStatus: onlyStatus,
            ),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) return _shimmerWidget;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Order Status Count",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
                SizedBox(height: heightDp * 10),
                if (snapshot.data!.length == 0)
                  Container(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text("No products purchased yet."),
                  ),
                if (snapshot.data!.length != 0)
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length > itemsToShow ? itemsToShow : snapshot.data!.length,
                    itemBuilder: (context, index) {
                      OrderStatusGroup tsp = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                getOrderStatusName(tsp.id!),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
                                "${tsp.count}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
