import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/reverse_auction_widget.dart';
import 'package:trapp/src/pages/ReverseAuctionDetailPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class ReverseAuctionListView extends StatefulWidget {
  final bool haveAppBar;

  ReverseAuctionListView({Key? key, this.haveAppBar = false}) : super(key: key);

  @override
  _ReverseAuctionListViewState createState() => _ReverseAuctionListViewState();
}

class _ReverseAuctionListViewState extends State<ReverseAuctionListView> with SingleTickerProviderStateMixin {
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
  ReverseAuctionProvider? _reverseAuctionProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;
  ScrollController? _controller;

  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 0;

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

    _reverseAuctionProvider = ReverseAuctionProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshControllerList = [];
    for (var i = 0; i < AppConfig.reverseAuctionStatusData.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 0;

    _tabController = TabController(length: AppConfig.reverseAuctionStatusData.length, vsync: this);

    _tabController!.addListener(_tabControllerListener);
    _controller = ScrollController();

    _reverseAuctionProvider!.setReverseAuctionState(
      _reverseAuctionProvider!.reverseAuctionState.update(
        reverseAuctionListData: Map<String, dynamic>(),
        reverseAuctionMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _reverseAuctionProvider!.addListener(_reverseAuctionProviderListener);

      _reverseAuctionProvider!.setReverseAuctionState(_reverseAuctionProvider!.reverseAuctionState.update(progressState: 1));
      _reverseAuctionProvider!.getReverseAuctionDataByStore(
        storeId: _authProvider!.authState.storeModel!.id,
        status: AppConfig.reverseAuctionStatusData[0]["id"],
      );
    });
  }

  @override
  void dispose() {
    _reverseAuctionProvider!.removeListener(_reverseAuctionProviderListener);

    super.dispose();
  }

