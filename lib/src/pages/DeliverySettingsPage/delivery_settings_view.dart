import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/delivery_partner_widget.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/DeliveryPartnerListPage/index.dart';
import 'package:trapp/src/pages/RegisterStorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class DeliverySettingsView extends StatefulWidget {
  DeliverySettingsView({Key? key}) : super(key: key);

  @override
  _DeliverySettingsViewState createState() => _DeliverySettingsViewState();
}

class _DeliverySettingsViewState extends State<DeliverySettingsView> {
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

  TextEditingController? _distanceController;
  TextEditingController? _minAmountController;
  TextEditingController? _minFreeAmountController;
  FocusNode _distanceFocusNode = FocusNode();
  FocusNode _minAmountFocusNode = FocusNode();
  FocusNode _minFreeAmountFocusNode = FocusNode();

  List<TextEditingController> _fromControllers = [];
  List<TextEditingController> _toControllers = [];
  List<TextEditingController> _chargeControllers = [];

  List<dynamic> _deliverySettingItems = [
    {"value": 0, "text": "Delivery not available"},
    {"value": 1, "text": "Delivered by own"},
    {"value": 2, "text": "Delivered by partner"},
  ];

  int? _selectedDeliverySeting;

  Map<String, dynamic>? _deliveryPartnerData;

  var numFormat = NumberFormat.currency(symbol: "", name: "");

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    _authProvider = AuthProvider.of(context);
    _storeProvider = StoreProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _storeModel = StoreModel.copy(_authProvider!.authState.storeModel!);

    _storeModel.delivery = _storeModel.delivery ?? false;

    if (_storeModel.deliveryInfo == null) {
      _storeModel.deliveryInfo = DeliveryInfo.fromJson({
        "mode": _storeModel.delivery! ? "DELIVERY_BY_OWN" : "NO_DELIVERY_CHOICE",
        "deliveryDistance": 0,
        "minAmountForFreeDelivery": 0,
        "minAmountForDelivery": 0,
      });
    }

    switch (_storeModel.deliveryInfo!.mode) {
      case "NO_DELIVERY_CHOICE":
        _selectedDeliverySeting = 0;
        break;
      case "DELIVERY_BY_OWN":
        _selectedDeliverySeting = 1;
        break;
      case "DELIVERY_BY_PARTNER":
        _selectedDeliverySeting = 2;
        _deliveryPartnerData = _storeModel.deliveryInfo!.deliveryPartner;
        break;
      default:
    }

    if (_storeModel.deliveryInfo!.mode == "DELIVERY_BY_OWN") {
      if (_storeModel.deliveryInfo!.chargesForDeliveryOwn == null) _storeModel.deliveryInfo!.chargesForDeliveryOwn = [];

      if (_storeModel.deliveryInfo!.chargesForDeliveryOwn!.isEmpty) {
        _storeModel.deliveryInfo!.chargesForDeliveryOwn!.add(<String, dynamic>{
          "minKm": 0,
          "maxKm": null,
          "chargingType": null,
          "amount": null,
        });
      } else if (_storeModel.deliveryInfo!.chargesForDeliveryOwn!.last["maxKm"] !=
          double.parse(_storeModel.deliveryInfo!.deliveryDistance.toString())) {
        _storeModel.deliveryInfo!.chargesForDeliveryOwn!.add(<String, dynamic>{
          "minKm": _storeModel.deliveryInfo!.chargesForDeliveryOwn!.last["maxKm"],
          "maxKm": null,
          "chargingType": null,
          "amount": null,
        });
      }
    }

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
    _formkey.currentState!.save();

    switch (_storeModel.deliveryInfo!.mode) {
      case "NO_DELIVERY_CHOICE":
        break;
      case "DELIVERY_BY_OWN":
        if (_storeModel.deliveryInfo!.chargesForDeliveryOwn!.last["maxKm"] != double.parse(_distanceController!.text.trim())) {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "Please enter max delivery distance for last delviery charge",
          );
          return;
        }

