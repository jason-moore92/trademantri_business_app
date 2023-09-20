import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/product_bargain_new_widget.dart';
import 'package:trapp/src/elements/service_bargain_new_widget.dart';
import 'package:trapp/src/models/index.dart';

class CartListPanel extends StatefulWidget {
  final BargainRequestModel? bargainRequestModel;
  final Function? updateQuantityCallback;
  final Function()? refreshCallback;

  CartListPanel({
    @required this.bargainRequestModel,
    @required this.updateQuantityCallback,
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
            children: List.generate(widget.bargainRequestModel!.products!.length, (index) {
              ProductOrderModel productOrderModel = widget.bargainRequestModel!.products![index];

              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ProductBargainNewWidget(
                    productOrderModel: productOrderModel,
                    bargainRequestModel: widget.bargainRequestModel,
                    updateQuantityCallback: widget.updateQuantityCallback,
                    refreshCallback: widget.refreshCallback,
                  ),
                ],
              );
            }),
          ),
          Column(
            children: List.generate(widget.bargainRequestModel!.services!.length, (index) {
              ServiceOrderModel serviceOrderModel = widget.bargainRequestModel!.services![index];

              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ServiceBargainNewWidget(
                    serviceOrderModel: serviceOrderModel,
                    bargainRequestModel: widget.bargainRequestModel,
                    updateQuantityCallback: widget.updateQuantityCallback,
                    refreshCallback: widget.refreshCallback,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
