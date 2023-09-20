import 'package:flutter/material.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class StoreDataProvider extends ChangeNotifier {
  static StoreDataProvider of(BuildContext context, {bool listen = false}) => Provider.of<StoreDataProvider>(context, listen: listen);

  StoreDataState _storeDataState = StoreDataState.init();
  StoreDataState get storeDataState => _storeDataState;

  void setStoreDataState(StoreDataState storeDataState, {bool isNotifiable = true}) {
    if (_storeDataState != storeDataState) {
      _storeDataState = storeDataState;
      if (isNotifiable) notifyListeners();
    }
  }

  void init({@required List<String>? storeIds, @required String? storeSubType}) async {
    try {
      /// product categories
      var result = await ProductListApiProvider.getProductCategories(
        storeIds: storeIds,
        storeSubType: storeSubType,
      );
      if (result["success"]) {
        List<dynamic> productCategoryList = [];
        double totalCount = 0;
        for (var i = 0; i < result["data"].length; i++) {
          totalCount += result["data"][i]["productCount"];
          productCategoryList.add(result["data"][i]["_id"]);
        }

        _storeDataState = _storeDataState.update(
          progressState: 2,
          message: "",
          productCategoryList: productCategoryList,
        );
      } else if (!result["success"]) {
        _storeDataState = _storeDataState.update(
          progressState: -1,
          message: "Something was wrong",
        );
        notifyListeners();
        return;
      }

      /// product catalog category
      result = await CatalogApiProvider.getProductCatalogCategories();
      if (result["success"] && result["data"].isNotEmpty) {
        List<dynamic> productCatalogCategoryList = [];
        for (var i = 0; i < result["data"].length; i++) {
          productCatalogCategoryList.add(result["data"][i]["_id"]);
        }

        _storeDataState = _storeDataState.update(
          progressState: 2,
          message: "",
          productCatalogCategoryList: productCatalogCategoryList,
        );
      } else if (!result["success"]) {
        _storeDataState = _storeDataState.update(
          progressState: -1,
          message: "Something was wrong",
        );
        notifyListeners();
        return;
      }

      /// product catalog sub category
      result = await CatalogApiProvider.getProductCatalogSubCategories();
      if (result["success"] && result["data"].isNotEmpty) {
        List<dynamic> productCatalogSubCategoryList = [];
        for (var i = 0; i < result["data"].length; i++) {
          productCatalogSubCategoryList.add(result["data"][i]["_id"]);
        }

        _storeDataState = _storeDataState.update(
          progressState: 2,
          message: "",
          productCatalogSubCategoryList: productCatalogSubCategoryList,
        );
      } else if (!result["success"]) {
        _storeDataState = _storeDataState.update(
          progressState: -1,
          message: "Something was wrong",
        );
        notifyListeners();
        return;
      }

      /// service catalog category
      result = await CatalogApiProvider.getServiceCatalogCategories();
      if (result["success"] && result["data"].isNotEmpty) {
        List<dynamic> serviceCatalogCategoryList = [];
        for (var i = 0; i < result["data"].length; i++) {
          serviceCatalogCategoryList.add(result["data"][i]["_id"]);
        }

        _storeDataState = _storeDataState.update(
          progressState: 2,
          message: "",
          serviceCatalogCategoryList: serviceCatalogCategoryList,
        );
      } else if (!result["success"]) {
        _storeDataState = _storeDataState.update(
          progressState: -1,
          message: "Something was wrong",
        );
        notifyListeners();
        return;
      }

      /// service catalog sub category
      result = await CatalogApiProvider.getServiceCatalogSubCategories();
      if (result["success"] && result["data"].isNotEmpty) {
        List<dynamic> serviceCatalogSubCategoryList = [];
        for (var i = 0; i < result["data"].length; i++) {
          serviceCatalogSubCategoryList.add(result["data"][i]["_id"]);
        }

        _storeDataState = _storeDataState.update(
          progressState: 2,
          message: "",
          serviceCatalogSubCategoryList: serviceCatalogSubCategoryList,
        );
      } else if (!result["success"]) {
        _storeDataState = _storeDataState.update(
          progressState: -1,
          message: "Something was wrong",
        );
        notifyListeners();
        return;
      }

      result = await ProductListApiProvider.getProductBrands(
        storeIds: storeIds,
        storeSubType: storeSubType,
      );

      if (result["success"] && result["data"].isNotEmpty) {
        List<dynamic> productBrandList = [];
        double totalCount = 0;
        for (var i = 0; i < result["data"].length; i++) {
          totalCount += result["data"][i]["productCount"];
          productBrandList.add(result["data"][i]["_id"]);
        }

        _storeDataState = _storeDataState.update(
          progressState: 2,
          message: "",
          productBrandList: productBrandList,
        );
      } else if (!result["success"]) {
        _storeDataState = _storeDataState.update(
          progressState: -1,
          message: "Something was wrong",
        );
        notifyListeners();
        return;
      }

      result = await ServiceListApiProvider.getServiceCategories(
        storeIds: storeIds,
        storeSubType: storeSubType,
      );

      if (result["success"] && result["data"].isNotEmpty) {
        List<dynamic> serviceCategoryList = [];
        double totalCount = 0;
        for (var i = 0; i < result["data"].length; i++) {
          totalCount += result["data"][i]["serviceCount"];
          serviceCategoryList.add(result["data"][i]["_id"]);
        }

        _storeDataState = _storeDataState.update(
          progressState: 2,
          message: "",
          serviceCategoryList: serviceCategoryList,
        );
      } else if (!result["success"]) {
        _storeDataState = _storeDataState.update(
          progressState: -1,
          message: "Something was wrong",
        );
        notifyListeners();
        return;
      }

      result = await ServiceListApiProvider.getServiceProvided(storeIds: storeIds);

      if (result["success"]) {
        List<dynamic> serviceProvidedList = [];
        double totalCount = 0;
        for (var i = 0; i < result["data"].length; i++) {
          totalCount += result["data"][i]["serviceCount"];
          serviceProvidedList.add(result["data"][i]["_id"]);
        }

        for (var i = 0; i < AppConfig.serviceProvidedList.length; i++) {
          if (!serviceProvidedList.contains(AppConfig.serviceProvidedList[i])) {
            serviceProvidedList.add(AppConfig.serviceProvidedList[i]);
          }
        }

        _storeDataState = _storeDataState.update(
          progressState: 2,
          message: "",
          serviceProvidedList: serviceProvidedList,
        );
      } else {
        _storeDataState = _storeDataState.update(
          progressState: -1,
          message: "Something was wrong",
        );
        notifyListeners();
        return;
      }
    } catch (e) {
      _storeDataState = _storeDataState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }

  // Future<void> getProductCategories({@required List<String> storeIds, bool isNotifiable = true}) async {
  //   try {
  //     var result = await ProductListApiProvider.getProductCategories(storeIds: storeIds);

  //     if (result["success"] && result["data"].isNotEmpty) {
  //       List<dynamic> productCategoryList = [];
  //       double totalCount = 0;
  //       for (var i = 0; i < result["data"].length; i++) {
  //         totalCount += result["data"][i]["productCount"];
  //         productCategoryList.add(result["data"][i]["_id"]);
  //       }

  //       _storeDataState = _storeDataState.update(
  //         progressState: 2,
  //         message: "",
  //         productCategoryList: productCategoryList,
  //       );
  //     }
  //     else if (result["success"] && result["data"].isEmpty) {
  //       _storeDataState = _storeDataState.update(
  //         progressState: 3,
  //         message: "No Data",
  //       );
  //     } else {
  //       _storeDataState = _storeDataState.update(
  //         progressState: 3,
  //         message: result["messsage"],
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   if (isNotifiable) notifyListeners();
  // }

  // Future<void> getProductBrands({@required List<String> storeIds, bool isNotifiable = true}) async {
  //   try {
  //     var result = await ProductListApiProvider.getProductBrands(storeIds: storeIds);

  //     if (result["success"] && result["data"].isNotEmpty) {
  //       List<dynamic> productBrandList = [];
  //       double totalCount = 0;
  //       for (var i = 0; i < result["data"].length; i++) {
  //         totalCount += result["data"][i]["productCount"];
  //         productBrandList.add(result["data"][i]["_id"]);
  //       }

  //       _storeDataState = _storeDataState.update(
  //         progressState: 2,
  //         message: "",
  //         productBrandList: productBrandList,
  //       );
  //     } else if (result["success"] && result["data"].isEmpty) {
  //       _storeDataState = _storeDataState.update(
  //         progressState: 4,
  //         message: "No Data",
  //       );
  //     } else {
  //       _storeDataState = _storeDataState.update(
  //         progressState: 3,
  //         message: result["messsage"],
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   if (isNotifiable) notifyListeners();
  // }
}
