import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/b2b_payment_detail_panel.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/payment_detail_panel.dart';
import 'package:trapp/src/elements/pos_widget.dart';
import 'package:trapp/src/elements/print_widget.dart';
import 'package:trapp/src/elements/qr_code_widget.dart';
import 'package:trapp/src/elements/store_info_panel.dart';
import 'package:trapp/src/elements/user_info_panel.dart';
import 'package:trapp/src/helpers/b2b_price_functions.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/helpers/price_functions1.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:json_diff/json_diff.dart';

import 'index.dart';

class B2BOrderDetailView extends StatefulWidget {
  B2BOrderModel? b2bOrderModel;

  B2BOrderDetailView({Key? key, this.b2bOrderModel}) : super(key: key);

  @override
  _B2BOrderDetailViewState createState() => _B2BOrderDetailViewState();
}

class _B2BOrderDetailViewState extends State<B2BOrderDetailView> {
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

  B2BOrderModel? _b2bOrderModel;

  String? updatedOrderStatus;

  bool isSent = false;

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
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _b2bOrderModel = B2BOrderModel.copy(widget.b2bOrderModel!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _calculateOrderPrice() {
    for (var i = 0; i < _b2bOrderModel!.products!.length; i++) {
      ProductOrderModel productOrderModel = _b2bOrderModel!.products![i];

      if (productOrderModel.productModel!.realBulkOrder! &&
          productOrderModel.productModel!.minQuantityForBulkOrder! > productOrderModel.orderQuantity!) {
        productOrderModel.orderPrice = productOrderModel.productModel!.price;
      } else {
        productOrderModel.orderPrice = productOrderModel.productModel!.price! - productOrderModel.productModel!.discount!;
      }

      if (productOrderModel.productModel!.taxType == null || productOrderModel.productModel!.taxType == AppConfig.taxTypes.first["value"]) {
      } else if (productOrderModel.productModel!.taxType == AppConfig.taxTypes.last["value"]) {
        double taxPrice = (productOrderModel.orderPrice! * productOrderModel.productModel!.taxPercentage!) / (100);
        productOrderModel.orderPrice = productOrderModel.orderPrice! + taxPrice;
      }
    }

    for (var i = 0; i < _b2bOrderModel!.services!.length; i++) {
      ServiceOrderModel serviceOrderModel = _b2bOrderModel!.services![i];

      if (serviceOrderModel.serviceModel!.realBulkOrder! &&
          serviceOrderModel.serviceModel!.minQuantityForBulkOrder! > serviceOrderModel.orderQuantity!) {
        serviceOrderModel.orderPrice = serviceOrderModel.serviceModel!.price;
      } else {
        serviceOrderModel.orderPrice = serviceOrderModel.serviceModel!.price! - serviceOrderModel.serviceModel!.discount!;
      }

      if (serviceOrderModel.serviceModel!.taxType == null || serviceOrderModel.serviceModel!.taxType == AppConfig.taxTypes.first["value"]) {
      } else if (serviceOrderModel.serviceModel!.taxType == AppConfig.taxTypes.last["value"]) {
        double taxPrice = (serviceOrderModel.orderPrice! * serviceOrderModel.serviceModel!.taxPercentage!) / (100);
        serviceOrderModel.orderPrice = serviceOrderModel.orderPrice! + taxPrice;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _calculateOrderPrice();

    B2BPriceFunctions.calculateDiscount(b2bOrderModel: _b2bOrderModel);
    _b2bOrderModel!.paymentDetail = B2BPriceFunctions.calclatePaymentDetail(b2bOrderModel: _b2bOrderModel);

    isSent = false;

    if (_b2bOrderModel!.myStoreModel!.id == AuthProvider.of(context).authState.storeModel!.id) {
      isSent = true;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop(updatedOrderStatus);
          },
        ),
        centerTitle: true,
        title: Text("B2B Order Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: _mainPanel(),
      ),
    );
  }

  Widget _mainPanel() {
    String orderStatus = "";
    for (var i = 0; i < AppConfig.b2bOrderStatusData.length; i++) {
      if (_b2bOrderModel!.status == AppConfig.b2bOrderStatusData[i]["id"]) {
        orderStatus = AppConfig.b2bOrderStatusData[i]["name"];
        break;
      }
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: Column(
            children: [
              Text(
                "${_b2bOrderModel!.orderId}",
                style: TextStyle(fontSize: fontSp * 21, color: Colors.black),
              ),

              ///
              SizedBox(height: heightDp * 5),
              QrCodeWidget(
                code: Encrypt.encryptString(
                  "B2BOrder_${_b2bOrderModel!.orderId}"
                  "_MyStoreId-${_b2bOrderModel!.myStoreModel!.id}"
                  "_BusinessStoreId-${_b2bOrderModel!.businessStoreModel!.id}",
                ),
                size: heightDp * 150,
              ),

              ///
              SizedBox(height: heightDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (await canLaunch(_b2bOrderModel!.invoicePdfUrlForStore ?? _b2bOrderModel!.invoicePdfUrl!)) {
                        await launch(
                          _b2bOrderModel!.invoicePdfUrlForStore ?? _b2bOrderModel!.invoicePdfUrl!,
                          forceSafariVC: false,
                          forceWebView: false,
                        );
                      } else {
                        throw 'Could not launch ${_b2bOrderModel!.invoicePdfUrlForStore ?? _b2bOrderModel!.invoicePdfUrl}';
                      }
                    },
                    child: Image.asset("img/pdf-icon.png", width: heightDp * 30, height: heightDp * 30, fit: BoxFit.cover),
                  ),
                  SizedBox(width: widthDp * 30),
                  GestureDetector(
                    onTap: () {
                      Share.share(_b2bOrderModel!.invoicePdfUrlForStore ?? _b2bOrderModel!.invoicePdfUrl!);
                    },
                    child: Image.asset(
                      "img/share-icon.png",
                      width: heightDp * 30,
                      height: heightDp * 30,
                      fit: BoxFit.cover,
                      color: config.Colors().mainColor(1),
                    ),
                  ),
                  SizedBox(width: widthDp * 30),
                  PrintWidget(
                    path: _b2bOrderModel!.invoicePdfUrl,
                    size: heightDp * 40,
                    color: config.Colors().mainColor(1),
                  ),
                  // SizedBox(width: widthDp * 30),
                  // POSWidget(
                  //   path: _b2bOrderModel!.invoicePdfUrl,
                  //   size: heightDp * 40,
                  //   color: config.Colors().mainColor(1),
                  // ),
                ],
              ),

              ///
              SizedBox(height: heightDp * 15),
              StoreInfoPanel(storeModel: _b2bOrderModel!.businessStoreModel),

              ///
              SizedBox(height: heightDp * 15),
              CartListPanel(
                b2bOrderModel: B2BOrderModel.copy(_b2bOrderModel!),
                refreshCallback: (B2BOrderModel? b2bOrderModel) {
                  _b2bOrderModel = b2bOrderModel;
                  setState(() {});
                },
              ),
              Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

              ///
              _b2bOrderModel!.description == ""
                  ? SizedBox()
                  : Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Container(
                          width: deviceWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.event_note, size: heightDp * 25, color: Colors.black.withOpacity(0.7)),
                                  SizedBox(width: widthDp * 10),
                                  Text(
                                    "Message On Invoice",
                                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: heightDp * 5),
                              Text(
                                _b2bOrderModel!.description!,
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      ],
                    ),

              // ///
              // if (_b2bOrderModel!.promocode != null)
              //   Column(
              //     children: [
              //       SizedBox(height: heightDp * 10),
              //       Container(
              //         width: deviceWidth,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Promo code: ",
              //               style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              //             ),
              //             Text(
              //               _b2bOrderModel!.promocode!.promocodeCode!,
              //               style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              //             ),
              //           ],
              //         ),
              //       ),
              //       SizedBox(height: heightDp * 10),
              //       Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              //     ],
              //   ),

              ///
              SizedBox(height: heightDp * 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Status: ",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    orderStatus,
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),
              if (_b2bOrderModel!.status == AppConfig.b2bOrderStatusData[6]["id"] || _b2bOrderModel!.status == AppConfig.b2bOrderStatusData[7]["id"])
                Column(
                  children: [
                    SizedBox(height: heightDp * 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _b2bOrderModel!.status == AppConfig.b2bOrderStatusData[7]["id"] ? "Cancel Reason:" : "Reject Reason: ",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: widthDp * 10),
                        Expanded(
                          child: Text(
                            "${_b2bOrderModel!.reasonForCancelOrReject}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              SizedBox(height: heightDp * 10),
              Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

              // ///
              // _b2bOrderModel!.products == null || _b2bOrderModel!.products!.isEmpty
              //     ? SizedBox()
              //     : Column(
              //         children: [
              //           SizedBox(height: heightDp * 10),
              //           Container(
              //             width: deviceWidth,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   "Order Type: ",
              //                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              //                 ),
              //                 Text(
              //                   _b2bOrderModel!.orderType!,
              //                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           SizedBox(height: heightDp * 10),
              //           Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              //         ],
              //       ),

              // ///
              // _b2bOrderModel!.products!.isEmpty || _b2bOrderModel!.orderType != "Pickup" || _b2bOrderModel!.pickupDateTime == null
              //     ? SizedBox()
              //     : Column(
              //         children: [
              //           SizedBox(height: heightDp * 10),
              //           Container(
              //             width: deviceWidth,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   "Pickup Date:",
              //                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              //                 ),
              //                 Text(
              //                   KeicyDateTime.convertDateTimeToDateString(
              //                     dateTime: _b2bOrderModel!.pickupDateTime,
              //                     formats: 'Y-m-d h:i A',
              //                     isUTC: false,
              //                   ),
              //                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           SizedBox(height: heightDp * 10),
              //           Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              //         ],
              //       ),

              // ///
              // _b2bOrderModel!.products!.isEmpty || _b2bOrderModel!.orderType != "Delivery" || _b2bOrderModel!.deliveryAddress == null
              //     ? SizedBox()
              //     : Column(
              //         children: [
              //           SizedBox(height: heightDp * 10),
              //           Container(
              //             width: deviceWidth,
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   "Delivery Address:",
              //                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              //                 ),
              //                 SizedBox(height: heightDp * 5),
              //                 Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Row(
              //                       children: [
              //                         Text(
              //                           "${_b2bOrderModel!.deliveryAddress!.addressType}",
              //                           style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
              //                           maxLines: 2,
              //                           overflow: TextOverflow.ellipsis,
              //                         ),
              //                         SizedBox(width: widthDp * 10),
              //                         Text(
              //                           "${(_b2bOrderModel!.deliveryAddress!.distance! / 1000).toStringAsFixed(3)} Km",
              //                           style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              //                         ),
              //                       ],
              //                     ),
              //                     SizedBox(height: heightDp * 5),
              //                     _b2bOrderModel!.deliveryAddress!.building == null || _b2bOrderModel!.deliveryAddress!.building == ""
              //                         ? SizedBox()
              //                         : Column(
              //                             children: [
              //                               Text(
              //                                 "${_b2bOrderModel!.deliveryAddress!.building}",
              //                                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              //                                 maxLines: 2,
              //                                 overflow: TextOverflow.ellipsis,
              //                               ),
              //                               SizedBox(height: heightDp * 5),
              //                             ],
              //                           ),
              //                     Text(
              //                       "${_b2bOrderModel!.deliveryAddress!.address!.address}",
              //                       style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              //                       maxLines: 2,
              //                       overflow: TextOverflow.ellipsis,
              //                     ),
              //                     SizedBox(height: heightDp * 10),
              //                     KeicyCheckBox(
              //                       iconSize: heightDp * 25,
              //                       iconColor: Color(0xFF00D18F),
              //                       labelSpacing: widthDp * 20,
              //                       label: "No Contact Delivery",
              //                       labelStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
              //                       value: _b2bOrderModel!.noContactDelivery!,
              //                       readOnly: true,
              //                     ),
              //                   ],
              //                 )
              //               ],
              //             ),
              //           ),
              //           SizedBox(height: heightDp * 10),
              //           Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              //         ],
              //       ),

              // ///
              // _b2bOrderModel!.services!.isEmpty || _b2bOrderModel!.serviceDateTime == null
              //     ? SizedBox()
              //     : Column(
              //         children: [
              //           SizedBox(height: heightDp * 10),
              //           Container(
              //             width: deviceWidth,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   "Service Date:",
              //                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              //                 ),
              //                 Text(
              //                   KeicyDateTime.convertDateTimeToDateString(
              //                     dateTime: _b2bOrderModel!.serviceDateTime,
              //                     formats: 'Y-m-d h:i A',
              //                     isUTC: false,
              //                   ),
              //                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           SizedBox(height: heightDp * 10),
              //           Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              //         ],
              //       ),

              //////
              SizedBox(height: heightDp * 10),
              B2BPaymentDetailPanel(b2bOrderModel: _b2bOrderModel, padding: EdgeInsets.zero),
              SizedBox(height: heightDp * 20),

              ///
              if (_b2bOrderModel!.status == AppConfig.b2bOrderStatusData[1]["id"])
                if (isSent) _acceptOrderSentButtonGroup() else _acceptOrderReceivedButtonGroup()
              else if (_b2bOrderModel!.status == AppConfig.b2bOrderStatusData[2]["id"])
                if (isSent) _paidOrderSentButtonGroup() else _paidOrderReceivedButtonGroup()
              else if (_b2bOrderModel!.status == AppConfig.b2bOrderStatusData[3]["id"])
                if (isSent) _pickupReadyOrderSentButtonGroup() else SizedBox()
              else if (_b2bOrderModel!.status == AppConfig.b2bOrderStatusData[4]["id"])
                if (isSent) _deliveryReadyOrderSentButtonGroup() else SizedBox()
              else if (_b2bOrderModel!.status == AppConfig.b2bOrderStatusData[5]["id"])
                if (isSent) _deliveryStartOrderSentButtonGroup() else _deliveryStartOrderReceivedButtonGroup()
              else if (_b2bOrderModel!.status == AppConfig.b2bOrderStatusData[6]["id"])
                if (isSent) _deliveredOrderSentButtonGroup() else SizedBox()
              else
                SizedBox(),
              SizedBox(height: heightDp * 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _acceptOrderReceivedButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp * 100,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: _cancelCallback,
        ),
      ],
    );
  }

  Widget _acceptOrderSentButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp * 130,
          height: heightDp * 30,
          color: _b2bOrderModel!.products!.isEmpty && _b2bOrderModel!.services!.isEmpty ? Colors.grey.withOpacity(0.6) : config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Payment Received",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: _payCallback,
        ),
        if (_b2bOrderModel!.orderType == "Delivery")
          KeicyRaisedButton(
            width: widthDp * 130,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Delivery Ready",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: _deliveryReadyCallback,
          ),
        if (_b2bOrderModel!.orderType == "Pickup")
          KeicyRaisedButton(
            width: widthDp * 130,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Pickup Ready",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: _pickupReadyCallback,
          ),
        KeicyRaisedButton(
          width: widthDp * 100,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          child: Text(
            "Reject",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: _rejectCallback,
        ),
      ],
    );
  }

  Widget _paidOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (_b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[3]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Pickup Ready",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: _pickupReadyCallback,
            ),
          if (_b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[4]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Delivery Ready",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: _deliveryReadyCallback,
            ),
          if (!_b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[4]["id"]) &&
              _b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[5]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Delivery Start",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: _deliveryStartCallback,
            ),
          if (_b2bOrderModel!.orderFutureStatus!.length == 1 && _b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[7]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Complete",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                _completeCallback();
              },
            ),
        ],
      ),
    );
  }

  Widget _paidOrderReceivedButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (!_b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[5]["id"]) &&
              _b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[6]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Order Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: _deliveryDoneCallback,
            ),
        ],
      ),
    );
  }

  Widget _pickupReadyOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (_b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[2]["id"]))
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Payment Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                _payCallback();
              },
            ),
          if (_b2bOrderModel!.orderFutureStatus!.length == 1 && _b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[7]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Complete",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                _completeCallback();
              },
            ),
        ],
      ),
    );
  }

  Widget _deliveryReadyOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (_b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[2]["id"]))
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Payment Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                _payCallback();
              },
            ),
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Delivery Start",
              style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
            ),
            onPressed: () {
              _deliveryStartCallback();
            },
          ),
        ],
      ),
    );
  }

  Widget _deliveryStartOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (_b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[2]["id"]))
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Payment Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                _payCallback();
              },
            ),
        ],
      ),
    );
  }

  Widget _deliveryStartOrderReceivedButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Order Received",
              style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
            ),
            onPressed: () {
              _deliveryDoneCallback();
            },
          ),
        ],
      ),
    );
  }

  Widget _deliveredOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (_b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[2]["id"]))
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Payment Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                _payCallback();
              },
            ),
          if (_b2bOrderModel!.orderFutureStatus!.length == 1 && _b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[7]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Complete",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                _completeCallback();
              },
            ),
        ],
      ),
    );
  }

  void _rejectCallback() async {
    OrderRejectDialog.show(
      context,
      title: "Order Reject",
      content: "Do you really want to reject the order. User will be notified with the rejection. Do you want to proceed.",
      callback: (reason) async {
        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(_b2bOrderModel!);
        newb2bOrderModel.reasonForCancelOrReject = reason;

        await _keicyProgressDialog!.show();
        var result = await _b2bOrderProvider!.updateOrderData(
          b2bOrderModel: newb2bOrderModel,
          status: AppConfig.b2bOrderStatusData[9]["id"],
          changedStatus: false,
          from: "sent",
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _b2bOrderModel = B2BOrderModel.fromJson(result["data"]);
          _b2bOrderModel!.myStoreModel = newb2bOrderModel.myStoreModel;
          _b2bOrderModel!.businessStoreModel = newb2bOrderModel.businessStoreModel;

          _b2bOrderModel!.status = AppConfig.b2bOrderStatusData[9]["id"];
          updatedOrderStatus = AppConfig.b2bOrderStatusData[9]["id"];
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The order is rejectecd",
          );
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: result["message"],
            isTryButton: true,
            callBack: () {
              _rejectCallback();
            },
          );
        }
      },
    );
  }

  void _cancelCallback() async {
    OrderRejectDialog.show(
      context,
      title: "Order cancel",
      content: "Do you really want to cancel the order. User will be notified with the rejection. Do you want to proceed.",
      callback: (reason) async {
        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(_b2bOrderModel!);
        newb2bOrderModel.reasonForCancelOrReject = reason;
        await _keicyProgressDialog!.show();
        var result = await _b2bOrderProvider!.updateOrderData(
          b2bOrderModel: newb2bOrderModel,
          status: AppConfig.b2bOrderStatusData[8]["id"],
          changedStatus: false,
          from: "received",
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _b2bOrderModel = B2BOrderModel.fromJson(result["data"]);
          _b2bOrderModel!.myStoreModel = newb2bOrderModel.myStoreModel;
          _b2bOrderModel!.businessStoreModel = newb2bOrderModel.businessStoreModel;

          _b2bOrderModel!.status = AppConfig.b2bOrderStatusData[8]["id"];
          updatedOrderStatus = AppConfig.b2bOrderStatusData[8]["id"];
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The order is rejectecd",
          );
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: result["message"],
            isTryButton: true,
            callBack: () {
              _rejectCallback();
            },
          );
        }
      },
    );
  }

  void _payCallback() async {
    B2BOrderPaidDialog.show(
      context,
      title: "Order Paid",
      content: "Do you want to upload proof of payment for this order?",
      callback: (File? file) async {
        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(_b2bOrderModel!);

        await _keicyProgressDialog!.show();
        var result = await UploadFileApiProvider.uploadFile(
          file: file,
          bucketName: "INVOICES_BUCKET",
          directoryName: "b2b_payment_proof/",
          fileName: _b2bOrderModel!.orderId! + "_" + DateTime.now().millisecondsSinceEpoch.toString(),
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
          _b2bOrderModel = B2BOrderModel.fromJson(result["data"]);
          _b2bOrderModel!.myStoreModel = newb2bOrderModel.myStoreModel;
          _b2bOrderModel!.businessStoreModel = newb2bOrderModel.businessStoreModel;

          _b2bOrderModel!.status = AppConfig.b2bOrderStatusData[2]["id"];
          updatedOrderStatus = AppConfig.b2bOrderStatusData[2]["id"];
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The order is paid",
          );
        }
      },
    );
  }

  void _pickupReadyCallback() async {
    OrderStatusDialog.show(
      context,
      title: "Pickup is Ready",
      content: "Is the order ready for Pickup",
      okayButtonString: "Yes",
      cancelButtonString: "No",
      callback: () async {
        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(_b2bOrderModel!);

        await _keicyProgressDialog!.show();
        var result = await _b2bOrderProvider!.updateOrderData(
          b2bOrderModel: newb2bOrderModel,
          status: AppConfig.b2bOrderStatusData[3]["id"],
          changedStatus: false,
          from: "sent",
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _b2bOrderModel = B2BOrderModel.fromJson(result["data"]);
          _b2bOrderModel!.myStoreModel = newb2bOrderModel.myStoreModel;
          _b2bOrderModel!.businessStoreModel = newb2bOrderModel.businessStoreModel;

          _b2bOrderModel!.status = AppConfig.b2bOrderStatusData[3]["id"];
          updatedOrderStatus = AppConfig.b2bOrderStatusData[3]["id"];
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The order is rejectecd",
          );
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: result["message"],
            isTryButton: true,
            callBack: () {
              _pickupReadyCallback();
            },
          );
        }
      },
    );
  }

  void _deliveryReadyCallback() async {
    B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(_b2bOrderModel!);

    await _keicyProgressDialog!.show();
    var result = await _b2bOrderProvider!.updateOrderData(
      b2bOrderModel: newb2bOrderModel,
      status: AppConfig.b2bOrderStatusData[4]["id"],
      changedStatus: false,
      from: "sent",
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _b2bOrderModel = B2BOrderModel.fromJson(result["data"]);
      _b2bOrderModel!.myStoreModel = newb2bOrderModel.myStoreModel;
      _b2bOrderModel!.businessStoreModel = newb2bOrderModel.businessStoreModel;

      _b2bOrderModel!.status = AppConfig.b2bOrderStatusData[4]["id"];
      updatedOrderStatus = AppConfig.b2bOrderStatusData[4]["id"];
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "The order is ready for delivery",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        isTryButton: true,
        callBack: () {
          _deliveryReadyCallback();
        },
      );
    }
  }

  void _deliveryStartCallback() async {
    B2BOrderDeliveryStartDialog.show(context, callback: (String str) async {
      B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(_b2bOrderModel!);

      newb2bOrderModel.deliveryDetails = str;

      await _keicyProgressDialog!.show();
      var result = await _b2bOrderProvider!.updateOrderData(
        b2bOrderModel: newb2bOrderModel,
        status: AppConfig.b2bOrderStatusData[5]["id"],
        changedStatus: false,
        from: "sent",
      );
      await _keicyProgressDialog!.hide();
      if (result["success"]) {
        _b2bOrderModel = B2BOrderModel.fromJson(result["data"]);
        _b2bOrderModel!.myStoreModel = newb2bOrderModel.myStoreModel;
        _b2bOrderModel!.businessStoreModel = newb2bOrderModel.businessStoreModel;

        _b2bOrderModel!.status = AppConfig.b2bOrderStatusData[5]["id"];
        updatedOrderStatus = AppConfig.b2bOrderStatusData[5]["id"];
        setState(() {});
        SuccessDialog.show(
          context,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "Delivery started.",
        );
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"],
          isTryButton: true,
          callBack: () {
            _deliveryReadyCallback();
          },
        );
      }
    });
  }

  void _deliveryDoneCallback() async {
    OrderStatusDialog.show(
      context,
      title: "Order Deliverd",
      content:
          "Are you sure you received the order delivered? When you mark it received the other store will be notified that you received the order.",
      callback: () async {
        B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(_b2bOrderModel!);

        await _keicyProgressDialog!.show();
        var result = await _b2bOrderProvider!.updateOrderData(
          b2bOrderModel: newb2bOrderModel,
          status: AppConfig.b2bOrderStatusData[6]["id"],
          changedStatus: false,
          from: "received",
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _b2bOrderModel = B2BOrderModel.fromJson(result["data"]);
          _b2bOrderModel!.myStoreModel = newb2bOrderModel.myStoreModel;
          _b2bOrderModel!.businessStoreModel = newb2bOrderModel.businessStoreModel;

          _b2bOrderModel!.status = AppConfig.b2bOrderStatusData[6]["id"];
          updatedOrderStatus = AppConfig.b2bOrderStatusData[6]["id"];
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "Delivery completed.",
          );
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: result["message"],
            isTryButton: true,
            callBack: () {
              _deliveryReadyCallback();
            },
          );
        }
      },
    );
  }

  void _completeCallback() async {
    B2BOrderModel newb2bOrderModel = B2BOrderModel.copy(_b2bOrderModel!);

    await _keicyProgressDialog!.show();
    var result = await _b2bOrderProvider!.updateOrderData(
      b2bOrderModel: newb2bOrderModel,
      status: AppConfig.b2bOrderStatusData[7]["id"],
      changedStatus: false,
      from: "sent",
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _b2bOrderModel = B2BOrderModel.fromJson(result["data"]);
      _b2bOrderModel!.myStoreModel = newb2bOrderModel.myStoreModel;
      _b2bOrderModel!.businessStoreModel = newb2bOrderModel.businessStoreModel;

      _b2bOrderModel!.status = AppConfig.b2bOrderStatusData[7]["id"];
      updatedOrderStatus = AppConfig.b2bOrderStatusData[7]["id"];
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Delivery completed.",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        isTryButton: true,
        callBack: () {
          _deliveryReadyCallback();
        },
      );
    }
  }
}
