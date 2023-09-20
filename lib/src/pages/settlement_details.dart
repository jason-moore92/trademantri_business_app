import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/settlement_item.dart';

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

class SettlementDetails extends StatefulWidget {
  final Settlement? settlement;

  SettlementDetails({
    this.settlement,
  });

  @override
  _SettlementDetailsState createState() => _SettlementDetailsState();
}

class _SettlementDetailsState extends State<SettlementDetails> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

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

    settlement = widget.settlement;

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
          "Settlement Details",
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
            Center(
              child: Container(
                padding: EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: settlement!.status! == "success" ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  "+ ${settlement!.amount.toString()}",
                  style: TextStyle(
                    color: settlement!.status! == "success" ? Colors.green : Colors.red,
                    fontSize: fontSp * 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                settlement!.notes!,
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
                  dateTime: settlement!.createdAt,
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
                    settlement!.referenceNumber!,
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
                    "Status:",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    settlement!.status!,
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
                    "Mode:",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    settlement!.mode!,
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
                    "Method:",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    settlement!.method!,
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (settlement!.rrn != null) ...[
              SizedBox(
                height: 8.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RRN:",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      settlement!.rrn!,
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
            if (settlement!.accountDetails != null) ...[
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
                      "Account Details",
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
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account Number:",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      settlement!.accountDetails!['accountNumber'],
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
                      "IFSC:",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      settlement!.accountDetails!['routingNumber'],
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
                      "VPA:",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      settlement!.accountDetails!['vpaDetail'],
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Wallet Txn:",
                      style: TextStyle(
                        fontSize: fontSp * 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      settlement!.walletTransactionId!,
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (settlement!.failedReason != null) ...[
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Failed Reason:",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        settlement!.failedReason!,
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
              if (settlement!.walletRefundId != null) ...[
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Refund Txn:",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        settlement!.walletRefundId!,
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ]
          ],
        ),
      ),
    );
  }
}
