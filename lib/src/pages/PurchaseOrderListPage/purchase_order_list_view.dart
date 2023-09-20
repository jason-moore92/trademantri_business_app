import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/purchase_order_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/PurchaseOrderDetailPage/purchase_order_detail_page.dart';
import 'package:trapp/src/pages/PurchaseOrderPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class PurchaseOrderListView extends StatefulWidget {
  PurchaseOrderListView({Key? key}) : super(key: key);

  @override
  _PurchaseOrderListViewState createState() => _PurchaseOrderListViewState();
}

class _PurchaseOrderListViewState extends State<PurchaseOrderListView> with SingleTickerProviderStateMixin {
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

  PurchaseListProvider? _purchaseListProvider;
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

    _purchaseListProvider = PurchaseListProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _controller = ScrollController();

    _refreshControllerList = [];
    for (var i = 0; i < AppConfig.purchaseStatusData.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 0;

    _tabController = TabController(length: AppConfig.purchaseStatusData.length, vsync: this);

    _tabController!.addListener(_tabControllerListener);

    Map<String, List<PurchaseModel>?>? purchaseLists = _purchaseListProvider!.purchaseListState.purchaseLists;
    Map<String, dynamic>? purchaseListMetaData = _purchaseListProvider!.purchaseListState.purchaseListMetaData;
    purchaseLists![AppConfig.purchaseStatusData[1]["id"]] = null;
    purchaseListMetaData![AppConfig.purchaseStatusData[1]["id"]] = null;

    _purchaseListProvider!.setPurchaseListState(
      _purchaseListProvider!.purchaseListState.update(
        purchaseLists: purchaseLists,
        purchaseListMetaData: purchaseListMetaData,
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _purchaseListProvider!.addListener(_purchaseListProviderListener);

      if (_purchaseListProvider!.purchaseListState.purchaseLists![AppConfig.purchaseStatusData[0]["id"]] != null) return;

      _purchaseListProvider!.setPurchaseListState(_purchaseListProvider!.purchaseListState.update(progressState: 1));
      _purchaseListProvider!.getPurchaseListData(
        storeId: AuthProvider.of(context).authState.storeModel!.id,
        status: AppConfig.purchaseStatusData[0]["id"],
      );
    });
  }

  @override
  void dispose() {
    _purchaseListProvider!.removeListener(_purchaseListProviderListener);

    super.dispose();
  }

