import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import '../index.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:trapp/environment.dart';

class Panel5Widget extends StatefulWidget {
  final int? stepCount;
  final int? step;
  final int? completedStep;
  final StoreModel? storeModel;
  final Function? callback;

  Panel5Widget({
    @required this.stepCount,
    @required this.step,
    @required this.completedStep,
    @required this.storeModel,
    @required this.callback,
  });

  @override
  _Panel5WidgetState createState() => _Panel5WidgetState();
}

class _Panel5WidgetState extends State<Panel5Widget> {
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

    widget.storeModel!.mobile = widget.storeModel!.mobile ?? "";
    widget.storeModel!.email = widget.storeModel!.email ?? "";
    widget.storeModel!.city = widget.storeModel!.city ?? "";
    widget.storeModel!.state = widget.storeModel!.state ?? "";
    widget.storeModel!.zipCode = widget.storeModel!.zipCode ?? "";
    widget.storeModel!.address = widget.storeModel!.address ?? "";
    widget.storeModel!.location = widget.storeModel!.location ?? null;

    _mobileController.text = widget.storeModel!.mobile!;
    _emailController.text = widget.storeModel!.email!;
    _cityController.text = widget.storeModel!.city!;
    _stateController.text = widget.storeModel!.state!;
    _zipCodeController.text = widget.storeModel!.zipCode!;
    _addressController.text = widget.storeModel!.address!;

    if (Environment.enableFBEvents!) {
      getFBAppEvents().logViewContent(
        type: "sub_page",
        id: "register_step5",
        content: {
          "version": "3.0.1",
        },
        currency: "INR",
        price: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            width: deviceWidth,
            height: deviceHeight - statusbarHeight - appbarHeight,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
            color: Colors.transparent,
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  HeaderWidget(
                    stepCount: widget.stepCount,
                    step: widget.step,
                    completedStep: widget.completedStep,
                    callback: (step) {
                      widget.callback!(step);
                    },
                  ),
                  Expanded(child: _mainPanel()),
                  NextButtonWidget(
                    step: widget.step,
                    storeModel: widget.storeModel,
                    isNextPossible: true,
                    callback: () {
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
                      widget.callback!(widget.step! + 1);
                    },
                  ),
                  SizedBox(height: heightDp * 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: heightDp * 20),

          ///
          KeicyTextFormField(
            controller: _mobileController,
            focusNode: _mobileFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.mobileHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            keyboardType: TextInputType.phone,
            onChangeHandler: (input) => widget.storeModel!.mobile = input.trim(),
            validatorHandler: (input) => input.isEmpty
                ? RegisterStorePageString.mobileValidate1
                : input.length != 10
                    ? RegisterStorePageString.mobileValidate2
                    : null,
            onSaveHandler: (input) => widget.storeModel!.mobile = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_emailFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.emailHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            keyboardType: TextInputType.emailAddress,
            onChangeHandler: (input) => widget.storeModel!.email = input.trim(),
            validatorHandler: (input) => !KeicyValidators.isValidEmail(input) ? RegisterStorePageString.emailValidate : null,
            onSaveHandler: (input) => widget.storeModel!.email = input.trim(),
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
                initialCenter: LatLng(22.70955573473137, 77.63422456256123),
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
                  widget.storeModel!.city = result.city;
                  widget.storeModel!.state = result.state;
                  widget.storeModel!.zipCode = result.zipCode;
                  widget.storeModel!.location = result.latLng;
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
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.cityHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            readOnly: true,
            onChangeHandler: (input) => widget.storeModel!.city = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.cityValidate : null,
            onSaveHandler: (input) => widget.storeModel!.city = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_stateFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 10),
          KeicyTextFormField(
            controller: _stateController,
            focusNode: _stateFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.stateHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            readOnly: true,
            onChangeHandler: (input) => widget.storeModel!.state = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.stateValidate : null,
            onSaveHandler: (input) => widget.storeModel!.state = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_zipCodeFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _zipCodeController,
            focusNode: _zipCodeFocusNode,
            width: double.infinity,
            height: heightDp * 40,
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
            onChangeHandler: (input) => widget.storeModel!.zipCode = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.zipCodeValidate : null,
            onSaveHandler: (input) => widget.storeModel!.zipCode = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_addressFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _addressController,
            focusNode: _addressFocusNode,
            width: double.infinity,
            height: heightDp * 80,
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
            onChangeHandler: (input) => widget.storeModel!.address = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.addressValidate : null,
            onSaveHandler: (input) => widget.storeModel!.address = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),

          ///
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }
}
