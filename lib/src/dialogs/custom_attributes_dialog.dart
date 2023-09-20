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

class CustomAttributesDialog {
  static show(
    BuildContext context, {
    Map<String, dynamic> attributes = const {},
  }) {
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    TextEditingController _typeController = TextEditingController();
    TextEditingController _vauleController = TextEditingController();
    TextEditingController _specificersController = TextEditingController();
    FocusNode _typeFocusNode = FocusNode();
    FocusNode _valueFocusNode = FocusNode();
    FocusNode _specificersFocusNode = FocusNode();

    Map<String, dynamic> _attributes = json.decode(json.encode(attributes));

    if (_attributes.isNotEmpty) {
      _typeController.text = _attributes["type"] == null ? "" : _attributes["type"].toString();
      _vauleController.text = _attributes["value"] == null ? "" : _attributes["value"].toString();
      _specificersController.text = _attributes["specifiers"] == null ? "" : _attributes["specifiers"];
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      // barrierColor: barrierColor ?? Colors.black.withOpacity(0.3),
      builder: (BuildContext context1) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
          titlePadding: EdgeInsets.only(
            left: heightDp * 10,
            right: heightDp * 10,
            top: heightDp * 0,
            bottom: heightDp * 0,
          ),
          contentPadding: EdgeInsets.only(
            left: heightDp * 0,
            right: heightDp * 0,
            top: heightDp * 0,
            bottom: heightDp * 0,
          ),
          children: [
            Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close, size: heightDp * 20),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: Column(
                        children: [
                          Text(
                            _attributes.isNotEmpty ? "Edit the Customer Fields" : "Add the Customer Fields",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: heightDp * 20),
                          KeicyTextFormField(
                            controller: _typeController,
                            focusNode: _typeFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            label: "Custom Field Name",
                            labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                            labelSpacing: heightDp * 5,
                            textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            hintText: "Please enter type",
                            validatorHandler: (value) => value.isEmpty ? "Please input type" : null,
                            onChangeHandler: (input) {
                              refreshProvider.refresh();
                              _attributes["type"] = input;
                            },
                            onSaveHandler: (input) => _attributes["type"] = input,
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_valueFocusNode),
                          ),

                          ///
                          SizedBox(height: heightDp * 10),
                          KeicyTextFormField(
                            controller: _vauleController,
                            focusNode: _valueFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            label: "Custom Field Value",
                            labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                            labelSpacing: heightDp * 5,
                            textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                            hintText: "Please enter value",
                            validatorHandler: (value) => value.isEmpty ? "Please input value" : null,
                            onChangeHandler: (input) {
                              refreshProvider.refresh();
                              _attributes["value"] = input;
                            },
                            onSaveHandler: (input) => _attributes["value"] = input,
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_specificersFocusNode),
                          ),

                          // ///
                          // SizedBox(height: heightDp * 10),
                          // KeicyTextFormField(
                          //   controller: _unitsController,
                          //   focusNode: _unitsFocusNode,
                          //   width: double.infinity,
                          //   height: heightDp * 40,
                          //   border: Border.all(color: Colors.grey.withOpacity(0.7)),
                          //   errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                          //   borderRadius: heightDp * 6,
                          //   contentHorizontalPadding: widthDp * 10,
                          //   contentVerticalPadding: heightDp * 8,
                          //   label: "Custom Field Units",
                          //   labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                          //   labelSpacing: heightDp * 5,
                          //   textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          //   hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                          //   hintText: "Please enter units",
                          //   keyboardType: TextInputType.number,
                          //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          //   // validatorHandler: (value) => value.isEmpty ? "Please input units" : null,
                          //   onChangeHandler: (input) {
                          //     refreshProvider.refresh();
                          //     _attributes["units"] = input;
                          //   },
                          //   onSaveHandler: (input) => _attributes["units"] = input,
                          //   onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_specificersFocusNode),
                          // ),

                          ///
                          SizedBox(height: heightDp * 10),
                          KeicyTextFormField(
                            controller: _specificersController,
                            focusNode: _specificersFocusNode,
                            width: double.infinity,
                            height: heightDp * 100,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 6,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            label: "Specificers (Extra Info)",
                            labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                            labelSpacing: heightDp * 5,
                            textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                            hintText: "Please enter specifiers",
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            // validatorHandler: (value) => value.isEmpty ? "Please input specifiers" : null,
                            onChangeHandler: (input) {
                              refreshProvider.refresh();
                              _attributes["specifiers"] = input;
                            },
                            onSaveHandler: (input) => _attributes["specifiers"] = input,
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                          ),

                          ///
                          SizedBox(height: heightDp * 20),
                          KeicyRaisedButton(
                              width: widthDp * 150,
                              height: heightDp * 40,
                              color: config.Colors().mainColor(1),
                              borderRadius: heightDp * 8,
                              child: Text(
                                "Save",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                              ),
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                _formKey.currentState!.save();
                                Navigator.of(context).pop(_attributes);
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: heightDp * 20),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
