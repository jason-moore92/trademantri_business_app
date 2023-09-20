import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ReferralRewardS2SOffersProvider extends ChangeNotifier {
  static ReferralRewardS2SOffersProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<ReferralRewardS2SOffersProvider>(context, listen: listen);

  ReferralRewardS2SOffersState _referralRewardU2SOffersState = ReferralRewardS2SOffersState.init();
  ReferralRewardS2SOffersState get referralRewardS2SOffersState => _referralRewardU2SOffersState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setReferralRewardU2SOffersState(ReferralRewardS2SOffersState referralRewardS2SOffersState, {bool isNotifiable = true}) {
    if (_referralRewardU2SOffersState != referralRewardS2SOffersState) {
      _referralRewardU2SOffersState = referralRewardS2SOffersState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getReferralRewardU2SOffersData({@required String? referredByStoreId, String searchKey = ""}) async {
    Map<String, dynamic> referralRewardOffersListData = _referralRewardU2SOffersState.referralRewardOffersListData!;
    Map<String, dynamic> referralRewardOffersMetaData = _referralRewardU2SOffersState.referralRewardOffersMetaData!;
    try {
      if (referralRewardOffersListData["ALL"] == null) referralRewardOffersListData["ALL"] = [];
      if (referralRewardOffersMetaData["ALL"] == null) referralRewardOffersMetaData["ALL"] = Map<String, dynamic>();

      var result;

      result = await ReferralRewardS2SOffersApiProvider.getReferralRewardOffersData(
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

        _referralRewardU2SOffersState = _referralRewardU2SOffersState.update(
          progressState: 2,
          referralRewardOffersListData: referralRewardOffersListData,
          referralRewardOffersMetaData: referralRewardOffersMetaData,
        );
      } else {
        _referralRewardU2SOffersState = _referralRewardU2SOffersState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _referralRewardU2SOffersState = _referralRewardU2SOffersState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
