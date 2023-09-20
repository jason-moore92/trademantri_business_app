// import 'dart:convert';

// import 'package:trapp/config/app_config.dart' as config;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:trapp/config/config.dart';
// import 'package:trapp/src/dialogs/index.dart';
// import 'package:trapp/src/dialogs/product_purchase_price_dialog.dart';
// import 'package:trapp/src/helpers/price_functions.dart';

// import 'keicy_avatar_image.dart';

// class ServiceBargainWidget extends StatefulWidget {
//   final Map<String, dynamic>? serviceData;
//   final Map<String, dynamic>? orderData;
//   final int? index;
//   final Function? updateQuantityCallback;
//   final Function? refreshCallback;

//   ServiceBargainWidget({
//     @required this.serviceData,
//     @required this.orderData,
//     this.index,
//     @required this.updateQuantityCallback,
//     @required this.refreshCallback,
//   });

//   @override
//   _ServiceBargainWidgetState createState() => _ServiceBargainWidgetState();
// }

// class _ServiceBargainWidgetState extends State<ServiceBargainWidget> {
//   /// Responsive design variables
//   double deviceWidth = 0;
//   double deviceHeight = 0;
//   double statusbarHeight = 0;
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
//     appbarHeight = AppBar().preferredSize.height;
//     widthDp = ScreenUtil().setWidth(1);
//     heightDp = ScreenUtil().setWidth(1);
//     heightDp1 = ScreenUtil().setHeight(1);
//     fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
//     ///////////////////////////////
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: widthDp * 0, vertical: heightDp * 5),
//       child: _productWidget(),
//     );
//   }

//   Widget _productWidget() {
//     if (widget.serviceData!["images"].runtimeType.toString() == "String") {
//       widget.serviceData!["images"] = json.decode(widget.serviceData!["images"]);
//     }

//     return Row(
//       children: [
//         KeicyAvatarImage(
//           url: (widget.serviceData!["images"] == null || widget.serviceData!["images"].isEmpty) ? "" : widget.serviceData!["images"][0],
//           width: widthDp * 80,
//           height: widthDp * 80,
//           backColor: Colors.grey.withOpacity(0.4),
//         ),
//         SizedBox(width: widthDp * 15),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       "${widget.serviceData!["name"]}",
//                       style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   SizedBox(width: widthDp * 5),
//                   _priceWidget(),
//                 ],
//               ),
//               ((widget.serviceData!["taxPrice"] == 0 || widget.serviceData!["taxPrice"] == null) && widget.serviceData!["provided"] == null)
//                   ? SizedBox(height: heightDp * 5)
//                   : Column(
//                       children: [
//                         SizedBox(height: heightDp * 5),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: widget.serviceData!["provided"] == null
//                                   ? SizedBox()
//                                   : Text(
//                                       "${widget.serviceData!["provided"]}",
//                                       style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                                     ),
//                             ),
//                             SizedBox(width: widthDp * 5),
//                             if (widget.serviceData!["taxPrice"] == null || widget.serviceData!["taxPrice"] == 0)
//                               Text(
//                                 "Tax: ₹ 0",
//                                 style: TextStyle(fontSize: fontSp * 14, color: Colors.transparent),
//                               )
//                             else
//                               Column(
//                                 children: [
//                                   Text(
//                                     "Tax: ₹ ${widget.serviceData!["taxPrice"]}",
//                                     style: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//               SizedBox(height: heightDp * 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _categoryButton(),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: widthDp * 5),
//                   _addMoreProductButton(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _categoryButton() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(heightDp * 20),
//         border: Border.all(color: Colors.blue),
//       ),
//       child: Text(
//         "Service",
//         style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
//       ),
//     );
//   }

