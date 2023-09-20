import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class B2BOrderDetailPage extends StatefulWidget {
  final B2BOrderModel? b2bOrderModel;
  final String? orderId;
  final String? myStoreId;
  final String? businessStoreId;

  B2BOrderDetailPage({
    this.b2bOrderModel,
    this.orderId,
    this.myStoreId,
    this.businessStoreId,
  });

  @override
  _B2BOrderDetailPageState createState() => _B2BOrderDetailPageState();
}

class _B2BOrderDetailPageState extends State<B2BOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double heightDp = ScreenUtil().setWidth(1);

    if (widget.b2bOrderModel == null && widget.orderId != null) {
      return StreamBuilder<dynamic>(
          stream: Stream.fromFuture(
            B2BOrderApiProvider.getOrder(
              orderId: widget.orderId,
              myStoreId: widget.myStoreId,
              businessStoreId: widget.businessStoreId,
            ),
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isNotEmpty) {
                  return B2BOrderDetailView(b2bOrderModel: B2BOrderModel.fromJson(snapshot.data["data"][0]));
                } else if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isEmpty) {
                  return Scaffold(
                    body: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: heightDp * 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your store is not part of this order",
                              style: TextStyle(fontSize: fontSp * 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: heightDp * 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 15, vertical: heightDp * 5),
                                decoration: BoxDecoration(
                                  color: config.Colors().mainColor(1),
                                  borderRadius: BorderRadius.circular(heightDp * 8),
                                ),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return ErrorPage(
                    message: snapshot.hasData ? snapshot.data["message"] ?? "" : "Something Wrong",
                    callback: () {
                      setState(() {});
                    },
                  );
                }
              default:
            }
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          });
    }
    return B2BOrderDetailView(b2bOrderModel: widget.b2bOrderModel);
  }
}
