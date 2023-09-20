import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class CustomerRecentOrdersPage extends StatelessWidget {
  final UserModel? user;
  CustomerRecentOrdersPage({
    this.user,
  });
  @override
  Widget build(BuildContext context) {
    return CustomerRecentOrdersView(
      user: user,
    );
  }
}