        _storeModel.deliveryInfo = DeliveryInfo.fromJson({
          "mode": "DELIVERY_BY_OWN",
          "deliveryDistance": double.parse(_distanceController!.text.trim()),
          "minAmountForFreeDelivery": double.parse(_minFreeAmountController!.text.trim()),
          "minAmountForDelivery": double.parse(_minAmountController!.text.trim()),
          "chargesForDeliveryOwn": _storeModel.deliveryInfo!.chargesForDeliveryOwn,
        });
        break;
      case "DELIVERY_BY_PARTNER":
        _storeModel.deliveryInfo = DeliveryInfo.fromJson({
          "mode": "DELIVERY_BY_PARTNER",
          "deliveryPartnerId": _deliveryPartnerData!["_id"],
          "minAmountForDelivery": _minAmountController!.text.trim(),
        });
        break;
      default:
    }
    if (_selectedDeliverySeting == 2 && _deliveryPartnerData == null) return;

    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    _storeProvider!.setStoreState(_storeProvider!.storeState.update(progressState: 1), isNotifiable: false);
    _storeProvider!.updateStore(id: _storeModel.id, storeData: _storeModel.toJson());
  }

  @override
  Widget build(BuildContext context) {
    _fromControllers = [];
    _toControllers = [];
    _chargeControllers = [];
    for (var i = 0; i < _storeModel.deliveryInfo!.chargesForDeliveryOwn!.length; i++) {
      _fromControllers.add(
        TextEditingController(
          text: _storeModel.deliveryInfo!.chargesForDeliveryOwn![i]["minKm"] == null
              ? ""
              : numFormat.format(_storeModel.deliveryInfo!.chargesForDeliveryOwn![i]["minKm"]),
        ),
      );
      _toControllers.add(
        TextEditingController(
          text: _storeModel.deliveryInfo!.chargesForDeliveryOwn![i]["maxKm"] == null
              ? ""
              : numFormat.format(_storeModel.deliveryInfo!.chargesForDeliveryOwn![i]["maxKm"]),
        ),
      );
      _chargeControllers.add(
        TextEditingController(
          text: _storeModel.deliveryInfo!.chargesForDeliveryOwn![i]["amount"] == null
              ? ""
              : numFormat.format(_storeModel.deliveryInfo!.chargesForDeliveryOwn![i]["amount"]),
        ),
      );
    }

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
          DeliverySettingsPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
        ),
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  SaveConfirmDialog.show(context, callback: saveHandler);
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
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            padding: EdgeInsets.symmetric(vertical: heightDp * 20),
            child: Form(
              key: _formkey,
              child: _mainPanel(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: Center(
            child: Text(
              DeliverySettingsPageString.description,
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: heightDp * 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: KeicyDropDownFormField(
            width: double.infinity,
            height: heightDp * 40,
            menuItems: _deliverySettingItems,
            border: Border.all(color: Colors.grey.withOpacity(0.7)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
            borderRadius: heightDp * 8,
            label: "Mode of Delivery",
            selectedItemStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            contentHorizontalPadding: widthDp * 10,
            value: _selectedDeliverySeting,
            isImportant: true,
            onChangeHandler: (value) {
              setState(() {
                _selectedDeliverySeting = value;

                if (_distanceController != null) _distanceController!.clear();
                if (_minAmountController != null) _minAmountController!.clear();
                if (_minFreeAmountController != null) _minFreeAmountController!.clear();
                _deliveryPartnerData = null;

                if (_selectedDeliverySeting == 0) {
                  _storeModel.delivery = false;
                  _storeModel.deliveryInfo = DeliveryInfo.fromJson({
                    "mode": "NO_DELIVERY_CHOICE",
                  });
                } else if (_selectedDeliverySeting == 1) {
                  _storeModel.delivery = true;
                  _storeModel.deliveryInfo = DeliveryInfo();
                  _storeModel.deliveryInfo!.mode = "DELIVERY_BY_OWN";
                } else if (_selectedDeliverySeting == 2) {
                  _storeModel.delivery = true;
                  _storeModel.deliveryInfo = DeliveryInfo();
                  _storeModel.deliveryInfo!.mode = "DELIVERY_BY_PARTNER";
                }

                if (_storeModel.deliveryInfo!.mode == "DELIVERY_BY_OWN") {
                  if (_storeModel.deliveryInfo!.chargesForDeliveryOwn == null) _storeModel.deliveryInfo!.chargesForDeliveryOwn = [];

                  if (_storeModel.deliveryInfo!.chargesForDeliveryOwn!.isEmpty) {
                    _storeModel.deliveryInfo!.chargesForDeliveryOwn!.add(<String, dynamic>{
                      "minKm": 0,
                      "maxKm": null,
                      "chargingType": null,
                      "amount": null,
                    });
                  } else if (_storeModel.deliveryInfo!.chargesForDeliveryOwn!.last["maxKm"] !=
                      double.parse(_storeModel.deliveryInfo!.deliveryDistance.toString())) {
                    _storeModel.deliveryInfo!.chargesForDeliveryOwn!.add(<String, dynamic>{
                      "minKm": _storeModel.deliveryInfo!.chargesForDeliveryOwn!.last["maxKm"],
                      "maxKm": null,
                      "chargingType": null,
                      "amount": null,
                    });
                  }
                }
              });
            },
            onValidateHandler: (value) => value == null ? "Please choose delivery settings" : null,
            onSaveHandler: (value) => _selectedDeliverySeting = value,
          ),
        ),
        SizedBox(height: heightDp * 30),

        ///
        if (_selectedDeliverySeting == 1) _deliveredOwnPanel(),
        if (_selectedDeliverySeting == 2)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
            child: _deliveredParnterPanel(),
          ),
      ],
    );
  }

  Widget _deliveredOwnPanel() {
    _distanceController = _distanceController ??
        TextEditingController(
          text: _storeModel.deliveryInfo!.deliveryDistance != 0 ? _storeModel.deliveryInfo!.deliveryDistance.toString() : "",
        );
    _minAmountController = _minAmountController ??
        TextEditingController(
          text: _storeModel.deliveryInfo!.minAmountForDelivery != 0 ? _storeModel.deliveryInfo!.minAmountForDelivery.toString() : "",
        );
    _minFreeAmountController = _minFreeAmountController ??
        TextEditingController(
          text: _storeModel.deliveryInfo!.minAmountForFreeDelivery != 0 ? _storeModel.deliveryInfo!.minAmountForFreeDelivery.toString() : "",
        );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: KeicyTextFormField(
            controller: _distanceController,
            focusNode: _distanceFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: "Max Delivery Distance",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
            hintText: "Max Delivery Distance",
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            keyboardType: TextInputType.number,
            isImportant: true,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
            onChangeHandler: (input) => _storeModel.deliveryInfo!.deliveryDistance = double.parse(input.trim()),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.distanceValidate : null,
            onSaveHandler: (input) => _storeModel.deliveryInfo!.deliveryDistance = double.parse(input.trim()),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_minFreeAmountFocusNode),
          ),
        ),

        ///
        SizedBox(height: heightDp * 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: KeicyTextFormField(
            controller: _minFreeAmountController,
            focusNode: _minFreeAmountFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: "Minimun Order Amount For Free Delivery",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
            hintText: "Minimun Order Amount For Free Delivery",
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            keyboardType: TextInputType.number,
            isImportant: true,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
            validatorHandler: (input) {
              if (input.isEmpty) return "Please input amount";
              if (_minFreeAmountController!.text.isNotEmpty &&
                  _minAmountController!.text.isNotEmpty &&
                  _storeModel.deliveryInfo!.minAmountForFreeDelivery! < _storeModel.deliveryInfo!.minAmountForDelivery!) {
                return "Please enter less than ${_storeModel.deliveryInfo!.minAmountForDelivery}";
              }
              return null;
            },
            onChangeHandler: (input) {
              if (input.isEmpty) return null;
              _storeModel.deliveryInfo!.minAmountForFreeDelivery = double.parse(input.trim());
            },
            onSaveHandler: (input) => _storeModel.deliveryInfo!.minAmountForFreeDelivery = double.parse(input.trim()),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),
        ),

        ///
        SizedBox(height: heightDp * 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: KeicyTextFormField(
            controller: _minAmountController,
            focusNode: _minAmountFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: "Minimun Order Amount For Delivery",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
            hintText: "Minimun Order Amount For Delivery",
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            keyboardType: TextInputType.number,
            isImportant: true,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
            validatorHandler: (input) {
              if (input.isEmpty) return "Please input amount";
              if (_minFreeAmountController!.text.isNotEmpty &&
                  _minAmountController!.text.isNotEmpty &&
                  _storeModel.deliveryInfo!.minAmountForFreeDelivery! < _storeModel.deliveryInfo!.minAmountForDelivery!) {
                return "Please enter more than ${_storeModel.deliveryInfo!.minAmountForFreeDelivery}";
              }

              return null;
            },
            onChangeHandler: (input) {
              if (input.isEmpty) return null;
              _storeModel.deliveryInfo!.minAmountForDelivery = double.parse(input.trim());
            },
            onSaveHandler: (input) => _storeModel.deliveryInfo!.minAmountForDelivery = double.parse(input.trim()),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),
        ),

        ///
        SizedBox(height: heightDp * 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
          child: Text("Charges Per Delivery", style: TextStyle(fontSize: fontSp * 18)),
        ),

        ///
        SizedBox(height: heightDp * 20),
        Column(
          children: List.generate(_storeModel.deliveryInfo!.chargesForDeliveryOwn!.length, (index) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (index != 0)
                      GestureDetector(
                        onTap: () {
                          _storeModel.deliveryInfo!.chargesForDeliveryOwn!.removeAt(index);
                          if (index < _storeModel.deliveryInfo!.chargesForDeliveryOwn!.length)
                            _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["minKm"] =
                                _storeModel.deliveryInfo!.chargesForDeliveryOwn![index - 1]["maxKm"];
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                          child: Text(
                            "Delete",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          ),
                        ),
                      )
                    else
                      SizedBox(),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: widthDp * 20),
                    Expanded(
                      child: KeicyTextFormField(
                        controller: _fromControllers[index],
                        width: double.infinity,
                        height: heightDp * 40,
                        label: "From",
                        labelSpacing: heightDp * 5,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
                        hintText: "From",
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        borderRadius: heightDp * 8,
                        keyboardType: TextInputType.number,
                        suffixIcons: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("KM", style: TextStyle(fontSize: fontSp * 14, color: Colors.black))],
                          )
                        ],
                        isImportant: true,
                        readOnly: true,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                        validatorHandler: (input) {
                          if (input.isEmpty) return "Please input amount";
                          if (_storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["minKm"] != null &&
                              _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["maxKm"] != null &&
                              _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["minKm"] >=
                                  _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["maxKm"])
                            return "Please enter value less than ${_storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["maxKm"]}";
                          return null;
                        },
                        onChangeHandler: (input) {
                          if (input.isEmpty) return;
                          _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["minKm"] = double.parse(input);
                          if (index != 0) {
                            _storeModel.deliveryInfo!.chargesForDeliveryOwn![index - 1]["maxKm"] = double.parse(input);
                            _toControllers[index - 1].text = numFormat.format(double.parse(input));
                          }
                        },
                        onSaveHandler: (input) => _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["minKm"] = double.parse(input),
                        onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
                      ),
                    ),
                    SizedBox(width: widthDp * 10),
                    Expanded(
                      child: KeicyTextFormField(
                        controller: _toControllers[index],
                        width: double.infinity,
                        height: heightDp * 40,
                        label: "To",
                        labelSpacing: heightDp * 5,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
                        hintText: "To",
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        borderRadius: heightDp * 8,
                        keyboardType: TextInputType.number,
                        isImportant: true,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                        suffixIcons: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("KM", style: TextStyle(fontSize: fontSp * 14, color: Colors.black))],
                          )
                        ],
                        validatorHandler: (input) {
                          if (input.isEmpty) return "Please input amount";
                          if (_storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["minKm"] != null &&
                              _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["maxKm"] != null &&
                              _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["minKm"] >=
                                  _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["maxKm"])
                            return "Please enter value more than ${_storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["minKm"]}";
                          return null;
                        },
                        onChangeHandler: (input) {
                          if (input.isEmpty) return;
                          _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["maxKm"] = double.parse(input);
                          if (index != _storeModel.deliveryInfo!.chargesForDeliveryOwn!.length - 1) {
                            _storeModel.deliveryInfo!.chargesForDeliveryOwn![index + 1]["minKm"] = double.parse(input);
                            _fromControllers[index + 1].text = numFormat.format(double.parse(input));
                          }
                        },
                        onSaveHandler: (input) => _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["maxKm"] = double.parse(input),
                        onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
                      ),
                    ),
                    SizedBox(width: widthDp * 20),
                  ],
                ),
                SizedBox(height: heightDp * 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: widthDp * 20),
                    Expanded(
                      child: KeicyDropDownFormField(
                        width: double.infinity,
                        height: heightDp * 40,
                        menuItems: AppConfig.deliveryChargeType,
                        border: Border.all(color: Colors.grey.withOpacity(0.7)),
                        errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                        borderRadius: heightDp * 8,
                        label: "Type",
                        selectedItemStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                        contentHorizontalPadding: widthDp * 10,
                        value: _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["chargingType"],
                        updateValueNewly: true,
                        isImportant: true,
                        onChangeHandler: (value) {
                          _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["chargingType"] = value;
                          // if (value == "Free") {
                          //   _chargeControllers[index].text = "0";
                          // }
                          setState(() {});
                        },
                        onValidateHandler: (value) => value == null ? "Please choose type" : null,
                        onSaveHandler: (value) => _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["chargingType"] = value,
                      ),
                    ),
                    SizedBox(width: widthDp * 10),
                    Expanded(
                      child: KeicyTextFormField(
                        controller: _chargeControllers[index],
                        width: double.infinity,
                        height: heightDp * 40,
                        label: "Charge",
                        labelSpacing: heightDp * 5,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
                        hintText: "Charge",
                        // enabled: _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["chargingType"] != "Free",
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        borderRadius: heightDp * 8,
                        keyboardType: TextInputType.number,
                        isImportant: true,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                        suffixIcons: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("RS", style: TextStyle(fontSize: fontSp * 14, color: Colors.black))],
                          )
                        ],
                        validatorHandler: (input) => input.isEmpty ? "Please input amount" : null,
                        onChangeHandler: (input) {
                          if (input.isEmpty) return;
                          _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["amount"] = double.parse(input);
                        },
                        onSaveHandler: (input) => _storeModel.deliveryInfo!.chargesForDeliveryOwn![index]["amount"] = double.parse(input),
                        onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
                      ),
                    ),
                    SizedBox(width: widthDp * 20),
                  ],
                ),
                Divider(height: heightDp * 30, thickness: 1, color: Colors.grey.withOpacity(0.7)),
              ],
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            KeicyRaisedButton(
              width: widthDp * 100,
              height: heightDp * 30,
              borderRadius: heightDp * 6,
              color: (_storeModel.deliveryInfo!.chargesForDeliveryOwn!.last["maxKm"] == null)
                  ? Colors.grey.withOpacity(0.7)
                  : config.Colors().mainColor(1),
              child: Text(
                "Add",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: () {
                if (_storeModel.deliveryInfo!.chargesForDeliveryOwn!.last["maxKm"] == null) return;
                _storeModel.deliveryInfo!.chargesForDeliveryOwn!.add(<String, dynamic>{
                  "minKm": _storeModel.deliveryInfo!.chargesForDeliveryOwn!.last["maxKm"],
                  "maxKm": null,
                  "chargingType": null,
                  "amount": null,
                });

                setState(() {});
              },
            ),
            SizedBox(width: widthDp * 20),
          ],
        ),
      ],
    );
  }

  Widget _deliveredParnterPanel() {
    _minAmountController = _minAmountController ??
        TextEditingController(
          text: _storeModel.deliveryInfo!.minAmountForDelivery != 0 ? _storeModel.deliveryInfo!.minAmountForDelivery.toString() : "",
        );

    return Column(
      children: [
        KeicyTextFormField(
          controller: _minAmountController,
          focusNode: _minAmountFocusNode,
          width: double.infinity,
          height: heightDp * 40,
          label: "Min Order Amount ",
          labelSpacing: heightDp * 5,
          textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.8)),
          hintText: "Min Order Amount",
          border: Border.all(color: Colors.grey.withOpacity(0.6)),
          errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
          contentHorizontalPadding: widthDp * 10,
          contentVerticalPadding: heightDp * 8,
          borderRadius: heightDp * 8,
          keyboardType: TextInputType.number,
          isImportant: true,
          validatorHandler: (input) => input.isEmpty ? "Please input amount" : null,
          onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
        ),
        SizedBox(height: heightDp * 20),
        KeicyRaisedButton(
          width: widthDp * 200,
          height: heightDp * 40,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 8,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          child: Text(
            "Pick a Delivery Partner",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          ),
          onPressed: () async {
            var result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => DeliveryPartnerListPage(),
              ),
            );
            if (result != null) {
              setState(() {
                _deliveryPartnerData = result;
              });
            }
          },
        ),
        SizedBox(height: heightDp * 20),
        if (_deliveryPartnerData != null)
          Container(
            width: deviceWidth,
            child: DeliveryPartnerWidget(
              deliveryPartnerData: _deliveryPartnerData,
              isLoading: _deliveryPartnerData!.isEmpty,
              tapHandler: null,
            ),
          )
      ],
    );
  }
}
