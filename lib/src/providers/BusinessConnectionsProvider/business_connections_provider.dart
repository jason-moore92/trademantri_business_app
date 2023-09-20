import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class BusinessConnectionsProvider extends ChangeNotifier {
  static BusinessConnectionsProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<BusinessConnectionsProvider>(context, listen: listen);

  BusinessConnectionsState _businessConnectionsState = BusinessConnectionsState.init();
  BusinessConnectionsState get businessConnectionsState => _businessConnectionsState;

  void setBusinessConnectionsState(BusinessConnectionsState businessConnectionsState, {bool isNotifiable = true}) {
    if (_businessConnectionsState != businessConnectionsState) {
      _businessConnectionsState = businessConnectionsState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getStoreList({
    @required String? storeId,
    @required List<dynamic>? types,
    @required List<dynamic>? categoryData,
    @required Map<String, dynamic>? location,
    String searchKey = "",
  }) async {
    List<dynamic>? storeList = _businessConnectionsState.storeList;
    Map<String, dynamic>? storeMetaData = _businessConnectionsState.storeMetaData;
    List<dynamic>? categoryIds = [];
    for (var i = 0; i < categoryData!.length; i++) {
      categoryIds.add(categoryData[i]["categoryId"]);
    }

    try {
      if (storeList == null) storeList = [];
      if (storeMetaData == null) storeMetaData = Map<String, dynamic>();

      var result;
      result = await StoreApiProvider.getStoreList(
        storeId: storeId,
        types: types,
        categoryIds: categoryIds,
        location: location,
        searchKey: searchKey,
        page: storeMetaData.isEmpty ? 1 : (storeMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          storeList.add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        storeMetaData = result["data"];

        _businessConnectionsState = _businessConnectionsState.update(
          progressState: 2,
          storeList: storeList,
          storeMetaData: storeMetaData,
        );
      } else {
        _businessConnectionsState = _businessConnectionsState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _businessConnectionsState = _businessConnectionsState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  void updateHandler({@required StoreModel? storeModel, @required BusinessConnectionModel? connectionModel}) {
    for (var i = 0; i < _businessConnectionsState.storeList!.length; i++) {
      if (_businessConnectionsState.storeList![i]["_id"] == storeModel!.id) {
        _businessConnectionsState.storeList![i] = storeModel.toJson();
        _businessConnectionsState.storeList![i]["connectionModel"] = connectionModel!.toJson();
        _businessConnectionsState = _businessConnectionsState.update(
          storeList: _businessConnectionsState.storeList,
        );
        break;
      }
    }
    notifyListeners();
  }
}
