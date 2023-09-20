import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ProductItemB2BDetailPage/index.dart';
import 'package:trapp/src/pages/ProductItemDetailPage/index.dart';

import 'keicy_avatar_image.dart';
import 'keicy_raised_button.dart';

class ServiceItemB2BWidget extends StatefulWidget {
  final List<ServiceModel>? selectedServices;
  final ServiceModel? serviceModel;
  final StoreModel? storeModel;
  final bool? isLoading;
  final EdgeInsetsGeometry? padding;
  final bool showDetailButton;

  ServiceItemB2BWidget({
    @required this.selectedServices,
    @required this.serviceModel,
    @required this.storeModel,
    this.isLoading = true,
    this.padding,
    this.showDetailButton = true,
  });

  @override
  _ServiceItemB2BWidgetState createState() => _ServiceItemB2BWidgetState();
}

class _ServiceItemB2BWidgetState extends State<ServiceItemB2BWidget> {
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
    return Padding(
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      child: widget.isLoading! ? _shimmerWidget() : _serviceWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading!,
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
                        "service name",
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
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "price asfasdf",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: heightDp * 5),
              Container(
                color: Colors.white,
                child: Text(
                  "price asff",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _serviceWidget() {
    isSelected = false;
    for (var i = 0; i < widget.selectedServices!.length; i++) {
      if (widget.selectedServices![i].id == widget.serviceModel!.id) {
        isSelected = true;
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Stack(
              children: [
                KeicyAvatarImage(
                  url: widget.serviceModel!.images!.isEmpty ? "" : widget.serviceModel!.images![0],
                  width: widthDp * 80,
                  height: widthDp * 80,
                  backColor: Colors.grey.withOpacity(0.4),
                  imageFile: widget.serviceModel!.imageFile,
                ),
                !widget.serviceModel!.isAvailable! ? Image.asset("img/unavailable.png", width: widthDp * 60, fit: BoxFit.fitWidth) : SizedBox(),
                Positioned(
                  child: isSelected ? Image.asset("img/check_icon.png", width: heightDp * 25, height: heightDp * 25) : SizedBox(),
                ),
              ],
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
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.serviceModel!.name}",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.serviceModel!.description != "")
                                Column(
                                  children: [
                                    SizedBox(height: heightDp * 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${widget.serviceModel!.description}",
                                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              if (widget.serviceModel!.provided != "")
                                Column(
                                  children: [
                                    SizedBox(height: heightDp * 5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${widget.serviceModel!.provided}",
                                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              SizedBox(height: heightDp * 5),
                              _categoryButton()
                            ],
                          ),
                        ),
                      ),
                      // !widget.serviceModel!.showPriceToUsers!
                      //     ? _disablePriceDiaplayWidget()
                      //     :
                      widget.serviceModel!.b2bPriceFrom == 0 && widget.serviceModel!.b2bPriceTo == 0
                          ? widget.serviceModel!.price == 0
                              ? Text(
                                  "Price Not Available",
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.red, fontWeight: FontWeight.w500),
                                )
                              : _priceWidget()
                          : _b2bPriceWidget(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.showDetailButton) SizedBox(height: heightDp * 5),
        if (widget.showDetailButton)
          KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 30,
            borderRadius: heightDp * 6,
            color: config.Colors().mainColor(1),
            child: Text(
              "Details",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => ProductItemB2BDetailPage(
                    storeModel: widget.storeModel,
                    serviceModel: widget.serviceModel,
                    type: "services",
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _disablePriceDiaplayWidget() {
    return Container(
      width: widthDp * 180,
      padding: EdgeInsets.symmetric(vertical: heightDp * 5),
      decoration: BoxDecoration(color: Color(0xFFF8C888), borderRadius: BorderRadius.circular(heightDp * 4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_moderator, size: widthDp * 12, color: Colors.black),
          SizedBox(width: widthDp * 3),
          Text(
            "Price Disabled By Store Owner",
            style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return widget.serviceModel!.discount == 0
        ? Text(
            "₹ ${numFormat.format(widget.serviceModel!.price)}",
            style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "₹ ${numFormat.format(widget.serviceModel!.price! - widget.serviceModel!.discount!)}",
                    style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: widthDp * 10),
                  Text(
                    "₹ ${numFormat.format(widget.serviceModel!.price)}",
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
              SizedBox(height: heightDp * 5),
              Text(
                "Saved ₹ ${numFormat.format(widget.serviceModel!.discount)}",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          );
  }

  Widget _b2bPriceWidget() {
    if (widget.serviceModel!.b2bDiscountValue != 0) {
      if (widget.serviceModel!.b2bDiscountType == "Amount") {
        widget.serviceModel!.b2bDiscount = widget.serviceModel!.b2bDiscountValue;
      } else if (widget.serviceModel!.b2bDiscountType == "Percentage") {
        widget.serviceModel!.b2bDiscount = (widget.serviceModel!.b2bDiscountValue! / 100) * widget.serviceModel!.b2bPriceFrom!;
      }
    }
    return widget.serviceModel!.b2bDiscount == 0
        ? Text(
            "₹ ${numFormat.format(widget.serviceModel!.b2bPriceFrom)}",
            style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "₹ ${numFormat.format(widget.serviceModel!.b2bPriceFrom! - widget.serviceModel!.b2bDiscount!)}",
                        style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: widthDp * 10),
                      Text(
                        "₹ ${numFormat.format(widget.serviceModel!.b2bPriceFrom)}",
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
                  SizedBox(height: heightDp * 2),
                  Text(
                    "Saved ₹ ${numFormat.format(widget.serviceModel!.b2bDiscount)}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              if (widget.serviceModel!.b2bAcceptBulkOrder!)
                Text(
                  "* Bulk order discount applied",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.red, fontWeight: FontWeight.w500),
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
        "Service",
        style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
      ),
    );
  }
}
