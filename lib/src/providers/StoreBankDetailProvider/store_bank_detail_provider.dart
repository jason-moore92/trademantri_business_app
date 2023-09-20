import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class StoreBankDetailProvider extends ChangeNotifier {
  static StoreBankDetailProvider of(BuildContext context, {bool listen = false}) => Provider.of<StoreBankDetailProvider>(context, listen: listen);

  StoreBankDetailState _storeBankDetailState = StoreBankDetailState.init();
  StoreBankDetailState get storeBankDetailState => _storeBankDetailState;

  void setStoreBankDetailState(StoreBankDetailState storeBankDetailState, {bool isNotifiable = true}) {
    if (_storeBankDetailState != storeBankDetailState) {
      _storeBankDetailState = storeBankDetailState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> updateStoreBankDetail({
    @required Map<String, dynamic>? storeBankDetail,
    @required String? storeId,
    File? imageFile,
    bool isNotifiable = true,
  }) async {
    var result = await StoreBankDetailApiProvider.updateStoreBankDetail(storeBankDetail: storeBankDetail, imageFile: imageFile, storeId: storeId);

    if (result["success"]) {
      _storeBankDetailState = _storeBankDetailState.update(
        progressState: 2,
        message: "",
        storeBankDetail: result["data"],
      );
    } else {
      _storeBankDetailState = _storeBankDetailState.update(
        progressState: -1,
        message: result["message"],
      );
    }

    if (isNotifiable) notifyListeners();
  }

  Future<void> getStoreBankDetail({@required String? storeId, bool isNotifiable = true}) async {
    var result = await StoreBankDetailApiProvider.getStoreBankDetail(storeId: storeId);

    if (result["success"]) {
      _storeBankDetailState = _storeBankDetailState.update(
        progressState: 2,
        message: "",
        storeBankDetail: result["data"] ?? Map<String, dynamic>(),
      );
    } else {
      _storeBankDetailState = _storeBankDetailState.update(
        progressState: -1,
        message: result["message"],
      );
    }

    if (isNotifiable) notifyListeners();
  }
}
