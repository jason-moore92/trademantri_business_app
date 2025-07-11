import 'package:flutter/material.dart';

import 'index.dart';

class CustomProductPage extends StatelessWidget {
  final Function(String, List<dynamic>)? callback;

  CustomProductPage({@required this.callback});

  @override
  Widget build(BuildContext context) {
    return CustomProductView(callback: callback);
  }
}
