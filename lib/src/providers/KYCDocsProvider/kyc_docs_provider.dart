import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/pages/KYCDocsPage/Styles/index.dart';

import 'index.dart';

class KYCDocsProvider extends ChangeNotifier {
  static KYCDocsProvider of(BuildContext context, {bool listen = false}) => Provider.of<KYCDocsProvider>(context, listen: listen);

  KYCDocsState _kycDocsState = KYCDocsState.init();
  KYCDocsState get kycDocsState => _kycDocsState;

  void setKYCDocsState(KYCDocsState kycDocsState, {bool isNotifiable = true}) {
    if (_kycDocsState != kycDocsState) {
      _kycDocsState = kycDocsState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getKYCDocs({@required String? storeUserId, @required String? storeId}) async {
    try {
      var result = await KYCDocsApiProvider.getKYCDocs(storeUserId: storeUserId, storeId: storeId);

      if (result["success"]) {
        _kycDocsState = _kycDocsState.update(
          progressState: 2,
          kycDocsData: result["data"] ??
              {
                "storeUserId": storeUserId,
                "storeId": storeId,
                "documents": KYCDocsPageString.documentType,
              },
        );
      } else {
        _kycDocsState = _kycDocsState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _kycDocsState = _kycDocsState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<void> updateKYCDocs({
    @required String? storeUserId,
    @required String? storeId,
    @required Map<String, dynamic>? kycDocs,
  }) async {
    try {
      var result = await KYCDocsApiProvider.updateKYCDocs(
        storeUserId: storeUserId,
        storeId: storeId,
        kycDocs: kycDocs,
      );

      if (result["success"]) {
        _kycDocsState = _kycDocsState.update(
          progressState: 2,
          kycDocsData: result["data"],
        );
      } else {
        _kycDocsState = _kycDocsState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _kycDocsState = _kycDocsState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }
}
