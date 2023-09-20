import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class PurchaseHistoryProvider extends ChangeNotifier {
  static PurchaseHistoryProvider of(BuildContext context, {bool listen = false}) => Provider.of<PurchaseHistoryProvider>(context, listen: listen);

  PurchaseHistoryState _purchaseHistoryState = PurchaseHistoryState.init();
  PurchaseHistoryState get purchaseHistoryState => _purchaseHistoryState;

  void setPurchaseHistoryState(PurchaseHistoryState purchaseHistoryState, {bool isNotifiable = true}) {
    if (_purchaseHistoryState != purchaseHistoryState) {
      _purchaseHistoryState = purchaseHistoryState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getPurchaseHistoryData({
    @required String? myStoreId,
    @required String? businessStoreId,
    @required String? itemId,
    @required String? category,
    String? eligibility,
    bool? enabled,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? itemList = _purchaseHistoryState.itemList;
    Map<String, dynamic>? itemListMetaData = _purchaseHistoryState.itemListMetaData;
    Map<String, dynamic>? purchaseData = _purchaseHistoryState.purchaseData;

    String status = "$category-$myStoreId-$businessStoreId-$itemId";

    try {
      if (itemListMetaData![status] == null) itemListMetaData[status] = Map<String, dynamic>();

      var result;

      result = await PurchaseOrderApiProvider.getPurchaseHistory(
        myStoreId: myStoreId,
        businessStoreId: businessStoreId,
        itemId: itemId,
        category: category,
        searchKey: searchKey,
        page: itemListMetaData[status].isEmpty ? 1 : (itemListMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        if (itemList![status] == null) itemList[status] = [];

        for (var i = 0; i < result["data"]["docs"].length; i++) {
          PurchaseModel? purchaseModel = PurchaseModel.fromJson(result["data"]["docs"][i]);
          if (category == "products") {
            purchaseData![status] = purchaseModel;
            for (var i = 0; i < purchaseModel.purchaseProducts!.length; i++) {
              if (purchaseModel.purchaseProducts![i].productId == itemId) {
                itemList[status].add(purchaseModel.purchaseProducts![i]);
              }
            }
          }

          if (category == "services") {
            purchaseData![status] = purchaseModel;
            for (var i = 0; i < purchaseModel.purchaseServices!.length; i++) {
              if (purchaseModel.purchaseServices![i].productId == itemId) {
                itemList[status].add(purchaseModel.purchaseServices![i]);
              }
            }
          }
        }
        result["data"].remove("docs");
        itemListMetaData[status] = result["data"];

        _purchaseHistoryState = _purchaseHistoryState.update(
          progressState: 2,
          itemList: itemList,
          itemListMetaData: itemListMetaData,
        );
      } else {
        _purchaseHistoryState = _purchaseHistoryState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _purchaseHistoryState = _purchaseHistoryState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
