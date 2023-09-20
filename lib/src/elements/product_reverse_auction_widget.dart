import 'dart:convert';

import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'keicy_avatar_image.dart';

class ProductReverseAuctionWidget extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final Map<String, dynamic>? reverseAuctionData;
  final int? index;
  final Function(int)? deleteCallback;

  ProductReverseAuctionWidget({
    @required this.productData,
    @required this.reverseAuctionData,
    this.index,
    this.deleteCallback,
  });

  @override
  _ProductReverseAuctionWidgetState createState() => _ProductReverseAuctionWidgetState();
}

class _ProductReverseAuctionWidgetState extends State<ProductReverseAuctionWidget> {
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
      child: _serviceWidget(),
    );
  }

  Widget _serviceWidget() {
    if (widget.productData!["images"].runtimeType.toString() == "String") {
      widget.productData!["images"] = json.decode(widget.productData!["images"]);
    }

    return Row(
      children: [
        KeicyAvatarImage(
          url: (widget.productData!["images"] == null || widget.productData!["images"].isEmpty) ? "" : widget.productData!["images"][0],
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
                "${widget.productData!["name"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "${widget.productData!["description"]}",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),

              ///
              SizedBox(height: heightDp * 5),
              if (widget.productData!["quantity"] != null && widget.productData!["quantityType"] != null)
                Text(
                  "${widget.productData!["quantity"]} ${widget.productData!["quantityType"]}",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                )
              else
                SizedBox(),
            ],
          ),
        ),
        Container(
          height: widthDp * 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _quantityButton(),
              _categoryButton(),
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

  Widget _quantityButton() {
    return Container(
      child: Row(
        children: [
          Text(
            "Quantity: ",
            style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          ),
          Text(
            "${widget.productData!["orderQuantity"]}",
            style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
