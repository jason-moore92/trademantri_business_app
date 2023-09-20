import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import '../../elements/keicy_progress_dialog.dart';

class StoreJobPostingDetailView extends StatefulWidget {
  final bool? isNew;
  final Map<String, dynamic>? jobPostingData;

  StoreJobPostingDetailView({Key? key, this.isNew, this.jobPostingData}) : super(key: key);

  @override
  _StoreJobPostingDetailViewState createState() => _StoreJobPostingDetailViewState();
}

class _StoreJobPostingDetailViewState extends State<StoreJobPostingDetailView> with SingleTickerProviderStateMixin {
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
  TextEditingController _peopleNumberController = TextEditingController();
  TextEditingController _minYearExperienceController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _salaryFromController = TextEditingController();
  TextEditingController _salaryToController = TextEditingController();
  TextEditingController _benefitsController = TextEditingController();
  TextEditingController _skillController = TextEditingController();

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _peopleNumberFocusNode = FocusNode();
  FocusNode _minYearExperienceFocusNode = FocusNode();
  FocusNode _startFocusNode = FocusNode();
  FocusNode _endDateFocusNode = FocusNode();
  FocusNode _salaryFromFocusNode = FocusNode();
  FocusNode _salaryToFocusNode = FocusNode();
  FocusNode _statusFocusNode = FocusNode();
  FocusNode _benefitsFocusNode = FocusNode();
  FocusNode _skillFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Map<String, dynamic>? _jobPostData;

  bool? _isNew;
  Map<String, dynamic> _isUpdatedData = {
    "isUpdated": false,
  };

  DateTime? _startDate;
  DateTime? _endDate;

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

    _jobPostData = Map<String, dynamic>();

    _isNew = widget.isNew;

