import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class B2BInvoicePage extends StatelessWidget {
  final B2BOrderModel? b2bOrderModel;
  final bool? isEditItems;
  final bool? isChangeBusiness;

  B2BInvoicePage({@required this.b2bOrderModel, this.isEditItems = false, this.isChangeBusiness = false});

  @override
  Widget build(BuildContext context) {
    return B2BInvoiceView(b2bOrderModel: b2bOrderModel, isEditItems: isEditItems, isChangeBusiness: isChangeBusiness);
  }
}
