import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class CustomerMonetaryOrdersPage extends StatelessWidget {
  final UserModel? user;
  CustomerMonetaryOrdersPage({
    this.user,
  });
  @override
  Widget build(BuildContext context) {
    return CustomerMonetaryOrdersView(
      user: user,
    );
  }
}
