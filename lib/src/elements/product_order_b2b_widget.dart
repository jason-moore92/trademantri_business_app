import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/normal_ask_dialog.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/order_model.dart';
import 'package:trapp/src/models/product_order_model.dart';

import 'keicy_avatar_image.dart';

class ProductOrderB2BWidget extends StatefulWidget {
  final ProductOrderModel? productOrderModel;
  final int? index;
  final bool? readOnly;
  final bool isAddQuantity;
  final bool? isShowReductDialog;
  final Function(String)? deleteCallback;
  final Function(ProductOrderModel?)? refreshCallback;

  ProductOrderB2BWidget({
    @required this.productOrderModel,
    @required this.readOnly,
    this.index,
    this.isAddQuantity = false,
    @required this.isShowReductDialog,
    this.deleteCallback,
    this.refreshCallback,
  });

  @override
  _ProductOrderB2BWidgetState createState() => _ProductOrderB2BWidgetState();
}

class _ProductOrderB2BWidgetState extends State<ProductOrderB2BWidget> {
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
          url: widget.productOrderModel!.productModel!.images!.isEmpty ? "" : widget.productOrderModel!.productModel!.images![0],
          imageFile: widget.productOrderModel!.productModel!.imageFile,
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
                "${widget.productOrderModel!.productModel!.name}",
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
                      "${widget.productOrderModel!.productModel!.quantity ?? ""} ${widget.productOrderModel!.productModel!.quantityType ?? ""}",
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
                        if (widget.productOrderModel!.taxPriceAfterDiscount != 0)
                          Column(
                            children: [
                              Text(
                                "Tax: ₹ ${numFormat.format(
                                  widget.productOrderModel!.taxPriceAfterDiscount! * widget.productOrderModel!.couponQuantity!,
                                )}",
                                style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        if (widget.productOrderModel!.productModel!.realBulkOrder! &&
                            widget.productOrderModel!.orderQuantity! >= widget.productOrderModel!.productModel!.minQuantityForBulkOrder!)
                          Text(
                            "* Bulk order discount applied"
                            "\nDiscount : ₹ ${widget.productOrderModel!.productModel!.discount}"
                            "\nMin bulk order items: ${widget.productOrderModel!.productModel!.minQuantityForBulkOrder} ",
                            style: TextStyle(fontSize: fontSp * 10, color: Colors.red, fontWeight: FontWeight.w500),
                          ),
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
        "Product",
        style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
      ),
    );
  }

  Widget _addMoreProductButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.deleteCallback != null && !widget.readOnly!)
          GestureDetector(
            child: Icon(Icons.delete, size: heightDp * 25, color: Colors.black),
            onTap: () {
              NormalAskDialog.show(
                context,
                content: "Do you want to delete this product",
                callback: () {
                  widget.deleteCallback!(widget.productOrderModel!.productModel!.id!);
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

                  if (widget.productOrderModel!.couponQuantity == 1) return;

                  if (widget.isShowReductDialog!) {
                    ReduceQualityDialog.show(
                      context,
                      widthDp: widthDp,
                      heightDp: heightDp,
                      fontSp: fontSp,
                      callBack: () {
                        widget.productOrderModel!.couponQuantity = widget.productOrderModel!.couponQuantity! - 1;
                        widget.productOrderModel!.orderQuantity = widget.productOrderModel!.orderQuantity! - 1;
                        widget.refreshCallback!(widget.productOrderModel);
                      },
                    );
                  } else {
                    widget.productOrderModel!.couponQuantity = widget.productOrderModel!.couponQuantity! - 1;
                    widget.productOrderModel!.orderQuantity = widget.productOrderModel!.orderQuantity! - 1;
                    widget.refreshCallback!(widget.productOrderModel);
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
                          color: (widget.readOnly! || widget.productOrderModel!.couponQuantity == 1) ? Colors.grey : config.Colors().mainColor(1),
                          size: heightDp * 20,
                        ),
                      ),
                      SizedBox(width: widthDp * 5),
                    ],
                  ),
                ),
              ),
              Text(
                "${numFormat.format(widget.productOrderModel!.couponQuantity)}",
                style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () async {
                  if (widget.readOnly! || !widget.isAddQuantity) return;

                  widget.productOrderModel!.couponQuantity = widget.productOrderModel!.couponQuantity! + 1;
                  widget.productOrderModel!.orderQuantity = widget.productOrderModel!.orderQuantity! + 1;
                  widget.refreshCallback!(widget.productOrderModel);
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
        if ((widget.productOrderModel!.productModel!.id == null || widget.productOrderModel!.productModel!.id.toString().contains("custom")) &&
            (widget.productOrderModel!.productModel!.price == 0))
          _addPriceButton()
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!widget.readOnly!) _editPriceButton(),
              if (widget.productOrderModel!.promocodeDiscount == 0 && widget.productOrderModel!.couponDiscount == 0)
                Text(
                  "₹ ${numFormat.format(widget.productOrderModel!.orderPrice! * widget.productOrderModel!.couponQuantity!)}",
                  style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹ ${numFormat.format(
                        (widget.productOrderModel!.orderPrice! -
                                widget.productOrderModel!.promocodeDiscount! -
                                widget.productOrderModel!.couponDiscount!) *
                            widget.productOrderModel!.couponQuantity!,
                      )}",
                      style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: widthDp * 3),
                    Text(
                      "₹ ${numFormat.format(widget.productOrderModel!.orderPrice! * widget.productOrderModel!.couponQuantity!)}",
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
          itemData: widget.productOrderModel!.productModel!.toJson(),
          quantity: widget.productOrderModel!.orderQuantity,
          callback: (Map<String, dynamic> productData, double quantity) {
            widget.productOrderModel!.productModel = ProductModel.fromJson(productData);
            widget.productOrderModel!.orderPrice = widget.productOrderModel!.productModel!.price! - widget.productOrderModel!.productModel!.discount!;
            widget.productOrderModel!.orderQuantity = quantity;
            widget.productOrderModel!.couponQuantity = quantity;
            widget.refreshCallback!(widget.productOrderModel);
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
          itemData: widget.productOrderModel!.productModel!.toJson(),
          quantity: widget.productOrderModel!.orderQuantity,
          callback: (Map<String, dynamic> productData, double quantity) {
            widget.productOrderModel!.productModel = ProductModel.fromJson(productData);
            widget.productOrderModel!.orderPrice = widget.productOrderModel!.productModel!.price! - widget.productOrderModel!.productModel!.discount!;
            widget.productOrderModel!.orderQuantity = quantity;
            widget.productOrderModel!.couponQuantity = quantity;
            widget.refreshCallback!(widget.productOrderModel);
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
