import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class RewardPointsForStoreProvider extends ChangeNotifier {
  static RewardPointsForStoreProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<RewardPointsForStoreProvider>(context, listen: listen);

  RewardPointsForStoreState _rewardPointsForCustomerState = RewardPointsForStoreState.init();
  RewardPointsForStoreState get rewardPointsForCustomerState => _rewardPointsForCustomerState;

  void setRewardPointsForStoreState(RewardPointsForStoreState rewardPointsForCustomerState, {bool isNotifiable = true}) {
    if (_rewardPointsForCustomerState != rewardPointsForCustomerState) {
      _rewardPointsForCustomerState = rewardPointsForCustomerState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> sumRewardPointsForStore({@required String? receiveStoreId, @required String? storeId}) async {
    try {
      var result = await RewardPointHistoryApiProvider.sumRewardPointsForStore(
        receiveStoreId: receiveStoreId,
        storeId: storeId,
      );

      if (result["success"]) {
        _rewardPointsForCustomerState = _rewardPointsForCustomerState.update(
          progressState: 2,
          message: "",
          sumRewardPoint: result["data"][0]["sum"],
        );
      } else {
        _rewardPointsForCustomerState = _rewardPointsForCustomerState.update(
          progressState: -1,
          message: result["messsage"],
        );
      }
    } catch (e) {
      _rewardPointsForCustomerState = _rewardPointsForCustomerState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
  }

  Future<void> getRewardPointsForStore({
    @required String? receiveStoreId,
    @required String? storeId,
    String searchKey = "",
  }) async {
    List<dynamic>? rewardPointListData = _rewardPointsForCustomerState.rewardPointListData;
    Map<String, dynamic>? rewardPointMetaData = _rewardPointsForCustomerState.rewardPointMetaData;

    if (rewardPointListData == null) rewardPointListData = [];
    if (rewardPointMetaData == null) rewardPointMetaData = Map<String, dynamic>();

    try {
      var result = await RewardPointHistoryApiProvider.getRewardPointsForStore(
        receiveStoreId: receiveStoreId,
        storeId: storeId,
        searchKey: searchKey,
        page: rewardPointMetaData.isEmpty ? 1 : (rewardPointMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        rewardPointListData.addAll(result["data"]["docs"]);
        result["data"].remove("docs");
        rewardPointMetaData = result["data"];

        _rewardPointsForCustomerState = _rewardPointsForCustomerState.update(
          progressState: 2,
          message: "",
          rewardPointListData: rewardPointListData,
          rewardPointMetaData: rewardPointMetaData,
        );
      } else {
        _rewardPointsForCustomerState = _rewardPointsForCustomerState.update(
          progressState: 2,
          message: result["messsage"],
        );
      }
    } catch (e) {
      _rewardPointsForCustomerState = _rewardPointsForCustomerState.update(
        progressState: 2,
        message: e.toString(),
      );
    }

    notifyListeners();
  }
}
