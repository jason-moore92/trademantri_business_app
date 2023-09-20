// import 'dart:convert';

// import 'package:trapp/config/app_config.dart' as config;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:trapp/src/providers/CartProvider/cart_provider.dart';
// import 'package:trapp/src/providers/index.dart';

// class ServiceCheckoutWidget extends StatefulWidget {
//   final Map<String, dynamic>? serviceData;
//   final Map<String, dynamic>? storeData;
//   final Map<String, dynamic>? orderData;
//   final Map<String, dynamic>? promocode;
//   final Function? callback;

//   ServiceCheckoutWidget({
//     @required this.serviceData,
//     @required this.storeData,
//     @required this.orderData,
//     @required this.promocode,
//     @required this.callback,
//   });

//   @override
//   _ServiceCheckoutWidgetState createState() => _ServiceCheckoutWidgetState();
// }

// class _ServiceCheckoutWidgetState extends State<ServiceCheckoutWidget> {
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

//   bool isAdded = false;
//   int selectedCount = 0;

//   CartProvider? _cartProvider;

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

//     _cartProvider = CartProvider.of(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: widthDp * 0, vertical: heightDp * 5),
//       child: _serviceWidget(),
//     );
//   }

//   Widget _serviceWidget() {
//     List<dynamic> cartData = (_cartProvider!.cartState.cartData![widget.storeData!["_id"]] == null ||
//             _cartProvider!.cartState.cartData![widget.storeData!["_id"]]["services"] == null)
//         ? []
//         : _cartProvider!.cartState.cartData![widget.storeData!["_id"]]["services"];

//     isAdded = false;
//     selectedCount = 0;
//     for (var i = 0; i < cartData.length; i++) {
//       if (cartData[i]["data"]["_id"] == widget.serviceData!["_id"]) {
//         isAdded = true;
//         selectedCount = cartData[i]["orderQuantity"];
//         break;
//       }
//     }

//     if (widget.serviceData!["images"].runtimeType.toString() == "String") {
//       widget.serviceData!["images"] = json.decode(widget.serviceData!["images"]);
//     }
//     return Row(
//       children: [
//         Icon(Icons.star, size: heightDp * 20, color: config.Colors().mainColor(1)),
//         SizedBox(width: widthDp * 15),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${widget.serviceData!["name"]}",
//                             style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w700),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: heightDp * 5),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "${widget.serviceData!["provided"]}",
//                                   style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
//                                 ),
//                               ),
//                               _categoryButton(),
//                               SizedBox(width: widthDp * 8),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         _addButtonPanel(),
//                       ],
//                     ),
//                   ),
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
//       padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(heightDp * 20),
//         border: Border.all(color: Colors.blue),
//       ),
//       child: Text(
//         "Service",
//         style: TextStyle(fontSize: fontSp * 14, color: Colors.blue),
//       ),
//     );
//   }

//   Widget _addButtonPanel() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Row(
//           children: [
//             _addMoreServiceButton(),
//             SizedBox(width: widthDp * 10),
//             _priceWidget(),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _addMoreServiceButton() {
//     return Container(
//       width: widthDp * 80,
//       padding: EdgeInsets.symmetric(vertical: heightDp * 5),
//       decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
//       alignment: Alignment.center,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () async {
//                 if (_cartProvider!.cartState.progressState == 1 || selectedCount == 0) return;
//                 _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));

//                 await _cartProvider!.setCartData(
//                   userId: AuthProvider.of(context).authState.userModel!.id,
//                   storeData: widget.storeData,
//                   objectData: widget.serviceData,
//                   category: "services",
//                   orderQuantity: selectedCount - 1,
//                 );

//                 widget.callback!();
//                 // setState(() {});
//               },
//               child: Container(
//                 color: Colors.transparent,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(width: widthDp * 5),
//                     GestureDetector(
//                       child: Icon(Icons.remove,
//                           color: selectedCount == 0 ? Colors.grey.withOpacity(0.4) : config.Colors().mainColor(1), size: heightDp * 20),
//                     ),
//                     SizedBox(width: widthDp * 5),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Text(
//             selectedCount.toString(),
//             style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w700),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () async {
//                 if (_cartProvider!.cartState.progressState == 1) return;
//                 _cartProvider!.setCartState(_cartProvider!.cartState.update(progressState: 1));

//                 await _cartProvider!.setCartData(
//                   userId: AuthProvider.of(context).authState.userModel!.id,
//                   storeData: widget.storeData,
//                   objectData: widget.serviceData,
//                   category: "services",
//                   orderQuantity: selectedCount + 1,
//                 );
//                 widget.callback!();
//                 // setState(() {});
//               },
//               child: Container(
//                 color: Colors.transparent,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(width: widthDp * 5),
//                     GestureDetector(
//                       child: Icon(Icons.add, color: config.Colors().mainColor(1), size: heightDp * 20),
//                     ),
//                     SizedBox(width: widthDp * 5),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _priceWidget() {
//     double price = 0;
//     double promocodeDiscount = 0;
//     double totalPrice = 0;

//     for (var i = 0; i < widget.orderData!["products"].length; i++) {
//       double discount = 0;
//       if (widget.orderData!["products"][i]["data"]["discount"] != null) {
//         discount = double.parse(widget.orderData!["products"][i]["data"]["discount"].toString());
//       }
//       totalPrice +=
//           widget.orderData!["products"][i]["orderQuantity"] * (double.parse(widget.orderData!["products"][i]["data"]["price"].toString()) - discount);
//     }
//     for (var i = 0; i < widget.orderData!["services"].length; i++) {
//       double discount = 0;
//       if (widget.orderData!["services"][i]["data"]["discount"] != null) {
//         discount = double.parse(widget.orderData!["services"][i]["data"]["discount"].toString());
//       }
//       totalPrice +=
//           widget.orderData!["services"][i]["orderQuantity"] * (double.parse(widget.orderData!["services"][i]["data"]["price"].toString()) - discount);
//     }

//     if (widget.serviceData!["discount"] == null || widget.serviceData!["discount"] == 0) {
//       price = double.parse(widget.serviceData!["price"].toString());
//     } else {
//       price = double.parse(widget.serviceData!["price"].toString()) - double.parse(widget.serviceData!["discount"].toString());
//     }

//     if (widget.promocode != null && widget.promocode!.isNotEmpty) {
//       if (widget.promocode!["promocodeType"] == "Percentage") {
//         promocodeDiscount = price * double.parse(widget.promocode!["promocodeValue"].toString()) / 100;
//       }

//       if (widget.promocode!["promocodeType"].toString().contains("INR")) {
//         double percent = double.parse(widget.promocode!["promocodeValue"].toString()) / totalPrice * 100;
//         // promocodeDiscount = double.parse(widget.promocode!["promocodeValue"].toString());
//         promocodeDiscount = price * percent / 100;
//       }
//     }

//     return widget.promocode == null || widget.promocode!.isEmpty || widget.promocode!["promocodeType"] == "Delivery"
//         ? Text(
//             "₹ ${(price * selectedCount).toStringAsFixed(2)}",
//             style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//           )
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "₹ ${((price - promocodeDiscount) * selectedCount).toStringAsFixed(2)}",
//                     style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(width: widthDp * 10),
//                 ],
//               ),
//               Text(
//                 "₹ ${((price) * selectedCount).toStringAsFixed(2)} ",
//                 style: TextStyle(
//                   fontSize: fontSp * 16,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                   decoration: TextDecoration.lineThrough,
//                   decorationThickness: 2,
//                 ),
//               ),
//             ],
//           );
//   }
// }
