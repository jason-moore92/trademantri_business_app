import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/maps_sheet.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/order_status_steps_widget.dart';
import 'package:trapp/src/elements/payment_detail_panel.dart';
import 'package:trapp/src/elements/pos_widget.dart';
import 'package:trapp/src/elements/print_widget.dart';
import 'package:trapp/src/elements/qr_code_widget.dart';
import 'package:trapp/src/elements/user_info_panel.dart';
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

class OrderDetailNewView extends StatefulWidget {
  OrderModel? orderModel;

  OrderDetailNewView({Key? key, this.orderModel}) : super(key: key);

  @override
  _OrderDetailNewViewState createState() => _OrderDetailNewViewState();
}

class _OrderDetailNewViewState extends State<OrderDetailNewView> {
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

  OrderModel? _orderModel;

  String? updatedOrderStatus;

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

    _orderModel = OrderModel.copy(widget.orderModel!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PriceFunctions1.calculateDiscount(orderModel: _orderModel);
    _orderModel!.paymentDetail = PriceFunctions1.calclatePaymentDetail(orderModel: _orderModel);

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
        title: Text("Order Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
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
    for (var i = 0; i < AppConfig.orderStatusData.length; i++) {
      if (_orderModel!.status == AppConfig.orderStatusData[i]["id"]) {
        orderStatus = AppConfig.orderStatusData[i]["name"];
        break;
      }
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Text(
                "${_orderModel!.orderId}",
                style: TextStyle(fontSize: fontSp * 21, color: Colors.black),
              ),
            ),

            ///
            SizedBox(height: heightDp * 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: QrCodeWidget(
                code: Encrypt.encryptString(
                    "Order_${_orderModel!.orderId}_StoreId-${_orderModel!.storeModel!.id}_UserId-${_orderModel!.userModel!.id}"),
                size: heightDp * 150,
              ),
            ),

            ///
            SizedBox(height: heightDp * 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (await canLaunch(_orderModel!.invoicePdfUrlForStore ?? _orderModel!.invoicePdfUrl!)) {
                        await launch(
                          _orderModel!.invoicePdfUrlForStore ?? _orderModel!.invoicePdfUrl!,
                          forceSafariVC: false,
                          forceWebView: false,
                        );
                      } else {
                        throw 'Could not launch ${_orderModel!.invoicePdfUrlForStore ?? _orderModel!.invoicePdfUrl}';
                      }
                    },
                    child: Image.asset("img/pdf-icon.png", width: heightDp * 30, height: heightDp * 30, fit: BoxFit.cover),
                  ),
                  SizedBox(width: widthDp * 30),
                  GestureDetector(
                    onTap: () {
                      Share.share(_orderModel!.invoicePdfUrlForStore ?? _orderModel!.invoicePdfUrl!);
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
                    path: _orderModel!.invoicePdfUrl,
                    size: heightDp * 40,
                    color: config.Colors().mainColor(1),
                  ),
                  // SizedBox(width: widthDp * 30),
                  // POSWidget(
                  //   path: _orderModel!.invoicePdfUrl,
                  //   size: heightDp * 40,
                  //   color: config.Colors().mainColor(1),
                  // ),
                ],
              ),
            ),

            if (_orderModel!.orderHistorySteps!.isNotEmpty || _orderModel!.orderFutureSteps!.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: heightDp * 15),
                  OrderStatusStepsWidget(orderModel: _orderModel),
                ],
              ),

            ///
            SizedBox(height: heightDp * 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: UserInfoPanel(userModel: _orderModel!.userModel),
            ),

            ///
            SizedBox(height: heightDp * 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: CartListPanel(
                orderModel: OrderModel.copy(_orderModel!),
                refreshCallback: (OrderModel? orderModel) {
                  _orderModel = orderModel;
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            ),

            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Received date: ",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: _orderModel!.createdAt!,
                      formats: "Y-m-d H:i",
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            ),
            SizedBox(height: heightDp * 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Updated date: ",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: _orderModel!.updatedAt!,
                      formats: "Y-m-d H:i",
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),
            ),

            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            ),

            ///
            _orderModel!.instructions == ""
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
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
                                    "Instruction",
                                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: heightDp * 5),
                              Text(
                                _orderModel!.instructions!,
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      ],
                    ),
                  ),

            ///
            if (_orderModel!.promocode != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 10),
                    Container(
                      width: deviceWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Promo code: ",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            _orderModel!.promocode!.promocodeCode!,
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: heightDp * 10),
                    Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ],
                ),
              ),

            ///
            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Row(
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
            ),

            ///
            if (_orderModel!.status == AppConfig.orderStatusData[7]["id"] || _orderModel!.status == AppConfig.orderStatusData[8]["id"])
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _orderModel!.status == AppConfig.orderStatusData[7]["id"] ? "Cancel Reason:" : "Reject Reason: ",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: widthDp * 10),
                        Expanded(
                          child: Text(
                            "${_orderModel!.reasonForCancelOrReject}",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
            ),

            ///
            _orderModel!.products == null || _orderModel!.products!.isEmpty
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Container(
                          width: deviceWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order Type: ",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                _orderModel!.orderType!,
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      ],
                    ),
                  ),

            ///
            _orderModel!.products!.isEmpty || _orderModel!.orderType != "Pickup" || _orderModel!.pickupDateTime == null
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Container(
                          width: deviceWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pickup Date:",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                KeicyDateTime.convertDateTimeToDateString(
                                  dateTime: _orderModel!.pickupDateTime,
                                  formats: 'Y-m-d h:i A',
                                  isUTC: false,
                                ),
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      ],
                    ),
                  ),

            ///
            _orderModel!.products!.isEmpty || _orderModel!.orderType != "Delivery" || _orderModel!.deliveryAddress == null
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Container(
                          width: deviceWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Address:",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: heightDp * 5),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${_orderModel!.deliveryAddress!.addressType}",
                                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(width: widthDp * 10),
                                            Text(
                                              "${(_orderModel!.deliveryAddress!.distance! / 1000).toStringAsFixed(3)} Km",
                                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: heightDp * 5),
                                        _orderModel!.deliveryAddress!.building == null || _orderModel!.deliveryAddress!.building == ""
                                            ? SizedBox()
                                            : Column(
                                                children: [
                                                  Text(
                                                    "${_orderModel!.deliveryAddress!.building}",
                                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: heightDp * 5),
                                                ],
                                              ),
                                        Text(
                                          "${_orderModel!.deliveryAddress!.address!.address}",
                                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: heightDp * 10),
                                        KeicyCheckBox(
                                          iconSize: heightDp * 25,
                                          iconColor: Color(0xFF00D18F),
                                          labelSpacing: widthDp * 20,
                                          label: "No Contact Delivery",
                                          labelStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                                          value: _orderModel!.noContactDelivery!,
                                          readOnly: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      MapsSheet.show(
                                        context: context,
                                        onMapTap: (map) {
                                          map.showMarker(
                                            coords: Coords(
                                              widget.orderModel!.deliveryAddress!.address!.location!.latitude,
                                              widget.orderModel!.deliveryAddress!.address!.location!.longitude,
                                            ),
                                            title: "Customer Address",
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(Icons.place),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      ],
                    ),
                  ),

            ///
            _orderModel!.services!.isEmpty || _orderModel!.serviceDateTime == null
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Container(
                          width: deviceWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Service Date:",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                KeicyDateTime.convertDateTimeToDateString(
                                  dateTime: _orderModel!.serviceDateTime,
                                  formats: 'Y-m-d h:i A',
                                  isUTC: false,
                                ),
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      ],
                    ),
                  ),

            //////
            SizedBox(height: heightDp * 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: PaymentDetailPanel(orderModel: _orderModel, padding: EdgeInsets.zero),
            ),
            SizedBox(height: heightDp * 20),

            ///
            if (_orderModel!.status == AppConfig.orderStatusData[1]["id"])
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _placeOrderButtonGroup(),
              )
            else if (_orderModel!.status == AppConfig.orderStatusData[2]["id"])
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _acceptedOrderButtonGroup(),
              )
            else if (_orderModel!.status == AppConfig.orderStatusData[3]["id"])
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _paidOrderButtonGroup(),
              )
            else if (_orderModel!.status == AppConfig.orderStatusData[4]["id"] || _orderModel!.status == AppConfig.orderStatusData[5]["id"])
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: _pickupCompleteButtonGroup(),
              ),

            ///
            SizedBox(height: heightDp * 20),
          ],
        ),
      ),
    );
  }

  Widget _placeOrderButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp * 100,
          height: heightDp * 30,
          color: _orderModel!.products!.isEmpty && _orderModel!.services!.isEmpty ? Colors.grey.withOpacity(0.6) : config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          child: Text(
            "Accept",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: _orderModel!.products!.isEmpty && _orderModel!.services!.isEmpty ? null : _acceptedCallback,
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

  Widget _acceptedOrderButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (_orderModel!.orderType != "Service")
                KeicyRaisedButton(
                  width: widthDp * 170,
                  height: heightDp * 30,
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: heightDp * 8,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  child: Text(
                    _orderModel!.orderType == "Pickup" ? "Change Pick Date" : "Change Delivery Date",
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                  ),
                  onPressed: () {
                    // OrderAcceptDialog.show(context, callback: widget.acceptCallback);
                  },
                ),
              if (_orderModel!.orderType != "Service")
                KeicyRaisedButton(
                  width: widthDp * 170,
                  height: heightDp * 30,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 8,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  child: Text(
                    _orderModel!.orderType == "Pickup" ? "Pickup Ready" : "Delivery Ready",
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                  ),
                  onPressed: () {
                    if (_orderModel!.orderType == "Pickup") {
                      _pickupReadyCallback();
                    } else {
                      _deliveryReadyCallback();
                    }
                  },
                ),
            ],
          ),
          SizedBox(height: heightDp * 10),
          (_orderModel!.payAtStore! || _orderModel!.cashOnDelivery!)
              ? KeicyRaisedButton(
                  width: widthDp * 170,
                  height: heightDp * 30,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 8,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  child: Text(
                    "Payment Done",
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                  ),
                  onPressed: _payCallback,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _paidOrderButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: heightDp * 10,
        children: [
          if (!_orderModel!.pickupDeliverySatus! && _orderModel!.orderType != "Service")
            KeicyRaisedButton(
              width: widthDp * 170,
              height: heightDp * 30,
              color: Colors.grey.withOpacity(0.5),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                _orderModel!.orderType == "Pickup" ? "Change Pick Date" : "Change Delivery Status",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                // OrderAcceptDialog.show(context, callback: widget.acceptCallback);
              },
            ),
          if (!_orderModel!.pickupDeliverySatus! && _orderModel!.orderType != "Service")
            KeicyRaisedButton(
              width: widthDp * 170,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                _orderModel!.orderType == "Pickup" ? "Pickup Ready" : "Delivery Ready",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                if (_orderModel!.orderType == "Pickup") {
                  _pickupReadyCallback();
                } else {
                  OrderStatusDialog.show(
                    context,
                    title: "Delivery is Ready",
                    content: "Is the order ready for Delivery",
                    okayButtonString: "Yes",
                    cancelButtonString: "No",
                    callback: () async {
                      if (_orderModel!.deliveryPartnerDetails == null || _orderModel!.deliveryPartnerDetails!.isEmpty) {
                        NormalDialog.show(context,
                            title: "Delivery Ready",
                            content:
                                "This order need to be delivered on your own, as your store and order is not associated with any delivery partners",
                            callback: () {
                          _deliveryReadyCallback();
                        });
                      } else {
                        _deliveryReadyCallback();
                      }
                    },
                  );
                }
              },
            ),
          KeicyRaisedButton(
            width: widthDp * 170,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Order Complete",
              style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
            ),
            onPressed: _completeCallback,
          ),
        ],
      ),
    );
  }

  Widget _pickupCompleteButtonGroup() {
    return Wrap(
      children: [
        if (_orderModel!.payStatus!)
          KeicyRaisedButton(
            width: widthDp * 170,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              _orderModel!.orderType == "Pickup" ? "Pickup Order Complete" : "Delivery Order Complete",
              style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
            ),
            onPressed: _completeCallback,
          ),
        if (!_orderModel!.payStatus! && (_orderModel!.payAtStore! || _orderModel!.cashOnDelivery!))
          KeicyRaisedButton(
            width: widthDp * 170,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Payment Done",
              style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
            ),
            onPressed: _payCallback,
          )
      ],
    );
  }

  void _acceptedCallback() async {
    bool isAvaiable = true;
    for (var i = 0; i < _orderModel!.products!.length; i++) {
      if (_orderModel!.products![i].productModel!.price == 0) {
        isAvaiable = false;
      }
    }

    for (var i = 0; i < _orderModel!.services!.length; i++) {
      if (_orderModel!.services![i].serviceModel!.price == 0) {
        isAvaiable = false;
      }
    }
    if (!isAvaiable) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "You have to change order based on the products and services available at store",
      );
      return;
    }

    OrderStatusDialog.show(
      context,
      title: "Order Accept",
      content: "Do you want to accept the order. User will be notified with it.",
      callback: () async {
        bool changedStatus = false;

        if (_orderModel!.products!.length != widget.orderModel!.products!.length) {
          changedStatus = true;
        }
        if (_orderModel!.services!.length != widget.orderModel!.services!.length) {
          changedStatus = true;
        }
        if (_orderModel!.bogoProducts!.length != widget.orderModel!.bogoProducts!.length) {
          changedStatus = true;
        }
        if (_orderModel!.bogoServices!.length != widget.orderModel!.bogoServices!.length) {
          changedStatus = true;
        }
        if (changedStatus == false) {
          for (var i = 0; i < _orderModel!.products!.length; i++) {
            ProductOrderModel oldOrderModel = widget.orderModel!.products![i];
            ProductOrderModel newOrderModel = _orderModel!.products![i];
            DiffNode diff = JsonDiffer.fromJson(oldOrderModel.toJson(), newOrderModel.toJson()).diff();
            if (!diff.hasNothing) {
              changedStatus = true;
              break;
            }
          }
        }
        if (changedStatus == false) {
          for (var i = 0; i < _orderModel!.services!.length; i++) {
            ServiceOrderModel oldOrderModel = widget.orderModel!.services![i];
            ServiceOrderModel newOrderModel = _orderModel!.services![i];
            DiffNode diff = JsonDiffer.fromJson(oldOrderModel.toJson(), newOrderModel.toJson()).diff();
            if (!diff.hasNothing) {
              changedStatus = true;
              break;
            }
          }
        }
        if (changedStatus == false) {
          for (var i = 0; i < _orderModel!.bogoProducts!.length; i++) {
            ProductOrderModel oldOrderModel = widget.orderModel!.products![i];
            ProductOrderModel newOrderModel = _orderModel!.products![i];
            DiffNode diff = JsonDiffer.fromJson(oldOrderModel.toJson(), newOrderModel.toJson()).diff();
            if (!diff.hasNothing) {
              changedStatus = true;
              break;
            }
          }
        }
        if (changedStatus == false) {
          for (var i = 0; i < _orderModel!.bogoServices!.length; i++) {
            ServiceOrderModel oldOrderModel = widget.orderModel!.services![i];
            ServiceOrderModel newOrderModel = _orderModel!.services![i];
            DiffNode diff = JsonDiffer.fromJson(oldOrderModel.toJson(), newOrderModel.toJson()).diff();
            if (!diff.hasNothing) {
              changedStatus = true;
              break;
            }
          }
        }

        await _keicyProgressDialog!.show();
        var result = await _orderProvider!.updateOrderData(
          orderModel: _orderModel,
          status: AppConfig.orderStatusData[2]["id"],
          changedStatus: changedStatus,
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _orderModel = OrderModel.fromJson(result["data"]);
          _orderModel!.userModel = widget.orderModel!.userModel;
          _orderModel!.storeModel = widget.orderModel!.storeModel;

          _orderModel!.status = AppConfig.orderStatusData[2]["id"];
          updatedOrderStatus = AppConfig.orderStatusData[2]["id"];
          setState(() {});

          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The order is accepted",
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
              _acceptedCallback();
            },
          );
        }
      },
    );
  }

  void _rejectCallback() async {
    OrderRejectDialog.show(
      context,
      title: "Order Reject",
      content: "Do you really want to reject the order. User will be notified with the rejection. Do you want to proceed.",
      callback: (reason) async {
        Map<String, dynamic> newOrderData = _orderModel!.toJson(); //
        newOrderData["reasonForCancelOrReject"] = reason;
        await _keicyProgressDialog!.show();
        // var result = await _orderProvider!.changeOrderStatus1(
        //   storeId: AuthProvider.of(context).authState.storeModel!.id,
        //   orderId: _orderModel!["_id"],
        //   userId: _orderModel!["userId"],
        //   status: AppConfig.orderStatusData[8]["id"],
        //   token: AuthProvider.of(context).authState.userData!["token"],
        // );
        var result = await _orderProvider!.updateOrderData(
          orderModel: OrderModel.fromJson(newOrderData),
          status: AppConfig.orderStatusData[8]["id"],
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _orderModel = OrderModel.fromJson(result["data"]);
          _orderModel!.userModel = widget.orderModel!.userModel;
          _orderModel!.storeModel = widget.orderModel!.storeModel;

          _orderModel!.status = AppConfig.orderStatusData[8]["id"];
          updatedOrderStatus = AppConfig.orderStatusData[8]["id"];
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

  void _pickupReadyCallback() async {
    OrderStatusDialog.show(
      context,
      title: "Pickup is Ready",
      content: "Is the order ready for Pickup",
      okayButtonString: "Yes",
      cancelButtonString: "No",
      callback: () async {
        await _keicyProgressDialog!.show();
        var result = await _orderProvider!.updateOrderData(
          orderModel: _orderModel,
          status: AppConfig.orderStatusData[4]["id"],
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _orderModel = OrderModel.fromJson(result["data"]);
          _orderModel!.userModel = widget.orderModel!.userModel;
          _orderModel!.storeModel = widget.orderModel!.storeModel;
          _orderModel!.status = AppConfig.orderStatusData[4]["id"];
          updatedOrderStatus = AppConfig.orderStatusData[4]["id"];
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The order is pickup ready",
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
    await _keicyProgressDialog!.show();
    var result = await _orderProvider!.updateOrderData(
      orderModel: _orderModel,
      status: AppConfig.orderStatusData[5]["id"],
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _orderModel = OrderModel.fromJson(result["data"]);
      _orderModel!.userModel = widget.orderModel!.userModel;
      _orderModel!.storeModel = widget.orderModel!.storeModel;
      _orderModel!.status = AppConfig.orderStatusData[5]["id"];
      updatedOrderStatus = AppConfig.orderStatusData[5]["id"];
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "The order is delivery ready",
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

  void _payCallback() async {
    OrderStatusDialog.show(
      context,
      title: "Order Paid",
      content: "Are you sure the order has been paid",
      callback: () async {
        await _keicyProgressDialog!.show();
        var result = await _orderProvider!.updateOrderData(
          orderModel: _orderModel,
          status: AppConfig.orderStatusData[3]["id"],
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _orderModel = OrderModel.fromJson(result["data"]);
          _orderModel!.userModel = widget.orderModel!.userModel;
          _orderModel!.storeModel = widget.orderModel!.storeModel;
          _orderModel!.status = AppConfig.orderStatusData[3]["id"];
          updatedOrderStatus = AppConfig.orderStatusData[3]["id"];
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The order is paid",
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
              _payCallback();
            },
          );
        }
      },
    );
  }

  void _completeCallback() async {
    OrderStatusDialog.show(
      context,
      title: "Order Complete",
      content: "Are you sure you want to complete this order",
      callback: () async {
        await _keicyProgressDialog!.show();
        var result = await _orderProvider!.updateOrderData(
          orderModel: _orderModel,
          status: AppConfig.orderStatusData[9]["id"],
        );
        await _keicyProgressDialog!.hide();
        if (result["success"]) {
          _orderModel = OrderModel.fromJson(result["data"]);
          _orderModel!.userModel = widget.orderModel!.userModel;
          _orderModel!.storeModel = widget.orderModel!.storeModel;
          _orderModel!.status = AppConfig.orderStatusData[9]["id"];
          updatedOrderStatus = AppConfig.orderStatusData[9]["id"];
          setState(() {});
          SuccessDialog.show(
            context,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "The order is Complete",
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
}
