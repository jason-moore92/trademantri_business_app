import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/StoreReviewPageProvider/index.dart';

import 'index.dart';

class StoreReviewPage extends StatelessWidget {
  final StoreModel? storeModel;

  StoreReviewPage({@required this.storeModel});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreReviewPageProvider()),
      ],
      child: StoreReviewView(storeModel: storeModel),
    );
  }
}
