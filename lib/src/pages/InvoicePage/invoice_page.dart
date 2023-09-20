import 'package:flutter/material.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class InvoicePage extends StatelessWidget {
  final UserModel? userModel;
  final bool? changeCustomer;

  InvoicePage({@required this.userModel, this.changeCustomer = true});

  @override
  Widget build(BuildContext context) {
    return InvoiceView(userModel: userModel, changeCustomer: changeCustomer);
  }
}
