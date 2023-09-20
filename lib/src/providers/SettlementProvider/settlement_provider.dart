import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class SettlementProvider extends ChangeNotifier {
  static SettlementProvider of(BuildContext context, {bool listen = false}) => Provider.of<SettlementProvider>(context, listen: listen);

  SettlementState _settlementState = SettlementState.init();
  SettlementState get settlementState => _settlementState;

  void setSettlementState(SettlementState settlementState, {bool isNotifiable = true}) {
    if (_settlementState != settlementState) {
      _settlementState = settlementState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getSettlements({
    @required String? storeId,
  }) async {
    List<Settlement>? settlementsListData = _settlementState.settlementsListData;
    Map<String, dynamic>? settlementsMetaData = _settlementState.settlementsMetaData;
    try {
      if (settlementsListData == null) settlementsListData = [];
      if (settlementsMetaData == null) settlementsMetaData = Map<String, dynamic>();

      var result;

      result = await SettlementApiProvider.getSettlements(
        storeId: storeId,
        page: (settlementsMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          settlementsListData.add(Settlement.fromJson(result["data"]["docs"][i]));
        }
        result["data"].remove("docs");
        settlementsMetaData = result["data"];

        _settlementState = _settlementState.update(
          progressState: 2,
          settlementsListData: settlementsListData,
          settlementsMetaData: settlementsMetaData,
        );
      } else {
        _settlementState = _settlementState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _settlementState = _settlementState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
