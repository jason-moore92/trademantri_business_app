// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:share/share.dart';
// import 'package:trapp/config/config.dart';
// import 'package:trapp/src/dialogs/index.dart';
// import 'package:trapp/src/elements/keicy_progress_dialog.dart';
// import 'package:trapp/src/elements/keicy_raised_button.dart';
// import 'package:trapp/src/elements/qr_code_widget.dart';
// import 'package:trapp/src/elements/user_info_panel.dart';
// import 'package:trapp/src/helpers/date_time_convert.dart';
// import 'package:trapp/src/helpers/encrypt.dart';
// import 'package:trapp/src/providers/index.dart';
// import 'package:trapp/config/app_config.dart' as config;
// import 'package:trapp/src/elements/keicy_checkbox.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:json_diff/json_diff.dart';

// import 'index.dart';

// class OrderDetailView extends StatefulWidget {
//   Map<String, dynamic>? orderData;

//   OrderDetailView({Key? key, this.orderData}) : super(key: key);

//   @override
//   _OrderDetailViewState createState() => _OrderDetailViewState();
// }

// class _OrderDetailViewState extends State<OrderDetailView> {
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

//   OrderProvider? _orderProvider;
//   KeicyProgressDialog? _keicyProgressDialog;

//   Map<String, dynamic>? _orderData;

//   String? updatedOrderStatus;

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

//     _orderProvider = OrderProvider.of(context);
//     _keicyProgressDialog = KeicyProgressDialog.of(context);

//     _orderData = json.decode(json.encode(widget.orderData));
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
//           onPressed: () {
//             Navigator.of(context).pop(updatedOrderStatus);
//           },
//         ),
//         centerTitle: true,
//         title: Text("Order Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
//         elevation: 0,
//       ),
//       body: Container(
//         width: deviceWidth,
//         height: deviceHeight,
//         child: _mainPanel(),
//       ),
//     );
//   }

//   Widget _mainPanel() {
//     String orderStatus = "";
//     for (var i = 0; i < AppConfig.orderStatusData.length; i++) {
//       if (_orderData!["status"] == AppConfig.orderStatusData[i]["id"]) {
//         orderStatus = AppConfig.orderStatusData[i]["name"];
//         break;
//       }
//     }

//     return NotificationListener<OverscrollIndicatorNotification>(
//       onNotification: (notification) {
//         notification.disallowGlow();
//         return true;
//       },
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
//           child: Column(
//             children: [
//               Text(
//                 "${_orderData!["orderId"]}",
//                 style: TextStyle(fontSize: fontSp * 21, color: Colors.black),
//               ),

//               ///
//               SizedBox(height: heightDp * 5),
//               QrCodeWidget(
//                 code: Encrypt.encryptString("Order_${_orderData!["orderId"]}_StoreId-${_orderData!["storeId"]}_UserId-${_orderData!["userId"]}"),
//                 width: heightDp * 150,
//                 height: heightDp * 150,
//               ),

//               ///
//               SizedBox(height: heightDp * 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       if (await canLaunch(_orderData!["invoicePdfUrlForStore"] ?? _orderData!["invoicePdfUrl"])) {
//                         await launch(
//                           _orderData!["invoicePdfUrlForStore"] ?? _orderData!["invoicePdfUrl"],
//                           forceSafariVC: false,
//                           forceWebView: false,
//                         );
//                       } else {
//                         throw 'Could not launch ${_orderData!["invoicePdfUrlForStore"] ?? _orderData!["invoicePdfUrl"]}';
//                       }
//                     },
//                     child: Image.asset("img/pdf-icon.png", width: heightDp * 40, height: heightDp * 40, fit: BoxFit.cover),
//                   ),
//                   SizedBox(width: widthDp * 30),
//                   GestureDetector(
//                     onTap: () {
//                       Share.share(_orderData!["invoicePdfUrlForStore"] ?? _orderData!["invoicePdfUrl"]);
//                     },
//                     child: Image.asset(
//                       "img/share-icon.png",
//                       width: heightDp * 40,
//                       height: heightDp * 40,
//                       fit: BoxFit.cover,
//                       color: config.Colors().mainColor(1),
//                     ),
//                   ),
//                 ],
//               ),

