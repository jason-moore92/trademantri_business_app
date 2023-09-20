import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class PurchaseDetailPage extends StatefulWidget {
  final PurchaseModel? purchaseModel;
  final String? purchaseOrderId;

  PurchaseDetailPage({@required this.purchaseModel, this.purchaseOrderId});

  @override
  State<PurchaseDetailPage> createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends State<PurchaseDetailPage> {
  @override
  Widget build(BuildContext context) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double heightDp = ScreenUtil().setWidth(1);

    if (widget.purchaseModel == null && widget.purchaseOrderId != null) {
      return StreamBuilder<dynamic>(
          stream: Stream.fromFuture(
            PurchaseOrderApiProvider.getPurchaseOrder(id: widget.purchaseOrderId),
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isNotEmpty) {
                  return PurchaseDetailView(purchaseModel: PurchaseModel.fromJson(snapshot.data["data"][0]));
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
    return PurchaseDetailView(purchaseModel: widget.purchaseModel);
  }
}
