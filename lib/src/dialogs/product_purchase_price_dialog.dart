import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

class ProductPurchasePriceDialog {
  static show(
    BuildContext context, {
    @required Map<String, dynamic>? itemData,
    Function(Map<String, dynamic>)? callback,
  }) {
    GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    TextEditingController _priceController = TextEditingController();
    TextEditingController _discountController = TextEditingController();
    FocusNode _priceFocusNode = FocusNode();
    FocusNode _discountFocusNode = FocusNode();

    Map<String, dynamic> _itemData = json.decode(json.encode(itemData));

    _priceController.text = _itemData["price"] != 0 ? _itemData["price"].toString() : "";
    _discountController.text = _itemData["discount"]!.toString();
    _itemData["taxPercentage"] = _itemData["taxPercentage"] ?? 0;

    void _submit(double totalPrice) {
      if (_formkey.currentState!.validate()) {
        _formkey.currentState!.save();

        Navigator.pop(context);

        if (callback != null) {
          callback(_itemData);
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
          double totalPrice = 0;
          if (_itemData["price"] != null) {
            totalPrice =
                double.parse(_itemData["price"].toString()) - (_itemData["discount"] != null ? double.parse(_itemData["discount"].toString()) : 0);
            totalPrice = double.parse(totalPrice.toStringAsFixed(2));
          }

          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
            titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Item Details', style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
              ],
            ),
            children: <Widget>[
              Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name:  ', style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600)),
                        Expanded(
                          child: Text('${_itemData["name"]}', style: TextStyle(fontSize: fontSp * 14, color: Colors.black)),
                        ),
                      ],
                    ),
                    // SizedBox(height: heightDp * 5),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('Quantity:  ', style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600)),
                    //     Text('${_itemData["orderQuantity"]}', style: TextStyle(fontSize: fontSp * 14, color: Colors.black)),
                    //   ],
                    // ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Price:  ', style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            // height: heightDp * 25,
                            child: TextFormField(
                              controller: _priceController,
                              focusNode: _priceFocusNode,
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black, height: 1),
                              decoration: InputDecoration(
                                errorMaxLines: 2,
                                errorStyle: TextStyle(fontSize: fontSp * 10, color: Colors.red, height: 1),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.8))),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                              onChanged: (input) {
                                if (input.isNotEmpty) _itemData["price"] = double.parse(input.trim());
                                refreshProvider.refresh();
                              },
                              onSaved: (input) => _itemData["price"] = double.parse(input!.trim()),
                              validator: (input) => input!.trim().isEmpty
                                  ? "Please enter price"
                                  : double.parse(_priceController.text.trim()) <= double.parse(_discountController.text.trim())
                                      ? "Please enter the value more than discount"
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: heightDp * 5),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Discount:  ', style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600)),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                // height: heightDp * 25,
                                child: TextFormField(
                                  controller: _discountController,
                                  focusNode: _discountFocusNode,
                                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, height: 1),
                                  decoration: InputDecoration(
                                    errorMaxLines: 2,
                                    errorStyle: TextStyle(fontSize: fontSp * 10, color: Colors.red, height: 1),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(),
                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.8))),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.end,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                                  onChanged: (input) {
                                    if (input.isNotEmpty) _itemData["discount"] = double.parse(input.trim());
                                    refreshProvider.refresh();
                                  },
                                  onSaved: (input) => _itemData["discount"] = double.parse(input!.trim()),
                                  validator: (input) => input!.trim().isEmpty
                                      ? "Please enter discount"
                                      : double.parse(_priceController.text.trim()) <= double.parse(_discountController.text.trim())
                                          ? "Please enter the value less than price"
                                          : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Tax:  ', style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600)),
                        ),
                        Expanded(
                          child: KeicyDropDownFormField(
                            width: double.infinity,
                            height: heightDp * 25,
                            isImportant: true,
                            label: "Some",
                            menuItems: AppConfig.taxValues,
                            value: _itemData["taxPercentage"] != null ? double.parse(_itemData["taxPercentage"].toString()) : 0,
                            selectedItemStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, height: 1),
                            border: Border.all(),
                            borderRadius: heightDp * 3,
                            onChangeHandler: (value) {
                              _itemData["taxPercentage"] = value;
                              refreshProvider.refresh();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    SizedBox(height: heightDp * 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:  ', style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w600)),
                        Text(
                          _itemData["price"] == null ? '0' : "$totalPrice",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          onPressed: () {
                            _submit(totalPrice);
                          },
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
