import 'package:flutter/material.dart';

import 'index.dart';

class WalletPage extends StatelessWidget {
  final bool haveAppBar;

  WalletPage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return WalletView(haveAppBar: haveAppBar);
  }
}
