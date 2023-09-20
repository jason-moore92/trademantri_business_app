// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:trapp/config/config.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:trapp/src/ApiDataProviders/index.dart';

// import 'index.dart';

// class FavoriteProvider extends ChangeNotifier {
//   static FavoriteProvider of(BuildContext context, {bool listen = false}) => Provider.of<FavoriteProvider>(context, listen: listen);

//   FavoriteState _favoriteState = FavoriteState.init();
//   FavoriteState get favoriteState => _favoriteState;

//   SharedPreferences? _prefs;
//   SharedPreferences? get prefs => _prefs;

//   void setFavoriteState(FavoriteState favoriteState, {bool isNotifiable = true}) {
//     if (_favoriteState != favoriteState) {
//       _favoriteState = favoriteState;
//       if (isNotifiable) notifyListeners();
//     }
//   }

//   Future<void> getFavorite({@required String? userId}) async {
//     if (_favoriteState.progressState != 2) {
//       if (_prefs == null) _prefs = await SharedPreferences.getInstance();
//       try {
//         if (_prefs!.getString("favorite_data_$userId") == null) {
//           bool localData = true;
//           Map<String, dynamic> favoriteData = Map<String, dynamic>();

//           var storeResult = await StoreFavoriteApiProvider.getStoreFavorite(userId: userId);
//           if (storeResult["success"]) {
//             favoriteData["stores"] = storeResult["data"];
//           } else {
//             localData = false;
//           }

//           var productResult = await ProductFavoriteApiProvider.getProductFavorite(userId: userId);
//           if (productResult["success"]) {
//             favoriteData["products"] = productResult["data"];
//           } else {
//             localData = false;
//           }

//           var serviceResult = await ServiceFavoriteApiProvider.getServiceFavorite(userId: userId);
//           if (serviceResult["success"]) {
//             favoriteData["services"] = serviceResult["data"];
//           } else {
//             localData = false;
//           }

//           _favoriteState = _favoriteState.update(
//             favoriteData: favoriteData,
//             progressState: 2,
//           );
//           if (localData == true && favoriteData.isNotEmpty) _prefs!.setString("favorite_data_$userId", json.encode(favoriteData));
//         } else {
//           _favoriteState = _favoriteState.update(
//             favoriteData: json.decode(_prefs!.getString("favorite_data_$userId")!),
//             progressState: 2,
//           );
//         }
//       } catch (e) {
//         _favoriteState = _favoriteState.update(
//           progressState: 2,
//         );
//       }
//     }
//   }

//   Future<void> getFavoriteData({@required String? userId, @required String? category, String searchKey = ""}) async {
//     Map<String, dynamic>? favoriteObjectListData = _favoriteState.favoriteObjectListData;
//     Map<String, dynamic>? favoriteObjectMetaData = _favoriteState.favoriteObjectMetaData;
//     try {
//       if (favoriteObjectListData![category] == null) favoriteObjectListData[category!] = [];
//       if (favoriteObjectMetaData![category] == null) favoriteObjectMetaData[category!] = Map<String, dynamic>();

//       var result;

//       switch (category) {
//         case "stores":
//           result = await StoreFavoriteApiProvider.getStoreFavoriteData(
//             userId: userId,
//             searchKey: searchKey,
//             page: favoriteObjectMetaData[category].isEmpty ? 1 : (favoriteObjectMetaData[category]["nextPage"] ?? 1),
//             limit: AppConfig.countLimitForList,
//           );
//           break;
//         case "products":
//           result = await ProductFavoriteApiProvider.getProductFavoriteData(
//             userId: userId,
//             searchKey: searchKey,
//             page: favoriteObjectMetaData[category].isEmpty ? 1 : (favoriteObjectMetaData[category]["nextPage"] ?? 1),
//             limit: AppConfig.countLimitForList,
//           );
//           break;
//         case "services":
//           result = await ServiceFavoriteApiProvider.getServiceFavoriteData(
//             userId: userId,
//             searchKey: searchKey,
//             page: favoriteObjectMetaData[category].isEmpty ? 1 : (favoriteObjectMetaData[category]["nextPage"] ?? 1),
//             limit: AppConfig.countLimitForList,
//           );
//           break;
//         // default:
//         //   result = await FavoriteApiProvider.getFavoriteData(
//         //     userId: userId,
//         //     category: category,
//         //     searchKey: searchKey,
//         //     page: favoriteObjectMetaData[category].isEmpty ? 1 : (favoriteObjectMetaData[category]["nextPage"] ?? 1),
//         //     limit: AppConfig.countLimitForList,
//         //   );
//       }

//       if (result["success"]) {
//         for (var i = 0; i < result["data"]["docs"].length; i++) {
//           favoriteObjectListData[category].add({
//             "data": result["data"]["docs"][i]["data"][0],
//             "store": result["data"]["docs"][i]["store"] == null ? null : result["data"]["docs"][i]["store"][0],
//           });
//         }
//         result["data"].remove("docs");
//         favoriteObjectMetaData[category!] = result["data"];

//         _favoriteState = _favoriteState.update(
//           progressState: 2,
//           favoriteObjectListData: favoriteObjectListData,
//           favoriteObjectMetaData: favoriteObjectMetaData,
//         );
//       } else {
//         _favoriteState = _favoriteState.update(
//           progressState: 2,
//         );
//       }
//     } catch (e) {
//       _favoriteState = _favoriteState.update(
//         progressState: 2,
//       );
//     }
//     Future.delayed(Duration(milliseconds: 300), () {
//       notifyListeners();
//     });
//   }

//   Future<void> setFavoriteData({
//     @required String? userId,
//     @required String? id,
//     @required String? storeId,
//     @required String? category,
//     @required bool? isFavorite,
//   }) async {
//     try {
//       if (_prefs == null) _prefs = await SharedPreferences.getInstance();
//       var result;

//       Map<String, dynamic>? favoriteData = _favoriteState.favoriteData;

//       if (favoriteData![category] == null) favoriteData[category!] = [];

//       switch (category) {
//         case "stores":
//           result = await StoreFavoriteApiProvider.setStoreFavorite(userId: userId, id: id, isFavorite: isFavorite);
//           break;
//         case "products":
//           result = await ProductFavoriteApiProvider.setProductFavorite(userId: userId, id: id, storeId: storeId, isFavorite: isFavorite);
//           break;
//         case "services":
//           result = await ServiceFavoriteApiProvider.setServiceFavorite(userId: userId, id: id, storeId: storeId, isFavorite: isFavorite);
//           break;
//         // default:
//         //   result = await FavoriteApiProvider.setFavorite(userId: userId, id: id, category: category, isFavorite: isFavorite);
//       }

//       if (result["success"] && result["data"] != null) {
//         if (isFavorite!) {
//           favoriteData[category].add(result["data"]);
//         } else {
//           favoriteData[category].removeWhere((element) => (result["data"]["_id"] == element["_id"]));
//         }
//         _favoriteState = _favoriteState.update(
//           favoriteData: favoriteData,
//           progressState: 2,
//         );
//         _prefs!.setString("favorite_data_$userId", json.encode(favoriteData));
//       } else {
//         _favoriteState = _favoriteState.update(
//           progressState: 2,
//         );
//       }
//     } catch (e) {
//       _favoriteState = _favoriteState.update(
//         progressState: 2,
//       );
//     }
//   }
// }
