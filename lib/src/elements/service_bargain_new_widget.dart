import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/product_purchase_price_dialog.dart';
import 'package:trapp/src/helpers/price_functions.dart';
import 'package:trapp/src/models/index.dart';

import 'keicy_avatar_image.dart';

class ServiceBargainNewWidget extends StatefulWidget {
  final ServiceOrderModel? serviceOrderModel;
  final BargainRequestModel? bargainRequestModel;
  final int? index;
  final Function? updateQuantityCallback;
  final Function()? refreshCallback;

  ServiceBargainNewWidget({
    @required this.serviceOrderModel,
    @required this.bargainRequestModel,
    this.index,
    @required this.updateQuantityCallback,
    @required this.refreshCallback,
  });

  @override
  _ServiceBargainWidgetState createState() => _ServiceBargainWidgetState();
}

class _ServiceBargainWidgetState extends State<ServiceBargainNewWidget> {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 0, vertical: heightDp * 5),
      child: _productWidget(),
    );
  }

  Widget _productWidget() {
    return Row(
      children: [
        KeicyAvatarImage(
          url: (widget.serviceOrderModel!.serviceModel!.images!.isEmpty) ? "" : widget.serviceOrderModel!.serviceModel!.images![0],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${widget.serviceOrderModel!.serviceModel!.name}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: widthDp * 5),
                  _priceWidget(),
                ],
              ),
              (widget.serviceOrderModel!.taxPriceAfterDiscount == 0 && widget.serviceOrderModel!.serviceModel!.provided == null)
                  ? SizedBox(height: heightDp * 5)
                  : Column(
                      children: [
                        SizedBox(height: heightDp * 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: widget.serviceOrderModel!.serviceModel!.provided == null
                                  ? SizedBox()
                                  : Text(
                                      "${widget.serviceOrderModel!.serviceModel!.provided}",
                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    ),
                            ),
                            SizedBox(width: widthDp * 5),
                            if (widget.serviceOrderModel!.taxPriceAfterDiscount == 0)
                              Text(
                                "Tax: ₹ 0",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.transparent),
                              )
                            else
                              Column(
                                children: [
                                  Text(
                                    "Tax: ₹ ${widget.serviceOrderModel!.taxPriceAfterDiscount}",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
              SizedBox(height: heightDp * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _categoryButton(),
                      ],
                    ),
                  ),
                  SizedBox(width: widthDp * 5),
                  _addMoreProductButton(),
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

  Widget _addMoreProductButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widget.bargainRequestModel!.status == AppConfig.bargainRequestStatusData[1]["id"] ||
                widget.bargainRequestModel!.status == AppConfig.bargainRequestStatusData[2]["id"]
            ? GestureDetector(
                onTap: () {
                  if (widget.updateQuantityCallback != null) widget.updateQuantityCallback!();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
                  color: Colors.transparent,
                  child: Icon(Icons.edit, size: heightDp * 20, color: Colors.black),
                ),
              )
            : SizedBox(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                "Quantities:  ",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
              ),
              Text(
                "${widget.serviceOrderModel!.orderQuantity}",
                style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.serviceOrderModel!.serviceModel!.id == null &&
            (widget.serviceOrderModel!.serviceModel!.price == null || widget.serviceOrderModel!.serviceModel!.price == 0))
          _addPriceButton()
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.serviceOrderModel!.serviceModel!.id == null &&
                  widget.bargainRequestModel!.status == AppConfig.bargainRequestStatusData[1]["id"])
                _editPriceButton()
              else
                SizedBox(),
              widget.serviceOrderModel!.promocodeDiscount == 0 && widget.serviceOrderModel!.couponDiscount == 0
                  ? Text(
                      "₹ ${numFormat.format(widget.serviceOrderModel!.orderPrice! * widget.serviceOrderModel!.orderQuantity!)}",
                      style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹ ${numFormat.format(
                            (widget.serviceOrderModel!.orderPrice! -
                                    widget.serviceOrderModel!.couponDiscount! -
                                    widget.serviceOrderModel!.promocodeDiscount!) *
                                widget.serviceOrderModel!.couponQuantity!,
                          )}",
                          style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: widthDp * 3),
                        Text(
                          "₹ ${numFormat.format(widget.serviceOrderModel!.orderPrice! * widget.serviceOrderModel!.couponQuantity!)}",
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
      ],
    );
  }

  Widget _addPriceButton() {
    return GestureDetector(
      onTap: () {
        ProductPriceDialog.show(
          context,
          itemData: widget.serviceOrderModel!.serviceModel!.toJson(),
          callback: (Map<String, dynamic> serviceData) {
            widget.serviceOrderModel!.serviceModel = ServiceModel.fromJson(serviceData);
            widget.serviceOrderModel!.orderPrice = widget.serviceOrderModel!.serviceModel!.price! - widget.serviceOrderModel!.serviceModel!.discount!;
            widget.refreshCallback!();
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 8, vertical: heightDp * 2),
        decoration: BoxDecoration(
          color: config.Colors().mainColor(1),
          borderRadius: BorderRadius.circular(heightDp * 5),
          boxShadow: [
            BoxShadow(offset: Offset(2, 2), color: Colors.grey, blurRadius: 3),
          ],
        ),
        child: Text(
          "Add Price",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _editPriceButton() {
    return GestureDetector(
      onTap: () {
        ProductPriceDialog.show(
          context,
          itemData: widget.serviceOrderModel!.serviceModel!.toJson(),
          callback: (Map<String, dynamic> serviceData) {
            widget.serviceOrderModel!.serviceModel = ServiceModel.fromJson(serviceData);
            widget.serviceOrderModel!.orderPrice = widget.serviceOrderModel!.serviceModel!.price! - widget.serviceOrderModel!.serviceModel!.discount!;
            widget.refreshCallback!();
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: widthDp * 10),
        child: Icon(Icons.edit, size: heightDp * 20),
      ),
    );
  }
}
