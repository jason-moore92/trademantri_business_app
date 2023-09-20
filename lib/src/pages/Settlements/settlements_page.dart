import 'package:flutter/material.dart';

import 'index.dart';

class SettlementsPage extends StatelessWidget {
  final bool haveAppBar;

  SettlementsPage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return SettlementsView(haveAppBar: haveAppBar);
  }
}