    if (_isNew!) {
      _jobPostData!["jobType"] = "Full Time";
      _jobPostData!["listonline"] = true;
      _jobPostData!["skills"] = [];
      _jobPostData!["status"] = AppConfig.jobStatusType.first["value"];
    } else if (!_isNew! && widget.jobPostingData!.isNotEmpty) {
      _jobPostData = json.decode(json.encode(widget.jobPostingData));

      _titleController.text = _jobPostData!["jobTitle"];
      _descriptionController.text = _jobPostData!["description"];
      _peopleNumberController.text = _jobPostData!["peopleNumber"];
      _minYearExperienceController.text = _jobPostData!["minYearExperience"];
      _startDate = DateTime.tryParse(_jobPostData!["startDate"])!.toLocal();
      _startDateController.text = KeicyDateTime.convertDateTimeToDateString(
        dateTime: _startDate,
        isUTC: false,
      );
      if (_jobPostData!["endDate"] != null && _jobPostData!["endDate"] != "") {
        _endDate = DateTime.tryParse(_jobPostData!["endDate"])!.toLocal();
        _endDateController.text = KeicyDateTime.convertDateTimeToDateString(
          dateTime: _endDate,
          isUTC: false,
        );
      }
      _salaryFromController.text = _jobPostData!["salaryFrom"];
      _salaryToController.text = _jobPostData!["salaryTo"];
      _benefitsController.text = _jobPostData!["benefits"];
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _jobPostHandler() async {
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
    _jobPostData!["storeId"] = _authProvider!.authState.storeModel!.id;

    var result;
    if (_isNew!) {
      _jobPostData!["location"] = {
        "type": "Point",
        "coordinates": [
          _authProvider!.authState.storeModel!.location!.longitude,
          _authProvider!.authState.storeModel!.location!.latitude,
        ]
      };
      result = await _storeJobPostingsProvider!.addJobPosting(jobPostData: _jobPostData);
    } else {
      _jobPostData!["location"] = {
        "type": "Point",
        "coordinates": [
          _authProvider!.authState.storeModel!.location!.longitude,
          _authProvider!.authState.storeModel!.location!.latitude,
        ]
      };
      result = await _storeJobPostingsProvider!.updateJobPosting(jobPostData: _jobPostData);
    }
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp);
      _jobPostData!["_id"] = result["data"]["_id"];
      _isNew = false;
      _isUpdatedData = {
        "isUpdated": true,
        "jobPostingData": _jobPostData,
      };
      setState(() {});
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
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
            _isNew! ? "New Job Posting" : "Edit Job Posting",
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
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///
                    KeicyTextFormField(
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
                      label: "Job Title",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      hintText: "Job Title",
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      validatorHandler: (input) => input.isEmpty ? "Please enter job title" : null,
                      onSaveHandler: (input) => _jobPostData!["jobTitle"] = input.trim(),
                      onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    KeicyTextFormField(
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
                      label: "Job Description",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      hintText: "Job Description",
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      validatorHandler: (input) => input.isEmpty ? "Please enter job description" : null,
                      onSaveHandler: (input) => _jobPostData!["description"] = input.trim(),
                      onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_peopleNumberFocusNode),
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    KeicyTextFormField(
                      controller: _peopleNumberController,
                      focusNode: _peopleNumberFocusNode,
                      width: double.infinity,
                      height: heightDp * 40,
                      border: Border.all(color: Colors.grey.withOpacity(0.7)),
                      errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                      borderRadius: heightDp * 6,
                      contentHorizontalPadding: widthDp * 10,
                      contentVerticalPadding: heightDp * 8,
                      isImportant: true,
                      label: "Number Of People You need",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      hintText: "Number Of People",
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validatorHandler: (input) => input.isEmpty ? "Please enter people number" : null,
                      onSaveHandler: (input) => _jobPostData!["peopleNumber"] = input.trim(),
                      onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_minYearExperienceFocusNode),
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    KeicyTextFormField(
                      controller: _minYearExperienceController,
                      focusNode: _minYearExperienceFocusNode,
                      width: double.infinity,
                      height: heightDp * 40,
                      border: Border.all(color: Colors.grey.withOpacity(0.7)),
                      errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                      borderRadius: heightDp * 6,
                      contentHorizontalPadding: widthDp * 10,
                      contentVerticalPadding: heightDp * 8,
                      isImportant: true,
                      label: "Min Years Of Experiences",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      hintText: "Experience years",
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validatorHandler: (input) => input.isEmpty ? "Please enter min year" : null,
                      onSaveHandler: (input) => _jobPostData!["minYearExperience"] = input.trim(),
                      onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                    ),

                    ///
                    SizedBox(height: heightDp * 10),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                groupValue: _jobPostData!["jobType"],
                                value: "Full Time",
                                onChanged: (value) {
                                  _jobPostData!["jobType"] = value;
                                  setState(() {});
                                },
                              ),
                              Expanded(
                                child: Text(
                                  "Full Time",
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio(
                                groupValue: _jobPostData!["jobType"],
                                value: "Part Time",
                                onChanged: (value) {
                                  _jobPostData!["jobType"] = value;
                                  setState(() {});
                                },
                              ),
                              Expanded(
                                child: Text(
                                  "Part Time",
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    ///
                    SizedBox(height: heightDp * 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: KeicyTextFormField(
                            controller: _startDateController,
                            focusNode: _startFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            isImportant: true,
                            label: "Start Date",
                            labelSpacing: heightDp * 5,
                            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            hintText: "Start Date",
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

                              _startDateController.text = KeicyDateTime.convertDateTimeToDateString(
                                dateTime: selecteDate,
                                isUTC: false,
                              );

                              _startDate = selecteDate;

                              setState(() {});
                            },
                            validatorHandler: (input) {
                              if (input.isEmpty) {
                                return "Please enter start date";
                              }

                              if (_endDateController.text.isNotEmpty && _startDate!.isAfter(_endDate!)) {
                                return "Please enter the start date before end date";
                              }

                              return null;
                            },
                            onSaveHandler: (input) => _jobPostData!["startDate"] = _startDate!.toUtc().toIso8601String(),
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                          ),
                        ),
                        SizedBox(width: widthDp * 10),
                        Expanded(
                          child: KeicyTextFormField(
                            controller: _endDateController,
                            focusNode: _endDateFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            autovalidateMode: AutovalidateMode.disabled,
                            label: "EndDate Date",
                            labelSpacing: heightDp * 5,
                            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            hintText: "End Date",
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                            readOnly: true,
                            validatorHandler: (input) {
                              if (input.isNotEmpty && _startDate!.isAfter(_endDate!)) {
                                return "Please enter the end date after start date";
                              }

                              return null;
                            },
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

                              _endDateController.text = KeicyDateTime.convertDateTimeToDateString(
                                dateTime: selecteDate,
                                isUTC: false,
                              );

                              _endDate = selecteDate;

                              setState(() {});
                            },
                            onSaveHandler: (input) {
                              if (_endDate == null) return;
                              _jobPostData!["endDate"] = _endDate!.toUtc().toIso8601String();
                            },
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                          ),
                        ),
                      ],
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    Row(
                      children: [
                        Text(
                          "Salary",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Text("  *", style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.w600))
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: KeicyTextFormField(
                            controller: _salaryFromController,
                            focusNode: _salaryFromFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            isImportant: true,
                            labelSpacing: heightDp * 5,
                            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            hintText: "From",
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                            // errorStringFontSize: fontSp * 10,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                            validatorHandler: (input) {
                              if (input.isEmpty) return "Please enter salary";

                              if (double.parse(_salaryFromController.text.trim()) > double.parse(_salaryToController.text.trim())) {
                                return "Please enter correct salary";
                              }

                              return null;
                            },
                            onSaveHandler: (input) => _jobPostData!["salaryFrom"] = input.trim(),
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_salaryToFocusNode),
                          ),
                        ),
                        SizedBox(width: widthDp * 5),
                        Expanded(
                          child: KeicyTextFormField(
                            controller: _salaryToController,
                            focusNode: _salaryToFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            hintText: "To",
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                            // errorStringFontSize: fontSp * 10,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                            validatorHandler: (input) {
                              if (input.isEmpty) return "Please enter salary";

                              if (double.parse(_salaryFromController.text.trim()) > double.parse(_salaryToController.text.trim())) {
                                return "Please enter correct salary";
                              }

                              return null;
                            },
                            onSaveHandler: (input) => _jobPostData!["salaryTo"] = input.trim(),
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                          ),
                        ),
                        SizedBox(width: widthDp * 5),
                        Expanded(
                          child: KeicyDropDownFormField(
                            width: double.infinity,
                            height: heightDp * 40,
                            value: _jobPostData!["salaryType"],
                            menuItems: AppConfig.salaryType,
                            selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            hintText: "Type",
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                            onValidateHandler: (value) => value == null ? "Please select type" : null,
                            onChangeHandler: (value) {
                              _jobPostData!["salaryType"] = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    Row(
                      children: [
                        Text(
                          "Skills",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        Text("  *", style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.w600))
                      ],
                    ),

                    SizedBox(height: heightDp * 5),
                    Wrap(
                      spacing: widthDp * 8,
                      runSpacing: heightDp * 5,
                      children: List.generate(_jobPostData!["skills"].length, (index) {
                        if (index >= _jobPostData!["skills"].length) {
                          return KeicyTextFormField(
                            controller: _skillController,
                            focusNode: _skillFocusNode,
                            width: widthDp * 120,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            isImportant: true,
                            labelSpacing: heightDp * 5,
                            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            hintText: "skill",
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                            // errorStringFontSize: fontSp * 10,
                            validatorHandler: (input) {
                              if (_jobPostData!["skills"] == null || _jobPostData!["skills"].isEmpty) return "Please enter skill";

                              return null;
                            },
                            onFieldSubmittedHandler: (input) {
                              if (_jobPostData!["skills"] == null) _jobPostData!["skills"] = [];
                              bool isNew = true;
                              for (var i = 0; i < _jobPostData!["skills"].length; i++) {
                                if (_jobPostData!["skills"][i].toString().toLowerCase() == input.trim().toLowerCase()) {
                                  isNew = false;
                                  break;
                                }
                              }
                              if (isNew) {
                                _jobPostData!["skills"].add(input.trim());
                                _skillController.clear();
                              }
                              setState(() {});
                            },
                          );
                        } else {
                          return Container(
                            height: heightDp * 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.withOpacity(0.7)),
                              borderRadius: BorderRadius.circular(heightDp * 6),
                            ),
                            child: Wrap(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: widthDp * 10),
                                  height: heightDp * 40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _jobPostData!["skills"][index],
                                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _jobPostData!["skills"].removeAt(index);
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: heightDp * 40,
                                    padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                                    child: Icon(Icons.close, size: heightDp * 20, color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      }),
                    ),
                    SizedBox(height: heightDp * 5),
                    KeicyTextFormField(
                      controller: _skillController,
                      focusNode: _skillFocusNode,
                      width: double.infinity,
                      height: heightDp * 40,
                      border: Border.all(color: Colors.grey.withOpacity(0.7)),
                      errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                      borderRadius: heightDp * 6,
                      contentHorizontalPadding: widthDp * 10,
                      contentVerticalPadding: heightDp * 8,
                      isImportant: true,
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      hintText: "skill",
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      // errorStringFontSize: fontSp * 10,
                      validatorHandler: (input) {
                        if (_jobPostData!["skills"] == null || _jobPostData!["skills"].isEmpty) return "Please enter skill";

                        return null;
                      },
                      onFieldSubmittedHandler: (input) {
                        if (_jobPostData!["skills"] == null) _jobPostData!["skills"] = [];
                        bool isNew = true;
                        for (var i = 0; i < _jobPostData!["skills"].length; i++) {
                          if (_jobPostData!["skills"][i].toString().toLowerCase() == input.trim().toLowerCase()) {
                            isNew = false;
                            break;
                          }
                        }
                        if (isNew) {
                          _jobPostData!["skills"].add(input.trim());
                          _skillController.clear();
                        }
                        FocusScope.of(context).requestFocus(_skillFocusNode);
                        setState(() {});
                      },
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    KeicyTextFormField(
                      controller: _benefitsController,
                      focusNode: _benefitsFocusNode,
                      width: double.infinity,
                      height: heightDp * 100,
                      // maxHeight: heightDp * 100,
                      border: Border.all(color: Colors.grey.withOpacity(0.7)),
                      errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                      borderRadius: heightDp * 6,
                      contentHorizontalPadding: widthDp * 10,
                      contentVerticalPadding: heightDp * 8,
                      isImportant: true,
                      label: "Job Benefits",
                      labelSpacing: heightDp * 5,
                      labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      hintText: "Job Benefits",
                      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      validatorHandler: (input) => input.isEmpty ? "Please enter benefits" : null,
                      onSaveHandler: (input) => _jobPostData!["benefits"] = input.trim(),
                      onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                    ),

                    ///
                    if (!_isNew!)
                      Column(
                        children: [
                          SizedBox(height: heightDp * 20),
                          KeicyDropDownFormField(
                            width: double.infinity,
                            height: heightDp * 40,
                            value: _jobPostData!["status"],
                            menuItems: AppConfig.jobStatusType,
                            selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            hintText: "Status",
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                            onValidateHandler: (value) => value == null ? "Please select status" : null,
                            onChangeHandler: (value) {
                              _jobPostData!["status"] = value;
                              setState(() {});
                            },
                          ),
                        ],
                      ),

                    ///
                    SizedBox(height: heightDp * 20),
                    Row(
                      children: [
                        KeicyCheckBox(
                          iconSize: heightDp * 25,
                          iconColor: config.Colors().mainColor(1),
                          label: "List Online",
                          labelSpacing: widthDp * 10,
                          labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          value: _jobPostData!["listonline"],
                          onChangeHandler: (value) {
                            _jobPostData!["listonline"] = value;
                            setState(() {});
                          },
                          onSaveHandler: (value) => _jobPostData!["listonline"] = value,
                        ),
                      ],
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    Center(
                      child: KeicyRaisedButton(
                        width: widthDp * 150,
                        height: heightDp * 35,
                        color: config.Colors().mainColor(1),
                        borderRadius: heightDp * 6,
                        child: Text(
                          "Post Job",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                        ),
                        onPressed: _jobPostHandler,
                      ),
                    ),

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
}
