import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class PurchaseListProvider extends ChangeNotifier {
  static PurchaseListProvider of(BuildContext context, {bool listen = false}) => Provider.of<PurchaseListProvider>(context, listen: listen);

  PurchaseListState _purchaseListState = PurchaseListState.init();
  PurchaseListState get purchaseListState => _purchaseListState;

  void setPurchaseListState(PurchaseListState purchaseListState, {bool isNotifiable = true}) {
    if (_purchaseListState != purchaseListState) {
      _purchaseListState = purchaseListState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getPurchaseListData({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, List<PurchaseModel>?>? purchaseLists = _purchaseListState.purchaseLists;
    Map<String, dynamic>? purchaseListMetaData = _purchaseListState.purchaseListMetaData;
    try {
      if (purchaseLists![status] == null) purchaseLists[status!] = [];
      if (purchaseListMetaData![status] == null) purchaseListMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await PurchaseOrderApiProvider.getPurchaseList(
        storeId: storeId,
        status: status,
        searchKey: searchKey,
        page: purchaseListMetaData[status].isEmpty ? 1 : (purchaseListMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          PurchaseModel purchaseModel = PurchaseModel.fromJson(result["data"]["docs"][i]);
          purchaseLists[status]!.add(purchaseModel);
        }
        result["data"].remove("docs");
        purchaseListMetaData[status!] = result["data"];

        _purchaseListState = _purchaseListState.update(
          progressState: 2,
          purchaseLists: purchaseLists,
          purchaseListMetaData: purchaseListMetaData,
        );
      } else {
        _purchaseListState = _purchaseListState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _purchaseListState = _purchaseListState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
