import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dto/top_selling_product.dart';
import 'package:trapp/src/helpers/helper.dart';

import 'index.dart';

class ProductListPageProvider extends ChangeNotifier {
  static ProductListPageProvider of(BuildContext context, {bool listen = false}) => Provider.of<ProductListPageProvider>(context, listen: listen);

  ProductListPageState _productListPageState = ProductListPageState.init();
  ProductListPageState get productListPageState => _productListPageState;

  void setProductListPageState(ProductListPageState productListPageState, {bool isNotifiable = true}) {
    if (_productListPageState != productListPageState) {
      _productListPageState = productListPageState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getProductCategories({@required List<String>? storeIds, @required String? storeSubType}) async {
    try {
      var result = await ProductListApiProvider.getProductCategories(
        storeIds: storeIds,
        storeSubType: storeSubType,
      );

      if (result["success"] && result["data"].isNotEmpty) {
        Map<String, dynamic>? productCategoryData = _productListPageState.productCategoryData;
        List<dynamic> productCategories = [
          {"category": "ALL", "productCount": 0}
        ];
        double totalCount = 0;
        for (var i = 0; i < result["data"].length; i++) {
          totalCount += result["data"][i]["productCount"];
          productCategories.add({
            "category": result["data"][i]["_id"],
            "productCount": result["data"][i]["productCount"],
          });
        }
        productCategories[0]["productCount"] = totalCount;
        productCategoryData![storeIds!.join(',')] = productCategories;

        _productListPageState = _productListPageState.update(
          progressState: 2,
          message: "",
          productCategoryData: productCategoryData,
        );
      } else if (result["success"] && result["data"].isEmpty) {
        _productListPageState = _productListPageState.update(
          progressState: 3,
          message: "No Data",
        );
      } else {
        _productListPageState = _productListPageState.update(
          progressState: 3,
          message: result["messsage"],
        );
      }

      notifyListeners();
    } catch (e) {
      FlutterLogs.logThis(
        tag: "product_list_page_provider",
        level: LogLevel.ERROR,
        subTag: "getProductCategories",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<void> getProductList({
    @required List<String>? storeIds,
    @required List<dynamic>? categories,
    @required bool? isDeleted,
    @required bool? listonline,
    List<dynamic> brands = const [],
    String searchKey = "",
  }) async {
    Map<String, dynamic>? productListData = _productListPageState.productListData;
    Map<String, dynamic>? productMetaData = _productListPageState.productMetaData;

    String category = categories!.isNotEmpty ? categories.join("_") : "ALL";
    if (productListData![category] == null) productListData[category] = [];
    if (productMetaData![category] == null) {
      productMetaData[category] = Map<String, dynamic>();
    }

    try {
      var result = await ProductListApiProvider.getProductList(
        storeIds: storeIds,
        categories: categories,
        brands: brands,
        searchKey: searchKey,
        isDeleted: isDeleted,
        listonline: listonline,
        page: productMetaData[category].isEmpty ? 1 : (productMetaData[category]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        productListData[category].addAll(result["data"]["docs"]);

        result["data"].remove("docs");
        productMetaData[category] = result["data"];

        _productListPageState = _productListPageState.update(
          progressState: 2,
          message: "",
          productListData: productListData,
          productMetaData: productMetaData,
        );
      } else {
        _productListPageState = _productListPageState.update(
          progressState: 2,
          message: result["messsage"],
        );
      }
    } catch (e) {
      _productListPageState = _productListPageState.update(
        progressState: 2,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<List<TopSellingProduct>> getTopSelling({
    @required String? storeId,
    String? userId,
  }) async {
    var result = await ProductApiProvider.getTopSelling(
      storeId: storeId,
      userId: userId,
      from: userId == null ? getMonthStartDay() : null,
      to: userId == null ? getMonthEndDay() : null,
    );
    if (result["success"]) {
      List<TopSellingProduct> products = [];
      for (var i = 0; i < result["data"].length; i++) {
        products.add(TopSellingProduct.fromJson(result["data"][i]));
      }
      return products;
    } else {
      return [];
    }
  }
}
