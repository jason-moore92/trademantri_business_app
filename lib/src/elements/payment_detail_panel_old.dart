// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:trapp/src/helpers/price_functions.dart';
// import 'package:trapp/src/providers/index.dart';

// class PaymentDetailPanel extends StatefulWidget {
//   final Map<String, dynamic>? storeData;
//   final Map<String, dynamic>? orderData;

//   PaymentDetailPanel({
//     @required this.storeData,
//     @required this.orderData,
//   });

//   @override
//   _PaymentDetailPanelState createState() => _PaymentDetailPanelState();
// }

// class _PaymentDetailPanelState extends State<PaymentDetailPanel> {
//   /// Responsive design variables
//   double deviceWidth = 0;
//   double deviceHeight = 0;
//   double statusbarHeight = 0;
//   double bottomBarHeight = 0;
//   double appbarHeight = 0;
//   double widthDp = 0;
//   double heightDp = 0;
//   double heightDp1 = 0;
//   double fontSp = 0;
//   ///////////////////////////////

//   @override
//   void initState() {
//     super.initState();

//     /// Responsive design variables
//     deviceWidth = 1.sw;
//     deviceHeight = 1.sh;
//     statusbarHeight = ScreenUtil().statusBarHeight;
//     bottomBarHeight = ScreenUtil().bottomBarHeight;
//     appbarHeight = AppBar().preferredSize.height;
//     widthDp = ScreenUtil().setWidth(1);
//     heightDp = ScreenUtil().setWidth(1);
//     heightDp1 = ScreenUtil().setHeight(1);
//     fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
//     ///////////////////////////////
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DeliveryAddressProvider>(builder: (context, deliveryAddressProvider, _) {
//       double totalQuantity = 0;
//       double totalPrice = 0;
//       double totalOriginPrice = 0;
//       double totalTax = 0;
//       double totalTaxBeforePromocode = 0;
//       double deliveryPrice = 0;
//       double deliveryDiscount = 0;
//       double tip = 0;

//       if (widget.orderData!["tip"] != null) {
//         tip = widget.orderData!["tip"].toDouble();
//       }

//       //////////// Delivery Price ////////////////////
//       if (widget.orderData!["deliveryPartnerDetails"] != null && widget.orderData!["deliveryPartnerDetails"].isNotEmpty) {
//         deliveryPrice = widget.orderData!["deliveryPartnerDetails"]["charge"]["deliveryPrice"];

//         if (widget.orderData!["promocode"] != null &&
//             widget.orderData!["promocode"].isNotEmpty &&
//             widget.orderData!["promocode"]["promocodeType"] == "Delivery") {
//           deliveryDiscount = (double.parse(widget.orderData!["promocode"]["promocodeValue"].toString()) * deliveryPrice / 100);
//         }
//       }
//       //////////////////////////////////////////////////

//       var result = PriceFunctions.getTotalPriceOfOrder(orderData: widget.orderData);
//       totalQuantity = result["totalQuantity"];
//       totalPrice = result["totalPrice"];
//       totalOriginPrice = result["totalOriginPrice"];
//       totalTax = result["totalTax"];
//       totalTaxBeforePromocode = result["totalTaxBeforePromocode"];

//       widget.orderData!["paymentDetail"] = {
//         "totalQuantity": totalQuantity,
//         "promocode": widget.orderData!["promocode"] != null ? widget.orderData!["promocode"]["promocodeCode"] : "",
//         "totalPriceBeforePromocode": double.parse(totalOriginPrice.toStringAsFixed(2)),
//         "totalPriceAfterPromocode": double.parse(totalPrice.toStringAsFixed(2)),
//         "deliveryCargeBeforePromocode": double.parse(deliveryPrice.toStringAsFixed(2)),
//         "deliveryCargeAfterPromocode": double.parse((deliveryPrice - deliveryDiscount).toStringAsFixed(2)),
//         "deliveryDiscount": double.parse(deliveryDiscount.toStringAsFixed(2)),
//         "distance": widget.orderData!["deliveryAddress"] != null && widget.orderData!["deliveryAddress"].isNotEmpty
//             ? (widget.orderData!["deliveryAddress"]["distance"] / 1000).toStringAsFixed(3)
//             : 0,
//         "tip": double.parse((tip).toStringAsFixed(2)),
//         "totalTax": double.parse(totalTax.toStringAsFixed(2)),
//         "totalTaxBeforePromocode": double.parse(totalTaxBeforePromocode.toStringAsFixed(2)),
//         // "redeemRewardValue": widget.orderData!["paymentDetail"] == null || widget.orderData!["redeemRewardData"]["redeemRewardValue"] == null
//         //     ? 0
//         //     : widget.orderData!["redeemRewardData"]["redeemRewardValue"],
//         // "redeemRewardPoint": widget.orderData!["paymentDetail"] == null || widget.orderData!["redeemRewardData"]["redeemRewardPoint"] == null
//         //     ? 0
//         //     : widget.orderData!["redeemRewardData"]["redeemRewardPoint"],
//         "toPay": double.parse((totalPrice + deliveryPrice - deliveryDiscount + tip).toStringAsFixed(2)),
//       };

//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ///
//             Text(
//               "Payment Detail",
//               style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
//             ),

//             ///
//             SizedBox(height: heightDp * 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total Count",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 ),
//                 Text(
//                   "$totalQuantity",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 ),
//               ],
//             ),

//             ///
//             Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total Price",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       "₹ ${totalPrice.toStringAsFixed(2)}",
//                       style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                     ),
//                     totalPrice == totalOriginPrice
//                         ? SizedBox()
//                         : Row(
//                             children: [
//                               SizedBox(width: widthDp * 5),
//                               Text(
//                                 "₹ ${totalOriginPrice.toStringAsFixed(2)}",
//                                 style: TextStyle(
//                                   fontSize: fontSp * 12,
//                                   color: Colors.grey,
//                                   decoration: TextDecoration.lineThrough,
//                                   decorationThickness: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ],
//                 ),
//               ],
//             ),

//             ///
//             Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total Item Price",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       "₹ ${(totalPrice - totalTax).toStringAsFixed(2)}",
//                       style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                     ),
//                     totalPrice == totalOriginPrice
//                         ? SizedBox()
//                         : Row(
//                             children: [
//                               SizedBox(width: widthDp * 5),
//                               Text(
//                                 "₹ ${(totalOriginPrice - totalTaxBeforePromocode).toStringAsFixed(2)}",
//                                 style: TextStyle(
//                                   fontSize: fontSp * 12,
//                                   color: Colors.grey,
//                                   decoration: TextDecoration.lineThrough,
//                                   decorationThickness: 2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ],
//                 ),
//               ],
//             ),

//             ///
//             widget.orderData!["promocode"] == null || widget.orderData!["promocode"].isEmpty
//                 ? SizedBox()
//                 : Column(
//                     children: [
//                       Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Promo code applied",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                           Text(
//                             "${widget.orderData!["promocode"]["promocodeCode"]}",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//             ///
//             widget.orderData!["deliveryAddress"] == null || widget.orderData!["deliveryAddress"].isEmpty || deliveryPrice == 0
//                 ? SizedBox()
//                 : Column(
//                     children: [
//                       Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 "Delivery Price",
//                                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   _deliveryBreakdownDialog();
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
//                                   color: Colors.transparent,
//                                   child: Icon(Icons.info_outline, size: heightDp * 20, color: Colors.black.withOpacity(0.6)),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 "₹ ${(deliveryPrice - deliveryDiscount).toStringAsFixed(2)}",
//                                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                               ),
//                               deliveryDiscount == 0
//                                   ? SizedBox()
//                                   : Row(
//                                       children: [
//                                         SizedBox(width: widthDp * 5),
//                                         Text(
//                                           "₹ ${(deliveryPrice).toStringAsFixed(2)}",
//                                           style: TextStyle(
//                                             fontSize: fontSp * 12,
//                                             color: Colors.grey,
//                                             decoration: TextDecoration.lineThrough,
//                                             decorationThickness: 2,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//             ///
//             tip == 0
//                 ? SizedBox()
//                 : Column(
//                     children: [
//                       Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Tip",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                           Text(
//                             "₹ ${tip.toStringAsFixed(2)}",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//             ///
//             totalTax == 0
//                 ? SizedBox()
//                 : Column(
//                     children: [
//                       Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Tax",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                           Text(
//                             "₹ ${totalTax.toStringAsFixed(2)}",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//             // ///
//             // widget.orderData!["redeemRewardData"] == null || widget.orderData!["redeemRewardData"]["tradeRedeemRewardValue"] == 0
//             //     ? SizedBox()
//             //     : Column(
//             //         children: [
//             //           Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//             //           Row(
//             //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //             children: [
//             //               Text(
//             //                 "TradeMantri Redeem Reward value",
//             //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//             //               ),
//             //               Text(
//             //                 "₹ ${widget.orderData!["redeemRewardData"]["tradeRedeemRewardValue"]}",
//             //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//             //               ),
//             //             ],
//             //           ),
//             //         ],
//             //       ),

//             ///
//             widget.orderData!["redeemRewardData"] == null || widget.orderData!["redeemRewardData"]["redeemRewardValue"] == 0
//                 ? SizedBox()
//                 : Column(
//                     children: [
//                       Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Redeem Reward value",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                           Text(
//                             "₹ ${widget.orderData!["redeemRewardData"]["redeemRewardValue"]}",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//             ///
//             Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//             Column(
//               children: [
//                 SizedBox(height: heightDp * 5),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "To Pay",
//                       style: TextStyle(
//                         fontSize: fontSp * 14,
//                         color: ((widget.orderData!["paymentDetail"]["toPay"] - widget.orderData!["redeemRewardData"]["redeemRewardValue"]) <= 0)
//                             ? Colors.red
//                             : Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "₹ ${(totalPrice + deliveryPrice - deliveryDiscount + tip - widget.orderData!["redeemRewardData"]["redeemRewardValue"]).toStringAsFixed(2)}",
//                       style: TextStyle(
//                         fontSize: fontSp * 14,
//                         color: ((widget.orderData!["paymentDetail"]["toPay"] - widget.orderData!["redeemRewardData"]["redeemRewardValue"]) <= 0)
//                             ? Colors.red
//                             : Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   void _deliveryBreakdownDialog() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return BottomSheet(
//           backgroundColor: Colors.transparent,
//           onClosing: () {},
//           builder: (context) {
//             double deliveryPrice = widget.orderData!["deliveryPartnerDetails"]["charge"]["deliveryPrice"];
//             double deliveryDiscount = 0;

//             if (widget.orderData!["promocode"] != null &&
//                 widget.orderData!["promocode"].isNotEmpty &&
//                 widget.orderData!["promocode"]["promocodeType"] == "Delivery") {
//               deliveryDiscount = (double.parse(widget.orderData!["promocode"]["promocodeValue"].toString()) * deliveryPrice / 100);
//             }

//             return Column(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(color: Colors.transparent),
//                   ),
//                 ),
//                 Container(
//                   width: deviceWidth,
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 15),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(heightDp * 20), topRight: Radius.circular(heightDp * 20)),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Delivery Charges Breakdown",
//                             style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.only(left: widthDp * 10),
//                               child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: heightDp * 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Delivery partner name",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                           Text(
//                             "${widget.orderData!["deliveryPartnerDetails"]["deliveryPartnerName"]}",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: heightDp * 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Total distance",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                           Text(
//                             "${(widget.orderData!["deliveryAddress"]["distance"] / 1000).toStringAsFixed(3)} Km",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: heightDp * 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Distance Charge",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                           Text(
//                             "₹ ${deliveryPrice.toStringAsFixed(2)}",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                       deliveryDiscount == 0
//                           ? SizedBox()
//                           : Column(
//                               children: [
//                                 SizedBox(height: heightDp * 5),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Distance Discount",
//                                       style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                                     ),
//                                     Text(
//                                       "₹ ${deliveryDiscount.toStringAsFixed(2)}",
//                                       style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                       Divider(height: heightDp * 20, thickness: 1, color: Colors.black.withOpacity(0.1)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Total",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "₹ ${(deliveryPrice - deliveryDiscount).toStringAsFixed(2)}",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
