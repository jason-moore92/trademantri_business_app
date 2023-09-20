import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class InvoicesProvider extends ChangeNotifier {
  static InvoicesProvider of(BuildContext context, {bool listen = false}) => Provider.of<InvoicesProvider>(context, listen: listen);

  InvoicesState _invoicesState = InvoicesState.init();
  InvoicesState get invoicesState => _invoicesState;

  void setInvoicesState(InvoicesState invoicesState, {bool isNotifiable = true}) {
    if (_invoicesState != invoicesState) {
      _invoicesState = invoicesState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getStoreInvoices({@required String? storeId, String searchKey = ""}) async {
    List<dynamic>? invoicesListData = _invoicesState.invoicesListData;
    Map<String, dynamic>? invoicesMetaData = _invoicesState.invoicesMetaData;
    try {
      if (invoicesListData == null) invoicesListData = [];
      if (invoicesMetaData == null) invoicesMetaData = Map<String, dynamic>();

      var result;

      result = await OrderApiProvider.getStoreInvoices(
        storeId: storeId,
        searchKey: searchKey,
        page: invoicesMetaData.isEmpty ? 1 : (invoicesMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          invoicesListData.add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        invoicesMetaData = result["data"];

        _invoicesState = _invoicesState.update(
          progressState: 2,
          invoicesListData: invoicesListData,
          invoicesMetaData: invoicesMetaData,
        );
      } else {
        _invoicesState = _invoicesState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _invoicesState = _invoicesState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
