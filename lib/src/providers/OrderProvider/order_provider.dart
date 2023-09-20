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

class OrderProvider extends ChangeNotifier {
  static OrderProvider of(BuildContext context, {bool listen = false}) => Provider.of<OrderProvider>(context, listen: listen);

  OrderState _orderState = OrderState.init();
  OrderState get orderState => _orderState;

  void setOrderState(OrderState orderState, {bool isNotifiable = true}) {
    if (_orderState != orderState) {
      _orderState = orderState;
      if (isNotifiable) notifyListeners();
    }
  }

  // Future<void> addOrder({
  //   @required Map<String, dynamic>? orderData,
  //   @required String? category,
  //   @required String? status,
  // }) async {
  //   orderData = json.decode(json.encode(orderData));
  //   orderData!.remove("_id");
  //   if (orderData["storeId"] == null) {
  //     orderData["storeId"] = orderData["store"]["_id"];
  //   }
  //   try {
  //     orderData = PriceFunctions.calculateINRPromocode(orderData: orderData);
  //     double productPriceForAllOrderQuantityBeforeTax = 0;
  //     double productPriceForAllOrderQuantityAfterTax = 0;
  //     bool haveCustomProduct = false;
  //     for (var i = 0; i < orderData["products"].length; i++) {
  //       if (orderData["products"][i].isEmpty) continue;
  //       Map<String, dynamic> newData = Map<String, dynamic>();
  //       if (orderData["products"][i]["_id"] == null) {
  //         newData["name"] = orderData["products"][i]["name"];
  //         newData["orderQuantity"] = orderData["products"][i]["orderQuantity"];
  //         orderData["products"][i] = newData;
  //         haveCustomProduct = true;
  //       } else {
  //         var result = PriceFunctions.getPriceDataForProduct(orderData: orderData, data: orderData["products"][i]);
  //         newData["id"] = orderData["products"][i]["_id"];
  //         newData["orderQuantity"] = orderData["products"][i]["orderQuantity"];
  //         newData["name"] = orderData["products"][i]["name"];
  //         newData["description"] = orderData["products"][i]["description"];
  //         newData["images"] = orderData["products"][i]["images"];
  //         newData["category"] = orderData["products"][i]["category"];
  //         newData["brand"] = orderData["products"][i]["brand"];
  //         newData["productIdentificationCode"] = orderData["products"][i]["productIdentificationCode"];
  //         newData["price"] = double.parse(orderData["products"][i]["price"].toString());
  //         newData["discount"] = orderData["products"][i]["discount"] == null ? 0 : double.parse(orderData["products"][i]["discount"].toString());
  //         newData["promocodeDiscount"] = result["promocodeDiscount"];
  //         newData["taxPrice"] = result["taxPrice"];
  //         newData["priceFor1OrderQuantityBeforeTax"] = newData["price"] - newData["discount"] - newData["promocodeDiscount"] - newData["taxPrice"];
  //         newData["priceFor1OrderQuantityAfterTax"] = newData["price"] - newData["discount"] - newData["promocodeDiscount"];
  //         newData["quantity"] = orderData["products"][i]["quantity"];
  //         newData["quantityType"] = orderData["products"][i]["quantityType"];
  //         newData["taxPercentage"] = orderData["products"][i]["taxPercentage"];
  //         orderData["products"][i] = newData;
  //         productPriceForAllOrderQuantityBeforeTax += newData["priceFor1OrderQuantityBeforeTax"] * newData["orderQuantity"];
  //         productPriceForAllOrderQuantityAfterTax += newData["priceFor1OrderQuantityAfterTax"] * newData["orderQuantity"];
  //       }
  //     }
  //     if (haveCustomProduct) {
  //       productPriceForAllOrderQuantityBeforeTax = 0;
  //       productPriceForAllOrderQuantityAfterTax = 0;
  //     }

