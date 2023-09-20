import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class Withdraw extends StatefulWidget {
  Withdraw({Key? key}) : super(key: key);

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
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

  WithdrawProvider? _withdrawProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  Map<String, dynamic>? _settlementData;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController? _amountController;
  TextEditingController? _notesController;
  FocusNode? _amountFocusNode = FocusNode();
  FocusNode? _notesFocusNode = FocusNode();

  bool isInited = false;

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

    _withdrawProvider = WithdrawProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    isInited = true;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _withdrawProvider!.addListener(_withdrawProviderListener);
      // if (_withdrawProvider!.withdrawState.progressState != 2) {
      //   _withdrawProvider!.setWithdrawState(
      //     _withdrawProvider!.withdrawState.update(progressState: 1),
      //     isNotifiable: false,
      //   );
      //   _withdrawProvider!.getWithdraw(
      //     storeId: AuthProvider.of(context).authState.storeModel!.id,
      //   );
      // } else {
      //   isInited = true;
      // }
    });
  }

  @override
  void dispose() {
    _withdrawProvider!.removeListener(_withdrawProviderListener);
    super.dispose();
  }

  void _withdrawProviderListener() async {
    if (_withdrawProvider!.withdrawState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_withdrawProvider!.withdrawState.progressState == 2 && isInited) {
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp);
    } else if (_withdrawProvider!.withdrawState.progressState == 2 && !isInited) {
      isInited = true;
    } else if (_withdrawProvider!.withdrawState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _withdrawProvider!.withdrawState.message!,
      );
    }
  }

  void saveHandler() async {
    await _keicyProgressDialog!.show();
    _withdrawProvider!.setWithdrawState(
      _withdrawProvider!.withdrawState.update(progressState: 1),
      isNotifiable: false,
    );

    _settlementData!["storeId"] = AuthProvider.of(context).authState.storeModel!.id;
    _withdrawProvider!.withdraw(
      amount: _settlementData!["amount"],
      notes: _settlementData!["notes"],
      storeId: AuthProvider.of(context).authState.storeModel!.id,
    );
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
          "Withdraw money",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
        ),
        elevation: 0,
        actions: [
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         SaveConfirmDialog.show(context, callback: saveHandler);
          //       },
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
          //         child: Text(
          //           "Save",
          //           style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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
            height: deviceHeight - statusbarHeight - appbarHeight,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
            child: Consumer<WithdrawProvider>(builder: (context, withdrawProvider, _) {
              if (!isInited && (withdrawProvider.withdrawState.progressState == 0 || withdrawProvider.withdrawState.progressState == 1)) {
                return Center(child: CupertinoActivityIndicator());
              }

              if (!isInited && withdrawProvider.withdrawState.progressState == -1) {
                return ErrorPage(
                  message: withdrawProvider.withdrawState.message!,
                  callback: () async {},
                );
              }

              _settlementData = json.decode(json.encode(_withdrawProvider!.withdrawState.settlementData));

              if (_amountController == null || _notesController == null) {
                _amountController = TextEditingController(text: _settlementData!["amount"] ?? "");
                _notesController = TextEditingController(text: _settlementData!["notes"] ?? "");
              }

              return _mainPanel();
            }),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.red,
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
            controller: _amountController,
            focusNode: _amountFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: "Amount",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: "Amount",
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => _settlementData!["amount"] = input.trim(),
            onSaveHandler: (input) => _settlementData!["amount"] = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_notesFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _notesController,
            focusNode: _notesFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: "Notes",
            labelSpacing: heightDp * 5,
            labelStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: "Notes",
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            maxLines: 5,
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => _settlementData!["notes"] = input.trim(),
            onSaveHandler: (input) => _settlementData!["notes"] = input.trim(),
            // onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_vpaDetailFocusNode),
          ),
        ],
      ),
    );
  }
}
