import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class StoreJobPostingsProvider extends ChangeNotifier {
  static StoreJobPostingsProvider of(BuildContext context, {bool listen = false}) => Provider.of<StoreJobPostingsProvider>(context, listen: listen);

  StoreJobPostingsState _storeJobPostingsState = StoreJobPostingsState.init();
  StoreJobPostingsState get storeJobPostingsState => _storeJobPostingsState;

  void setStoreJobPostingsState(StoreJobPostingsState storeJobPostingsState, {bool isNotifiable = true}) {
    if (_storeJobPostingsState != storeJobPostingsState) {
      _storeJobPostingsState = storeJobPostingsState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getStoreJobPostingsData({
    @required String? storeId,
    String status = "ALL",
    String searchKey = "",
  }) async {
    List<dynamic>? storeJobPostingsListData = _storeJobPostingsState.storeJobPostingsListData;
    Map<String, dynamic>? storeJobPostingsMetaData = _storeJobPostingsState.storeJobPostingsMetaData;
    try {
      if (storeJobPostingsListData == null) storeJobPostingsListData = [];
      if (storeJobPostingsMetaData == null) storeJobPostingsMetaData = Map<String, dynamic>();

      var result;

      result = await StoreJobPostingsApiProvider.getStoreJobPostingsData(
        storeId: storeId,
        status: status,
        searchKey: searchKey,
        page: storeJobPostingsMetaData.isEmpty ? 1 : (storeJobPostingsMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          storeJobPostingsListData.add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        storeJobPostingsMetaData = result["data"];

        _storeJobPostingsState = _storeJobPostingsState.update(
          progressState: 2,
          storeJobPostingsListData: storeJobPostingsListData,
          storeJobPostingsMetaData: storeJobPostingsMetaData,
        );
      } else {
        _storeJobPostingsState = _storeJobPostingsState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _storeJobPostingsState = _storeJobPostingsState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<dynamic> addJobPosting({@required Map<String, dynamic>? jobPostData}) async {
    try {
      return await StoreJobPostingsApiProvider.addJobPosting(jobPostData: jobPostData);
    } catch (e) {
      return {"success": false};
    }
  }

  Future<dynamic> updateJobPosting({@required Map<String, dynamic>? jobPostData}) async {
    try {
      return await StoreJobPostingsApiProvider.updateJobPosting(jobPostData: jobPostData);
    } catch (e) {
      return {"success": false};
    }
  }
}
