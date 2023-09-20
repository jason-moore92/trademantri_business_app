import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/bargain_request_widget.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BargainRequestDetailPage_new/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class BargainRequestListView extends StatefulWidget {
  final bool haveAppBar;

  BargainRequestListView({Key? key, this.haveAppBar = false}) : super(key: key);

  @override
  _BargainRequestListViewState createState() => _BargainRequestListViewState();
}

class _BargainRequestListViewState extends State<BargainRequestListView> with SingleTickerProviderStateMixin {
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
  BargainRequestProvider? _bargainRequestProvider;
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

    _bargainRequestProvider = BargainRequestProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshControllerList = [];
    for (var i = 0; i < AppConfig.bargainRequestStatusData.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 0;

    _tabController = TabController(length: AppConfig.bargainRequestStatusData.length, vsync: this);

    _tabController!.addListener(_tabControllerListener);
    _controller = ScrollController();

    _bargainRequestProvider!.setBargainRequestState(
      _bargainRequestProvider!.bargainRequestState.update(
        bargainRequestListData: Map<String, dynamic>(),
        bargainRequestMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _bargainRequestProvider!.addListener(_bargainRequestProviderListener);

      _bargainRequestProvider!.setBargainRequestState(_bargainRequestProvider!.bargainRequestState.update(progressState: 1));
      _bargainRequestProvider!.getBargainRequestData(
        storeId: _authProvider!.authState.storeModel!.id,
        status: AppConfig.bargainRequestStatusData[0]["id"],
      );
    });
  }

  @override
  void dispose() {
    _bargainRequestProvider!.removeListener(_bargainRequestProviderListener);

    super.dispose();
  }

