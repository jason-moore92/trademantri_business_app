import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class CouponDetailPage extends StatelessWidget {
  final bool? isNew;
  final CouponModel? couponModel;

  CouponDetailPage({@required this.isNew, this.couponModel});

  @override
  Widget build(BuildContext context) {
    return CouponDetailView(isNew: isNew, couponModel: couponModel);
  }
}
