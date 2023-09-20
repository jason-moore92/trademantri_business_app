import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import '../index.dart';
import 'package:trapp/config/store_type.dart';
import 'package:trapp/environment.dart';

class Panel4Widget extends StatefulWidget {
  final int? stepCount;
  final int? step;
  final int? completedStep;
  final StoreModel? storeModel;
  final Function? callback;

  Panel4Widget({
    @required this.stepCount,
    @required this.step,
    @required this.completedStep,
    @required this.storeModel,
    @required this.callback,
  });

  @override
  _Panel4WidgetState createState() => _Panel4WidgetState();
}

class _Panel4WidgetState extends State<Panel4Widget> {
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

    widget.storeModel!.type = widget.storeModel!.type ?? "";

    if (Environment.enableFBEvents!) {
      getFBAppEvents().logViewContent(
        type: "sub_page",
        id: "register_step4",
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

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            width: deviceWidth,
            height: deviceHeight - statusbarHeight - appbarHeight,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
            color: Colors.transparent,
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
                SizedBox(height: heightDp * 20),
                NextButtonWidget(
                  step: widget.step,
                  storeModel: widget.storeModel,
                  isNextPossible: widget.storeModel!.type != "",
                  callback: () {
                    widget.callback!(widget.step! + 1);
                  },
                ),
                SizedBox(height: heightDp * 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    List<Map<String, dynamic>> categories = storeTypes;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: heightDp * 20),

          ///
          Container(
            width: deviceWidth,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.end,
              runAlignment: WrapAlignment.spaceBetween,
              spacing: widthDp * 20,
              runSpacing: heightDp * 20,
              children: List.generate(categories.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.storeModel!.type = categories[index]["value"];
                      widget.storeModel!.storetype = categories[index]["value"];
                    });
                  },
                  child: Container(
                    width: widthDp * 160,
                    height: heightDp * 140,
                    decoration: BoxDecoration(
                      color: widget.storeModel!.type == categories[index]["value"] ? config.Colors().mainColor(1) : Colors.white,
                      borderRadius: BorderRadius.circular(heightDp * 8),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, 3), color: Colors.grey.withOpacity(0.4), blurRadius: 6),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    alignment: Alignment.center,
                    child: Text(
                      categories[index]["name"],
                      style: TextStyle(
                        fontSize: fontSp * 14,
                        color: widget.storeModel!.type == categories[index]["value"] ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ),
          ),

          ///
        ],
      ),
    );
  }
}
