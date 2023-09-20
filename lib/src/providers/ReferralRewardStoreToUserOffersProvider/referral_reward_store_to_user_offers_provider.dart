import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ReferralRewardS2UOffersProvider extends ChangeNotifier {
  static ReferralRewardS2UOffersProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<ReferralRewardS2UOffersProvider>(context, listen: listen);

  ReferralRewardS2UOffersState _referralRewardU2UOffersState = ReferralRewardS2UOffersState.init();
  ReferralRewardS2UOffersState get referralRewardU2UOffersState => _referralRewardU2UOffersState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setReferralRewardS2UOffersState(ReferralRewardS2UOffersState referralRewardU2UOffersState, {bool isNotifiable = true}) {
    if (_referralRewardU2UOffersState != referralRewardU2UOffersState) {
      _referralRewardU2UOffersState = referralRewardU2UOffersState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getReferralRewardS2UOffersData({@required String? referredByStoreId, String searchKey = ""}) async {
    Map<String, dynamic> referralRewardOffersListData = _referralRewardU2UOffersState.referralRewardOffersListData!;
    Map<String, dynamic> referralRewardOffersMetaData = _referralRewardU2UOffersState.referralRewardOffersMetaData!;
    try {
      if (referralRewardOffersListData["ALL"] == null) referralRewardOffersListData["ALL"] = [];
      if (referralRewardOffersMetaData["ALL"] == null) referralRewardOffersMetaData["ALL"] = Map<String, dynamic>();

      var result;

      result = await ReferralRewardS2UOffersApiProvider.getReferralRewardOffersData(
        referredByStoreId: referredByStoreId,
        searchKey: searchKey,
        page: referralRewardOffersMetaData["ALL"].isEmpty ? 1 : (referralRewardOffersMetaData["ALL"]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          referralRewardOffersListData["ALL"].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        referralRewardOffersMetaData["ALL"] = result["data"];

        _referralRewardU2UOffersState = _referralRewardU2UOffersState.update(
          progressState: 2,
          referralRewardOffersListData: referralRewardOffersListData,
          referralRewardOffersMetaData: referralRewardOffersMetaData,
        );
      } else {
        _referralRewardU2UOffersState = _referralRewardU2UOffersState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _referralRewardU2UOffersState = _referralRewardU2UOffersState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
