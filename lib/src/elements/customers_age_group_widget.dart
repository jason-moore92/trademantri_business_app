import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/dto/customer_age_group.dart';
import 'package:trapp/src/pages/CustomerAgeGroups/index.dart';
import 'package:trapp/src/providers/index.dart';

class CustomersAgeGroupWidget extends StatelessWidget {
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
        height: heightDp * 370,
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
                      "Age Groups",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => CustomerAgeGroupsPage(),
                        ),
                      );
                    },
                    child: Icon(Icons.launch),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<CustomerAgeGroup>>(
              future: customersProvider!.getCustomersByAgeGroup(
                storeId: authProvider!.authState.storeModel!.id,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return _shimmerWidget;
                }

                List<CustomerAgeGroup>? groups = snapshot.data;

                if (groups == null) {
                  return Center(
                    child: Text("No age data"),
                  );
                }
                if (groups.length == 0) {
                  return Center(
                    child: Text("No age data"),
                  );
                }
                return Column(
                  children: [
                    Container(
                      width: widthDp * 250,
                      height: heightDp * 250,
                      child: PieChart(
                        PieChartData(
                          sections: groups
                              .map(
                                (e) => PieChartSectionData(
                                  value: e.count!.toDouble(),
                                  color: config.Colors().customerAgeGroup(e.key!),
                                  // title: e.name!,
                                  titleStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: groups
                          .map((e) => Row(
                                children: [
                                  Container(
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      color: config.Colors().customerAgeGroup(e.key!),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(e.name!),
                                ],
                              ))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
