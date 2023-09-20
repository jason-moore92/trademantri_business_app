import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/order_new_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class OrderListView extends StatefulWidget {
  final bool haveAppBar;

  OrderListView({Key? key, this.haveAppBar = false}) : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> with SingleTickerProviderStateMixin {
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

  OrderProvider? _orderProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;
  ScrollController? _controller;

  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 1;

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

    _orderProvider = OrderProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _controller = ScrollController();

    _refreshControllerList = [];
    for (var i = 0; i < AppConfig.orderStatusData.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 1;

    _tabController = TabController(length: AppConfig.orderStatusData.length, vsync: this, initialIndex: _oldTabIndex);

    _tabController!.addListener(_tabControllerListener);

    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(
        orderListData: Map<String, dynamic>(),
        orderMetaData: Map<String, dynamic>(),
        progressState: 0,
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _orderProvider!.addListener(_orderProviderListener);

      _orderProvider!.setOrderState(_orderProvider!.orderState.update(progressState: 1));
      _orderProvider!.getOrderData(
        storeId: AuthProvider.of(context).authState.storeModel!.id,
        status: AppConfig.orderStatusData[1]["id"],
      );
    });
  }

  @override
  void dispose() {
    _orderProvider!.removeListener(_orderProviderListener);

    super.dispose();
  }

  void _orderProviderListener() async {
    if (_orderProvider!.orderState.progressState == -1) {
      if (_orderProvider!.orderState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _orderProvider!.setOrderState(
          _orderProvider!.orderState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_orderProvider!.orderState.progressState == 2) {
      if (_orderProvider!.orderState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _orderProvider!.setOrderState(
          _orderProvider!.orderState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if ((_orderProvider!.orderState.progressState != 1) &&
        (_textController.text.isNotEmpty ||
            _orderProvider!.orderState.orderListData![AppConfig.orderStatusData[_tabController!.index]["id"]] == null ||
            _orderProvider!.orderState.orderListData![AppConfig.orderStatusData[_tabController!.index]["id"]].isEmpty)) {
      Map<String, dynamic>? orderListData = _orderProvider!.orderState.orderListData;
      Map<String, dynamic>? orderMetaData = _orderProvider!.orderState.orderMetaData;

      if (_oldTabIndex != _tabController!.index && _textController.text.isNotEmpty) {
        orderListData![AppConfig.orderStatusData[_oldTabIndex]["id"]] = [];
        orderMetaData![AppConfig.orderStatusData[_oldTabIndex]["id"]] = Map<String, dynamic>();
      }

      _orderProvider!.setOrderState(
        _orderProvider!.orderState.update(
          progressState: 1,
          orderListData: orderListData,
          orderMetaData: orderMetaData,
        ),
        isNotifiable: false,
      );

      // _textController.clear();
      _oldTabIndex = _tabController!.index;

      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _orderProvider!.getOrderData(
          storeId: AuthProvider.of(context).authState.storeModel!.id,
          status: AppConfig.orderStatusData[_tabController!.index]["id"],
          searchKey: _textController.text.trim(),
        );
      });
    } else {
      _oldTabIndex = _tabController!.index;
      setState(() {});
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? orderListData = _orderProvider!.orderState.orderListData;
    Map<String, dynamic>? orderMetaData = _orderProvider!.orderState.orderMetaData;

    orderListData![AppConfig.orderStatusData[_tabController!.index]["id"]] = [];
    orderMetaData![AppConfig.orderStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(
        progressState: 1,
        orderListData: orderListData,
        orderMetaData: orderMetaData,
        isRefresh: true,
      ),
    );

    _orderProvider!.getOrderData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.orderStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(progressState: 1),
    );
    _orderProvider!.getOrderData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.orderStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _searchKeyOrderListHandler() {
    Map<String, dynamic>? orderListData = _orderProvider!.orderState.orderListData;
    Map<String, dynamic>? orderMetaData = _orderProvider!.orderState.orderMetaData;

    orderListData![AppConfig.orderStatusData[_tabController!.index]["id"]] = [];
    orderMetaData![AppConfig.orderStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(
        progressState: 1,
        orderListData: orderListData,
        orderMetaData: orderMetaData,
      ),
    );

    _orderProvider!.getOrderData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.orderStatusData[_tabController!.index]["id"],
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
                "Orders",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: Consumer<OrderProvider>(builder: (context, orderProvider, _) {
        if (orderProvider.orderState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return DefaultTabController(
          length: AppConfig.orderStatusData.length,
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
        hintText: OrderListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _textController.clear();
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyOrderListHandler();
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
        tabs: List.generate(AppConfig.orderStatusData.length, (index) {
          if (index == 0) return SizedBox();
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
                "${AppConfig.orderStatusData[index]["name"]}",
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _orderListPanel() {
    String status = AppConfig.orderStatusData[_tabController!.index]["id"];

    List<dynamic> orderList = [];
    Map<String, dynamic> orderMetaData = Map<String, dynamic>();

    if (_orderProvider!.orderState.orderListData![status] != null) {
      orderList = _orderProvider!.orderState.orderListData![status];
    }
    if (_orderProvider!.orderState.orderMetaData![status] != null) {
      orderMetaData = _orderProvider!.orderState.orderMetaData![status];
    }

    int itemCount = 0;

    if (_orderProvider!.orderState.orderListData![status] != null) {
      int length = _orderProvider!.orderState.orderListData![status].length;
      itemCount += length;
    }

    if (_orderProvider!.orderState.progressState == 1) {
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
              enablePullUp: (orderMetaData["nextPage"] != null && _orderProvider!.orderState.progressState != 1),
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
                        Map<String, dynamic> orderData = (index >= orderList.length) ? Map<String, dynamic>() : orderList[index];
                        if (orderData.isNotEmpty && orderData["store"] == null) {
                          orderData["store"] = AuthProvider.of(context).authState.storeModel!.toJson();
                        }

                        return OrderWidget(
                          orderModel: orderData.isEmpty ? null : OrderModel.fromJson(orderData),
                          loadingStatus: orderData.isEmpty,
                          acceptCallback: () async {
                            _acceptCallback(orderData: orderData);
                          },
                          rejectCallback: () {
                            _rejectCallback(orderData: orderData);
                          },
                          pickupReadyCallback: () {
                            _pickupReadyCallback(orderData: orderData);
                          },
                          deliveryReadyCallback: () {
                            OrderStatusDialog.show(
                              context,
                              title: "Delivery is Ready",
                              content: "Is the order ready for Delivery",
                              okayButtonString: "Yes",
                              cancelButtonString: "No",
                              callback: () async {
                                if (orderData["deliveryPartnerDetails"] == null || orderData["deliveryPartnerDetails"].isEmpty) {
                                  NormalDialog.show(context,
                                      title: "Delivery Ready",
                                      content:
                                          "This order need to be delivered on your own, as your store and order is not associated with any delivery partners",
                                      callback: () {
                                    _deliveryReadyCallback(orderData: orderData);
                                  });
                                } else {
                                  _deliveryReadyCallback(orderData: orderData);
                                }
                              },
                            );
                          },
                          completeCallback: () {
                            _completeCallback(orderData: orderData);
                          },
                          payCallback: () {
                            _payCallback(orderData: orderData);
                          },
                          detailCallback: () {
                            _detailCallback(orderData: orderData);
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

  void _acceptCallback({Map<String, dynamic>? orderData}) async {
    bool isAvaiable = true;
    for (var i = 0; i < orderData!["products"].length; i++) {
      if (orderData["products"][i]["price"] == null || orderData["products"][i]["price"] == 0) {
        isAvaiable = false;
      }
    }

    for (var i = 0; i < orderData["services"].length; i++) {
      if (orderData["services"][i]["price"] == null || orderData["services"][i]["price"] == 0) {
        isAvaiable = false;
      }
    }

    if (!isAvaiable && orderData["category"] == AppConfig.orderCategories["assistant"]) {
      NormalAskDialog.show(
        context,
        content: "This order needs updates on the prices, please update prices of the items and total",
        callback: () async {
          _orderProvider!.removeListener(_orderProviderListener);
          var result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => OrderDetailNewPage(orderModel: OrderModel.fromJson(orderData)),
            ),
          );
          _orderProvider!.addListener(_orderProviderListener);
          if (result != null) {
            for (var i = 0; i < AppConfig.orderStatusData.length; i++) {
              if (result == AppConfig.orderStatusData[i]["id"]) {
                _tabController!.animateTo(i);
                _onRefresh();
                _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                break;
              }
            }
          }
        },
      );
    } else {
      OrderStatusDialog.show(
        context,
        title: "Order Accept",
        content: "Do you want to accept the order. User will be notified with it.",
        callback: () async {
          await _keicyProgressDialog!.show();
          var result = await _orderProvider!.updateOrderData(
            orderModel: OrderModel.fromJson(orderData),
            status: AppConfig.orderStatusData[2]["id"],
          );
          await _keicyProgressDialog!.hide();
          if (result["success"]) {
            if (result["data"] != null && result["data"]["status"] == AppConfig.orderStatusData[3]["id"]) {
              _tabController!.animateTo(3);
            } else {
              _tabController!.animateTo(2);
            }
            _onRefresh();
            _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
          }
        },
      );
    }
  }

  void _rejectCallback({@required Map<String, dynamic>? orderData}) async {
    OrderRejectDialog.show(
      context,
      title: "Order Reject",
      content: "Do you really want to reject the order. User will be notified with the rejection. Do you want to proceed.",
      callback: (reason) async {
        Map<String, dynamic> newOrderData = json.decode(json.encode(orderData));
        newOrderData["reasonForCancelOrReject"] = reason;
        await _keicyProgressDialog!.show();
        var result = await _orderProvider!.updateOrderData(
          orderModel: OrderModel.fromJson(orderData!),
          status: AppConfig.orderStatusData[8]["id"],
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _tabController!.animateTo(8);
          _onRefresh();
          _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }

  void _pickupReadyCallback({@required Map<String, dynamic>? orderData}) async {
    OrderStatusDialog.show(
      context,
      title: "Pickup is Ready",
      content: "Is the order ready for Pickup",
      okayButtonString: "Yes",
      cancelButtonString: "No",
      callback: () async {
        await _keicyProgressDialog!.show();
        var result = await _orderProvider!.updateOrderData(
          orderModel: OrderModel.fromJson(orderData!),
          status: AppConfig.orderStatusData[4]["id"],
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _tabController!.animateTo(4);
          _onRefresh();
          _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }

  void _deliveryReadyCallback({@required Map<String, dynamic>? orderData}) async {
    await _keicyProgressDialog!.show();
    var result = await _orderProvider!.updateOrderData(
      orderModel: OrderModel.fromJson(orderData!),
      status: AppConfig.orderStatusData[5]["id"],
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _tabController!.animateTo(5);
      _onRefresh();
      _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void _payCallback({@required Map<String, dynamic>? orderData}) async {
    OrderStatusDialog.show(
      context,
      title: "Order Paid",
      content: "Are you sure the order has been paid",
      callback: () async {
        await _keicyProgressDialog!.show();
        var result = await _orderProvider!.updateOrderData(
          orderModel: OrderModel.fromJson(orderData!),
          status: AppConfig.orderStatusData[3]["id"],
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _tabController!.animateTo(3);
          _onRefresh();
          _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }

  void _completeCallback({@required Map<String, dynamic>? orderData}) async {
    OrderStatusDialog.show(
      context,
      title: "Order Complete",
      content: "Are you sure you want to complete this order",
      callback: () async {
        await _keicyProgressDialog!.show();
        var result = await _orderProvider!.updateOrderData(
          orderModel: OrderModel.fromJson(orderData!),
          status: AppConfig.orderStatusData[9]["id"],
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _tabController!.animateTo(9);
          _onRefresh();
          _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }

  void _detailCallback({@required Map<String, dynamic>? orderData}) async {
    _orderProvider!.removeListener(_orderProviderListener);
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => OrderDetailNewPage(orderModel: OrderModel.fromJson(orderData!)),
      ),
    );
    _orderProvider!.addListener(_orderProviderListener);
    if (result != null) {
      for (var i = 0; i < AppConfig.orderStatusData.length; i++) {
        if (result == AppConfig.orderStatusData[i]["id"]) {
          _tabController!.animateTo(i);
          _onRefresh();
          _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
          break;
        }
      }
    }
  }
}
