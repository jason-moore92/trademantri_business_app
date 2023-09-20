import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class RewardPointsListProvider extends ChangeNotifier {
  static RewardPointsListProvider of(BuildContext context, {bool listen = false}) => Provider.of<RewardPointsListProvider>(context, listen: listen);

  RewardPointsListState _rewardPointsListState = RewardPointsListState.init();
  RewardPointsListState get rewardPointsListState => _rewardPointsListState;

  void setRewardPointsListState(RewardPointsListState rewardPointsListState, {bool isNotifiable = true}) {
    if (_rewardPointsListState != rewardPointsListState) {
      _rewardPointsListState = rewardPointsListState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getRewardPointById({@required String? storeId}) async {
    try {
      var result = await RewardPointApiProvider.getRewardPointsListById(storeId: storeId);

      if (result["success"]) {
        _rewardPointsListState = _rewardPointsListState.update(
          progressState: 2,
          rewardPointsList: result["data"],
          message: "",
        );
      } else {
        _rewardPointsListState = _rewardPointsListState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _rewardPointsListState = _rewardPointsListState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }
}
