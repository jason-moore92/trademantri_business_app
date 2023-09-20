import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class BusinessNetworkStatusProvider extends ChangeNotifier {
  static BusinessNetworkStatusProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<BusinessNetworkStatusProvider>(context, listen: listen);

  BusinessNetworkStatusState _businessInvitationsPageState = BusinessNetworkStatusState.init();
  BusinessNetworkStatusState get businessInvitationsPageState => _businessInvitationsPageState;

  void setBusinessNetworkStatusState(BusinessNetworkStatusState businessInvitationsPageState, {bool isNotifiable = true}) {
    if (_businessInvitationsPageState != businessInvitationsPageState) {
      _businessInvitationsPageState = businessInvitationsPageState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> networkStatus({@required String? storeId}) async {
    try {
      var result;
      result = await BusinessConnectionsApiProvider.networkStatus(storeId: storeId);

      if (result["success"]) {
        _businessInvitationsPageState = _businessInvitationsPageState.update(
          progressState: 2,
          networkStatus: result["data"],
        );
      } else {
        _businessInvitationsPageState = _businessInvitationsPageState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _businessInvitationsPageState = _businessInvitationsPageState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }
}
