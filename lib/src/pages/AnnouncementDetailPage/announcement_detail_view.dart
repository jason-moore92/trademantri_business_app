import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/coupon_widget.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CouponListPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import '../../elements/keicy_progress_dialog.dart';

class AnnouncementDetailView extends StatefulWidget {
  final StoreModel? storeModel;
  final bool? isNew;
  final Map<String, dynamic>? announcementData;

  AnnouncementDetailView({Key? key, this.isNew, this.storeModel, this.announcementData}) : super(key: key);

  @override
  _AnnouncementDetailViewState createState() => _AnnouncementDetailViewState();
}

class _AnnouncementDetailViewState extends State<AnnouncementDetailView> with SingleTickerProviderStateMixin {
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
  StoreJobPostingsProvider? _storeJobPostingsProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _postedDateController = TextEditingController();

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _postedDateFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Map<String, dynamic>? _announcementData;

  ImagePicker picker = ImagePicker();
  List<File> _imageFiles = [];

  bool? _isNew;
  Map<String, dynamic> _isUpdatedData = {
    "isUpdated": false,
  };

  DateTime? _postedDate;

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

    _storeJobPostingsProvider = StoreJobPostingsProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _announcementData = Map<String, dynamic>();
    _announcementData = json.decode(json.encode(widget.announcementData));

    _isNew = widget.isNew;