  //     double servicePriceForAllOrderQuantityBeforeTax = 0;
  //     double servicePriceForAllOrderQuantityAfterTax = 0;
  //     bool haveCustomService = false;
  //     for (var i = 0; i < orderData["services"].length; i++) {
  //       if (orderData["services"][i].isEmpty) continue;
  //       Map<String, dynamic> newData = Map<String, dynamic>();
  //       if (orderData["services"][i]["_id"] == null) {
  //         newData["name"] = orderData["services"][i]["name"];
  //         haveCustomService = true;
  //         newData["orderQuantity"] = orderData["services"][i]["orderQuantity"];
  //         orderData["services"][i] = newData;
  //       } else {
  //         var result = PriceFunctions.getPriceDataForProduct(orderData: orderData, data: orderData["services"][i]);
  //         newData["id"] = orderData["services"][i]["_id"];
  //         newData["orderQuantity"] = orderData["services"][i]["orderQuantity"];
  //         newData["name"] = orderData["services"][i]["name"];
  //         newData["description"] = orderData["services"][i]["description"];
  //         newData["images"] = orderData["services"][i]["images"];
  //         newData["category"] = orderData["services"][i]["category"];
  //         newData["provided"] = orderData["services"][i]["provided"];
  //         newData["price"] = double.parse(orderData["services"][i]["price"].toString());
  //         newData["discount"] = orderData["services"][i]["discount"] == null ? 0 : double.parse(orderData["services"][i]["discount"].toString());
  //         newData["promocodeDiscount"] = result["promocodeDiscount"];
  //         newData["taxPrice"] = result["taxPrice"];
  //         newData["priceFor1OrderQuantityBeforeTax"] = newData["price"] - newData["discount"] - newData["promocodeDiscount"] - newData["taxPrice"];
  //         newData["priceFor1OrderQuantityAfterTax"] = newData["price"] - newData["discount"] - newData["promocodeDiscount"];
  //         newData["priceToPay"] = newData["price"] - newData["discount"] - newData["promocodeDiscount"] + newData["taxPrice"];
  //         newData["taxPercentage"] = orderData["services"][i]["taxPercentage"];
  //         orderData["services"][i] = newData;
  //         servicePriceForAllOrderQuantityBeforeTax += newData["priceFor1OrderQuantityBeforeTax"] * newData["orderQuantity"];
  //         servicePriceForAllOrderQuantityAfterTax += newData["priceFor1OrderQuantityAfterTax"] * newData["orderQuantity"];
  //       }
  //     }

  //     if (haveCustomService) {
  //       servicePriceForAllOrderQuantityBeforeTax = 0;
  //       servicePriceForAllOrderQuantityAfterTax = 0;
  //     }

  //     if (haveCustomService || haveCustomService) {
  //       orderData["productPriceForAllOrderQuantityBeforeTax"] = 0;
  //       orderData["productPriceForAllOrderQuantityAfterTax"] = 0;
  //       orderData["servicePriceForAllOrderQuantityBeforeTax"] = 0;
  //       orderData["servicePriceForAllOrderQuantityAfterTax"] = 0;
  //       orderData["paymentDetail"] = {
  //         "promocode": orderData["paymentDetail"]["promocode"],
  //         "distance": orderData["paymentDetail"]["distance"],
  //         "totalQuantity": orderData["paymentDetail"]["totalQuantity"],
  //         "totalPriceBeforePromocode": 0,
  //         "totalPriceAfterPromocode": 0,
  //         "deliveryCargeBeforePromocode": 0,
  //         "deliveryCargeAfterPromocode": 0,
  //         "deliveryDiscount": 0,
  //         "tip": 0,
  //         "totalTax": 0,
  //         "totalTaxBeforePromocode": 0,
  //         "toPay": 0,
  //       };
  //     } else {
  //       orderData["productPriceForAllOrderQuantityBeforeTax"] = productPriceForAllOrderQuantityBeforeTax.toStringAsFixed(2);
  //       orderData["productPriceForAllOrderQuantityAfterTax"] = productPriceForAllOrderQuantityAfterTax.toStringAsFixed(2);
  //       orderData["servicePriceForAllOrderQuantityBeforeTax"] = servicePriceForAllOrderQuantityBeforeTax.toStringAsFixed(2);
  //       orderData["servicePriceForAllOrderQuantityAfterTax"] = servicePriceForAllOrderQuantityAfterTax.toStringAsFixed(2);
  //     }
  //     orderData["status"] = status;
  //     orderData["category"] = category;
  //     orderData["orderId"] = "TM-" + randomAlphaNumeric(12);

