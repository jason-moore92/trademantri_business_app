import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/RegisterStorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:google_map_location_picker/google_map_location_picker.dart';

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';
import 'package:trapp/environment.dart';

class ContactDetailView extends StatefulWidget {
  ContactDetailView({Key? key}) : super(key: key);

  @override
  _ContactDetailViewState createState() => _ContactDetailViewState();
}

class _ContactDetailViewState extends State<ContactDetailView> {
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

  StoreModel? _storeModel;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  FocusNode _mobileFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();
  FocusNode _stateFocusNode = FocusNode();
  FocusNode _zipCodeFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();

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

    _mobileController.text = _storeModel!.mobile!;
    _emailController.text = _storeModel!.email!;
    _cityController.text = _storeModel!.city!;
    _stateController.text = _storeModel!.state!;
    _zipCodeController.text = _storeModel!.zipCode!;
    _addressController.text = _storeModel!.address!;

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

    await _keicyProgressDialog!.show();
    _storeProvider!.setStoreState(_storeProvider!.storeState.update(progressState: 1), isNotifiable: false);
    _storeProvider!.updateStore(id: _storeModel!.id, storeData: _storeModel!.toJson());
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
          ContactDetailPageString.appbarTitle,
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
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
            child: Column(
              children: [
                _mainPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          ///
          KeicyTextFormField(
            controller: _mobileController,
            focusNode: _mobileFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: RegisterStorePageString.mobileHint,
            labelSpacing: heightDp * 5,
            labelStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.mobileHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            keyboardType: TextInputType.phone,
            readOnly: true,
            isImportant: true,
            onChangeHandler: (input) => _storeModel!.mobile = input.trim(),
            validatorHandler: (input) => input.isEmpty
                ? RegisterStorePageString.mobileValidate1
                : input.length != 10
                    ? RegisterStorePageString.mobileValidate2
                    : null,
            onSaveHandler: (input) => _storeModel!.mobile = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_emailFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: RegisterStorePageString.emailHint,
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.emailHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            keyboardType: TextInputType.emailAddress,
            isImportant: true,
            onChangeHandler: (input) => _storeModel!.email = input.trim(),
            validatorHandler: (input) => input.isNotEmpty && !KeicyValidators.isValidEmail(input) ? RegisterStorePageString.emailValidate : null,
            onSaveHandler: (input) => _storeModel!.email = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_cityFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          GestureDetector(
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              LocationResult? result = await showLocationPicker(
                context,
                Environment.googleApiKey!,
                initialCenter: LatLng(31.1975844, 29.9598339),
                myLocationButtonEnabled: true,
                layersButtonEnabled: true,
                // countries: ['AE', 'NG'],
              );
              if (result != null) {
                setState(() {
                  _cityController.text = result.city;
                  _stateController.text = result.state;
                  _zipCodeController.text = result.zipCode;
                  _addressController.text = result.address ?? "";
                  _storeModel!.city = result.city;
                  _storeModel!.state = result.state;
                  _storeModel!.zipCode = result.zipCode;
                  _storeModel!.address = result.address ?? "";
                  _storeModel!.location = result.latLng;
                });
              }
            },
            child: Row(
              children: [
                Text(
                  "Pick an address",
                  style: TextStyle(
                    fontSize: fontSp * 18,
                    color: config.Colors().mainColor(1),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _cityController,
            focusNode: _cityFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: RegisterStorePageString.cityHint,
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.cityHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            readOnly: true,
            isImportant: true,
            onChangeHandler: (input) => _storeModel!.city = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.cityValidate : null,
            onSaveHandler: (input) => _storeModel!.city = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_stateFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 10),
          KeicyTextFormField(
            controller: _stateController,
            focusNode: _stateFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: RegisterStorePageString.stateHint,
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.stateHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            readOnly: true,
            isImportant: true,
            onChangeHandler: (input) => _storeModel!.state = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.stateValidate : null,
            onSaveHandler: (input) => _storeModel!.state = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_zipCodeFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _zipCodeController,
            focusNode: _zipCodeFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: RegisterStorePageString.zipCodeHint,
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.zipCodeHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            keyboardType: TextInputType.number,
            readOnly: true,
            isImportant: true,
            onChangeHandler: (input) => _storeModel!.zipCode = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.zipCodeValidate : null,
            onSaveHandler: (input) => _storeModel!.zipCode = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_addressFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _addressController,
            focusNode: _addressFocusNode,
            width: double.infinity,
            height: heightDp * 80,
            label: RegisterStorePageString.addressHint,
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.addressHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            // readOnly: true,
            maxLines: null,
            textAlign: TextAlign.left,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            isImportant: true,
            onChangeHandler: (input) => _storeModel!.address = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.addressValidate : null,
            onSaveHandler: (input) => _storeModel!.address = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),
        ],
      ),
    );
  }
}
