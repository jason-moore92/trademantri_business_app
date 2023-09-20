import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/pages/B2BOrderListPage/received_invoice_panel.dart';
import 'package:trapp/src/pages/B2BOrderListPage/sent_invoice_panel.dart';
import 'package:trapp/src/providers/index.dart';

class B2BOrderListView extends StatefulWidget {
  B2BOrderListView({Key? key}) : super(key: key);

  @override
  _B2BOrderListViewState createState() => _B2BOrderListViewState();
}

class _B2BOrderListViewState extends State<B2BOrderListView> with SingleTickerProviderStateMixin {
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

  bool isSent = true;

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
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    B2BOrderProvider.of(context).setB2BOrderState(
      B2BOrderProvider.of(context).b2bOrderState.update(
            sentOrderListData: Map<String, dynamic>(),
            sentOrderMetaData: Map<String, dynamic>(),
            sentProgressState: 0,
            receivedOrderListData: Map<String, dynamic>(),
            receivedOrderMetaData: Map<String, dynamic>(),
            receivedProgressState: 0,
          ),
      isNotifiable: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "B2B Orders",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: heightDp * 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          groupValue: isSent,
                          value: true,
                          onChanged: (value) {
                            isSent = true;
                            setState(() {});
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            isSent = true;
                            setState(() {});
                          },
                          child: Text(
                            "Sent",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: heightDp * 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          groupValue: isSent,
                          value: false,
                          onChanged: (value) {
                            isSent = false;
                            setState(() {});
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            isSent = false;
                            setState(() {});
                          },
                          child: Text(
                            "Received",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: heightDp * 5),
            if (isSent)
              Expanded(
                child: SentInvoicePanel(),
              )
            else
              Expanded(
                child: ReceivedInvoicePanel(),
              ),
          ],
        ),
      ),
    );
  }
}
