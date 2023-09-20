import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/environment.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

class YourDetailPanel extends StatefulWidget {
  YourDetailPanel({Key? key}) : super(key: key);

  @override
  _YourDetailPanelState createState() => _YourDetailPanelState();
}

class _YourDetailPanelState extends State<YourDetailPanel> with SingleTickerProviderStateMixin {
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

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  TextEditingController _aboutUsController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();

  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _captionFocusNode = FocusNode();
  FocusNode _aboutUsFocusNode = FocusNode();
  FocusNode _homeOrFlatFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _websiteFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  BusinessCardModel? _businessCardModel;

  File? _profileImage;
  File? _companyImage;

  KeicyProgressDialog? _keicyProgressDialog;

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

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _businessCardModel = BusinessCardModel.copy(AuthProvider.of(context).authState.businessCardModel!);
    _businessCardModel!.storeId = AuthProvider.of(context).authState.storeModel!.id;
    _businessCardModel!.userId = AuthProvider.of(context).authState.businessUserModel!.id;

    if (_businessCardModel!.firstname == "" || _businessCardModel!.firstname == null) {
      _businessCardModel!.firstname = AuthProvider.of(context).authState.storeModel!.profile!["ownerInfo"]["firstName"] ?? "";
    }

    if (_businessCardModel!.lastname == "" || _businessCardModel!.lastname == null) {
      _businessCardModel!.lastname = AuthProvider.of(context).authState.storeModel!.profile!["ownerInfo"]["lastName"] ?? "";
    }

    if (_businessCardModel!.businessName == "" || _businessCardModel!.businessName == null) {
      _businessCardModel!.businessName = AuthProvider.of(context).authState.storeModel!.name ?? "";
    }

    if (_businessCardModel!.address == "" || _businessCardModel!.address == null) {
      _businessCardModel!.address = AuthProvider.of(context).authState.storeModel!.address ?? "";
    }

    if (_businessCardModel!.city == "" || _businessCardModel!.city == null) {
      _businessCardModel!.city = AuthProvider.of(context).authState.storeModel!.city ?? "";
    }

    if (_businessCardModel!.phone == "" || _businessCardModel!.phone == null) {
      _businessCardModel!.phone = AuthProvider.of(context).authState.storeModel!.mobile ?? "";
    }

    if (_businessCardModel!.email == "" || _businessCardModel!.email == null) {
      _businessCardModel!.email = AuthProvider.of(context).authState.storeModel!.email ?? "";
    }

    _firstNameController.text = _businessCardModel!.firstname ?? "";
    _lastNameController.text = _businessCardModel!.lastname ?? "";
    _captionController.text = _businessCardModel!.caption ?? "";
    _aboutUsController.text = _businessCardModel!.aboutus ?? "";
    addressLine1Controller.text = _businessCardModel!.addressLine1 ?? "";
    _phoneController.text = _businessCardModel!.phone ?? "";
    _emailController.text = _businessCardModel!.email ?? "";
    _websiteController.text = _businessCardModel!.website ?? "";

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Uri dynamicUrl = await DynamicLinkService.createStoreDynamicLink(
        AuthProvider.of(context).authState.storeModel,
      );

      _businessCardModel!.website = dynamicUrl.toString(); // + "_storeId-" + AuthProvider.of(context).authState.storeModel!.id!;

      _websiteController.text = _businessCardModel!.website ?? "";
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveHandler() async {
    if (!_formkey.currentState!.validate()) return;

    _formkey.currentState!.save();

    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();

    if (_profileImage != null) {
      var result = await UploadFileApiProvider.uploadFile(
        file: _profileImage,
        directoryName: "BusinessCard/Profile/",
        fileName: _profileImage!.path.split("/").last,
        bucketName: "STORE_PROFILE_BUCKET_NAME",
      );

      if (result["success"]) {
        _businessCardModel!.profileImage = result["data"];
        _profileImage = null;
      }
    }

    if (_companyImage != null) {
      var result = await UploadFileApiProvider.uploadFile(
        file: _companyImage,
        directoryName: "BusinessCard/CompanyLogo/",
        fileName: _companyImage!.path.split("/").last,
        bucketName: "STORE_PROFILE_BUCKET_NAME",
      );

      if (result["success"]) {
        _businessCardModel!.companyLogo = result["data"];
        _companyImage = null;
      }
    }

    var result = await BusinessCardApiProvider.createOrUpdateBusinessCard(businessCardModel: _businessCardModel);

    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _businessCardModel = BusinessCardModel.fromJson(result["data"]);

      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Business Card saved successfully",
      );
      AuthProvider.of(context).setAuthState(
        AuthProvider.of(context).authState.update(
              businessCardModel: _businessCardModel,
            ),
      );
      setState(() {});
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"] ?? "Something was wrong",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Card Details",
            style: TextStyle(fontSize: fontSp * 24, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: heightDp * 10),
        Center(
          child: Text(
            "Specify details that show on your business card",
            style: TextStyle(fontSize: fontSp * 14),
            textAlign: TextAlign.center,
          ),
        ),

