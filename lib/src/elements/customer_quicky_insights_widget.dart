import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/dto/customer_quick_insights.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class CustomerQuickInsightsWidget extends StatelessWidget {
  final UserModel? user;
  CustomerQuickInsightsWidget({this.user});

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
        // height: heightDp * 370,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(heightDp * 10),
          color: Colors.white,
        ),
        child: FutureBuilder<CustomerQuickInsights>(
          future: customersProvider!.getQuickInsights(
            storeId: authProvider!.authState.storeModel!.id,
            userId: user!.id,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _shimmerWidget;
            }

            CustomerQuickInsights? cqi = snapshot.data;

            if (cqi == null) {
              return Center(
                child: Text("No data found."),
              );
            }
            return Column(
              children: [
                Row(
                  children: [
                    KeicyAvatarImage(
                      url: user!.imageUrl,
                      width: widthDp * 50,
                      height: widthDp * 50,
                      backColor: Colors.grey.withOpacity(0.4),
                      borderRadius: widthDp * 50,
                      borderColor: Colors.grey.withOpacity(0.2),
                      borderWidth: 1,
                      shimmerEnable: false,
                      userName: (user!.firstName! + " " + user!.lastName!).toString().toUpperCase(),
                      textStyle: TextStyle(fontSize: fontSp * 20),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user!.firstName} ${user!.lastName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Text("Customer Since : "),
                            Text(
                              KeicyDateTime.convertDateTimeToDateString(
                                dateTime: cqi.customerSince,
                                isUTC: false,
                                formats: "d M Y",
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Divider(),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Total transaction value "),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "₹ ${cqi.totalOrdersAmount.toString()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Numer of Orders "),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        cqi.noOfOrders.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Last purchase amount"),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${cqi.lastPurchaseAmount == null ? 'NA' : "₹ " + cqi.lastPurchaseAmount.toString()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Last purchase date "),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        cqi.lastPurchaseDate == null
                            ? "NA"
                            : KeicyDateTime.convertDateTimeToDateString(
                                dateTime: cqi.lastPurchaseDate,
                                isUTC: false,
                                formats: "d M Y",
                              ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
