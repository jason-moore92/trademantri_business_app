import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/normal_ask_dialog.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/order_model.dart';
import 'package:trapp/src/models/service_order_model.dart';

import 'keicy_avatar_image.dart';

class ServiceOrderB2BWidget extends StatefulWidget {
  final ServiceOrderModel? serviceOrderModel;
  final int? index;
  final bool? readOnly;
  final bool isAddQuantity;
  final bool? isShowReductDialog;
  final Function(String)? deleteCallback;
  final Function(ServiceOrderModel?)? refreshCallback;

  ServiceOrderB2BWidget({
    @required this.serviceOrderModel,
    @required this.readOnly,
    this.index,
    this.isAddQuantity = false,
    @required this.isShowReductDialog,
    this.deleteCallback,
    this.refreshCallback,
  });

  @override
  _ServiceOrderB2BWidgetState createState() => _ServiceOrderB2BWidgetState();
}

class _ServiceOrderB2BWidgetState extends State<ServiceOrderB2BWidget> {
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
      child: _serviceWidget(),
    );
  }

  Widget _serviceWidget() {
    return Row(
      children: [
        KeicyAvatarImage(
          url: widget.serviceOrderModel!.serviceModel!.images!.isEmpty ? "" : widget.serviceOrderModel!.serviceModel!.images![0],
          imageFile: widget.serviceOrderModel!.serviceModel!.imageFile,
          width: widthDp * 80,
          height: widthDp * 80,
          backColor: Colors.grey.withOpacity(0.4),
        ),
        SizedBox(width: widthDp * 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.serviceOrderModel!.serviceModel!.name}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              ///
              SizedBox(height: heightDp * 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${widget.serviceOrderModel!.serviceModel!.provided ?? ""}",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    ),
                  ),
                  SizedBox(width: widthDp * 5),
                  _categoryButton(),
                ],
              ),

              ///
              SizedBox(height: heightDp * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _priceWidget(),
                        if (widget.serviceOrderModel!.taxPriceAfterDiscount != 0)
                          Column(
                            children: [
                              Text(
                                "Tax: ₹ ${numFormat.format(
                                  widget.serviceOrderModel!.taxPriceAfterDiscount! * widget.serviceOrderModel!.couponQuantity!,
                                )}",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        if (widget.serviceOrderModel!.serviceModel!.realBulkOrder! &&
                            widget.serviceOrderModel!.orderQuantity! >= widget.serviceOrderModel!.serviceModel!.minQuantityForBulkOrder!)
                          Text(
                            "* Bulk order discount applied"
                            "\nDiscount : ₹ ${widget.serviceOrderModel!.serviceModel!.discount}"
                            "\nMin bulk order items: ${widget.serviceOrderModel!.serviceModel!.minQuantityForBulkOrder} ",
                            style: TextStyle(fontSize: fontSp * 10, color: Colors.red, fontWeight: FontWeight.w500),
                          ),
                      ],
                    ),
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
        if (widget.deleteCallback != null && !widget.readOnly!)
          GestureDetector(
            child: Icon(Icons.delete, size: heightDp * 25, color: Colors.black),
            onTap: () {
              NormalAskDialog.show(
                context,
                content: "Do you want to delete this service",
                callback: () {
                  widget.deleteCallback!(widget.serviceOrderModel!.serviceModel!.id!);
                },
              );
            },
          ),
        SizedBox(width: widthDp * 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: heightDp * 2),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  if (widget.readOnly!) return;

                  if (widget.serviceOrderModel!.couponQuantity == 1) return;

                  if (widget.isShowReductDialog!) {
                    ReduceQualityDialog.show(
                      context,
                      widthDp: widthDp,
                      heightDp: heightDp,
                      fontSp: fontSp,
                      callBack: () {
                        widget.serviceOrderModel!.couponQuantity = widget.serviceOrderModel!.couponQuantity! - 1;
                        widget.serviceOrderModel!.orderQuantity = widget.serviceOrderModel!.orderQuantity! - 1;
                        widget.refreshCallback!(widget.serviceOrderModel);
                      },
                    );
                  } else {
                    widget.serviceOrderModel!.couponQuantity = widget.serviceOrderModel!.couponQuantity! - 1;
                    widget.serviceOrderModel!.orderQuantity = widget.serviceOrderModel!.orderQuantity! - 1;
                    widget.refreshCallback!(widget.serviceOrderModel);
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 10),
                      GestureDetector(
                        child: Icon(
                          Icons.remove,
                          color: (widget.readOnly! || widget.serviceOrderModel!.couponQuantity == 1) ? Colors.grey : config.Colors().mainColor(1),
                          size: heightDp * 20,
                        ),
                      ),
                      SizedBox(width: widthDp * 5),
                    ],
                  ),
                ),
              ),
              Text(
                "${numFormat.format(widget.serviceOrderModel!.couponQuantity)}",
                style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () async {
                  if (widget.readOnly! || !widget.isAddQuantity) return;

                  widget.serviceOrderModel!.couponQuantity = widget.serviceOrderModel!.couponQuantity! + 1;
                  widget.serviceOrderModel!.orderQuantity = widget.serviceOrderModel!.orderQuantity! + 1;
                  widget.refreshCallback!(widget.serviceOrderModel);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 5),
                      GestureDetector(
                        child: Icon(
                          Icons.add,
                          color: (widget.readOnly! || !widget.isAddQuantity) ? Colors.grey : config.Colors().mainColor(1),
                          size: heightDp * 20,
                        ),
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
        if ((widget.serviceOrderModel!.serviceModel!.id == null || widget.serviceOrderModel!.serviceModel!.id.toString().contains("custom")) &&
            (widget.serviceOrderModel!.serviceModel!.price == 0))
          _addPriceButton()
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!widget.readOnly!) _editPriceButton(),
              if (widget.serviceOrderModel!.promocodeDiscount == 0 && widget.serviceOrderModel!.couponDiscount == 0)
                Text(
                  "₹ ${numFormat.format(widget.serviceOrderModel!.orderPrice! * widget.serviceOrderModel!.couponQuantity!)}",
                  style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹ ${numFormat.format(
                        (widget.serviceOrderModel!.orderPrice! -
                                widget.serviceOrderModel!.promocodeDiscount! -
                                widget.serviceOrderModel!.couponDiscount!) *
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
    if (widget.readOnly!)
      return Text(
        "Price Not Available",
        style: TextStyle(fontSize: fontSp * 14, color: Colors.red, fontWeight: FontWeight.w500),
      );
    return GestureDetector(
      onTap: () {
        ProductB2BPriceDialog.show(
          context,
          itemData: widget.serviceOrderModel!.serviceModel!.toJson(),
          quantity: widget.serviceOrderModel!.orderQuantity!.toDouble(),
          callback: (Map<String, dynamic> serviceData, double quantity) {
            widget.serviceOrderModel!.serviceModel = ServiceModel.fromJson(serviceData);
            widget.serviceOrderModel!.orderPrice = widget.serviceOrderModel!.serviceModel!.price! - widget.serviceOrderModel!.serviceModel!.discount!;
            widget.serviceOrderModel!.orderQuantity = quantity;
            widget.serviceOrderModel!.couponQuantity = quantity;
            widget.refreshCallback!(widget.serviceOrderModel);
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
        ProductB2BPriceDialog.show(
          context,
          itemData: widget.serviceOrderModel!.serviceModel!.toJson(),
          quantity: widget.serviceOrderModel!.orderQuantity!.toDouble(),
          callback: (Map<String, dynamic> serviceData, double quantity) {
            widget.serviceOrderModel!.serviceModel = ServiceModel.fromJson(serviceData);
            widget.serviceOrderModel!.orderPrice = widget.serviceOrderModel!.serviceModel!.price! - widget.serviceOrderModel!.serviceModel!.discount!;
            widget.serviceOrderModel!.orderQuantity = quantity;
            widget.serviceOrderModel!.couponQuantity = quantity;
            widget.refreshCallback!(widget.serviceOrderModel);
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
