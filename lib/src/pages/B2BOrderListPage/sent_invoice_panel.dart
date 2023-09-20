import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/b2b_order_widget.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/B2BInvoicePage/b2b_invoice_page.dart';
import 'package:trapp/src/pages/B2BOrderDetailPage/index.dart';
import 'package:trapp/src/pages/BusinessStoresPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class SentInvoicePanel extends StatefulWidget {
  SentInvoicePanel({Key? key}) : super(key: key);

  @override
  _SentInvoicePanelState createState() => _SentInvoicePanelState();
}

class _SentInvoicePanelState extends State<SentInvoicePanel> with SingleTickerProviderStateMixin {
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

  B2BOrderProvider? _b2bOrderProvider;
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

    _b2bOrderProvider = B2BOrderProvider.of(context);
    _controller = ScrollController();

    _refreshControllerList = [];
    for (var i = 0; i < AppConfig.b2bOrderStatusData.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 0;

    _tabController = TabController(length: AppConfig.b2bOrderStatusData.length, vsync: this);

    _tabController!.addListener(_tabControllerListener);

    // _b2bOrderProvider!.setB2BOrderState(
    //   _b2bOrderProvider!.b2bOrderState.update(
    //     sentOrderListData: Map<String, dynamic>(),
    //     sentOrderMetaData: Map<String, dynamic>(),
    //     sentProgressState: 0,
    //   ),
    //   isNotifiable: false,
    // );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _b2bOrderProvider!.addListener(_b2bOrderProviderListener);

      if (_b2bOrderProvider!.b2bOrderState.sentProgressState != 2 ||
          _b2bOrderProvider!.b2bOrderState.sentOrderListData![AppConfig.b2bOrderStatusData[_tabController!.index]["id"]] == null ||
          _b2bOrderProvider!.b2bOrderState.sentOrderListData![AppConfig.b2bOrderStatusData[_tabController!.index]["id"]].isEmpty) {
        _b2bOrderProvider!.setB2BOrderState(_b2bOrderProvider!.b2bOrderState.update(sentProgressState: 1));
        _b2bOrderProvider!.getSentOrderData(
          myStoreId: AuthProvider.of(context).authState.storeModel!.id,
          status: AppConfig.b2bOrderStatusData[0]["id"],
        );
      }
    });
  }

  @override
  void dispose() {
    _b2bOrderProvider!.removeListener(_b2bOrderProviderListener);

    super.dispose();
  }

  void _b2bOrderProviderListener() async {
    if (_b2bOrderProvider!.b2bOrderState.sentProgressState == -1) {
      if (_b2bOrderProvider!.b2bOrderState.sentIsRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _b2bOrderProvider!.setB2BOrderState(
          _b2bOrderProvider!.b2bOrderState.update(sentIsRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_b2bOrderProvider!.b2bOrderState.sentProgressState == 2) {
      if (_b2bOrderProvider!.b2bOrderState.sentIsRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _b2bOrderProvider!.setB2BOrderState(
          _b2bOrderProvider!.b2bOrderState.update(sentIsRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if ((_b2bOrderProvider!.b2bOrderState.sentProgressState != 1) &&
        (_textController.text.isNotEmpty ||
            _b2bOrderProvider!.b2bOrderState.sentOrderListData![AppConfig.b2bOrderStatusData[_tabController!.index]["id"]] == null ||
            _b2bOrderProvider!.b2bOrderState.sentOrderListData![AppConfig.b2bOrderStatusData[_tabController!.index]["id"]].isEmpty)) {
      Map<String, dynamic>? sentOrderListData = _b2bOrderProvider!.b2bOrderState.sentOrderListData;
      Map<String, dynamic>? sentOrderMetaData = _b2bOrderProvider!.b2bOrderState.sentOrderMetaData;

      if (_oldTabIndex != _tabController!.index && _textController.text.isNotEmpty) {
        sentOrderListData![AppConfig.b2bOrderStatusData[_oldTabIndex]["id"]] = [];
        sentOrderMetaData![AppConfig.b2bOrderStatusData[_oldTabIndex]["id"]] = Map<String, dynamic>();
      }

      _b2bOrderProvider!.setB2BOrderState(
        _b2bOrderProvider!.b2bOrderState.update(
          sentProgressState: 1,
          sentOrderListData: sentOrderListData,
          sentOrderMetaData: sentOrderMetaData,
        ),
        isNotifiable: false,
      );

      _textController.clear();
      _oldTabIndex = _tabController!.index;

      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _b2bOrderProvider!.getSentOrderData(
          myStoreId: AuthProvider.of(context).authState.storeModel!.id,
          status: AppConfig.b2bOrderStatusData[_tabController!.index]["id"],
          searchKey: _textController.text.trim(),
        );
      });
    } else {
      _oldTabIndex = _tabController!.index;
      setState(() {});
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? sentOrderListData = _b2bOrderProvider!.b2bOrderState.sentOrderListData;
    Map<String, dynamic>? sentOrderMetaData = _b2bOrderProvider!.b2bOrderState.sentOrderMetaData;

    sentOrderListData![AppConfig.b2bOrderStatusData[_tabController!.index]["id"]] = [];
    sentOrderMetaData![AppConfig.b2bOrderStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _b2bOrderProvider!.setB2BOrderState(
      _b2bOrderProvider!.b2bOrderState.update(
        sentProgressState: 1,
        sentOrderListData: sentOrderListData,
        sentOrderMetaData: sentOrderMetaData,
        sentIsRefresh: true,
      ),
    );

    _b2bOrderProvider!.getSentOrderData(
      myStoreId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.b2bOrderStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _b2bOrderProvider!.setB2BOrderState(
      _b2bOrderProvider!.b2bOrderState.update(sentProgressState: 1),
    );
    _b2bOrderProvider!.getSentOrderData(
      myStoreId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.b2bOrderStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  void _searchKeyB2BOrderListHandler() {
    Map<String, dynamic>? sentOrderListData = _b2bOrderProvider!.b2bOrderState.sentOrderListData;
    Map<String, dynamic>? sentOrderMetaData = _b2bOrderProvider!.b2bOrderState.sentOrderMetaData;

    sentOrderListData![AppConfig.b2bOrderStatusData[_tabController!.index]["id"]] = [];
    sentOrderMetaData![AppConfig.b2bOrderStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _b2bOrderProvider!.setB2BOrderState(
      _b2bOrderProvider!.b2bOrderState.update(
        sentProgressState: 1,
        sentOrderListData: sentOrderListData,
        sentOrderMetaData: sentOrderMetaData,
      ),
    );

    _b2bOrderProvider!.getSentOrderData(
      myStoreId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.b2bOrderStatusData[_tabController!.index]["id"],
      searchKey: _textController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<B2BOrderProvider>(builder: (context, b2bOrderProvider, _) {
        if (b2bOrderProvider.b2bOrderState.sentProgressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return DefaultTabController(
          length: AppConfig.b2bOrderStatusData.length,
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
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
      child: Row(
        children: [
          Expanded(
            child: KeicyTextFormField(
              controller: _textController,
              focusNode: _focusNode,
              width: null,
              height: heightDp * 35,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: heightDp * 6,
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
              hintText: B2BOrderListPageString.searchHint,
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
                _searchKeyB2BOrderListHandler();
              },
            ),
          ),
          SizedBox(width: widthDp * 5),
          KeicyRaisedButton(
            width: widthDp * 110,
            height: heightDp * 35,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 6,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "+ New Order",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: () async {
              var result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BusinessStoresPage(
                    status: ConnectionStatus.active,
                    forSelection: true,
                  ),
                ),
              );

              if (result == null) {
                return;
              }

              B2BOrderModel _b2bOrderModel = B2BOrderModel();
              _b2bOrderModel.category = B2BOrderCategory.invoice;
              _b2bOrderModel.myStoreModel = AuthProvider.of(context).authState.storeModel;
              _b2bOrderModel.businessStoreModel = StoreModel.fromJson(result);
              _b2bOrderModel.deliveryAddress = AddressModel(
                address: _b2bOrderModel.businessStoreModel!.address,
                city: _b2bOrderModel.businessStoreModel!.city,
                state: _b2bOrderModel.businessStoreModel!.state,
                zipCode: _b2bOrderModel.businessStoreModel!.zipCode,
                location: _b2bOrderModel.businessStoreModel!.location,
              );
              _b2bOrderModel.invoiceDate = DateTime.now();

              var result1 = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => B2BInvoicePage(
                    b2bOrderModel: _b2bOrderModel,
                    isEditItems: true,
                    isChangeBusiness: true,
                  ),
                ),
              );
              if (result1 != null) {
                _tabController!.animateTo(1);
                _onRefresh();
                if (_controller!.offset != 0) _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
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
        tabs: List.generate(AppConfig.b2bOrderStatusData.length, (index) {
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
                "${AppConfig.b2bOrderStatusData[index]["name"]}",
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _orderListPanel() {
    String status = AppConfig.b2bOrderStatusData[_tabController!.index]["id"];

    List<dynamic> orderList = [];
    Map<String, dynamic> sentOrderMetaData = Map<String, dynamic>();

    if (_b2bOrderProvider!.b2bOrderState.sentOrderListData![status] != null) {
      orderList = _b2bOrderProvider!.b2bOrderState.sentOrderListData![status];
    }
    if (_b2bOrderProvider!.b2bOrderState.sentOrderMetaData![status] != null) {
      sentOrderMetaData = _b2bOrderProvider!.b2bOrderState.sentOrderMetaData![status];
    }

    int itemCount = 0;

    if (_b2bOrderProvider!.b2bOrderState.sentOrderListData![status] != null) {
      int length = _b2bOrderProvider!.b2bOrderState.sentOrderListData![status].length;
      itemCount += length;
    }

    if (_b2bOrderProvider!.b2bOrderState.sentProgressState == 1) {
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
              enablePullUp: (sentOrderMetaData["nextPage"] != null && _b2bOrderProvider!.b2bOrderState.sentProgressState != 1),
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

                        return B2BOrderWidget(
                          b2bOrderModel: orderData.isEmpty ? null : B2BOrderModel.fromJson(orderData),
                          loadingStatus: orderData.isEmpty,
                          rejectCallback: () {
                            _rejectCallback(b2bOrderModel: B2BOrderModel.fromJson(orderData));
                          },
                          pickupReadyCallback: () {
                            _pickupReadyCallback(b2bOrderModel: B2BOrderModel.fromJson(orderData));
                          },
                          deliveryReadyCallback: () {
                            _deliveryReadyCallback(b2bOrderModel: B2BOrderModel.fromJson(orderData));
                          },
                          deliveryStartCallback: () {
                            _deliveryStartCallback(b2bOrderModel: B2BOrderModel.fromJson(orderData));
                          },
                          completeCallback: () {
                            _completeCallback(b2bOrderModel: B2BOrderModel.fromJson(orderData));
                          },
                          payCallback: () {
                            _payCallback(b2bOrderModel: B2BOrderModel.fromJson(orderData));
                          },
                          detailCallback: () {
                            _detailCallback(b2bOrderModel: B2BOrderModel.fromJson(orderData));
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

  void _detailCallback({@required B2BOrderModel? b2bOrderModel}) async {
    _b2bOrderProvider!.removeListener(_b2bOrderProviderListener);
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => B2BOrderDetailPage(b2bOrderModel: b2bOrderModel),
      ),
    );
    _b2bOrderProvider!.addListener(_b2bOrderProviderListener);

    if (result != null) {
      for (var i = 0; i < AppConfig.b2bOrderStatusData.length; i++) {
        if (result == AppConfig.b2bOrderStatusData[i]["id"]) {
          _tabController!.animateTo(i);
          _onRefresh();
          if (_controller!.offset != 0) _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
          break;
        }
      }
    }
  }

  void _rejectCallback({@required B2BOrderModel? b2bOrderModel}) async {
    OrderRejectDialog.show(
      context,
      title: "Order Reject",
      content: "Do you really want reject cancel the order. User will be notified with the rejection. Do you want to proceed.",
      callback: (reason) async {
        await _keicyProgressDialog!.show();

        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(b2bOrderModel!);
        newb2bOrderModel.reasonForCancelOrReject = reason;

        var result = await _b2bOrderProvider!.updateOrderData(
          b2bOrderModel: newb2bOrderModel,
          status: AppConfig.b2bOrderStatusData[9]["id"],
          changedStatus: false,
          from: "received",
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _tabController!.animateTo(9);
          _onRefresh();
          if (_controller!.offset != 0) _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }

  void _pickupReadyCallback({@required B2BOrderModel? b2bOrderModel}) async {
    OrderStatusDialog.show(
      context,
      title: "Pickup is Ready",
      content: "Is the order ready for Pickup",
      okayButtonString: "Yes",
      cancelButtonString: "No",
      callback: () async {
        await _keicyProgressDialog!.show();

        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(b2bOrderModel!);

        var result = await _b2bOrderProvider!.updateOrderData(
          b2bOrderModel: newb2bOrderModel,
          status: AppConfig.b2bOrderStatusData[3]["id"],
          changedStatus: false,
          from: "sent",
        );
        await _keicyProgressDialog!.hide();

        if (result["success"]) {
          _tabController!.animateTo(3);
          _onRefresh();
          if (_controller!.offset != 0) _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }

  void _deliveryReadyCallback({@required B2BOrderModel? b2bOrderModel}) async {
    OrderStatusDialog.show(
      context,
      title: "Delivery is Ready",
      content: "Is the order ready for Delivery",
      okayButtonString: "Yes",
      cancelButtonString: "No",
      callback: () async {
        await _keicyProgressDialog!.show();

        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(b2bOrderModel!);

        var result = await _b2bOrderProvider!.updateOrderData(
          b2bOrderModel: newb2bOrderModel,
          status: AppConfig.b2bOrderStatusData[4]["id"],
          changedStatus: false,
          from: "sent",
        );
        await _keicyProgressDialog!.hide();

        if (result["success"]) {
          _tabController!.animateTo(4);
          _onRefresh();
          if (_controller!.offset != 0) _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }

  void _deliveryStartCallback({@required B2BOrderModel? b2bOrderModel}) async {
    B2BOrderDeliveryStartDialog.show(
      context,
      callback: (String str) async {
        await _keicyProgressDialog!.show();

        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(b2bOrderModel!);
        newb2bOrderModel.deliveryDetails = str;

        var result = await _b2bOrderProvider!.updateOrderData(
          b2bOrderModel: newb2bOrderModel,
          status: AppConfig.b2bOrderStatusData[5]["id"],
          changedStatus: false,
          from: "sent",
        );
        await _keicyProgressDialog!.hide();

        if (result["success"]) {
          _tabController!.animateTo(5);
          _onRefresh();
          if (_controller!.offset != 0) _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }

  void _payCallback({@required B2BOrderModel? b2bOrderModel}) async {
    B2BOrderPaidDialog.show(
      context,
      title: "Order Paid",
      content: "Do you want to mark this order as payment received?",
      callback: (File? file) async {
        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(b2bOrderModel!);

        await _keicyProgressDialog!.show();
        var result = await UploadFileApiProvider.uploadFile(
          file: file,
          bucketName: "INVOICES_BUCKET",
          directoryName: "b2b_payment_proof/",
          fileName: b2bOrderModel.orderId! + "_" + DateTime.now().millisecondsSinceEpoch.toString(),
        );

        if (result["success"]) {
          newb2bOrderModel.paymentProofImage = result["data"];
        }

        result = await _b2bOrderProvider!.updateOrderData(
          b2bOrderModel: newb2bOrderModel,
          status: AppConfig.b2bOrderStatusData[2]["id"],
          changedStatus: false,
          from: "sent",
        );
        await _keicyProgressDialog!.hide();

        if (result["success"]) {
          _tabController!.animateTo(2);
          _onRefresh();
          if (_controller!.offset != 0) _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      },
    );
  }

  void _completeCallback({@required B2BOrderModel? b2bOrderModel}) async {
    B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(b2bOrderModel!);

    await _keicyProgressDialog!.show();

    var result = await _b2bOrderProvider!.updateOrderData(
      b2bOrderModel: newb2bOrderModel,
      status: AppConfig.b2bOrderStatusData[7]["id"],
      changedStatus: false,
      from: "sent",
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _tabController!.animateTo(7);
      _onRefresh();
      if (_controller!.offset != 0) _controller!.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
  }
}
