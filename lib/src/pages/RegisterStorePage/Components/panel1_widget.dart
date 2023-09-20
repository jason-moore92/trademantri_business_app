import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import '../index.dart';
import 'package:trapp/environment.dart';

class Panel1Widget extends StatefulWidget {
  final int? stepCount;
  final int? step;
  final int? completedStep;
  final StoreModel? storeModel;
  final Function(int)? callback;
  final Function(String)? businessTypeCallback;

  Panel1Widget({
    @required this.stepCount,
    @required this.step,
    @required this.completedStep,
    @required this.storeModel,
    @required this.callback,
    @required this.businessTypeCallback,
  });

  @override
  _Panel1WidgetState createState() => _Panel1WidgetState();
}

class _Panel1WidgetState extends State<Panel1Widget> {
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

    widget.storeModel!.businessType = widget.storeModel!.businessType ?? "";

    if (Environment.enableFBEvents!) {
      getFBAppEvents().logViewContent(
        type: "sub_page",
        id: "register_step1",
        content: {
          "version": "3.0.1",
        },
        currency: "INR",
        price: 0.0,
      );
    }
  }

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

    return Container(
      width: deviceWidth,
      height: deviceHeight - statusbarHeight - appbarHeight,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: Column(
        children: [
          HeaderWidget(
            stepCount: widget.stepCount,
            step: widget.step,
            completedStep: widget.completedStep,
            callback: (step) {
              widget.callback!(step);
            },
          ),
          Expanded(child: _mainPanel()),
          NextButtonWidget(
            step: widget.step,
            storeModel: widget.storeModel,
            isNextPossible: widget.storeModel!.businessType != "",
            callback: () {
              widget.callback!(widget.step! + 1);
            },
          ),
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }

  Widget _mainPanel() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: heightDp * 20),
          Text(
            RegisterStorePageString.step1Title,
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
          ),
          SizedBox(height: heightDp * 20),
          Text(
            RegisterStorePageString.step1Desc1,
            style: TextStyle(
              fontSize: fontSp * 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: RegisterStorePageString.step1Desc2,
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: RegisterStorePageString.step1Desc3,
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightDp * 15),
          Text(
            RegisterStorePageString.step1Desc4,
            style: TextStyle(
              fontSize: fontSp * 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: RegisterStorePageString.step1Desc5,
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: RegisterStorePageString.step1Desc6,
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: heightDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.storeModel!.businessType = "store";
                    widget.storeModel!.type = "";
                    widget.storeModel!.servicetype = "";
                    widget.businessTypeCallback!(widget.storeModel!.businessType!);
                    widget.storeModel!.subType = "";
                  });
                },
                child: Container(
                  width: widthDp * 100,
                  height: heightDp * 50,
                  decoration: BoxDecoration(
                    color: widget.storeModel!.businessType == "store" ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(heightDp * 8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Store",
                    style: TextStyle(
                      fontSize: fontSp * 18,
                      color: widget.storeModel!.businessType == "store" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.storeModel!.businessType = "services";
                    widget.storeModel!.type = "Service";
                    widget.storeModel!.servicetype = "Service";
                    widget.businessTypeCallback!(widget.storeModel!.businessType!);
                    widget.storeModel!.subType = "";
                  });
                },
                child: Container(
                  width: widthDp * 100,
                  height: heightDp * 50,
                  decoration: BoxDecoration(
                    color: widget.storeModel!.businessType == "services" ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(heightDp * 8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Services",
                    style: TextStyle(
                      fontSize: fontSp * 18,
                      color: widget.storeModel!.businessType == "services" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }
}
