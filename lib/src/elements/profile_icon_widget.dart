import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/pages/ProfilePage/index.dart';
import 'package:trapp/src/pages/QRcodeScanPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class ProfileIconWidget extends StatelessWidget {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
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
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ProfilePage(haveAppbar: true)));
      },
      child: Center(
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          color: Colors.transparent,
          child: Icon(
            Icons.person_outline,
            size: heightDp * 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
