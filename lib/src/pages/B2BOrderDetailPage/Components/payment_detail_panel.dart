// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class PaymentDetailPanel extends StatefulWidget {
//   final Map<String, dynamic>? orderData;

//   PaymentDetailPanel({@required this.orderData});

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
//     if (widget.orderData!["paymentDetail"] == null ||
//         widget.orderData!["paymentDetail"]["toPay"] == 0 ||
//         widget.orderData!["paymentDetail"]["totalPriceBeforePromocode"] == 0) {
//       return SizedBox();
//     }

//     int redeemRewardValue = 0;
//     if (widget.orderData!["paymentDetail"]["redeemRewardValue"] != null) {
//       redeemRewardValue = widget.orderData!["paymentDetail"]["redeemRewardValue"];
//     }
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ///
//           Text(
//             "Payment Detail",
//             style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
//           ),

//           ///
//           SizedBox(height: heightDp * 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Total Count",
//                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//               ),
//               Text(
//                 "${widget.orderData!["paymentDetail"]["totalQuantity"]}",
//                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//               ),
//             ],
//           ),

//           ///
//           Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//           Column(
//             children: [
//               SizedBox(height: heightDp * 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Total Price",
//                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                   ),
//                   Text(
//                     "₹ ${(widget.orderData!["paymentDetail"]["totalPriceBeforePromocode"] - redeemRewardValue).toStringAsFixed(2)}",
//                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           ///
//           Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Total Item Price",
//                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     "₹ ${(widget.orderData!["paymentDetail"]["totalPriceBeforePromocode"] - widget.orderData!["paymentDetail"]["totalTax"]).toStringAsFixed(2)}",
//                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           ///
//           widget.orderData!["paymentDetail"]["totalTax"] == 0
//               ? SizedBox()
//               : Column(
//                   children: [
//                     Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Tax",
//                           style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                         ),
//                         Text(
//                           "₹ ${widget.orderData!["paymentDetail"]["totalTax"].toStringAsFixed(2)}",
//                           style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//           ///
//           redeemRewardValue == 0
//               ? SizedBox()
//               : Column(
//                   children: [
//                     Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Redeem Reward Value",
//                           style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                         ),
//                         Text(
//                           "₹ $redeemRewardValue",
//                           style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//         ],
//       ),
//     );
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
//                             "Total distance",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                           Text(
//                             "${widget.orderData!["paymentDetail"]["distance"]} Km",
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
//                             "₹ ${widget.orderData!["paymentDetail"]["deliveryCargeBeforePromocode"].toStringAsFixed(2)}",
//                             style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                       widget.orderData!["paymentDetail"]["deliveryDiscount"] == 0
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
//                                       "₹ ${widget.orderData!["paymentDetail"]["deliveryDiscount"].toStringAsFixed(2)}",
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
//                             "₹ ${widget.orderData!["paymentDetail"]["deliveryCargeAfterPromocode"].toStringAsFixed(2)}",
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
