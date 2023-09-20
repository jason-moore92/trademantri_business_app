import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/transaction_item.dart';

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

class TransactionDetails extends StatefulWidget {
  final WalletTransaction? transaction;

  TransactionDetails({
    this.transaction,
  });

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

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

    transaction = widget.transaction;

    widthDp = ScreenUtil().setWidth(1);
    // heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Transaction Details",
          style: TextStyle(
            fontSize: fontSp * 18,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16.0,
            ),
            if (transaction!.credit != 0.0)
              Center(
                child: Container(
                  padding: EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                    ),
                  ),
                  child: Text(
                    "+ ${transaction!.credit.toString()}",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: fontSp * 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (transaction!.debit != 0.0)
              Center(
                child: Container(
                  padding: EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red,
                    ),
                  ),
                  child: Text(
                    "- ${transaction!.debit.toString()}",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: fontSp * 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              child: Text(
                "₹ ${transaction!.outStanding.toString()}",
                style: TextStyle(
                  fontSize: fontSp * 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                transaction!.narration!,
                style: TextStyle(
                  fontSize: fontSp * 14,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              child: Text(
                KeicyDateTime.convertDateTimeToDateString(
                  dateTime: transaction!.date,
                  formats: "Y-m-d H:i",
                  isUTC: false,
                ),
                style: TextStyle(
                  fontSize: fontSp * 16,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reference Id:",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    transaction!.reqReferenceId!,
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Is Refund:",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    transaction!.isRefund! ? "Yes" : "No",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Is Settled:",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    transaction!.settled! ? "Yes" : "No",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (transaction!.parent != null) ...[
              SizedBox(
                height: 32.0,
              ),
              Container(
                width: deviceWidth,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Parent Transaction",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: TransactionItem(
                  transaction: transaction!.parent,
                  detailCallback: () {
                    // _detailCallback(
                    //   transaction: transaction,
                    // );
                  },
                ),
              )
            ],
            //TODO:: here we need to keep order details or settlement details.
            if (transaction!.meta != null && transaction!.meta!.orderId != null) ...[
              SizedBox(
                height: 32.0,
              ),
              Container(
                width: deviceWidth,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Related Order",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(transaction!.meta!.orderId!),
              )
            ]
          ],
        ),
      ),
    );
  }
}
