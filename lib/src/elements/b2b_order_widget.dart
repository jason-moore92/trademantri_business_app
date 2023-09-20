import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/AuthProvider/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class B2BOrderWidget extends StatefulWidget {
  final B2BOrderModel? b2bOrderModel;
  final bool? loadingStatus;
  final bool isShowCard;
  final Function()? rejectCallback;
  final Function()? cancelCallback;
  final Function()? pickupReadyCallback;
  final Function()? deliveryReadyCallback;
  final Function()? deliveryStartCallback;
  final Function()? deliveryDoneCallback;
  final Function()? completeCallback;
  final Function()? detailCallback;
  final Function()? payCallback;

  B2BOrderWidget({
    @required this.b2bOrderModel,
    @required this.loadingStatus,
    this.isShowCard = true,
    this.cancelCallback,
    this.rejectCallback,
    this.pickupReadyCallback,
    this.deliveryReadyCallback,
    this.deliveryStartCallback,
    this.deliveryDoneCallback,
    this.completeCallback,
    this.detailCallback,
    this.payCallback,
  });

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<B2BOrderWidget> {
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

  bool isSent = false;

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
    String orderStatus = "";
    for (var i = 0; i < AppConfig.b2bOrderStatusData.length; i++) {
      if (widget.b2bOrderModel!.status == AppConfig.b2bOrderStatusData[i]["id"]) {
        orderStatus = AppConfig.b2bOrderStatusData[i]["name"];
        break;
      }
    }

    isSent = false;

    if (widget.b2bOrderModel!.myStoreModel!.id == AuthProvider.of(context).authState.storeModel!.id) {
      isSent = true;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(heightDp * 6),
              ),
              child: Text(
                isSent ? "Sent" : "Received",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch(widget.b2bOrderModel!.invoicePdfUrlForStore ?? widget.b2bOrderModel!.invoicePdfUrl!)) {
                      await launch(
                        widget.b2bOrderModel!.invoicePdfUrlForStore ?? widget.b2bOrderModel!.invoicePdfUrl!,
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    } else {
                      throw 'Could not launch ${widget.b2bOrderModel!.invoicePdfUrlForStore ?? widget.b2bOrderModel!.invoicePdfUrl}';
                    }
                  },
                  child: Image.asset("img/pdf-icon.png", width: heightDp * 30, height: heightDp * 30, fit: BoxFit.cover),
                ),
                SizedBox(width: widthDp * 30),
                GestureDetector(
                  onTap: () {
                    Share.share(widget.b2bOrderModel!.invoicePdfUrlForStore ?? widget.b2bOrderModel!.invoicePdfUrl!);
                  },
                  child: Image.asset(
                    "img/share-icon.png",
                    width: heightDp * 30,
                    height: heightDp * 30,
                    fit: BoxFit.cover,
                    color: config.Colors().mainColor(1),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: heightDp * 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.b2bOrderModel!.orderId!,
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              KeicyDateTime.convertDateTimeToDateString(
                dateTime: widget.b2bOrderModel!.updatedAt,
                formats: "Y-m-d H:i",
                isUTC: false,
              ),
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
          ],
        ),
        Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Business Name:",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.b2bOrderModel!.businessStoreModel!.name}",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
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
                  Text(
                    "Order Type: ",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.b2bOrderModel!.orderType ?? "",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ///
        // widget.b2bOrderModel!.products!.isEmpty || widget.b2bOrderModel!.orderType != "Pickup" || widget.b2bOrderModel!.pickupDateTime == null
        //     ? SizedBox()
        //     : Column(
        //         children: [
        //           SizedBox(height: heightDp * 5),
        //           Container(
        //             width: deviceWidth,
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(
        //                   "Pickup Date:",
        //                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
        //                 ),
        //                 Text(
        //                   KeicyDateTime.convertDateTimeToDateString(
        //                     dateTime: widget.b2bOrderModel!.pickupDateTime,
        //                     formats: 'Y-m-d h:i A',
        //                     isUTC: false,
        //                   ),
        //                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),

        // ///
        // widget.b2bOrderModel!.products!.isEmpty || widget.b2bOrderModel!.orderType != "Delivery" || widget.b2bOrderModel!.deliveryAddress == null
        //     ? SizedBox()
        //     : Column(
        //         children: [
        //           SizedBox(height: heightDp * 5),
        //           Container(
        //             width: deviceWidth,
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   "Delivery Address:",
        //                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
        //                 ),
        //                 SizedBox(height: heightDp * 5),
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Row(
        //                       children: [
        //                         Text(
        //                           "${widget.b2bOrderModel!.deliveryAddress!.addressType}",
        //                           style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.bold),
        //                           maxLines: 2,
        //                           overflow: TextOverflow.ellipsis,
        //                         ),
        //                         SizedBox(width: widthDp * 10),
        //                         Text(
        //                           "${(widget.b2bOrderModel!.deliveryAddress!.distance! / 1000).toStringAsFixed(3)} Km",
        //                           style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
        //                         ),
        //                       ],
        //                     ),
        //                     SizedBox(height: heightDp * 5),
        //                     widget.b2bOrderModel!.deliveryAddress!.building == null || widget.b2bOrderModel!.deliveryAddress!.building == ""
        //                         ? SizedBox()
        //                         : Column(
        //                             children: [
        //                               Text(
        //                                 "${widget.b2bOrderModel!.deliveryAddress!.building}",
        //                                 style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
        //                                 maxLines: 2,
        //                                 overflow: TextOverflow.ellipsis,
        //                               ),
        //                               SizedBox(height: heightDp * 5),
        //                             ],
        //                           ),
        //                     Text(
        //                       "${widget.b2bOrderModel!.deliveryAddress!.address!.address}",
        //                       style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
        //                       maxLines: 2,
        //                       overflow: TextOverflow.ellipsis,
        //                     ),
        //                     SizedBox(height: heightDp * 5),
        //                     KeicyCheckBox(
        //                       iconSize: heightDp * 20,
        //                       iconColor: Color(0xFF00D18F),
        //                       labelSpacing: widthDp * 10,
        //                       label: "No Contact Delivery",
        //                       labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
        //                       value: widget.b2bOrderModel!.noContactDelivery!,
        //                       readOnly: true,
        //                     ),
        //                   ],
        //                 )
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),

        ///
        SizedBox(height: heightDp * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "To Pay: ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "₹ ${widget.b2bOrderModel!.paymentDetail!.toPay}",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
          ],
        ),

        SizedBox(height: heightDp * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Order Status: ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              orderStatus,
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
          ],
        ),

        Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

        ///
        if (widget.b2bOrderModel!.status == AppConfig.b2bOrderStatusData[1]["id"])
          if (isSent) _acceptOrderSentButtonGroup() else _acceptOrderReceivedButtonGroup()
        else if (widget.b2bOrderModel!.status == AppConfig.b2bOrderStatusData[2]["id"])
          if (isSent) _paidOrderSentButtonGroup() else _paidOrderReceivedButtonGroup()
        else if (widget.b2bOrderModel!.status == AppConfig.b2bOrderStatusData[3]["id"])
          if (isSent) _pickupReadyOrderSentButtonGroup() else _detailButton()
        else if (widget.b2bOrderModel!.status == AppConfig.b2bOrderStatusData[4]["id"])
          if (isSent) _deliveryReadyOrderSentButtonGroup() else _detailButton()
        else if (widget.b2bOrderModel!.status == AppConfig.b2bOrderStatusData[5]["id"])
          if (isSent) _deliveryStartOrderSentButtonGroup() else _deliveryStartOrderReceiedButtonGroup()
        else if (widget.b2bOrderModel!.status == AppConfig.b2bOrderStatusData[6]["id"])
          if (isSent) _deliveryDoneOrderSentButtonGroup() else _detailButton()

        // else if (widget.b2bOrderModel!.status == AppConfig.b2bOrderStatusData[4]["id"] ||
        //     widget.b2bOrderModel!.status == AppConfig.b2bOrderStatusData[5]["id"])
        //   _pickupCompleteButtonGroup()
        else
          _detailButton(),
      ],
    );
  }

  Widget _acceptOrderSentButtonGroup() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: widthDp * 5,
      runSpacing: heightDp * 5,
      children: [
        KeicyRaisedButton(
          width: widthDp * 140,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Payment Received",
            style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
          ),
          onPressed: widget.payCallback,
        ),
        if (widget.b2bOrderModel!.orderType == "Delivery")
          KeicyRaisedButton(
            width: widthDp * 130,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Delivery Ready",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: widget.deliveryReadyCallback,
          ),
        if (widget.b2bOrderModel!.orderType == "Pickup")
          KeicyRaisedButton(
            width: widthDp * 130,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Pickup Ready",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: widget.pickupReadyCallback,
          ),
        KeicyRaisedButton(
          width: widthDp * 80,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          child: Text(
            "Reject",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: widget.rejectCallback,
        ),
        KeicyRaisedButton(
          width: widthDp * 110,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
              Text(
                "To detail",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
            ],
          ),
          onPressed: widget.detailCallback,
        ),
      ],
    );
  }

  Widget _acceptOrderReceivedButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            child: Text(
              "Cancel",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: widget.cancelCallback),
        KeicyRaisedButton(
          width: widthDp * 120,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
              Text(
                "To detail",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
            ],
          ),
          onPressed: widget.detailCallback,
        ),
      ],
    );
  }

  Widget _detailButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        KeicyRaisedButton(
          width: widthDp * 170,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
              Text(
                "To detail",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
            ],
          ),
          onPressed: widget.detailCallback,
        ),
      ],
    );
  }

  Widget _paidOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[3]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Pickup Ready",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: widget.pickupReadyCallback,
            ),
          if (widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[4]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Delivery Ready",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: widget.deliveryReadyCallback,
            ),
          if (!widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[4]["id"]) &&
              widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[5]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Delivery Start",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: widget.deliveryStartCallback,
            ),
          if (widget.b2bOrderModel!.orderFutureStatus!.length == 1 &&
              widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[7]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Complete",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                widget.completeCallback!();
              },
            ),
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
                Text(
                  "To detail",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                ),
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
              ],
            ),
            onPressed: widget.detailCallback,
          ),
        ],
      ),
    );
  }

  Widget _paidOrderReceivedButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (!widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[5]["id"]) &&
              widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[6]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Order Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: widget.deliveryDoneCallback,
            ),
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
                Text(
                  "To detail",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                ),
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
              ],
            ),
            onPressed: widget.detailCallback,
          ),
        ],
      ),
    );
  }

  Widget _pickupReadyOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[2]["id"]))
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Payment Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                widget.payCallback!();
              },
            ),
          if (widget.b2bOrderModel!.orderFutureStatus!.length == 1 &&
              widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[7]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Complete",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                widget.completeCallback!();
              },
            ),
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
                Text(
                  "To detail",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                ),
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
              ],
            ),
            onPressed: widget.detailCallback,
          ),
        ],
      ),
    );
  }

  Widget _deliveryReadyOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[2]["id"]))
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Payment Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                widget.payCallback!();
              },
            ),
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Delivery Start",
              style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
            ),
            onPressed: widget.deliveryStartCallback,
          ),
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
                Text(
                  "To detail",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                ),
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
              ],
            ),
            onPressed: widget.detailCallback,
          ),
        ],
      ),
    );
  }

  Widget _deliveryStartOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[2]["id"]))
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Payment Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                widget.payCallback!();
              },
            ),
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
                Text(
                  "To detail",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                ),
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
              ],
            ),
            onPressed: widget.detailCallback,
          ),
        ],
      ),
    );
  }

  Widget _deliveryStartOrderReceiedButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Order Received",
              style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
            ),
            onPressed: widget.deliveryDoneCallback,
          ),
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
                Text(
                  "To detail",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                ),
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
              ],
            ),
            onPressed: widget.detailCallback,
          ),
        ],
      ),
    );
  }

  Widget _deliveryDoneOrderSentButtonGroup() {
    return Container(
      width: deviceWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: widthDp * 5,
        runSpacing: heightDp * 5,
        children: [
          if (widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[2]["id"]))
            KeicyRaisedButton(
              width: widthDp * 140,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Payment Received",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                widget.payCallback!();
              },
            ),
          if (widget.b2bOrderModel!.orderFutureStatus!.length == 1 &&
              widget.b2bOrderModel!.orderFutureStatus!.contains(AppConfig.b2bOrderStatusData[7]["id"]))
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 30,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Complete",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
              ),
              onPressed: () {
                widget.completeCallback!();
              },
            ),
          KeicyRaisedButton(
            width: widthDp * 120,
            height: heightDp * 30,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
                Text(
                  "To detail",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                ),
                Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
              ],
            ),
            onPressed: widget.detailCallback,
          ),
        ],
      ),
    );
  }
}
