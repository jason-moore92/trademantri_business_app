import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class CouponViewPage extends StatefulWidget {
  final CouponModel? couponModel;
  final StoreModel? storeModel;
  final String? couponId;

  CouponViewPage({this.storeModel, this.couponModel, this.couponId});

  @override
  _CouponViewPageState createState() => _CouponViewPageState();
}

class _CouponViewPageState extends State<CouponViewPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.couponModel == null && widget.couponId != null) {
      return StreamBuilder<dynamic>(
        stream: Stream.fromFuture(
          CouponsApiProvider.getCoupon(couponId: widget.couponId),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          }

          if (snapshot.hasError || !snapshot.data["success"] || snapshot.data["data"].isEmpty) {
            return ErrorPage(
              message: "Something Wrong",
              callback: () {
                setState(() {});
              },
            );
          }

          return CouponViewView(
            storeModel: StoreModel.fromJson(snapshot.data["data"][0]["store"]),
            couponModel: CouponModel.fromJson(snapshot.data["data"][0]),
          );
        },
      );
    }
    return CouponViewView(storeModel: widget.storeModel, couponModel: widget.couponModel);
  }
}
