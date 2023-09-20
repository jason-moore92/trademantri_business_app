import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class DeliveryPartnerListPage extends StatelessWidget {
  final bool haveAppBar;

  DeliveryPartnerListPage({this.haveAppBar = true});

  @override
  Widget build(BuildContext context) {
    return DeliveryPartnerListView(haveAppBar: haveAppBar);
  }
}
