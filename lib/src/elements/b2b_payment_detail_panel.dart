import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class B2BPaymentDetailPanel extends StatefulWidget {
  final B2BOrderModel? b2bOrderModel;
  final EdgeInsetsGeometry? padding;

  B2BPaymentDetailPanel({@required this.b2bOrderModel, this.padding});

  @override
  _PaymentDetailPanelState createState() => _PaymentDetailPanelState();
}

class _PaymentDetailPanelState extends State<B2BPaymentDetailPanel> {
  /// Responsive design variables
  double? deviceWidth;
  double? deviceHeight;
  double? statusbarHeight;
  double? bottomBarHeight;
  double? appbarHeight;
  double? widthDp;
  double? heightDp;
  double? heightDp1;
  double? fontSp;
  ///////////////////////////////

  var numFormat = NumberFormat.currency(symbol: "", name: "");

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryAddressProvider>(builder: (context, deliveryAddressProvider, _) {
      return Container(
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: widthDp! * 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///
            Text(
              "Payment Detail",
              style: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.w500),
            ),

            ///
            SizedBox(height: heightDp! * 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Count",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
                Text(
                  "${numFormat.format(widget.b2bOrderModel!.paymentDetail!.totalQuantity)}",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
              ],
            ),

            ///
            Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
                Row(
                  children: [
                    Text(
                      "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.totalPrice! + widget.b2bOrderModel!.paymentDetail!.totalPromocodeDiscount!)}",
                      style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                    ),
                    if (widget.b2bOrderModel!.paymentDetail!.totalPrice != widget.b2bOrderModel!.paymentDetail!.totalOriginPrice)
                      Row(
                        children: [
                          SizedBox(width: widthDp! * 5),
                          Text(
                            "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.totalOriginPrice)}",
                            style: TextStyle(
                              fontSize: fontSp! * 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),

            ///
            Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Item Price",
                  style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                ),
                Row(
                  children: [
                    Text(
                      "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.totalPrice! - widget.b2bOrderModel!.paymentDetail!.totalTaxAfterCouponDiscount! + widget.b2bOrderModel!.paymentDetail!.totalPromocodeDiscount!)}",
                      style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                    ),
                    widget.b2bOrderModel!.paymentDetail!.totalPrice == widget.b2bOrderModel!.paymentDetail!.totalOriginPrice
                        ? SizedBox()
                        : Row(
                            children: [
                              SizedBox(width: widthDp! * 5),
                              Text(
                                "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.totalOriginPrice! - widget.b2bOrderModel!.paymentDetail!.totalTaxAfterCouponDiscount!)}",
                                style: TextStyle(
                                  fontSize: fontSp! * 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ],
            ),

            // ///
            // if (widget.b2bOrderModel!.promocode != null)
            //   Column(
            //     children: [
            //       Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Promo code applied",
            //             style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //           ),
            //           Text(
            //             "${widget.b2bOrderModel!.promocode!.promocodeCode}",
            //             style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),

            // ///
            // if (widget.b2bOrderModel!.paymentDetail!.totalPromocodeDiscount != 0)
            //   Column(
            //     children: [
            //       Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Total Promoode Discount",
            //             style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //           ),
            //           Row(
            //             children: [
            //               Text(
            //                 "₹ ${widget.b2bOrderModel!.paymentDetail!.totalPromocodeDiscount!.toStringAsFixed(2)}",
            //                 style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),

            // ///
            // if (widget.b2bOrderModel!.coupon != null)
            //   Column(
            //     children: [
            //       Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Coupon applied",
            //             style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //           ),
            //           Text(
            //             "${widget.b2bOrderModel!.coupon!.discountCode}",
            //             style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),

            // ///
            // if (widget.b2bOrderModel!.paymentDetail!.totalCouponDiscount != 0)
            //   Column(
            //     children: [
            //       Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Total Coupon Discount",
            //             style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //           ),
            //           Row(
            //             children: [
            //               Text(
            //                 "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.totalCouponDiscount)}",
            //                 style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),

            // ///
            // widget.b2bOrderModel!.deliveryAddress == null
            //     ? SizedBox()
            //     : Column(
            //         children: [
            //           Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Row(
            //                 children: [
            //                   Text(
            //                     "Delivery Price",
            //                     style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //                   ),
            //                   GestureDetector(
            //                     onTap: () {
            //                       _deliveryBreakdownDialog();
            //                     },
            //                     child: Container(
            //                       padding: EdgeInsets.symmetric(horizontal: widthDp! * 10),
            //                       color: Colors.transparent,
            //                       child: Icon(Icons.info_outline, size: heightDp! * 20, color: Colors.black.withOpacity(0.6)),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 children: [
            //                   Text(
            //                     "₹ ${widget.b2bOrderModel!.paymentDetail!.deliveryChargeAfterDiscount!.toStringAsFixed(2)}",
            //                     style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //                   ),
            //                   if (widget.b2bOrderModel!.paymentDetail!.deliveryDiscount != 0)
            //                     Row(
            //                       children: [
            //                         SizedBox(width: widthDp! * 5),
            //                         Text(
            //                           "₹ ${widget.b2bOrderModel!.paymentDetail!.deliveryChargeBeforeDiscount!.toStringAsFixed(2)}",
            //                           style: TextStyle(
            //                             fontSize: fontSp! * 12,
            //                             color: Colors.grey,
            //                             decoration: TextDecoration.lineThrough,
            //                             decorationThickness: 2,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),

            // ///
            // if (widget.b2bOrderModel!.paymentDetail!.tip != 0)
            //   Column(
            //     children: [
            //       Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Tip",
            //             style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //           ),
            //           Text(
            //             "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.tip)}",
            //             style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),

            ///
            if (widget.b2bOrderModel!.paymentDetail!.totalTaxAfterDiscount != 0)
              Column(
                children: [
                  Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tax",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                      Text(
                        "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.totalTaxAfterCouponDiscount)}",
                        style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),

            // ///
            // widget.b2bOrderModel["redeemRewardData"].isEmpty || widget.b2bOrderModel["redeemRewardData"]["tradeRedeemRewardValue"] == 0
            //     ? SizedBox()
            //     : Column(
            //         children: [
            //           Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 "TradeMantri Redeem Reward value",
            //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            //               ),
            //               Text(
            //                 "₹ ${widget.b2bOrderModel["redeemRewardData"]["tradeRedeemRewardValue"]}",
            //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),

            // ///
            // widget.b2bOrderModel!.redeemRewardData!.isEmpty || widget.b2bOrderModel!.redeemRewardData!["redeemRewardValue"] == 0
            //     ? SizedBox()
            //     : Column(
            //         children: [
            //           Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 "Redeem Reward value",
            //                 style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //               ),
            //               Text(
            //                 "₹ ${numFormat.format(widget.b2bOrderModel!.redeemRewardData!["redeemRewardValue"] ?? 0)}",
            //                 style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),

            ///
            Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            Column(
              children: [
                SizedBox(height: heightDp! * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: fontSp! * 14,
                        // color: ((widget.b2bOrderModel!.paymentDetail!.toPay! - (widget.b2bOrderModel!.redeemRewardData!["redeemRewardValue"] ?? 0)) <= 0)
                        //     ? Colors.red
                        //     : Colors.black,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.totalOriginPrice! - widget.b2bOrderModel!.paymentDetail!.totalCouponDiscount!)}",
                      // "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.totalOriginPrice! - widget.b2bOrderModel!.paymentDetail!.totalCouponDiscount! - (widget.b2bOrderModel!.redeemRewardData!["redeemRewardValue"] ?? 0))}",
                      style: TextStyle(
                        fontSize: fontSp! * 14,
                        // color:
                        //     ((widget.b2bOrderModel!.paymentDetail!.toPay! - (widget.b2bOrderModel!.redeemRewardData!["redeemRewardValue"] ?? 0)) <= 0)
                        //         ? Colors.red
                        //         : Colors.black,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            ///
            Divider(height: heightDp! * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
            Text(
              "Disclaimer : The total price doesn’t include the delivery charges, TradeMantri redeemed rewards and promo code discount.",
              style: TextStyle(
                fontSize: fontSp! * 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    });
  }

  // void _deliveryBreakdownDialog() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return BottomSheet(
  //         backgroundColor: Colors.transparent,
  //         onClosing: () {},
  //         builder: (context) {
  //           return Column(
  //             children: [
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Container(color: Colors.transparent),
  //                 ),
  //               ),
  //               Container(
  //                 width: deviceWidth,
  //                 padding: EdgeInsets.symmetric(horizontal: widthDp! * 15, vertical: heightDp! * 15),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(heightDp! * 20), topRight: Radius.circular(heightDp! * 20)),
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           "Delivery Charges Breakdown",
  //                           style: TextStyle(fontSize: fontSp! * 18, color: Colors.black, fontWeight: FontWeight.w500),
  //                         ),
  //                         GestureDetector(
  //                           onTap: () {
  //                             Navigator.of(context).pop();
  //                           },
  //                           child: Padding(
  //                             padding: EdgeInsets.only(left: widthDp! * 10),
  //                             child: Icon(Icons.close, size: heightDp! * 25, color: Colors.black),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                     SizedBox(height: heightDp! * 20),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           "Delivery partner name",
  //                           style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
  //                         ),
  //                         Text(
  //                           "${widget.b2bOrderModel!.deliveryPartnerDetails!["deliveryPartnerName"]}",
  //                           style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: heightDp! * 5),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           "Total distance",
  //                           style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
  //                         ),
  //                         Text(
  //                           "${(widget.b2bOrderModel!.deliveryAddress!.distance! / 1000).toStringAsFixed(3)} Km",
  //                           style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: heightDp! * 5),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           "Distance Charge",
  //                           style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
  //                         ),
  //                         Text(
  //                           "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.deliveryChargeBeforeDiscount)}",
  //                           style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
  //                         ),
  //                       ],
  //                     ),
  //                     Column(
  //                       children: [
  //                         SizedBox(height: heightDp! * 5),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Text(
  //                               "Distance Discount",
  //                               style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
  //                             ),
  //                             Text(
  //                               "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.deliveryDiscount)}",
  //                               style: TextStyle(fontSize: fontSp! * 14, color: Colors.black),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     Divider(height: heightDp! * 20, thickness: 1, color: Colors.black.withOpacity(0.1)),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           "Total",
  //                           style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
  //                         ),
  //                         Text(
  //                           "₹ ${numFormat.format(widget.b2bOrderModel!.paymentDetail!.deliveryChargeAfterDiscount)}",
  //                           style: TextStyle(fontSize: fontSp! * 14, color: Colors.black, fontWeight: FontWeight.bold),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
