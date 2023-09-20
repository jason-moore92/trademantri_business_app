import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class WalletProvider extends ChangeNotifier {
  static WalletProvider of(BuildContext context, {bool listen = false}) => Provider.of<WalletProvider>(context, listen: listen);

  WalletState _walletState = WalletState.init();
  WalletState get walletState => _walletState;

  void setWalletState(WalletState walletState, {bool isNotifiable = true}) {
    if (_walletState != walletState) {
      _walletState = walletState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getTransactions({
    @required String? storeId,
    String? accountId,
    String status = "settled",
    String? narration,
  }) async {
    Map<String, List<WalletTransaction>>? transactionsListData = _walletState.transactionsListData;
    Map<String, dynamic>? transactionsMetaData = _walletState.transactionsMetaData;
    try {
      if (transactionsListData![status] == null) transactionsListData[status] = [];
      if (transactionsMetaData![status] == null) transactionsMetaData[status] = Map<String, dynamic>();

      var result;

      result = await WalletApiProvider.getTransactions(
        storeId: storeId,
        accountId: accountId,
        page: transactionsMetaData[status].isEmpty ? 1 : (transactionsMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        settled: status == "settled",
        narration: narration,
        // reqReferenceId: searchKey,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          WalletTransaction txn = WalletTransaction.fromJson(result["data"]["docs"][i]);
          transactionsListData[status]!.add(txn);
        }
        result["data"].remove("docs");
        transactionsMetaData[status] = result["data"];

        _walletState = _walletState.update(
          progressState: 2,
          transactionsListData: transactionsListData,
          transactionsMetaData: transactionsMetaData,
        );
      } else {
        _walletState = _walletState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _walletState = _walletState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<void> getAccount({
    @required String? storeId,
    String? accountId,
  }) async {
    // try {
    var result = await WalletApiProvider.getAccount(
      storeId: storeId,
      accountId: accountId,
    );
    if (result["success"]) {
      _walletState = _walletState.update(
        accountData: WalletAccount.fromJson(result["data"]),
      );
    } else {}
    // } catch (e) {}
    notifyListeners();
  }

  Future<void> withdraw({
    @required String? storeId,
    double? amount,
    String? notes,
  }) async {
    try {
      var result = await WalletApiProvider.withdrawal(
        storeId: storeId,
        amount: amount,
        notes: notes,
      );
      if (result["success"]) {
        _walletState = _walletState.update(
          accountData: result["data"][0],
        );
      } else {}
    } catch (e) {}
  }
}
