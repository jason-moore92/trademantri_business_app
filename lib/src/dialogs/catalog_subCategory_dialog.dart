import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/index.dart';

class CatalogSubCategoryDialog {
  static show(
    BuildContext context,
    List<dynamic> productSubCatalogCategoryList,
    String selectedSubCategory,
  ) {
    TextEditingController _controller = TextEditingController();
    FocusNode _focusNode = FocusNode();

    double deviceHeight = 1.sh;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    String _selectedSubCategory = selectedSubCategory;

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
            "Choose the Sub Category",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
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
            Container(
              height: deviceHeight * 0.6,
              child: Column(
                children: [
                  Expanded(
                    child: Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
                      List<dynamic> _productCatalogCategoryList = [];
                      for (var i = 0; i < productSubCatalogCategoryList.length; i++) {
                        if (_controller.text.trim().isNotEmpty &&
                            productSubCatalogCategoryList[i].toString().toLowerCase().contains(_controller.text.trim().toLowerCase())) {
                          _productCatalogCategoryList.add(productSubCatalogCategoryList[i]);
                        } else if (_controller.text.trim().isEmpty) {
                          _productCatalogCategoryList.add(productSubCatalogCategoryList[i]);
                        }
                      }

                      return Column(
                        children: [
                          KeicyRaisedButton(
                            width: widthDp * 120,
                            height: heightDp * 35,
                            color: config.Colors().mainColor(1),
                            borderRadius: heightDp * 8,
                            child: Text(
                              "Choose",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(_selectedSubCategory);
                            },
                          ),
                          SizedBox(height: heightDp * 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                            child: KeicyTextFormField(
                              controller: _controller,
                              focusNode: _focusNode,
                              width: double.infinity,
                              height: heightDp * 40,
                              border: Border.all(color: Colors.grey.withOpacity(0.7)),
                              contentHorizontalPadding: widthDp * 10,
                              contentVerticalPadding: heightDp * 8,
                              textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                              hintText: "Please enter sub category",
                              onChangeHandler: (input) {
                                refreshProvider.refresh();
                              },
                            ),
                          ),
                          SizedBox(height: heightDp * 15),
                          Expanded(
                            child: NotificationListener<OverscrollIndicatorNotification>(
                              onNotification: (notification) {
                                notification.disallowGlow();
                                return true;
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(_productCatalogCategoryList.length, (index) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          dense: true,
                                          leading: IconButton(
                                            icon: Icon(
                                              _selectedSubCategory == _productCatalogCategoryList[index]
                                                  ? Icons.radio_button_checked_outlined
                                                  : Icons.radio_button_off_outlined,
                                              size: heightDp * 25,
                                              color: config.Colors().mainColor(1),
                                            ),
                                            onPressed: () {
                                              if (_selectedSubCategory == _productCatalogCategoryList[index]) {
                                                _selectedSubCategory = "";
                                              } else {
                                                _selectedSubCategory = _productCatalogCategoryList[index];
                                              }

                                              refreshProvider.refresh();
                                            },
                                          ),
                                          title: Text("${_productCatalogCategoryList[index]}", style: TextStyle(fontSize: fontSp * 16)),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
