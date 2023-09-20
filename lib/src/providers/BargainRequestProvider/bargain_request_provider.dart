import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class BargainRequestProvider extends ChangeNotifier {
  static BargainRequestProvider of(BuildContext context, {bool listen = false}) => Provider.of<BargainRequestProvider>(context, listen: listen);

  BargainRequestState _bargainRequestState = BargainRequestState.init();
  BargainRequestState get bargainRequestState => _bargainRequestState;

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void setBargainRequestState(BargainRequestState bargainRequestState, {bool isNotifiable = true}) {
    if (_bargainRequestState != bargainRequestState) {
      _bargainRequestState = bargainRequestState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<bool> addBargainRequestData({@required BargainRequestModel? bargainRequestModel}) async {
    try {
      if (bargainRequestModel!.products!.isNotEmpty && bargainRequestModel.products![0].productModel!.imageFile != null) {
        var result = await UploadFileApiProvider.uploadFile(
          file: bargainRequestModel.products![0].productModel!.imageFile,
          directoryName: "StoreId-${bargainRequestModel.storeModel!.id}/",
          fileName: (bargainRequestModel.products![0].productModel!.name! +
              "-" +
              DateTime.now().millisecondsSinceEpoch.toString() +
              "." +
              bargainRequestModel.products![0].productModel!.imageFile!.path.split("/").last.split('.').last),
          bucketName: "BARGAIN_BUCKET_NAME",
        );

        if (result["success"]) {
          bargainRequestModel.products![0].productModel!.images = [result["data"]];
        }
      }

      if (bargainRequestModel.services!.isNotEmpty && bargainRequestModel.services![0].serviceModel!.imageFile != null) {
        var result = await UploadFileApiProvider.uploadFile(
          file: bargainRequestModel.services![0].serviceModel!.imageFile,
          directoryName: "StoreId-${bargainRequestModel.storeModel!.id}/",
          fileName: bargainRequestModel.services![0].serviceModel!.name! +
              "-" +
              DateTime.now().millisecondsSinceEpoch.toString() +
              bargainRequestModel.services![0].serviceModel!.imageFile!.path.toString().split("/").last.split('.').last,
          bucketName: "BARGAIN_BUCKET_NAME",
        );

        if (result["success"]) {
          bargainRequestModel.services![0].serviceModel!.images = [result["data"]];
        }
      }

      bargainRequestModel.bargainRequestId = "TMBR-" + randomAlphaNumeric(12);

      var result = await BargainRequestApiProvider.addBargainRequest(bargainRequestModel: bargainRequestModel);

      if (result["success"]) {
        _bargainRequestState = _bargainRequestState.update(
          progressState: 2,
          message: "",
        );
        notifyListeners();

        return true;
      } else {
        _bargainRequestState = _bargainRequestState.update(
          progressState: -1,
          message: result["message"],
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      _bargainRequestState = _bargainRequestState.update(
        progressState: -1,
        message: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  Future<void> getBargainRequestData({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic> bargainRequestListData = _bargainRequestState.bargainRequestListData!;
    Map<String, dynamic> bargainRequestMetaData = _bargainRequestState.bargainRequestMetaData!;
    try {
      if (bargainRequestListData[status] == null) bargainRequestListData[status!] = [];
      if (bargainRequestMetaData[status] == null) bargainRequestMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await BargainRequestApiProvider.getBargainRequestData(
        storeId: storeId,
        status: status,
        searchKey: searchKey,
        page: bargainRequestMetaData[status].isEmpty ? 1 : (bargainRequestMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          bargainRequestListData[status].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        bargainRequestMetaData[status!] = result["data"];

        _bargainRequestState = _bargainRequestState.update(
          progressState: 2,
          bargainRequestListData: bargainRequestListData,
          bargainRequestMetaData: bargainRequestMetaData,
        );
      } else {
        _bargainRequestState = _bargainRequestState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _bargainRequestState = _bargainRequestState.update(
        progressState: 2,
      );
    }
    Future.delayed(Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }

  Future<dynamic> updateBargainRequestData({
    @required BargainRequestModel? bargainRequestModel,
    @required String? status,
    @required String? subStatus,
    @required String? storeId,
  }) async {
    var result = await BargainRequestApiProvider.updateBargainRequestData(
      bargainRequestModel: bargainRequestModel,
      status: status,
      subStatus: subStatus,
      storeId: storeId,
    );
    if (result["success"]) {
      _bargainRequestState = _bargainRequestState.update(
        progressState: 1,
        bargainRequestListData: Map<String, dynamic>(),
        bargainRequestMetaData: Map<String, dynamic>(),
      );
      // getBargainRequestData(
      //   storeId: bargainRequestModel.storeId,
      //   status: status,
      // );
    }
    return result;
  }
}
