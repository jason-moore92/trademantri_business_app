import 'package:flutter/material.dart';

import 'index.dart';

class SearchCategoryPage extends StatelessWidget {
  final bool isMultiple;
  final List<dynamic>? selectedCategoryData;

  SearchCategoryPage({this.isMultiple = false, this.selectedCategoryData});

  @override
  Widget build(BuildContext context) {
    return SearchCategoryView(isMultiple: isMultiple, selectedCategoryData: selectedCategoryData);
  }
}
