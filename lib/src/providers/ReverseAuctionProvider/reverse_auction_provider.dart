import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ReverseAuctionProvider extends ChangeNotifier {
  static ReverseAuctionProvider of(BuildContext context, {bool listen = false}) => Provider.of<ReverseAuctionProvider>(context, listen: listen);

  ReverseAuctionState _reverseAuctionState = ReverseAuctionState.init();
  ReverseAuctionState get reverseAuctionState => _reverseAuctionState;

  void setReverseAuctionState(ReverseAuctionState reverseAuctionState, {bool isNotifiable = true}) {
    if (_reverseAuctionState != reverseAuctionState) {
      _reverseAuctionState = reverseAuctionState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<bool> addReverseAuctionData({@required Map<String, dynamic>? reverseAuctionData}) async {
    try {
      if (reverseAuctionData!["products"].isNotEmpty && reverseAuctionData["products"][0]["data"]["imageFile"] != null) {
        var result = await UploadFileApiProvider.uploadFile(
          file: reverseAuctionData["products"][0]["data"]["imageFile"],
          directoryName: "UserId-${reverseAuctionData["userId"]}/StoreId-${reverseAuctionData["userId"]}/",
          fileName: (reverseAuctionData["products"][0]["data"]["name"] +
              "-" +
              DateTime.now().millisecondsSinceEpoch.toString() +
              "." +
              reverseAuctionData["products"][0]["data"]["imageFile"].toString().split("/").last.split('.').last),
          bucketName: "REVERSE_AUCTION_BUCKET_NAME",
        );

        if (result["success"]) {
          reverseAuctionData["products"][0]["data"]["images"] = [result["data"]];
          reverseAuctionData["products"][0]["data"].remove("imageFile");
        } else {
          reverseAuctionData["products"][0]["data"].remove("imageFile");
        }
      }

      if (reverseAuctionData["services"].isNotEmpty && reverseAuctionData["services"][0]["data"]["imageFile"] != null) {
        var result = await UploadFileApiProvider.uploadFile(
          file: reverseAuctionData["services"][0]["data"]["imageFile"],
          directoryName: "UserId-${reverseAuctionData["userId"]}/StoreId-${reverseAuctionData["userId"]}/",
          fileName: reverseAuctionData["services"][0]["data"]["name"] +
              "-" +
              DateTime.now().millisecondsSinceEpoch.toString() +
              reverseAuctionData["services"][0]["data"]["imageFile"].toString().split("/").last.split('.').last,
          bucketName: "REVERSE_AUCTION_BUCKET_NAME",
        );

        if (result["success"]) {
          reverseAuctionData["services"][0]["data"]["images"] = [result["data"]];
          reverseAuctionData["services"][0]["data"].remove("imageFile");
        } else {
          reverseAuctionData["services"][0]["data"].remove("imageFile");
        }
      }

      reverseAuctionData["reverseAuctionId"] = "TMRA-" + randomAlphaNumeric(12);

      var result = await ReverseAuctionApiProvider.addReverseAuction(reverseAuctionData: reverseAuctionData);

      if (result["success"]) {
        _reverseAuctionState = _reverseAuctionState.update(
          progressState: 2,
          message: "",
          // reverseAuctionData: reverseAuctionData,
        );
        notifyListeners();

        return true;
      } else {
        _reverseAuctionState = _reverseAuctionState.update(
          progressState: -1,
          message: result["message"],
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      _reverseAuctionState = _reverseAuctionState.update(
        progressState: -1,
        message: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  Future<void> getReverseAuctionDataByStore({@required String? storeId, @required String? status, String searchKey = ""}) async {
    Map<String, dynamic>? reverseAuctionListData = _reverseAuctionState.reverseAuctionListData;
    Map<String, dynamic>? reverseAuctionMetaData = _reverseAuctionState.reverseAuctionMetaData;
    try {
      if (reverseAuctionListData![status] == null) reverseAuctionListData[status!] = [];
      if (reverseAuctionMetaData![status] == null) reverseAuctionMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await ReverseAuctionApiProvider.getReverseAuctionDataByStore(
        storeId: storeId,
        status: status,
        searchKey: searchKey,
        page: reverseAuctionMetaData[status].isEmpty ? 1 : (reverseAuctionMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          reverseAuctionListData[status].add(result["data"]["docs"][i]["reverse_auction"]);
          reverseAuctionListData[status][i]["user"] = result["data"]["docs"][i]["user"];
          reverseAuctionListData[status][i]["storeId"] = result["data"]["docs"][i]["storeId"];
        }
        result["data"].remove("docs");
        reverseAuctionMetaData[status!] = result["data"];

        _reverseAuctionState = _reverseAuctionState.update(
          progressState: 2,
          reverseAuctionListData: reverseAuctionListData,
          reverseAuctionMetaData: reverseAuctionMetaData,
        );
      } else {
        _reverseAuctionState = _reverseAuctionState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _reverseAuctionState = _reverseAuctionState.update(
        progressState: 2,
      );
    }
    Future.delayed(Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }

  Future<dynamic> updateReverseAuctionData({
    @required Map<String, dynamic>? reverseAuctionData,
    @required Map<String, dynamic>? storeOfferData,
    @required String? status,
    @required String? storeId,
  }) async {
    var result = await ReverseAuctionApiProvider.updateReverseAuctionData(
        reverseAuctionData: reverseAuctionData, storeOfferData: storeOfferData, status: status, storeId: storeId);
    if (result["success"]) {
      _reverseAuctionState = _reverseAuctionState.update(
        progressState: 1,
        reverseAuctionListData: Map<String, dynamic>(),
        reverseAuctionMetaData: Map<String, dynamic>(),
      );
      // getReverseAuctionDataByStore(
      //   storeId: reverseAuctionData["userId"],
      //   status: status,
      // );
    }
    return result;
  }
}
