import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';

import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/pages/RewardPointsHistoryPage/index.dart';

import 'index.dart';

class RewardPointsForCustomerView extends StatefulWidget {
  RewardPointsForCustomerView({Key? key}) : super(key: key);

  @override
  _RewardPointsForCustomerViewState createState() => _RewardPointsForCustomerViewState();
}

class _RewardPointsForCustomerViewState extends State<RewardPointsForCustomerView> {
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

  RewardPointsForCustomerProvider? _rewardPointsForCustomerProvider;
  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  String? _storeId;

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

    _rewardPointsForCustomerProvider = RewardPointsForCustomerProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _storeId = AuthProvider.of(context).authState.storeModel!.id;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _rewardPointsForCustomerProvider!.addListener(_rewardPointsForCustomerProviderListener);

      _rewardPointsForCustomerProvider!.sumRewardPointsForCustomer(
        storeId: _storeId,
      );
      _rewardPointsForCustomerProvider!.getRewardPointsForCustomer(
        storeId: _storeId,
      );
    });
  }

  @override
  void dispose() {
    _rewardPointsForCustomerProvider!.removeListener(_rewardPointsForCustomerProviderListener);
    super.dispose();
  }

  void _rewardPointsForCustomerProviderListener() async {
    if (_rewardPointsForCustomerProvider!.rewardPointsForCustomerState.progressState == -1) {
      if (_rewardPointsForCustomerProvider!.rewardPointsForCustomerState.isRefresh!) {
        _refreshController!.refreshFailed();
        _rewardPointsForCustomerProvider!.setRewardPointsForCustomerState(
          _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_rewardPointsForCustomerProvider!.rewardPointsForCustomerState.progressState == 2) {
      if (_rewardPointsForCustomerProvider!.rewardPointsForCustomerState.isRefresh!) {
        _refreshController!.refreshCompleted();
        _rewardPointsForCustomerProvider!.setRewardPointsForCustomerState(
          _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List? rewardPointListData = _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointListData;
    Map<String, dynamic>? rewardPointMetaData = _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointMetaData;

    rewardPointListData = [];
    rewardPointMetaData = Map<String, dynamic>();
    _rewardPointsForCustomerProvider!.setRewardPointsForCustomerState(
      _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.update(
        progressState: 1,
        rewardPointListData: rewardPointListData,
        rewardPointMetaData: rewardPointMetaData,
        isRefresh: true,
      ),
    );

    _rewardPointsForCustomerProvider!.getRewardPointsForCustomer(
      storeId: _storeId,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _rewardPointsForCustomerProvider!.setRewardPointsForCustomerState(
      _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.update(progressState: 1),
    );
    _rewardPointsForCustomerProvider!.getRewardPointsForCustomer(
      storeId: _storeId,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyProductListHandler() {
    List? rewardPointListData = _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointListData;
    Map<String, dynamic>? rewardPointMetaData = _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointMetaData;

    rewardPointListData = [];
    rewardPointMetaData = Map<String, dynamic>();
    _rewardPointsForCustomerProvider!.setRewardPointsForCustomerState(
      _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.update(
        progressState: 1,
        rewardPointListData: rewardPointListData,
        rewardPointMetaData: rewardPointMetaData,
        isRefresh: true,
      ),
    );

    _rewardPointsForCustomerProvider!.getRewardPointsForCustomer(
      storeId: _storeId,
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "My Customers Reward Points",
          style: TextStyle(fontSize: fontSp * 18, color: Color(0xFF162779)),
        ),
        elevation: 0,
        flexibleSpace: Container(
          height: statusbarHeight + appbarHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFE4E4FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Consumer<RewardPointsForCustomerProvider>(builder: (context, rewardPointsForCustomerProvider, _) {
          if (rewardPointsForCustomerProvider.rewardPointsForCustomerState.progressState == 0) {
            return Column(
              children: [
                Image.asset("img/rewardPoints.png", width: deviceWidth, fit: BoxFit.fitWidth),
                Expanded(child: Center(child: CupertinoActivityIndicator())),
              ],
            );
          }

          if (rewardPointsForCustomerProvider.rewardPointsForCustomerState.progressState == -1) {
            return Column(
              children: [
                Image.asset("img/rewardPoints.png", width: deviceWidth, fit: BoxFit.fitWidth),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(widthDp * 20),
                      child: Text(
                        rewardPointsForCustomerProvider.rewardPointsForCustomerState.message!,
                        style: TextStyle(fontSize: fontSp * 16),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Stack(
                children: [
                  Image.asset("img/rewardPoints.png", width: deviceWidth, fit: BoxFit.fitWidth),
                  Positioned(
                    left: widthDp * 70,
                    top: widthDp * 90,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(heightDp * 8),
                        color: Color(0xFF162779),
                      ),
                      child: Text(
                        "${rewardPointsForCustomerProvider.rewardPointsForCustomerState.sumRewardPoint}",
                        style: TextStyle(fontSize: fontSp * 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              _searchField(),
              SizedBox(height: heightDp * 10),
              Expanded(child: _rewardPointListPanel()),
            ],
          );
        }),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: KeicyTextFormField(
        controller: _controller,
        focusNode: _focusNode,
        width: null,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        contentVerticalPadding: heightDp * 8,
        textInputAction: TextInputAction.done,
        textStyle: TextStyle(fontSize: fontSp * 12, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 12, color: Colors.grey.withOpacity(0.6)),
        hintText: RewardPointsForCustomerPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyProductListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        // onEditingCompleteHandler: () {
        //   FocusScope.of(context).requestFocus(FocusNode());
        //   _searchKeyProductListHandler();
        // },
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyProductListHandler();
        },
      ),
    );
  }

  Widget _rewardPointListPanel() {
    List<dynamic> rewardPointListData = [];
    Map<String, dynamic> rewardPointMetaData = Map<String, dynamic>();

    if (_rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointListData != null) {
      rewardPointListData = _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointListData!;
    }
    if (_rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointMetaData != null) {
      rewardPointMetaData = _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointMetaData!;
    }

    int itemCount = 0;

    if (_rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointListData != null) {
      itemCount += _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.rewardPointListData!.length;
    }

    if (_rewardPointsForCustomerProvider!.rewardPointsForCustomerState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (rewardPointMetaData["nextPage"] != null && _rewardPointsForCustomerProvider!.rewardPointsForCustomerState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshController!,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Reward Point Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  dynamic rewardData = (index >= rewardPointListData.length) ? Map<String, dynamic>() : rewardPointListData[index];

                  return rewardData.isEmpty ? _storeShimmerWidget() : _storeWidget(rewardData);
                },
              ),
      ),
    );
  }

  Widget _storeWidget(dynamic rewardData) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => RewardPointsHistoryPage(
              historyData: rewardData["history"],
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
          alignment: Alignment.center,
          child: Row(
            children: [
              KeicyAvatarImage(
                url: rewardData["user"]["imageUrl"],
                width: heightDp * 60,
                height: heightDp * 60,
                backColor: Colors.grey.withOpacity(0.4),
                borderRadius: heightDp * 60,
                borderColor: Colors.grey.withOpacity(0.2),
                borderWidth: 1,
                userName: rewardData["user"]["firstName"],
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${rewardData["user"]["firstName"]} ${rewardData["user"]["lastName"]}",
                      style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w500),
                    ),
                    // SizedBox(height: heightDp * 5),
                    // Text(
                    //   rewardData["user"]["email"],
                    //   style: TextStyle(fontSize: fontSp * 12, color: Colors.grey),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ],
                ),
              ),
              SizedBox(width: widthDp * 10),
              Column(
                children: [
                  Row(
                    children: [
                      Image.asset("img/reward_points_icon.png", width: heightDp * 25, height: heightDp * 25),
                      SizedBox(width: widthDp * 5),
                      Text(
                        "${rewardData["rewardPoints"]}",
                        style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold, color: config.Colors().mainColor(1)),
                      ),
                    ],
                  ),
                  // SizedBox(height: heightDp * 10),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 6), color: config.Colors().mainColor(1)),
                  //   child: Text(
                  //     "Redeem",
                  //     style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600, color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storeShimmerWidget() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        direction: ShimmerDirection.ltr,
        enabled: true,
        period: Duration(milliseconds: 1000),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                width: heightDp * 80,
                height: heightDp * 80,
                color: Colors.white,
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text("dummy store name", style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: heightDp * 5),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "store dummy address store dummy addressstore dummy address store dummy address store dummy address",
                        style: TextStyle(fontSize: fontSp * 12, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: widthDp * 10),
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Image.asset("img/reward_points_icon.png", width: heightDp * 25, height: heightDp * 25),
                        SizedBox(width: widthDp * 5),
                        Text(
                          "100",
                          style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.bold, color: config.Colors().mainColor(1)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: heightDp * 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 6), color: Colors.white),
                    child: Text(
                      "Redeem",
                      style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
