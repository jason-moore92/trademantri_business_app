// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:share/share.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:trapp/config/config.dart';
// import 'package:trapp/src/elements/keicy_raised_button.dart';
// import 'package:trapp/src/helpers/date_time_convert.dart';
// import 'package:trapp/config/app_config.dart' as config;
// import 'package:url_launcher/url_launcher.dart';

// import 'keicy_checkbox.dart';

// class OrderWidget extends StatefulWidget {
//   final Map<String, dynamic>? orderData;
//   final bool? loadingStatus;
//   final bool isShowCard;
//   final Function()? acceptCallback;
//   final Function()? rejectCallback;
//   final Function()? pickupReadyCallback;
//   final Function()? deliveryReadyCallback;
//   final Function()? completeCallback;
//   final Function()? detailCallback;
//   final Function()? payCallback;

//   OrderWidget({
//     @required this.orderData,
//     @required this.loadingStatus,
//     this.isShowCard = true,
//     this.acceptCallback,
//     this.rejectCallback,
//     this.pickupReadyCallback,
//     this.deliveryReadyCallback,
//     this.completeCallback,
//     this.detailCallback,
//     this.payCallback,
//   });

//   @override
//   _OrderWidgetState createState() => _OrderWidgetState();
// }

// class _OrderWidgetState extends State<OrderWidget> {
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
//     return Card(
//       margin: widget.isShowCard
//           ? EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10)
//           : EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
//       elevation: widget.isShowCard ? 5 : 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 8)),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(heightDp * 8),
//           border: widget.isShowCard ? null : Border.all(color: Colors.grey.withOpacity(0.4)),
//         ),
//         child: widget.loadingStatus! ? _shimmerWidget() : _orderWidget(),
//       ),
//     );
//   }

//   Widget _shimmerWidget() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       direction: ShimmerDirection.ltr,
//       enabled: widget.loadingStatus!,
//       period: Duration(milliseconds: 1000),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "OrderID",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "2021-04-05",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//           Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "User Name:",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "Userfirst  last Name:",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: heightDp * 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "User Mobile:",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "123456780",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),
//           Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

//           ///
//           Column(
//             children: [
//               SizedBox(height: heightDp * 5),
//               Container(
//                 width: deviceWidth,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       color: Colors.white,
//                       child: Text(
//                         "Order Type: ",
//                         style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Container(
//                       color: Colors.white,
//                       child: Text(
//                         "orderType",
//                         style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           ///
//           Column(
//             children: [
//               SizedBox(height: heightDp * 5),
//               Container(
//                 width: deviceWidth,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       color: Colors.white,
//                       child: Text(
//                         "Order Type: ",
//                         style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Container(
//                       color: Colors.white,
//                       child: Text(
//                         "orderType",
//                         style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           ///
//           SizedBox(height: heightDp * 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "To Pay: ",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "₹ 1375.23",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: heightDp * 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "Order Status: ",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "orderStatus ",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                 ),
//               ),
//             ],
//           ),

//           Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

