import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class CouponListPage extends StatelessWidget {
  final StoreModel? storeModel;
  final bool? isForSelection;
  final bool? isForBusiness;

  CouponListPage({
    @required this.storeModel,
    this.isForSelection = false,
    this.isForBusiness = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CouponListProvider()),
      ],
      child: CouponListView(
        storeModel: storeModel,
        isForSelection: isForSelection,
        isForBusiness: isForBusiness,
      ),
    );
  }
}
