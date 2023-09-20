import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/string_helper.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class AppointmentView extends StatefulWidget {
  final AppointmentModel? appointmentModel;
  final bool? isNew;

  AppointmentView({Key? key, this.appointmentModel, this.isNew}) : super(key: key);

  @override
  _AppointmentViewState createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> with SingleTickerProviderStateMixin {
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

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _timeSlotController = TextEditingController();
  TextEditingController _usersController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _maxGestsNumController = TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _timeSlotFocusNode = FocusNode();
  FocusNode _usersFocusNode = FocusNode();
  FocusNode _startDateFocusNode = FocusNode();
  FocusNode _endDateFocusNode = FocusNode();
  FocusNode _maxGestsNumFocusNode = FocusNode();

  TextEditingController _mondayFromController = TextEditingController();
  TextEditingController _tuesdayFromController = TextEditingController();
  TextEditingController _wednesdayFromController = TextEditingController();
  TextEditingController _thursdayFromController = TextEditingController();
  TextEditingController _fridayFromController = TextEditingController();
  TextEditingController _saturdayFromController = TextEditingController();
  TextEditingController _sundayFromController = TextEditingController();

  TextEditingController _mondayToController = TextEditingController();
  TextEditingController _tuesdayToController = TextEditingController();
  TextEditingController _wednesdayToController = TextEditingController();
  TextEditingController _thursdayToController = TextEditingController();
  TextEditingController _fridayToController = TextEditingController();
  TextEditingController _saturdayToController = TextEditingController();
  TextEditingController _sundayToController = TextEditingController();

  TextEditingController _mondayBreakFromController = TextEditingController();
  TextEditingController _tuesdayBreakFromController = TextEditingController();
  TextEditingController _wednesdayBreakFromController = TextEditingController();
  TextEditingController _thursdayBreakFromController = TextEditingController();
  TextEditingController _fridayBreakFromController = TextEditingController();
  TextEditingController _saturdayBreakFromController = TextEditingController();
  TextEditingController _sundayBreakFromController = TextEditingController();

  TextEditingController _mondayBreakToController = TextEditingController();
  TextEditingController _tuesdayBreakToController = TextEditingController();
  TextEditingController _wednesdayBreakToController = TextEditingController();
  TextEditingController _thursdayBreakToController = TextEditingController();
  TextEditingController _fridayBreakToController = TextEditingController();
  TextEditingController _saturdayBreakToController = TextEditingController();
  TextEditingController _sundayBreakToController = TextEditingController();

  FocusNode _mondayFromFocusNode = FocusNode();
  FocusNode _tuesdayFromFocusNode = FocusNode();
  FocusNode _wednesdayFromFocusNode = FocusNode();
  FocusNode _thursdayFromFocusNode = FocusNode();
  FocusNode _fridayFromFocusNode = FocusNode();
  FocusNode _saturdayFromFocusNode = FocusNode();
  FocusNode _sundayFromFocusNode = FocusNode();

  FocusNode _mondayToFocusNode = FocusNode();
  FocusNode _tuesdayToFocusNode = FocusNode();
  FocusNode _wednesdayToFocusNode = FocusNode();
  FocusNode _thursdayToFocusNode = FocusNode();
  FocusNode _fridayToFocusNode = FocusNode();
  FocusNode _saturdayToFocusNode = FocusNode();
  FocusNode _sundayToFocusNode = FocusNode();

  FocusNode _mondayBreakFromFocusNode = FocusNode();
  FocusNode _tuesdayBreakFromFocusNode = FocusNode();
  FocusNode _wednesdayBreakFromFocusNode = FocusNode();
  FocusNode _thursdayBreakFromFocusNode = FocusNode();
  FocusNode _fridayBreakFromFocusNode = FocusNode();
  FocusNode _saturdayBreakFromFocusNode = FocusNode();
  FocusNode _sundayBreakFromFocusNode = FocusNode();

  FocusNode _mondayBreakToFocusNode = FocusNode();
  FocusNode _tuesdayBreakToFocusNode = FocusNode();
  FocusNode _wednesdayBreakToFocusNode = FocusNode();
  FocusNode _thursdayBreakToFocusNode = FocusNode();
  FocusNode _fridayBreakToFocusNode = FocusNode();
  FocusNode _saturdayBreakToFocusNode = FocusNode();
  FocusNode _sundayBreakToFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  AppointmentModel? _appointmentModel;

  String usersperslot = "unlimited";

  KeicyProgressDialog? _keicyProgressDialog;

  File? _imageFile;

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

    if (!widget.isNew!) {
      _appointmentModel = AppointmentModel.copy(widget.appointmentModel!);
      _nameController.text = _appointmentModel!.name ?? "";
      _descriptionController.text = _appointmentModel!.description ?? "";
      if (!AppConfig.timeSlotList.contains(_appointmentModel!.timeslot)) _timeSlotController.text = _appointmentModel!.timeslot ?? "";
      if (_appointmentModel!.usersperslot != '1' && _appointmentModel!.usersperslot != 'unlimited') {
        _usersController.text = _appointmentModel!.usersperslot ?? "";
      }
      _startDateController.text = KeicyDateTime.convertDateTimeToDateString(dateTime: _appointmentModel!.startDate, isUTC: false);
      if (_appointmentModel!.endDate != null)
        _endDateController.text = KeicyDateTime.convertDateTimeToDateString(dateTime: _appointmentModel!.endDate, isUTC: false);
      _maxGestsNumController.text = _appointmentModel!.maxNumOfGuestsPerTimeSlot!.toString();
    } else {
      _appointmentModel = AppointmentModel();
      _appointmentModel!.address = AuthProvider.of(context).authState.storeModel!.address;
      _appointmentModel!.startDate = DateTime.now();
      _startDateController.text = KeicyDateTime.convertDateTimeToDateString(dateTime: DateTime.now(), isUTC: false);
      _appointmentModel!.storeId = AuthProvider.of(context).authState.storeModel!.id;
      _maxGestsNumController.text = _appointmentModel!.maxNumOfGuestsPerTimeSlot!.toString();
    }

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveHandler() async {
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

    var result;
    await _keicyProgressDialog!.show();

    if (_imageFile != null) {
      var result = await UploadFileApiProvider.uploadFile(
        file: _imageFile,
        directoryName: "Appointment/",
        fileName: DateTime.now().millisecondsSinceEpoch.toString(),
        bucketName: "APPOINTMENT_EVENT_BUCKET",
      );

      if (result["success"]) {
        _appointmentModel!.image = result["data"];
      }
    }

    if (widget.isNew!) {
      result = await AppointmentApiProvider.addAppointment(appointmentModel: _appointmentModel);
    } else {
      result = await AppointmentApiProvider.updateAppointment(appointmentModel: _appointmentModel);
    }
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      result["data"]["store"] = _appointmentModel!.storeModel!.toJson();
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Appointment successfully uploaded",
        callBack: () {
          Navigator.pop(
            context,
            {"success": true, "data": result["data"]},
          );
        },
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"] ?? "Someting was wrong",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            widget.isNew! ? "Add Appointment" : "Edit Appointment",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                        value: _appointmentModel!.eventenable!,
                        onChanged: (value) {
                          setState(() {
                            _appointmentModel!.eventenable = value;
                          });
                        },
                      ),
                      Text(
                        "Your Event type is " + (_appointmentModel!.eventenable! ? "on" : "off"),
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: widthDp * 20),
                    ],
                  ),
                  _mainPanel(),
                  _main1Panel(),
                  SizedBox(height: heightDp * 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                    child: Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       "Image",
                        //       style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        //     ),
                        //     KeicyRaisedButton(
                        //       width: widthDp * 90,
                        //       height: heightDp * 35,
                        //       color: config.Colors().mainColor(1),
                        //       borderRadius: heightDp * 8,
                        //       child: Text(
                        //         "Add",
                        //         style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                        //       ),
                        //       onPressed: () {
                        //         ImageFilePickDialog.show(context, callback: (File? file) {
                        //           setState(() {
                        //             _imageFile = file;
                        //           });
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),

                        Column(
                          children: [
                            Text(
                              "Event Image",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: heightDp * 10),
                            DottedBorder(
                              borderType: BorderType.RRect,
                              dashPattern: [10, 5],
                              radius: Radius.circular(widthDp * 6),
                              padding: EdgeInsets.all(widthDp * 3),
                              child: Container(
                                width: widthDp * 170,
                                height: widthDp * 170,
                                child: (_appointmentModel!.image == "" && _imageFile == null)
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
                                                  if (files == null) return;
                                                  setState(() {
                                                    if (files.length > 0) {
                                                      _imageFile = files[0];
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
                                            url: _appointmentModel!.image,
                                            width: widthDp * 170,
                                            height: widthDp * 170,
                                            borderRadius: widthDp * 6,
                                            imageFile: _imageFile,
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
                                                      if (files == null) return;
                                                      setState(() {
                                                        if (files.length > 0) {
                                                          _imageFile = files[0];
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
                  ),
                  SizedBox(height: heightDp * 20),
                  KeicyRaisedButton(
                    width: widthDp * 90,
                    height: heightDp * 35,
                    color: config.Colors().mainColor(1),
                    borderRadius: heightDp * 8,
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                    ),
                    onPressed: _saveHandler,
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: Colors.black.withOpacity(0.6), height: 2, thickness: 2)),
              SizedBox(width: widthDp * 15),
              Text(
                "What event is this?",
                style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: widthDp * 15),
              Expanded(child: Divider(color: Colors.black.withOpacity(0.6), height: 2, thickness: 2)),
            ],
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red),
            borderRadius: heightDp * 6,
            textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            label: "Event name:",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            labelSpacing: heightDp * 5,
            hintText: "Event name",
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            isImportant: true,
            errorStringFontSize: fontSp * 10,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            onChangeHandler: (input) {},
            validatorHandler: (input) {
              if (input.trim().isEmpty) {
                return "Please enter event name";
              }
              return null;
            },
            onSaveHandler: (input) {
              _appointmentModel!.name = input.trim();
            },
            onEditingCompleteHandler: () {},
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _descriptionController,
            focusNode: _descriptionFocusNode,
            width: double.infinity,
            height: heightDp * 80,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red),
            borderRadius: heightDp * 6,
            textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            label: "Event Description:",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            labelSpacing: heightDp * 5,
            hintText: "Event Description",
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            errorStringFontSize: fontSp * 10,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: null,
            onChangeHandler: (input) {},
            validatorHandler: (input) {
              return null;
            },
            onSaveHandler: (input) {
              _appointmentModel!.description = input.trim();
            },
            onEditingCompleteHandler: () {},
          ),

          ///
          SizedBox(height: heightDp * 20),
          Row(
            children: [
              Text(
                "Slot Time duration(min):",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Text(
                "  *",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: heightDp * 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(AppConfig.timeSlotList.length, (index) {
              return GestureDetector(
                onTap: () {
                  if (_appointmentModel!.timeslot == AppConfig.timeSlotList[index]) return;

                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    _appointmentModel!.timeslot = AppConfig.timeSlotList[index];
                    _timeSlotController.clear();
                    _appointmentModel!.monday!.totime = "";
                    _appointmentModel!.tuesday!.totime = "";
                    _appointmentModel!.wednesday!.totime = "";
                    _appointmentModel!.thursday!.totime = "";
                    _appointmentModel!.friday!.totime = "";
                    _appointmentModel!.saturday!.totime = "";
                    _appointmentModel!.sunday!.totime = "";
                  });
                },
                child: Container(
                  width: heightDp * 50,
                  height: heightDp * 50,
                  decoration: BoxDecoration(
                    color: _appointmentModel!.timeslot == AppConfig.timeSlotList[index] ? config.Colors().mainColor(1) : Colors.transparent,
                    border: Border(
                      left: index != 0
                          ? BorderSide(color: Colors.grey, width: 0)
                          : BorderSide(
                              color: _appointmentModel!.timeslot == AppConfig.timeSlotList[index]
                                  ? config.Colors().mainColor(1)
                                  : Colors.grey.withOpacity(0.7),
                            ),
                      right: index == 0
                          ? BorderSide(color: Colors.grey, width: 0)
                          : BorderSide(
                              color: _appointmentModel!.timeslot == AppConfig.timeSlotList[index]
                                  ? config.Colors().mainColor(1)
                                  : Colors.grey.withOpacity(0.7),
                            ),
                      top: BorderSide(
                        color: _appointmentModel!.timeslot == AppConfig.timeSlotList[index]
                            ? config.Colors().mainColor(1)
                            : Colors.grey.withOpacity(0.7),
                      ),
                      bottom: BorderSide(
                        color: _appointmentModel!.timeslot == AppConfig.timeSlotList[index]
                            ? config.Colors().mainColor(1)
                            : Colors.grey.withOpacity(0.7),
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    AppConfig.timeSlotList[index],
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: _appointmentModel!.timeslot == AppConfig.timeSlotList[index] ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: heightDp * 10),
          Center(
            child: KeicyTextFormField(
              controller: _timeSlotController,
              focusNode: _timeSlotFocusNode,
              width: widthDp * 170,
              height: heightDp * 40,
              border: Border.all(color: Colors.grey.withOpacity(0.6)),
              errorBorder: Border.all(color: Colors.grey.withOpacity(0.6)),
              borderRadius: heightDp * 6,
              textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              labelSpacing: heightDp * 5,
              hintText: "Custom Min",
              hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
              errorStringFontSize: fontSp * 12,
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChangeHandler: (input) {
                if (input.isEmpty) {
                  _appointmentModel!.timeslot = "";
                } else {
                  _appointmentModel!.timeslot = input.trim();
                }
                _appointmentModel!.monday!.totime = "";
                _appointmentModel!.tuesday!.totime = "";
                _appointmentModel!.wednesday!.totime = "";
                _appointmentModel!.thursday!.totime = "";
                _appointmentModel!.friday!.totime = "";
                _appointmentModel!.saturday!.totime = "";
                _appointmentModel!.sunday!.totime = "";
                setState(() {});
              },
              textAlign: TextAlign.center,
              onTapHandler: () {
                // setState(() {
                //   _appointmentModel!.timeslot = "";
                // });
              },
              validatorHandler: (input) {
                if (_appointmentModel!.timeslot == "" && input.trim().isEmpty) {
                  return "Please select or time slot";
                }
                return null;
              },
              onSaveHandler: (input) {
                if (input.isNotEmpty) _appointmentModel!.timeslot = input.trim();
              },
              onEditingCompleteHandler: () {},
            ),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyCheckBox(
            value: _appointmentModel!.wholeday!,
            iconSize: heightDp * 25,
            iconColor: config.Colors().mainColor(1),
            labelSpacing: widthDp * 10,
            label: "Whole day",
            labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
            onChangeHandler: (value) {
              setState(() {
                _appointmentModel!.wholeday = value;
              });
            },
          ),

          ///
          SizedBox(height: heightDp * 15),
          Text(
            "How many people you would accept for the same time slot:",
            style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 10),
          Row(
            children: [
              Radio<String>(
                groupValue: usersperslot,
                value: "one",
                onChanged: (String? value) {
                  usersperslot = "one";
                  _appointmentModel!.usersperslot = "1";
                  _usersController.clear();
                  setState(() {});
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    usersperslot = "one";
                    _appointmentModel!.usersperslot = "1";
                    _usersController.clear();
                    setState(() {});
                  },
                  child: Text(
                    "One",
                    style: TextStyle(fontSize: fontSp * 16),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                groupValue: usersperslot,
                value: "specific",
                onChanged: (String? value) {
                  usersperslot = "specific";
                  _appointmentModel!.usersperslot = "specific";
                  _usersController.clear();
                  setState(() {});
                },
              ),
              GestureDetector(
                onTap: () {
                  usersperslot = "specific";
                  _appointmentModel!.usersperslot = "specific";
                  _usersController.clear();
                  setState(() {});
                },
                child: Text(
                  "Specific number",
                  style: TextStyle(fontSize: fontSp * 16),
                ),
              ),
              SizedBox(width: widthDp * 15),
              Expanded(
                child: KeicyTextFormField(
                  controller: _usersController,
                  focusNode: _usersFocusNode,
                  width: double.infinity,
                  height: heightDp * 35,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "users",
                  hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  readOnly: usersperslot != "specific",
                  onChangeHandler: (input) {},
                  onTapHandler: () {
                    setState(() {
                      _appointmentModel!.usersperslot = "";
                    });
                  },
                  validatorHandler: (input) {
                    if (usersperslot == "specific" && input.trim().isEmpty) {
                      return "Please input users";
                    }
                    return null;
                  },
                  onSaveHandler: (input) {
                    if (input.isNotEmpty && usersperslot == "specific") _appointmentModel!.usersperslot = input.trim();
                  },
                  onEditingCompleteHandler: () {},
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                groupValue: usersperslot,
                value: "unlimited",
                onChanged: (String? value) {
                  usersperslot = "unlimited";
                  _appointmentModel!.usersperslot = "unlimited";
                  _usersController.clear();
                  setState(() {});
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    usersperslot = "unlimited";
                    _appointmentModel!.usersperslot = "unlimited";
                    _usersController.clear();
                    setState(() {});
                  },
                  child: Text(
                    "Unlimited",
                    style: TextStyle(fontSize: fontSp * 16),
                  ),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Switch(
                value: _appointmentModel!.autoAccept!,
                onChanged: (value) {
                  setState(() {
                    _appointmentModel!.autoAccept = value;
                  });
                },
              ),
              SizedBox(width: widthDp * 5),
              Text(
                "Auto accept bookings of this event",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _maxGestsNumController,
            focusNode: _maxGestsNumFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red),
            borderRadius: heightDp * 6,
            textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            label: "Maximum number of guests per time slot",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            labelSpacing: heightDp * 5,
            hintText: "max number",
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            errorStringFontSize: fontSp * 10,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChangeHandler: (input) {},
            validatorHandler: (input) {
              if (input.trim().isEmpty) {
                return "Please enter number";
              }
              if (int.parse(input.trim()) < 0) {
                return "Please enter number more than 0";
              }

              return null;
            },
            onSaveHandler: (input) {
              _appointmentModel!.maxNumOfGuestsPerTimeSlot = int.parse(input.trim());
            },
            onEditingCompleteHandler: () {},
          ),

          ///
          SizedBox(height: heightDp * 15),
          Text(
            "Location:",
            style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${_appointmentModel!.address}",
                  style: TextStyle(fontSize: fontSp * 14),
                ),
              ),
              KeicyRaisedButton(
                width: widthDp * 100,
                height: heightDp * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 8,
                child: Text(
                  "Change",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
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
                    setState(() {
                      _appointmentModel!.address = result.address;
                      _appointmentModel!.storeAddress = false;
                    });
                  }
                },
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: _startDateController,
                  focusNode: _startDateFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  label: "Start Date:",
                  labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  labelSpacing: heightDp * 5,
                  hintText: "Start Date",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  isImportant: true,
                  readOnly: true,
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  onTapHandler: () async {
                    DateTime? dateTime = await _selectPickupDateTimeHandler();
                    if (dateTime != null) {
                      _appointmentModel!.startDate = dateTime;
                      _startDateController.text = KeicyDateTime.convertDateTimeToDateString(dateTime: dateTime, isUTC: false);
                      setState(() {});
                    }
                  },
                  validatorHandler: (input) {
                    if (input.isEmpty) return "Please enter start date";

                    if (_appointmentModel!.startDate != null &&
                        _appointmentModel!.endDate != null &&
                        _appointmentModel!.endDate!.difference(_appointmentModel!.startDate!).inSeconds <= 0) {
                      return "Please enter correct date";
                    }

                    return null;
                  },
                  onSaveHandler: (input) {},
                  onEditingCompleteHandler: () {},
                ),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: KeicyTextFormField(
                  controller: _endDateController,
                  focusNode: _endDateFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  label: "End Date:",
                  labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  labelSpacing: heightDp * 5,
                  hintText: "End Date",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  readOnly: true,
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  onTapHandler: () async {
                    DateTime? dateTime = await _selectPickupDateTimeHandler();
                    if (dateTime != null) {
                      _appointmentModel!.endDate = dateTime;
                      _endDateController.text = KeicyDateTime.convertDateTimeToDateString(dateTime: dateTime, isUTC: false);
                      setState(() {});
                    }
                  },
                  validatorHandler: (input) {
                    if (_appointmentModel!.startDate != null &&
                        _appointmentModel!.endDate != null &&
                        _appointmentModel!.endDate!.difference(_appointmentModel!.startDate!).inSeconds <= 0) {
                      return "Please enter correct date";
                    }

                    return null;
                  },
                  onSaveHandler: (input) {},
                  onEditingCompleteHandler: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _selectPickupDateTimeHandler() async {
    DateTime? selecteDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
      selectableDayPredicate: (date) {
        if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
        if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
        return true;
      },
    );
    return selecteDate;
  }

  Widget _main1Panel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: Colors.black.withOpacity(0.6), height: 2, thickness: 2)),
              SizedBox(width: widthDp * 15),
              Text(
                "When can people book this event?",
                style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: widthDp * 15),
              Expanded(child: Divider(color: Colors.black.withOpacity(0.6), height: 2, thickness: 2)),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          _weekWidget("monday"),

          ///
          SizedBox(height: heightDp * 15),
          _weekWidget("tuesday"),

          ///
          SizedBox(height: heightDp * 15),
          _weekWidget("wednesday"),

          ///
          SizedBox(height: heightDp * 15),
          _weekWidget("thursday"),

          ///
          SizedBox(height: heightDp * 15),
          _weekWidget("friday"),

          ///
          SizedBox(height: heightDp * 15),
          _weekWidget("saturday"),

          ///
          SizedBox(height: heightDp * 15),
          _weekWidget("sunday"),
        ],
      ),
    );
  }

  Widget _weekWidget(String week) {
    WeekModel? weekModel;
    TextEditingController? fromController = TextEditingController();
    TextEditingController? toController = TextEditingController();
    FocusNode? fromFocusNode;
    FocusNode? toFocusNode;
    TextEditingController? breakfromController = TextEditingController();
    TextEditingController? breaktoController = TextEditingController();
    FocusNode? breakfromFocusNode;
    FocusNode? breaktoFocusNode;

    switch (week) {
      case "monday":
        weekModel = _appointmentModel!.monday;
        fromController = _mondayFromController;
        toController = _mondayToController;
        fromFocusNode = _mondayFromFocusNode;
        toFocusNode = _mondayToFocusNode;

        breakfromController = _mondayBreakFromController;
        breaktoController = _mondayBreakToController;
        breakfromFocusNode = _mondayBreakFromFocusNode;
        breaktoFocusNode = _mondayBreakToFocusNode;

        break;
      case "tuesday":
        weekModel = _appointmentModel!.tuesday;
        fromController = _tuesdayFromController;
        toController = _tuesdayToController;
        fromFocusNode = _tuesdayFromFocusNode;
        toFocusNode = _tuesdayToFocusNode;

        breakfromController = _tuesdayBreakFromController;
        breaktoController = _tuesdayBreakToController;
        breakfromFocusNode = _tuesdayBreakFromFocusNode;
        breaktoFocusNode = _tuesdayBreakToFocusNode;

        break;
      case "wednesday":
        weekModel = _appointmentModel!.wednesday;
        fromController = _wednesdayFromController;
        toController = _wednesdayToController;
        fromFocusNode = _wednesdayFromFocusNode;
        toFocusNode = _wednesdayToFocusNode;

        breakfromController = _wednesdayBreakFromController;
        breaktoController = _wednesdayBreakToController;
        breakfromFocusNode = _wednesdayBreakFromFocusNode;
        breaktoFocusNode = _wednesdayBreakToFocusNode;

        break;
      case "thursday":
        weekModel = _appointmentModel!.thursday;
        fromController = _thursdayFromController;
        toController = _thursdayToController;
        fromFocusNode = _thursdayFromFocusNode;
        toFocusNode = _thursdayToFocusNode;

        breakfromController = _thursdayBreakFromController;
        breaktoController = _thursdayBreakToController;
        breakfromFocusNode = _thursdayBreakFromFocusNode;
        breaktoFocusNode = _thursdayBreakToFocusNode;

        break;
      case "friday":
        weekModel = _appointmentModel!.friday;
        fromController = _fridayFromController;
        toController = _fridayToController;
        fromFocusNode = _fridayFromFocusNode;
        toFocusNode = _fridayToFocusNode;

        breakfromController = _fridayBreakFromController;
        breaktoController = _fridayBreakToController;
        breakfromFocusNode = _fridayBreakFromFocusNode;
        breaktoFocusNode = _fridayBreakToFocusNode;

        break;
      case "saturday":
        weekModel = _appointmentModel!.saturday;
        fromController = _saturdayFromController;
        toController = _saturdayToController;
        fromFocusNode = _saturdayFromFocusNode;
        toFocusNode = _saturdayToFocusNode;

        breakfromController = _saturdayBreakFromController;
        breaktoController = _saturdayBreakToController;
        breakfromFocusNode = _saturdayBreakFromFocusNode;
        breaktoFocusNode = _saturdayBreakToFocusNode;

        break;
      case "sunday":
        weekModel = _appointmentModel!.sunday;
        fromController = _sundayFromController;
        toController = _sundayToController;
        fromFocusNode = _sundayFromFocusNode;
        toFocusNode = _sundayToFocusNode;

        breakfromController = _sundayBreakFromController;
        breaktoController = _sundayBreakToController;
        breakfromFocusNode = _sundayBreakFromFocusNode;
        breaktoFocusNode = _sundayBreakToFocusNode;

        break;
      default:
    }

    fromController.text = weekModel!.fromtime ?? "";
    toController.text = weekModel.totime ?? "";
    breakfromController.text = weekModel.breakfromtime ?? "";
    breaktoController.text = weekModel.breaktotime ?? "";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15),
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(heightDp * 8),
      ),
      child: Column(
        children: [
          KeicyCheckBox(
            value: weekModel.open!,
            iconSize: heightDp * 25,
            iconColor: config.Colors().mainColor(1),
            labelSpacing: widthDp * 10,
            label: StringHelper.getUpperCaseString(week),
            labelStyle: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
            stateChangePossible: true,
            onChangeHandler: (value) {
              if (!_appointmentModel!.wholeday! && _appointmentModel!.timeslot == "") {
                NormalDialog.show(context, content: "Please select time slot", callback: () {});
                setState(() {
                  weekModel!.open = false;
                  weekModel.haveBreak = false;
                  weekModel.fromtime = "";
                  weekModel.totime = "";
                  weekModel.breakfromtime = "";
                  weekModel.breakfromtime = "";
                  fromController!.clear();
                  toController!.clear();
                  breakfromController!.clear();
                  breaktoController!.clear();
                });
              } else {
                setState(() {
                  weekModel!.open = value;
                  weekModel.haveBreak = false;
                  weekModel.fromtime = "";
                  weekModel.totime = "";
                  weekModel.breakfromtime = "";
                  weekModel.breakfromtime = "";
                  fromController!.clear();
                  toController!.clear();
                  breakfromController!.clear();
                  breaktoController!.clear();
                });
              }
            },
          ),

          ///
          SizedBox(height: heightDp * 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: fromController,
                  focusNode: fromFocusNode,
                  width: double.infinity,
                  height: heightDp * 35,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: "From",
                  labelStyle: TextStyle(fontSize: fontSp * 16),
                  labelSpacing: heightDp * 5,
                  hintText: "00:00",
                  hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  // inputFormatters: [LookasTimeCustomFormatter()],
                  textAlign: TextAlign.center,
                  readOnly: true,
                  // onChangeHandler: (input) {
                  //   weekModel!.fromtime = input;
                  // },
                  onTapHandler: () async {
                    if (!weekModel!.open!) return;
                    TimeOfDay? timeOfDay = await _breakTimeHandler(
                      checkAvailable: false,
                    );
                    if (timeOfDay != null) {
                      DateTime dateTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        timeOfDay.hour,
                        timeOfDay.minute,
                      );

                      fromController!.text = KeicyDateTime.convertDateTimeToDateString(
                        dateTime: dateTime,
                        formats: "H:i",
                        isUTC: false,
                      );
                      weekModel.fromtime = fromController.text;
                      setState(() {});
                    }
                  },
                  validatorHandler: (input) {
                    if (!weekModel!.open!) return null;
                    if (input.isEmpty) return "Please enter time";

                    ///  from time
                    String? fromHour;
                    String? fromMin;
                    fromHour = fromController!.text.split(":").first;
                    fromMin = fromController.text.contains(":") ? input.split(":").last : "0";
                    fromMin = fromMin != "" ? fromMin : "0";
                    DateTime fromTime = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      int.parse(fromHour),
                      int.parse(fromMin),
                    );

                    ///  to time
                    if (toController!.text.isNotEmpty) {
                      String? toHour;
                      String? toMin;
                      toHour = toController.text.split(":").first;
                      toMin = toController.text.contains(":") ? input.split(":").last : "0";
                      toMin = toMin != "" ? toMin : "0";
                      DateTime toTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        int.parse(toHour),
                        int.parse(toMin),
                      );

                      ///  compare with  from and  to time
                      if (toTime.difference(fromTime).inSeconds < 0) return "Please enter correct time";
                    }

                    ///
                    fromController.text = KeicyDateTime.convertDateTimeToDateString(
                      dateTime: fromTime,
                      formats: "H:i",
                      isUTC: false,
                    );
                    weekModel.fromtime = fromController.text;

                    return null;
                  },
                  onSaveHandler: (input) {
                    weekModel!.fromtime = input;
                  },
                  onEditingCompleteHandler: () {},
                ),
              ),
              SizedBox(width: widthDp * 15),
              Expanded(
                child: KeicyTextFormField(
                  controller: toController,
                  focusNode: toFocusNode,
                  width: double.infinity,
                  height: heightDp * 35,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: "To",
                  labelStyle: TextStyle(fontSize: fontSp * 16),
                  labelSpacing: heightDp * 5,
                  hintText: "00:00",
                  hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  // inputFormatters: [LookasTimeCustomFormatter()],
                  readOnly: true,
                  // onChangeHandler: (input) {
                  //   weekModel!.totime = input;
                  // },
                  onTapHandler: () async {
                    if (!weekModel!.open!) return;
                    if (fromController!.text.isEmpty) {
                      NormalDialog.show(context, content: "Please select start time.", callback: () {});
                      return;
                    }
                    TimeOfDay? timeOfDay = await _breakTimeHandler(
                      checkAvailable: !_appointmentModel!.wholeday!,
                      startTime: weekModel.fromtime!,
                      timeSlot: _appointmentModel!.timeslot!,
                    );
                    if (timeOfDay != null) {
                      DateTime dateTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        timeOfDay.hour,
                        timeOfDay.minute,
                      );

                      toController!.text = KeicyDateTime.convertDateTimeToDateString(
                        dateTime: dateTime,
                        formats: "H:i",
                        isUTC: false,
                      );
                      weekModel.totime = toController.text;
                      setState(() {});
                    }
                  },
                  textAlign: TextAlign.center,
                  validatorHandler: (input) {
                    if (!weekModel!.open!) return null;
                    if (input.isEmpty) return "Please enter time";

                    ///  from time
                    String? fromHour;
                    String? fromMin;
                    fromHour = fromController!.text.split(":").first;
                    fromMin = fromController.text.contains(":") ? input.split(":").last : "0";
                    DateTime fromTime = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      int.parse(fromHour),
                      int.parse(fromMin),
                    );

                    ///  to time
                    String? toHour;
                    String? toMin;
                    toHour = toController!.text.split(":").first;
                    toMin = toController.text.contains(":") ? input.split(":").last : "0";
                    DateTime toTime = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      int.parse(toHour),
                      int.parse(toMin),
                    );

                    ///  compare with  from and  to time
                    if (toTime.difference(fromTime).inSeconds < 0) return "Please enter correct time";

                    toController.text = KeicyDateTime.convertDateTimeToDateString(
                      dateTime: toTime,
                      formats: "H:i",
                      isUTC: false,
                    );
                    weekModel.totime = toController.text;

                    return null;
                  },
                  onSaveHandler: (input) {
                    weekModel!.totime = input;
                  },
                  onEditingCompleteHandler: () {},
                ),
              ),
            ],
          ),

          // ///
          // SizedBox(height: heightDp * 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     KeicyRaisedButton(
          //       width: widthDp * 170,
          //       height: heightDp * 30,
          //       padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
          //       color: config.Colors().mainColor(1),
          //       borderRadius: heightDp * 8,
          //       child: Text(
          //         weekModel.haveBreak! ? "Cancel Breakdown" : "Add Breakdown",
          //         style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
          //       ),
          //       onPressed: () async {
          //         FocusScope.of(context).requestFocus(FocusNode());
          //         weekModel!.haveBreak = !weekModel.haveBreak!;
          //         weekModel.breakfromtime = "";
          //         weekModel.breaktotime = "";
          //         breakfromController!.clear();
          //         breaktoController!.clear();
          //         setState(() {});
          //       },
          //     ),
          //   ],
          // ),

          // ///
          // if (weekModel.haveBreak!) SizedBox(height: heightDp * 15),
          // if (weekModel.haveBreak!)
          //   Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Expanded(
          //         child: KeicyTextFormField(
          //           controller: breakfromController,
          //           focusNode: breakfromFocusNode,
          //           width: double.infinity,
          //           height: heightDp * 35,
          //           border: Border.all(color: Colors.grey.withOpacity(0.6)),
          //           errorBorder: Border.all(color: Colors.red),
          //           borderRadius: heightDp * 6,
          //           textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          //           label: "Break From",
          //           labelStyle: TextStyle(fontSize: fontSp * 16),
          //           labelSpacing: heightDp * 5,
          //           hintText: "00:00",
          //           hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
          //           errorStringFontSize: fontSp * 10,
          //           contentHorizontalPadding: widthDp * 10,
          //           contentVerticalPadding: heightDp * 8,
          //           keyboardType: TextInputType.number,
          //           // inputFormatters: [LookasTimeCustomFormatter()],
          //           readOnly: true,
          //           // onChangeHandler: (input) {
          //           //   weekModel!.breakfromtime = input;
          //           // },
          //           onTapHandler: () async {
          //             TimeOfDay? timeOfDay = await _breakTimeHandler();
          //             if (timeOfDay != null) {
          //               DateTime dateTime = DateTime(
          //                 DateTime.now().year,
          //                 DateTime.now().month,
          //                 DateTime.now().day,
          //                 timeOfDay.hour,
          //                 timeOfDay.minute,
          //               );

          //               breakfromController!.text = KeicyDateTime.convertDateTimeToDateString(
          //                 dateTime: dateTime,
          //                 formats: "H:i",
          //                 isUTC: false,
          //               );
          //               weekModel!.breakfromtime = breakfromController.text;
          //               setState(() {});
          //             }
          //           },
          //           textAlign: TextAlign.center,
          //           validatorHandler: (input) {
          //             if (input.isEmpty) return "Please enter time";

          //             ///  break from time
          //             String? breakfromHour;
          //             String? breakfromMin;
          //             breakfromHour = breakfromController!.text.split(":").first;
          //             breakfromMin = breakfromController.text.contains(":") ? input.split(":").last : "0";
          //             breakfromMin = breakfromMin != "" ? breakfromMin : "0";
          //             DateTime breakfromTime = DateTime(
          //               DateTime.now().year,
          //               DateTime.now().month,
          //               DateTime.now().day,
          //               int.parse(breakfromHour),
          //               int.parse(breakfromMin),
          //             );

          //             ///  break to time
          //             String? breaktoHour;
          //             String? breaktoMin;
          //             breaktoHour = breaktoController!.text.split(":").first;
          //             breaktoMin = breaktoController.text.contains(":") ? input.split(":").last : "0";
          //             breaktoMin = breaktoMin != "" ? breaktoMin : "0";
          //             DateTime breaktoTime = DateTime(
          //               DateTime.now().year,
          //               DateTime.now().month,
          //               DateTime.now().day,
          //               int.parse(breaktoHour),
          //               int.parse(breaktoMin),
          //             );

          //             ///  compare with break from and break to
          //             if (breaktoTime.difference(breakfromTime).inSeconds <= 0) return "Please enter correct time";

          //             breakfromController.text = KeicyDateTime.convertDateTimeToDateString(
          //               dateTime: breakfromTime,
          //               formats: "H:i",
          //               isUTC: false,
          //             );
          //             weekModel!.breakfromtime = breakfromController.text;

          //             ///  compare with break from and from time
          //             String? fromHour;
          //             String? fromMin;
          //             fromHour = fromController!.text.split(":").first;
          //             fromMin = fromController.text.contains(":") ? input.split(":").last : "0";
          //             fromMin = fromMin != "" ? fromMin : "0";
          //             DateTime fromTime = DateTime(
          //               DateTime.now().year,
          //               DateTime.now().month,
          //               DateTime.now().day,
          //               int.parse(fromHour),
          //               int.parse(fromMin),
          //             );

          //             if (breakfromTime.difference(fromTime).inSeconds <= 0) return "Please enter correct time";

          //             return null;
          //           },
          //           onSaveHandler: (input) {
          //             weekModel!.breakfromtime = input;
          //           },
          //           onEditingCompleteHandler: () {},
          //         ),
          //       ),
          //       SizedBox(width: widthDp * 15),
          //       Expanded(
          //         child: KeicyTextFormField(
          //           controller: breaktoController,
          //           focusNode: breaktoFocusNode,
          //           width: double.infinity,
          //           height: heightDp * 35,
          //           border: Border.all(color: Colors.grey.withOpacity(0.6)),
          //           errorBorder: Border.all(color: Colors.red),
          //           borderRadius: heightDp * 6,
          //           textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          //           label: "Break To",
          //           labelStyle: TextStyle(fontSize: fontSp * 16),
          //           labelSpacing: heightDp * 5,
          //           hintText: "00:00",
          //           hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
          //           errorStringFontSize: fontSp * 10,
          //           contentHorizontalPadding: widthDp * 10,
          //           contentVerticalPadding: heightDp * 8,
          //           keyboardType: TextInputType.number,
          //           // inputFormatters: [LookasTimeCustomFormatter()],
          //           textAlign: TextAlign.center,
          //           readOnly: true,
          //           // onChangeHandler: (input) {
          //           //   weekModel!.breaktotime = input;
          //           // },
          //           onTapHandler: () async {
          //             TimeOfDay? timeOfDay = await _breakTimeHandler();
          //             if (timeOfDay != null) {
          //               DateTime dateTime = DateTime(
          //                 DateTime.now().year,
          //                 DateTime.now().month,
          //                 DateTime.now().day,
          //                 timeOfDay.hour,
          //                 timeOfDay.minute,
          //               );

          //               breaktoController!.text = KeicyDateTime.convertDateTimeToDateString(
          //                 dateTime: dateTime,
          //                 formats: "H:i",
          //                 isUTC: false,
          //               );
          //               weekModel!.breaktotime = breaktoController.text;
          //               setState(() {});
          //             }
          //           },
          //           validatorHandler: (input) {
          //             if (input.isEmpty) return "Please enter time";

          //             ///  break from time
          //             String? breakfromHour;
          //             String? breakfromMin;
          //             breakfromHour = breakfromController!.text.split(":").first;
          //             breakfromMin = breakfromController.text.contains(":") ? input.split(":").last : "0";
          //             DateTime breakfromTime = DateTime(
          //               DateTime.now().year,
          //               DateTime.now().month,
          //               DateTime.now().day,
          //               int.parse(breakfromHour),
          //               int.parse(breakfromMin),
          //             );

          //             ///  break to time
          //             String? breaktoHour;
          //             String? breaktoMin;
          //             breaktoHour = breaktoController!.text.split(":").first;
          //             breaktoMin = breaktoController.text.contains(":") ? input.split(":").last : "0";
          //             DateTime breaktoTime = DateTime(
          //               DateTime.now().year,
          //               DateTime.now().month,
          //               DateTime.now().day,
          //               int.parse(breaktoHour),
          //               int.parse(breaktoMin),
          //             );

          //             ///  compare with break from and break to
          //             if (breaktoTime.difference(breakfromTime).inSeconds <= 0) return "Please enter correct time";

          //             breaktoController.text = KeicyDateTime.convertDateTimeToDateString(
          //               dateTime: breaktoTime,
          //               formats: "H:i",
          //               isUTC: false,
          //             );
          //             weekModel!.breaktotime = breaktoController.text;

          //             ///  compare with break to and to time
          //             String? toHour;
          //             String? toMin;
          //             toHour = toController!.text.split(":").first;
          //             toMin = toController.text.contains(":") ? input.split(":").last : "0";
          //             DateTime toTime = DateTime(
          //               DateTime.now().year,
          //               DateTime.now().month,
          //               DateTime.now().day,
          //               int.parse(toHour),
          //               int.parse(toMin),
          //             );

          //             if (toTime.difference(breaktoTime).inSeconds <= 0) return "Please enter correct time";

          //             return null;
          //           },
          //           onSaveHandler: (input) {
          //             weekModel!.breaktotime = input;
          //           },
          //           onEditingCompleteHandler: () {},
          //         ),
          //       ),
          //     ],
          //   ),
        ],
      ),
    );
  }

  Future<TimeOfDay?> _breakTimeHandler({
    @required bool? checkAvailable,
    String startTime = "",
    String? timeSlot,
  }) async {
    TimeOfDay initialTime;

    if (checkAvailable! && startTime != "" && timeSlot != null) {
      int h = int.parse(startTime.split(":").first);
      int m = int.parse(startTime.split(":").last);
      m = m + (timeSlot != "" ? int.parse(timeSlot) : 0);

      if (m >= 60) {
        h = h + m ~/ 60;
        m = m - (m ~/ 60) * 60;
      }
      initialTime = TimeOfDay(hour: h, minute: m);
    } else {
      initialTime = TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);
    }

    return await showCustomTimePicker(
      context: context,
      onFailValidation: (context) => FlutterLogs.logWarn(
        "appointment_view",
        "showCustomTimePicker",
        "Unavailable selection",
      ),
      initialTime: initialTime,
      selectableTimePredicate: !checkAvailable
          ? null
          : (TimeOfDay? time) {
              if (startTime != "" && timeSlot != null) {
                int h = int.parse(startTime.split(":").first);
                int m = int.parse(startTime.split(":").last);
                int startMin = h * 60 + m;
                int curMin = time!.hour * 60 + time.minute;
                if ((curMin - startMin) >= int.parse(timeSlot)) {
                  return true;
                } else {
                  return false;
                }
              }

              return true;
            },
    );
  }
}
