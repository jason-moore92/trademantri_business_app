import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import '../index.dart';
import 'package:trapp/environment.dart';

class Panel2Widget extends StatefulWidget {
  final int? stepCount;
  final int? step;
  final int? completedStep;
  final StoreModel? storeModel;
  final Function? callback;

  Panel2Widget({
    @required this.stepCount,
    @required this.step,
    @required this.completedStep,
    @required this.storeModel,
    @required this.callback,
  });

  @override
  _Panel2WidgetState createState() => _Panel2WidgetState();
}

class _Panel2WidgetState extends State<Panel2Widget> {
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
  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _ownerFirstNameController = TextEditingController();
  TextEditingController _ownerLastNameController = TextEditingController();
  TextEditingController _businessDescriptionController = TextEditingController();
  FocusNode _businessNameFocusNode = FocusNode();
  FocusNode _ownerFirstNameFocusNode = FocusNode();
  FocusNode _ownerLastNameFocusNode = FocusNode();
  FocusNode _businessDescriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    widget.storeModel!.name = widget.storeModel!.name ?? "";
    if (widget.storeModel!.profile!["ownerInfo"] == null) widget.storeModel!.profile!["ownerInfo"] = Map<String, dynamic>();
    widget.storeModel!.profile!["ownerInfo"]["firstName"] = widget.storeModel!.profile!["ownerInfo"]["firstName"] ?? "";
    widget.storeModel!.profile!["ownerInfo"]["lastName"] = widget.storeModel!.profile!["ownerInfo"]["lastName"] ?? "";
    widget.storeModel!.description = widget.storeModel!.description ?? "";

    _businessNameController.text = widget.storeModel!.name!;
    _ownerFirstNameController.text = widget.storeModel!.profile!["ownerInfo"]["firstName"];
    _ownerLastNameController.text = widget.storeModel!.profile!["ownerInfo"]["lastName"];
    _businessDescriptionController.text = widget.storeModel!.description!;

    if (Environment.enableFBEvents!) {
      getFBAppEvents().logViewContent(
        type: "sub_page",
        id: "register_step2",
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
            controller: _businessNameController,
            focusNode: _businessNameFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.businessNameHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => widget.storeModel!.name = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.businessNameValidate : null,
            onSaveHandler: (input) => widget.storeModel!.name = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_ownerFirstNameFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _ownerFirstNameController,
            focusNode: _ownerFirstNameFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.ownerFirstNameHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => widget.storeModel!.profile!["ownerInfo"]["firstName"] = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.ownerFirstNameValidate : null,
            onSaveHandler: (input) => widget.storeModel!.profile!["ownerInfo"]["firstName"] = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_ownerLastNameFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _ownerLastNameController,
            focusNode: _ownerLastNameFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.ownerLastNameHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => widget.storeModel!.profile!["ownerInfo"]["lastName"] = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.ownerLastNameValidate : null,
            onSaveHandler: (input) => widget.storeModel!.profile!["ownerInfo"]["lastName"] = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_businessDescriptionFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _businessDescriptionController,
            focusNode: _businessDescriptionFocusNode,
            width: double.infinity,
            height: heightDp * 100,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: RegisterStorePageString.businessDescHint,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            maxLines: null,
            textAlign: TextAlign.left,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            onChangeHandler: (input) => widget.storeModel!.description = input.trim(),
            validatorHandler: (input) => input.isEmpty ? RegisterStorePageString.businessDescValidate : null,
            onSaveHandler: (input) => widget.storeModel!.description = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),

          ///
          SizedBox(height: heightDp * 20),
        ],
      ),
    );
  }
}
