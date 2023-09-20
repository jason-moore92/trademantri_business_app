import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class ServiceListPage extends StatelessWidget {
  final List<ServiceModel>? selectedServices;
  final List<String>? storeIds;
  final StoreModel? storeModel;
  final bool isForSelection;
  final bool isForB2b;
  final bool showDetailButton;

  ServiceListPage({
    @required this.selectedServices,
    @required this.storeIds,
    @required this.storeModel,
    this.isForSelection = false,
    this.isForB2b = false,
    this.showDetailButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceListPageProvider()),
      ],
      child: ServiceListView(
        selectedServices: selectedServices,
        storeIds: storeIds,
        storeModel: storeModel,
        isForSelection: isForSelection,
        isForB2b: isForB2b,
        showDetailButton: showDetailButton,
      ),
    );
  }
}
