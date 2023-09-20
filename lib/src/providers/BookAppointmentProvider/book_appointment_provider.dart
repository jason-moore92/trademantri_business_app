import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class BookAppointmentProvider extends ChangeNotifier {
  static BookAppointmentProvider of(BuildContext context, {bool listen = false}) => Provider.of<BookAppointmentProvider>(context, listen: listen);

  BookAppointmentState _bookAppointmentState = BookAppointmentState.init();
  BookAppointmentState get bookAppointmentState => _bookAppointmentState;

  void setBookAppointmentState(BookAppointmentState bookAppointmentState, {bool isNotifiable = true}) {
    if (_bookAppointmentState != bookAppointmentState) {
      _bookAppointmentState = bookAppointmentState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getBookData({
    @required String? storeId,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? bookListData = _bookAppointmentState.bookListData;
    Map<String, dynamic>? bookListMetaData = _bookAppointmentState.bookListMetaData;
    try {
      if (bookListData![status] == null) bookListData[status!] = [];
      if (bookListMetaData![status] == null) bookListMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await BookAppointmentApiProvider.getBookData(
        storeId: storeId,
        status: status,
        searchKey: searchKey,
        page: bookListMetaData[status].isEmpty ? 1 : (bookListMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          bookListData[status].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        bookListMetaData[status!] = result["data"];

        _bookAppointmentState = _bookAppointmentState.update(
          progressState: 2,
          bookListData: bookListData,
          bookListMetaData: bookListMetaData,
        );
      } else {
        _bookAppointmentState = _bookAppointmentState.update(
          progressState: 2,
          message: result["message"] ?? "Something was wrong",
        );
      }
    } catch (e) {
      _bookAppointmentState = _bookAppointmentState.update(
        progressState: 2,
        message: "Something was wrong",
      );
    }
    notifyListeners();
  }
}
