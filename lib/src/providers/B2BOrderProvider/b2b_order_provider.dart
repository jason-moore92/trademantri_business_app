import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/helpers/price_functions.dart';
import 'package:random_string/random_string.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class B2BOrderProvider extends ChangeNotifier {
  static B2BOrderProvider of(BuildContext context, {bool listen = false}) => Provider.of<B2BOrderProvider>(context, listen: listen);

  B2BOrderState _b2bOrderState = B2BOrderState.init();
  B2BOrderState get b2bOrderState => _b2bOrderState;

  void setB2BOrderState(B2BOrderState b2bOrderState, {bool isNotifiable = true}) {
    if (_b2bOrderState != b2bOrderState) {
      _b2bOrderState = b2bOrderState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> addOrder({
    @required B2BOrderModel? b2bOrderModel,
    @required String? status,
  }) async {
    b2bOrderModel = B2BOrderModel.copy(b2bOrderModel!);
    try {
      b2bOrderModel.status = status;
      b2bOrderModel.orderId = "TM-" + randomAlphaNumeric(12);

      if (b2bOrderModel.products!.isEmpty && b2bOrderModel.services!.isNotEmpty) {
        b2bOrderModel.orderType = "Service";
      }

      /// order steps
      if (b2bOrderModel.orderType == OrderType.delivery) {
        b2bOrderModel.orderHistorySteps = ["Order Accepted"];
        b2bOrderModel.orderHistoryStatus = [AppConfig.b2bOrderStatusData[1]["id"]];

        b2bOrderModel.orderFutureSteps = [
          "Order Paid",
          "Delivery Ready",
          "Delivery Start",
          "Delivered",
          "Completed",
        ];

        b2bOrderModel.orderFutureStatus = [
          AppConfig.b2bOrderStatusData[2]["id"],
          AppConfig.b2bOrderStatusData[4]["id"],
          AppConfig.b2bOrderStatusData[5]["id"],
          AppConfig.b2bOrderStatusData[6]["id"],
          AppConfig.b2bOrderStatusData[7]["id"],
        ];
      } else if (b2bOrderModel.orderType == OrderType.pickup) {
        b2bOrderModel.orderHistorySteps = ["Order Accepted"];
        b2bOrderModel.orderHistoryStatus = [AppConfig.b2bOrderStatusData[1]["id"]];

        b2bOrderModel.orderFutureSteps = [
          "Order Paid",
          "Pickup Ready",
          "Completed",
        ];

        b2bOrderModel.orderFutureStatus = [
          AppConfig.b2bOrderStatusData[2]["id"],
          AppConfig.b2bOrderStatusData[3]["id"],
          AppConfig.b2bOrderStatusData[7]["id"],
        ];
      }

      var result = await B2BOrderApiProvider.addOrder(
        orderData: b2bOrderModel.toJson(),
        qrCode: Encrypt.encryptString(
          "B2BOrder_${b2bOrderModel.orderId}_MyStoreId-${b2bOrderModel.myStoreModel!.id}_BusinessStoreId-${b2bOrderModel.businessStoreModel!.id}",
        ),
      );

      if (result["success"]) {
        _b2bOrderState = _b2bOrderState.update(
          sentProgressState: 2,
          newB2bOrderModel: b2bOrderModel,
        );
      } else {
        _b2bOrderState = _b2bOrderState.update(
          sentProgressState: -1,
          sentMessage: result["message"],
        );
      }
    } catch (e) {
      _b2bOrderState = _b2bOrderState.update(
        sentProgressState: -1,
        sentMessage: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<void> getSentOrderData({
    @required String? myStoreId,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? orderListData = _b2bOrderState.sentOrderListData;
    Map<String, dynamic>? orderMetaData = _b2bOrderState.sentOrderMetaData;
    try {
      if (orderListData![status] == null) orderListData[status!] = [];
      if (orderMetaData![status] == null) orderMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await B2BOrderApiProvider.getOrderData(
        myStoreId: myStoreId,
        businessStoreId: null,
        status: status,
        searchKey: searchKey,
        page: orderMetaData[status].isEmpty ? 1 : (orderMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          orderListData[status].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        orderMetaData[status!] = result["data"];

        _b2bOrderState = _b2bOrderState.update(
          sentProgressState: 2,
          sentOrderListData: orderListData,
          sentOrderMetaData: orderMetaData,
        );
      } else {
        _b2bOrderState = _b2bOrderState.update(
          sentProgressState: 2,
        );
      }
    } catch (e) {
      _b2bOrderState = _b2bOrderState.update(
        sentProgressState: 2,
      );
    }
    notifyListeners();
  }

  Future<void> getReceivedOrderData({
    @required String? businessStoreId,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? orderListData = _b2bOrderState.receivedOrderListData;
    Map<String, dynamic>? orderMetaData = _b2bOrderState.receivedOrderMetaData;
    try {
      if (orderListData![status] == null) orderListData[status!] = [];
      if (orderMetaData![status] == null) orderMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await B2BOrderApiProvider.getOrderData(
        myStoreId: null,
        businessStoreId: businessStoreId,
        status: status,
        searchKey: searchKey,
        page: orderMetaData[status].isEmpty ? 1 : (orderMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          orderListData[status].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        orderMetaData[status!] = result["data"];

        _b2bOrderState = _b2bOrderState.update(
          receivedProgressState: 2,
          receivedOrderListData: orderListData,
          receivedOrderMetaData: orderMetaData,
        );
      } else {
        _b2bOrderState = _b2bOrderState.update(
          receivedProgressState: 2,
        );
      }
    } catch (e) {
      _b2bOrderState = _b2bOrderState.update(
        receivedProgressState: 2,
      );
    }
    notifyListeners();
  }

  // Future<dynamic> changeOrderStatus1({
  //   @required String? storeId,
  //   @required String? orderId,
  //   @required String? userId,
  //   @required String? status,
  //   @required String? token,
  // }) async {
  //   var result = await B2BOrderApiProvider.changeOrderStatus(
  //     orderId: orderId,
  //     userId: userId,
  //     status: status,
  //     storeId: storeId,
  //     token: token,
  //   );

  //   if (result["success"]) {
  //     _b2bOrderState = _b2bOrderState.update(
  //       progressState: 1,
  //       orderListData: Map<String, dynamic>(),
  //       orderMetaData: Map<String, dynamic>(),
  //     );
  //     // getOrderData(
  //     //   storeId: storeId,
  //     //   status: status,
  //     // );
  //   }
  //   return result;
  // }

  Future<dynamic> updateOrderData({
    @required B2BOrderModel? b2bOrderModel,
    @required String? status,
    @required String? from,
    bool changedStatus = true,
  }) async {
    /// order_paid
    if (status == AppConfig.b2bOrderStatusData[2]["id"]) {
      if (!b2bOrderModel!.orderHistoryStatus!.contains(AppConfig.b2bOrderStatusData[2]["id"])) {
        b2bOrderModel.orderHistoryStatus!.add(AppConfig.b2bOrderStatusData[2]["id"]);
        b2bOrderModel.orderFutureStatus!.remove(AppConfig.b2bOrderStatusData[2]["id"]);
      }

      if (!b2bOrderModel.orderHistorySteps!.contains("Order Paid")) {
        b2bOrderModel.orderHistorySteps!.add("Order Paid");
        b2bOrderModel.orderFutureSteps!.remove("Order Paid");
      }
    }

    /// pickup_ready
    if (status == AppConfig.b2bOrderStatusData[3]["id"]) {
      if (!b2bOrderModel!.orderHistoryStatus!.contains(AppConfig.b2bOrderStatusData[3]["id"])) {
        b2bOrderModel.orderHistoryStatus!.add(AppConfig.b2bOrderStatusData[3]["id"]);
        b2bOrderModel.orderFutureStatus!.remove(AppConfig.b2bOrderStatusData[3]["id"]);
      }

      if (!b2bOrderModel.orderHistorySteps!.contains("Pickup Ready")) {
        b2bOrderModel.orderHistorySteps!.add("Pickup Ready");
        b2bOrderModel.orderFutureSteps!.remove("Pickup Ready");
      }
    }

    /// delivery_ready
    if (status == AppConfig.b2bOrderStatusData[4]["id"]) {
      if (!b2bOrderModel!.orderHistoryStatus!.contains(AppConfig.b2bOrderStatusData[4]["id"])) {
        b2bOrderModel.orderHistoryStatus!.add(AppConfig.b2bOrderStatusData[4]["id"]);
        b2bOrderModel.orderFutureStatus!.remove(AppConfig.b2bOrderStatusData[4]["id"]);
      }

      if (!b2bOrderModel.orderHistorySteps!.contains("Delivery Ready")) {
        b2bOrderModel.orderHistorySteps!.add("Delivery Ready");
        b2bOrderModel.orderFutureSteps!.remove("Delivery Ready");
      }
    }

    /// delivery_start
    if (status == AppConfig.b2bOrderStatusData[5]["id"]) {
      if (!b2bOrderModel!.orderHistoryStatus!.contains(AppConfig.b2bOrderStatusData[5]["id"])) {
        b2bOrderModel.orderHistoryStatus!.add(AppConfig.b2bOrderStatusData[5]["id"]);
        b2bOrderModel.orderFutureStatus!.remove(AppConfig.b2bOrderStatusData[5]["id"]);
      }

      if (!b2bOrderModel.orderHistorySteps!.contains("Delivery Start")) {
        b2bOrderModel.orderHistorySteps!.add("Delivery Start");
        b2bOrderModel.orderFutureSteps!.remove("Delivery Start");
      }
    }

    /// delivered
    if (status == AppConfig.b2bOrderStatusData[6]["id"]) {
      if (!b2bOrderModel!.orderHistoryStatus!.contains(AppConfig.b2bOrderStatusData[6]["id"])) {
        b2bOrderModel.orderHistoryStatus!.add(AppConfig.b2bOrderStatusData[6]["id"]);
        b2bOrderModel.orderFutureStatus!.remove(AppConfig.b2bOrderStatusData[6]["id"]);
      }

      if (!b2bOrderModel.orderHistorySteps!.contains("Delivered")) {
        b2bOrderModel.orderHistorySteps!.add("Delivered");
        b2bOrderModel.orderFutureSteps!.remove("Delivered");
      }
    }

    /// order_completed
    if (status == AppConfig.b2bOrderStatusData[7]["id"]) {
      if (!b2bOrderModel!.orderHistoryStatus!.contains(AppConfig.b2bOrderStatusData[7]["id"])) {
        b2bOrderModel.orderHistoryStatus!.add(AppConfig.b2bOrderStatusData[7]["id"]);
        b2bOrderModel.orderFutureStatus!.remove(AppConfig.b2bOrderStatusData[7]["id"]);
      }

      if (!b2bOrderModel.orderHistorySteps!.contains("Completed")) {
        b2bOrderModel.orderHistorySteps!.add("Completed");
        b2bOrderModel.orderFutureSteps!.remove("Completed");
      }
    }

    ////
    var result = await B2BOrderApiProvider.updateOrderData(
      orderData: b2bOrderModel!.toJson(),
      status: status,
      changedStatus: changedStatus,
    );
    if (result["success"]) {
      if (from == "sent") {
        _b2bOrderState = _b2bOrderState.update(
          sentProgressState: 1,
          sentOrderListData: Map<String, dynamic>(),
          sentOrderMetaData: Map<String, dynamic>(),
        );
      } else if (from == "received") {
        _b2bOrderState = _b2bOrderState.update(
          receivedProgressState: 1,
          receivedOrderListData: Map<String, dynamic>(),
          receivedOrderMetaData: Map<String, dynamic>(),
        );
      }
    }

    return result;
  }
}
