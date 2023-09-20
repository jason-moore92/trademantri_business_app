import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';

import 'keicy_avatar_image.dart';

class CatalogProductWidget extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final bool isLoading;
  final Function? varientsHandler;

  CatalogProductWidget({
    @required this.productData,
    @required this.varientsHandler,
    this.isLoading = true,
  });

  @override
  _ProductItemForSelectionWidgetState createState() => _ProductItemForSelectionWidgetState();
}

class _ProductItemForSelectionWidgetState extends State<CatalogProductWidget> {
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
      width: widthDp * 170,
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 20),
        child: Column(
          children: [
            Container(width: widthDp * 100, height: widthDp * 100, color: Colors.white),
            SizedBox(height: heightDp * 10),
            Container(
              color: Colors.white,
              child: Text(
                "product name",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: heightDp * 5),
            Container(
              color: Colors.white,
              child: Text(
                "category",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: heightDp * 15),
            KeicyRaisedButton(
              width: widthDp * 130,
              height: heightDp * 35,
              color: Colors.white,
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Show Variants",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 20),
      child: Column(
        children: [
          KeicyAvatarImage(
            url: widget.productData!["imgLocation"] + widget.productData!["item"]["imageUrl"],
            width: widthDp * 100,
            height: widthDp * 100,
            imageFile: widget.productData!["imageFile"],
            backColor: Colors.grey.withOpacity(0.4),
          ),
          SizedBox(height: heightDp * 10),
          Text(
            "${widget.productData!["name"]}",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "${widget.productData!["category"]}",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightDp * 15),
          KeicyRaisedButton(
            width: widthDp * 130,
            height: heightDp * 35,
            color: widget.productData!["item"]["variants"] == null || widget.productData!["item"]["variants"].isEmpty
                ? Colors.grey.withOpacity(0.7)
                : config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Show Variants",
              style: TextStyle(
                fontSize: fontSp * 14,
                color:
                    widget.productData!["item"]["variants"] == null || widget.productData!["item"]["variants"].isEmpty ? Colors.black : Colors.white,
              ),
            ),
            onPressed: widget.productData!["item"]["variants"] == null || widget.productData!["item"]["variants"].isEmpty
                ? null
                : () {
                    if (widget.varientsHandler != null) {
                      widget.varientsHandler!();
                    }
                  },
          ),
        ],
      ),
    );
  }
}