//               ///
//               SizedBox(height: heightDp * 15),
//               UserInfoPanel(userData: _orderData!["user"]),

//               ///
//               SizedBox(height: heightDp * 15),
//               CartListPanel(
//                 storeData: _orderData!["store"],
//                 orderData: json.decode(json.encode(_orderData)),
//                 refreshCallback: (Map<String, dynamic>? orderData) {
//                   _orderData = orderData;
//                   setState(() {});
//                 },
//               ),
//               Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

//               ///
//               _orderData!["instructions"] == ""
//                   ? SizedBox()
//                   : Column(
//                       children: [
//                         SizedBox(height: heightDp * 10),
//                         Container(
//                           width: deviceWidth,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(Icons.event_note, size: heightDp * 25, color: Colors.black.withOpacity(0.7)),
//                                   SizedBox(width: widthDp * 10),
//                                   Text(
//                                     "Instruction",
//                                     style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: heightDp * 5),
//                               Text(
//                                 _orderData!["instructions"],
//                                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: heightDp * 10),
//                         Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
//                       ],
//                     ),

//               ///
//               _orderData!["paymentDetail"]["promocode"] == ""
//                   ? SizedBox()
//                   : Column(
//                       children: [
//                         SizedBox(height: heightDp * 10),
//                         Container(
//                           width: deviceWidth,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Promo code: ",
//                                 style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 _orderData!["paymentDetail"]["promocode"],
//                                 style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: heightDp * 10),
//                         Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
//                       ],
//                     ),

//               ///
//               SizedBox(height: heightDp * 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Order Status: ",
//                     style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
//                   ),
//                   Text(
//                     orderStatus,
//                     style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
//                   ),
//                 ],
//               ),
//               if (_orderData!["status"] == AppConfig.orderStatusData[7]["id"] || _orderData!["status"] == AppConfig.orderStatusData[8]["id"])
//                 Column(
//                   children: [
//                     SizedBox(height: heightDp * 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _orderData!["status"] == AppConfig.orderStatusData[7]["id"] ? "Cancel Reason:" : "Reject Reason: ",
//                           style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
//                         ),
//                         SizedBox(width: widthDp * 10),
//                         Expanded(
//                           child: Text(
//                             "${_orderData!["reasonForCancelOrReject"]}",
//                             style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
//                             textAlign: TextAlign.right,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//               SizedBox(height: heightDp * 10),
//               Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

//               ///
//               _orderData!["products"] == null || _orderData!["products"].isEmpty
//                   ? SizedBox()
//                   : Column(
//                       children: [
//                         SizedBox(height: heightDp * 10),
//                         Container(
//                           width: deviceWidth,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Order Type: ",
//                                 style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 _orderData!["orderType"],
//                                 style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: heightDp * 10),
//                         Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
//                       ],
//                     ),

//               ///
//               _orderData!["products"] == null ||
//                       _orderData!["products"].isEmpty ||
//                       _orderData!["orderType"] != "Pickup" ||
//                       _orderData!['pickupDateTime'] == null
//                   ? SizedBox()
//                   : Column(
//                       children: [
//                         SizedBox(height: heightDp * 10),
//                         Container(
//                           width: deviceWidth,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Pickup Date:",
//                                 style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 KeicyDateTime.convertDateTimeToDateString(
//                                   dateTime: DateTime.tryParse(_orderData!['pickupDateTime']),
//                                   formats: 'Y-m-d h:i A',
//                                   isUTC: false,
//                                 ),
//                                 style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: heightDp * 10),
//                         Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
//                       ],
//                     ),

