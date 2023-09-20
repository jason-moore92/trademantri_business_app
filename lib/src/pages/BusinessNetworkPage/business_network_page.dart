import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/providers/BusinessNetworkStatusProvider/index.dart';

import 'index.dart';

class BusinessNetworkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BusinessNetworkStatusProvider()),
      ],
      child: BusinessNetworkView(),
    );
  }
}
