import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class NewProductPage extends StatelessWidget {
  final String? type;
  final bool? isNew;
  final ProductModel? productModel;

  NewProductPage({
    @required this.type,
    @required this.isNew,
    this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return NewProductView(type: type, isNew: isNew, productModel: productModel);
  }
}
