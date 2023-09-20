import 'package:flutter/material.dart';

import 'index.dart';

class NotificationListPage extends StatelessWidget {
  final bool haveAppBar;

  NotificationListPage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return NotificationListView(haveAppBar: haveAppBar);
  }
}
