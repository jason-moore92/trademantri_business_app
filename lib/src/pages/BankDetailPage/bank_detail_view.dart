import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class BankDetailView extends StatefulWidget {
  BankDetailView({Key? key}) : super(key: key);

  @override
  _BankDetailViewState createState() => _BankDetailViewState();
}

class _BankDetailViewState extends State<BankDetailView> {
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

  StoreBankDetailProvider? _storeBankDetailProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  Map<String, dynamic>? _storeBankDetail;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController? _accountNumberController;
  TextEditingController? _routingNumberController;
  TextEditingController? _vpaDetailController;
  FocusNode? _accountNumberFocusNode = FocusNode();
  FocusNode? _routingNumberFocusNode = FocusNode();
  FocusNode? _vpaDetailFocusNode = FocusNode();

  ImagePicker picker = ImagePicker();
  File? _imageFile;

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

    _storeBankDetailProvider = StoreBankDetailProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    isInited = false;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _storeBankDetailProvider!.addListener(_storeBankDetailProviderListener);
      if (_storeBankDetailProvider!.storeBankDetailState.progressState != 2) {
        _storeBankDetailProvider!.setStoreBankDetailState(
          _storeBankDetailProvider!.storeBankDetailState.update(progressState: 1),
          isNotifiable: false,
        );
        _storeBankDetailProvider!.getStoreBankDetail(
          storeId: AuthProvider.of(context).authState.storeModel!.id,
        );
      } else {
        isInited = true;
      }
    });
  }

  @override
  void dispose() {
    _storeBankDetailProvider!.removeListener(_storeBankDetailProviderListener);
    super.dispose();
  }

  void _storeBankDetailProviderListener() async {
    if (_storeBankDetailProvider!.storeBankDetailState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_storeBankDetailProvider!.storeBankDetailState.progressState == 2 && isInited) {
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp);
    } else if (_storeBankDetailProvider!.storeBankDetailState.progressState == 2 && !isInited) {
      isInited = true;
    } else if (_storeBankDetailProvider!.storeBankDetailState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _storeBankDetailProvider!.storeBankDetailState.message!,
      );
    }
  }

  void saveHandler() async {
    await _keicyProgressDialog!.show();
    _storeBankDetailProvider!.setStoreBankDetailState(
      _storeBankDetailProvider!.storeBankDetailState.update(progressState: 1),
      isNotifiable: false,
    );

    _storeBankDetail!["storeId"] = AuthProvider.of(context).authState.storeModel!.id;
    _storeBankDetailProvider!.updateStoreBankDetail(
      storeBankDetail: _storeBankDetail,
      imageFile: _imageFile,
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
          BankDetailPageString.appbarTitle,
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
            height: deviceHeight - statusbarHeight - appbarHeight,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
            child: Consumer<StoreBankDetailProvider>(builder: (context, storeBankDetailProvider, _) {
              if (!isInited &&
                  (storeBankDetailProvider.storeBankDetailState.progressState == 0 ||
                      storeBankDetailProvider.storeBankDetailState.progressState == 1)) {
                return Center(child: CupertinoActivityIndicator());
              }

              if (!isInited && storeBankDetailProvider.storeBankDetailState.progressState == -1) {
                return ErrorPage(
                  message: storeBankDetailProvider.storeBankDetailState.message!,
                  callback: () async {
                    _storeBankDetailProvider!.setStoreBankDetailState(
                      _storeBankDetailProvider!.storeBankDetailState.update(progressState: 1),
                    );
                    _storeBankDetailProvider!.getStoreBankDetail(
                      storeId: AuthProvider.of(context).authState.storeModel!.id,
                    );
                  },
                );
              }

              _storeBankDetail = json.decode(json.encode(_storeBankDetailProvider!.storeBankDetailState.storeBankDetail));

              if (_accountNumberController == null || _routingNumberController == null || _vpaDetailController == null) {
                _accountNumberController = TextEditingController(text: _storeBankDetail!["accountNumber"] ?? "");
                _routingNumberController = TextEditingController(text: _storeBankDetail!["routingNumber"] ?? "");
                _vpaDetailController = TextEditingController(text: _storeBankDetail!["vpaDetail"] ?? "");
              }

              return _mainPanel();
            }),
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
            controller: _accountNumberController,
            focusNode: _accountNumberFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: "Account Number",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: "Account Number",
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => _storeBankDetail!["accountNumber"] = input.trim(),
            onSaveHandler: (input) => _storeBankDetail!["accountNumber"] = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_routingNumberFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _routingNumberController,
            focusNode: _routingNumberFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            label: "IFSC",
            labelSpacing: heightDp * 5,
            labelStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
            hintText: "ICICI00001",
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            borderRadius: heightDp * 8,
            onChangeHandler: (input) => _storeBankDetail!["routingNumber"] = input.trim(),
            onSaveHandler: (input) => _storeBankDetail!["routingNumber"] = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_vpaDetailFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: _vpaDetailController,
                  focusNode: _vpaDetailFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  label: "VPA Detail",
                  labelSpacing: heightDp * 5,
                  textStyle: TextStyle(fontSize: fontSp * 18, color: Colors.black),
                  hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
                  hintText: "VPA Detail",
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  borderRadius: heightDp * 8,
                  onChangeHandler: (input) => _storeBankDetail!["vpaDetail"] = input.trim(),
                  onSaveHandler: (input) => _storeBankDetail!["vpaDetail"] = input.trim(),
                  onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var status = await Permission.camera.status;
                  if (!status.isGranted) {
                    var newStatus = await Permission.camera.request();
                    if (!newStatus.isGranted) {
                      ErrorDialog.show(
                        context,
                        widthDp: widthDp,
                        heightDp: heightDp,
                        fontSp: fontSp,
                        text: "Your camera permission isn't granted",
                        isTryButton: false,
                        callBack: () {
                          Navigator.of(context).pop();
                        },
                      );
                      return;
                    }
                  }

                  NormalDialog.show(
                    context,
                    title: "Scan bank QR-code to get VPA details.",
                    callback: () async {
                      var result = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
                      if (result == "-1") return;
                      _vpaDetailController!.text = result;
                      _storeBankDetail!["vpaDetail"] = result;
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: widthDp * 10),
                  color: Colors.transparent,
                  child: Image.asset("img/qrcode_scan.png", width: heightDp * 40, height: heightDp * 40, fit: BoxFit.cover),
                ),
              ),
            ],
          ),

          ///
          // SizedBox(height: heightDp * 30),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       _storeBankDetail!["qrcodeImageUrl"] != null && _storeBankDetail!["qrcodeImageUrl"] != "" ? "Update Bank QR code" : "Add Bank QR code",
          //       style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          //     ),
          //     KeicyRaisedButton(
          //       width: widthDp * 100,
          //       height: heightDp * 35,
          //       borderRadius: heightDp * 8,
          //       color: config.Colors().mainColor(1),
          //       child: Text("Select", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
          //       onPressed: _selectOptionBottomSheet,
          //     ),
          //   ],
          // ),
          // SizedBox(height: heightDp * 20),
          // _imageFile != null
          //     ? Center(
          //         child: Image.file(
          //           _imageFile!,
          //           width: heightDp * 200,
          //           height: heightDp * 200,
          //           fit: BoxFit.cover,
          //         ),
          //       )
          //     : Text(
          //         _storeBankDetail!["qrcodeImageUrl"] ?? "",
          //         style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //         textAlign: TextAlign.center,
          //       ),
        ],
      ),
    );
  }

  void _selectOptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              Container(
                child: Container(
                  padding: EdgeInsets.all(heightDp * 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: deviceWidth,
                        padding: EdgeInsets.all(heightDp * 10.0),
                        child: Text(
                          "Choose Option",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _getAvatarImage(ImageSource.camera);
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black.withOpacity(0.7),
                                size: heightDp * 25.0,
                              ),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Camera",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _getAvatarImage(ImageSource.gallery);
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.photo, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "From Gallery",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future _getAvatarImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, maxWidth: 500, maxHeight: 500);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      FlutterLogs.logInfo(
        "bank_detail_view",
        "_getAvatarImage",
        "No image selected.",
      );
    }
  }
}
