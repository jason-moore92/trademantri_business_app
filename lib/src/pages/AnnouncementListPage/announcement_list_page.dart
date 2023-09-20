import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class AnnouncementListPage extends StatelessWidget {
  final StoreModel? storeModel;
  final bool? isForBusiness;

  AnnouncementListPage({@required this.storeModel, this.isForBusiness = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnnouncementListProvider()),
      ],
      child: AnnouncementListView(storeModel: storeModel, isForBusiness: isForBusiness),
    );
  }
}
