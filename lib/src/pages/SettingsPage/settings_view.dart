import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/ip_util.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class SettingsView extends StatefulWidget {
  final bool haveAppbar;

  SettingsView({Key? key, this.haveAppbar = true}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
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
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  TextEditingController _ipController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  FocusNode _ipFocusNode = FocusNode();
  FocusNode _portFocusNode = FocusNode();
  List<dynamic> _newPosData = List.generate(1, (index) => Map<String, dynamic>());

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

    if (_storeModel.settings != null) {
      _controller.text =
          _storeModel.settings!["bargainOfferPricePercent"] != null ? _storeModel.settings!["bargainOfferPricePercent"].toString() : "";
    }

    if (_storeModel.settings == null) {
      _storeModel.settings = AppConfig.initialSettings;
    }

    if (_storeModel.settings == null) {
      _storeModel.settings = AppConfig.initialSettings;
    }
    if (_storeModel.settings!["posInfo"] == null) _storeModel.settings!["posInfo"] = [];

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
      setState(() {
        _authProvider!.setAuthState(
          _authProvider!.authState.update(storeModel: _storeModel),
        );
      });
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

  void _saveHandler() async {
    if (!_formkey.currentState!.validate()) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Please fix missing fields that are marked as red",
      );
      return;
    }

    await _keicyProgressDialog!.show();
    _storeProvider!.setStoreState(_storeProvider!.storeState.update(progressState: 1), isNotifiable: false);
    _storeProvider!.updateStore(id: _storeModel.id, storeData: _storeModel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.haveAppbar
          ? AppBar(
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
                SettingsPageString.appbarTitle,
                style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
              ),
              elevation: 0,
              actions: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _saveHandler,
                      child: Container(
                        color: Colors.transparent,
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
            )
          : null,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            child: Column(
              children: [
                _listPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listPanel() {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            title: Text(
              "Notifications",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            ),
            trailing: Switch(
              value: _storeModel.settings!["notification"],
              onChanged: (value) {
                setState(() {
                  _storeModel.settings!["notification"] = value;
                });
              },
            ),
            onTap: () {},
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          ListTile(
            dense: true,
            title: Text(
              "Bargain Enable",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            ),
            trailing: Switch(
              value: _storeModel.settings!["bargainEnable"],
              onChanged: (value) {
                setState(() {
                  _storeModel.settings!["bargainEnable"] = value;
                });
              },
            ),
            onTap: () {},
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          ListTile(
            dense: true,
            title: Text(
              "Bargain Offer Price\nNot Less Than",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KeicyTextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  width: widthDp * 100,
                  height: heightDp * 35,
                  border: Border.all(color: Colors.grey.withOpacity(0.0)),
                  errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  fillColor: Colors.grey.withOpacity(0.3),
                  borderRadius: heightDp * 0,
                  textStyle: TextStyle(fontSize: fontSp * 16),
                  keyboardType: TextInputType.number,
                  errorStringFontSize: fontSp * 0,
                  suffixIcons: [
                    Text(
                      " %",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                  ],
                  onChangeHandler: (input) {
                    try {
                      if (input.isNotEmpty) {
                        setState(() {
                          _storeModel.settings!["bargainOfferPricePercent"] = double.parse(input);
                        });
                      }
                    } catch (e) {}
                  },
                  validatorHandler: (input) => _storeModel.settings!["bargainEnable"] && input.isEmpty
                      ? "Enter a value"
                      : _storeModel.settings!["bargainEnable"] && double.parse(input) >= 100
                          ? "Enter value less than 100"
                          : null,
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          SizedBox(height: heightDp * 20),
          Center(
            child: Text(
              "Print Configuration",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            ),
          ),
          SizedBox(height: heightDp * 10),
          Column(
            children: List.generate(_storeModel.settings!["posInfo"].length, (index) {
              String initialName = "";
              String initialIp = "";
              String initialPort = "";
              if (_storeModel.settings!["posInfo"][index].isEmpty) {
                _storeModel.settings!["posInfo"][index] = Map<String, dynamic>();
              }
              initialName = _storeModel.settings!["posInfo"][index]["name"] ?? "";
              initialIp = _storeModel.settings!["posInfo"][index]["ipAddress"] ?? "";
              initialPort = _storeModel.settings!["posInfo"][index]["port"] ?? "";

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _storeModel.settings!["posInfo"].removeAt(index);
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                                child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        KeicyTextFormField(
                          initialValue: initialName,
                          width: double.infinity,
                          height: heightDp * 40,
                          border: Border.all(color: Colors.grey.withOpacity(0.7)),
                          errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                          contentHorizontalPadding: widthDp * 10,
                          contentVerticalPadding: heightDp * 8,
                          label: "Print Name",
                          labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          labelSpacing: heightDp * 5,
                          textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          borderRadius: heightDp * 8,
                          onChangeHandler: (input) {
                            _storeModel.settings!["posInfo"][index]["name"] = input.trim();
                          },
                          validatorHandler: (input) {
                            if (input.isEmpty) return "Please enter a name";
                            return null;
                          },
                        ),
                        SizedBox(height: heightDp * 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: KeicyTextFormField(
                                initialValue: initialIp,
                                width: double.infinity,
                                height: heightDp * 40,
                                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                                errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                                contentHorizontalPadding: widthDp * 10,
                                contentVerticalPadding: heightDp * 8,
                                label: "IP Address",
                                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                labelSpacing: heightDp * 5,
                                inputFormatters: [
                                  MaskTextInputFormatter(mask: '###.###.###.###', filter: {'#': RegExp(r'[0-9]')}),
                                ],
                                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                borderRadius: heightDp * 8,
                                keyboardType: TextInputType.number,
                                onChangeHandler: (input) {
                                  _storeModel.settings!["posInfo"][index]["ipAddress"] = input.trim();
                                },
                                validatorHandler: (input) {
                                  // if (input.length != 15) return "Please correct Ip address";
                                  if (!IpUtil.verifyIp(input)) return "PPlease Enter Correct IP Address";
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: widthDp * 10),
                            Expanded(
                              flex: 2,
                              child: KeicyTextFormField(
                                initialValue: initialPort,
                                width: double.infinity,
                                height: heightDp * 40,
                                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                                errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                                contentHorizontalPadding: widthDp * 10,
                                contentVerticalPadding: heightDp * 8,
                                label: "Port",
                                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                labelSpacing: heightDp * 5,
                                inputFormatters: [
                                  MaskTextInputFormatter(mask: '####.', filter: {'#': RegExp(r'[0-9]')}),
                                ],
                                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                borderRadius: heightDp * 8,
                                keyboardType: TextInputType.number,
                                onChangeHandler: (input) {
                                  _storeModel.settings!["posInfo"][index]["port"] = input.trim();
                                },
                                validatorHandler: (input) {
                                  if (input.length == 0) return "Please Enter Port";
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.withOpacity(0.7), height: heightDp * 20, thickness: 1),
                ],
              );
            }),
          ),
          if (_storeModel.settings!["posInfo"].length <= 5)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                KeicyRaisedButton(
                  width: widthDp * 180,
                  height: heightDp * 35,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 6,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  child: Text(
                    "+  Add Printer Config",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: () {
                    _storeModel.settings!["posInfo"].add(Map<String, dynamic>());
                    setState(() {});
                  },
                ),
                SizedBox(width: widthDp * 20),
              ],
            ),
          SizedBox(height: heightDp * 30),
        ],
      ),
    );
  }
}