//               ///
//               _orderData!["products"] == null ||
//                       _orderData!["products"].isEmpty ||
//                       _orderData!["orderType"] != "Delivery" ||
//                       _orderData!['deliveryAddress'] == null
//                   ? SizedBox()
//                   : Column(
//                       children: [
//                         SizedBox(height: heightDp * 10),
//                         Container(
//                           width: deviceWidth,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Delivery Address:",
//                                 style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
//                               ),
//                               SizedBox(height: heightDp * 5),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "${_orderData!["deliveryAddress"]["addressType"]}",
//                                         style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       SizedBox(width: widthDp * 10),
//                                       Text(
//                                         "${(_orderData!["deliveryAddress"]["distance"] / 1000).toStringAsFixed(3)} Km",
//                                         style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: heightDp * 5),
//                                   _orderData!["deliveryAddress"]["building"] == null || _orderData!["deliveryAddress"]["building"] == ""
//                                       ? SizedBox()
//                                       : Column(
//                                           children: [
//                                             Text(
//                                               "${_orderData!["deliveryAddress"]["building"]}",
//                                               style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             SizedBox(height: heightDp * 5),
//                                           ],
//                                         ),
//                                   Text(
//                                     "${_orderData!["deliveryAddress"]["address"]["address"]}",
//                                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   SizedBox(height: heightDp * 10),
//                                   KeicyCheckBox(
//                                     iconSize: heightDp * 25,
//                                     iconColor: Color(0xFF00D18F),
//                                     labelSpacing: widthDp * 20,
//                                     label: "No Contact Delivery",
//                                     labelStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
//                                     value: _orderData!["noContactDelivery"],
//                                     readOnly: true,
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: heightDp * 10),
//                         Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
//                       ],
//                     ),

//               ///
//               _orderData!["services"] == null || _orderData!["services"].isEmpty || _orderData!['serviceDateTime'] == null
//                   ? SizedBox()
//                   : Column(
//                       children: [
//                         SizedBox(height: heightDp * 10),
//                         Container(
//                           width: deviceWidth,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Service Date:",
//                                 style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
//                               ),
//                               Text(
//                                 KeicyDateTime.convertDateTimeToDateString(
//                                   dateTime: DateTime.tryParse(_orderData!['serviceDateTime']),
//                                   formats: 'Y-m-d h:i A',
//                                   isUTC: false,
//                                 ),
//                                 style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: heightDp * 10),
//                         Divider(height: heightDp * 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
//                       ],
//                     ),

//               //////
//               SizedBox(height: heightDp * 10),
//               PaymentDetailPanel(orderData: json.decode(json.encode(_orderData))),
//               SizedBox(height: heightDp * 20),

//               ///
//               if (_orderData!["status"] == AppConfig.orderStatusData[1]["id"])
//                 _placeOrderButtonGroup()
//               else if (_orderData!["status"] == AppConfig.orderStatusData[2]["id"])
//                 _acceptedOrderButtonGroup()
//               else if (_orderData!["status"] == AppConfig.orderStatusData[3]["id"])
//                 _paidOrderButtonGroup()
//               else if (_orderData!["status"] == AppConfig.orderStatusData[4]["id"] || _orderData!["status"] == AppConfig.orderStatusData[5]["id"])
//                 _pickupCompleteButtonGroup(),
//               SizedBox(height: heightDp * 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _placeOrderButtonGroup() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         KeicyRaisedButton(
//           width: widthDp * 100,
//           height: heightDp * 30,
//           color: _orderData!["products"].isEmpty && _orderData!["services"].isEmpty ? Colors.grey.withOpacity(0.6) : config.Colors().mainColor(1),
//           borderRadius: heightDp * 8,
//           child: Text(
//             "Accept",
//             style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
//           ),
//           onPressed: _orderData!["products"].isEmpty && _orderData!["services"].isEmpty ? null : _acceptedCallback,
//         ),
//         KeicyRaisedButton(
//           width: widthDp * 100,
//           height: heightDp * 30,
//           color: config.Colors().mainColor(1),
//           borderRadius: heightDp * 8,
//           child: Text(
//             "Reject",
//             style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
//           ),
//           onPressed: _rejectCallback,
//         ),
//       ],
//     );
//   }

