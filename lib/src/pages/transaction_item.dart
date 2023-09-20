import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';

class TransactionItem extends StatefulWidget {
  final WalletTransaction? transaction;
  final Function()? detailCallback;

  TransactionItem({
    this.transaction,
    this.detailCallback,
  });

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
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
  WalletTransaction? transaction;

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
    transaction = widget.transaction;

    return ListTile(
      title: Text(transaction!.reqReferenceId!),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transaction!.narration!),
          Text(
            KeicyDateTime.convertDateTimeToDateString(
              dateTime: transaction!.date,
              formats: "Y-m-d H:i",
              isUTC: false,
            ),
          ),
        ],
      ),
      leading: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: transaction!.isRefund! ? Colors.orange : Colors.brown,
          // borderRadius: BorderRadius.circular(32.0),
          shape: BoxShape.circle,
        ),
        child: Text(
          transaction!.isRefund! ? "R" : "T",
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
          if (transaction!.credit != 0.0)
            Text(
              "+ ${transaction!.credit.toString()}",
              style: TextStyle(
                color: Colors.green,
                fontSize: 16.0,
              ),
            ),
          if (transaction!.debit != 0.0)
            Text(
              "- ${transaction!.debit.toString()}",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.red,
              ),
            ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            transaction!.outStanding.toString(),
          ),
        ],
      ),
      onTap: () {
        if (widget.detailCallback != null) {
          widget.detailCallback!();
        }
      },
    );
  }
}
