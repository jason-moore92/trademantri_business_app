import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/store_model.dart';
import 'package:trapp/src/pages/ProductStockListPage/index.dart';

import 'keicy_avatar_image.dart';

class StoreProductWidget extends StatefulWidget {
  final ProductModel? productModel;
  final bool isLoading;
  final Function()? editHandler;
  final Function()? shareHandler;
  final Function()? deleteHandler;
  final Function(bool)? availableHandler;
  final Function(bool)? listonlineHandler;

  StoreProductWidget({
    @required this.productModel,
    @required this.editHandler,
    @required this.shareHandler,
    @required this.deleteHandler,
    @required this.availableHandler,
    @required this.listonlineHandler,
    this.isLoading = true,
  });

  @override
  _ProductItemForSelectionWidgetState createState() => _ProductItemForSelectionWidgetState();
}

class _ProductItemForSelectionWidgetState extends State<StoreProductWidget> {
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

  bool isSelected = false;

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
    return Container(
      width: widthDp * 180,
      height: heightDp * 340,
      margin: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightDp * 8), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.6),
          blurRadius: 6,
          offset: Offset(0, 3),
        )
      ]),
      child: widget.isLoading ? _shimmerWidget() : _productWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
              child: Column(
                children: [
                  SizedBox(height: heightDp * 10),
                  Container(
                    width: widthDp * 80,
                    height: widthDp * 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: heightDp * 10),
                  Expanded(
                    child: Center(
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          "Product name",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: heightDp * 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: Colors.white,
                            child: Text(
                              "Procut pri",
                              style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(width: widthDp * 5),
                          Container(
                            color: Colors.white,
                            child: Text(
                              "345.45",
                              style: TextStyle(
                                fontSize: fontSp * 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      Container(
                        color: Colors.white,
                        child: Text(
                          "Saved Price",
                          style: TextStyle(fontSize: fontSp * 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: heightDp * 10),
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          SizedBox(height: heightDp * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                    color: Colors.transparent,
                    child: Icon(Icons.edit, size: heightDp * 20, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                    color: Colors.transparent,
                    child: Icon(Icons.share, size: heightDp * 20, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                    color: Colors.transparent,
                    child: Icon(Icons.delete, size: heightDp * 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 5),
        ],
      ),
    );
  }

  Widget _productWidget() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
            child: Column(
              children: [
                SizedBox(height: heightDp * 10),
                Stack(
                  children: [
                    Stack(
                      children: [
                        KeicyAvatarImage(
                          url: widget.productModel!.images!.isEmpty ? "" : widget.productModel!.images![0],
                          width: widthDp * 80,
                          height: widthDp * 80,
                          imageFile: widget.productModel!.imageFile,
                          backColor: Colors.grey.withOpacity(0.4),
                        ),
                        Positioned(
                          child: isSelected ? Image.asset("img/check_icon.png", width: heightDp * 25, height: heightDp * 25) : SizedBox(),
                        ),
                      ],
                    ),
                    !widget.productModel!.isAvailable! ? Image.asset("img/unavailable.png", width: widthDp * 60, fit: BoxFit.fitWidth) : SizedBox(),
                  ],
                ),
                SizedBox(height: heightDp * 10),
                Expanded(
                  child: Center(
                    child: Text(
                      "${widget.productModel!.name}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: heightDp * 10),
                Container(
                  child: !widget.productModel!.showPriceToUsers!
                      ? _disablePriceDiaplayWidget()
                      : widget.productModel!.price != 0
                          ? _priceWidget()
                          : SizedBox(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: heightDp * 10),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        SizedBox(height: heightDp * 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: widget.editHandler,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                  color: Colors.transparent,
                  child: Icon(Icons.edit, size: heightDp * 25, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: widget.shareHandler,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                  color: Colors.transparent,
                  child: Icon(Icons.share, size: heightDp * 25, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: widget.deleteHandler,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                  color: Colors.transparent,
                  child: Icon(Icons.delete, size: heightDp * 25, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: heightDp * 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "Product Available",
                  style: TextStyle(fontSize: fontSp * 12),
                ),
              ),
            ),
            Container(
              height: heightDp * 20,
              child: Switch(
                value: widget.productModel!.isAvailable!,
                onChanged: widget.availableHandler,
              ),
            ),
          ],
        ),
        SizedBox(height: heightDp * 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "List Online",
                  style: TextStyle(fontSize: fontSp * 12),
                ),
              ),
            ),
            Container(
              height: heightDp * 20,
              child: Switch(
                value: widget.productModel!.listonline!,
                onChanged: widget.listonlineHandler,
              ),
            ),
          ],
        ),
        SizedBox(height: heightDp * 10),
        // InkWell(
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Text(
        //       "Manage Stock",
        //       style: TextStyle(
        //         color: Colors.blue,
        //         decoration: TextDecoration.underline,
        //       ),
        //     ),
        //   ),
        //   onTap: () {
        //     _goToStock(widget.productModel!);
        //   },
        // )
      ],
    );
  }

  void _goToStock(ProductModel? productModel) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ProductStockListPage(
          product: productModel,
          haveAppBar: true,
        ),
      ),
    );
    if (result != null && result) {
      // _onRefresh();
    }
  }

  Widget _disablePriceDiaplayWidget() {
    return Container(
      width: widthDp * 110,
      padding: EdgeInsets.symmetric(vertical: heightDp * 5),
      decoration: BoxDecoration(color: Color(0xFFF8C888), borderRadius: BorderRadius.circular(heightDp * 4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_moderator, size: widthDp * 12, color: Colors.black),
          SizedBox(width: widthDp * 3),
          Text(
            "Price Disabled\nBy Store Owner",
            style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return Center(
      child: widget.productModel!.discount == 0
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹ ${numFormat.format(widget.productModel!.price)}",
                      style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Text(
                  "Saved ",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.transparent, fontWeight: FontWeight.w500),
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹ ${numFormat.format(widget.productModel!.price! - widget.productModel!.discount!)}",
                      style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: widthDp * 5),
                    Text(
                      "₹ ${numFormat.format(widget.productModel!.price)}",
                      style: TextStyle(
                        fontSize: fontSp * 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Text(
                  "Saved ₹ ${numFormat.format(widget.productModel!.discount)}",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
    );
  }
}
