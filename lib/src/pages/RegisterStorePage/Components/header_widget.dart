import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;

class HeaderWidget extends StatelessWidget {
  int? step;
  int? completedStep;
  int? stepCount;
  Function(int)? callback;

  HeaderWidget({
    @required this.stepCount,
    @required this.step,
    @required this.completedStep,
    @required this.callback,
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
        Image.asset("img/logo.png", width: widthDp * 200, fit: BoxFit.fitWidth),
        stepIndicator(),
      ],
    );
  }

  Widget stepIndicator() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(vertical: heightDp * 20),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(stepCount!, (index) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (step! >= index + 1) {
                    callback!(index + 1);
                  }
                  //  if (completedStep > index) {
                  //   callback(index + 1);
                  // }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: step! > index ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                      width: 3,
                    ),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(heightDp * 7),
                  alignment: Alignment.center,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: step! > index ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              index == stepCount! - 1
                  ? SizedBox()
                  : Container(
                      width: stepCount == 6 ? widthDp * 34 : widthDp * 50,
                      child: Divider(
                        height: 3,
                        thickness: 3,
                        color: step! > index + 1 ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                      ),
                    )
            ],
          );
        }),
      ),
    );
  }
}
