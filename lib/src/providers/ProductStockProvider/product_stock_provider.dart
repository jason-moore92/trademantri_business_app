import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/entities/product_stock.dart';
import 'package:trapp/src/models/index.dart';

import 'index.dart';

class ProductStockProvider extends ChangeNotifier {
  static ProductStockProvider of(BuildContext context, {bool listen = false}) => Provider.of<ProductStockProvider>(context, listen: listen);

  ProductStockState _productStockState = ProductStockState.init();
  ProductStockState get productStockState => _productStockState;

  void setProductStockState(ProductStockState productStockState, {bool isNotifiable = true}) {
    if (_productStockState != productStockState) {
      _productStockState = productStockState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getAll({@required String? storeId, String? productId, String searchKey = ""}) async {
    List<ProductStock>? entryListData = _productStockState.entryListData;
    Map<String, dynamic>? entryMetaData = _productStockState.entryMetaData;
    try {
      if (entryMetaData == null) entryMetaData = Map<String, dynamic>();

      var result;

      result = await ProductStockApiProvider.getAll(
        storeId: storeId,
        productId: productId,
        searchKey: searchKey,
        page: entryMetaData.isEmpty ? 1 : (entryMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          ProductStock ps = ProductStock.fromJson(result["data"]["docs"][i]);
          entryListData!.add(ps);
        }
        result["data"].remove("docs");
        entryMetaData = result["data"];

        _productStockState = _productStockState.update(
          progressState: 2,
          entryListData: entryListData,
          entryMetaData: entryMetaData,
        );
      } else {
        _productStockState = _productStockState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _productStockState = _productStockState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  //Add Entry
}