    if (_isNew!) {
      _announcementData!["announcementto"] = _announcementData!["announcementto"] ?? AppConfig.announcementTo[0]["value"];
      _announcementData!["city"] = AuthProvider.of(context).authState.storeModel!.city;
      _announcementData!["location"] = AuthProvider.of(context).authState.storeModel!.location;
      _announcementData!["images"] = [];
      _announcementData!["coupon"] = [];
      _announcementData!["datetobeposted"] = DateTime.now().toUtc().toIso8601String();
      _announcementData!["active"] = true;
      _postedDateController.text = KeicyDateTime.convertDateTimeToDateString(dateTime: DateTime.now(), isUTC: false);
      _postedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    } else if (!_isNew! && widget.announcementData!.isNotEmpty) {
      _announcementData = json.decode(json.encode(widget.announcementData));

      _titleController.text = _announcementData!["title"];
      _descriptionController.text = _announcementData!["description"];

      _announcementData!["images"] = _announcementData!["images"] != null ? _announcementData!["images"] : [];

      _postedDate = DateTime.tryParse(_announcementData!["datetobeposted"])!.toLocal();
      _postedDateController.text = KeicyDateTime.convertDateTimeToDateString(
        dateTime: _postedDate,
        isUTC: false,
      );
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _jobPostHandler() async {
    try {
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

      FocusScope.of(context).requestFocus(FocusNode());

      await _keicyProgressDialog!.show();

      _announcementData!["images"] = _announcementData!["images"] ?? [];
      if (_imageFiles.isNotEmpty) {
        for (var i = 0; i < _imageFiles.length; i++) {
          var result = await UploadFileApiProvider.uploadFile(
            file: _imageFiles[i],
            fileName: DateTime.now().millisecondsSinceEpoch.toString(),
            directoryName: "announcements/",
            bucketName: "ANNOUNCEMENTS_BUCKET",
          );

          if (result["success"]) {
            _announcementData!["images"].add(result["data"]);
          }
        }
      }

      _announcementData = {
        "_id": _announcementData!["_id"],
        "title": _titleController.text.trim(),
        "description": _descriptionController.text.trim(),
        "datetobeposted": _postedDate!.toUtc().toIso8601String(),
        "images": _announcementData!["images"],
        "announcementto": _announcementData!["announcementto"],
        "storeId": _authProvider!.authState.storeModel!.id,
        "couponId": _announcementData!["coupon"].isNotEmpty ? _announcementData!["coupon"][0]["_id"] : null,
        "coupon": _announcementData!["coupon"],
        "location": _announcementData!["location"],
        "city": _announcementData!["city"],
        "active": _announcementData!["active"],
        "type": _announcementData!["coupon"].isNotEmpty ? AppConfig.announcmentType[1]["value"] : AppConfig.announcmentType[0]["value"],
      };

      var result;
      if (_isNew!) {
        result = await AnnouncementsApiProvider.addAnnouncements(announcementData: _announcementData);
      } else {
        result = await AnnouncementsApiProvider.updateAnnouncements(announcementData: _announcementData);
      }
      await _keicyProgressDialog!.hide();

      if (result["success"]) {
        SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp, callBack: () {
          Navigator.of(context).pop(_isUpdatedData);
        });
        _announcementData!["_id"] = result["data"]["_id"];
        _isNew = false;
        _isUpdatedData = {
          "isUpdated": true,
          "announcementData": _announcementData,
        };
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"],
        );
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "announcement_detail_view",
        level: LogLevel.ERROR,
        subTag: "_jobPostHandler",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_isUpdatedData);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop(_isUpdatedData);
            },
          ),
          centerTitle: true,
          title: Text(
            _isNew! ? "New Announcement" : "Edit Announcement",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();

            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceWidth,
              padding: EdgeInsets.symmetric(vertical: heightDp * 10),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: KeicyTextFormField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        width: double.infinity,
                        height: heightDp * 40,
                        border: Border.all(color: Colors.grey.withOpacity(0.7)),
                        errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                        borderRadius: heightDp * 6,
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        isImportant: true,
                        label: "Title",
                        labelSpacing: heightDp * 5,
                        labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        hintText: "title",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        validatorHandler: (input) => input.isEmpty ? "Please enter title" : null,
                        onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                        onSaveHandler: (input) => _announcementData!["title"] = input.trim(),
                        onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                      ),
                    ),

                    ///
                    Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: KeicyTextFormField(
                        controller: _descriptionController,
                        focusNode: _descriptionFocusNode,
                        width: double.infinity,
                        height: heightDp * 100,
                        // maxHeight: heightDp * 100,
                        border: Border.all(color: Colors.grey.withOpacity(0.7)),
                        errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                        borderRadius: heightDp * 6,
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        isImportant: true,
                        label: "Description",
                        labelSpacing: heightDp * 5,
                        labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        hintText: "Description",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        validatorHandler: (input) => input.isEmpty ? "Please enter description" : null,
                        onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                        onSaveHandler: (input) => _announcementData!["description"] = input.trim(),
                        onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                      ),
                    ),

                    Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: KeicyTextFormField(
                        controller: _postedDateController,
                        focusNode: _postedDateFocusNode,
                        width: double.infinity,
                        height: heightDp * 40,
                        border: Border.all(color: Colors.grey.withOpacity(0.7)),
                        errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                        borderRadius: heightDp * 6,
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        isImportant: true,
                        label: "Post Date",
                        labelSpacing: heightDp * 5,
                        labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        hintText: "Post Date",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        readOnly: true,
                        onTapHandler: () async {
                          DateTime? selecteDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
                            selectableDayPredicate: (date) {
                              if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
                              if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
                              return true;
                            },
                          );

                          if (selecteDate == null) return;

                          _postedDateController.text = KeicyDateTime.convertDateTimeToDateString(
                            dateTime: selecteDate,
                            isUTC: false,
                          );

                          _postedDate = selecteDate;

                          setState(() {});
                        },
                        validatorHandler: (input) {
                          if (input.isEmpty) {
                            return "Please enter posted date";
                          }

                          return null;
                        },
                        // onSaveHandler: (input) => _announcementData!["datetobeposted"] = _postedDate!.toUtc().toIso8601String(),
                        onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                      ),
                    ),

                    ///
                    Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: _announcementTypePanel(),
                    ),

                    ///
                    Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: _pickupLocation(),
                    ),

                    ///
                    Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: _couponListPanel(),
                    ),

                    ///
                    Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: _imagePanel(),
                    ),

                    ///
                    Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: _enabledPanel(),
                    ),

                    ///
                    Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                    _buttonPanel(),

                    ///
                    SizedBox(height: heightDp * 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _announcementTypePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Announcement",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(AppConfig.announcementTo.length, (index) {
            return Column(
              children: [
                Container(
                  height: heightDp * 35,
                  child: Row(
                    children: [
                      Radio(
                        groupValue: _announcementData!["announcementto"],
                        value: AppConfig.announcementTo[index]["value"].toString(),
                        onChanged: _announcementData!["coupon"].isNotEmpty && index != 0
                            ? null
                            : (value) {
                                _announcementData!["announcementto"] = value;
                                setState(() {});
                              },
                      ),
                      Expanded(
                        child: Text(
                          AppConfig.announcementTo[index]["text"],
                          style: TextStyle(
                            fontSize: fontSp * 16,
                            color: _announcementData!["coupon"].isNotEmpty && index != 0 ? Colors.grey.withOpacity(0.7) : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _pickupLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Location",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            KeicyCheckBox(
              iconSize: heightDp * 25,
              iconColor: config.Colors().mainColor(1),
              label: "No Spacific Location",
              labelSpacing: widthDp * 5,
              labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              value: _announcementData!["city"] == "ALL",
              onChangeHandler: (value) {
                if (value) {
                  _announcementData!["city"] = "ALL";
                  _announcementData!["location"] = null;
                } else {
                  _announcementData!["city"] = AuthProvider.of(context).authState.storeModel!.city;
                  _announcementData!["location"] = AuthProvider.of(context).authState.storeModel!.city;
                }
                setState(() {});
              },
            ),
          ],
        ),
        if (_announcementData!["city"] != "ALL") SizedBox(height: heightDp * 5),
        if (_announcementData!["city"] != "ALL")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_announcementData!["city"]}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
              KeicyRaisedButton(
                width: widthDp * 110,
                height: heightDp * 35,
                borderRadius: heightDp * 6,
                color: config.Colors().mainColor(1),
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                child: Text(
                  "Pick a city",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  LocationResult? result = await showLocationPicker(
                    context,
                    Environment.googleApiKey!,
                    initialCenter: LatLng(31.1975844, 29.9598339),
                    myLocationButtonEnabled: true,
                    layersButtonEnabled: true,
                    necessaryField: "city",
                    // countries: ['AE', 'NG'],
                  );
                  if (result != null) {
                    setState(() {
                      _announcementData!["city"] = result.city;
                      _announcementData!["location"] = {
                        "type": "Point",
                        "coordinates": [result.latLng?.longitude, result.latLng?.latitude]
                      };
                    });
                  }
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _enabledPanel() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: heightDp * 35,
            child: Row(
              children: [
                Radio(
                  groupValue: _announcementData!["active"],
                  value: true,
                  onChanged: (value) {
                    _announcementData!["active"] = value;
                    setState(() {});
                  },
                ),
                Expanded(
                  child: Text(
                    "Enabled",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: heightDp * 35,
            child: Row(
              children: [
                Radio(
                  groupValue: _announcementData!["active"],
                  value: false,
                  onChanged: (value) {
                    _announcementData!["active"] = value;
                    setState(() {});
                  },
                ),
                Expanded(
                  child: Text(
                    "Disabled",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _couponListPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Announce About A Coupon",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            KeicyRaisedButton(
              width: widthDp * 100,
              height: heightDp * 35,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              child: Text(
                "Browse",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: () async {
                CouponModel? couponModel = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CouponListPage(
                      storeModel: AuthProvider.of(context).authState.storeModel,
                      isForSelection: true,
                    ),
                  ),
                );

                if (couponModel != null) {
                  _announcementData!["coupon"] = [couponModel.toJson()];
                  _announcementData!["announcementto"] = AppConfig.announcementTo[0]["value"];
                  setState(() {});
                }
              },
            ),
          ],
        ),
        SizedBox(height: heightDp * 5),
        if (_announcementData!["coupon"].isNotEmpty)
          Center(
            child: CouponWidget(
              couponModel: CouponModel.fromJson(_announcementData!["coupon"][0]),
              storeModel: widget.storeModel,
              isLoading: _announcementData!["coupon"][0].isEmpty,
              isForView: true,
              margin: EdgeInsets.only(
                left: widthDp * 20,
                right: widthDp * 20,
                top: heightDp * 5,
                bottom: heightDp * 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _imagePanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeicyRaisedButton(
                width: widthDp * 120,
                height: heightDp * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 8,
                child: Text("Add Image", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                onPressed: _selectOptionBottomSheet,
              ),
            ],
          ),
          if (_announcementData!["images"].length != 0) SizedBox(height: heightDp * 20),
          Container(
            width: deviceWidth,
            child: Wrap(
              spacing: widthDp * 10,
              runSpacing: heightDp * 10,
              children: List.generate(_announcementData!["images"].length + _imageFiles.length, (index) {
                String url = "";
                File? imageFile;

                if (index < _announcementData!["images"].length) {
                  url = _announcementData!["images"][index];
                } else if (index >= _announcementData!["images"].length && _imageFiles.isNotEmpty) {
                  int length = _announcementData!["images"]!.length;
                  imageFile = _imageFiles[index - length];
                }

                return Column(
                  children: [
                    Container(
                      width: heightDp * 80,
                      height: heightDp * 80,
                      child: KeicyAvatarImage(
                        url: url,
                        width: heightDp * 80,
                        height: heightDp * 80,
                        imageFile: imageFile,
                        backColor: Colors.grey.withOpacity(0.6),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (index >= _announcementData!["images"].length) {
                          int length = _announcementData!["images"].length;
                          _imageFiles.removeAt(index - length);
                          setState(() {});
                        } else {
                          NormalAskDialog.show(
                            context,
                            content: "Are you sure to delete this image",
                            callback: () {
                              _announcementData!["images"].removeAt(index);
                              setState(() {});
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(heightDp * 5),
                        color: Colors.transparent,
                        child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _selectOptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Container(
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
            )
          ],
        );
      },
    );
  }

  Future _getAvatarImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, maxWidth: 500, maxHeight: 500);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
    } else {
      FlutterLogs.logInfo(
        "announcement_detail_view",
        "_getAvatarImage",
        "No image selected.",
      );
    }
  }

  Widget _buttonPanel() {
    return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
      bool isValidated = true;

      if (_titleController.text.trim().isEmpty) isValidated = false;
      if (_descriptionController.text.trim().isEmpty) isValidated = false;
      if (_postedDateController.text.trim().isEmpty) {
        isValidated = false;
      }

      return Column(
        children: [
          SizedBox(height: heightDp * 20),
          Center(
            child: KeicyRaisedButton(
              width: widthDp * 150,
              height: heightDp * 35,
              color: isValidated ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.7),
              borderRadius: heightDp * 6,
              child: Text(
                "Save",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: isValidated ? _jobPostHandler : null,
            ),
          ),
        ],
      );
    });
  }
}
