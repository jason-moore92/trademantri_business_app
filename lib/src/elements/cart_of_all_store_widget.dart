// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:trapp/src/providers/CartProvider/cart_provider.dart';
// import 'package:trapp/config/app_config.dart' as config;

// class CartOfAllStoresWidget extends StatelessWidget {
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

//     return Consumer<CartProvider>(builder: (context, cartProvider, _) {
//       return GestureDetector(
//         onTap: () {},
//         child: Row(
//           children: [
//             Stack(
//               children: [
//                 Icon(
//                   Icons.shopping_cart_outlined,
//                   size: heightDp * 30,
//                   color: Colors.black,
//                 ),
//                 cartProvider.cartState.cartData!.length == 0
//                     ? SizedBox()
//                     : Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           width: heightDp * 15,
//                           height: heightDp * 15,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(heightDp * 10),
//                             color: config.Colors().mainColor(1),
//                           ),
//                           alignment: Alignment.center,
//                           child: Text(
//                             cartProvider.cartState.cartData!.length.toString(),
//                             style: TextStyle(fontSize: 14, color: Colors.white),
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