  //     ///  add promocode
  //     if (orderData["promocode"] != null) {
  //       Map<String, dynamic> tmp = Map<String, dynamic>();
  //       tmp["id"] = orderData["promocode"]["_id"];
  //       tmp["promocodeType"] = orderData["promocode"]["promocodeType"];
  //       tmp["promocodeCode"] = orderData["promocode"]["promocodeCode"];
  //       tmp["promocodeValue"] = orderData["promocode"]["promocodeValue"];
  //       orderData["promocode"] = tmp;
  //     }

  //     if (orderData["products"].isEmpty && orderData["services"].isNotEmpty) {
  //       orderData["orderType"] = "Service";
  //     }

  //     orderData.remove("createdAt");
  //     orderData.remove("updatedAt");

  //     /// --- tax Tyepe
  //     if (orderData["orderType"] == "Pickup") {
  //       orderData["paymentDetail"]["taxType"] = "SGST";
  //     } else if (orderData["orderType"] == "Delivery" &&
  //         orderData["deliveryAddress"]["address"]["state"].toString().toLowerCase() == orderData["store"]["state"].toString().toLowerCase()) {
  //       orderData["paymentDetail"]["taxType"] = "SGST";
  //     } else if (orderData["orderType"] == "Delivery" &&
  //         orderData["deliveryAddress"]["address"]["state"].toString().toLowerCase() != orderData["store"]["state"].toString().toLowerCase()) {
  //       orderData["paymentDetail"]["taxType"] = "IGST";
  //     }

  //     if (double.parse(orderData["paymentDetail"]["totalTax"].toString()) > 0) {
  //       orderData["paymentDetail"]["taxBreakdown"] = [
  //         {"type": "CGST", "value": (double.parse(orderData["paymentDetail"]["totalTax"].toString()) / 2).toStringAsFixed(2)},
  //         {
  //           "type": orderData["paymentDetail"]["taxType"],
  //           "value": (double.parse(orderData["paymentDetail"]["totalTax"].toString()) / 2).toStringAsFixed(2)
  //         }
  //       ];
  //     }
  //     ///////////////////
  //     if (orderData["redeemRewardData"] == null || orderData["redeemRewardData"]["sumRewardPoint"] == null) {
  //       orderData["redeemRewardData"] = Map<String, dynamic>();
  //       orderData["redeemRewardData"]["sumRewardPoint"] = 0;
  //       orderData["redeemRewardData"]["redeemRewardValue"] = 0;
  //       orderData["redeemRewardData"]["redeemRewardPoint"] = 0;
  //       orderData["redeemRewardData"]["tradeSumRewardPoint"] = 0;
  //       orderData["redeemRewardData"]["tradeRedeemRewardPoint"] = 0;
  //       orderData["redeemRewardData"]["tradeRedeemRewardValue"] = 0;
  //     }
  //     ////

  //     var result = await OrderApiProvider.addOrder(
  //       orderData: orderData,
  //       qrCode: Encrypt.encryptString("Order_${orderData["orderId"]}_StoreId-${orderData["storeId"]}_UserId-${orderData["userId"]}"),
  //     );

  //     if (result["success"]) {
  //       _orderState = _orderState.update(
  //         progressState: 2,
  //         newOrderData: result["data"],
  //       );
  //     } else {
  //       _orderState = _orderState.update(
  //         progressState: -1,
  //         message: result["message"],
  //       );
  //     }
  //   } catch (e) {
  //     _orderState = _orderState.update(
  //       progressState: -1,
  //       message: e.toString(),
  //     );
  //   }

  //   notifyListeners();
  // }

