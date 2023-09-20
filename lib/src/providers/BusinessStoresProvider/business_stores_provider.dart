import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class BusinessStoresProvider extends ChangeNotifier {
  static BusinessStoresProvider of(BuildContext context, {bool listen = false}) => Provider.of<BusinessStoresProvider>(context, listen: listen);

  BusinessStoresState _businessStoresState = BusinessStoresState.init();
  BusinessStoresState get businessStoresState => _businessStoresState;

  void setBusinessStoresState(BusinessStoresState businessStoresState, {bool isNotifiable = true}) {
    if (_businessStoresState != businessStoresState) {
      _businessStoresState = businessStoresState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getStoreList({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? storeList = _businessStoresState.storeList;
    Map<String, dynamic>? storeMetaData = _businessStoresState.storeMetaData;

    try {
      if (storeList == null) storeList = Map<String, dynamic>();
      if (storeList[status] == null) storeList[status!] = [];
      if (storeMetaData == null) storeMetaData = Map<String, dynamic>();

      var result;
      result = await BusinessConnectionsApiProvider.connectedStores(
        storeId: storeId,
        status: status,
        searchKey: searchKey,
        page: storeMetaData.isEmpty ? 1 : (storeMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          storeList[status!].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        storeMetaData = result["data"];

        _businessStoresState = _businessStoresState.update(
          progressState: 2,
          storeList: storeList,
          storeMetaData: storeMetaData,
        );
      } else {
        _businessStoresState = _businessStoresState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _businessStoresState = _businessStoresState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
