import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/normal_ask_dialog.dart';
import 'package:trapp/src/helpers/price_functions.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/PurchaseProductItemDetailPage/index.dart';

import 'keicy_avatar_image.dart';

class ServicePurchaseWidget extends StatefulWidget {
  final PurchaseModel? purchaseModel;
  final PurchaseItemModel? purchaseItemModel;
  final int? index;
  final Function(String, int)? deleteCallback;
  final Function(PurchaseItemModel?, int)? refreshCallback;
  final bool isReadOnly;
  final bool showStatus;
  final bool isAddable;
  final double maxAmount;

  ServicePurchaseWidget({
    @required this.purchaseModel,
    @required this.purchaseItemModel,
    @required this.index,
    this.deleteCallback,
    this.refreshCallback,
    this.isReadOnly = false,
    this.showStatus = false,
    this.isAddable = true,
    this.maxAmount = 0,
  });

  @override
  _ServicePurchaseWidgetState createState() => _ServicePurchaseWidgetState();
}

class _ServicePurchaseWidgetState extends State<ServicePurchaseWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  PurchaseItemModel? _purchaseItemModel;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////
    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    _purchaseItemModel = PurchaseItemModel.copy(widget.purchaseItemModel!);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 0, vertical: heightDp * 5),
      child: _serviceWidget(),
    );
  }

  Widget _serviceWidget() {
    return Row(
      children: [
        KeicyAvatarImage(
          url: (widget.purchaseModel!.servicesData![_purchaseItemModel!.productId]!.images!.isEmpty)
              ? ""
              : widget.purchaseModel!.servicesData![_purchaseItemModel!.productId]!.images![0],
          imageFile: widget.purchaseModel!.servicesData![_purchaseItemModel!.productId]!.imageFile,
          width: widthDp * 80,
          height: widthDp * 80,
          backColor: Colors.grey.withOpacity(0.4),
        ),
        SizedBox(width: widthDp * 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${widget.purchaseModel!.servicesData![_purchaseItemModel!.productId]!.name}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.showStatus)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 8, vertical: heightDp * 3),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(heightDp * 6),
                      ),
                      child: Text(
                        "${_purchaseItemModel!.status}",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(width: widthDp * 5),
              Column(
                children: [
                  SizedBox(height: heightDp * 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: (widget.purchaseModel!.servicesData![_purchaseItemModel!.productId]!.provided == null)
                            ? SizedBox()
                            : Text(
                                "${widget.purchaseModel!.servicesData![_purchaseItemModel!.productId]!.provided ?? ""}",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              ),
                      ),
                      SizedBox(width: widthDp * 5),
                      _categoryButton(),
                    ],
                  ),
                ],
              ),
              SizedBox(height: heightDp * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _priceWidget(),
                  ),
                  SizedBox(width: widthDp * 5),
                  _addMoreServiceButton(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(heightDp * 20),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        "Service",
        style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
      ),
    );
  }

  Widget _addMoreServiceButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!widget.isReadOnly)
          GestureDetector(
            child: Icon(Icons.delete, size: heightDp * 25, color: Colors.black),
            onTap: () {
              NormalAskDialog.show(
                context,
                content: "Do you want to delete this service",
                callback: () {
                  widget.deleteCallback!(_purchaseItemModel!.productId!, widget.index!);
                },
              );
            },
          ),
        SizedBox(width: widthDp * 5),
        Container(
          // width: widthDp * 100,
          padding: EdgeInsets.symmetric(vertical: heightDp * 2),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  if (widget.isReadOnly) return;
                  if (_purchaseItemModel!.quantity == 1) return;

                  _purchaseItemModel!.quantity = _purchaseItemModel!.quantity! - 1;

                  if (!_purchaseItemModel!.acceptBulkOrder! || _purchaseItemModel!.quantity! >= _purchaseItemModel!.minQuantityForBulkOrder!) {
                    _purchaseItemModel!.itemPrice = _purchaseItemModel!.price! - _purchaseItemModel!.discount!;
                  } else {
                    _purchaseItemModel!.itemPrice = _purchaseItemModel!.price;
                  }

                  if (_purchaseItemModel!.taxType == AppConfig.taxTypes.first["value"]) {
                    _purchaseItemModel!.taxPrice =
                        (_purchaseItemModel!.itemPrice! * _purchaseItemModel!.taxPercentage!) / (100 + _purchaseItemModel!.taxPercentage!);
                    _purchaseItemModel!.itemPrice = _purchaseItemModel!.itemPrice! - _purchaseItemModel!.taxPrice!;
                    _purchaseItemModel!.orderPrice = _purchaseItemModel!.itemPrice! + _purchaseItemModel!.taxPrice!;
                  } else if (_purchaseItemModel!.taxType == AppConfig.taxTypes.last["value"]) {
                    _purchaseItemModel!.taxPrice = (_purchaseItemModel!.itemPrice! * _purchaseItemModel!.taxPercentage!) / (100);
                    _purchaseItemModel!.orderPrice = _purchaseItemModel!.itemPrice! + _purchaseItemModel!.taxPrice!;
                  } else {
                    _purchaseItemModel!.orderPrice = _purchaseItemModel!.itemPrice!;
                  }

                  widget.refreshCallback!(_purchaseItemModel, widget.index!);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 10),
                      GestureDetector(
                        child: Icon(
                          Icons.remove,
                          color: (widget.isReadOnly || _purchaseItemModel!.quantity == 1) ? Colors.grey : config.Colors().mainColor(1),
                          size: heightDp * 20,
                        ),
                      ),
                      SizedBox(width: widthDp * 5),
                    ],
                  ),
                ),
              ),
              Text(
                "${numFormat.format(_purchaseItemModel!.quantity)}",
                style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () async {
                  if ((!widget.isAddable && _purchaseItemModel!.quantity! >= widget.maxAmount) || widget.isReadOnly) return;
                  _purchaseItemModel!.quantity = _purchaseItemModel!.quantity! + 1;

                  if (!_purchaseItemModel!.acceptBulkOrder! || _purchaseItemModel!.quantity! >= _purchaseItemModel!.minQuantityForBulkOrder!) {
                    _purchaseItemModel!.itemPrice = _purchaseItemModel!.price! - _purchaseItemModel!.discount!;
                  } else {
                    _purchaseItemModel!.itemPrice = _purchaseItemModel!.price;
                  }

                  if (_purchaseItemModel!.taxType == AppConfig.taxTypes.first["value"]) {
                    _purchaseItemModel!.taxPrice =
                        (_purchaseItemModel!.itemPrice! * _purchaseItemModel!.taxPercentage!) / (100 + _purchaseItemModel!.taxPercentage!);
                    _purchaseItemModel!.itemPrice = _purchaseItemModel!.itemPrice! - _purchaseItemModel!.taxPrice!;
                    _purchaseItemModel!.orderPrice = _purchaseItemModel!.itemPrice! + _purchaseItemModel!.taxPrice!;
                  } else if (_purchaseItemModel!.taxType == AppConfig.taxTypes.last["value"]) {
                    _purchaseItemModel!.taxPrice = (_purchaseItemModel!.itemPrice! * _purchaseItemModel!.taxPercentage!) / (100);
                    _purchaseItemModel!.orderPrice = _purchaseItemModel!.itemPrice! + _purchaseItemModel!.taxPrice!;
                  } else {
                    _purchaseItemModel!.orderPrice = _purchaseItemModel!.itemPrice!;
                  }

                  widget.refreshCallback!(_purchaseItemModel, widget.index!);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 5),
                      GestureDetector(
                        child: Icon(Icons.add,
                            color: (!widget.isAddable && _purchaseItemModel!.quantity! >= widget.maxAmount) || widget.isReadOnly
                                ? Colors.grey
                                : config.Colors().mainColor(1),
                            size: heightDp * 20),
                      ),
                      SizedBox(width: widthDp * 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (!widget.isReadOnly) _editPriceButton(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹ ${numFormat.format(_purchaseItemModel!.orderPrice! * _purchaseItemModel!.quantity!)}",
                  style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                ),
                if (_purchaseItemModel!.taxPrice != 0)
                  Column(
                    children: [
                      Text(
                        "Tax: ₹ ${numFormat.format(
                          _purchaseItemModel!.taxPrice! * _purchaseItemModel!.quantity!,
                        )}",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        if (_purchaseItemModel!.acceptBulkOrder! && _purchaseItemModel!.quantity! >= _purchaseItemModel!.minQuantityForBulkOrder!)
          Text(
            "* Bulk order discount applied\nDiscount : ₹ ${_purchaseItemModel!.discount}\nMinimum bulk order items: ${_purchaseItemModel!.minQuantityForBulkOrder} ",
            style: TextStyle(fontSize: fontSp * 10, color: Colors.red, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }

  Widget _editPriceButton() {
    return GestureDetector(
      onTap: () async {
        var purchaseItemModel = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => PurchaseProductItemDetailPage(
              category: "services",
              purchaseModel: widget.purchaseModel,
              purchaseItemModel: _purchaseItemModel,
            ),
          ),
        );

        if (purchaseItemModel != null) {
          _purchaseItemModel = purchaseItemModel;
          widget.refreshCallback!(_purchaseItemModel, widget.index!);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: widthDp * 10),
        child: Icon(Icons.edit, size: heightDp * 20),
      ),
    );
  }
}