  void _reverseAuctionProviderListener() async {
    if (_reverseAuctionProvider!.reverseAuctionState.progressState == -1) {
      if (_reverseAuctionProvider!.reverseAuctionState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _reverseAuctionProvider!.setReverseAuctionState(
          _reverseAuctionProvider!.reverseAuctionState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_reverseAuctionProvider!.reverseAuctionState.progressState == 2) {
      if (_reverseAuctionProvider!.reverseAuctionState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _reverseAuctionProvider!.setReverseAuctionState(
          _reverseAuctionProvider!.reverseAuctionState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if ((_reverseAuctionProvider!.reverseAuctionState.progressState != 1) &&
        (_textController.text.isNotEmpty ||
            _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] ==
                null ||
            _reverseAuctionProvider!
                .reverseAuctionState.reverseAuctionListData![AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]].isEmpty)) {
      Map<String, dynamic>? reverseAuctionListData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData;
      Map<String, dynamic>? reverseAuctionMetaData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData;

      if (_oldTabIndex != _tabController!.index && _textController.text.isNotEmpty) {
        reverseAuctionListData![AppConfig.reverseAuctionStatusData[_oldTabIndex]["id"]] = [];
        reverseAuctionMetaData![AppConfig.reverseAuctionStatusData[_oldTabIndex]["id"]] = Map<String, dynamic>();
      }

      _reverseAuctionProvider!.setReverseAuctionState(
        _reverseAuctionProvider!.reverseAuctionState.update(
          progressState: 1,
          reverseAuctionListData: reverseAuctionListData,
          reverseAuctionMetaData: reverseAuctionMetaData,
        ),
        isNotifiable: false,
      );

      _textController.clear();
      _oldTabIndex = _tabController!.index;

      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _reverseAuctionProvider!.getReverseAuctionDataByStore(
          storeId: _authProvider!.authState.storeModel!.id,
          status: AppConfig.reverseAuctionStatusData[_tabController!.index]["id"],
          searchKey: _textController.text.trim(),
        );
      });
    } else {
      _oldTabIndex = _tabController!.index;
      setState(() {});
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? reverseAuctionListData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData;
    Map<String, dynamic>? reverseAuctionMetaData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData;

    reverseAuctionListData![AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] = [];
    reverseAuctionMetaData![AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _reverseAuctionProvider!.setReverseAuctionState(
      _reverseAuctionProvider!.reverseAuctionState.update(
        progressState: 1,
        reverseAuctionListData: reverseAuctionListData,
        reverseAuctionMetaData: reverseAuctionMetaData,
        isRefresh: true,
      ),
    );

    _reverseAuctionProvider!.getReverseAuctionDataByStore(
      storeId: _authProvider!.authState.storeModel!.id,
      status: AppConfig.reverseAuctionStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _reverseAuctionProvider!.setReverseAuctionState(
      _reverseAuctionProvider!.reverseAuctionState.update(progressState: 1),
    );
    _reverseAuctionProvider!.getReverseAuctionDataByStore(
      storeId: _authProvider!.authState.storeModel!.id,
      status: AppConfig.reverseAuctionStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _searchKeyReverseAuctionListHandler() {
    Map<String, dynamic>? reverseAuctionListData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData;
    Map<String, dynamic>? reverseAuctionMetaData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData;

    reverseAuctionListData![AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] = [];
    reverseAuctionMetaData![AppConfig.reverseAuctionStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _reverseAuctionProvider!.setReverseAuctionState(
      _reverseAuctionProvider!.reverseAuctionState.update(
        progressState: 1,
        reverseAuctionListData: reverseAuctionListData,
        reverseAuctionMetaData: reverseAuctionMetaData,
      ),
    );

    _reverseAuctionProvider!.getReverseAuctionDataByStore(
      storeId: _authProvider!.authState.storeModel!.id,
      status: AppConfig.reverseAuctionStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !widget.haveAppBar
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                "Reverse Auction",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: Consumer<ReverseAuctionProvider>(builder: (context, reverseAuctionProvider, _) {
        if (reverseAuctionProvider.reverseAuctionState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return DefaultTabController(
          length: AppConfig.reverseAuctionStatusData.length,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _searchField(),
                _tabBar(),
                Expanded(child: _reverseAuctionListPanel()),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: KeicyTextFormField(
        controller: _textController,
        focusNode: _focusNode,
        width: null,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        contentVerticalPadding: heightDp * 8,
        textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
        hintText: ReverseAuctionListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _textController.clear();
              _searchKeyReverseAuctionListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyReverseAuctionListHandler();
        },
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      ),
      alignment: Alignment.center,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        indicatorWeight: 1,
        labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 5),
        labelStyle: TextStyle(fontSize: fontSp * 14),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: List.generate(AppConfig.reverseAuctionStatusData.length, (index) {
          return Tab(
            child: Container(
              width: widthDp * 110,
              height: heightDp * 35,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _tabController!.index == index ? config.Colors().mainColor(1) : Colors.white,
                borderRadius: BorderRadius.circular(heightDp * 30),
              ),
              child: Text(
                "${AppConfig.reverseAuctionStatusData[index]["name"]}",
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _reverseAuctionListPanel() {
    String status = AppConfig.reverseAuctionStatusData[_tabController!.index]["id"];

    List<dynamic> reverseAuctionList = [];
    Map<String, dynamic> reverseAuctionMetaData = Map<String, dynamic>();

    if (_reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![status] != null) {
      reverseAuctionList = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![status];
    }
    if (_reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData![status] != null) {
      reverseAuctionMetaData = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionMetaData![status];
    }

    int itemCount = 0;

    if (_reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![status] != null) {
      int length = _reverseAuctionProvider!.reverseAuctionState.reverseAuctionListData![status].length;
      itemCount += length;
    }

    if (_reverseAuctionProvider!.reverseAuctionState.progressState == 1) {
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
              enablePullUp: (reverseAuctionMetaData["nextPage"] != null && _reverseAuctionProvider!.reverseAuctionState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList[_tabController!.index],
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Reverse Auction Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      controller: _controller,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> reverseAuctionData =
                            (index >= reverseAuctionList.length) ? Map<String, dynamic>() : reverseAuctionList[index];

                        return ReverseAuctionWidget(
                          reverseAuctionData: reverseAuctionData,
                          loadingStatus: reverseAuctionData.isEmpty,
                          detailCallback: () {
                            _detailCallback(reverseAuctionData);
                          },
                          placeBidCallback: () {
                            NormalAskDialog.show(
                              context,
                              title: "Auction Place Bid",
                              content: "Do you want a place a bid for this user auction?",
                              callback: () async {
                                double leastOfferPrice = 0;
                                double yourOfferPrice = 0;
                                if (reverseAuctionData["storeBiddingPriceList"] != null) {
                                  reverseAuctionData["storeBiddingPriceList"].forEach((key, value) {
                                    if (leastOfferPrice == 0) leastOfferPrice = double.parse(value["offerPrice"]);
                                    if (leastOfferPrice > double.parse(value["offerPrice"])) {
                                      leastOfferPrice = double.parse(value["offerPrice"]);
                                    }

                                    if (reverseAuctionData["storeId"] == key) {
                                      yourOfferPrice = double.parse(value["offerPrice"]);
                                    }
                                  });
                                }

                                StoreOfferPriceDialog.show(
                                  context,
                                  leastOfferPrice: leastOfferPrice,
                                  yourOfferPrice: yourOfferPrice,
                                  yourMessage: "",
                                  callback: (price, message) {
                                    _placeBidCallback(reverseAuctionData, price, message);
                                  },
                                );
                              },
                            );
                          },
                          acceptCallback: () {
                            NormalAskDialog.show(
                              context,
                              title: "Auction Accept",
                              content: "You are going to accept the auction for ${reverseAuctionData["biddingPrice"]}, would you like to accept?",
                              callback: () async {
                                _placeBidCallback(reverseAuctionData, reverseAuctionData["biddingPrice"], "");
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _detailCallback(Map<String, dynamic> reverseAuctionData) async {
    _reverseAuctionProvider!.removeListener(_reverseAuctionProviderListener);
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ReverseAuctionDetailPage(reverseAuctionData: reverseAuctionData),
      ),
    );
    _reverseAuctionProvider!.addListener(_reverseAuctionProviderListener);
    if (result != null) {
      for (var i = 0; i < AppConfig.reverseAuctionStatusData.length; i++) {
        if (result == AppConfig.reverseAuctionStatusData[i]["id"]) {
          _tabController!.animateTo(i);
          _onRefresh();
          _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
          break;
        }
      }
    }
  }

  void _placeBidCallback(Map<String, dynamic> reverseAuctionData, String offerPrice, String message) async {
    if (reverseAuctionData["storeBiddingPriceList"] == null) reverseAuctionData["storeBiddingPriceList"] = Map<String, dynamic>();
    reverseAuctionData["storeBiddingPriceList"][reverseAuctionData["storeId"]] = {
      "offerPrice": offerPrice,
      "message": message,
    };

    await _keicyProgressDialog!.show();
    var result = await _reverseAuctionProvider!.updateReverseAuctionData(
      reverseAuctionData: reverseAuctionData,
      storeOfferData: {
        "storeId": reverseAuctionData["storeId"],
        "offerPrice": offerPrice,
        "message": message,
      },
      status: AppConfig.reverseAuctionStatusData[2]["id"],
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      // storeName: AuthProvider.of(context).authState.userData["storeData"]["name"],
      // userName: "${reverseAuctionData["user"]["firstName"]} ${reverseAuctionData["user"]["lastName"]}",
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _tabController!.animateTo(2);
      _onRefresh();
      _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _placeBidCallback(reverseAuctionData, offerPrice, message);
        },
      );
    }
  }
}
