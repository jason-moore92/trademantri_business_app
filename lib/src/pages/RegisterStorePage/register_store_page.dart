import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class RegisterStorePage extends StatelessWidget {
  final String? referredBy;
  final String? referredByUserId;
  final String? appliedFor;

  RegisterStorePage({this.referredBy, this.referredByUserId, this.appliedFor});

  @override
  Widget build(BuildContext context) {
    return RegisterStoreView(referredBy: referredBy, referredByUserId: referredByUserId, appliedFor: appliedFor);
  }
}
