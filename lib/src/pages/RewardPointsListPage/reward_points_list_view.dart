import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/pages/CreateRewardPointsPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/pages/RewardPointsForCustomerPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class RewardPointsListView extends StatefulWidget {
  RewardPointsListView({Key? key}) : super(key: key);

  @override
  _RewardPointsListViewState createState() => _RewardPointsListViewState();
}

class _RewardPointsListViewState extends State<RewardPointsListView> with SingleTickerProviderStateMixin {
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

  AuthProvider? _authProvider;
  RewardPointsListProvider? _rewardPointsListProvider;
  KeicyProgressDialog? _keicyProgressDialog;

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

    _rewardPointsListProvider = RewardPointsListProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _rewardPointsListProvider!.addListener(_rewardPointsListProviderListener);
      if (_rewardPointsListProvider!.rewardPointsListState.progressState != 2) {
        _rewardPointsListProvider!.getRewardPointById(
          storeId: _authProvider!.authState.storeModel!.id,
        );
      }
    });
  }

  @override
  void dispose() {
    _rewardPointsListProvider!.removeListener(_rewardPointsListProviderListener);

    super.dispose();
  }

  void _rewardPointsListProviderListener() async {
    if (_rewardPointsListProvider!.rewardPointsListState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Configure Reward Points",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<RewardPointsListProvider>(builder: (context, rewardPointsListProvider, _) {
        if (rewardPointsListProvider.rewardPointsListState.progressState == 0 || rewardPointsListProvider.rewardPointsListState.progressState == 1) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (rewardPointsListProvider.rewardPointsListState.progressState == -1) {
          return ErrorPage(
            message: rewardPointsListProvider.rewardPointsListState.message,
            callback: () {
              rewardPointsListProvider.setRewardPointsListState(
                rewardPointsListProvider.rewardPointsListState.update(
                  progressState: 1,
                ),
              );

              _rewardPointsListProvider!.getRewardPointById(
                storeId: _authProvider!.authState.storeModel!.id,
              );
            },
          );
        }

        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              Container(
                width: deviceWidth,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_rewardPointsListProvider!.rewardPointsListState.rewardPointsList!.length == 0)
                      KeicyRaisedButton(
                        width: widthDp * 150,
                        height: heightDp * 40,
                        color: config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                        child: Text(
                          "+ Add Config",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                        onPressed: () async {
                          var result = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) => CreateRewardPointsPage()),
                          );

                          if (result != null) {
                            _rewardPointsListProvider!.setRewardPointsListState(
                              _rewardPointsListProvider!.rewardPointsListState.update(rewardPointsList: [result]),
                            );
                            setState(() {});
                          }
                        },
                      )
                    else
                      KeicyRaisedButton(
                        width: widthDp * 185,
                        height: heightDp * 40,
                        color: config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                        child: Text(
                          "See Customers Reward",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) => RewardPointsForCustomerPage()),
                          );
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: heightDp * 10),
              Expanded(child: _rewardPointsListPanel()),
            ],
          ),
        );
      }),
    );
  }

  Widget _rewardPointsListPanel() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: ListView.builder(
        itemCount: _rewardPointsListProvider!.rewardPointsListState.rewardPointsList!.length,
        itemBuilder: (context, index) {
          var rewardPointsData = _rewardPointsListProvider!.rewardPointsListState.rewardPointsList![index];

          return _rewardPointPanel(index, rewardPointsData);
        },
      ),
    );
  }

  Widget _rewardPointPanel(int index, Map<String, dynamic> rewardPointsData) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 8),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Buy : ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "RewardPoints : ${rewardPointsData["buy"]["rewardPoints"]}",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                      Text(
                        "Value : ${rewardPointsData["buy"]["value"]}",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: widthDp * 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Redeem : ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "RewardPoints : ${rewardPointsData["redeem"]["rewardPoints"]}",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                      Text(
                        "Value : ${rewardPointsData["redeem"]["value"]}",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: heightDp * 15),
            Row(
              children: [
                Text(
                  "Min Order Amount : ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${rewardPointsData["minOrderAmount"]}",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Max Rewards Per Order : ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${rewardPointsData["maxRewardsPerOrder"]}",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: heightDp * 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Start Date: ",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          KeicyDateTime.convertDateTimeToDateString(
                            dateTime: DateTime.tryParse(rewardPointsData["validity"]["startDate"]),
                            isUTC: false,
                          ),
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "End Date: ",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          rewardPointsData["validity"]["endDate"] == null || rewardPointsData["validity"]["endDate"] == ""
                              ? "Not Defined"
                              : KeicyDateTime.convertDateTimeToDateString(
                                  dateTime: DateTime.tryParse(rewardPointsData["validity"]["endDate"]),
                                  isUTC: false,
                                ),
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                KeicyRaisedButton(
                  width: widthDp * 130,
                  height: heightDp * 35,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 6,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  child: Text(
                    "Configure",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: () async {
                    var result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => CreateRewardPointsPage(
                          isNew: false,
                          rewardPointsData: rewardPointsData,
                        ),
                      ),
                    );

                    if (result != null) {
                      _rewardPointsListProvider!.rewardPointsListState.rewardPointsList![index] = result;
                      setState(() {});
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
