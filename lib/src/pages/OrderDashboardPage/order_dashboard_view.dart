import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/order_dashboard_widget.dart';
import 'package:trapp/src/elements/order_new_widget.dart';
import 'package:trapp/src/elements/order_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/pages/OrderDetailPage/index.dart';
import 'package:trapp/src/pages/OrderListPage/order_list_page.dart';
import 'package:trapp/src/providers/index.dart';

class OrderDashboardView extends StatefulWidget {
  OrderDashboardView({Key? key}) : super(key: key);

  @override
  _OrderDashboardViewState createState() => _OrderDashboardViewState();
}

class _OrderDashboardViewState extends State<OrderDashboardView> {
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

    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(
        orderListData: Map<String, dynamic>(),
        orderMetaData: Map<String, dynamic>(),
        progressState: 0,
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _orderProvider!.setOrderState(
        _orderProvider!.orderState.update(
          orderListData: Map<String, dynamic>(),
          orderMetaData: Map<String, dynamic>(),
          progressState: 0,
        ),
      );
      _orderAllData();
    });
  }

  void _orderAllData() {
    _orderProvider!.setOrderState(
      _orderProvider!.orderState.update(
        orderListData: Map<String, dynamic>(),
        orderMetaData: Map<String, dynamic>(),
        progressState: 1,
      ),
    );
    _orderProvider!.getOrderData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.orderStatusData[0]["id"],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Order Dashboard",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            child: Container(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: Row(
                        children: [
                          OrderDashboardWidget(fieldName: "totalPrice", description: "Total Sales", prefix: "₹"),
                          OrderDashboardWidget(fieldName: "totalOrderCount", description: "Total Orders"),
                          OrderDashboardWidget(fieldName: "totalQuantity", description: "Total Units"),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: Row(
                        children: [
                          OrderDashboardWidget(fieldName: "totalRejectedOrderCount", description: "Total Rejected Orders"),
                          OrderDashboardWidget(fieldName: "todayPrice", description: "Today Price", prefix: "₹"),
                          OrderDashboardWidget(fieldName: "todayOrderCount", description: "Today Orders"),
                        ],
                      ),
                    ),
                  ),

                  ////
                  _orderListPanel(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderListPanel() {
    return Consumer<OrderProvider>(builder: (context, orderProvider, _) {
      String status = AppConfig.orderStatusData[0]["id"];

      List<dynamic> orderList = [];
      Map<String, dynamic> orderMetaData = Map<String, dynamic>();

      if (_orderProvider!.orderState.orderListData![status] != null) {
        orderList = _orderProvider!.orderState.orderListData![status];
      }
      if (_orderProvider!.orderState.orderMetaData![status] != null) {
        orderMetaData = _orderProvider!.orderState.orderMetaData![status];
      }

      int itemCount = 0;

      if (_orderProvider!.orderState.orderListData![status] != null && _orderProvider!.orderState.progressState != 1) {
        int length = _orderProvider!.orderState.orderListData![status].length;
        itemCount += length > 2 ? 2 : length;
      } else {
        itemCount = 2;
      }
      return Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(vertical: heightDp * 15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Orders",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  KeicyRaisedButton(
                    width: widthDp * 120,
                    height: heightDp * 35,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 8,
                    child: Text("Show All", style: TextStyle(fontSize: fontSp * 15, color: Colors.white)),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)),
                      );
                      _orderAllData();
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(itemCount, (index) {
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
                    _deliveryReadyCallback(orderData: orderData);
                  },
                  completeCallback: () {
                    _completeCallback(orderData: orderData);
                  },
                  detailCallback: () {
                    _detailCallback(orderData: orderData);
                  },
                  payCallback: () {
                    _payCallback(orderData: orderData);
                  },
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  void _acceptCallback({Map<String, dynamic>? orderData}) async {
    if (orderData!["store"] == null) {
      orderData["store"] = AuthProvider.of(context).authState.storeModel!.toJson();
    }
    bool isAvaiable = true;
    for (var i = 0; i < orderData["products"].length; i++) {
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
          var result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => OrderDetailNewPage(orderModel: OrderModel.fromJson(orderData)),
            ),
          );
          if (result != null) {
            _orderAllData();
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
          await _orderProvider!.updateOrderData(
            orderModel: OrderModel.copy(OrderModel.fromJson(orderData)),
            status: AppConfig.orderStatusData[2]["id"],
          );
          await _keicyProgressDialog!.hide();
          _orderAllData();
        },
      );
    }
  }

  void _rejectCallback({@required Map<String, dynamic>? orderData}) async {
    OrderStatusDialog.show(
      context,
      title: "Order Reject",
      content: "Do you really want to reject the order. User will be notified with the rejection. Do you want to proceed.",
      callback: () async {
        await _keicyProgressDialog!.show();
        await _orderProvider!.updateOrderData(
          orderModel: OrderModel.copy(OrderModel.fromJson(orderData!)),
          status: AppConfig.orderStatusData[8]["id"],
        );
        await _keicyProgressDialog!.hide();
        _orderAllData();
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
        await _orderProvider!.updateOrderData(
          orderModel: OrderModel.copy(OrderModel.fromJson(orderData!)),
          status: AppConfig.orderStatusData[4]["id"],
        );
        await _keicyProgressDialog!.hide();
        _orderAllData();
      },
    );
  }

  void _deliveryReadyCallback({@required Map<String, dynamic>? orderData}) async {
    OrderStatusDialog.show(
      context,
      title: "Delivery is Ready",
      content: "Is the order ready for Delivery",
      okayButtonString: "Yes",
      cancelButtonString: "No",
      callback: () async {
        await _keicyProgressDialog!.show();
        await _orderProvider!.updateOrderData(
          orderModel: OrderModel.copy(OrderModel.fromJson(orderData!)),
          status: AppConfig.orderStatusData[5]["id"],
        );
        await _keicyProgressDialog!.hide();
        _orderAllData();
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
        await _orderProvider!.updateOrderData(
          orderModel: OrderModel.copy(OrderModel.fromJson(orderData!)),
          status: AppConfig.orderStatusData[9]["id"],
        );
        await _keicyProgressDialog!.hide();
        _orderAllData();
      },
    );
  }

  void _detailCallback({@required Map<String, dynamic>? orderData}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => OrderDetailNewPage(orderModel: OrderModel.fromJson(orderData!)),
      ),
    );
    _orderAllData();
  }

  void _payCallback({@required Map<String, dynamic>? orderData}) async {
    OrderStatusDialog.show(
      context,
      title: "Order Paid",
      content: "Are you sure the order has been paid",
      callback: () async {
        await _keicyProgressDialog!.show();
        await _orderProvider!.updateOrderData(
          orderModel: OrderModel.copy(OrderModel.fromJson(orderData!)),
          status: AppConfig.orderStatusData[3]["id"],
        );
        await _keicyProgressDialog!.hide();
        _orderAllData();
      },
    );
  }
}
