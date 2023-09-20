import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_attribute_widget.dart';
import 'package:trapp/src/entities/product_stock.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ProductStockListPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class ProductStockView extends StatefulWidget {
  final bool? isNew;
  final ProductStock? productStock;
  final ProductModel? product;

  ProductStockView({
    Key? key,
    this.isNew,
    this.productStock,
    this.product,
  }) : super(key: key);

  @override
  _ProductStockViewState createState() => _ProductStockViewState();
}

class _ProductStockViewState extends State<ProductStockView> with SingleTickerProviderStateMixin {
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

  TextEditingController _notesController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  FocusNode _notesFocusNode = FocusNode();
  FocusNode _amountFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProductStock _productStock = ProductStock();

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  ImagePicker picker = ImagePicker();
  List<File> _imageFiles = [];

  StoreDataProvider? _storeDataProvider;

  KeicyProgressDialog? _keicyProgressDialog;

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

    _storeDataProvider = StoreDataProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
    numFormat.turnOffGrouping();

    _productStock = _productStock.copyWith(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      productId: widget.product!.id,
      type: "debit",
      amount: 0,
    );
    _amountController.text = "0";

    if (!widget.isNew! && widget.productStock != null) {
      _productStock = widget.productStock!;

      _notesController.text = _productStock.notes ?? "";
      _amountController.text = _productStock.amount.toString();
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveHandler() async {
    if (!_formKey.currentState!.validate()) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Please fix missing fields that are marked as red",
      );
      return;
    }
    _formKey.currentState!.save();

    await _keicyProgressDialog!.show();
    var result;

    if (widget.isNew!) {
      result = await ProductStockApiProvider.add(
        data: _productStock.toJson(),
      );
    } else {
      //No needed.
    }

    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: widget.isNew! ? "Create Success" : "Update Success!",
        callBack: () {
          Navigator.of(context).pop({
            "newStockValue": "todo",
          });
        },
      );
      _productStock = _productStock.copyWith(id: result["oid"]);
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"] ?? "Something was wrong",
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            widget.isNew! ? "New Entry" : "Edit Entry",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
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
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: heightDp * 15),
                    _generalInfoPanel(),
                    SizedBox(height: heightDp * 30),
                    KeicyRaisedButton(
                      width: widthDp * 120,
                      height: heightDp * 35,
                      borderRadius: heightDp * 8,
                      color: config.Colors().mainColor(1),
                      child: Text("Save", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                      onPressed: _saveHandler,
                    ),
                    SizedBox(height: heightDp * 30),
                    Text(
                      "Disclaimer : This entry will effect the total stock value on that product.",
                      style: TextStyle(
                        fontSize: fontSp * 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _generalInfoPanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: _amountController,
                  focusNode: _amountFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  isImportant: true,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: "Amount",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Amount",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  prefixIcons: [],
                  autovalidateMode: AutovalidateMode.always,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    _productStock = _productStock.copyWith(
                      amount: double.parse(input),
                    );
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) return "Enter the amount";
                    if (double.parse(input) < 0) return "Enter the amount more than 0";
                    return null;
                  },
                  onSaveHandler: (input) {
                    if (input.isEmpty) return;
                    _productStock = _productStock.copyWith(
                      amount: double.parse(input),
                    );
                  },
                  onEditingCompleteHandler: () {
                    // FocusScope.of(context).requestFocus(_sellingPriceFocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                "* ${widget.product!.quantity} ${widget.product!.quantityType}",
                style: TextStyle(
                  fontSize: fontSp * 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: heightDp * 15,
          ),
          KeicyDropDownFormField(
            width: double.infinity,
            height: heightDp * 25,
            menuItems: AppConfig.stockTypes,
            label: "Type",
            value: _productStock.type,
            selectedItemStyle: TextStyle(
              fontSize: fontSp * 14,
              color: Colors.black,
              height: 1,
            ),
            isImportant: true,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red),
            borderRadius: heightDp * 6,
            onChangeHandler: (value) {
              _productStock = _productStock.copyWith(
                type: value,
              );
            },
          ),
          SizedBox(
            height: heightDp * 15,
          ),
          KeicyTextFormField(
            controller: _notesController,
            focusNode: _notesFocusNode,
            width: double.infinity,
            height: null,
            maxHeight: heightDp * 80,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red),
            borderRadius: heightDp * 6,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            isImportant: true,
            label: "Notes",
            labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            labelSpacing: heightDp * 5,
            hintText: "Notes",
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            errorStringFontSize: fontSp * 10,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            onChangeHandler: (input) => _productStock = _productStock.copyWith(notes: input.trim()),
            validatorHandler: (input) => (input.trim().isEmpty) ? "Enter some notes" : null,
            onSaveHandler: (input) => _productStock = _productStock.copyWith(notes: input.trim()),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),
        ],
      ),
    );
  }
}
