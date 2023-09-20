import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class ProductListPage extends StatelessWidget {
  final List<ProductModel>? selectedProducts;
  final List<String>? storeIds;
  final StoreModel? storeModel;
  final bool isForSelection;
  final bool isForB2b;
  final bool showDetailButton;

  ProductListPage({
    this.selectedProducts = const [],
    @required this.storeIds,
    @required this.storeModel,
    this.isForSelection = false,
    this.isForB2b = false,
    this.showDetailButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return ProductListView(
      selectedProducts: selectedProducts,
      storeIds: storeIds,
      storeModel: storeModel,
      isForSelection: isForSelection,
      isForB2b: isForB2b,
      showDetailButton: showDetailButton,
    );
  }
}
