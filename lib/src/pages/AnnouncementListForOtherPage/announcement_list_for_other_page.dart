import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class AnnouncementListForOtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnnouncementListProvider()),
      ],
      child: AnnouncementListForOtherView(),
    );
  }
}