        ///
        SizedBox(height: heightDp * 40),
        Row(
          children: [
            Text(
              "Business Name",
              style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: widthDp * 10),
            Expanded(
              child: Text(
                "${_businessCardModel!.businessName}",
                style: TextStyle(fontSize: fontSp * 16),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          children: [
            Expanded(
              child: KeicyTextFormField(
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                label: "First Name",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey),
                hintText: "Please enter first name",
                isImportant: true,
                onChangeHandler: (input) {},
                validatorHandler: (input) => input.isEmpty ? "Please enter first name" : null,
                onSaveHandler: (input) => _businessCardModel!.firstname = input.trim(),
                onFieldSubmittedHandler: (input) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
            SizedBox(width: widthDp * 10),
            Expanded(
              child: KeicyTextFormField(
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                label: "Last Name",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey),
                hintText: "Please enter last name",
                isImportant: true,
                onChangeHandler: (input) {},
                validatorHandler: (input) => input.isEmpty ? "Please enter last name" : null,
                onSaveHandler: (input) => _businessCardModel!.lastname = input.trim(),
                onFieldSubmittedHandler: (input) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          children: [
            Expanded(
              child: KeicyTextFormField(
                controller: _captionController,
                focusNode: _captionFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                label: "Caption",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey),
                hintText: "Please enter caption",
                isImportant: true,
                onChangeHandler: (input) {},
                validatorHandler: (input) => input.isEmpty ? "Please enter caption" : null,
                onSaveHandler: (input) => _businessCardModel!.caption = input.trim(),
                onFieldSubmittedHandler: (input) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          children: [
            Expanded(
              child: KeicyTextFormField(
                controller: _aboutUsController,
                focusNode: _aboutUsFocusNode,
                width: double.infinity,
                height: heightDp * 90,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                label: "About Us",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey),
                // hintText: "Please enter string",
                hintText: "Please enter about your business here",
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                onChangeHandler: (input) {},
                onSaveHandler: (input) => _businessCardModel!.aboutus = input.trim(),
                onFieldSubmittedHandler: (input) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Address",
              style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
            ),
            KeicyRaisedButton(
              width: widthDp * 100,
              height: heightDp * 35,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              child: Text(
                "Change",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: () async {
                LocationResult? result = await showLocationPicker(
                  context,
                  Environment.googleApiKey!,
                  initialCenter: LatLng(31.1975844, 29.9598339),
                  myLocationButtonEnabled: true,
                  layersButtonEnabled: true,
                  necessaryField: "",
                  // countries: ['AE', 'NG'],
                );
                if (result != null) {
                  _businessCardModel!.address = result.address;
                  _businessCardModel!.city = result.city;
                  _businessCardModel!.location = result.latLng;
                  setState(() {});
                }
              },
            ),
          ],
        ),

        SizedBox(height: heightDp * 10),
        Row(
          children: [
            Text(
              "City :   ",
              style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
            Text(
              "${_businessCardModel!.city}",
              style: TextStyle(fontSize: fontSp * 16),
              textAlign: TextAlign.start,
            ),
          ],
        ),

        SizedBox(height: heightDp * 10),
        Text(
          "Address :   ",
          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: heightDp * 5),
        Text(
          "${_businessCardModel!.address}",
          style: TextStyle(fontSize: fontSp * 16),
          textAlign: TextAlign.start,
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          children: [
            Expanded(
              child: KeicyTextFormField(
                controller: addressLine1Controller,
                focusNode: _homeOrFlatFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                label: "Flat No / Door No / Initial",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey),
                hintText: "Please enter flat / door no",
                onChangeHandler: (input) {},
                onSaveHandler: (input) => _businessCardModel!.addressLine1 = input.trim(),
                onFieldSubmittedHandler: (input) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          children: [
            Expanded(
              child: KeicyTextFormField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                label: "Phone",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey),
                hintText: "Please enter phone",
                isImportant: true,
                onChangeHandler: (input) {},
                validatorHandler: (input) => input.isEmpty
                    ? "Please enter phone"
                    : input.length != 10
                        ? "Please enter 10 digits"
                        : null,
                onSaveHandler: (input) => _businessCardModel!.phone = input.trim(),
                onFieldSubmittedHandler: (input) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          children: [
            Expanded(
              child: KeicyTextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                label: "Email",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey),
                hintText: "Please enter email",
                isImportant: true,
                onChangeHandler: (input) {},
                validatorHandler: (input) => input.isEmpty ? "Please enter email" : null,
                onSaveHandler: (input) => _businessCardModel!.email = input.trim(),
                onFieldSubmittedHandler: (input) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          children: [
            Expanded(
              child: KeicyTextFormField(
                controller: _websiteController,
                focusNode: _websiteFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                label: "Website",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey),
                hintText: "Please enter website",
                isImportant: true,
                readOnly: true,
                onChangeHandler: (input) {},
                validatorHandler: (input) => input.isEmpty ? "Please enter website" : null,
                onSaveHandler: (input) => _businessCardModel!.website = input.trim(),
                onFieldSubmittedHandler: (input) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile Image",
                  style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: heightDp * 5),
                DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: [10, 5],
                  radius: Radius.circular(widthDp * 6),
                  padding: EdgeInsets.all(widthDp * 3),
                  child: Container(
                    width: widthDp * 170,
                    height: widthDp * 170,
                    child: (_businessCardModel!.profileImage == "" && _profileImage == null)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: heightDp * 20),
                              Text(
                                "Please choose image",
                                style: TextStyle(fontSize: fontSp * 14),
                              ),
                              SizedBox(height: heightDp * 20),
                              IconButton(
                                onPressed: () {
                                  ImageFilePickDialog.show(
                                    context,
                                    callback: (List<File>? files) {
                                      setState(() {
                                        if (files != null && files.length > 0) {
                                          _profileImage = files[0];
                                        }
                                      });
                                    },
                                    allowMultiple: false,
                                  );
                                },
                                icon: Icon(Icons.add, size: heightDp * 35),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              KeicyAvatarImage(
                                url: _businessCardModel!.profileImage,
                                width: widthDp * 170,
                                height: widthDp * 170,
                                borderRadius: widthDp * 6,
                                imageFile: _profileImage,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.white,
                                  child: IconButton(
                                    onPressed: () {
                                      ImageFilePickDialog.show(
                                        context,
                                        callback: (List<File>? files) {
                                          setState(() {
                                            if (files != null && files.length > 0) {
                                              _profileImage = files[0];
                                            }
                                          });
                                        },
                                        allowMultiple: false,
                                      );
                                    },
                                    icon: Icon(Icons.add, size: heightDp * 35),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Company Logo",
                  style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: heightDp * 5),
                DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: [10, 5],
                  radius: Radius.circular(widthDp * 6),
                  padding: EdgeInsets.all(widthDp * 3),
                  child: Container(
                    width: widthDp * 170,
                    height: widthDp * 170,
                    child: (_businessCardModel!.companyLogo == "" && _companyImage == null)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: heightDp * 20),
                              Text(
                                "Please choose image",
                                style: TextStyle(fontSize: fontSp * 14),
                              ),
                              SizedBox(height: heightDp * 20),
                              IconButton(
                                onPressed: () {
                                  // ImageFilePickDialog.show(context, callback: (File? file) {
                                  //   if (file == null) return;
                                  //   setState(() {
                                  //     _companyImage = file;
                                  //   });
                                  // });

                                  ImageFilePickDialog.show(
                                    context,
                                    callback: (List<File>? files) {
                                      setState(() {
                                        if (files != null && files.length > 0) {
                                          _companyImage = files[0];
                                        }
                                      });
                                    },
                                    allowMultiple: false,
                                  );
                                },
                                icon: Icon(Icons.add, size: heightDp * 35),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              KeicyAvatarImage(
                                url: _businessCardModel!.companyLogo,
                                width: widthDp * 170,
                                height: widthDp * 170,
                                borderRadius: widthDp * 6,
                                imageFile: _companyImage,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.white,
                                  child: IconButton(
                                    onPressed: () {
                                      // ImageFilePickDialog.show(context, callback: (File? file) {
                                      //   if (file == null) return;
                                      //   setState(() {
                                      //     _companyImage = file;
                                      //   });
                                      // });

                                      ImageFilePickDialog.show(
                                        context,
                                        callback: (List<File>? files) {
                                          setState(() {
                                            if (files != null && files.length > 0) {
                                              _companyImage = files[0];
                                            }
                                          });
                                        },
                                        allowMultiple: false,
                                      );
                                    },
                                    icon: Icon(Icons.add, size: heightDp * 35),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),

        ///
        SizedBox(height: heightDp * 20),
        Center(
          child: KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 6,
            child: Text(
              "Save",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
            ),
            onPressed: _saveHandler,
          ),
        ),
      ],
    );
  }
}
