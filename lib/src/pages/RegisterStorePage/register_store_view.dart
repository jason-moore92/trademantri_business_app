import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/success_dialog.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class RegisterStoreView extends StatefulWidget {
  final String? referredBy;
  final String? referredByUserId;
  final String? appliedFor;

  RegisterStoreView({Key? key, this.referredBy, this.referredByUserId, this.appliedFor}) : super(key: key);

  @override
  _RegisterStoreViewState createState() => _RegisterStoreViewState();
}

class _RegisterStoreViewState extends State<RegisterStoreView> {
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

  StoreProvider? _storeProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  StoreModel? _storeModel;

  int _step = 1;
  int _stepCount = 6;
  int _completedStep = 0;

  bool referralReadOnly = false;

  SharedPreferences? _preferences;

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

    _storeProvider = StoreProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _step = 1;
    _stepCount = 6;
    _completedStep = 0;

    _storeModel = StoreModel();

    _storeModel!.referredBy = widget.referredBy;
    _storeModel!.referredByUserId = widget.referredByUserId;
    _storeModel!.appliedFor = widget.appliedFor;
    if (widget.referredBy != null) {
      referralReadOnly = true;
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _storeProvider!.addListener(_storeProviderListener);

      _preferences = await SharedPreferences.getInstance();
      if (_preferences!.getString("register_store") != null && _preferences!.getString("register_store") != "null") {
        _storeModel = StoreModel.fromJson(json.decode(_preferences!.getString("register_store")!));
        if (_storeModel!.businessType == "store") {
          _stepCount = 6;
        } else {
          _stepCount = 5;
          _storeModel!.type = "Service";
        }
        setState(() {});
      }
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
      _preferences!.setString("register_store", "null");

      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: RegisterStorePageString.successString,
        haveButton: true,
        callBack: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => LoginWidget(),
            ),
          );
        },
      );
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

  @override
  Widget build(BuildContext context) {
    Widget panel = SizedBox();

    switch (_step) {
      case 1:
        panel = Panel1Widget(
          stepCount: _stepCount,
          step: _step,
          completedStep: _completedStep,
          storeModel: _storeModel,
          callback: (step) async {
            if (_completedStep < step - 1) {
              _completedStep = step - 1;
            }

            if (_preferences == null) {
              _preferences = await SharedPreferences.getInstance();
            }
            _preferences!.setString("register_store", json.encode(_storeModel!.toJson()));

            setState(() {
              _step = step;
            });
          },
          businessTypeCallback: (businessType) {
            setState(() {
              if (businessType == "store") {
                _stepCount = 6;
              } else {
                _stepCount = 5;
                _storeModel!.type = "Service";
              }
            });
          },
        );
        break;
      case 2:
        panel = Panel2Widget(
          stepCount: _stepCount,
          step: _step,
          completedStep: _completedStep,
          storeModel: _storeModel,
          callback: (step) async {
            if (_completedStep < step - 1) {
              _completedStep = step - 1;
            }

            if (_preferences == null) _preferences = await SharedPreferences.getInstance();
            _preferences!.setString("register_store", json.encode(_storeModel));

            setState(() {
              _step = step;
            });
          },
        );
        break;
      case 3:
        panel = Panel3Widget(
          stepCount: _stepCount,
          step: _step,
          completedStep: _completedStep,
          storeModel: _storeModel,
          callback: (step) async {
            if (_completedStep < step - 1) {
              _completedStep = step - 1;
            }

            if (_preferences == null) _preferences = await SharedPreferences.getInstance();
            _preferences!.setString("register_store", json.encode(_storeModel));

            setState(() {
              _step = step;
            });
          },
        );
        break;
      case 4:
        if (_stepCount == 6) {
          panel = Panel4Widget(
            stepCount: _stepCount,
            step: _step,
            completedStep: _completedStep,
            storeModel: _storeModel,
            callback: (step) async {
              if (_completedStep < step - 1) {
                _completedStep = step - 1;
              }

              if (_preferences == null) {
                _preferences = await SharedPreferences.getInstance();
              }
              _preferences!.setString("register_store", json.encode(_storeModel));

              setState(() {
                _step = step;
              });
            },
          );
        } else {
          panel = Panel5Widget(
            stepCount: _stepCount,
            step: _step,
            completedStep: _completedStep,
            storeModel: _storeModel,
            callback: (step) async {
              if (_completedStep < step - 1) {
                _completedStep = step - 1;
              }

              if (_preferences == null) _preferences = await SharedPreferences.getInstance();
              _preferences!.setString("register_store", json.encode(_storeModel));

              setState(() {
                _step = step;
              });
            },
          );
        }
        break;
      case 5:
        if (_stepCount == 6) {
          panel = Panel5Widget(
            stepCount: _stepCount,
            step: _step,
            completedStep: _completedStep,
            storeModel: _storeModel,
            callback: (step) async {
              if (_completedStep < step - 1) {
                _completedStep = step - 1;
              }

              if (_preferences == null) _preferences = await SharedPreferences.getInstance();
              _preferences!.setString("register_store", json.encode(_storeModel));

              setState(() {
                _step = step;
              });
            },
          );
        } else {
          panel = Panel6Widget(
            stepCount: _stepCount,
            step: _step,
            completedStep: _completedStep,
            storeModel: _storeModel,
            referralReadOnly: referralReadOnly,
            callback: (step) async {
              if (step == 999) {
                await _keicyProgressDialog!.show();
                _storeProvider!.registerStore(
                  storeData: _storeModel!.toJson(),
                );
              } else {
                if (_completedStep < step - 1) {
                  _completedStep = step - 1;
                }

                if (_preferences == null) {
                  _preferences = await SharedPreferences.getInstance();
                }
                _preferences!.setString("register_store", json.encode(_storeModel));

                setState(() {
                  _step = step;
                });
              }
            },
          );
        }
        break;
      case 6:
        panel = Panel6Widget(
          stepCount: _stepCount,
          step: _step,
          completedStep: _completedStep,
          storeModel: _storeModel,
          referralReadOnly: referralReadOnly,
          callback: (step) async {
            if (step == 999) {
              await _keicyProgressDialog!.show();
              _storeProvider!.registerStore(
                storeData: _storeModel!.toJson(),
              );
            } else {
              if (_completedStep < step - 1) {
                _completedStep = step - 1;
              }

              if (_preferences == null) {
                _preferences = await SharedPreferences.getInstance();
              }
              _preferences!.setString("register_store", json.encode(_storeModel));

              setState(() {
                _step = step;
              });
            }
          },
        );
        break;
      default:
    }

    return Scaffold(
      appBar: AppBar(
        leading: _step == 1
            ? SizedBox()
            : BackButton(
                onPressed: () {
                  setState(() {
                    _step--;
                  });
                },
              ),
        elevation: 0,
      ),
      body: panel,
    );
  }
}
