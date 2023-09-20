import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class WithdrawProvider extends ChangeNotifier {
  static WithdrawProvider of(BuildContext context, {bool listen = false}) => Provider.of<WithdrawProvider>(context, listen: listen);

  WithdrawState _withdrawState = WithdrawState.init();
  WithdrawState get withdrawState => _withdrawState;

  void setWithdrawState(WithdrawState withdrawState, {bool isNotifiable = true}) {
    if (_withdrawState != withdrawState) {
      _withdrawState = withdrawState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> withdraw({
    @required String? storeId,
    double? amount,
    String? notes,
  }) async {
    // try {
    var result = await WalletApiProvider.withdrawal(
      storeId: storeId,
      amount: amount,
      notes: notes,
    );
    if (result["success"]) {
      _withdrawState = _withdrawState.update(
        settlementData: result["data"][0],
      );
    } else {}
    // } catch (e) {}
  }
}
