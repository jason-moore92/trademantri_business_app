import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class BusinessInvitationsProvider extends ChangeNotifier {
  static BusinessInvitationsProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<BusinessInvitationsProvider>(context, listen: listen);

  BusinessInvitationsState _businessInvitationsPageState = BusinessInvitationsState.init();
  BusinessInvitationsState get businessInvitationsPageState => _businessInvitationsPageState;

  void setBusinessInvitationsState(BusinessInvitationsState businessInvitationsPageState, {bool isNotifiable = true, bool isRefresh = false}) {
    if (_businessInvitationsPageState != businessInvitationsPageState) {
      _businessInvitationsPageState = businessInvitationsPageState;
      if (isNotifiable) notifyListeners();
    } else {
      if (isRefresh) {
        notifyListeners();
      }
    }
  }

  Future<void> requestedStores({
    @required String? recepientId,
    @required List<String>? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? requestedStoreList = _businessInvitationsPageState.requestedStoreList;
    Map<String, dynamic>? requestedStoreMetaData = _businessInvitationsPageState.requestedStoreMetaData;

    try {
      String statusStr = status!.join('_');
      if (requestedStoreList == null) requestedStoreList = Map<String, dynamic>();
      if (requestedStoreList[statusStr] == null) requestedStoreList[statusStr] = [];
      if (requestedStoreMetaData == null) requestedStoreMetaData = Map<String, dynamic>();

      var result;
      result = await BusinessConnectionsApiProvider.requestedStores(
        recepientId: recepientId,
        status: status,
        searchKey: searchKey,
        page: requestedStoreMetaData.isEmpty ? 1 : (requestedStoreMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          requestedStoreList[statusStr].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        requestedStoreMetaData = result["data"];

        _businessInvitationsPageState = _businessInvitationsPageState.update(
          progressState: 3,
          requestedStoreList: requestedStoreList,
          requestedStoreMetaData: requestedStoreMetaData,
        );
      } else {
        _businessInvitationsPageState = _businessInvitationsPageState.update(
          progressState: 3,
        );
      }
    } catch (e) {
      _businessInvitationsPageState = _businessInvitationsPageState.update(
        progressState: 3,
      );
    }
    notifyListeners();
  }

  Future<void> recepientStores({
    @required String? requestedId,
    @required List<String>? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? recepientStoreList = _businessInvitationsPageState.recepientStoreList;
    Map<String, dynamic>? recepientStoreMetaData = _businessInvitationsPageState.recepientStoreMetaData;

    try {
      String statusStr = status!.join('_');
      if (recepientStoreList == null) recepientStoreList = Map<String, dynamic>();
      if (recepientStoreList[statusStr] == null) recepientStoreList[statusStr] = [];
      if (recepientStoreMetaData == null) recepientStoreMetaData = Map<String, dynamic>();

      var result;
      result = await BusinessConnectionsApiProvider.recepientStores(
        requestedId: requestedId,
        status: status,
        searchKey: searchKey,
        page: recepientStoreMetaData.isEmpty ? 1 : (recepientStoreMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          recepientStoreList[statusStr].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        recepientStoreMetaData = result["data"];

        _businessInvitationsPageState = _businessInvitationsPageState.update(
          progressState: 3,
          recepientStoreList: recepientStoreList,
          recepientStoreMetaData: recepientStoreMetaData,
        );
      } else {
        _businessInvitationsPageState = _businessInvitationsPageState.update(
          progressState: 3,
        );
      }
    } catch (e) {
      _businessInvitationsPageState = _businessInvitationsPageState.update(
        progressState: 3,
      );
    }
    notifyListeners();
  }

  void update({@required BusinessConnectionModel? connectionModel, @required StoreModel? storeModel, @required String? statusStr}) {
    Map<String, dynamic> connectionData = connectionModel!.toJson();
    connectionData["requestedStore"] = storeModel!.toJson();

    for (var i = 0; i < _businessInvitationsPageState.requestedStoreList![statusStr].length; i++) {
      if (_businessInvitationsPageState.requestedStoreList![statusStr][i]["_id"] == connectionData["_id"]) {
        _businessInvitationsPageState.requestedStoreList![statusStr][i] = connectionData;
        break;
      }
    }

    _businessInvitationsPageState = _businessInvitationsPageState.update(
      requestedStoreList: _businessInvitationsPageState.requestedStoreList,
    );

    notifyListeners();
  }
}
