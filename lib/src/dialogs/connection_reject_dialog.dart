import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/index.dart';

class ConnectionRejectDialog {
  static show(BuildContext context) {
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    TextEditingController _noteController = TextEditingController();
    FocusNode _noteFocusNode = FocusNode();

    return showDialog(
      context: context,
      barrierDismissible: false,
      // barrierColor: barrierColor ?? Colors.black.withOpacity(0.3),
      builder: (BuildContext context1) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
          title: Text(
            "Connection Reject",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          titlePadding: EdgeInsets.only(
            left: heightDp * 10,
            right: heightDp * 10,
            top: heightDp * 20,
            bottom: heightDp * 10,
          ),
          contentPadding: EdgeInsets.only(
            left: heightDp * 0,
            right: heightDp * 0,
            top: heightDp * 10,
            bottom: heightDp * 20,
          ),
          children: [
            Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
              return Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                  child: Column(
                    children: [
                      Text(
                        "Are you going to reject this request, please add a note why you are going to reject",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: heightDp * 20),
                      KeicyTextFormField(
                        controller: _noteController,
                        focusNode: _noteFocusNode,
                        width: double.infinity,
                        height: heightDp * 100,
                        border: Border.all(color: Colors.grey.withOpacity(0.7)),
                        errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                        borderRadius: heightDp * 6,
                        label: "Add Note",
                        labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                        labelSpacing: heightDp * 5,
                        textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        hintText: "Please enter note",
                        validatorHandler: (value) => value.length > 1000 ? "Please input 1000 letters at most" : null,
                        onChangeHandler: (input) {},
                        onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                      ),

                      ///
                      SizedBox(height: heightDp * 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          KeicyRaisedButton(
                            width: widthDp * 100,
                            height: heightDp * 40,
                            color: config.Colors().mainColor(1),
                            borderRadius: heightDp * 8,
                            child: Text(
                              "Reject",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                            ),
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;
                              _formKey.currentState!.save();
                              Navigator.of(context).pop(_noteController.text);
                            },
                          ),
                          KeicyRaisedButton(
                            width: widthDp * 100,
                            height: heightDp * 40,
                            color: config.Colors().mainColor(1),
                            borderRadius: heightDp * 8,
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
