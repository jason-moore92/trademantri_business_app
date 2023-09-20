import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/RefreshProvider/index.dart';

class UpdateQuantityDialog {
  static show(
    BuildContext context, {
    @required int? quantity,
    @required double? widthDp,
    @required double? heightDp,
    @required double? fontSp,
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    bool barrierDismissible = true,
    @required Function(int)? callBack,
    int delaySecondes = 2,
  }) async {
    TextEditingController _quantityController = TextEditingController(text: quantity.toString());
    FocusNode _quantityFocusNode = FocusNode();

    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    var result = await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
          return SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.white,
            insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
            titlePadding: titlePadding ?? EdgeInsets.zero,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: widthDp! * 20, vertical: heightDp * 20),
            children: [
              Center(
                child: Text(
                  "Update Quantity",
                  style: TextStyle(fontSize: fontSp! * 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),

              ///
              SizedBox(height: heightDp * 20),
              Form(
                key: _formkey,
                child: Center(
                  child: Container(
                    width: widthDp! * 150,
                    decoration: BoxDecoration(border: Border.all()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        KeicyTextFormField(
                          controller: _quantityController,
                          focusNode: _quantityFocusNode,
                          width: widthDp * 100,
                          height: heightDp * 35,
                          textStyle: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                          textAlign: TextAlign.center,
                          border: Border.all(color: Colors.transparent),
                          contentHorizontalPadding: widthDp * 10,
                          contentVerticalPadding: heightDp * 8,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          onChangeHandler: (input) {
                            refreshProvider.refresh();
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                if (_quantityController.text.trim().isEmpty) _quantityController.text = "0";
                                _quantityController.text = (int.parse(_quantityController.text.toString()) + 1).toString();
                                refreshProvider.refresh();
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 5, bottom: heightDp * 0),
                                color: Colors.transparent,
                                child: Transform.rotate(
                                  angle: pi / 2.0,
                                  child: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if ((_quantityController.text.isEmpty || (int.parse(_quantityController.text.toString()) == 1))) return;
                                FocusScope.of(context).requestFocus(FocusNode());

                                _quantityController.text = (int.parse(_quantityController.text.toString()) - 1).toString();
                                refreshProvider.refresh();
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 0, bottom: heightDp * 5),
                                color: Colors.transparent,
                                child: Transform.rotate(
                                  angle: -pi / 2.0,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: heightDp * 20,
                                    color: (_quantityController.text.isEmpty || (int.parse(_quantityController.text.toString()) == 1))
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "(Customer will be notified about update quantity)",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),

              ///
              SizedBox(height: heightDp * 15),

              SizedBox(height: heightDp * 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  KeicyRaisedButton(
                    width: widthDp * 100,
                    height: heightDp * 30,
                    color: _quantityController.text.isEmpty || quantity.toString() == _quantityController.text
                        ? Colors.grey.withOpacity(0.4)
                        : config.Colors().mainColor(1),
                    borderRadius: heightDp * 6,
                    child: Text(
                      "Update",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                    ),
                    onPressed: _quantityController.text.isEmpty || quantity.toString() == _quantityController.text
                        ? null
                        : () {
                            if (!_formkey.currentState!.validate()) return;
                            Navigator.of(context).pop();
                            if (callBack != null) {
                              callBack(int.parse(_quantityController.text.toString()));
                            }
                          },
                  ),
                ],
              )
            ],
          );
        });
      },
    );

    // if (result == null && cancelCallback != null) {
    //   cancelCallback();
    // }
  }
}
