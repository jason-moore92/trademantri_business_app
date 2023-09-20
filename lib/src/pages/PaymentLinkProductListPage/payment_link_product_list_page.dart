import 'package:flutter/material.dart';

import 'index.dart';

class PaymentLinkProductListPage extends StatelessWidget {
  final Map<String, dynamic>? paymentLinkData;

  PaymentLinkProductListPage({@required this.paymentLinkData});

  @override
  Widget build(BuildContext context) {
    return PaymentLinkProductListView(paymentLinkData: paymentLinkData);
  }
}
