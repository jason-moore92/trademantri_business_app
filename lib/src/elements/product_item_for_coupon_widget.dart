import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/models/index.dart';

import 'keicy_avatar_image.dart';

class ProductItemForCouponWidget extends StatelessWidget {
  final ProductModel? productModel;
  final EdgeInsetsGeometry? padding;
  final Function(ProductModel?)? deleteCallback;

  ProductItemForCouponWidget({
    @required this.productModel,
    this.padding,
    this.deleteCallback,
  });

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

  ProductModel? _productModel;

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  @override
  Widget build(BuildContext context) {
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
    _productModel = ProductModel.copy(productModel!);

    bool isLoading = productModel == null;

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      child: isLoading ? _shimmerWidget() : _productWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: true,
      period: Duration(milliseconds: 1000),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: widthDp * 80,
                height: widthDp * 80,
                color: Colors.white,
              ),
              SizedBox(width: widthDp * 15),
              Container(
                height: widthDp * 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "product name",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "10 unites",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "price",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: widthDp * 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(heightDp * 20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "ADD",
                    style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _productWidget() {
    return Row(
      children: [
        Stack(
          children: [
            KeicyAvatarImage(
              url: _productModel!.images!.isNotEmpty ? _productModel!.images![0] : "",
              width: widthDp * 80,
              height: widthDp * 80,
              backColor: Colors.grey.withOpacity(0.4),
            ),
            !_productModel!.isAvailable! ? Image.asset("img/unavailable.png", width: widthDp * 60, fit: BoxFit.fitWidth) : SizedBox(),
          ],
        ),
        SizedBox(width: widthDp * 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_productModel!.name}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_productModel!.description}",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_productModel!.quantity != 0 && _productModel!.quantityType != "")
                          Expanded(
                            child: Text(
                              "${_productModel!.quantity} ${_productModel!.quantityType}",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            if (deleteCallback != null) {
                              deleteCallback!(_productModel);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: heightDp * 5, horizontal: widthDp * 5),
                            child: Icon(Icons.delete, size: heightDp * 20, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _categoryButton(),
                        _priceWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
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

  Widget _priceWidget() {
    return _productModel!.discount == 0
        ? Text(
            "₹ ${numFormat.format(_productModel!.price)}",
            style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "₹ ${numFormat.format(_productModel!.price! - _productModel!.discount!)}",
                    style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: widthDp * 10),
                  Text(
                    "₹ ${numFormat.format(_productModel!.price)}",
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
              Text(
                "Saved ₹ ${numFormat.format(_productModel!.discount)}",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          );
  }

  Widget _availableBargainWidget() {
    return Container(
      width: widthDp * 120,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: heightDp * 5),
              decoration: BoxDecoration(color: Color(0xFFE7F16E), borderRadius: BorderRadius.circular(heightDp * 4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, size: widthDp * 12, color: Colors.black),
                  SizedBox(width: widthDp * 3),
                  Text(
                    "Bargain Available",
                    style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: widthDp * 10),
        ],
      ),
    );
  }

  Widget _availableBulkOrder() {
    return Container(
      width: widthDp * 135,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: heightDp * 5),
              decoration: BoxDecoration(color: Color(0xFF6EF174), borderRadius: BorderRadius.circular(heightDp * 4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, size: widthDp * 12, color: Colors.black),
                  SizedBox(width: widthDp * 3),
                  Text(
                    "Bulk Order Available",
                    style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: widthDp * 10),
        ],
      ),
    );
  }
}