//   Widget _addMoreProductButton() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         widget.orderData!["status"] == AppConfig.bargainRequestStatusData[1]["id"] ||
//                 widget.orderData!["status"] == AppConfig.bargainRequestStatusData[2]["id"]
//             ? GestureDetector(
//                 onTap: () {
//                   if (widget.updateQuantityCallback != null) widget.updateQuantityCallback!();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
//                   color: Colors.transparent,
//                   child: Icon(Icons.edit, size: heightDp * 20, color: Colors.black),
//                 ),
//               )
//             : SizedBox(),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 2),
//           decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
//           alignment: Alignment.center,
//           child: Row(
//             children: [
//               Text(
//                 "Quantities:  ",
//                 style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
//               ),
//               Text(
//                 "${widget.serviceData!["orderQuantity"]}",
//                 style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _priceWidget() {
//     if (widget.orderData!["promocode"] != null &&
//         widget.orderData!["promocode"].isNotEmpty &&
//         widget.orderData!["promocode"]["promocodeType"].toString().contains("INR")) {
//       PriceFunctions.calculateINRPromocodeForOrder(orderData: widget.orderData);
//       var priceResult = PriceFunctions.getPriceDataForProduct(orderData: widget.orderData, data: widget.serviceData);
//       widget.serviceData!.addAll(priceResult);
//     } else {
//       var priceResult = PriceFunctions.getPriceDataForProduct(orderData: widget.orderData, data: widget.serviceData);
//       widget.serviceData!.addAll(priceResult);
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         if (widget.serviceData!["_id"] == null && (widget.serviceData!["price"] == null || widget.serviceData!["price"] == 0))
//           _adddPriceButton()
//         else
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               if (widget.serviceData!["_id"] == null && widget.orderData!["status"] == AppConfig.bargainRequestStatusData[1]["id"])
//                 _editPriceButton()
//               else
//                 SizedBox(),
//               if (widget.serviceData!["promocodeDiscount"] == 0)
//                 Text(
//                   "₹ ${(widget.serviceData!["price"] - widget.serviceData!["discount"])}",
//                   style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//                 )
//               else
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       "₹ ${(widget.serviceData!["price"] - widget.serviceData!["discount"] - widget.serviceData!["promocodeDiscount"])}",
//                       style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//                     ),
//                     SizedBox(width: widthDp * 3),
//                     Text(
//                       "₹ ${(widget.serviceData!["price"] - widget.serviceData!["discount"])}",
//                       style: TextStyle(
//                         fontSize: fontSp * 14,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500,
//                         decoration: TextDecoration.lineThrough,
//                         decorationThickness: 2,
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//       ],
//     );
//   }

//   Widget _adddPriceButton() {
//     return GestureDetector(
//       onTap: () {
//         ProductPriceOldDialog.show(context, productData: widget.serviceData, callback: (Map<String, dynamic> serviceData) {
//           widget.serviceData!["price"] = serviceData["price"];
//           widget.serviceData!["taxPercentage"] = serviceData["taxPercentage"];
//           widget.serviceData!["discount"] = serviceData["discount"];
//           widget.serviceData!["promocodeDiscount"] = serviceData["promocodeDiscount"];
//           widget.serviceData!["taxPercentage"] = serviceData["taxPercentage"];
//           widget.serviceData!["taxPrice"] = serviceData["taxPrice"];
//           widget.serviceData!["priceFor1OrderQuantityBeforeTax"] = serviceData["priceFor1OrderQuantityBeforeTax"];
//           widget.serviceData!["priceFor1OrderQuantityAfterTax"] = serviceData["priceFor1OrderQuantityAfterTax"];
//           // setState(() {});
//           widget.refreshCallback!();
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: widthDp * 8, vertical: heightDp * 2),
//         decoration: BoxDecoration(
//           color: config.Colors().mainColor(1),
//           borderRadius: BorderRadius.circular(heightDp * 5),
//           boxShadow: [
//             BoxShadow(offset: Offset(2, 2), color: Colors.grey, blurRadius: 3),
//           ],
//         ),
//         child: Text(
//           "Add Price",
//           style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
//         ),
//       ),
//     );
//   }

//   Widget _editPriceButton() {
//     return GestureDetector(
//       onTap: () {
//         ProductPriceOldDialog.show(context, productData: widget.serviceData, callback: (Map<String, dynamic> serviceData) {
//           widget.serviceData!["price"] = serviceData["price"];
//           widget.serviceData!["discount"] = serviceData["discount"];
//           widget.serviceData!["promocodeDiscount"] = serviceData["promocodeDiscount"];
//           widget.serviceData!["taxPercentage"] = serviceData["taxPercentage"];
//           widget.serviceData!["taxPrice"] = serviceData["taxPrice"];
//           widget.serviceData!["priceFor1OrderQuantityBeforeTax"] = serviceData["priceFor1OrderQuantityBeforeTax"];
//           widget.serviceData!["priceFor1OrderQuantityAfterTax"] = serviceData["priceFor1OrderQuantityAfterTax"];
//           setState(() {});
//           widget.refreshCallback!();
//         });
//       },
//       child: Padding(
//         padding: EdgeInsets.only(right: widthDp * 10),
//         child: Icon(Icons.edit, size: heightDp * 20),
//       ),
//     );
//   }
// }
