import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class PaymentLinkProductListView extends StatefulWidget {
  final Map<String, dynamic>? paymentLinkData;

  PaymentLinkProductListView({Key? key, this.paymentLinkData}) : super(key: key);

  @override
  _PaymentLinkProductListViewState createState() => _PaymentLinkProductListViewState();
}

class _PaymentLinkProductListViewState extends State<PaymentLinkProductListView> with SingleTickerProviderStateMixin {
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

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Products & Services",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Column(
            children: List.generate(
              widget.paymentLinkData!["products"].length,
              (index) {
                return ProductItemForSelectionWidget(
                  selectedProducts: [],
                  productModel:
                      widget.paymentLinkData!["products"][index].isEmpty ? null : ProductModel.fromJson(widget.paymentLinkData!["products"][index]),
                  storeModel: AuthProvider.of(context).authState.storeModel,
                  isLoading: widget.paymentLinkData!["products"][index].isEmpty,
                );
              },
            ),
          ),
          Column(
            children: List.generate(
              widget.paymentLinkData!["services"].length,
              (index) {
                return ServiceItemForSelectionWidget(
                  selectedServices: [],
                  serviceModel:
                      widget.paymentLinkData!["services"][index].isEmpty ? null : ServiceModel.fromJson(widget.paymentLinkData!["services"][index]),
                  storeModel: AuthProvider.of(context).authState.storeModel,
                  isLoading: widget.paymentLinkData!["services"][index].isEmpty,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
