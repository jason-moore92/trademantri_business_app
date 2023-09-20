import 'package:flutter/material.dart';

import 'index.dart';

class NewCustomerForChatPage extends StatelessWidget {
  final bool fromSidebar;
  final bool fromBottomBar;
  final bool haveAppbar;

  NewCustomerForChatPage({
    this.fromSidebar = false,
    this.fromBottomBar = false,
    this.haveAppbar = true,
  });

  @override
  Widget build(BuildContext context) {
    return NewCustomerForChatView(
      fromSidebar: fromSidebar,
      fromBottomBar: fromBottomBar,
      haveAppbar: haveAppbar,
    );
  }
}
