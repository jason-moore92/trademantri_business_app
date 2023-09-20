import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/qr_code_widget.dart';
import 'package:trapp/src/elements/user_info_panel.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/helpers/price_functions1.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class BargainRequestDetailView extends StatefulWidget {
  final BargainRequestModel? bargainRequestModel;

  BargainRequestDetailView({
    Key? key,
    this.bargainRequestModel,
  }) : super(key: key);

  @override
  _BargainRequestDetailViewState createState() => _BargainRequestDetailViewState();
}

class _BargainRequestDetailViewState extends State<BargainRequestDetailView> {
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

  String? updatedOrderStatus;

  BargainRequestModel? _bargainRequestModel;

  double? originPrice;

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

    _authProvider = AuthProvider.of(context);
    _bargainRequestProvider = BargainRequestProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _bargainRequestModel = BargainRequestModel.copy(widget.bargainRequestModel!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop(updatedOrderStatus);
          },
        ),
        title: Text("Bargain Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
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
    PriceFunctions1.calculateDiscount(orderModel: OrderModel.fromJson(_bargainRequestModel!.toJson()));

    String bargainRequestStatus = "";
    if (_bargainRequestModel!.status != _bargainRequestModel!.subStatus) {
      for (var i = 0; i < AppConfig.bargainSubStatusData.length; i++) {
        if (AppConfig.bargainSubStatusData[i]["id"] == _bargainRequestModel!.subStatus) {
          bargainRequestStatus = AppConfig.bargainSubStatusData[i]["name"];
          break;
        }
      }
    } else {
      for (var i = 0; i < AppConfig.bargainRequestStatusData.length; i++) {
        if (AppConfig.bargainRequestStatusData[i]["id"] == _bargainRequestModel!.status) {
          bargainRequestStatus = AppConfig.bargainRequestStatusData[i]["name"];
          break;
        }
      }
    }

    if (_bargainRequestModel!.products!.isNotEmpty && _bargainRequestModel!.products![0].productModel!.price != 0) {
      originPrice = _bargainRequestModel!.products![0].productModel!.price! -
          (_bargainRequestModel!.products![0].productModel!.discount != null ? _bargainRequestModel!.products![0].productModel!.discount! : 0);
    } else if (_bargainRequestModel!.services!.isNotEmpty && _bargainRequestModel!.services![0].serviceModel!.price != 0) {
      originPrice = _bargainRequestModel!.services![0].serviceModel!.price! -
          (_bargainRequestModel!.services![0].serviceModel!.discount != null ? _bargainRequestModel!.services![0].serviceModel!.discount! : 0);
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
                "${_bargainRequestModel!.bargainRequestId}",
                style: TextStyle(fontSize: fontSp * 23, color: Colors.black),
              ),

              ///
              SizedBox(height: heightDp * 5),
              QrCodeWidget(
                code: Encrypt.encryptString(
                  "BargainRequest_${_bargainRequestModel!.bargainRequestId}"
                  "_StoreId-${_bargainRequestModel!.storeModel!.id}"
                  "_UserId-${_bargainRequestModel!.userModel!.id}",
                ),
                size: heightDp * 150,
              ),

              SizedBox(height: heightDp * 15),
              UserInfoPanel(userModel: _bargainRequestModel!.userModel),

              ///
              SizedBox(height: heightDp * 15),
              CartListPanel(
                bargainRequestModel: _bargainRequestModel,
                updateQuantityCallback: () {
                  NormalAskDialog.show(
                    context,
                    title: "Update Quantity",
                    content: "Do you really want to update the quantity selected by User",
                    callback: () {
                      UpdateQuantityDialog.show(
                        context,
                        quantity: _bargainRequestModel!.products!.isNotEmpty
                            ? _bargainRequestModel!.products![0].orderQuantity!.toInt()
                            : _bargainRequestModel!.services![0].orderQuantity!.toInt(),
                        widthDp: widthDp,
                        heightDp: heightDp,
                        fontSp: fontSp,
                        callBack: (newQuantity) {
                          _updateQuantityCallback(BargainRequestModel.copy(_bargainRequestModel!), newQuantity);
                        },
                      );
                    },
                  );
                },
                refreshCallback: () {
                  setState(() {});
                },
              ),
              Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

              SizedBox(height: heightDp * 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bargain Request Status:   ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    bargainRequestStatus,
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),

              ///
              SizedBox(height: heightDp * 15),
              Text("Offer Price Per Quantity", style: TextStyle(fontSize: fontSp * 26, color: Colors.black)),
              SizedBox(height: heightDp * 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Upto",
                    style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                  ),
                  SizedBox(width: widthDp * 30),
                  Text(
                    "₹ ${_bargainRequestModel!.offerPrice}",
                    style: TextStyle(fontSize: fontSp * 33, color: Colors.black),
                  ),
                  SizedBox(width: widthDp * 30),
                  Text(
                    "Upto",
                    style: TextStyle(fontSize: fontSp * 20, color: Colors.transparent),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 15),
              Padding(
                padding: EdgeInsets.symmetric(vertical: heightDp * 10),
                child: Text(
                  "User is looking for "
                  "${_bargainRequestModel!.products!.isNotEmpty ? 'product' : 'service'}"
                  " ranging from 1 to "
                  "${_bargainRequestModel!.offerPrice}"
                  ". Please provide your "
                  "${_bargainRequestModel!.products!.isNotEmpty ? 'product' : 'service'}"
                  " at better offer price",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: heightDp * 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Original Price", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
                      SizedBox(height: heightDp * 5),
                      Text(
                        originPrice == null ? "" : "₹ $originPrice",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Redution Price", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
                      SizedBox(height: heightDp * 5),
                      Text(
                        originPrice == null ? "" : "₹ ${originPrice! - double.parse(_bargainRequestModel!.offerPrice.toString())}",
                        style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),

              if (originPrice != null && originPrice != 0 && originPrice! < double.parse(_bargainRequestModel!.offerPrice.toString()))
                Padding(
                  padding: EdgeInsets.symmetric(vertical: heightDp * 10),
                  child: Text(
                    "your original price is less than user offer price",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              if (originPrice == null || originPrice == 0)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: heightDp * 10),
                  child: Text(
                    "Please enther a original price",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              ///
              SizedBox(height: heightDp * 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bargain Date:  ", style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500)),
                  Text(
                    KeicyDateTime.convertDateTimeToDateString(
                      dateTime: _bargainRequestModel!.bargainDateTime,
                      formats: 'Y-m-d h:i A',
                      isUTC: false,
                    ),
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ],
              ),

              ///
              SizedBox(height: heightDp * 20),
              AppConfig.bargainRequestStatusData[1]["id"] == _bargainRequestModel!.status ? _userOfferButtonGroup() : SizedBox(),

              ///
              SizedBox(height: heightDp * 10),
              Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

              ///
              SizedBox(height: heightDp * 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Messages", style: TextStyle(fontSize: fontSp * 20, color: Colors.black)),
                  if (_bargainRequestModel!.status == AppConfig.bargainRequestStatusData[3]["id"] ||
                      _bargainRequestModel!.status == AppConfig.bargainRequestStatusData[4]["id"] ||
                      _bargainRequestModel!.status == AppConfig.bargainRequestStatusData[5]["id"] ||
                      _bargainRequestModel!.status == AppConfig.bargainRequestStatusData[6]["id"])
                    SizedBox()
                  else
                    KeicyRaisedButton(
                      width: widthDp * 120,
                      height: heightDp * 35,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 6,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Text("New message", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                      onPressed: () {
                        NewMessageDialog.show(
                          context,
                          widthDp: widthDp,
                          heightDp: heightDp,
                          fontSp: fontSp,
                          callBack: (messsage) {
                            _newMessageCallback(BargainRequestModel.copy(_bargainRequestModel!), messsage);
                          },
                        );
                      },
                    ),
                ],
              ),
              SizedBox(height: heightDp * 20),
              Column(
                children: List.generate(_bargainRequestModel!.messages!.length, (index) {
                  return Row(
                    mainAxisAlignment: _bargainRequestModel!.messages![index]["senderId"] == _bargainRequestModel!.storeModel!.id
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: _bargainRequestModel!.messages![index]["senderId"] == _bargainRequestModel!.userModel!.id
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: widthDp * 150),
                            margin: EdgeInsets.symmetric(vertical: heightDp * 7),
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
                            decoration: BoxDecoration(
                              color: _bargainRequestModel!.messages![index]["senderId"] == _bargainRequestModel!.userModel!.id
                                  ? config.Colors().mainColor(0.4)
                                  : Colors.grey.withOpacity(0.4),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  _bargainRequestModel!.messages![index]["senderId"] == _bargainRequestModel!.userModel!.id ? 0 : heightDp * 6,
                                ),
                                topRight: Radius.circular(
                                  _bargainRequestModel!.messages![index]["senderId"] != _bargainRequestModel!.userModel!.id ? 0 : heightDp * 6,
                                ),
                                bottomLeft: Radius.circular(heightDp * 6),
                                bottomRight: Radius.circular(heightDp * 6),
                              ),
                            ),
                            child: Text(
                              _bargainRequestModel!.messages![index]["text"],
                              style: TextStyle(fontSize: fontSp * 17, color: Colors.black),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
              ),

              ///
              SizedBox(height: heightDp * 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userOfferButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
          width: widthDp * 135,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Offer Counter",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () async {
            if (originPrice == null || originPrice == 0) {
              ErrorDialog.show(
                context,
                widthDp: widthDp,
                heightDp: heightDp,
                fontSp: fontSp,
                text: "Please enter original price",
              );
              return;
            }
            await CounterDialog.show(
              context,
              bargainRequestModel: BargainRequestModel.copy(_bargainRequestModel!),
              storeModel: _bargainRequestModel!.storeModel,
              widthDp: widthDp,
              heightDp: heightDp,
              fontSp: fontSp,
              callBack: (BargainRequestModel? newBargainRequestModel) {
                _counterOfferCallback(newBargainRequestModel);
              },
            );
          },
        ),
        KeicyRaisedButton(
          width: widthDp * 100,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Accept",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () {
            if (originPrice == null || originPrice == 0) {
              ErrorDialog.show(
                context,
                widthDp: widthDp,
                heightDp: heightDp,
                fontSp: fontSp,
                text: "Please enter original price",
              );
              return;
            }
            NormalAskDialog.show(
              context,
              title: "BargainRequest accept",
              content: "Do you want to accept this bargain request?",
              callback: () async {
                _acceptCallback(BargainRequestModel.copy(_bargainRequestModel!));
              },
            );
          },
        ),
        KeicyRaisedButton(
          width: widthDp * 100,
          height: heightDp * 35,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Reject",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              title: "BargainRequest reject",
              content: "Do you want to reject this bargain request?",
              callback: () async {
                _rejectCallback(BargainRequestModel.copy(_bargainRequestModel!));
              },
            );
          },
        ),
      ],
    );
  }

  void _newMessageCallback(BargainRequestModel newBargainRequestModel, String newMessage) async {
    newBargainRequestModel.messages!.add({
      "text": newMessage,
      "senderId": newBargainRequestModel.storeModel!.id,
      "date": DateTime.now().toUtc().toIso8601String(),
    });

    await _keicyProgressDialog!.show();
    var result = await _bargainRequestProvider!.updateBargainRequestData(
      bargainRequestModel: newBargainRequestModel,
      status: "store_new_message",
      subStatus: "store_new_message",
      storeId: _authProvider!.authState.storeModel!.id,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _bargainRequestModel = newBargainRequestModel;
      updatedOrderStatus = newBargainRequestModel.status;
      setState(() {});
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _newMessageCallback(newBargainRequestModel, newMessage);
        },
      );
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
      newBargainRequestModel.status = AppConfig.bargainRequestStatusData[5]["id"];
      newBargainRequestModel.subStatus = AppConfig.bargainRequestStatusData[5]["id"];
      updatedOrderStatus = AppConfig.bargainRequestStatusData[5]["id"];
      _bargainRequestModel = newBargainRequestModel;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "This BargainRequest is rejected",
      );
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
      newBargainRequestModel.status = AppConfig.bargainRequestStatusData[3]["id"];
      newBargainRequestModel.subStatus = AppConfig.bargainRequestStatusData[3]["id"];
      updatedOrderStatus = AppConfig.bargainRequestStatusData[3]["id"];
      _bargainRequestModel = newBargainRequestModel;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "This BargainRequest is accepted",
      );
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
      newBargainRequestModel.status = AppConfig.bargainRequestStatusData[2]["id"];
      newBargainRequestModel.subStatus = AppConfig.bargainSubStatusData[2]["id"];
      updatedOrderStatus = AppConfig.bargainRequestStatusData[2]["id"];
      _bargainRequestModel = newBargainRequestModel;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "This BargainRequest is countered offer",
      );
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

  void _updateQuantityCallback(BargainRequestModel newBargainRequestModel, int newQuantity) async {
    int? initQuantity;
    if (newBargainRequestModel.products!.isNotEmpty) {
      initQuantity = newBargainRequestModel.products![0].orderQuantity!.toInt();
      newBargainRequestModel.products![0].orderQuantity = newQuantity.toDouble();
    } else if (newBargainRequestModel.services!.isNotEmpty) {
      initQuantity = newBargainRequestModel.services![0].orderQuantity!.toInt();
      newBargainRequestModel.services![0].orderQuantity = newQuantity.toDouble();
    }

    newBargainRequestModel.history!.add({
      "title": AppConfig.bargainHistoryData["quantity_updated"]["title"],
      "text": AppConfig.bargainHistoryData["quantity_updated"]["text"]
          .replaceAll(
            'initial_value',
            initQuantity.toString(),
          )
          .replaceAll(
            'updated_value',
            newQuantity.toString(),
          ),
      "bargainType": newBargainRequestModel.status,
      "date": DateTime.now().toUtc().toIso8601String(),
      "initialPrice": newBargainRequestModel.history!.first["initialPrice"],
      "offerPrice": newBargainRequestModel.offerPrice,
    });

    await _keicyProgressDialog!.show();

    var result = await _bargainRequestProvider!.updateBargainRequestData(
      bargainRequestModel: newBargainRequestModel,
      status: "quantity_updated",
      subStatus: "quantity_updated",
      storeId: _authProvider!.authState.storeModel!.id,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      updatedOrderStatus = newBargainRequestModel.status;
      _bargainRequestModel = newBargainRequestModel;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "This BargainRequest quantity updated",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _updateQuantityCallback(newBargainRequestModel, newQuantity);
        },
      );
    }
  }
}
