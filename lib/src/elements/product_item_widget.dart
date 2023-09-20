// import 'package:intl/intl.dart';
// import 'package:trapp/config/app_config.dart' as config;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:trapp/src/models/product_order_model.dart';

// import 'keicy_avatar_image.dart';

// class ProductItemWidget extends StatelessWidget {
//   final ProductOrderModel? productOrderModel;
//   final EdgeInsetsGeometry? padding;
//   final Function(ProductOrderModel?)? refreshCallback;

//   ProductItemWidget({
//     @required this.productOrderModel,
//     this.padding,
//     this.refreshCallback,
//   });

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

//   ProductOrderModel? _productOrderModel;

//   var numFormat = NumberFormat.currency(symbol: "", name: "");

//   @override
//   Widget build(BuildContext context) {
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
//     _productOrderModel = productOrderModel!;

//     bool isLoading = _productOrderModel!.productModel!.toJson().isEmpty;

//     numFormat.maximumFractionDigits = 2;
//     numFormat.minimumFractionDigits = 0;
//     numFormat.turnOffGrouping();

//     return Padding(
//       padding: padding ?? EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
//       child: isLoading ? _shimmerWidget() : _productWidget(),
//     );
//   }

//   Widget _shimmerWidget() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       direction: ShimmerDirection.ltr,
//       enabled: true,
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
//                     Container(
//                       color: Colors.white,
//                       child: Text(
//                         "price",
//                         style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             width: widthDp * 100,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white),
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(heightDp * 20),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     "ADD",
//                     style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _productWidget() {
//     return Row(
//       children: [
//         Stack(
//           children: [
//             KeicyAvatarImage(
//               url: _productOrderModel!.productModel!.images!.isNotEmpty ? _productOrderModel!.productModel!.images![0] : "",
//               width: widthDp * 80,
//               height: widthDp * 80,
//               backColor: Colors.grey.withOpacity(0.4),
//             ),
//             !_productOrderModel!.productModel!.isAvailable!
//                 ? Image.asset("img/unavailable.png", width: widthDp * 60, fit: BoxFit.fitWidth)
//                 : SizedBox(),
//           ],
//         ),
//         SizedBox(width: widthDp * 15),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "${_productOrderModel!.productModel!.name}",
//                       style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: heightDp * 5),
//                     Text(
//                       "${_productOrderModel!.productModel!.description}",
//                       style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: heightDp * 5),
//                     Row(
//                       children: [
//                         if (_productOrderModel!.productModel!.quantity != 0 && _productOrderModel!.productModel!.quantityType != "")
//                           Expanded(
//                             child: Text(
//                               "${_productOrderModel!.productModel!.quantity} ${_productOrderModel!.productModel!.quantityType}",
//                               style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//                             ),
//                           ),
//                         _categoryButton(),
//                       ],
//                     ),
//                     SizedBox(height: heightDp * 5),
//                     !_productOrderModel!.productModel!.showPriceToUsers!
//                         ? _disablePriceDiaplayWidget()
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _productOrderModel!.orderQuantity == 0 ? _addOneProductButton() : _addMoreProductButton(),
//                               _priceWidget(),
//                             ],
//                           ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: heightDp * 5),
//               Wrap(
//                 runSpacing: heightDp * 5,
//                 children: [
//                   _productOrderModel!.productModel!.bargainAvailable! ? _availableBargainWidget() : SizedBox(),
//                   _productOrderModel!.productModel!.acceptBulkOrder! ? _availableBulkOrder() : SizedBox(),
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
//         "Product",
//         style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
//       ),
//     );
//   }

//   Widget _countButton() {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
//             decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
//             alignment: Alignment.center,
//             child: Row(
//               children: [
//                 Text(
//                   "Quantities:  ",
//                   style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
//                 ),
//                 Text(
//                   "${numFormat.format(_productOrderModel!.orderQuantity)}",
//                   style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _addOneProductButton() {
//     return Container(
//       width: widthDp * 100,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           GestureDetector(
//             onTap: () async {
//               _productOrderModel!.orderQuantity = 1;
//               if (refreshCallback != null) {
//                 refreshCallback!(_productOrderModel);
//               }
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
//               decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
//               alignment: Alignment.center,
//               child: Text(
//                 "ADD",
//                 style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _addMoreProductButton() {
//     return Container(
//       width: widthDp * 100,
//       padding: EdgeInsets.symmetric(vertical: heightDp * 5),
//       decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.6)), borderRadius: BorderRadius.circular(heightDp * 20)),
//       alignment: Alignment.center,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () async {
//               if (_productOrderModel!.orderQuantity == 0) return;
//               _productOrderModel!.orderQuantity = _productOrderModel!.orderQuantity! - 1;
//               if (refreshCallback != null) {
//                 refreshCallback!(_productOrderModel);
//               }
//             },
//             child: Container(
//               color: Colors.transparent,
//               child: Row(
//                 children: [
//                   SizedBox(width: widthDp * 10),
//                   GestureDetector(
//                     child: Icon(
//                       Icons.remove,
//                       color: _productOrderModel!.orderQuantity == 0 ? Colors.black : config.Colors().mainColor(1),
//                       size: heightDp * 20,
//                     ),
//                   ),
//                   SizedBox(width: widthDp * 5),
//                 ],
//               ),
//             ),
//           ),
//           Text(
//             numFormat.format(_productOrderModel!.orderQuantity),
//             style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w700),
//           ),
//           GestureDetector(
//             onTap: () async {
//               _productOrderModel!.orderQuantity = _productOrderModel!.orderQuantity! + 1;
//               if (refreshCallback != null) {
//                 refreshCallback!(_productOrderModel);
//               }
//             },
//             child: Container(
//               color: Colors.transparent,
//               child: Row(
//                 children: [
//                   SizedBox(width: widthDp * 5),
//                   GestureDetector(
//                     child: Icon(Icons.add, color: config.Colors().mainColor(1), size: heightDp * 20),
//                   ),
//                   SizedBox(width: widthDp * 10),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _disablePriceDiaplayWidget() {
//     return Container(
//       width: widthDp * 180,
//       padding: EdgeInsets.symmetric(vertical: heightDp * 5),
//       decoration: BoxDecoration(color: Color(0xFFF8C888), borderRadius: BorderRadius.circular(heightDp * 4)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.remove_moderator, size: widthDp * 12, color: Colors.black),
//           SizedBox(width: widthDp * 3),
//           Text(
//             "Price Disabled By Store Owner",
//             style: TextStyle(fontSize: fontSp * 10, color: Colors.black, fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _priceWidget() {
//     return _productOrderModel!.productModel!.discount == 0
//         ? Text(
//             "₹ ${numFormat.format(_productOrderModel!.productModel!.price)}",
//             style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//           )
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "₹ ${numFormat.format(_productOrderModel!.productModel!.price! - _productOrderModel!.productModel!.discount!)}",
//                     style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(width: widthDp * 10),
//                   Text(
//                     "₹ ${numFormat.format(_productOrderModel!.productModel!.price)}",
//                     style: TextStyle(
//                       fontSize: fontSp * 12,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                       decoration: TextDecoration.lineThrough,
//                       decorationThickness: 2,
//                     ),
//                   ),
//                 ],
//               ),
//               Text(
//                 "Saved ₹ ${numFormat.format(_productOrderModel!.productModel!.discount)}",
//                 style: TextStyle(fontSize: fontSp * 12, color: Colors.grey, fontWeight: FontWeight.w500),
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
// }
