import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class CatalogServiceListPageProvider extends ChangeNotifier {
  static CatalogServiceListPageProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<CatalogServiceListPageProvider>(context, listen: listen);

  CatalogServiceListPageState _catalogServiceListPageState = CatalogServiceListPageState.init();
  CatalogServiceListPageState get catalogServiceListPageState => _catalogServiceListPageState;

  void setCatalogServiceListPageState(CatalogServiceListPageState catalogServiceListPageState, {bool isNotifiable = true}) {
    if (_catalogServiceListPageState != catalogServiceListPageState) {
      _catalogServiceListPageState = catalogServiceListPageState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getCatalogServiceList({
    String searchTerm = "",
    String cat = "",
    String subCat = "",
  }) async {
    List<dynamic>? serviceListData = _catalogServiceListPageState.serviceListData;
    Map<String, dynamic>? serviceMetaData = _catalogServiceListPageState.serviceMetaData;

    if (serviceListData == null) serviceListData = [];
    if (serviceMetaData == null) serviceMetaData = Map<String, dynamic>();

    try {
      var result = await CatalogApiProvider.getCatalogServices(
        searchTerm: searchTerm,
        cat: cat,
        subCat: subCat,
        page: serviceMetaData.isEmpty ? 0 : (serviceMetaData["page"] + 1 ?? 0),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["results"].length; i++) {
          result["data"]["results"][i]["imgLocation"] = result["data"]["imgLocation"];
          serviceListData.add(result["data"]["results"][i]);
        }

        result["data"].remove("results");
        serviceMetaData = result["data"];

        _catalogServiceListPageState = _catalogServiceListPageState.update(
          progressState: 2,
          message: "",
          serviceListData: serviceListData,
          serviceMetaData: serviceMetaData,
        );
      } else {
        _catalogServiceListPageState = _catalogServiceListPageState.update(
          progressState: 2,
          message: result["messsage"],
        );
      }
    } catch (e) {
      _catalogServiceListPageState = _catalogServiceListPageState.update(
        progressState: 2,
        message: e.toString(),
      );
    }

    notifyListeners();
  }
}
