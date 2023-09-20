import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class SettingsPage extends StatelessWidget {
  final bool haveAppbar;

  SettingsPage({this.haveAppbar = true});

  @override
  Widget build(BuildContext context) {
    return SettingsView(haveAppbar: haveAppbar);
  }
}
