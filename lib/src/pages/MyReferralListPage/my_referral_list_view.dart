import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/user_reward_point_widget.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class MyReferralListView extends StatefulWidget {
  MyReferralListView({Key? key}) : super(key: key);

  @override
  _MyReferralListViewState createState() => _MyReferralListViewState();
}

class _MyReferralListViewState extends State<MyReferralListView> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  AuthProvider? _authProvider;
  ReferralRewardS2UOffersProvider? _referralRewardS2UOffersProvider;

  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String status = "ALL";

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
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _referralRewardS2UOffersProvider = ReferralRewardS2UOffersProvider.of(context);
    _authProvider = AuthProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    // _referralRewardS2UOffersProvider!.setReferralRewardS2UOffersState(
    //   _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.update(
    //     progressState: 0,
    //     referralRewardOffersListData: Map<String, dynamic>(),
    //     referralRewardOffersMetaData: Map<String, dynamic>(),
    //   ),
    //   isNotifiable: false,
    // );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _referralRewardS2UOffersProvider!.addListener(_referralRewardS2UOffersProviderListener);

      if (_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.progressState == 0) {
        _referralRewardS2UOffersProvider!
            .setReferralRewardS2UOffersState(_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.update(progressState: 1));
        _referralRewardS2UOffersProvider!.getReferralRewardS2UOffersData(
          referredByStoreId: _authProvider!.authState.storeModel!.id,
        );
      }
    });
  }

  @override
  void dispose() {
    _referralRewardS2UOffersProvider!.removeListener(_referralRewardS2UOffersProviderListener);

    super.dispose();
  }

  void _referralRewardS2UOffersProviderListener() async {
    if (_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.progressState == -1) {
      if (_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.isRefresh!) {
        _referralRewardS2UOffersProvider!.setReferralRewardS2UOffersState(
          _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.progressState == 2) {
      if (_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.isRefresh!) {
        _referralRewardS2UOffersProvider!.setReferralRewardS2UOffersState(
          _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic> referralRewardOffersListData = _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData!;
    Map<String, dynamic> referralRewardOffersMetaData = _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersMetaData!;

    referralRewardOffersListData[status] = [];
    referralRewardOffersMetaData[status] = Map<String, dynamic>();
    _referralRewardS2UOffersProvider!.setReferralRewardS2UOffersState(
      _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.update(
        progressState: 1,
        referralRewardOffersListData: referralRewardOffersListData,
        referralRewardOffersMetaData: referralRewardOffersMetaData,
        isRefresh: true,
      ),
    );

    _referralRewardS2UOffersProvider!.getReferralRewardS2UOffersData(
      referredByStoreId: _authProvider!.authState.storeModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _referralRewardS2UOffersProvider!.setReferralRewardS2UOffersState(
      _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.update(progressState: 1),
    );
    _referralRewardS2UOffersProvider!.getReferralRewardS2UOffersData(
      referredByStoreId: _authProvider!.authState.storeModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyMyReferralListHandler() {
    Map<String, dynamic> referralRewardOffersListData = _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData!;
    Map<String, dynamic> referralRewardOffersMetaData = _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersMetaData!;

    referralRewardOffersListData[status] = [];
    referralRewardOffersMetaData[status] = Map<String, dynamic>();
    _referralRewardS2UOffersProvider!.setReferralRewardS2UOffersState(
      _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.update(
        progressState: 1,
        referralRewardOffersListData: referralRewardOffersListData,
        referralRewardOffersMetaData: referralRewardOffersMetaData,
      ),
    );

    _referralRewardS2UOffersProvider!.getReferralRewardS2UOffersData(
      referredByStoreId: _authProvider!.authState.storeModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Referrals",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<ReferralRewardS2UOffersProvider>(builder: (context, referralRewardS2UOffersProvider, _) {
        if (referralRewardS2UOffersProvider.referralRewardU2UOffersState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _searchField(),
              Expanded(child: _myReferralListPanel()),
            ],
          ),
        );
      }),
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
        textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
        hintText: MyReferralListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyMyReferralListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyMyReferralListHandler();
        },
      ),
    );
  }

  Widget _myReferralListPanel() {
    List<dynamic> myReferralList = [];
    Map<String, dynamic> referralRewardOffersMetaData = Map<String, dynamic>();

    if (_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData![status] != null) {
      myReferralList = _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData![status];
    }
    if (_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersMetaData![status] != null) {
      referralRewardOffersMetaData = _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersMetaData![status];
    }

    int itemCount = 0;

    if (_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData![status] != null) {
      List<dynamic> data = _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.referralRewardOffersListData![status];
      itemCount += data.length;
    }

    if (_referralRewardS2UOffersProvider!.referralRewardU2UOffersState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return Column(
      children: [
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();
              return true;
            },
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: (referralRewardOffersMetaData["nextPage"] != null &&
                  _referralRewardS2UOffersProvider!.referralRewardU2UOffersState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "You haven't referred anyone.",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> referralRewardData = (index >= myReferralList.length) ? Map<String, dynamic>() : myReferralList[index];

                        return UserRewardPointWidget(
                          referralRewardData: referralRewardData,
                          isLoading: referralRewardData.isEmpty,
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
