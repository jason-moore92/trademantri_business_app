import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class NewCustomerForChatPageProvider extends ChangeNotifier {
  static NewCustomerForChatPageProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<NewCustomerForChatPageProvider>(context, listen: listen);

  NewCustomerForChatPageState _newCustomerForChatPageState = NewCustomerForChatPageState.init();
  NewCustomerForChatPageState get newCustomerForChatPageState => _newCustomerForChatPageState;

  void setNewCustomerForChatPageState(NewCustomerForChatPageState newCustomerForChatPageState, {bool isNotifiable = true}) {
    if (_newCustomerForChatPageState != newCustomerForChatPageState) {
      _newCustomerForChatPageState = newCustomerForChatPageState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getNewCustomerForChatPageData({@required String? storeId, String searchKey = ""}) async {
    List<dynamic>? customerListData = _newCustomerForChatPageState.customerListData;
    Map<String, dynamic>? customerListMetaData = _newCustomerForChatPageState.customerListMetaData;
    try {
      if (customerListData == null) customerListData = [];
      if (customerListMetaData == null) customerListMetaData = Map<String, dynamic>();

      var result;

      result = await OrderApiProvider.getUserListForChat(
        storeId: storeId,
        searchKey: searchKey,
        page: customerListMetaData.isEmpty ? 1 : (customerListMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          customerListData.add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        customerListMetaData = result["data"];

        _newCustomerForChatPageState = _newCustomerForChatPageState.update(
          progressState: 2,
          customerListData: customerListData,
          customerListMetaData: customerListMetaData,
        );
      } else {
        _newCustomerForChatPageState = _newCustomerForChatPageState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _newCustomerForChatPageState = _newCustomerForChatPageState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }
}
