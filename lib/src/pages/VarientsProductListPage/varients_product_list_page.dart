import 'package:flutter/material.dart';

import 'index.dart';

class VarientsProuctListPage extends StatelessWidget {
  final List<dynamic>? varients;
  final Map<String, dynamic>? productData;
  final String? imgLocation;

  VarientsProuctListPage({@required this.varients, @required this.productData, @required this.imgLocation});

  @override
  Widget build(BuildContext context) {
    return VarientsProuctListView(varients: varients, productData: productData, imgLocation: imgLocation);
  }
}
