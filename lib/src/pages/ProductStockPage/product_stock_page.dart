import 'package:flutter/material.dart';
import 'package:trapp/src/entities/product_stock.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class ProductStockPage extends StatelessWidget {
  final bool isNew;
  final ProductStock? productStock;
  final ProductModel? product;

  ProductStockPage({
    this.isNew = true,
    this.productStock,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ProductStockView(
      isNew: isNew,
      productStock: productStock,
      product: product,
    );
  }
}
