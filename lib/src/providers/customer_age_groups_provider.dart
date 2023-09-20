import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/customer_api_provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dto/customer_age_group.dart';
import 'package:trapp/src/entities/fliter_type.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/src/states/customer_age_group_state.dart';

class CustomerAgeGroupsProvider extends ChangeNotifier {
  static CustomerAgeGroupsProvider of(BuildContext context, {bool listen = false}) => Provider.of<CustomerAgeGroupsProvider>(context, listen: listen);

  CustomerAgeGroupsState _state = CustomerAgeGroupsState();
  CustomerAgeGroupsState get state => _state;

  void setCustomerAgeGroupsState(CustomerAgeGroupsState state, {bool isNotifiable = true}) {
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
        "from": getMonthStartDay(),
        "to": getMonthEndDay(),
      },
      filterType: FilterType.simple,
      years: KeicyDateTime.yearsForDropDown(),
      months: KeicyDateTime.monthsForDropDown(),
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
        if (_state.searchData!["year"] != null || _state.searchData!["month"] != null) {
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
          from = getMonthStartDay(
            year: _state.searchData!["year"],
            month: _state.searchData!["month"],
          );
          to = getMonthEndDay(
            year: _state.searchData!["year"],
            month: _state.searchData!["month"],
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
    var result = await CustomerApiProvider.groupByAge(
      storeId: storeId,
      from: from,
      to: to,
    );
    if (result["success"]) {
      List<CustomerAgeGroup> data = [];
      for (var i = 0; i < result["data"].length; i++) {
        data.add(CustomerAgeGroup.fromJson(result["data"][i]));
      }
      _state = _state.copyWith(
        groups: data,
        isRefresh: isRefresh,
        isLoading: false,
      );
    } else {
      _state = _state.copyWith(
        groups: [],
        isRefresh: isRefresh,
        isLoading: false,
      );
    }

    notifyListeners();
  }

  bool checkData(List<CustomerAgeGroup> groups) {
    bool dataThere = false;

    for (var i = 0; i < groups.length; i++) {
      if (groups[i].count! > 0) {
        dataThere = true;
      }
    }
    return dataThere;
  }
}
