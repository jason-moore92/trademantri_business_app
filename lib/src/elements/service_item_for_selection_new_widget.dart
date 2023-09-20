// import 'dart:convert';

// import 'package:intl/intl.dart';
// import 'package:trapp/config/app_config.dart' as config;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:trapp/src/models/index.dart';

// import 'keicy_avatar_image.dart';

// class ServiceItemForSelectionNewWidget extends StatefulWidget {
//   final List<ServiceOrderModel>? selectedServices;
//   final ServiceOrderModel? serviceOrderModel;
//   final bool? isLoading;
//   final EdgeInsetsGeometry? padding;

//   ServiceItemForSelectionNewWidget({
//     @required this.selectedServices,
//     @required this.serviceOrderModel,
//     this.isLoading = true,
//     this.padding,
//   });

//   @override
//   _ServiceItemForSelectionWidgetState createState() => _ServiceItemForSelectionWidgetState();
// }

// class _ServiceItemForSelectionWidgetState extends State<ServiceItemForSelectionNewWidget> {
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
//       child: widget.isLoading! ? _shimmerWidget() : _serviceWidget(),
//     );
//   }

//   Widget _shimmerWidget() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       direction: ShimmerDirection.ltr,
//       enabled: widget.isLoading!,
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
//                         "service name",
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

//   Widget _serviceWidget() {
//     isSelected = false;
//     for (var i = 0; i < widget.selectedServices!.length; i++) {
//       if (widget.selectedServices![i].serviceModel!.id == widget.serviceOrderModel!.serviceModel!.id) {
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
//                   url: (widget.serviceOrderModel!.serviceModel!.images!.isEmpty) ? "" : widget.serviceOrderModel!.serviceModel!.images![0],
//                   width: widthDp * 80,
//                   height: widthDp * 80,
//                   backColor: Colors.grey.withOpacity(0.4),
//                 ),
//                 Positioned(
//                   child: isSelected ? Image.asset("img/check_icon.png", width: heightDp * 25, height: heightDp * 25) : SizedBox(),
//                 ),
//               ],
//             ),
//             !widget.serviceOrderModel!.serviceModel!.isAvailable!
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
//                             "${widget.serviceOrderModel!.serviceModel!.name}",
//                             style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           if (widget.serviceOrderModel!.serviceModel!.description == null)
//                             SizedBox()
//                           else
//                             Column(
//                               children: [
//                                 SizedBox(height: heightDp * 5),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         "${widget.serviceOrderModel!.serviceModel!.description}",
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
//                   !widget.serviceOrderModel!.serviceModel!.showPriceToUsers!
//                       ? _disablePriceDiaplayWidget()
//                       : widget.serviceOrderModel!.serviceModel!.price != 0
//                           ? _priceWidget()
//                           : SizedBox(),
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
//     return widget.serviceOrderModel!.couponDiscount == 0 && widget.serviceOrderModel!.promocodeDiscount == 0
//         ? Text(
//             "₹ ${numFormat.format(widget.serviceOrderModel!.orderPrice)}",
//             style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//           )
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "₹ ${numFormat.format((widget.serviceOrderModel!.orderPrice! - widget.serviceOrderModel!.couponDiscount! - widget.serviceOrderModel!.promocodeDiscount!))}",
//                     style: TextStyle(fontSize: fontSp * 18, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(width: widthDp * 10),
//                   Text(
//                     "₹ ${numFormat.format(widget.serviceOrderModel!.orderPrice)}",
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
//                 "Saved ₹ ${numFormat.format(widget.serviceOrderModel!.couponDiscount! + widget.serviceOrderModel!.promocodeDiscount!)}",
//                 style: TextStyle(fontSize: fontSp * 14, color: Colors.grey, fontWeight: FontWeight.w500),
//               ),
//             ],
//           );
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
//         style: TextStyle(fontSize: fontSp * 12, color: Colors.blue),
//       ),
//     );
//   }
// }
