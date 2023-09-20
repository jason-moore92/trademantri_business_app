import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';

/// Responsive design variables
double deviceWidth = 0;
double deviceHeight = 0;
double statusbarHeight = 0;
double bottomBarHeight = 0;
double appbarHeight = 0;
double widthDp = 0;
// double heightDp;
double heightDp1 = 0;
double fontSp = 0;

class SettlementItem extends StatefulWidget {
  final Settlement? settlement;
  final Function()? detailCallback;

  SettlementItem({
    this.settlement,
    this.detailCallback,
  });

  @override
  _SettlementItemState createState() => _SettlementItemState();
}

class _SettlementItemState extends State<SettlementItem> {
  Settlement? settlement;
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
    // heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    settlement = widget.settlement;

    return ListTile(
      title: Text(settlement!.referenceNumber!),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(settlement!.notes!),
          Text(
            KeicyDateTime.convertDateTimeToDateString(
              dateTime: settlement!.createdAt,
              formats: "Y-m-d H:i",
              isUTC: false,
            ),
          ),
        ],
      ),
      leading: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: settlement!.mode == "manaual" ? Colors.orange : Colors.brown,
          // borderRadius: BorderRadius.circular(32.0),
          shape: BoxShape.circle,
        ),
        child: Text(
          settlement!.mode == "manaual" ? "M" : "A",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${settlement!.amount.toString()}",
            style: TextStyle(
              color: Colors.green,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            settlement!.status.toString(),
          ),
        ],
      ),
    );
  }
}
