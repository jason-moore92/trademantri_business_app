import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/login.dart';
import '../index.dart';

class NextButtonWidget extends StatelessWidget {
  int? step;
  StoreModel? storeModel;
  Function()? callback;
  bool? isNextPossible;
  bool isSubmitButton;

  NextButtonWidget({
    @required this.storeModel,
    @required this.callback,
    @required this.step,
    @required this.isNextPossible,
    this.isSubmitButton = false,
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

    return Column(
      children: [
        KeicyRaisedButton(
          color: isNextPossible! ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
          height: heightDp * 40,
          borderRadius: heightDp * 8,
          child: Text(
            isSubmitButton ? "Register" : "Next Step",
            style: TextStyle(fontSize: fontSp * 16, color: isNextPossible! ? Colors.white : Colors.black),
          ),
          onPressed: !isNextPossible! ? null : callback!,
        ),
        SizedBox(height: heightDp * 20),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => LoginWidget(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                RegisterStorePageString.loginString1,
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Text(
                RegisterStorePageString.loginString2,
                style: TextStyle(fontSize: fontSp * 14, color: config.Colors().mainColor(1), fontWeight: FontWeight.w900),
              )
            ],
          ),
        ),
      ],
    );
  }
}
