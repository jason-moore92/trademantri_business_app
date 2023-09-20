import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class PurchaseOrderWidget extends StatefulWidget {
  final PurchaseModel? purchaseModel;
  final bool? loadingStatus;
  final bool isShowCard;
  final Function()? detailHandler;

  PurchaseOrderWidget({
    @required this.purchaseModel,
    @required this.loadingStatus,
    this.isShowCard = true,
    this.detailHandler,
  });

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<PurchaseOrderWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
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
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: widget.isShowCard
          ? EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10)
          : EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
      elevation: widget.isShowCard ? 5 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(heightDp * 8),
          border: widget.isShowCard ? null : Border.all(color: Colors.grey.withOpacity(0.4)),
        ),
        child: widget.loadingStatus! ? _shimmerWidget() : _orderWidget(),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "OrderID",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "2021-04-05",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
          Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "User Name:",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "Userfirst  last Name:",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "User Mobile:",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "123456780",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),
          Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

          ///
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Order Type: ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "orderType",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Container(
                width: deviceWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "Order Type: ",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "orderType",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "To Pay: ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "₹ 1375.23",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),

          SizedBox(height: heightDp * 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Order Status: ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: Colors.white,
                child: Text(
                  "orderStatus ",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ),
            ],
          ),

          Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KeicyRaisedButton(
                width: widthDp * 100,
                height: heightDp * 30,
                color: Colors.white,
                borderRadius: heightDp * 8,
                child: Text(
                  "Accept",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: () {
                  ///
                },
              ),
              KeicyRaisedButton(
                width: widthDp * 100,
                height: heightDp * 30,
                color: Colors.white,
                borderRadius: heightDp * 8,
                child: Text(
                  "Reject",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: () {
                  ///
                },
              ),
              KeicyRaisedButton(
                width: widthDp * 120,
                height: heightDp * 30,
                color: Colors.white,
                borderRadius: heightDp * 8,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
                    Text(
                      "To detail",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                    Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
                  ],
                ),
                onPressed: () {
                  ///
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderWidget() {
    StoreModel? storeModel;
    if (widget.purchaseModel!.myStoreModel!.id != AuthProvider.of(context).authState.storeModel!.id) {
      storeModel = widget.purchaseModel!.myStoreModel;
    } else {
      storeModel = widget.purchaseModel!.businessStoreModel;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Store Name:",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "${storeModel!.name}",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PO ID:",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.purchaseModel!.purchaseOrderId}",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
          ],
        ),

        ///
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shipping:",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: heightDp * 5),
            Text(
              "${widget.purchaseModel!.shippingAddress!.address}",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            KeicyRaisedButton(
              width: widthDp * 100,
              height: heightDp * 35,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              child: Text(
                "Detail",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
              ),
              onPressed: widget.detailHandler,
            ),
          ],
        ),
      ],
    );
  }
}
