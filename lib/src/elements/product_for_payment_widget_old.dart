import 'dart:convert';

import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/normal_ask_dialog.dart';
import 'package:trapp/src/dialogs/product_purchase_price_dialog.dart';
import 'package:trapp/src/helpers/price_functions.dart';

import 'keicy_avatar_image.dart';

class ProductPaymentOldWidget extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final Map<String, dynamic>? orderData;
  final int? index;
  final Function(String)? deleteCallback;
  final Function? refreshCallback;

  ProductPaymentOldWidget({
    @required this.productData,
    @required this.orderData,
    this.index,
    this.deleteCallback,
    this.refreshCallback,
  });

  @override
  _ProductPaymentOldWidgetState createState() => _ProductPaymentOldWidgetState();
}

class _ProductPaymentOldWidgetState extends State<ProductPaymentOldWidget> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 0, vertical: heightDp * 5),
      child: _productWidget(),
    );
  }

  Widget _productWidget() {
    if (widget.productData!["images"].runtimeType.toString() == "String") {
      widget.productData!["images"] = json.decode(widget.productData!["images"]);
    }

    return Row(
      children: [
        KeicyAvatarImage(
          url: (widget.productData!["images"] == null || widget.productData!["images"].isEmpty) ? "" : widget.productData!["images"][0],
          imageFile: widget.productData!["imageFile"],
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
                      "${widget.productData!["name"]}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: widthDp * 5),
                  _priceWidget(),
                ],
              ),
              (widget.productData!["taxPrice"] == 0 && (widget.productData!["quantity"] == null || widget.productData!["quantityType"] == null))
                  ? SizedBox(width: widthDp * 5)
                  : Column(
                      children: [
                        SizedBox(height: heightDp * 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: (widget.productData!["quantity"] == null || widget.productData!["quantityType"] == null)
                                  ? SizedBox()
                                  : Text(
                                      "${widget.productData!["quantity"] ?? ""} ${widget.productData!["quantityType"] ?? ""}",
                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    ),
                            ),
                            SizedBox(width: widthDp * 5),
                            widget.productData!["taxPrice"] == null || widget.productData!["taxPrice"] == 0
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Text(
                                        "Tax: ₹ ${(widget.productData!["taxPrice"] * widget.productData!["orderQuantity"]).toStringAsFixed(2)}",
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
        "Product",
        style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
      ),
    );
  }

  Widget _addMoreProductButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          child: Icon(Icons.delete, size: heightDp * 25, color: Colors.black),
          onTap: () {
            NormalAskDialog.show(
              context,
              content: "Do you want to delete this product",
              callback: () {
                widget.deleteCallback!(widget.productData!["_id"]);
              },
            );
          },
        ),
        SizedBox(width: widthDp * 10),
        Container(
          width: widthDp * 100,
          padding: EdgeInsets.symmetric(vertical: heightDp * 2),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  if (widget.productData!["orderQuantity"] == 1) return;

                  widget.productData!["orderQuantity"] = widget.productData!["orderQuantity"] - 1;
                  widget.refreshCallback!(widget.productData!["_id"], widget.productData!["orderQuantity"]);
                  // ReduceQualityDialog.show(
                  //   context,
                  //   widthDp: widthDp,
                  //   heightDp: heightDp,
                  //   fontSp: fontSp,
                  //   callBack: () {
                  //     widget.productData!["orderQuantity"] = widget.productData!["orderQuantity"] - 1;
                  //     widget.refreshCallback(widget.productData!["_id"], widget.productData!["orderQuantity"]);
                  //   },
                  // );
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 10),
                      GestureDetector(
                        child: Icon(
                          Icons.remove,
                          color: (widget.productData!["orderQuantity"] == 1) ? Colors.grey : config.Colors().mainColor(1),
                          size: heightDp * 20,
                        ),
                      ),
                      SizedBox(width: widthDp * 5),
                    ],
                  ),
                ),
              ),
              Text(
                "${widget.productData!["orderQuantity"]}",
                style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () async {
                  widget.productData!["orderQuantity"] = widget.productData!["orderQuantity"] + 1;
                  widget.refreshCallback!(widget.productData!["_id"], widget.productData!["orderQuantity"]);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 5),
                      GestureDetector(
                        child: Icon(Icons.add, color: config.Colors().mainColor(1), size: heightDp * 20),
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
    if (widget.orderData!["promocode"] != null &&
        widget.orderData!["promocode"].isNotEmpty &&
        widget.orderData!["promocode"]["promocodeType"].toString().contains("INR")) {
      PriceFunctions.calculateINRPromocodeForOrder(orderData: widget.orderData);
      var priceResult = PriceFunctions.getPriceDataForProduct(orderData: widget.orderData, data: widget.productData);
      widget.productData!.addAll(priceResult);
    } else {
      var priceResult = PriceFunctions.getPriceDataForProduct(orderData: widget.orderData, data: widget.productData);
      widget.productData!.addAll(priceResult);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if ((widget.productData!["_id"] == null || widget.productData!["_id"].toString().contains("custom")) &&
            (widget.productData!["price"] == null || widget.productData!["price"] == 0))
          _addPriceButton()
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _editPriceButton(),
              if (widget.productData!["promocodeDiscount"] == 0)
                Text(
                  "₹ ${((widget.productData!["price"] - widget.productData!["discount"]) * widget.productData!["orderQuantity"]).toStringAsFixed(2)}",
                  style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "₹ ${((widget.productData!["price"] - widget.productData!["discount"] - widget.productData!["promocodeDiscount"]) * widget.productData!["orderQuantity"]).toStringAsFixed(2)}",
                      style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: widthDp * 3),
                    Text(
                      "₹ ${((widget.productData!["price"] - widget.productData!["discount"]) * widget.productData!["orderQuantity"]).toStringAsFixed(2)}",
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
        ProductPriceOldDialog.show(context, productData: widget.productData, callback: (Map<String, dynamic> productData) {
          widget.productData!["price"] = productData["price"];
          widget.productData!["taxPercentage"] = productData["taxPercentage"];
          widget.productData!["discount"] = productData["discount"];
          widget.productData!["promocodeDiscount"] = productData["promocodeDiscount"];
          widget.productData!["taxPercentage"] = productData["taxPercentage"];
          widget.productData!["taxPrice"] = productData["taxPrice"];
          widget.productData!["priceFor1OrderQuantityBeforeTax"] = productData["priceFor1OrderQuantityBeforeTax"];
          widget.productData!["priceFor1OrderQuantityAfterTax"] = productData["priceFor1OrderQuantityAfterTax"];
          setState(() {});
          widget.refreshCallback!(widget.productData!["_id"], widget.productData!["orderQuantity"]);
        });
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
        ProductPriceOldDialog.show(context, productData: widget.productData, callback: (Map<String, dynamic> productData) {
          widget.productData!["price"] = productData["price"];
          widget.productData!["discount"] = productData["discount"];
          widget.productData!["promocodeDiscount"] = productData["promocodeDiscount"];
          widget.productData!["taxPercentage"] = productData["taxPercentage"];
          widget.productData!["taxPrice"] = productData["taxPrice"];
          widget.productData!["priceFor1OrderQuantityBeforeTax"] = productData["priceFor1OrderQuantityBeforeTax"];
          widget.productData!["priceFor1OrderQuantityAfterTax"] = productData["priceFor1OrderQuantityAfterTax"];
          setState(() {});
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: widthDp * 10),
        child: Icon(Icons.edit, size: heightDp * 20),
      ),
    );
  }
}
