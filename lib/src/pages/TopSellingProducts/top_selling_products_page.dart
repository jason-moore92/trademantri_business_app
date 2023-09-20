import 'package:flutter/material.dart';
import 'package:trapp/src/models/user_model.dart';

import 'index.dart';

class TopSellingProductsPage extends StatelessWidget {
  final UserModel? user;

  TopSellingProductsPage({this.user});

  @override
  Widget build(BuildContext context) {
    return TopSellingProductsView(
      user: user,
    );
  }
}
