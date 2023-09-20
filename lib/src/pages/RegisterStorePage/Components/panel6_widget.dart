import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/DocViewPage/index.dart';
import 'package:trapp/src/pages/LegalResourcesPage/index.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import '../index.dart';
import 'package:trapp/environment.dart';

class Panel6Widget extends StatefulWidget {
  final int? stepCount;
  final int? step;
  final int? completedStep;
  final StoreModel? storeModel;
  final Function? callback;
  final bool? referralReadOnly;

  Panel6Widget({
    @required this.stepCount,
    @required this.step,
    @required this.completedStep,
    @required this.storeModel,
    @required this.callback,
    @required this.referralReadOnly,
  });

  @override
  _Panel6WidgetState createState() => _Panel6WidgetState();
}

class _Panel6WidgetState extends State<Panel6Widget> {
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
  TextEditingController _gstInController = TextEditingController();
  TextEditingController _referralCodeController = TextEditingController();
  TextEditingController _distanceController = TextEditingController();
  FocusNode _gstInFocusNode = FocusNode();
  FocusNode _referralCodeFocusNode = FocusNode();
  FocusNode _distanceFocusNode = FocusNode();

  bool iAgree = false;

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  @override
  void initState() {
    super.initState();

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    widget.storeModel!.gstIn = widget.storeModel!.gstIn ?? "";
    widget.storeModel!.delivery = widget.storeModel!.delivery ?? false;
    widget.storeModel!.deliveryInfo = widget.storeModel!.deliveryInfo ??
        DeliveryInfo(
          mode: "NO_DELIVERY_CHOICE",
        );
    widget.storeModel!.referredBy = widget.storeModel!.referredBy ?? "";

    _gstInController.text = widget.storeModel!.gstIn ?? "";
    _referralCodeController.text = widget.storeModel!.referredBy ?? "";
    _distanceController.text = numFormat.format(widget.storeModel!.deliveryInfo!.deliveryDistance);

    if (Environment.enableFBEvents!) {
      getFBAppEvents().logViewContent(
        type: "sub_page",
        id: "register_step6",
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
                    isNextPossible: iAgree,
                    isSubmitButton: true,
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
                      widget.callback!(999);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: heightDp * 20),

          ///
          KeicyTextFormField(
            controller: _gstInController,
            focusNode: _gstInFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.gstInHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => widget.storeModel!.gstIn = input.trim(),
            onSaveHandler: (input) => widget.storeModel!.gstIn = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_referralCodeFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _referralCodeController,
            focusNode: _referralCodeFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.referralCodeHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            // readOnly: widget.storeModel!.referredBy != "",
            readOnly: widget.referralReadOnly,
            onChangeHandler: (input) => widget.storeModel!.referredBy = input.trim(),
            onSaveHandler: (input) {
              widget.storeModel!.referredBy = input.trim();
            },
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),
          SizedBox(height: heightDp * 5),
          Text("* Enter referral code (if available)", style: TextStyle(fontSize: fontSp * 14, color: Colors.black)),

          ///
          SizedBox(height: heightDp * 20),
          KeicyCheckBox(
            iconSize: heightDp * 25,
            iconColor: config.Colors().mainColor(1),
            label: RegisterStorePageString.deliveryDesc,
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            labelSpacing: widthDp * 10,
            value: widget.storeModel!.delivery!,
            onChangeHandler: (value) {
              widget.storeModel!.delivery = value;
              if (!value) {
                widget.storeModel!.distance = null;
                _distanceController.clear();
              }

              setState(() {});
            },
          ),
          SizedBox(height: heightDp * 10),
          !widget.storeModel!.delivery!
              ? SizedBox()
              : KeicyTextFormField(
                  controller: _distanceController,
                  focusNode: _distanceFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                  hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
                  hintText: RegisterStorePageString.distanceHint,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  borderRadius: heightDp * 8,
                  keyboardType: TextInputType.number,
                  suffixIcons: [
                    Text("KM"),
                  ],
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) => widget.storeModel!.deliveryInfo!.deliveryDistance = double.parse(input.trim()),
                  validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.distanceValidate : null,
                  onSaveHandler: (input) => widget.storeModel!.deliveryInfo!.deliveryDistance = double.parse(input.trim()),
                  onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
                ),

          ///
          SizedBox(height: heightDp * 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KeicyCheckBox(
                iconSize: heightDp * 25,
                iconColor: config.Colors().mainColor(1),
                value: iAgree,
                onChangeHandler: (value) {
                  iAgree = value;
                  setState(() {});
                },
              ),
              SizedBox(width: widthDp * 10),
              Text(RegisterStorePageString.terms1, style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => DocViewPage(
                        appBarTitle: LegalResourcesPageString.terms,
                        doc: AppConfig.termsDocLink,
                      ),
                    ),
                  );
                },
                child: Text(
                  RegisterStorePageString.terms2,
                  style: TextStyle(fontSize: fontSp * 16, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }
}
