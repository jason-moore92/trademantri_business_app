import 'package:flutter/material.dart';

import 'index.dart';

class ProductOrdersPage extends StatelessWidget {
  final String? productId;

  ProductOrdersPage({this.productId});

  @override
  Widget build(BuildContext context) {
    return ProductOrdersView(
      productId: productId,
    );
  }
}