  void _bargainRequestProviderListener() async {
    if (_bargainRequestProvider!.bargainRequestState.progressState == -1) {
      if (_bargainRequestProvider!.bargainRequestState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _bargainRequestProvider!.setBargainRequestState(
          _bargainRequestProvider!.bargainRequestState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_bargainRequestProvider!.bargainRequestState.progressState == 2) {
      if (_bargainRequestProvider!.bargainRequestState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _bargainRequestProvider!.setBargainRequestState(
          _bargainRequestProvider!.bargainRequestState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if ((_bargainRequestProvider!.bargainRequestState.progressState != 1) &&
        (_textController.text.isNotEmpty ||
            _bargainRequestProvider!.bargainRequestState.bargainRequestListData![AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] ==
                null ||
            _bargainRequestProvider!
                .bargainRequestState.bargainRequestListData![AppConfig.bargainRequestStatusData[_tabController!.index]["id"]].isEmpty)) {
      Map<String, dynamic>? bargainRequestListData = _bargainRequestProvider!.bargainRequestState.bargainRequestListData;
      Map<String, dynamic>? bargainRequestMetaData = _bargainRequestProvider!.bargainRequestState.bargainRequestMetaData;

      if (_oldTabIndex != _tabController!.index && _textController.text.isNotEmpty) {
        bargainRequestListData![AppConfig.bargainRequestStatusData[_oldTabIndex]["id"]] = [];
        bargainRequestMetaData![AppConfig.bargainRequestStatusData[_oldTabIndex]["id"]] = Map<String, dynamic>();
      }

      _bargainRequestProvider!.setBargainRequestState(
        _bargainRequestProvider!.bargainRequestState.update(
          progressState: 1,
          bargainRequestListData: bargainRequestListData,
          bargainRequestMetaData: bargainRequestMetaData,
        ),
        isNotifiable: false,
      );

      _textController.clear();
      _oldTabIndex = _tabController!.index;

      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _bargainRequestProvider!.getBargainRequestData(
          storeId: _authProvider!.authState.storeModel!.id,
          status: AppConfig.bargainRequestStatusData[_tabController!.index]["id"],
          searchKey: _textController.text.trim(),
        );
      });
    } else {
      _oldTabIndex = _tabController!.index;
      setState(() {});
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? bargainRequestListData = _bargainRequestProvider!.bargainRequestState.bargainRequestListData;
    Map<String, dynamic>? bargainRequestMetaData = _bargainRequestProvider!.bargainRequestState.bargainRequestMetaData;

    bargainRequestListData![AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] = [];
    bargainRequestMetaData![AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _bargainRequestProvider!.setBargainRequestState(
      _bargainRequestProvider!.bargainRequestState.update(
        progressState: 1,
        bargainRequestListData: bargainRequestListData,
        bargainRequestMetaData: bargainRequestMetaData,
        isRefresh: true,
      ),
    );

    _bargainRequestProvider!.getBargainRequestData(
      storeId: _authProvider!.authState.storeModel!.id,
      status: AppConfig.bargainRequestStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _bargainRequestProvider!.setBargainRequestState(
      _bargainRequestProvider!.bargainRequestState.update(progressState: 1),
    );
    _bargainRequestProvider!.getBargainRequestData(
      storeId: _authProvider!.authState.storeModel!.id,
      status: AppConfig.bargainRequestStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _searchKeyBargainRequestListHandler() {
    Map<String, dynamic>? bargainRequestListData = _bargainRequestProvider!.bargainRequestState.bargainRequestListData;
    Map<String, dynamic>? bargainRequestMetaData = _bargainRequestProvider!.bargainRequestState.bargainRequestMetaData;

    bargainRequestListData![AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] = [];
    bargainRequestMetaData![AppConfig.bargainRequestStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _bargainRequestProvider!.setBargainRequestState(
      _bargainRequestProvider!.bargainRequestState.update(
        progressState: 1,
        bargainRequestListData: bargainRequestListData,
        bargainRequestMetaData: bargainRequestMetaData,
      ),
    );

    _bargainRequestProvider!.getBargainRequestData(
      storeId: _authProvider!.authState.storeModel!.id,
      status: AppConfig.bargainRequestStatusData[_tabController!.index]["id"],
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
                "Bargain Requests",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: Consumer<BargainRequestProvider>(builder: (context, bargainRequestProvider, _) {
        if (bargainRequestProvider.bargainRequestState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return DefaultTabController(
          length: AppConfig.bargainRequestStatusData.length,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _searchField(),
                _tabBar(),
                Expanded(child: _bargainRequestListPanel()),
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
        hintText: BargainRequestListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _textController.clear();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyBargainRequestListHandler();
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
        tabs: List.generate(AppConfig.bargainRequestStatusData.length, (index) {
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
                "${AppConfig.bargainRequestStatusData[index]["name"]}",
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _bargainRequestListPanel() {
    String status = AppConfig.bargainRequestStatusData[_tabController!.index]["id"];

    List<dynamic> bargainRequestList = [];
    Map<String, dynamic> bargainRequestMetaData = Map<String, dynamic>();

    if (_bargainRequestProvider!.bargainRequestState.bargainRequestListData![status] != null) {
      bargainRequestList = _bargainRequestProvider!.bargainRequestState.bargainRequestListData![status];
    }
    if (_bargainRequestProvider!.bargainRequestState.bargainRequestMetaData![status] != null) {
      bargainRequestMetaData = _bargainRequestProvider!.bargainRequestState.bargainRequestMetaData![status];
    }

    int itemCount = 0;

    if (_bargainRequestProvider!.bargainRequestState.bargainRequestListData![status] != null) {
      int length = _bargainRequestProvider!.bargainRequestState.bargainRequestListData![status].length;
      itemCount += length;
    }

    if (_bargainRequestProvider!.bargainRequestState.progressState == 1) {
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
              enablePullUp: (bargainRequestMetaData["nextPage"] != null && _bargainRequestProvider!.bargainRequestState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList[_tabController!.index],
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Bargain Request Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      controller: _controller,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        BargainRequestModel? bargainRequestModel =
                            (index >= bargainRequestList.length) ? null : BargainRequestModel.fromJson(bargainRequestList[index]);

                        if (bargainRequestModel != null && bargainRequestModel.storeModel!.settings == null) {
                          bargainRequestModel.storeModel!.settings = AppConfig.initialSettings;
                        }

                        double? originPrice;
                        if (bargainRequestModel != null) {
                          if (bargainRequestModel.products!.isNotEmpty && bargainRequestModel.products![0].productModel!.price != 0) {
                            originPrice =
                                bargainRequestModel.products![0].productModel!.price! - bargainRequestModel.products![0].productModel!.discount!;
                          } else if (bargainRequestModel.services!.isNotEmpty && bargainRequestModel.services![0].serviceModel!.price != 0) {
                            originPrice =
                                bargainRequestModel.services![0].serviceModel!.price! - bargainRequestModel.services![0].serviceModel!.discount!;
                          }
                        }

                        return BargainRequestWidget(
                          bargainRequestModel: bargainRequestModel,
                          loadingStatus: bargainRequestModel == null,
                          detailCallback: () {
                            _detailCallback(BargainRequestModel.copy(bargainRequestModel!));
                          },
                          rejectCallback: () {
                            NormalAskDialog.show(
                              context,
                              title: "BargainRequest Reject",
                              content: "Do you want to reject this bargain request?",
                              callback: () async {
                                _rejectCallback(BargainRequestModel.copy(bargainRequestModel!));
                              },
                            );
                          },
                          acceptCallback: () {
                            if (originPrice == null || originPrice == 0) {
                              ErrorDialog.show(
                                context,
                                widthDp: widthDp,
                                heightDp: heightDp,
                                fontSp: fontSp,
                                text: "Please enter original price",
                                callBack: () {
                                  _detailCallback(BargainRequestModel.copy(bargainRequestModel!));
                                },
                              );
                              return;
                            }

                            NormalAskDialog.show(
                              context,
                              title: "BargainRequest accept",
                              content: "Do you want to accept this bargain request?",
                              callback: () async {
                                _acceptCallback(BargainRequestModel.copy(bargainRequestModel!));
                              },
                            );
                          },
                          counterCallback: () async {
                            if (originPrice == null || originPrice == 0) {
                              ErrorDialog.show(
                                context,
                                widthDp: widthDp,
                                heightDp: heightDp,
                                fontSp: fontSp,
                                text: "Please enter original price",
                                callBack: () {
                                  _detailCallback(BargainRequestModel.copy(bargainRequestModel!));
                                },
                              );
                              return;
                            }

                            await CounterDialog.show(
                              context,
                              bargainRequestModel: BargainRequestModel.copy(bargainRequestModel!),
                              storeModel: bargainRequestModel.storeModel,
                              widthDp: widthDp,
                              heightDp: heightDp,
                              fontSp: fontSp,
                              callBack: (newBargainRequestModel) {
                                _counterOfferCallback(newBargainRequestModel);
                              },
                            );
                          },
                        );
                      },
                      // separatorBuilder: (context, index) {
                      //   return Divider(color: Colors.grey.withOpacity(0.3), height: 5, thickness: 5);
                      // },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _detailCallback(BargainRequestModel? bargainRequestModel) async {
    _bargainRequestProvider!.removeListener(_bargainRequestProviderListener);
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => BargainRequestDetailNewPage(
          bargainRequestModel: bargainRequestModel,
        ),
      ),
    );
    _bargainRequestProvider!.addListener(_bargainRequestProviderListener);
    if (result != null) {
      for (var i = 0; i < AppConfig.bargainRequestStatusData.length; i++) {
        if (result == AppConfig.bargainRequestStatusData[i]["id"]) {
          _tabController!.animateTo(i);
          _onRefresh();
          _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
          break;
        }
      }
    }
  }

  void _rejectCallback(BargainRequestModel newBargainRequestModel) async {
    newBargainRequestModel.history!.add({
      "title": AppConfig.bargainHistoryData["rejected"]["title"],
      "text": AppConfig.bargainHistoryData["rejected"]["text"],
      "bargainType": AppConfig.bargainRequestStatusData[5]["id"],
      "date": DateTime.now().toUtc().toIso8601String(),
      "initialPrice": newBargainRequestModel.history!.first["initialPrice"],
      "offerPrice": newBargainRequestModel.offerPrice,
    });

    await _keicyProgressDialog!.show();

    var result = await _bargainRequestProvider!.updateBargainRequestData(
      bargainRequestModel: newBargainRequestModel,
      status: AppConfig.bargainRequestStatusData[5]["id"],
      subStatus: AppConfig.bargainRequestStatusData[5]["id"],
      storeId: _authProvider!.authState.storeModel!.id,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _tabController!.animateTo(5);
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
          _rejectCallback(newBargainRequestModel);
        },
      );
    }
  }

  void _acceptCallback(BargainRequestModel newBargainRequestModel) async {
    newBargainRequestModel.history!.add({
      "title": AppConfig.bargainHistoryData["accepted"]["title"],
      "text": AppConfig.bargainHistoryData["accepted"]["text"],
      "bargainType": AppConfig.bargainRequestStatusData[3]["id"],
      "date": DateTime.now().toUtc().toIso8601String(),
      "initialPrice": newBargainRequestModel.history!.first["initialPrice"],
      "offerPrice": newBargainRequestModel.offerPrice,
    });

    await _keicyProgressDialog!.show();
    var result = await _bargainRequestProvider!.updateBargainRequestData(
      bargainRequestModel: newBargainRequestModel,
      status: AppConfig.bargainRequestStatusData[3]["id"],
      subStatus: AppConfig.bargainRequestStatusData[3]["id"],
      storeId: _authProvider!.authState.storeModel!.id,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _tabController!.animateTo(3);
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
          _acceptCallback(newBargainRequestModel);
        },
      );
    }
  }

  void _counterOfferCallback(BargainRequestModel? newBargainRequestModel) async {
    await _keicyProgressDialog!.show();
    List<dynamic> tmp = [];
    for (var i = 0; i < newBargainRequestModel!.storeOfferPriceList!.length; i++) {
      tmp.add(newBargainRequestModel.storeOfferPriceList![i]);
    }
    tmp.add(newBargainRequestModel.offerPrice);
    newBargainRequestModel.storeOfferPriceList = tmp;

    newBargainRequestModel.history!.add({
      "title": AppConfig.bargainHistoryData["store_count_offer"]["title"],
      "text": AppConfig.bargainHistoryData["store_count_offer"]["text"],
      "bargainType": AppConfig.bargainRequestStatusData[2]["id"],
      "date": DateTime.now().toUtc().toIso8601String(),
      "initialPrice": newBargainRequestModel.history!.first["initialPrice"],
      "offerPrice": newBargainRequestModel.offerPrice,
    });

    var result = await _bargainRequestProvider!.updateBargainRequestData(
      bargainRequestModel: newBargainRequestModel,
      status: AppConfig.bargainRequestStatusData[2]["id"],
      subStatus: AppConfig.bargainSubStatusData[2]["id"],
      storeId: _authProvider!.authState.storeModel!.id,
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
          _counterOfferCallback(newBargainRequestModel);
        },
      );
    }
  }
}