//           ///
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               KeicyRaisedButton(
//                 width: widthDp * 100,
//                 height: heightDp * 30,
//                 color: Colors.white,
//                 borderRadius: heightDp * 8,
//                 child: Text(
//                   "Accept",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
//                 ),
//                 onPressed: () {
//                   ///
//                 },
//               ),
//               KeicyRaisedButton(
//                 width: widthDp * 100,
//                 height: heightDp * 30,
//                 color: Colors.white,
//                 borderRadius: heightDp * 8,
//                 child: Text(
//                   "Reject",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
//                 ),
//                 onPressed: () {
//                   ///
//                 },
//               ),
//               KeicyRaisedButton(
//                 width: widthDp * 120,
//                 height: heightDp * 30,
//                 color: Colors.white,
//                 borderRadius: heightDp * 8,
//                 padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
//                     Text(
//                       "To detail",
//                       style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
//                     ),
//                     Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
//                   ],
//                 ),
//                 onPressed: () {
//                   ///
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _orderWidget() {
//     String orderStatus = "";
//     for (var i = 0; i < AppConfig.orderStatusData.length; i++) {
//       print(widget.orderData!["status"]);
//       if (widget.orderData!["status"] == AppConfig.orderStatusData[i]["id"]) {
//         orderStatus = AppConfig.orderStatusData[i]["name"];
//         break;
//       }
//     }

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
//               decoration: BoxDecoration(
//                 color: widget.orderData!["payStatus"] ? Colors.green : Colors.red,
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(heightDp * 6),
//                   bottomRight: Radius.circular(heightDp * 6),
//                 ),
//               ),
//               child: Text(
//                 widget.orderData!["payStatus"] ? "Paid" : "Not Paid",
//                 style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
//               ),
//             ),
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     if (await canLaunch(widget.orderData!["invoicePdfUrlForStore"] ?? widget.orderData!["invoicePdfUrl"])) {
//                       await launch(
//                         widget.orderData!["invoicePdfUrlForStore"] ?? widget.orderData!["invoicePdfUrl"],
//                         forceSafariVC: false,
//                         forceWebView: false,
//                       );
//                     } else {
//                       throw 'Could not launch ${widget.orderData!["invoicePdfUrlForStore"] ?? widget.orderData!["invoicePdfUrl"]}';
//                     }
//                   },
//                   child: Image.asset("img/pdf-icon.png", width: heightDp * 30, height: heightDp * 30, fit: BoxFit.cover),
//                 ),
//                 SizedBox(width: widthDp * 30),
//                 GestureDetector(
//                   onTap: () {
//                     Share.share(widget.orderData!["invoicePdfUrlForStore"] ?? widget.orderData!["invoicePdfUrl"]);
//                   },
//                   child: Image.asset(
//                     "img/share-icon.png",
//                     width: heightDp * 30,
//                     height: heightDp * 30,
//                     fit: BoxFit.cover,
//                     color: config.Colors().mainColor(1),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(height: heightDp * 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               widget.orderData!["orderId"],
//               style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               KeicyDateTime.convertDateTimeToDateString(
//                 dateTime: DateTime.parse(widget.orderData!["updatedAt"]),
//                 formats: "Y-m-d H:i",
//                 isUTC: false,
//               ),
//               style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//             ),
//           ],
//         ),
//         Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "User Name:",
//               style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               "${widget.orderData!["user"]["firstName"]} ${widget.orderData!["user"]["lastName"]}",
//               style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//             ),
//           ],
//         ),
//         Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

//         ///
//         Column(
//           children: [
//             SizedBox(height: heightDp * 5),
//             Container(
//               width: deviceWidth,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Order Type: ",
//                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     widget.orderData!["orderType"] ?? "",
//                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),

//         ///
//         widget.orderData!["products"] == null ||
//                 widget.orderData!["products"].isEmpty ||
//                 widget.orderData!["orderType"] != "Pickup" ||
//                 widget.orderData!['pickupDateTime'] == null
//             ? SizedBox()
//             : Column(
//                 children: [
//                   SizedBox(height: heightDp * 5),
//                   Container(
//                     width: deviceWidth,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Pickup Date:",
//                           style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           KeicyDateTime.convertDateTimeToDateString(
//                             dateTime: DateTime.tryParse(widget.orderData!['pickupDateTime']),
//                             formats: 'Y-m-d h:i A',
//                             isUTC: false,
//                           ),
//                           style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//         ///
//         widget.orderData!["products"] == null ||
//                 widget.orderData!["products"].isEmpty ||
//                 widget.orderData!["orderType"] != "Delivery" ||
//                 widget.orderData!['deliveryAddress'] == null
//             ? SizedBox()
//             : Column(
//                 children: [
//                   SizedBox(height: heightDp * 5),
//                   Container(
//                     width: deviceWidth,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Delivery Address:",
//                           style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: heightDp * 5),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   "${widget.orderData!["deliveryAddress"]["addressType"]}",
//                                   style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.bold),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(width: widthDp * 10),
//                                 Text(
//                                   "${(widget.orderData!["deliveryAddress"]["distance"] / 1000).toStringAsFixed(3)} Km",
//                                   style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: heightDp * 5),
//                             widget.orderData!["deliveryAddress"]["building"] == null || widget.orderData!["deliveryAddress"]["building"] == ""
//                                 ? SizedBox()
//                                 : Column(
//                                     children: [
//                                       Text(
//                                         "${widget.orderData!["deliveryAddress"]["building"]}",
//                                         style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       SizedBox(height: heightDp * 5),
//                                     ],
//                                   ),
//                             Text(
//                               "${widget.orderData!["deliveryAddress"]["address"]["address"]}",
//                               style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             SizedBox(height: heightDp * 5),
//                             KeicyCheckBox(
//                               iconSize: heightDp * 20,
//                               iconColor: Color(0xFF00D18F),
//                               labelSpacing: widthDp * 10,
//                               label: "No Contact Delivery",
//                               labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
//                               value: widget.orderData!["noContactDelivery"],
//                               readOnly: true,
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//         ///
//         SizedBox(height: heightDp * 5),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "To Pay: ",
//               style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               "₹ ${widget.orderData!["paymentDetail"]["toPay"]}",
//               style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//             ),
//           ],
//         ),

//         SizedBox(height: heightDp * 5),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Order Status: ",
//               style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               orderStatus,
//               style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//             ),
//           ],
//         ),

//         Divider(height: heightDp * 15, thickness: 1, color: Colors.grey.withOpacity(0.6)),

//         ///
//         if (widget.orderData!["status"] == AppConfig.orderStatusData[1]["id"])
//           _placeOrderButtonGroup()
//         else if (widget.orderData!["status"] == AppConfig.orderStatusData[2]["id"])
//           _acceptedOrderButtonGroup()
//         else if (widget.orderData!["status"] == AppConfig.orderStatusData[3]["id"])
//           _paidOrderButtonGroup()
//         else if (widget.orderData!["status"] == AppConfig.orderStatusData[4]["id"] ||
//             widget.orderData!["status"] == AppConfig.orderStatusData[5]["id"])
//           _pickupCompleteButtonGroup()
//         else
//           _detailButton(),
//       ],
//     );
//   }

//   Widget _placeOrderButtonGroup() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         KeicyRaisedButton(
//           width: widthDp * 100,
//           height: heightDp * 30,
//           color: config.Colors().mainColor(1),
//           borderRadius: heightDp * 8,
//           child: Text(
//             "Accept",
//             style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
//           ),
//           onPressed: widget.acceptCallback,
//         ),
//         KeicyRaisedButton(
//           width: widthDp * 100,
//           height: heightDp * 30,
//           color: config.Colors().mainColor(1),
//           borderRadius: heightDp * 8,
//           child: Text(
//             "Reject",
//             style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//           ),
//           onPressed: widget.rejectCallback,
//         ),
//         KeicyRaisedButton(
//           width: widthDp * 120,
//           height: heightDp * 30,
//           color: config.Colors().mainColor(1),
//           borderRadius: heightDp * 8,
//           padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
//               Text(
//                 "To detail",
//                 style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//               ),
//               Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
//             ],
//           ),
//           onPressed: widget.detailCallback,
//         ),
//       ],
//     );
//   }

//   Widget _detailButton() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         KeicyRaisedButton(
//           width: widthDp * 170,
//           height: heightDp * 30,
//           color: config.Colors().mainColor(1),
//           borderRadius: heightDp * 8,
//           padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
//               Text(
//                 "To detail",
//                 style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//               ),
//               Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
//             ],
//           ),
//           onPressed: widget.detailCallback,
//         ),
//       ],
//     );
//   }

//   Widget _paidOrderButtonGroup() {
//     return Container(
//       width: deviceWidth,
//       child: Wrap(
//         alignment: WrapAlignment.spaceAround,
//         runSpacing: heightDp * 10,
//         children: [
//           if (!widget.orderData!["pickupDeliverySatus"] && widget.orderData!["orderType"] != "Service")
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 KeicyRaisedButton(
//                   width: widthDp * 170,
//                   height: heightDp * 30,
//                   color: Colors.grey.withOpacity(0.5),
//                   // color: config.Colors().mainColor(1),
//                   borderRadius: heightDp * 8,
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                   child: Text(
//                     widget.orderData!["orderType"] == "Pickup" ? "Change Pick Date" : "Change Delivery Status",
//                     style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                   ),
//                   onPressed: () {
//                     // OrderAcceptDialog.show(context, callback: widget.acceptCallback);
//                   },
//                 ),
//                 KeicyRaisedButton(
//                   width: widthDp * 170,
//                   height: heightDp * 30,
//                   color: config.Colors().mainColor(1),
//                   borderRadius: heightDp * 8,
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                   child: Text(
//                     widget.orderData!["orderType"] == "Pickup" ? "Pickup Ready" : "Delivery Ready",
//                     style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                   ),
//                   onPressed: () {
//                     if (widget.orderData!["orderType"] == "Pickup") {
//                       widget.pickupReadyCallback!();
//                     } else {
//                       widget.deliveryReadyCallback!();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               KeicyRaisedButton(
//                 width: widthDp * 170,
//                 height: heightDp * 30,
//                 color: config.Colors().mainColor(1),
//                 borderRadius: heightDp * 8,
//                 padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                 child: Text(
//                   "Order Complete",
//                   style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                 ),
//                 onPressed: widget.completeCallback,
//               ),
//               KeicyRaisedButton(
//                 width: widthDp * 170,
//                 height: heightDp * 30,
//                 color: config.Colors().mainColor(1),
//                 borderRadius: heightDp * 8,
//                 padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
//                     Text(
//                       "To detail",
//                       style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                     ),
//                     Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
//                   ],
//                 ),
//                 onPressed: widget.detailCallback,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _acceptedOrderButtonGroup() {
//     return Column(
//       children: [
//         if (widget.orderData!["orderType"] != "Service")
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               KeicyRaisedButton(
//                 width: widthDp * 170,
//                 height: heightDp * 30,
//                 color: Colors.grey.withOpacity(0.5),
//                 // color: config.Colors().mainColor(1),
//                 borderRadius: heightDp * 8,
//                 padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                 child: Text(
//                   widget.orderData!["orderType"] == "Pickup" ? "Change Pick Date" : "Change Delivery Status",
//                   style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                 ),
//                 onPressed: () {
//                   // OrderAcceptDialog.show(context, callback: widget.acceptCallback);
//                 },
//               ),
//               KeicyRaisedButton(
//                 width: widthDp * 170,
//                 height: heightDp * 30,
//                 color: config.Colors().mainColor(1),
//                 borderRadius: heightDp * 8,
//                 padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                 child: Text(
//                   widget.orderData!["orderType"] == "Pickup" ? "Pickup Ready" : "Delivery Ready",
//                   style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                 ),
//                 onPressed: () {
//                   if (widget.orderData!["orderType"] == "Pickup") {
//                     widget.pickupReadyCallback!();
//                   } else {
//                     widget.deliveryReadyCallback!();
//                   }
//                 },
//               ),
//             ],
//           )
//         else
//           SizedBox(),
//         if (widget.orderData!["orderType"] != "Service") SizedBox(height: heightDp * 10) else SizedBox(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             if (widget.orderData!["payAtStore"] || widget.orderData!["cashOnDelivery"])
//               KeicyRaisedButton(
//                 width: widthDp * 170,
//                 height: heightDp * 30,
//                 color: config.Colors().mainColor(1),
//                 borderRadius: heightDp * 8,
//                 padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                 child: Text(
//                   "Payment Done",
//                   style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                 ),
//                 onPressed: widget.payCallback,
//               ),
//             KeicyRaisedButton(
//               width: widthDp * 170,
//               height: heightDp * 30,
//               color: config.Colors().mainColor(1),
//               borderRadius: heightDp * 8,
//               padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
//                   Text(
//                     "To detail",
//                     style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                   ),
//                   Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
//                 ],
//               ),
//               onPressed: widget.detailCallback,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _pickupCompleteButtonGroup() {
//     return Container(
//       width: deviceWidth,
//       child: Wrap(
//         alignment: WrapAlignment.spaceAround,
//         runSpacing: heightDp * 10,
//         children: [
//           if (widget.orderData!["payStatus"])
//             KeicyRaisedButton(
//               width: widthDp * 170,
//               height: heightDp * 30,
//               color: config.Colors().mainColor(1),
//               borderRadius: heightDp * 8,
//               padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//               child: Text(
//                 widget.orderData!["orderType"] == "Pickup" ? "Pickup Order Complete" : "Delivery Order Complete",
//                 style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//               ),
//               onPressed: widget.completeCallback,
//             ),
//           if (!widget.orderData!["payStatus"] && (widget.orderData!["payAtStore"] || widget.orderData!["cashOnDelivery"]))
//             KeicyRaisedButton(
//               width: widthDp * 170,
//               height: heightDp * 30,
//               color: config.Colors().mainColor(1),
//               borderRadius: heightDp * 8,
//               padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//               child: Text(
//                 "Payment Done",
//                 style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//               ),
//               onPressed: widget.payCallback,
//             ),
//           KeicyRaisedButton(
//             width: widthDp * 170,
//             height: heightDp * 30,
//             color: config.Colors().mainColor(1),
//             borderRadius: heightDp * 8,
//             padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.transparent),
//                 Text(
//                   "To detail",
//                   style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                 ),
//                 Icon(Icons.arrow_forward_ios, size: heightDp * 15, color: Colors.white),
//               ],
//             ),
//             onPressed: widget.detailCallback,
//           ),
//         ],
//       ),
//     );
//   }
// }
