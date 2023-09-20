import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import 'package:trapp/environment.dart';

import 'index.dart';

class StoreProvider extends ChangeNotifier {
  static StoreProvider of(BuildContext context, {bool listen = false}) => Provider.of<StoreProvider>(context, listen: listen);

  StoreState _storeState = StoreState.init();
  StoreState get storeState => _storeState;

  void setStoreState(StoreState storeState, {bool isNotifiable = true}) {
    if (_storeState != storeState) {
      _storeState = storeState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> registerStore({
    @required Map<String, dynamic>? storeData,
    bool isNotifiable = true,
  }) async {
    try {
      var result = await StoreApiProvider.registerStore(storeData: storeData);

      if (result["success"]) {
        storeData = result["data"];
        if (Environment.enableFBEvents!) {
          getFBAppEvents().logCompletedRegistration(
            registrationMethod: "email_password",
          );
        }

        _storeState = _storeState.update(
          progressState: 2,
          message: "",
          storeData: result["data"],
        );
      } else {
        _storeState = _storeState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _storeState = _storeState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    if (isNotifiable) notifyListeners();
  }

  Future<void> updateStore({
    @required String? id,
    @required Map<String, dynamic>? storeData,
    File? imageFile,
    bool isNotifiable = true,
  }) async {
    var result = await StoreApiProvider.updateStoreData(id: id, storeData: storeData, imageFile: imageFile);

    if (result["success"]) {
      _storeState = _storeState.update(
        progressState: 2,
        message: "",
        storeData: result["data"],
      );
    } else {
      _storeState = _storeState.update(
        progressState: -1,
        message: result["message"],
      );
    }

    if (isNotifiable) notifyListeners();
  }
}
