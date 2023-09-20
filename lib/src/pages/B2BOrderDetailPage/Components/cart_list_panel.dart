import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/product_order_b2b_widget.dart';
import 'package:trapp/src/elements/product_order_widget.dart';
import 'package:trapp/src/elements/service_b2b_order_widget.dart';
import 'package:trapp/src/elements/service_order_b2b_widget.dart';
import 'package:trapp/src/elements/service_order_widget.dart';
import 'package:trapp/src/models/index.dart';

class CartListPanel extends StatefulWidget {
  final B2BOrderModel? b2bOrderModel;
  final Function(B2BOrderModel?)? refreshCallback;

  CartListPanel({
    @required this.b2bOrderModel,
    @required this.refreshCallback,
  });

  @override
  _CartListPanelState createState() => _CartListPanelState();
}

class _CartListPanelState extends State<CartListPanel> {
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
  void initState() {
    super.initState();

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(
            children: List.generate(widget.b2bOrderModel!.products!.length, (index) {
              ProductOrderModel productOrderModel = widget.b2bOrderModel!.products![index];
              if (productOrderModel.couponQuantity == 0) return SizedBox();
              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ProductOrderB2BWidget(
                    productOrderModel: productOrderModel,
                    index: index,
                    readOnly: widget.b2bOrderModel!.status != AppConfig.orderStatusData[1]["id"],
                    isShowReductDialog: true,
                    deleteCallback: (String id) {
                      int? deleteIndex;
                      for (var i = 0; i < widget.b2bOrderModel!.products!.length; i++) {
                        if (widget.b2bOrderModel!.products![i].productModel!.id == id) {
                          deleteIndex = i;
                          break;
                        }
                      }
                      if (deleteIndex != null) {
                        widget.b2bOrderModel!.products!.removeAt(index);
                        setState(() {});
                        if (widget.refreshCallback != null) {
                          widget.refreshCallback!(widget.b2bOrderModel);
                        }
                      }
                    },
                    refreshCallback: (ProductOrderModel? productOrderModel) {
                      if (productOrderModel == null) return;

                      for (var i = 0; i < widget.b2bOrderModel!.products!.length; i++) {
                        if (widget.b2bOrderModel!.products![i].productModel!.id == productOrderModel.productModel!.id) {
                          widget.b2bOrderModel!.products![i] = productOrderModel;
                          break;
                        }
                      }

                      if (widget.refreshCallback != null) {
                        widget.refreshCallback!(widget.b2bOrderModel);
                      }
                    },
                  ),
                ],
              );
            }),
          ),
          Column(
            children: List.generate(widget.b2bOrderModel!.services!.length, (index) {
              ServiceOrderModel serviceOrderModel = widget.b2bOrderModel!.services![index];
              if (serviceOrderModel.couponQuantity == 0) return SizedBox();
              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ServiceOrderB2BWidget(
                    serviceOrderModel: serviceOrderModel,
                    index: index,
                    readOnly: widget.b2bOrderModel!.status != AppConfig.orderStatusData[1]["id"],
                    isShowReductDialog: true,
                    deleteCallback: (String id) {
                      int? deleteIndex;
                      for (var i = 0; i < widget.b2bOrderModel!.services!.length; i++) {
                        if (widget.b2bOrderModel!.services![i].serviceModel!.id == id) {
                          deleteIndex = i;
                          break;
                        }
                      }
                      if (deleteIndex != null) {
                        widget.b2bOrderModel!.services!.removeAt(index);
                        setState(() {});
                        if (widget.refreshCallback != null) {
                          widget.refreshCallback!(widget.b2bOrderModel);
                        }
                      }
                    },
                    refreshCallback: (ServiceOrderModel? serviceOrderModel) {
                      if (serviceOrderModel == null) return;

                      for (var i = 0; i < widget.b2bOrderModel!.services!.length; i++) {
                        if (widget.b2bOrderModel!.services![i].serviceModel!.id == serviceOrderModel.serviceModel!.id) {
                          widget.b2bOrderModel!.services![i] = serviceOrderModel;
                          break;
                        }
                      }

                      if (widget.refreshCallback != null) {
                        widget.refreshCallback!(widget.b2bOrderModel);
                      }
                    },
                  ),
                ],
              );
            }),
          ),
          // if (widget.b2bOrderModel!.bogoProducts!.isNotEmpty || widget.b2bOrderModel!.bogoServices!.isNotEmpty)
          //   Column(
          //     children: [
          //       Container(
          //         width: deviceWidth,
          //         padding: EdgeInsets.symmetric(vertical: heightDp * 10),
          //         decoration: BoxDecoration(
          //           border: Border(
          //             top: BorderSide(color: Colors.grey.withOpacity(0.7)),
          //           ),
          //         ),
          //         child: Center(
          //           child: Text(
          //             "Buy ${widget.b2bOrderModel!.coupon!.discountData!["customerBogo"]["buy"]["quantity"]} "
          //             "Get ${widget.b2bOrderModel!.coupon!.discountData!["customerBogo"]["get"]["quantity"]} "
          //             "${widget.b2bOrderModel!.coupon!.discountData!["customerBogo"]["get"]["type"] == "Free" ? 'Free' : widget.b2bOrderModel!.coupon!.discountData!["customerBogo"]["get"]["percentValue"].toString() + ' % OFF'}",
          //             style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          //           ),
          //         ),
          //       ),
          //       Column(
          //         children: List.generate(widget.b2bOrderModel!.bogoProducts!.length, (index) {
          //           ProductOrderModel productOrderModel = widget.b2bOrderModel!.products![index];
          //           return Column(
          //             children: [
          //               Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          //               ProductOrderWidget(
          //                 productOrderModel: productOrderModel,
          //                 b2bOrderModel: widget.b2bOrderModel,
          //                 index: index,
          //                 // deleteCallback: (int index) {
          //                 //   widget.b2bOrderModel!.products!.removeAt(index);
          //                 //   setState(() {});
          //                 //   if (widget.refreshCallback != null) {
          //                 //     widget.refreshCallback!(widget.b2bOrderModel);
          //                 //   }
          //                 // },
          //                 // refreshCallback: widget.refreshCallback,
          //               ),
          //             ],
          //           );
          //         }),
          //       ),
          //       Column(
          //         children: List.generate(widget.b2bOrderModel!.bogoServices!.length, (index) {
          //           ServiceOrderModel serviceOrderModel = widget.b2bOrderModel!.services![index];
          //           return Column(
          //             children: [
          //               Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          //               ServiceOrderWidget(
          //                 serviceOrderModel: serviceOrderModel,
          //                 b2bOrderModel: widget.b2bOrderModel,
          //                 index: index,
          //                 // deleteCallback: (int index) {
          //                 //   widget.b2bOrderModel!.services!.removeAt(index);
          //                 //   setState(() {});
          //                 //   if (widget.refreshCallback != null) {
          //                 //     widget.refreshCallback!(widget.b2bOrderModel);
          //                 //   }
          //                 // },
          //                 // refreshCallback: widget.refreshCallback,
          //               ),
          //             ],
          //           );
          //         }),
          //       ),
          //     ],
          //   ),
        ],
      ),
    );
  }
}
