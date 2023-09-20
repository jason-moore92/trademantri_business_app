import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class PurchaseProductItemDetailPage extends StatelessWidget {
  final String? category;
  final PurchaseModel? purchaseModel;
  final PurchaseItemModel? purchaseItemModel;

  PurchaseProductItemDetailPage({
    @required this.category,
    @required this.purchaseModel,
    @required this.purchaseItemModel,
  });

  @override
  Widget build(BuildContext context) {
    return PurchaseProductItemDetailView(
      category: category,
      purchaseModel: purchaseModel,
      purchaseItemModel: purchaseItemModel,
    );
  }
}
