import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/varient_product_widget.dart';
import 'package:trapp/src/providers/index.dart';

class VarientsProuctListView extends StatefulWidget {
  final List<dynamic>? varients;
  final Map<String, dynamic>? productData;
  final String? imgLocation;

  VarientsProuctListView({Key? key, this.varients, this.productData, this.imgLocation}) : super(key: key);

  @override
  _VarientsProuctListViewState createState() => _VarientsProuctListViewState();
}

class _VarientsProuctListViewState extends State<VarientsProuctListView> with SingleTickerProviderStateMixin {
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
          "Item Variants",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: ListView.builder(
          itemCount: widget.varients!.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> varientData1 = widget.varients![index];

            return VarientProductWidget(
              varientData: varientData1,
              productData: widget.productData,
              imgLocation: widget.imgLocation,
              isLoading: varientData1.isEmpty,
            );
          },
        ),
      ),
    );
  }
}