//   Widget _acceptedOrderButtonGroup() {
//     return Container(
//       width: deviceWidth,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               if (_orderData!["orderType"] != "Service")
//                 KeicyRaisedButton(
//                   width: widthDp * 170,
//                   height: heightDp * 30,
//                   color: Colors.grey.withOpacity(0.5),
//                   borderRadius: heightDp * 8,
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                   child: Text(
//                     _orderData!["orderType"] == "Pickup" ? "Change Pick Date" : "Change Delivery Date",
//                     style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                   ),
//                   onPressed: () {
//                     // OrderAcceptDialog.show(context, callback: widget.acceptCallback);
//                   },
//                 ),
//               if (_orderData!["orderType"] != "Service")
//                 KeicyRaisedButton(
//                   width: widthDp * 170,
//                   height: heightDp * 30,
//                   color: config.Colors().mainColor(1),
//                   borderRadius: heightDp * 8,
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                   child: Text(
//                     _orderData!["orderType"] == "Pickup" ? "Pickup Ready" : "Delivery Ready",
//                     style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                   ),
//                   onPressed: () {
//                     if (_orderData!["orderType"] == "Pickup") {
//                       _pickupReadyCallback();
//                     } else {
//                       _deliveryReadyCallback();
//                     }
//                   },
//                 ),
//             ],
//           ),
//           SizedBox(height: heightDp * 10),
//           (_orderData!["payAtStore"] || _orderData!["cashOnDelivery"])
//               ? KeicyRaisedButton(
//                   width: widthDp * 170,
//                   height: heightDp * 30,
//                   color: config.Colors().mainColor(1),
//                   borderRadius: heightDp * 8,
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//                   child: Text(
//                     "Payment Done",
//                     style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//                   ),
//                   onPressed: _payCallback,
//                 )
//               : SizedBox(),
//         ],
//       ),
//     );
//   }

//   Widget _paidOrderButtonGroup() {
//     return Container(
//       width: deviceWidth,
//       child: Wrap(
//         alignment: WrapAlignment.spaceAround,
//         runSpacing: heightDp * 10,
//         children: [
//           if (!_orderData!["pickupDeliverySatus"] && _orderData!["orderType"] != "Service")
//             KeicyRaisedButton(
//               width: widthDp * 170,
//               height: heightDp * 30,
//               color: Colors.grey.withOpacity(0.5),
//               borderRadius: heightDp * 8,
//               padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//               child: Text(
//                 _orderData!["orderType"] == "Pickup" ? "Change Pick Date" : "Change Delivery Status",
//                 style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//               ),
//               onPressed: () {
//                 // OrderAcceptDialog.show(context, callback: widget.acceptCallback);
//               },
//             ),
//           if (!_orderData!["pickupDeliverySatus"] && _orderData!["orderType"] != "Service")
//             KeicyRaisedButton(
//               width: widthDp * 170,
//               height: heightDp * 30,
//               color: config.Colors().mainColor(1),
//               borderRadius: heightDp * 8,
//               padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//               child: Text(
//                 _orderData!["orderType"] == "Pickup" ? "Pickup Ready" : "Delivery Ready",
//                 style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//               ),
//               onPressed: () {
//                 if (_orderData!["orderType"] == "Pickup") {
//                   _pickupReadyCallback();
//                 } else {
//                   OrderStatusDialog.show(
//                     context,
//                     title: "Delivery is Ready",
//                     content: "Is the order ready for Delivery",
//                     okayButtonString: "Yes",
//                     cancelButtonString: "No",
//                     callback: () async {
//                       if (_orderData!["deliveryPartnerDetails"] == null || _orderData!["deliveryPartnerDetails"].isEmpty) {
//                         NormalDialog.show(context,
//                             title: "Delivery Ready",
//                             content:
//                                 "This order need to be delivered on your own, as your store and order is not associated with any delivery partners",
//                             callback: () {
//                           _deliveryReadyCallback();
//                         });
//                       } else {
//                         _deliveryReadyCallback();
//                       }
//                     },
//                   );
//                 }
//               },
//             ),
//           KeicyRaisedButton(
//             width: widthDp * 170,
//             height: heightDp * 30,
//             color: config.Colors().mainColor(1),
//             borderRadius: heightDp * 8,
//             padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//             child: Text(
//               "Order Complete",
//               style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//             ),
//             onPressed: _completeCallback,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _pickupCompleteButtonGroup() {
//     return Wrap(
//       children: [
//         if (_orderData!["payStatus"])
//           KeicyRaisedButton(
//             width: widthDp * 170,
//             height: heightDp * 30,
//             color: config.Colors().mainColor(1),
//             borderRadius: heightDp * 8,
//             padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//             child: Text(
//               _orderData!["orderType"] == "Pickup" ? "Pickup Order Complete" : "Delivery Order Complete",
//               style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//             ),
//             onPressed: _completeCallback,
//           ),
//         if (!_orderData!["payStatus"] && (_orderData!["payAtStore"] || _orderData!["cashOnDelivery"]))
//           KeicyRaisedButton(
//             width: widthDp * 170,
//             height: heightDp * 30,
//             color: config.Colors().mainColor(1),
//             borderRadius: heightDp * 8,
//             padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
//             child: Text(
//               "Payment Done",
//               style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
//             ),
//             onPressed: _payCallback,
//           )
//       ],
//     );
//   }

//   void _acceptedCallback() async {
//     bool isAvaiable = true;
//     for (var i = 0; i < _orderData!["products"].length; i++) {
//       if (_orderData!["products"][i]["price"] == null || _orderData!["products"][i]["price"] == 0) {
//         isAvaiable = false;
//       }
//     }

//     for (var i = 0; i < _orderData!["services"].length; i++) {
//       if (_orderData!["services"][i]["price"] == null || _orderData!["services"][i]["price"] == 0) {
//         isAvaiable = false;
//       }
//     }
//     if (!isAvaiable) {
//       ErrorDialog.show(
//         context,
//         widthDp: widthDp,
//         heightDp: heightDp,
//         fontSp: fontSp,
//         text: "You have to change order based on the products and services available at store",
//       );
//       return;
//     }

//     OrderStatusDialog.show(
//       context,
//       title: "Order Accept",
//       content: "Do you want to accept the order. User will be notified with it.",
//       callback: () async {
//         await _keicyProgressDialog!.show();
//         var result = await _orderProvider!.updateOrderData(
//           orderData: _orderData,
//           status: AppConfig.orderStatusData[2]["id"],
//           changedStatus: !(JsonDiffer.fromJson(_orderData!, widget.orderData!).diff().hasNothing),
//         );
//         await _keicyProgressDialog!.hide();
//         if (result["success"]) {
//           _orderData!["status"] = AppConfig.orderStatusData[2]["id"];
//           updatedOrderStatus = AppConfig.orderStatusData[2]["id"];
//           setState(() {});

//           SuccessDialog.show(
//             context,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: "The order is accepted",
//           );
//         } else {
//           ErrorDialog.show(
//             context,
//             widthDp: widthDp,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: result["message"],
//             callBack: () {
//               _acceptedCallback();
//             },
//           );
//         }
//       },
//     );
//   }

//   void _rejectCallback() async {
//     OrderRejectDialog.show(
//       context,
//       title: "Order Reject",
//       content: "Do you really want to reject the order. User will be notified with the rejection. Do you want to proceed.",
//       callback: (reason) async {
//         Map<String, dynamic> newOrderData = json.decode(json.encode(_orderData));
//         newOrderData["reasonForCancelOrReject"] = reason;
//         await _keicyProgressDialog!.show();
//         // var result = await _orderProvider!.changeOrderStatus1(
//         //   storeId: AuthProvider.of(context).authState.storeModel!.id,
//         //   orderId: _orderData!["_id"],
//         //   userId: _orderData!["userId"],
//         //   status: AppConfig.orderStatusData[8]["id"],
//         //   token: AuthProvider.of(context).authState.userData!["token"],
//         // );
//         var result = await _orderProvider!.updateOrderData(
//           orderData: newOrderData,
//           status: AppConfig.orderStatusData[8]["id"],
//           changedStatus: false,
//         );
//         await _keicyProgressDialog!.hide();
//         if (result["success"]) {
//           _orderData = result["data"];
//           _orderData!["status"] = AppConfig.orderStatusData[8]["id"];
//           updatedOrderStatus = AppConfig.orderStatusData[8]["id"];
//           setState(() {});
//           SuccessDialog.show(
//             context,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: "The order is rejectecd",
//           );
//         } else {
//           ErrorDialog.show(
//             context,
//             widthDp: widthDp,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: result["message"],
//             callBack: () {
//               _rejectCallback();
//             },
//           );
//         }
//       },
//     );
//   }

//   void _pickupReadyCallback() async {
//     OrderStatusDialog.show(
//       context,
//       title: "Pickup is Ready",
//       content: "Is the order ready for Pickup",
//       okayButtonString: "Yes",
//       cancelButtonString: "No",
//       callback: () async {
//         await _keicyProgressDialog!.show();
//         var result = await _orderProvider!.changeOrderStatus1(
//           storeId: AuthProvider.of(context).authState.storeModel!.id,
//           orderId: _orderData!["_id"],
//           userId: _orderData!["userId"],
//           status: AppConfig.orderStatusData[4]["id"],
//           token: AuthProvider.of(context).authState.userData!["token"],
//         );
//         await _keicyProgressDialog!.hide();
//         if (result["success"]) {
//           _orderData!["status"] = AppConfig.orderStatusData[4]["id"];
//           updatedOrderStatus = AppConfig.orderStatusData[4]["id"];
//           setState(() {});
//           SuccessDialog.show(
//             context,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: "The order is pickup ready",
//           );
//         } else {
//           ErrorDialog.show(
//             context,
//             widthDp: widthDp,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: result["message"],
//             callBack: () {
//               _pickupReadyCallback();
//             },
//           );
//         }
//       },
//     );
//   }

//   void _deliveryReadyCallback() async {
//     await _keicyProgressDialog!.show();
//     var result = await _orderProvider!.changeOrderStatus1(
//       storeId: AuthProvider.of(context).authState.storeModel!.id,
//       orderId: _orderData!["_id"],
//       userId: _orderData!["userId"],
//       status: AppConfig.orderStatusData[5]["id"],
//       token: AuthProvider.of(context).authState.userData!["token"],
//     );
//     await _keicyProgressDialog!.hide();
//     if (result["success"]) {
//       _orderData!["status"] = AppConfig.orderStatusData[5]["id"];
//       updatedOrderStatus = AppConfig.orderStatusData[5]["id"];
//       setState(() {});
//       SuccessDialog.show(
//         context,
//         heightDp: heightDp,
//         fontSp: fontSp,
//         text: "The order is delivery ready",
//       );
//     } else {
//       ErrorDialog.show(
//         context,
//         widthDp: widthDp,
//         heightDp: heightDp,
//         fontSp: fontSp,
//         text: result["message"],
//         callBack: () {
//           _deliveryReadyCallback();
//         },
//       );
//     }
//   }

//   void _payCallback() async {
//     OrderStatusDialog.show(
//       context,
//       title: "Order Paid",
//       content: "Are you sure the order has been paid",
//       callback: () async {
//         await _keicyProgressDialog!.show();
//         var result = await _orderProvider!.changeOrderStatus1(
//           storeId: AuthProvider.of(context).authState.storeModel!.id,
//           orderId: _orderData!["_id"],
//           userId: _orderData!["userId"],
//           status: AppConfig.orderStatusData[3]["id"],
//           token: AuthProvider.of(context).authState.userData!["token"],
//         );
//         await _keicyProgressDialog!.hide();
//         if (result["success"]) {
//           _orderData!["status"] = AppConfig.orderStatusData[3]["id"];
//           updatedOrderStatus = AppConfig.orderStatusData[3]["id"];
//           setState(() {});
//           SuccessDialog.show(
//             context,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: "The order is paid",
//           );
//         } else {
//           ErrorDialog.show(
//             context,
//             widthDp: widthDp,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: result["message"],
//             callBack: () {
//               _payCallback();
//             },
//           );
//         }
//       },
//     );
//   }

//   void _completeCallback() async {
//     OrderStatusDialog.show(
//       context,
//       title: "Order Complete",
//       content: "Are you sure you want to complete this order",
//       callback: () async {
//         await _keicyProgressDialog!.show();
//         var result = await _orderProvider!.changeOrderStatus1(
//           storeId: AuthProvider.of(context).authState.storeModel!.id,
//           orderId: _orderData!["_id"],
//           userId: _orderData!["userId"],
//           status: AppConfig.orderStatusData[9]["id"],
//           token: AuthProvider.of(context).authState.userData!["token"],
//         );
//         await _keicyProgressDialog!.hide();
//         if (result["success"]) {
//           _orderData!["status"] = AppConfig.orderStatusData[9]["id"];
//           updatedOrderStatus = AppConfig.orderStatusData[9]["id"];
//           setState(() {});
//           SuccessDialog.show(
//             context,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: "The order is Complete",
//           );
//         } else {
//           ErrorDialog.show(
//             context,
//             widthDp: widthDp,
//             heightDp: heightDp,
//             fontSp: fontSp,
//             text: result["message"],
//             callBack: () {
//               _deliveryReadyCallback();
//             },
//           );
//         }
//       },
//     );
//   }
// }
