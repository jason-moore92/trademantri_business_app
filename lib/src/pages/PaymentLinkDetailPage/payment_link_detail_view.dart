import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class PaymentLinkDetailView extends StatefulWidget {
  final Map<String, dynamic>? paymentLinkData;

  PaymentLinkDetailView({Key? key, this.paymentLinkData}) : super(key: key);

  @override
  _PaymentLinkDetailViewState createState() => _PaymentLinkDetailViewState();
}

class _PaymentLinkDetailViewState extends State<PaymentLinkDetailView> with SingleTickerProviderStateMixin {
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

  var numFormat = NumberFormat.currency(symbol: "", name: "");

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalItems = 0;
    double totalPrice = 0;

    for (var i = 0; i < widget.paymentLinkData!["products"].length; i++) {
      totalItems += widget.paymentLinkData!["products"][i]["orderQuantity"];
      totalPrice += double.parse(widget.paymentLinkData!["products"][i]["price"].toString()) -
          (widget.paymentLinkData!["products"][i]["discount"] != null && widget.paymentLinkData!["products"][i]["discount"] != ""
              ? double.parse(widget.paymentLinkData!["products"][i]["discount"].toString())
              : 0);
    }

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
          "Payment Link Details",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
            child: Column(
              children: [
                ///
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 8),
                  decoration: BoxDecoration(
                    // color: config.Colors().mainColor(1),
                    color: widget.paymentLinkData!["paymentData"]["status"].toString().toLowerCase() == "paid" ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(heightDp * 6),
                  ),
                  child: Text(
                    widget.paymentLinkData!["paymentData"]["status"].toString().toLowerCase() == "paid" ? "Paid" : "Not Paid",
                    // StringHelper.getUpperCaseString(widget.paymentLinkData!["paymentData"]["status"].toString()),
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                ///
                SizedBox(height: heightDp * 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Payment ID : ",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${widget.paymentLinkData!["paymentData"]["id"]}",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "User Name : ",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${widget.paymentLinkData!["user"]["firstName"]} ${widget.paymentLinkData!["user"]["lastName"]}",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "User Email : ",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${widget.paymentLinkData!["user"]["email"]}",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "User Phone : ",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${widget.paymentLinkData!["user"]["mobile"]}",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 20),
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),

                ///
                SizedBox(height: heightDp * 20),
                Row(
                  children: [
                    Text(
                      "Products & Services",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 20),
                Column(
                  children: List.generate(
                    widget.paymentLinkData!["products"].length,
                    (index) {
                      return ProductItemForSelectionWidget(
                        selectedProducts: [],
                        productModel: widget.paymentLinkData!["products"][index].isEmpty
                            ? null
                            : ProductModel.fromJson(widget.paymentLinkData!["products"][index]),
                        storeModel: AuthProvider.of(context).authState.storeModel,
                        isLoading: widget.paymentLinkData!["products"][index].isEmpty,
                        padding: EdgeInsets.symmetric(vertical: heightDp * 5),
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
                        serviceModel: widget.paymentLinkData!["services"][index].isEmpty
                            ? null
                            : ServiceModel.fromJson(widget.paymentLinkData!["services"][index]),
                        storeModel: AuthProvider.of(context).authState.storeModel,
                        isLoading: widget.paymentLinkData!["services"][index].isEmpty,
                        padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                      );
                    },
                  ),
                ),

                ///
                SizedBox(height: heightDp * 20),
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                SizedBox(height: heightDp * 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KeicyCheckBox(
                      iconSize: heightDp * 25,
                      label: "Reminder Enable",
                      iconColor: config.Colors().mainColor(1),
                      value: widget.paymentLinkData!["paymentData"]["reminder_enable"],
                      readOnly: true,
                      labelSpacing: widthDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 20),
                Row(
                  children: [
                    KeicyCheckBox(
                      iconSize: heightDp * 25,
                      label: "Accept Partial",
                      iconColor: config.Colors().mainColor(1),
                      value: widget.paymentLinkData!["paymentData"]["accept_partial"],
                      readOnly: true,
                      labelSpacing: widthDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    SizedBox(width: widthDp * 15),
                    widget.paymentLinkData!["paymentData"]["accept_partial"]
                        ? Expanded(
                            child: Text(
                              "${widget.paymentLinkData!["paymentData"]["first_min_partial_amount"]}",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),

                ///
                if (widget.paymentLinkData!["paymentData"]["description"] != null && widget.paymentLinkData!["paymentData"]["description"] != "")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 20),
                      Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      SizedBox(height: heightDp * 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description : ",
                            style: TextStyle(
                              fontSize: fontSp * 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: heightDp * 5),
                          Text(
                            "${widget.paymentLinkData!["paymentData"]["description"]}",
                            style: TextStyle(
                              fontSize: fontSp * 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ///
                if (widget.paymentLinkData!["paymentData"]["notes"] != null && widget.paymentLinkData!["paymentData"]["notes"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 20),
                      Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                      SizedBox(height: heightDp * 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.paymentLinkData!["paymentData"]["notes"].keys.first} : ",
                            style: TextStyle(
                              fontSize: fontSp * 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: heightDp * 5),
                          Text(
                            "${widget.paymentLinkData!["paymentData"]["notes"].values.first}",
                            style: TextStyle(
                              fontSize: fontSp * 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ///
                SizedBox(height: heightDp * 20),
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                SizedBox(height: heightDp * 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Total Items: ",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        numFormat.format(totalItems),
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Total Price: ",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        numFormat.format(widget.paymentLinkData!["paymentData"]["amount"] / 100),
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: heightDp * 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
