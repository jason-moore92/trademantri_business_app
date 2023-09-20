import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class StoreTimingDetailView extends StatefulWidget {
  StoreTimingDetailView({Key? key}) : super(key: key);

  @override
  _StoreTimingDetailViewState createState() => _StoreTimingDetailViewState();
}

class _StoreTimingDetailViewState extends State<StoreTimingDetailView> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  AuthProvider? _authProvider;
  StoreProvider? _storeProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  StoreModel _storeModel = StoreModel();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool isValidated = true;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _authProvider = AuthProvider.of(context);
    _storeProvider = StoreProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _storeModel = StoreModel.copy(_authProvider!.authState.storeModel!);

    isValidated = true;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _storeProvider!.addListener(_storeProviderListener);
    });
  }

  @override
  void dispose() {
    _storeProvider!.removeListener(_storeProviderListener);
    super.dispose();
  }

  void _storeProviderListener() async {
    if (_storeProvider!.storeState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_storeProvider!.storeState.progressState == 2) {
      _authProvider!.setAuthState(
        _authProvider!.authState.update(storeModel: _storeModel),
      );
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp);
    } else if (_storeProvider!.storeState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _storeProvider!.storeState.message!,
      );
    }
  }

  void saveHandler() async {
    if (!_formkey.currentState!.validate()) return;
    _formkey.currentState!.save();

    for (var i = 0; i < 7; i++) {
      String day = "";
      switch (i) {
        case 0:
          day = "Monday";
          break;
        case 1:
          day = "Tuesday";
          break;
        case 2:
          day = "Wednesday";
          break;
        case 3:
          day = "Thursday";
          break;
        case 4:
          day = "Friday";
          break;
        case 5:
          day = "Saturday";
          break;
        case 6:
          day = "Sunday";
          break;
        default:
      }
      _storeModel.profile!["hours"][i]["day"] = day;
    }

    await _keicyProgressDialog!.show();
    _storeProvider!.setStoreState(_storeProvider!.storeState.update(progressState: 1), isNotifiable: false);
    _storeProvider!.updateStore(id: _storeModel.id, storeData: _storeModel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: config.Colors().mainColor(1),
        centerTitle: true,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          StoreTimingDetailPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
        ),
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (!isValidated) {
                    ErrorDialog.show(
                      context,
                      widthDp: widthDp,
                      heightDp: heightDp,
                      fontSp: fontSp,
                      text: StoreTimingDetailPageString.validateString,
                    );
                  } else {
                    SaveConfirmDialog.show(context, callback: saveHandler);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: Container(
          width: deviceWidth,
          height: deviceHeight - statusbarHeight - appbarHeight,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
          child: SingleChildScrollView(
            child: _mainPanel(),
          ),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    isValidated = true;
    if (_storeModel.profile!["hours"].isEmpty) {
      _storeModel.profile!["hours"] = [];
      for (var i = 0; i < 7; i++) {
        String day = "";
        switch (i) {
          case 0:
            day = "Monday";
            break;
          case 1:
            day = "Tuesday";
            break;
          case 2:
            day = "Wednesday";
            break;
          case 3:
            day = "Thursday";
            break;
          case 4:
            day = "Friday";
            break;
          case 5:
            day = "Saturday";
            break;
          case 6:
            day = "Sunday";
            break;
          default:
        }
        _storeModel.profile!["hours"].add({
          "isWorkingDay": false,
          "openingTime": "",
          "closingTime": "",
          "day": day,
        });
      }
    }

    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(7, (weekday) {
          DateTime? openTime;
          DateTime? closeTime;
          String? validateString;

          if (_storeModel.profile!["hours"][weekday]["isWorkingDay"] &&
              _storeModel.profile!["hours"][weekday]["openingTime"] != null &&
              _storeModel.profile!["hours"][weekday]["openingTime"] != "") {
            openTime = DateTime.tryParse(_storeModel.profile!["hours"][weekday]["openingTime"])!.toLocal();
          }

          if (_storeModel.profile!["hours"][weekday]["isWorkingDay"] &&
              _storeModel.profile!["hours"][weekday]["closingTime"] != null &&
              _storeModel.profile!["hours"][weekday]["closingTime"] != "") {
            closeTime = DateTime.tryParse(_storeModel.profile!["hours"][weekday]["closingTime"])!.toLocal();
          }
          if (_storeModel.profile!["hours"][weekday]["isWorkingDay"] && (openTime == null || closeTime == null)) {
            validateString = StoreTimingDetailPageString.validateString1;
            isValidated = false;
          } else if (_storeModel.profile!["hours"][weekday]["isWorkingDay"] &&
              (openTime != null && closeTime != null) &&
              !(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                closeTime.hour,
                closeTime.minute,
              ).isAfter(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                openTime.hour,
                openTime.minute,
              )))) {
            validateString = StoreTimingDetailPageString.validateString2;
            isValidated = false;
          }

          return Stack(
            children: [
              Container(
                width: deviceWidth,
                margin: EdgeInsets.symmetric(vertical: heightDp * 10),
                padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(heightDp * 8),
                ),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KeicyCheckBox(
                      iconSize: heightDp * 25,
                      iconColor: config.Colors().mainColor(1),
                      label: StoreTimingDetailPageString.notOpen,
                      labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      value: !_storeModel.profile!["hours"][weekday]["isWorkingDay"],
                      onChangeHandler: (value) {
                        setState(() {
                          _storeModel.profile!["hours"][weekday]["isWorkingDay"] = !value;
                        });
                      },
                    ),
                    SizedBox(height: heightDp * 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        KeicyRaisedButton(
                          width: widthDp * 120,
                          height: heightDp * 35,
                          color: _storeModel.profile!["hours"][weekday]["isWorkingDay"] ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.4),
                          borderRadius: heightDp * 8,
                          child: Text(
                            (openTime != null
                                ? "${KeicyDateTime.convertDateTimeToDateString(
                                    dateTime: openTime,
                                    formats: 'h:i A',
                                    isUTC: false,
                                  )}"
                                : "${StoreTimingDetailPageString.fromTime}"),
                            style: TextStyle(
                              fontSize: fontSp * 14,
                              color: _storeModel.profile!["hours"][weekday]["isWorkingDay"] ? Colors.white : Colors.black,
                            ),
                          ),
                          onPressed: !_storeModel.profile!["hours"][weekday]["isWorkingDay"]
                              ? null
                              : () {
                                  _openTimeHandler(weekday);
                                },
                        ),
                        Container(width: widthDp * 20, height: 2, color: Colors.black),
                        KeicyRaisedButton(
                          width: widthDp * 120,
                          height: heightDp * 35,
                          color: _storeModel.profile!["hours"][weekday]["isWorkingDay"] ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.4),
                          borderRadius: heightDp * 8,
                          child: Text(
                            (closeTime != null
                                ? "${KeicyDateTime.convertDateTimeToDateString(
                                    dateTime: closeTime,
                                    formats: 'h:i A',
                                    isUTC: false,
                                  )}"
                                : "${StoreTimingDetailPageString.toTime}"),
                            style: TextStyle(
                              fontSize: fontSp * 14,
                              color: _storeModel.profile!["hours"][weekday]["isWorkingDay"] ? Colors.white : Colors.black,
                            ),
                          ),
                          onPressed: !_storeModel.profile!["hours"][weekday]["isWorkingDay"]
                              ? null
                              : () {
                                  _closeTimeHandler(weekday);
                                },
                        ),
                      ],
                    ),

                    // ///
                    // if (_storeModel.profile!["hours"][weekday]["isWorkingDay"])
                    //   Column(
                    //     children: [
                    //       SizedBox(height: heightDp * 10),
                    //       Text(
                    //         (openTime != null
                    //                 ? "${KeicyDateTime.convertDateTimeToDateString(dateTime: openTime, formats: "h:i A")}"
                    //                 : "${StoreTimingDetailPageString.fromTime}") +
                    //             " ~ " +
                    //             (closeTime != null
                    //                 ? "${KeicyDateTime.convertDateTimeToDateString(dateTime: closeTime, formats: "h:i A")}"
                    //                 : "${StoreTimingDetailPageString.toTime}"),
                    //         style: TextStyle(
                    //           fontSize: fontSp * 14,
                    //           color: _storeModel.profile!["hours"][weekday]["isWorkingDay"] ? Colors.black : Colors.grey.withOpacity(0.7),
                    //         ),
                    //       ),
                    //     ],
                    //   ),

                    ///
                    if (_storeModel.profile!["hours"][weekday]["isWorkingDay"] && validateString != null)
                      Column(
                        children: [
                          SizedBox(height: heightDp * 10),
                          Center(
                            child: Text(
                              validateString,
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.red.withOpacity(0.8)),
                            ),
                          ),
                        ],
                      ),

                    ///
                    if (_storeModel.profile!["hours"][weekday]["isWorkingDay"])
                      Column(
                        children: [
                          Divider(height: heightDp * 30, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              KeicyRaisedButton(
                                width: widthDp * 160,
                                height: heightDp * 35,
                                color: (_storeModel.profile!["hours"][weekday]["isWorkingDay"] && validateString == null)
                                    ? config.Colors().mainColor(1)
                                    : Colors.grey.withOpacity(0.6),
                                borderRadius: heightDp * 8,
                                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                                child: Text(
                                  _storeModel.profile!["hours"][weekday]["hoursBreakdown"] == null ? "Add Breakdown" : "Cancel Breakdown",
                                  style: TextStyle(
                                    fontSize: fontSp * 14,
                                    color: (_storeModel.profile!["hours"][weekday]["isWorkingDay"] && validateString == null)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                onPressed: (_storeModel.profile!["hours"][weekday]["isWorkingDay"] && validateString == null)
                                    ? _storeModel.profile!["hours"][weekday]["hoursBreakdown"] == null
                                        ? () {
                                            _storeModel.profile!["hours"][weekday]["hoursBreakdown"] = [
                                              {
                                                "type": "MorningTime",
                                                "fromTime": _storeModel.profile!["hours"][weekday]["openingTime"],
                                                "toTime": null
                                              },
                                              {
                                                "type": "EveningTime",
                                                "fromTime": null,
                                                "toTime": _storeModel.profile!["hours"][weekday]["closingTime"]
                                              }
                                            ];

                                            setState(() {});
                                          }
                                        : () {
                                            _storeModel.profile!["hours"][weekday]["hoursBreakdown"] = null;

                                            setState(() {});
                                          }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),

                    ///
                    if (_storeModel.profile!["hours"][weekday]["hoursBreakdown"] != null)
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              _storeModel.profile!["hours"][weekday]["hoursBreakdown"].length,
                              (index) {
                                var breadDownData = _storeModel.profile!["hours"][weekday]["hoursBreakdown"][index];
                                return _breadDownWidget(weekday, index, breadDownData);
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Positioned(
                left: widthDp * 15,
                child: Container(
                  height: heightDp * 20,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                  color: Colors.white,
                  child: Text(
                    StoreTimingDetailPageString.weekDays[weekday],
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _breadDownWidget(int weekday, int index, Map<String, dynamic> data) {
    DateTime? fromTime = data["fromTime"] != null ? DateTime.tryParse(data["fromTime"])!.toLocal() : null;
    DateTime? toTime = data["toTime"] != null ? DateTime.tryParse(data["toTime"])!.toLocal() : null;

    String? validateString;

    if ((fromTime != null && toTime == null) || (fromTime == null && toTime != null)) {
      validateString = StoreTimingDetailPageString.validateString1;
      isValidated = false;
    } else if ((fromTime != null && toTime != null) &&
        !(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          toTime.hour,
          toTime.minute,
        ).isAfter(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            fromTime.hour,
            fromTime.minute,
          ),
        ))) {
      validateString = StoreTimingDetailPageString.validateString2;
      isValidated = false;
    }

    DateTime preFromTime;
    DateTime? preToTime;
    DateTime nowFromTime;
    DateTime nowToTime;
    for (var i = 0; i < _storeModel.profile!["hours"][weekday]["hoursBreakdown"].length; i++) {
      var breakDownData = _storeModel.profile!["hours"][weekday]["hoursBreakdown"][i];
      if (breakDownData["fromTime"] == null || breakDownData["toTime"] == null) continue;
      nowFromTime = DateTime.tryParse(breakDownData["fromTime"])!.toLocal();
      nowToTime = DateTime.tryParse(breakDownData["toTime"])!.toLocal();

      if (i != 0) {
        if (DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          toTime!.hour,
          toTime.minute,
        ).isBefore(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            fromTime!.hour,
            fromTime.minute,
          ),
        )) {
          continue;
        }

        if (DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          nowFromTime.hour,
          nowFromTime.minute,
        ).isBefore(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            preToTime!.hour,
            preToTime.minute,
          ),
        )) {
          if (index == 0) {
            validateString = StoreTimingDetailPageString.morningValidateString;
          } else {
            validateString = StoreTimingDetailPageString.eveningValidateString;
          }
          isValidated = false;
        }
      }

      preFromTime = DateTime.tryParse(breakDownData["fromTime"])!.toLocal();
      preToTime = DateTime.tryParse(breakDownData["toTime"])!.toLocal();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: heightDp * 20),
        Row(
          children: [
            Text(
              "${data["type"]}: ",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: widthDp * 10),
            // Expanded(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         (fromTime != null
            //                 ? "${KeicyDateTime.convertDateTimeToDateString(dateTime: fromTime, formats: "h:i A")}"
            //                 : "${StoreTimingDetailPageString.fromTime}") +
            //             " ~ " +
            //             (toTime != null
            //                 ? "${KeicyDateTime.convertDateTimeToDateString(dateTime: toTime, formats: "h:i A")}"
            //                 : "${StoreTimingDetailPageString.toTime}"),
            //         style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        SizedBox(height: heightDp * 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 35,
              color: index == 0 ? Colors.grey.withOpacity(0.6) : config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              child: Text(
                (fromTime != null
                    ? "${KeicyDateTime.convertDateTimeToDateString(
                        dateTime: fromTime,
                        formats: 'h:i A',
                        isUTC: false,
                      )}"
                    : "${StoreTimingDetailPageString.fromTime}"),
                style: TextStyle(
                  fontSize: fontSp * 14,
                  color: index == 0 ? Colors.black : Colors.white,
                ),
              ),
              onPressed: index == 0
                  ? null
                  : () {
                      _fromBreakTimeHandler(weekday, index, data["type"]);
                    },
            ),
            KeicyRaisedButton(
              width: widthDp * 120,
              height: heightDp * 35,
              color: index == _storeModel.profile!["hours"][weekday]["hoursBreakdown"].length - 1
                  ? Colors.grey.withOpacity(0.6)
                  : config.Colors().mainColor(1),
              borderRadius: heightDp * 8,
              child: Text(
                (toTime != null
                    ? "${KeicyDateTime.convertDateTimeToDateString(
                        dateTime: toTime,
                        formats: 'h:i A',
                        isUTC: false,
                      )}"
                    : "${StoreTimingDetailPageString.toTime}"),
                style: TextStyle(
                  fontSize: fontSp * 14,
                  color: index == _storeModel.profile!["hours"][weekday]["hoursBreakdown"].length - 1 ? Colors.black : Colors.white,
                ),
              ),
              onPressed: index == _storeModel.profile!["hours"][weekday]["hoursBreakdown"].length - 1
                  ? null
                  : () {
                      _toBreakTimeHandler(weekday, index, data["type"]);
                    },
            ),
          ],
        ),
        if (_storeModel.profile!["hours"][weekday]["isWorkingDay"] && validateString != null)
          Column(
            children: [
              SizedBox(height: heightDp * 10),
              Center(
                child: Text(
                  validateString,
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.red.withOpacity(0.8)),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _fromBreakTimeHandler(int weekday, int index, String type) async {
    TimeOfDay? time = await showCustomTimePicker(
      context: context,
      onFailValidation: (context) => FlutterLogs.logWarn(
        "store_timing_detail_view",
        "_fromBreakTimeHandler",
        "Unavailable selection",
      ),
      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    );
    if (time == null) return;
    setState(() {
      _storeModel.profile!["hours"][weekday]["hoursBreakdown"][index]["fromTime"] = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        time.hour,
        time.minute,
      ).toUtc().toIso8601String();
    });
  }

  void _toBreakTimeHandler(int weekday, int index, String type) async {
    TimeOfDay? time = await showCustomTimePicker(
      context: context,
      onFailValidation: (context) => FlutterLogs.logWarn(
        "store_timing_detail_view",
        "_toBreakTimeHandler",
        "Unavailable selection",
      ),
      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    );
    if (time == null) return;
    setState(() {
      _storeModel.profile!["hours"][weekday]["hoursBreakdown"][index]["toTime"] = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        time.hour,
        time.minute,
      ).toUtc().toIso8601String();
    });
  }

  void _openTimeHandler(weekday) async {
    TimeOfDay? time = await showCustomTimePicker(
      context: context,
      onFailValidation: (context) => FlutterLogs.logWarn(
        "store_timing_detail_view",
        "_openTimeHandler",
        "Unavailable selection",
      ),
      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    );
    if (time == null) return;
    setState(() {
      _storeModel.profile!["hours"][weekday]["openingTime"] = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        time.hour,
        time.minute,
      ).toUtc().toIso8601String();

      if (_storeModel.profile!["hours"][weekday]["hoursBreakdown"] != null) {
        _storeModel.profile!["hours"][weekday]["hoursBreakdown"][0]["fromTime"] = _storeModel.profile!["hours"][weekday]["openingTime"];
      }
    });
  }

  void _closeTimeHandler(weekday) async {
    TimeOfDay? time = await showCustomTimePicker(
      context: context,
      onFailValidation: (context) => FlutterLogs.logWarn(
        "store_timing_detail_view",
        "_closeTimeHandler",
        "Unavailable selection",
      ),
      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    );
    if (time == null) return;
    setState(() {
      _storeModel.profile!["hours"][weekday]["closingTime"] = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        time.hour,
        time.minute,
      ).toUtc().toIso8601String();
      if (_storeModel.profile!["hours"][weekday]["hoursBreakdown"] != null) {
        _storeModel.profile!["hours"][weekday]["hoursBreakdown"].last["toTime"] = _storeModel.profile!["hours"][weekday]["closingTime"];
      }
    });
  }
}
