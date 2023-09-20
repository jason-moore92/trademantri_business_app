import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class RewardPointsForCustomerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RewardPointsForCustomerProvider()),
      ],
      child: RewardPointsForCustomerView(),
    );
  }
}
