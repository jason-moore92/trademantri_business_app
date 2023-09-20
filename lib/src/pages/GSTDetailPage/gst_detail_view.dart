import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/RegisterStorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class GSTDetailView extends StatefulWidget {
  GSTDetailView({Key? key}) : super(key: key);

  @override
  _GSTDetailViewState createState() => _GSTDetailViewState();
}

class _GSTDetailViewState extends State<GSTDetailView> {
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

  TextEditingController _gstInController = TextEditingController();
  TextEditingController _panNumberController = TextEditingController();
  TextEditingController _fssaiLicenseController = TextEditingController();
  FocusNode _gstInFocusNode = FocusNode();
  FocusNode _panNumberFocusNode = FocusNode();
  FocusNode _fssaiLicenseFocusNode = FocusNode();

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

    _gstInController.text = _storeModel.gstIn ?? "";
    _panNumberController.text = _storeModel.businessPANnumber ?? "";
    _fssaiLicenseController.text = _storeModel.fssaiLicense ?? "";

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
    if (_storeModel.delivery == true) {
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
          GSTDetailPageString.appbarTitle,
          style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
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
            controller: _gstInController,
            focusNode: _gstInFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: RegisterStorePageString.gstInHint,
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.gstInHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => _storeModel.gstIn = input.trim(),
            onSaveHandler: (input) => _storeModel.gstIn = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_panNumberFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _panNumberController,
            focusNode: _panNumberFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: RegisterStorePageString.panNumberHint,
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.panNumberHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => _storeModel.businessPANnumber = input.trim(),
            onSaveHandler: (input) => _storeModel.businessPANnumber = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _fssaiLicenseController,
            focusNode: _fssaiLicenseFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: "FSSAI License Number",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: "FSSAI License Number",
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => _storeModel.fssaiLicense = input.trim(),
            onSaveHandler: (input) => _storeModel.fssaiLicense = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),
        ],
      ),
    );
  }
}
