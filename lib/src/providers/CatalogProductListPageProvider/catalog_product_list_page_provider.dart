import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class CatalogProductListPageProvider extends ChangeNotifier {
  static CatalogProductListPageProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<CatalogProductListPageProvider>(context, listen: listen);

  CatalogProductListPageState _catalogProductListPageState = CatalogProductListPageState.init();
  CatalogProductListPageState get catalogProductListPageState => _catalogProductListPageState;

  void setCatalogProductListPageState(CatalogProductListPageState catalogProductListPageState, {bool isNotifiable = true}) {
    if (_catalogProductListPageState != catalogProductListPageState) {
      _catalogProductListPageState = catalogProductListPageState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getCatalogProductList({
    String searchTerm = "",
    String cat = "",
    String subCat = "",
  }) async {
    List<dynamic>? productListData = _catalogProductListPageState.productListData;
    Map<String, dynamic>? productMetaData = _catalogProductListPageState.productMetaData;

    if (productListData == null) productListData = [];
    if (productMetaData == null) productMetaData = Map<String, dynamic>();

    try {
      var result = await CatalogApiProvider.getCatalogProducts(
        searchTerm: searchTerm,
        cat: cat,
        subCat: subCat,
        page: productMetaData.isEmpty ? 0 : (productMetaData["page"] + 1 ?? 0),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["results"].length; i++) {
          result["data"]["results"][i]["imgLocation"] = result["data"]["imgLocation"];
          productListData.add(result["data"]["results"][i]);
        }

        result["data"].remove("results");
        productMetaData = result["data"];

        _catalogProductListPageState = _catalogProductListPageState.update(
          progressState: 2,
          message: "",
          productListData: productListData,
          productMetaData: productMetaData,
        );
      } else {
        _catalogProductListPageState = _catalogProductListPageState.update(
          progressState: 2,
          message: result["messsage"],
        );
      }
    } catch (e) {
      _catalogProductListPageState = _catalogProductListPageState.update(
        progressState: 2,
        message: e.toString(),
      );
    }

    notifyListeners();
  }
}
