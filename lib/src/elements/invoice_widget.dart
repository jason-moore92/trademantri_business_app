import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class InvoiceWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final bool? isLoading;

  InvoiceWidget({
    @required this.orderModel,
    @required this.isLoading,
  });

  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  @override
  Widget build(BuildContext context) {
    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    return Card(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
      elevation: 5,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
        color: Colors.transparent,
        child: isLoading! ? _shimmerWidget() : _notificationWidget(context),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: isLoading!,
      period: Duration(milliseconds: 1000),
      child: Row(
        children: [
          Container(width: heightDp * 80, height: heightDp * 80, color: Colors.black),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "notification storeName",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "2021-09-23",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "orderModel title",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "orderModel body\npaymentLinkData body body body body",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationWidget(BuildContext context) {
    ProductOrderModel? productOrderModel;
    ServiceOrderModel? serviceOrderModel;
    if (orderModel!.products!.length != 0) {
      productOrderModel = orderModel!.products![0];
    }
    if (orderModel!.services!.length != 0) {
      serviceOrderModel = orderModel!.services![0];
    }

    if (orderModel!.storeModel == null) {
      orderModel!.storeModel = AuthProvider.of(context).authState.storeModel;
    }

    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "User Name :  ${orderModel!.userModel!.firstName} ${orderModel!.userModel!.lastName}",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "User Email :  " +
                          (orderModel!.userModel!.email.toString().length < 15
                              ? "${orderModel!.userModel!.email}"
                              : "${orderModel!.userModel!.email.toString().substring(0, 15)}..."),
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
                decoration: BoxDecoration(
                  //   color: Colors.red,
                  color: orderModel!.payStatus! ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(heightDp * 6),
                ),
                child: Text(
                  orderModel!.payStatus! ? "Paid" : "Not Paid",
                  // StringHelper.getUpperCaseString(orderModel!["paymentData"]["status"].toString()),
                  style: TextStyle(
                    fontSize: fontSp * 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 10),
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          if (productOrderModel != null)
            Column(
              children: [
                SizedBox(height: heightDp * 10),
                ProductItemForSelectionWidget(
                  selectedProducts: [],
                  productModel: productOrderModel.productModel,
                  storeModel: orderModel!.storeModel,
                  padding: EdgeInsets.zero,
                  isLoading: false,
                ),
              ],
            ),
          if (serviceOrderModel != null)
            Column(
              children: [
                SizedBox(height: heightDp * 10),
                ServiceItemForSelectionWidget(
                  selectedServices: [],
                  serviceModel: serviceOrderModel.serviceModel,
                  storeModel: orderModel!.storeModel,
                  padding: EdgeInsets.zero,
                  isLoading: false,
                ),
              ],
            ),
          SizedBox(height: heightDp * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "To view invoice order details",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              ),
              SizedBox(width: widthDp * 10),
              KeicyRaisedButton(
                width: widthDp * 120,
                height: heightDp * 35,
                borderRadius: heightDp * 6,
                color: config.Colors().mainColor(1),
                child: Text(
                  "Details",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => OrderDetailNewPage(
                        orderModel: orderModel,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
