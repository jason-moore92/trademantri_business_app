import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class BusinessStoresPage extends StatelessWidget {
  final String? status;
  final bool? forSelection;

  BusinessStoresPage({@required this.status, this.forSelection = false});

  @override
  Widget build(BuildContext context) {
    return BusinessStoresView(status: status, forSelection: forSelection);
  }
}
