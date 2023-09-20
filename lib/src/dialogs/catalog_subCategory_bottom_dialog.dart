import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/index.dart';

class CatalogSubCategoryBottomSheetDialog {
  static show(
    BuildContext context,
    List<dynamic> productSubCatalogCategoryList,
    String selectedSubCategory,
  ) {
    /// Responsive design variables
    double deviceWidth = 0;
    double deviceHeight = 0;
    double widthDp = 0;
    double heightDp = 0;
    double fontSp = 0;
    ///////////////////////////////

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    String _selectedSubCategory = selectedSubCategory;

    TextEditingController _controller = TextEditingController();
    FocusNode _focusNode = FocusNode();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
          List<dynamic> _productSubCatalogCategoryList = [];
          for (var i = 0; i < productSubCatalogCategoryList.length; i++) {
            if (_controller.text.trim().isNotEmpty &&
                productSubCatalogCategoryList[i].toString().toLowerCase().contains(_controller.text.trim().toLowerCase())) {
              _productSubCatalogCategoryList.add(productSubCatalogCategoryList[i]);
            } else if (_controller.text.trim().isEmpty) {
              _productSubCatalogCategoryList.add(productSubCatalogCategoryList[i]);
            }
          }

          return Material(
            color: Colors.transparent,
            child: KeyboardAware(builder: (context, keyboardConfig) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: deviceWidth,
                    height: deviceHeight / 2,
                    padding: EdgeInsets.symmetric(vertical: heightDp * 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(heightDp * 20), topRight: Radius.circular(heightDp * 20)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                          child: Text(
                            "Choose the Sub Category",
                            style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                          ),
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
                        SizedBox(height: heightDp * 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _productSubCatalogCategoryList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    leading: IconButton(
                                      icon: Icon(
                                        _selectedSubCategory == _productSubCatalogCategoryList[index]
                                            ? Icons.radio_button_checked_outlined
                                            : Icons.radio_button_off_outlined,
                                        size: heightDp * 25,
                                        color: config.Colors().mainColor(1),
                                      ),
                                      onPressed: () {
                                        if (_selectedSubCategory == _productSubCatalogCategoryList[index]) {
                                          _selectedSubCategory = "";
                                        } else {
                                          _selectedSubCategory = _productSubCatalogCategoryList[index];
                                        }

                                        refreshProvider.refresh();
                                      },
                                    ),
                                    title: Text("${_productSubCatalogCategoryList[index]}", style: TextStyle(fontSize: fontSp * 16)),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: heightDp * 20),
                        KeicyRaisedButton(
                          width: widthDp * 120,
                          height: heightDp * 35,
                          color: config.Colors().mainColor(1),
                          // color: _selectedSubCategory != "" ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                          borderRadius: heightDp * 8,
                          child: Text(
                            "Choose",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                            // style: TextStyle(fontSize: fontSp * 14, color: _selectedSubCategory != "" ? Colors.white : Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(_selectedSubCategory);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: keyboardConfig.keyboardHeight),
                ],
              );
            }),
          );
        });
      },
    );
  }
}
