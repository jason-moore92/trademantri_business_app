import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/success_dialog.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/index.dart';

import 'keicy_avatar_image.dart';
import 'keicy_dropdown_form_field.dart';

class VarientProductWidget extends StatefulWidget {
  final Map<String, dynamic>? varientData;
  final Map<String, dynamic>? productData;
  final String? imgLocation;
  final bool isLoading;

  VarientProductWidget({
    @required this.varientData,
    @required this.productData,
    @required this.imgLocation,
    this.isLoading = true,
  });

  @override
  _ProductItemForSelectionWidgetState createState() => _ProductItemForSelectionWidgetState();
}

class _ProductItemForSelectionWidgetState extends State<VarientProductWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  TextEditingController _categoryCongtroller = TextEditingController();
  TextEditingController _mrpCongtroller = TextEditingController();
  TextEditingController _sellingController = TextEditingController();
  TextEditingController _buyingController = TextEditingController();
  TextEditingController _stockAvailableCongtroller = TextEditingController();

  FocusNode _categoryFocusNode = FocusNode();
  FocusNode _mrpFocusNode = FocusNode();
  FocusNode _sellingFocusNode = FocusNode();
  FocusNode _buyingFocusNode = FocusNode();
  FocusNode _stockAvailableFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  KeicyProgressDialog? _keicyProgressDialog;

  int? _taxValue;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _categoryCongtroller.text = widget.productData!["item"]["category"];
    _mrpCongtroller.text = widget.varientData!["mrp"].toString();
    widget.varientData!["discount"] = widget.varientData!["discount"] ?? 0;
    widget.varientData!["buyingPrice"] = widget.varientData!["buyingPrice"] ?? 0;
    _sellingController.text =
        (double.parse(widget.varientData!["mrp"].toString()) - double.parse(widget.varientData!["discount"].toString())).toString();
    _buyingController.text = widget.varientData!["buyingPrice"] != null ? widget.varientData!["buyingPrice"].toString() : "0";
    _taxValue = widget.varientData!["gst"] ?? 0;
  }

  void _addHandler() async {
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

    Map<String, dynamic> _newProductData = {
      "name": widget.varientData!["name"],
      "description": widget.varientData!["description"],
      "category": widget.productData!["item"]["category"],
      "brand": widget.varientData!["brand"],
      "quantity": 1,
      "quantityType": "measureType",
      "storeId": AuthProvider.of(context).authState.storeModel!.id,
      "price": double.parse(_mrpCongtroller.text.trim()),
      "isAvailable": true,
      "racklocation": null,
      "stockavailable": double.parse(_stockAvailableCongtroller.text.trim()),
      "taxPercentage": _taxValue,
      "discount": double.parse(_mrpCongtroller.text.trim()) - double.parse(_sellingController.text.trim()),
      "showPriceToUsers": true,
      "productIdentificationCode": widget.varientData!["skuId"],
      "images": [widget.imgLocation! + widget.varientData!["imageUrl"]],
      "bargainAvailable": false,
      "acceptBulkOrder": false,
      "minQuantityForBulkOrder": 0,
      "isDeleted": false,
      "listonline": true,
      "variant": null,
      "priceAttributes": {
        "selling": double.parse(_sellingController.text.trim()),
        "buying": double.parse(_buyingController.text.trim()),
      },
      "margin": double.parse(
        numFormat.format(
          (double.parse(_sellingController.text.trim()) - double.parse(_buyingController.text.trim())) /
              double.parse(_sellingController.text.trim()) *
              100,
        ),
      ),
      "bargainAttributes": {
        "minQuantity": null,
        "minAmount": null,
      },
      "extraCharges": {
        "cess": {
          "percentage": widget.productData!["item"]["cessPercentage"],
          "value": widget.productData!["item"]["ess"],
        },
      },
      "attributes": []
    };

    await _keicyProgressDialog!.show();

    var result = await ProductApiProvider.addProduct(
      productData: _newProductData,
      token: AuthProvider.of(context).authState.businessUserModel!.token,
      isNew: true,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      List<dynamic> productCategoryList = StoreDataProvider.of(context).storeDataState.productCategoryList!;
      bool isNew = true;
      for (var i = 0; i < productCategoryList.length; i++) {
        if (productCategoryList[i] == _categoryCongtroller.text.trim()) {
          isNew = false;
        }
      }

      if (isNew) {
        productCategoryList.add(_categoryCongtroller.text.trim());
      }

      List<dynamic> productBrandList = StoreDataProvider.of(context).storeDataState.productBrandList!;
      isNew = true;
      for (var i = 0; i < productBrandList.length; i++) {
        if (productBrandList[i] == widget.varientData!["brand"]) {
          isNew = false;
        }
      }
      if (isNew) {
        productBrandList.add(widget.varientData!["brand"]);
      }

      StoreDataProvider.of(context).setStoreDataState(
        StoreDataProvider.of(context).storeDataState.update(
              productCategoryList: productCategoryList,
              productBrandList: productBrandList,
            ),
      );
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp);
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightDp * 8), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.6),
          blurRadius: 6,
          offset: Offset(0, 3),
        )
      ]),
      child: widget.isLoading ? _shimmerWidget() : _productWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.isLoading,
      period: Duration(milliseconds: 1000),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 20),
        child: Column(
          children: [
            Container(width: widthDp * 100, height: widthDp * 100, color: Colors.white),
            SizedBox(height: heightDp * 10),
            Container(
              color: Colors.white,
              child: Text(
                "product name",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: heightDp * 5),
            Container(
              color: Colors.white,
              child: Text(
                "category",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: heightDp * 15),
            KeicyRaisedButton(
              width: widthDp * 130,
              height: heightDp * 35,
              color: Colors.white,
              borderRadius: heightDp * 8,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "Show Variants",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productWidget() {
    return Form(
      key: _formkey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: KeicyAvatarImage(
                url: widget.imgLocation! + widget.varientData!["imageUrl"],
                width: widthDp * 100,
                height: widthDp * 100,
                imageFile: widget.varientData!["imageFile"],
                backColor: Colors.grey.withOpacity(0.4),
              ),
            ),

            ///
            SizedBox(height: heightDp * 10),
            Text(
              "${widget.varientData!["name"]}",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

            ///
            SizedBox(height: heightDp * 10),
            KeicyTextFormField(
              controller: _categoryCongtroller,
              focusNode: _categoryFocusNode,
              width: double.infinity,
              height: heightDp * 40,
              border: Border.all(color: Colors.grey.withOpacity(0.7)),
              errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              isImportant: true,
              label: "Category",
              labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              labelSpacing: heightDp * 5,
              textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              borderRadius: heightDp * 8,
              validatorHandler: (input) => input.trim().isEmpty ? "Please enter category" : null,
            ),

            ///
            SizedBox(height: heightDp * 10),
            KeicyTextFormField(
              controller: _mrpCongtroller,
              focusNode: _mrpFocusNode,
              width: double.infinity,
              height: heightDp * 40,
              border: Border.all(color: Colors.grey.withOpacity(0.7)),
              errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              isImportant: true,
              label: "Max Retail Price",
              labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              labelSpacing: heightDp * 5,
              textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              borderRadius: heightDp * 8,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
              validatorHandler: (input) {
                if (input.trim().isEmpty) return "Please enter retail price";

                if (double.parse(input.trim()) < 0) {
                  return "Please enter retail price more than 0";
                }

                if (double.parse(_mrpCongtroller.text.trim()) < double.parse(_sellingController.text.trim())) {
                  return "Please enter retail price more than selling price";
                }

                return null;
              },
            ),

            ///
            SizedBox(height: heightDp * 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KeicyTextFormField(
                    controller: _sellingController,
                    focusNode: _sellingFocusNode,
                    width: double.infinity,
                    height: heightDp * 40,
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    isImportant: true,
                    label: "Selling Price",
                    labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    borderRadius: heightDp * 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    validatorHandler: (input) {
                      if (input.trim().isEmpty) return "Please enter selling price";

                      if (double.parse(input.trim()) < 0) {
                        return "Please enter selling price more than 0";
                      }

                      if (double.parse(_mrpCongtroller.text.trim()) < double.parse(_sellingController.text.trim())) {
                        return "Please enter selling price less than retail price";
                      }

                      if (double.parse(_buyingController.text.trim()) > double.parse(_sellingController.text.trim())) {
                        return "Please enter selling price more than buying price";
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(width: widthDp * 10),
                Expanded(
                  child: KeicyTextFormField(
                    controller: _buyingController,
                    focusNode: _buyingFocusNode,
                    width: double.infinity,
                    height: heightDp * 40,
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    isImportant: true,
                    label: "Buying Price",
                    labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    borderRadius: heightDp * 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    validatorHandler: (input) {
                      if (input.trim().isEmpty) return "Please enter buying price";

                      if (double.parse(input.trim()) < 0) {
                        return "Please enter buying price more than 0";
                      }

                      if (double.parse(_buyingController.text.trim()) > double.parse(_sellingController.text.trim())) {
                        return "Please enter buying price less than selling price";
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),

            ///

            ///
            SizedBox(height: heightDp * 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KeicyDropDownFormField(
                    focusNode: FocusNode(),
                    width: double.infinity,
                    height: heightDp * 40,
                    menuItems: AppConfig.taxValues,
                    isImportant: true,
                    label: "Tax Percent (%)",
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    value: _taxValue,
                    selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                    borderRadius: heightDp * 6,
                    onValidateHandler: (value) => value == null ? "Please select tax percent" : null,
                    onChangeHandler: (value) {
                      _taxValue = value;
                    },
                  ),
                ),
                SizedBox(width: widthDp * 10),
                Expanded(
                  child: KeicyTextFormField(
                    controller: _stockAvailableCongtroller,
                    focusNode: _stockAvailableFocusNode,
                    width: double.infinity,
                    height: heightDp * 40,
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.8)),
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    isImportant: true,
                    label: "Stock Avaliable",
                    labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    borderRadius: heightDp * 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validatorHandler: (input) => input.trim().isEmpty ? "Please enter stock avaiable" : null,
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 10),

            SizedBox(height: heightDp * 20),
            Center(
              child: KeicyRaisedButton(
                width: widthDp * 185,
                height: heightDp * 40,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 8,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                child: Text(
                  "Add product to Store",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: _addHandler,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
