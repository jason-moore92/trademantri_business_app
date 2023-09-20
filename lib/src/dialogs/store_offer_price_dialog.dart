import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/index.dart';

class StoreOfferPriceDialog {
  static show(
    BuildContext context, {
    @required double? leastOfferPrice,
    @required double? yourOfferPrice,
    @required String? yourMessage,
    Function(String, String)? callback,
  }) {
    GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    TextEditingController _priceController = TextEditingController(text: yourOfferPrice.toString());
    FocusNode _priceFocusNode = FocusNode();
    TextEditingController _messageController = TextEditingController(text: yourMessage);
    FocusNode _messageFocusNode = FocusNode();

    void _submitHandler() {
      if (!_formkey.currentState!.validate()) return;
      Navigator.of(context).pop();
      callback!(_priceController.text.trim(), _messageController.text.trim());
    }

    showDialog(
      context: context,
      builder: (context) {
        return Consumer<RefreshProvider>(builder: (context, statusProvider, _) {
          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
            titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Place Your Bid', style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
              ],
            ),
            children: <Widget>[
              Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: widthDp * 150,
                        child: TextFormField(
                          controller: _priceController,
                          focusNode: _priceFocusNode,
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.8))),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (input) {},
                          validator: (input) => input!.trim().isEmpty
                              ? "Please enter price"
                              : double.parse(input.trim()) == yourOfferPrice
                                  ? "Please enter other Price"
                                  : null,
                        ),
                      ),
                    ),
                    SizedBox(height: heightDp * 20),
                    Text(
                      "Least Bid Price in the Auction",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                    ),
                    SizedBox(height: heightDp * 20),
                    Text(
                      leastOfferPrice == 0 ? "No Bid" : "₹ $leastOfferPrice",
                      style: TextStyle(
                        fontSize: leastOfferPrice == 0 ? fontSp * 16 : fontSp * 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    ///
                    SizedBox(height: heightDp * 10),
                    Row(
                      children: [
                        Text(
                          "Message:",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    TextFormField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.8))),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                      ),
                      maxLines: 3,
                      onChanged: (input) {},
                      validator: (input) => input!.trim().isEmpty ? "Please enter message" : null,
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          onPressed: _submitHandler,
                          color: config.Colors().mainColor(1),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 3),
                          child: Text("Save", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.grey.withOpacity(0.4),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 3),
                          child: Text("Cancel", style: TextStyle(fontSize: fontSp * 14, color: Colors.black)),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 20),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
