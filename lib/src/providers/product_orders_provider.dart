import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dto/product_order.dart';
import 'package:trapp/src/entities/fliter_type.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/states/product_orders_state.dart';

class ProductOrdersProvider extends ChangeNotifier {
  static ProductOrdersProvider of(BuildContext context, {bool listen = false}) => Provider.of<ProductOrdersProvider>(context, listen: listen);

  ProductOrdersState _state = ProductOrdersState();
  ProductOrdersState get state => _state;

  void setProductOrdersState(ProductOrdersState state, {bool isNotifiable = true}) {
    if (_state != state) {
      _state = state;
      if (isNotifiable) notifyListeners();
    }
  }

  init() {
    DateTime now = DateTime.now();
    _state = _state.copyWith(
      searchData: {
        "year": now.year,
        "month": now.month,
        "weekNumber": (now.day / 7).ceil(),
        "from": getMonthStartDay(),
        "to": getMonthEndDay(),
      },
      filterType: FilterType.simple,
      years: KeicyDateTime.yearsForDropDown(),
      months: KeicyDateTime.monthsForDropDown(),
      weekNumbers: KeicyDateTime.weekNumbersForDropDown(),
    );
    notifyListeners();
  }

  setYear(String? year) {
    if (year == null) {}
    Map<String, dynamic> data = state.searchData!;
    data["year"] = int.parse(year!);
    changeSearchData(data);
  }

  setMonth(String? month) {
    if (month == null) {}
    Map<String, dynamic> data = state.searchData!;
    data["month"] = int.parse(month!);
    changeSearchData(data);
  }

  setWeekNumber(String? weekNumber) {
    if (weekNumber == null) {}
    Map<String, dynamic> data = state.searchData!;
    data["weekNumber"] = int.parse(weekNumber!);
    changeSearchData(data);
  }

  setFrom(String from) {
    Map<String, dynamic> data = state.searchData!;
    data["from"] = from;
    changeSearchData(data);
  }

  setTo(String to) {
    Map<String, dynamic> data = state.searchData!;
    data["to"] = to;
    changeSearchData(data);
  }

  changeSearchData(Map<String, dynamic> newSearchData) {
    _state = _state.copyWith(
      searchData: newSearchData,
    );
    notifyListeners();
  }

  toggleMode() {
    _state = _state.copyWith(
      filterType: _state.filterType == FilterType.simple ? FilterType.advanced : FilterType.simple,
    );
    notifyListeners();
  }

  bool isSearchData() {
    bool result = false;

    if (_state.filterType == FilterType.simple) {
      if (_state.searchData != null) {
        if (_state.searchData!["year"] != null || _state.searchData!["month"] != null || _state.searchData!["weekNumber"] != null) {
          result = true;
        }
      }
    }

    if (_state.filterType == FilterType.advanced) {
      if (_state.searchData != null) {
        if (_state.searchData!["from"] != null || _state.searchData!["to"] != null) {
          result = true;
        }
      }
    }

    return result;
  }

  getData({
    @required String? storeId,
    String? productId,
    bool? isRefresh,
  }) async {
    _state = _state.copyWith(
      isLoading: true,
    );
    notifyListeners();
    // await Future.delayed(
    //   Duration(seconds: 10),
    // );
    String? from;
    String? to;

    if (_state.filterType == FilterType.simple) {
      if (_state.searchData != null) {
        if (_state.searchData!["year"] != null && _state.searchData!["month"] != null) {
          from = getWeekStartDay(
            year: _state.searchData!["year"],
            month: _state.searchData!["month"],
            weekNumber: _state.searchData!["weekNumber"],
          );
          to = getWeekEndDay(
            year: _state.searchData!["year"],
            month: _state.searchData!["month"],
            weekNumber: _state.searchData!["weekNumber"],
          );
        }
      }
    }
    if (_state.filterType == FilterType.advanced) {
      if (_state.searchData != null) {
        if (_state.searchData!["from"] != null && _state.searchData!["to"] != null) {
          from = _state.searchData!["from"];
          to = _state.searchData!["to"];
        }
      }
    }
    var result = await ProductApiProvider.getStatisticsByOrder(
      storeId: storeId,
      productId: productId,
      from: from,
      to: to,
    );
    if (result["success"]) {
      List<ProductOrder> products = [];
      for (var i = 0; i < result["data"].length; i++) {
        products.add(ProductOrder.fromJson(result["data"][i]));
      }
      _state = _state.copyWith(
        pos: products,
        isRefresh: isRefresh,
        isLoading: false,
      );
    } else {
      _state = _state.copyWith(
        pos: [],
        isRefresh: isRefresh,
        isLoading: false,
      );
    }

    notifyListeners();
  }

  bool checkData(List<ProductOrder> poss) {
    bool dataThere = false;

    for (var i = 0; i < poss.length; i++) {
      if (poss[i].count! > 0) {
        dataThere = true;
      }
    }
    return dataThere;
  }

  List<FlSpot> convertToGraph(List<ProductOrder> poss) {
    List<FlSpot> result = [];
    for (var i = 0; i < poss.length; i++) {
      result.add(FlSpot(i.toDouble(), poss[i].count!.toDouble()));
    }
    return result;
  }

  List<FlSpot> convertToGraphProductCount(List<ProductOrder> poss) {
    List<FlSpot> result = [];
    for (var i = 0; i < poss.length; i++) {
      result.add(FlSpot(i.toDouble(), poss[i].productCount!.toDouble()));
    }
    return result;
  }

  List<FlSpot> convertToGraphServiceCount(List<ProductOrder> poss) {
    List<FlSpot> result = [];
    for (var i = 0; i < poss.length; i++) {
      result.add(FlSpot(i.toDouble(), poss[i].serviceCount!.toDouble()));
    }
    return result;
  }

  getProductData({
    @required String? productId,
    @required String? storeId,
  }) async {
    _state = _state.copyWith(
      isLoading: true,
    );
    notifyListeners();

    var result = await ProductApiProvider.getProduct(
      id: productId,
    );
    if (result["success"]) {
      _state = _state.copyWith(
        isRefresh: false,
        product: ProductModel.fromJson(result["data"]),
        isLoading: false,
      );
    }

    notifyListeners();
  }
}
