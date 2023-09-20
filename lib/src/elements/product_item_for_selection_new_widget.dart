// import 'dart:convert';

// import 'package:intl/intl.dart';
// import 'package:trapp/config/app_config.dart' as config;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:trapp/src/models/product_order_model.dart';

// import 'keicy_avatar_image.dart';

// class ProductItemForSelectionNewWidget extends StatefulWidget {
//   final List<ProductOrderModel>? selectedProducts;
//   final ProductOrderModel? productOrderModel;
//   final bool isLoading;
//   final EdgeInsetsGeometry? padding;

//   ProductItemForSelectionNewWidget({
//     @required this.selectedProducts,
//     @required this.productOrderModel,
//     this.isLoading = true,
//     this.padding,
//   });

//   @override
//   _ProductItemForSelectionWidgetState createState() => _ProductItemForSelectionWidgetState();
// }

// class _ProductItemForSelectionWidgetState extends State<ProductItemForSelectionNewWidget> {
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

//   var numFormat = NumberFormat.currency(symbol: "", name: "");

//   bool isSelected = false;

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

//     numFormat.maximumFractionDigits = 2;
//     numFormat.minimumFractionDigits = 0;
//     numFormat.turnOffGrouping();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: widget.padding ?? EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
//       child: widget.isLoading ? _shimmerWidget() : _productWidget(),
//     );
//   }

//   Widget _shimmerWidget() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       direction: ShimmerDirection.ltr,
//       enabled: widget.isLoading,
//       period: Duration(milliseconds: 1000),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: widthDp * 80,
//                 height: widthDp * 80,
//                 color: Colors.white,
//               ),
//               SizedBox(width: widthDp * 15),
//               Container(
//                 height: widthDp * 80,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       color: Colors.white,
//                       child: Text(
//                         "product name",
//                         style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     Container(
//                       color: Colors.white,
//                       child: Text(
//                         "10 unites",
//                         style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "price asfasdf",
//                   style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
//                 ),
//               ),
//               SizedBox(height: heightDp * 5),
//               Container(
//                 color: Colors.white,
//                 child: Text(
//                   "price asff",
//                   style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _productWidget() {
//     isSelected = false;
//     for (var i = 0; i < widget.selectedProducts!.length; i++) {
//       if (widget.selectedProducts![i].productModel!.id == widget.productOrderModel!.productModel!.id) {
//         isSelected = true;
//         break;
//       }
//     }

//     return Row(
//       children: [
//         Stack(
//           children: [
//             Stack(
//               children: [
//                 KeicyAvatarImage(
//                   url: (widget.productOrderModel!.productModel!.images!.isEmpty) ? "" : widget.productOrderModel!.productModel!.images![0],
//                   width: widthDp * 80,
//                   height: widthDp * 80,
//                   backColor: Colors.grey.withOpacity(0.4),
//                 ),
//                 Positioned(
//                   child: isSelected ? Image.asset("img/check_icon.png", width: heightDp * 25, height: heightDp * 25) : SizedBox(),
//                 ),
//               ],
//             ),
//             !widget.productOrderModel!.productModel!.isAvailable!
//                 ? Image.asset("img/unavailable.png", width: widthDp * 60, fit: BoxFit.fitWidth)
//                 : SizedBox(),
//           ],
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
//                     child: Container(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${widget.productOrderModel!.productModel!.name}",
//                             style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           if (widget.productOrderModel!.productModel!.description == null)
//                             SizedBox()
//                           else
//                             Column(
//                               children: [
//                                 SizedBox(height: heightDp * 5),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         "${widget.productOrderModel!.productModel!.description}",
//                                         style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           SizedBox(height: heightDp * 5),
//                           _categoryButton()
//                         ],
//                       ),
//                     ),
//                   ),
//                   !widget.productOrderModel!.productModel!.showPriceToUsers!
//                       ? _disablePriceDiaplayWidget()
//                       : widget.productOrderModel!.productModel!.price != 0
//                           ? _priceWidget()
//                           : SizedBox(),
//                 ],
//               ),
//               SizedBox(height: heightDp * 5),
//               Wrap(
//                 runSpacing: heightDp * 5,
//                 children: [
//                   widget.productOrderModel!.productModel!.bargainAvailable! ? _availableBargainWidget() : SizedBox(),
//                   widget.productOrderModel!.productModel!.acceptBulkOrder! ? _availableBulkOrder() : SizedBox(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _disablePriceDiaplayWidget() {
//     return Container(
//       width: widthDp * 110,
//       padding: EdgeInsets.symmetric(vertical: heightDp * 5),
//       decoration: BoxDecoration(color: Color(0xFFF8C888), borderRadius: BorderRadius.circular(heightDp * 4)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.remove_moderator, size: widthDp * 12, color: Colors.black),
//           SizedBox(width: widthDp * 3),
//           Text(
//             "Price Disabled\nBy Store Owner",
//             style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _priceWidget() {
//     return widget.productOrderModel!.promocodeDiscount == 0 && widget.productOrderModel!.couponDiscount == 0
//         ? Text(
//             "₹ ${numFormat.format(widget.productOrderModel!.orderPrice)}",
//             style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//           )
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "₹ ${numFormat.format((widget.productOrderModel!.orderPrice! - widget.productOrderModel!.promocodeDiscount! - widget.productOrderModel!.couponDiscount!))}",
//                     style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(width: widthDp * 10),
//                   Text(
//                     "₹ ${numFormat.format(widget.productOrderModel!.orderPrice)}",
//                     style: TextStyle(
//                       fontSize: fontSp * 14,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                       decoration: TextDecoration.lineThrough,
//                       decorationThickness: 2,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: heightDp * 5),
//               Text(
//                 "Saved ₹ ${numFormat.format(widget.productOrderModel!.promocodeDiscount! + widget.productOrderModel!.couponDiscount!)}",
//                 style: TextStyle(fontSize: fontSp * 14, color: Colors.grey, fontWeight: FontWeight.w500),
//               ),
//             ],
//           );
//   }

//   Widget _availableBargainWidget() {
//     return Container(
//       width: widthDp * 120,
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: heightDp * 5),
//               decoration: BoxDecoration(color: Color(0xFFE7F16E), borderRadius: BorderRadius.circular(heightDp * 4)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.star, size: widthDp * 12, color: Colors.black),
//                   SizedBox(width: widthDp * 3),
//                   Text(
//                     "Bargain Available",
//                     style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(width: widthDp * 10),
//         ],
//       ),
//     );
//   }

//   Widget _availableBulkOrder() {
//     return Container(
//       width: widthDp * 135,
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: heightDp * 5),
//               decoration: BoxDecoration(color: Color(0xFF6EF174), borderRadius: BorderRadius.circular(heightDp * 4)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.star, size: widthDp * 12, color: Colors.black),
//                   SizedBox(width: widthDp * 3),
//                   Text(
//                     "Bulk Order Available",
//                     style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(width: widthDp * 10),
//         ],
//       ),
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
//         "Product",
//         style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
//       ),
//     );
//   }
// }
