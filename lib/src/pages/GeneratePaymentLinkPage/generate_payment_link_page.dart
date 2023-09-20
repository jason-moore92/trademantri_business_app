import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class GeneratePaymentLinkPage extends StatelessWidget {
  final Map<String, dynamic>? customerData;
  final StoreModel? storeModel;

  GeneratePaymentLinkPage({@required this.customerData, @required this.storeModel});

  @override
  Widget build(BuildContext context) {
    return GeneratePaymentLinkView(customerData: customerData, storeModel: storeModel);
  }
}
