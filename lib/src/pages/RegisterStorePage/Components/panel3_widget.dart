import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import 'package:trapp/src/providers/index.dart';
import '../index.dart';
import 'package:trapp/environment.dart';

class Panel3Widget extends StatefulWidget {
  final int? stepCount;
  final int? step;
  final int? completedStep;
  final StoreModel? storeModel;
  final Function? callback;

  Panel3Widget({
    @required this.stepCount,
    @required this.step,
    @required this.completedStep,
    @required this.storeModel,
    @required this.callback,
  });

  @override
  _Panel3WidgetState createState() => _Panel3WidgetState();
}

class _Panel3WidgetState extends State<Panel3Widget> {
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

    widget.storeModel!.subType = widget.storeModel!.subType ?? "";

    if (CategoryProvider.of(context).categoryState.progressState != 2) {
      CategoryProvider.of(context).setCategoryState(
        CategoryProvider.of(context).categoryState.update(progressState: 0),
        isNotifiable: false,
      );
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (CategoryProvider.of(context).categoryState.progressState != 2) {
        CategoryProvider.of(context).getCategoryAll();
      }
    });

    if (Environment.enableFBEvents!) {
      getFBAppEvents().logViewContent(
        type: "sub_page",
        id: "register_step3",
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
                Text("Select the category of your business"),
                Expanded(child: _mainPanel()),
                SizedBox(height: heightDp * 20),
                NextButtonWidget(
                  step: widget.step,
                  storeModel: widget.storeModel,
                  isNextPossible: widget.storeModel!.subType != null && widget.storeModel!.subType != "",
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
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
      if (categoryProvider.categoryState.progressState == 0) {
        return Center(child: CupertinoActivityIndicator());
      }

      if (categoryProvider.categoryState.progressState == -1) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(categoryProvider.categoryState.message!, style: TextStyle(fontSize: fontSp * 14)),
              SizedBox(height: heightDp * 30),
              KeicyRaisedButton(
                width: widthDp * 120,
                height: heightDp * 40,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text("Try again", style: TextStyle(fontSize: fontSp * 14)),
              ),
            ],
          ),
        );
      }

      //TODO:: Handle no categories returned from server

      // List<Map<String, dynamic>> categories = widget.storeModel!.businessType == "store" ? storeCategories : serviceCategories;
      List<dynamic> categories = widget.storeModel!.businessType == "store"
          ? categoryProvider.categoryState.categoryData!["store"]
          : categoryProvider.categoryState.categoryData!["services"];

      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: heightDp * 20),

            ///
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.end,
              runAlignment: WrapAlignment.spaceBetween,
              spacing: widthDp * 10,
              runSpacing: heightDp * 10,
              children: List.generate(categories.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.storeModel!.subType = categories[index]["categoryId"];
                    });
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 8)),
                    child: Container(
                      width: widthDp * 105,
                      height: heightDp * 150,
                      decoration: BoxDecoration(
                        color: widget.storeModel!.subType == categories[index]["categoryId"]
                            ? config.Colors().mainColor(1).withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(heightDp * 8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Image.asset(
                            "img/category-icon/${categories[index]["categoryId"].toLowerCase()}-icon.png",
                            width: heightDp * 90,
                            height: heightDp * 90,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                categories[index]["categoryDesc"],
                                style: TextStyle(
                                  fontSize: fontSp * 14,
                                  color: Colors.black,
                                  // color: widget.storeModel!.subType == categories[index]["value"] ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            ///
          ],
        ),
      );
    });
  }
}