  Future<void> addOrder({
    @required OrderModel? orderModel,
    @required String? category,
    @required String? status,
  }) async {
    orderModel!.cashOnDelivery = false;
    orderModel = OrderModel.copy(orderModel);
    try {
      // bool haveCustomProduct = false;
      // for (var i = 0; i < orderModel.products!.length; i++) {
      //   if (orderModel.products![i].productModel!.id == "") {
      //     // newData["name"] = orderModel.products![i]["data"]["name"];
      //     // newData["orderQuantity"] = orderModel.products![i]["orderQuantity"];
      //     // orderModel.products![i] = newData;
      //     haveCustomProduct = true;
      //   }
      // }

      // bool haveCustomService = false;
      // for (var i = 0; i < orderModel.services!.length; i++) {
      //   if (orderModel.services![i].serviceModel!.id == null) {
      //     // newData["name"] = orderModel.services![i]["data"]["name"];
      //     // newData["orderQuantity"] = orderModel.services![i]["orderQuantity"];
      //     // orderModel.services![i] = newData;
      //     haveCustomService = true;
      //   }
      // }

      // if (haveCustomService || haveCustomService) {
      //   // orderModel["productPriceForAllOrderQuantityBeforeTax"] = 0;
      //   // orderModel["productPriceForAllOrderQuantityAfterTax"] = 0;
      //   // orderModel["servicePriceForAllOrderQuantityBeforeTax"] = 0;
      //   // orderModel["servicePriceForAllOrderQuantityAfterTax"] = 0;
      //   // orderModel.paymentDetail = {
      //   //   "promocode": orderModel.paymentDetail["promocode"],
      //   //   "distance": orderModel.paymentDetail["distance"],
      //   //   "totalQuantity": orderModel.paymentDetail["totalQuantity"],
      //   //   "totalOriginPrice": 0,
      //   //   "totalPrice": 0,
      //   //   "deliveryCargeBeforeDiscount": 0,
      //   //   "deliveryCargeAfterDiscount": 0,
      //   //   "deliveryDiscount": 0,
      //   //   "tip": 0,
      //   //   "totalTax": 0,
      //   //   "totalTaxBeforeDiscount": 0,
      //   //   "toPay": 0,
      //   // };
      // }
      orderModel.status = status;
      orderModel.category = category;
      orderModel.orderId = "TM-" + randomAlphaNumeric(12);

      // /// --- tax Tyepe
      // if (orderModel.orderType == "Pickup") {
      //   orderModel.paymentDetail!.taxType = "SGST";
      // } else if (orderModel.orderType == "Delivery" &&
      //     orderModel.deliveryAddress!.address!.state.toString().toLowerCase() == orderModel.storeModel!.state!.toString().toLowerCase()) {
      //   orderModel.paymentDetail!.taxType = "SGST";
      // } else if (orderModel.orderType == "Delivery" &&
      //     orderModel.deliveryAddress!.address!.state.toString().toLowerCase() != orderModel.storeModel!.state!.toString().toLowerCase()) {
      //   orderModel.paymentDetail!.taxType = "IGST";
      // }

      // if (orderModel.paymentDetail!.totalTaxAfterDiscount! > 0) {
      //   orderModel.paymentDetail!.taxBreakdown = [
      //     {"type": "CGST", "value": (orderModel.paymentDetail!.totalTaxAfterDiscount! / 2).toStringAsFixed(2)},
      //     {"type": orderModel.paymentDetail!.taxType!, "value": (orderModel.paymentDetail!.totalTaxAfterDiscount! / 2).toStringAsFixed(2)}
      //   ];
      // }

      if (orderModel.products!.isEmpty && orderModel.services!.isNotEmpty) {
        orderModel.orderType = "Service";
      }
      // ///////////////////
      // if (orderModel.redeemRewardData == null || orderModel.redeemRewardData!["sumRewardPoint"] == null) {
      //   orderModel.redeemRewardData = Map<String, dynamic>();
      //   orderModel.redeemRewardData!["sumRewardPoint"] = 0;
      //   orderModel.redeemRewardData!["redeemRewardValue"] = 0;
      //   orderModel.redeemRewardData!["redeemRewardPoint"] = 0;
      //   orderModel.redeemRewardData!["tradeSumRewardPoint"] = 0;
      //   orderModel.redeemRewardData!["tradeRedeemRewardPoint"] = 0;
      //   orderModel.redeemRewardData!["tradeRedeemRewardValue"] = 0;
      // }
      // ////

      /// order steps
      if (orderModel.orderType == OrderType.delivery) {
        orderModel.orderHistorySteps = [
          {"text": "Order Created"},
        ];
        if (orderModel.cashOnDelivery!)
          orderModel.orderFutureSteps = [
            {"text": "Order Accepted"},
            {"text": "Delivery Ready"},
            {"text": "Items Picked"},
            {"text": "Delivery done"},
          ];
        else
          orderModel.orderFutureSteps = [
            {"text": "Order Accepted"},
            {"text": "Order Paid"},
            {"text": "Delivery Ready"},
            {"text": "Items Picked"},
            {"text": "Delivery done"},
          ];
      } else if (orderModel.orderType == OrderType.pickup) {
        orderModel.orderHistorySteps = [
          {"text": "Order Created"},
        ];
        if (orderModel.payAtStore!)
          orderModel.orderFutureSteps = [
            {"text": "Order Accepted"},
            {"text": "Pickup Ready"},
            {"text": "Completed"},
          ];
        else
          orderModel.orderFutureSteps = [
            {"text": "Order Accepted"},
            {"text": "Order Paid"},
            {"text": "Pickup Ready"},
            {"text": "Completed"},
          ];
      }
      /////////////////////

      if (status == AppConfig.orderStatusData[2]["id"]) {
        orderModel.orderHistorySteps!.add({"text": "Order Accepted"});
        orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Order Accepted");
      }

      var result = await OrderApiProvider.addOrder(
        orderData: orderModel.toJson(),
        qrCode: Encrypt.encryptString("Order_${orderModel.orderId}_StoreId-${orderModel.storeModel!.id}_UserId-${orderModel.userModel!.id}"),
      );

      if (result["success"]) {
        OrderModel newOrderModel = OrderModel.fromJson(result["data"]);
        newOrderModel.storeModel = orderModel.storeModel;
        newOrderModel.userModel = orderModel.userModel;

        _orderState = _orderState.update(
          progressState: 2,
          newOrderModel: newOrderModel,
        );
      } else {
        _orderState = _orderState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _orderState = _orderState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<void> getOrderData({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? orderListData = _orderState.orderListData;
    Map<String, dynamic>? orderMetaData = _orderState.orderMetaData;
    try {
      if (orderListData![status] == null) orderListData[status!] = [];
      if (orderMetaData![status] == null) orderMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await OrderApiProvider.getOrderData(
        storeId: storeId,
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

        _orderState = _orderState.update(
          progressState: 2,
          orderListData: orderListData,
          orderMetaData: orderMetaData,
        );
      } else {
        _orderState = _orderState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _orderState = _orderState.update(
        progressState: 2,
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
  //   var result = await OrderApiProvider.changeOrderStatus(
  //     orderId: orderId,
  //     userId: userId,
  //     status: status,
  //     storeId: storeId,
  //     token: token,
  //   );

  //   if (result["success"]) {
  //     _orderState = _orderState.update(
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
    @required OrderModel? orderModel,
    @required String? status,
    bool changedStatus = false,
  }) async {
    /// order_accepted
    if (status == AppConfig.orderStatusData[2]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Accepted"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Order Accepted");
    }

    /// order_paid
    if (status == AppConfig.orderStatusData[3]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Paid"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Order Paid");
    }

    /// pickup_ready
    if (status == AppConfig.orderStatusData[4]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Pickup Ready"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Pickup Ready");
    }

    /// delivery_ready
    if (status == AppConfig.orderStatusData[5]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Delivery Ready"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Delivery Ready");
    }

    /// delivered
    if (status == AppConfig.orderStatusData[6]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Delivery done"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Delivery done");
    }

    /// order_cancelled
    if (status == AppConfig.orderStatusData[7]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Cancelled"});
      orderModel.orderFutureSteps = [];
    }

    /// order_rejected
    if (status == AppConfig.orderStatusData[8]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Rejected"});
      orderModel.orderFutureSteps = [];
    }

    /// order_completed
    if (status == AppConfig.orderStatusData[9]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Completed"});
      orderModel.orderFutureSteps = [];
    }

    var result = await OrderApiProvider.updateOrderData(
      orderData: orderModel!.toJson(),
      status: status,
      changedStatus: changedStatus,
      storeId: orderModel.storeModel!.id,
    );
    if (result["success"]) {
      _orderState = _orderState.update(
        progressState: 1,
        orderListData: Map<String, dynamic>(),
        orderMetaData: Map<String, dynamic>(),
      );
    }

    return result;
  }

  Future<void> getDashboardDataByStore({@required String? storeId}) async {
    try {
      var result = await OrderApiProvider.getDashboardDataByStore(storeId: storeId);
      if (result["success"]) {
        _orderState = _orderState.update(
          dashboardOrderData: result["data"],
        );
      } else {}
    } catch (e) {}
  }
}
