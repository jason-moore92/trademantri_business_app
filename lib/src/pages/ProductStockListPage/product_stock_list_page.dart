import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class ProductStockListPage extends StatelessWidget {
  final bool haveAppBar;
  final ProductModel? product;

  ProductStockListPage({this.haveAppBar = false, this.product});

  @override
  Widget build(BuildContext context) {
    return ProductStockListView(
      haveAppBar: haveAppBar,
      product: product,
    );
  }
}