  void _purchaseListProviderListener() async {
    if (_purchaseListProvider!.purchaseListState.progressState == -1) {
      if (_purchaseListProvider!.purchaseListState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _purchaseListProvider!.setPurchaseListState(
          _purchaseListProvider!.purchaseListState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_purchaseListProvider!.purchaseListState.progressState == 2) {
      if (_purchaseListProvider!.purchaseListState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _purchaseListProvider!.setPurchaseListState(
          _purchaseListProvider!.purchaseListState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if ((_purchaseListProvider!.purchaseListState.progressState != 1) &&
        (_textController.text.isNotEmpty ||
            _purchaseListProvider!.purchaseListState.purchaseLists![AppConfig.purchaseStatusData[_tabController!.index]["id"]] == null ||
            _purchaseListProvider!.purchaseListState.purchaseLists![AppConfig.purchaseStatusData[_tabController!.index]["id"]]!.isEmpty)) {
      Map<String, List<PurchaseModel>?>? purchaseLists = _purchaseListProvider!.purchaseListState.purchaseLists;
      Map<String, dynamic>? purchaseListMetaData = _purchaseListProvider!.purchaseListState.purchaseListMetaData;

      if (_oldTabIndex != _tabController!.index && _textController.text.isNotEmpty) {
        purchaseLists![AppConfig.purchaseStatusData[_oldTabIndex]["id"]] = [];
        purchaseListMetaData![AppConfig.purchaseStatusData[_oldTabIndex]["id"]] = Map<String, dynamic>();
      }

      _purchaseListProvider!.setPurchaseListState(
        _purchaseListProvider!.purchaseListState.update(
          progressState: 1,
          purchaseLists: purchaseLists,
          purchaseListMetaData: purchaseListMetaData,
        ),
        isNotifiable: false,
      );

      _textController.clear();
      _oldTabIndex = _tabController!.index;

      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _purchaseListProvider!.getPurchaseListData(
          storeId: AuthProvider.of(context).authState.storeModel!.id,
          status: AppConfig.purchaseStatusData[_tabController!.index]["id"],
          searchKey: _textController.text.trim(),
        );
      });
    } else {
      _oldTabIndex = _tabController!.index;
      setState(() {});
    }
  }

  void _onRefresh() async {
    Map<String, List<PurchaseModel>?>? purchaseLists = _purchaseListProvider!.purchaseListState.purchaseLists;
    Map<String, dynamic>? purchaseListMetaData = _purchaseListProvider!.purchaseListState.purchaseListMetaData;

    purchaseLists![AppConfig.purchaseStatusData[_tabController!.index]["id"]] = [];
    purchaseListMetaData![AppConfig.purchaseStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _purchaseListProvider!.setPurchaseListState(
      _purchaseListProvider!.purchaseListState.update(
        progressState: 1,
        purchaseLists: purchaseLists,
        purchaseListMetaData: purchaseListMetaData,
        isRefresh: true,
      ),
    );

    _purchaseListProvider!.getPurchaseListData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.purchaseStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _purchaseListProvider!.setPurchaseListState(
      _purchaseListProvider!.purchaseListState.update(progressState: 1),
    );
    _purchaseListProvider!.getPurchaseListData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.purchaseStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _searchKeyPurchaseOrderListHandler() {
    Map<String, List<PurchaseModel>?>? purchaseLists = _purchaseListProvider!.purchaseListState.purchaseLists;
    Map<String, dynamic>? purchaseListMetaData = _purchaseListProvider!.purchaseListState.purchaseListMetaData;

    purchaseLists![AppConfig.purchaseStatusData[_tabController!.index]["id"]] = [];
    purchaseListMetaData![AppConfig.purchaseStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _purchaseListProvider!.setPurchaseListState(
      _purchaseListProvider!.purchaseListState.update(
        progressState: 1,
        purchaseLists: purchaseLists,
        purchaseListMetaData: purchaseListMetaData,
      ),
    );

    _purchaseListProvider!.getPurchaseListData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.purchaseStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Purchase Orders",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<PurchaseListProvider>(builder: (context, purchaseListProvider, _) {
        if (purchaseListProvider.purchaseListState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return DefaultTabController(
          length: AppConfig.purchaseStatusData.length,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _searchField(),
                _tabBar(),
                Expanded(child: _orderListPanel()),
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
      child: Row(
        children: [
          Expanded(
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
              hintText: PurchaseOrderListPageString.searchHint,
              prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
              suffixIcons: [
                GestureDetector(
                  onTap: () {
                    _textController.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                    _searchKeyPurchaseOrderListHandler();
                  },
                  child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                ),
              ],
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchKeyPurchaseOrderListHandler();
              },
            ),
          ),
          SizedBox(width: widthDp * 5),
          KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 6,
            child: Text(
              "Add New",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: () async {
              var result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => PurchaseOrderPage(),
                ),
              );
              if (result != null && result) {
                _tabController!.animateTo(0);
                _onRefresh();
              }
            },
          ),
        ],
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
        tabs: List.generate(AppConfig.purchaseStatusData.length, (index) {
          return Tab(
            child: Container(
              width: widthDp * 120,
              height: heightDp * 35,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _tabController!.index == index ? config.Colors().mainColor(1) : Colors.white,
                borderRadius: BorderRadius.circular(heightDp * 30),
              ),
              child: Text(
                "${AppConfig.purchaseStatusData[index]["name"]}",
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _orderListPanel() {
    String status = AppConfig.purchaseStatusData[_tabController!.index]["id"];

    List<PurchaseModel> purchaseList = [];
    Map<String, dynamic> purchaseListMetaData = Map<String, dynamic>();

    if (_purchaseListProvider!.purchaseListState.purchaseLists![status] != null) {
      purchaseList = _purchaseListProvider!.purchaseListState.purchaseLists![status]!;
    }
    if (_purchaseListProvider!.purchaseListState.purchaseListMetaData![status] != null) {
      purchaseListMetaData = _purchaseListProvider!.purchaseListState.purchaseListMetaData![status];
    }

    int itemCount = 0;

    if (_purchaseListProvider!.purchaseListState.purchaseLists![status] != null) {
      int length = _purchaseListProvider!.purchaseListState.purchaseLists![status]!.length;
      itemCount += length;
    }

    if (_purchaseListProvider!.purchaseListState.progressState == 1) {
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
              enablePullUp: (purchaseListMetaData["nextPage"] != null && _purchaseListProvider!.purchaseListState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList[_tabController!.index],
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Order Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.separated(
                      controller: _controller,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        PurchaseModel? purchaseModel = (index >= purchaseList.length) ? null : purchaseList[index];

                        return PurchaseOrderWidget(
                          purchaseModel: purchaseModel,
                          loadingStatus: purchaseModel == null,
                          detailHandler: () {
                            _detailHandler(purchaseModel);
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox();
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _detailHandler(PurchaseModel? purchaseModel) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PurchaseDetailPage(purchaseModel: purchaseModel),
      ),
    );
    if (result != null && result) {
      _onRefresh();
    }
  }
}
