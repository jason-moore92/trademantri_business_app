import 'dart:convert';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NewServiceView extends StatefulWidget {
  final String? type;
  final bool? isNew;
  final ServiceModel? serviceModel;

  NewServiceView({
    Key? key,
    this.type,
    this.isNew,
    this.serviceModel,
  }) : super(key: key);

  @override
  _NewServiceViewState createState() => _NewServiceViewState();
}

class _NewServiceViewState extends State<NewServiceView> with SingleTickerProviderStateMixin {
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
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _providedController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _sellingPriceController = TextEditingController();
  TextEditingController _buyingPriceController = TextEditingController();
  TextEditingController _marginController = TextEditingController();
  TextEditingController _cessPercentController = TextEditingController();
  TextEditingController _cessValueController = TextEditingController();
  TextEditingController _bargainMinQuantityController = TextEditingController();
  TextEditingController _bargainMinAmountController = TextEditingController();
  TextEditingController _b2bPriceFromController = TextEditingController();
  TextEditingController _b2bPriceToController = TextEditingController();
  TextEditingController _b2bDiscountController = TextEditingController();
  TextEditingController _b2bMinQuantityForBulkOrderController = TextEditingController();
  TextEditingController _b2bTaxPercentageController = TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _discountFocusNode = FocusNode();
  FocusNode _sellingPriceFocusNode = FocusNode();
  FocusNode _buyingPriceFocusNode = FocusNode();
  FocusNode _marginFocusNode = FocusNode();
  FocusNode _taxFocusNode = FocusNode();
  FocusNode _cessPercentFocusNode = FocusNode();
  FocusNode _cessValueFocusNode = FocusNode();
  FocusNode _bargainMinQuantityFocusNode = FocusNode();
  FocusNode _bargainMinAmountFocusNode = FocusNode();
  FocusNode _b2bPriceFromFocusNode = FocusNode();
  FocusNode _b2bPriceToFocusNode = FocusNode();
  FocusNode _b2bDiscountFocusNode = FocusNode();
  FocusNode _b2bMinQuantityForBulkOrderFocusNode = FocusNode();
  FocusNode _b2bTaxPercentageFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ServiceModel _serviceModel = ServiceModel();

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

    _serviceModel.storeId = AuthProvider.of(context).authState.storeModel!.id;
    _serviceModel.discount = 0;
    _serviceModel.bargainAvailable = true;
    _serviceModel.isAvailable = true;
    _serviceModel.listonline = true;
    _serviceModel.showPriceToUsers = true;
    _serviceModel.taxPercentage = 0;
    _serviceModel.isDeleted = false;
    _serviceModel.images = [];
    _discountController.text = "0";
    _b2bDiscountController.text = "0";

    if (!widget.isNew! && widget.serviceModel != null) {
      _serviceModel = ServiceModel.copy(widget.serviceModel!);

      _serviceModel.images = _serviceModel.images ?? [];

      _nameController.text = _serviceModel.name ?? "";
      _descriptionController.text = _serviceModel.description ?? "";
      _categoryController.text = _serviceModel.category ?? "";
      _providedController.text = _serviceModel.provided ?? "";
      _priceController.text = _serviceModel.price.toString();
      _discountController.text = _serviceModel.discount.toString();
      _sellingPriceController.text = (_serviceModel.priceAttributes != null && _serviceModel.priceAttributes!["selling"] != null)
          ? _serviceModel.priceAttributes!["selling"].toString()
          : "";
      _buyingPriceController.text = (_serviceModel.priceAttributes != null && _serviceModel.priceAttributes!["buying"] != null)
          ? _serviceModel.priceAttributes!["buying"].toString()
          : "";
      _marginController.text = _serviceModel.margin != null ? _serviceModel.margin.toString() : "";
      _cessPercentController.text = (_serviceModel.extraCharges != null &&
              _serviceModel.extraCharges!["cess"] != null &&
              _serviceModel.extraCharges!["cess"]["percentage"] != null)
          ? _serviceModel.extraCharges!["cess"]["percentage"].toString()
          : "";
      _cessValueController.text =
          (_serviceModel.extraCharges != null && _serviceModel.extraCharges!["cess"] != null && _serviceModel.extraCharges!["cess"]["value"] != null)
              ? _serviceModel.extraCharges!["cess"]["value"].toString()
              : "";
      _bargainMinAmountController.text = (_serviceModel.bargainAttributes != null && _serviceModel.bargainAttributes!["minAmount"] != null)
          ? _serviceModel.bargainAttributes!["minAmount"].toString()
          : "";
      _bargainMinQuantityController.text = (_serviceModel.bargainAttributes != null && _serviceModel.bargainAttributes!["minQuantity"] != null)
          ? _serviceModel.bargainAttributes!["minQuantity"].toString()
          : "";

      if (_serviceModel.attributes == null) _serviceModel.attributes = [];
      List<dynamic> attributes = [];
      for (var i = 0; i < _serviceModel.attributes!.length; i++) {
        if (_serviceModel.attributes![i]["type"] != "" && _serviceModel.attributes![i]["type"] != null) {
          attributes.add(_serviceModel.attributes![i]);
        }
      }
      _serviceModel.attributes = attributes;

      //////
      if (_serviceModel.b2bPriceFrom != null) _b2bPriceFromController.text = _serviceModel.b2bPriceFrom.toString();
      if (_serviceModel.b2bPriceTo != null) _b2bPriceToController.text = _serviceModel.b2bPriceTo.toString();
      if (_serviceModel.b2bDiscountValue != null) _b2bDiscountController.text = _serviceModel.b2bDiscountValue.toString();
      if (_serviceModel.b2bMinQuantityForBulkOrder != null)
        _b2bMinQuantityForBulkOrderController.text = _serviceModel.b2bMinQuantityForBulkOrder.toString();
      if (_serviceModel.b2bTaxPercentage != null) _b2bTaxPercentageController.text = _serviceModel.b2bTaxPercentage.toString();
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _priceHandler({bool isPrice = false, bool isDiscount = false, bool isSelling = false}) {
    if (_serviceModel.price == null) return;
    if (_serviceModel.priceAttributes == null) {
      _serviceModel.priceAttributes = Map<String, dynamic>();
    }

    if (isDiscount) {
      _serviceModel.priceAttributes!["selling"] = double.parse((_serviceModel.price! - _serviceModel.discount!).toStringAsFixed(2));
      _priceController.text = numFormat.format(_serviceModel.price);
      _sellingPriceController.text = numFormat.format(_serviceModel.priceAttributes!["selling"]);
    }

    if (isSelling && _serviceModel.price! >= _serviceModel.priceAttributes!["selling"]) {
      _serviceModel.discount = double.parse((_serviceModel.price! - _serviceModel.priceAttributes!["selling"]).toStringAsFixed(2));
      _priceController.text = numFormat.format(_serviceModel.price);
      _discountController.text = numFormat.format(_serviceModel.discount);
    }

    if (isPrice) {
      _serviceModel.priceAttributes!["selling"] = double.parse((_serviceModel.price! - _serviceModel.discount!).toStringAsFixed(2));
      _discountController.text = numFormat.format(_serviceModel.discount);
      _sellingPriceController.text = numFormat.format(_serviceModel.priceAttributes!["selling"]);
    }

    setState(() {});
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

    try {} catch (e) {}

    await _keicyProgressDialog!.show();
    var result;
    if (_imageFiles.isNotEmpty) {
      result = await ServiceApiProvider.uploadImage(
        imageFiles: _imageFiles,
        token: AuthProvider.of(context).authState.businessUserModel!.token,
      );
      if (!result["success"] || result["data"].isEmpty) {
        await _keicyProgressDialog!.hide();

        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: result["message"] ?? "Image upload Error",
        );
        return;
      }
      _serviceModel.images!.addAll(result["data"]);
    }

    if (widget.isNew!) {
      result = await ServiceApiProvider.addService(
        serviceData: _serviceModel.toJson(),
        token: AuthProvider.of(context).authState.businessUserModel!.token,
        isNew: widget.isNew,
      );
    } else {
      result = await ServiceApiProvider.addService(
        serviceData: _serviceModel.toJson(),
        token: AuthProvider.of(context).authState.businessUserModel!.token,
        isNew: false,
      );
    }
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      List<dynamic>? serviceCategoryList = StoreDataProvider.of(context).storeDataState.serviceCategoryList;
      List<dynamic>? serviceProvidedList = StoreDataProvider.of(context).storeDataState.serviceProvidedList;

      if (!serviceCategoryList!.contains(_serviceModel.category)) {
        serviceCategoryList.add(_serviceModel.category);
      }

      if (!serviceProvidedList!.contains(_serviceModel.provided)) {
        serviceProvidedList.add(_serviceModel.provided);
      }

      StoreDataProvider.of(context).setStoreDataState(
        StoreDataProvider.of(context).storeDataState.update(
              serviceCategoryList: serviceCategoryList,
              // serviceBrandList: serviceBrandList,
            ),
      );

      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: widget.isNew! ? "Create Success" : "Update Success!",
        callBack: () {
          Navigator.of(context).pop({
            "category": _serviceModel.category,
            "provided": _serviceModel.provided,
          });
        },
      );
      _serviceModel.id = result["oid"];
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
            widget.isNew! ? "New Service" : "Edit Service",
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
                    _pricePanel(),
                    SizedBox(height: heightDp * 30),
                    _b2bPricePanel(),
                    SizedBox(height: heightDp * 30),
                    _bargainDetail(),
                    SizedBox(height: heightDp * 30),
                    _attributesDetail(),
                    SizedBox(height: heightDp * 30),
                    _otherPanel(),
                    SizedBox(height: heightDp * 30),
                    _imagePanel(),
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
          Text(
            "General Details",
            style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          SizedBox(height: heightDp * 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  // constraints: BoxConstraints(maxHeight: heightDp * 80),
                  child: KeicyTextFormField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    width: double.infinity,
                    height: null,
                    maxHeight: heightDp * 80,
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    errorBorder: Border.all(color: Colors.red),
                    borderRadius: heightDp * 6,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: !widget.isNew! ? Colors.grey : Colors.black),
                    label: "Name",
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    hintText: "Name",
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                    errorStringFontSize: fontSp * 10,
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    readOnly: !widget.isNew!,
                    textInputAction: TextInputAction.newline,
                    onChangeHandler: (input) => _serviceModel.name = input.trim(),
                    validatorHandler: (input) => (input.trim().isEmpty) ? "Please enter the name" : null,
                    onSaveHandler: (input) => _serviceModel.name = input.trim(),
                    onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                  ),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          KeicyTextFormField(
            controller: _descriptionController,
            focusNode: _descriptionFocusNode,
            width: double.infinity,
            height: null,
            maxHeight: heightDp * 80,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red),
            borderRadius: heightDp * 6,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            label: "Description",
            labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            labelSpacing: heightDp * 5,
            hintText: "Description",
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            errorStringFontSize: fontSp * 10,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            onChangeHandler: (input) => _serviceModel.description = input.trim(),
            validatorHandler: (input) => (input.trim().isEmpty) ? "Please enter the name" : null,
            onSaveHandler: (input) => _serviceModel.description = input.trim(),
            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),

          ///
          SizedBox(height: heightDp * 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: _categoryController,
                  width: double.infinity,
                  height: null,
                  maxHeight: heightDp * 80,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  isImportant: true,
                  label: "Category",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Category",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  readOnly: true,
                  validatorHandler: (input) => (input.trim().isEmpty) ? "Select a category" : null,
                  onSaveHandler: (input) => _serviceModel.category = input.trim(),
                  onTapHandler: () async {
                    var result = await ItemSelectDialog.show(
                      context,
                      heading: "Category",
                      itemList: _storeDataProvider!.storeDataState.serviceCategoryList,
                    );
                    if (result != null) {
                      _categoryController.text = result;
                      setState(() {});
                    }
                  },
                ),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: KeicyTextFormField(
                  controller: _providedController,
                  width: double.infinity,
                  height: null,
                  maxHeight: heightDp * 80,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle:
                      TextStyle(fontSize: fontSp * 16, color: _providedController.text.isNotEmpty && !widget.isNew! ? Colors.grey : Colors.black),
                  isImportant: true,
                  label: "Service Provided Time",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Service Provided Time",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  readOnly: true,
                  validatorHandler: (input) => (input.trim().isEmpty) ? "Select a Service Provided Time" : null,
                  onSaveHandler: (input) => _serviceModel.provided = input.trim(),
                  onTapHandler: () async {
                    if (!widget.isNew!) return;
                    var result = await ItemSelectDialog.show(
                      context,
                      heading: "Service Provided Time",
                      itemList: _storeDataProvider!.storeDataState.serviceProvidedList,
                    );
                    if (result != null) {
                      _providedController.text = result;
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pricePanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Price Details",
            style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),

          ///
          SizedBox(height: heightDp * 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: _priceController,
                  focusNode: _priceFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  isImportant: true,
                  label: "Price(MRP) in INR",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Price(MRP) in INR",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  errorStringFontSize: fontSp * 10,
                  keyboardType: TextInputType.number,
                  prefixIcons: [
                    Text("₹", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                  ],
                  autovalidateMode: AutovalidateMode.always,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    _serviceModel.price = double.parse(input);
                    _priceHandler(isPrice: true);
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) {
                      return "Enter the price";
                    }
                    if (double.parse(input) < 0) return "Enter the price more than 0";

                    if (_sellingPriceController.text.trim().isNotEmpty &&
                        double.parse(_sellingPriceController.text.replaceAll("₹ ", "")) > double.parse(input.replaceAll("₹ ", ""))) {
                      return "Enter the price more than ${_serviceModel.priceAttributes!["selling"]}";
                    }

                    return null;
                  },
                  onSaveHandler: (input) {
                    if (input.isEmpty) return;
                    _serviceModel.price = double.parse(input);
                  },
                  onEditingCompleteHandler: () {
                    FocusScope.of(context).requestFocus(_discountFocusNode);
                  },
                ),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: KeicyTextFormField(
                  controller: _discountController,
                  focusNode: _discountFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: "Discount",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Discount",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  prefixIcons: [
                    Text("₹", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                  ],
                  autovalidateMode: AutovalidateMode.always,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    _serviceModel.discount = double.parse(input);
                    _priceHandler(isDiscount: true);
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) return "Enter the discount";
                    if (double.parse(input) < 0) return "Enter the price more than 0";
                    if (_priceController.text.isNotEmpty && _serviceModel.price! < double.parse(input))
                      return "Enter the price less than ${_priceController.text}";
                    return null;
                  },
                  onSaveHandler: (input) {
                    if (input.isEmpty)
                      _serviceModel.discount = 0;
                    else
                      _serviceModel.discount = double.parse(input);
                  },
                  onEditingCompleteHandler: () {
                    FocusScope.of(context).requestFocus(_sellingPriceFocusNode);
                  },
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: _sellingPriceController,
                  focusNode: _sellingPriceFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  isImportant: true,
                  label: "Selling Price",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Selling Price",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  prefixIcons: [
                    Text("₹", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                  ],
                  autovalidateMode: AutovalidateMode.always,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    if (_serviceModel.priceAttributes == null) {
                      _serviceModel.priceAttributes = Map<String, dynamic>();
                    }
                    _serviceModel.priceAttributes!["selling"] = double.parse(input);

                    if (_serviceModel.priceAttributes!["selling"] != null &&
                        _serviceModel.priceAttributes!["buying"] != null &&
                        _serviceModel.priceAttributes!["selling"] > _serviceModel.priceAttributes!["buying"]) {
                      _serviceModel.margin = double.parse(
                        numFormat.format(
                          (_serviceModel.priceAttributes!["selling"] - _serviceModel.priceAttributes!["buying"]) /
                              _serviceModel.priceAttributes!["selling"] *
                              100,
                        ),
                      );
                      _marginController.text = numFormat.format(_serviceModel.margin);
                    }
                    _priceHandler(isSelling: true);
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) {
                      return "Enter the selling price";
                    }

                    if (_priceController.text.trim().isNotEmpty &&
                        double.parse(_priceController.text.replaceAll("₹ ", "")) < double.parse(input.replaceAll("₹ ", ""))) {
                      return "Enter the price less than ${_serviceModel.price}";
                    }

                    if (double.parse(input) < 0) {
                      return "Enter the price more than 0";
                    }

                    return null;
                  },
                  onSaveHandler: (input) {
                    if (input.isEmpty) return;
                    if (_serviceModel.priceAttributes == null) {
                      _serviceModel.priceAttributes = Map<String, dynamic>();
                    }
                    _serviceModel.priceAttributes!["selling"] = double.parse(input);

                    if (_serviceModel.priceAttributes!["selling"] != null &&
                        _serviceModel.priceAttributes!["buying"] != null &&
                        _serviceModel.priceAttributes!["selling"] > _serviceModel.priceAttributes!["buying"]) {
                      _serviceModel.margin = double.parse(
                        numFormat.format(
                          (_serviceModel.priceAttributes!["selling"] - _serviceModel.priceAttributes!["buying"]) /
                              _serviceModel.priceAttributes!["selling"] *
                              100,
                        ),
                      );
                      _marginController.text = numFormat.format(_serviceModel.margin);
                    }
                  },
                  onEditingCompleteHandler: () {
                    FocusScope.of(context).requestFocus(_buyingPriceFocusNode);
                  },
                ),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: KeicyTextFormField(
                  controller: _buyingPriceController,
                  focusNode: _buyingPriceFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  isImportant: true,
                  label: "Buying Price",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Buying Price",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  prefixIcons: [
                    Text("₹", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                  ],
                  autovalidateMode: AutovalidateMode.always,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    if (_serviceModel.priceAttributes == null) {
                      _serviceModel.priceAttributes = Map<String, dynamic>();
                    }
                    _serviceModel.priceAttributes!["buying"] = double.parse(input);

                    if (_serviceModel.priceAttributes!["selling"] != null &&
                        _serviceModel.priceAttributes!["buying"] != null &&
                        _serviceModel.priceAttributes!["selling"] > _serviceModel.priceAttributes!["buying"]) {
                      _serviceModel.margin = double.parse(
                        numFormat.format(
                          (_serviceModel.priceAttributes!["selling"] - _serviceModel.priceAttributes!["buying"]) /
                              _serviceModel.priceAttributes!["selling"] *
                              100,
                        ),
                      );
                      _marginController.text = numFormat.format(_serviceModel.margin);
                    }
                    setState(() {});
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) return "Enter the buying price";

                    if (_sellingPriceController.text.isNotEmpty && double.parse(_sellingPriceController.text) < double.parse(input))
                      return "Enter the price less than ${double.parse(_sellingPriceController.text.replaceAll("₹ ", ""))}";

                    return null;
                  },
                  onSaveHandler: (input) {
                    if (input.isEmpty) return;
                    if (_serviceModel.priceAttributes == null) {
                      _serviceModel.priceAttributes = Map<String, dynamic>();
                    }
                    _serviceModel.priceAttributes!["buying"] = double.parse(input.replaceAll("₹ ", ""));

                    if (_serviceModel.priceAttributes!["selling"] != null &&
                        _serviceModel.priceAttributes!["buying"] != null &&
                        _serviceModel.priceAttributes!["selling"] > _serviceModel.priceAttributes!["buying"]) {
                      _serviceModel.margin = double.parse(
                        numFormat.format(
                          (_serviceModel.priceAttributes!["selling"] - _serviceModel.priceAttributes!["buying"]) /
                              _serviceModel.priceAttributes!["selling"] *
                              100,
                        ),
                      );
                      _marginController.text = numFormat.format(_serviceModel.margin);
                    }
                  },
                  onEditingCompleteHandler: () {
                    FocusScope.of(context).requestFocus(_taxFocusNode);
                  },
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 15),
          Text(
            "The Margin Amount is: ${_serviceModel.priceAttributes != null && _serviceModel.priceAttributes!["selling"] != null && _serviceModel.priceAttributes!["buying"] != null ? '₹ ' + numFormat.format(_serviceModel.priceAttributes!["selling"] - _serviceModel.priceAttributes!["buying"]) : ""}",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: heightDp * 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: _marginController,
                  focusNode: _marginFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: "Margin (%)",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Margin (%)",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KeicyDropDownFormField(
                      focusNode: _taxFocusNode,
                      width: double.infinity,
                      height: heightDp * 40,
                      menuItems: AppConfig.taxValues,
                      label: "Tax Percent (%)",
                      labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      labelSpacing: heightDp * 5,
                      value: _serviceModel.taxPercentage != null ? _serviceModel.taxPercentage : 0,
                      selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      border: Border.all(color: Colors.grey.withOpacity(0.6)),
                      borderRadius: heightDp * 6,
                      onChangeHandler: (value) {
                        _serviceModel.taxPercentage = double.parse(value.toString());
                      },
                    ),
                    SizedBox(height: heightDp * 3),
                    Text(
                      "Note: Prices are always tax inclusive, make sure you define your products/services prices accordingly.",
                      style: TextStyle(fontSize: fontSp * 9, color: Colors.black),
                    )
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: heightDp * 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: _cessPercentController,
                  focusNode: _cessPercentFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: "Sale Cess (%)",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Sale Cess (%)",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MaskTextInputFormatter(mask: '% ##.##', filter: {'#': RegExp(r'[0-9]')}),
                  ],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    if (_serviceModel.extraCharges == null) _serviceModel.extraCharges = Map<String, dynamic>();
                    if (_serviceModel.extraCharges!["cess"] == null) _serviceModel.extraCharges!["cess"] = Map<String, dynamic>();
                    _serviceModel.extraCharges!["cess"]["percentage"] = double.parse(input.replaceAll("% ", ""));
                  },
                  // validatorHandler: (input) {
                  //   if (input.trim().isEmpty) return "Please enter the tax";

                  //   return null;
                  // },
                  onSaveHandler: (input) {
                    if (input.trim().isEmpty) return;
                    if (_serviceModel.extraCharges == null) _serviceModel.extraCharges = Map<String, dynamic>();
                    if (_serviceModel.extraCharges!["cess"] == null) _serviceModel.extraCharges!["cess"] = Map<String, dynamic>();
                    _serviceModel.extraCharges!["cess"]["percentage"] = double.parse(input.replaceAll("% ", ""));
                  },
                  onEditingCompleteHandler: () {
                    FocusScope.of(context).requestFocus(_cessValueFocusNode);
                  },
                ),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: KeicyTextFormField(
                  controller: _cessValueController,
                  focusNode: _cessValueFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: "Sale Cess",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Sale Cess",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      decimalDigits: 2,
                      symbol: '₹ ',
                      turnOffGrouping: true,
                    ),
                  ],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    if (_serviceModel.extraCharges == null) _serviceModel.extraCharges = Map<String, dynamic>();
                    if (_serviceModel.extraCharges!["cess"] == null) _serviceModel.extraCharges!["cess"] = Map<String, dynamic>();
                    _serviceModel.extraCharges!["cess"]["value"] = double.parse(input.replaceAll("₹ ", ""));
                  },
                  // validatorHandler: (input) {
                  //   if (input.trim().isEmpty) return "Please enter the tax";

                  //   return null;
                  // },
                  onSaveHandler: (input) {
                    if (input.trim().isEmpty) return;
                    if (_serviceModel.extraCharges == null) _serviceModel.extraCharges = Map<String, dynamic>();
                    if (_serviceModel.extraCharges!["cess"] == null) _serviceModel.extraCharges!["cess"] = Map<String, dynamic>();
                    _serviceModel.extraCharges!["cess"]["value"] = double.parse(input.replaceAll("₹ ", ""));
                  },
                  onEditingCompleteHandler: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _b2bPricePanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "B2B Price Details",
            style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),

          // ///
          // SizedBox(height: heightDp * 15),
          // KeicyCheckBox(
          //   value: _serviceModel.b2bPriceType == null || _serviceModel.b2bPriceType == "Fixed" ? true : false,
          //   iconSize: heightDp * 25,
          //   iconColor: config.Colors().mainColor(1),
          //   label: "Fixed Amount",
          //   labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //   onChangeHandler: (value) {
          //     if (value)
          //       _serviceModel.b2bPriceType = "Fixed";
          //     else
          //       _serviceModel.b2bPriceType = "Range";

          //     setState(() {});
          //   },
          // ),

          ///
          SizedBox(height: heightDp * 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: KeicyTextFormField(
                  controller: _b2bPriceFromController,
                  focusNode: _b2bPriceFromFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: (_serviceModel.b2bPriceType == null || _serviceModel.b2bPriceType == "Fixed") ? "B2B Price" : "From Price(MRP)",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: (_serviceModel.b2bPriceType == null || _serviceModel.b2bPriceType == "Fixed") ? "B2B Price" : "From Price(MRP)",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  errorStringFontSize: fontSp * 10,
                  keyboardType: TextInputType.number,
                  prefixIcons: [
                    Text("₹", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                  ],
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) {
                    if (input.isEmpty) {
                      _serviceModel.b2bPriceFrom = 0;
                      _serviceModel.b2bDiscountValue = 0;
                      _b2bDiscountController.clear();
                      _serviceModel.b2bAcceptBulkOrder = false;
                      _serviceModel.b2bMinQuantityForBulkOrder = 0;
                      _b2bMinQuantityForBulkOrderController.clear();
                      _serviceModel.b2bTaxPercentage = 0;
                      _b2bTaxPercentageController.clear();
                    } else {
                      _serviceModel.b2bPriceFrom = double.parse(input);
                    }
                    RefreshProvider.of(context).refresh();
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) {
                      return null;
                    }
                    if (double.parse(input) < 0) return "Enter the price more than 0";

                    if (_serviceModel.b2bPriceType != null &&
                        _serviceModel.b2bPriceType != "Fixed" &&
                        _b2bPriceToController.text.isNotEmpty &&
                        _serviceModel.b2bPriceFrom! >= _serviceModel.b2bPriceTo!) {
                      return "Enter the price less than ${_serviceModel.b2bPriceTo}";
                    }

                    return null;
                  },
                  onSaveHandler: (input) {
                    if (input.isEmpty) return;
                    _serviceModel.b2bPriceFrom = double.parse(input);
                  },
                  onEditingCompleteHandler: () {
                    FocusScope.of(context).requestFocus(_b2bPriceToFocusNode);
                  },
                ),
              ),
              (_serviceModel.b2bPriceType == null || _serviceModel.b2bPriceType == "Fixed") ? SizedBox() : SizedBox(width: widthDp * 10),
              (_serviceModel.b2bPriceType == null || _serviceModel.b2bPriceType == "Fixed")
                  ? SizedBox()
                  : Expanded(
                      child: KeicyTextFormField(
                        controller: _b2bPriceToController,
                        focusNode: _b2bPriceToFocusNode,
                        width: double.infinity,
                        height: heightDp * 40,
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        errorBorder: Border.all(color: Colors.red),
                        borderRadius: heightDp * 6,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        label: "To Price(MRP)",
                        labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        labelSpacing: heightDp * 5,
                        hintText: "To Price(MRP)",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        errorStringFontSize: fontSp * 10,
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        keyboardType: TextInputType.number,
                        readOnly: (_serviceModel.b2bPriceType == null || _serviceModel.b2bPriceType == "Fixed"),
                        prefixIcons: [
                          Text("₹", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                        ],
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                        onChangeHandler: (input) {
                          if (input.isEmpty) return;
                          _serviceModel.b2bPriceTo = double.parse(input);
                        },
                        validatorHandler: (input) {
                          if (input.trim().isEmpty) {
                            return null;
                          }
                          if (double.parse(input) < 0) return "Enter the price more than 0";

                          if (_serviceModel.b2bPriceType != null &&
                              _serviceModel.b2bPriceType != "Fixed" &&
                              _b2bPriceFromController.text.isNotEmpty &&
                              _serviceModel.b2bPriceFrom! >= _serviceModel.b2bPriceTo!) {
                            return "Enter the price more than ${_serviceModel.b2bPriceFrom}";
                          }

                          return null;
                        },
                        onSaveHandler: (input) {
                          if (input.isEmpty) return;
                          _serviceModel.b2bPriceTo = double.parse(input);
                        },
                        onEditingCompleteHandler: () {
                          FocusScope.of(context).requestFocus(_b2bDiscountFocusNode);
                        },
                      ),
                    ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 10),
          Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KeicyDropDownFormField(
                    width: double.infinity,
                    height: heightDp * 40,
                    menuItems: [
                      {"text": "Amount", "value": "Amount"},
                      {"text": "Percentage", "value": "Percentage"},
                    ],
                    label: "DiscountType",
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    value: _serviceModel.b2bDiscountType ?? "Amount",
                    selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    borderRadius: heightDp * 6,
                    isDisabled: _b2bPriceFromController.text.isEmpty,
                    onChangeHandler: (value) {
                      _serviceModel.b2bDiscountType = value;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: widthDp * 10),
                Expanded(
                  child: KeicyTextFormField(
                    controller: _b2bDiscountController,
                    focusNode: _b2bDiscountFocusNode,
                    width: double.infinity,
                    height: heightDp * 40,
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    errorBorder: Border.all(color: Colors.red),
                    borderRadius: heightDp * 6,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    label: "Discount",
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    hintText: "Discount",
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                    errorStringFontSize: fontSp * 10,
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    keyboardType: TextInputType.number,
                    prefixIcons: [
                      Text(
                        _serviceModel.b2bDiscountType == null || _serviceModel.b2bDiscountType == "Amount" ? "₹" : "%",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                    ],
                    autovalidateMode: AutovalidateMode.always,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    readOnly: _b2bPriceFromController.text.isEmpty,
                    onChangeHandler: (input) {
                      if (input.isEmpty) return;
                      _serviceModel.b2bDiscountValue = double.parse(input);
                    },
                    validatorHandler: (input) {
                      if (input.trim().isEmpty) {
                        return null;
                      }
                      if (double.parse(input) < 0) return "Enter the price more than 0";
                      if (_serviceModel.b2bDiscountType == "Percentage" && double.parse(input) >= 100) {
                        return "Enter the price less than 100";
                      }

                      if (_b2bPriceFromController.text.isNotEmpty && _serviceModel.b2bPriceFrom! < double.parse(input)) {
                        return "Enter the price less than ${_b2bPriceFromController.text}";
                      }

                      if (_serviceModel.b2bPriceType != "Fixed" &&
                          _b2bPriceToController.text.isNotEmpty &&
                          _serviceModel.b2bPriceTo! < double.parse(input)) {
                        return "Enter the price less than ${_b2bPriceToController.text}";
                      }

                      return null;
                    },
                    onSaveHandler: (input) {
                      if (input.isEmpty) return;
                      _serviceModel.b2bDiscountValue = double.parse(input);
                    },
                    onEditingCompleteHandler: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              ],
            );
          }),

          ///
          SizedBox(height: heightDp * 15),
          Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
            return Row(
              children: [
                Expanded(
                  child: KeicyCheckBox(
                    value: _serviceModel.b2bAcceptBulkOrder ?? false,
                    iconSize: heightDp * 25,
                    iconColor: config.Colors().mainColor(1),
                    label: "Discount Applied\nif only bulk order",
                    labelSpacing: widthDp * 5,
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    readOnly: _b2bPriceFromController.text.isEmpty,
                    onChangeHandler: (value) {
                      _serviceModel.b2bAcceptBulkOrder = value;
                      _b2bMinQuantityForBulkOrderController.clear();
                      _serviceModel.b2bMinQuantityForBulkOrder = 0;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: widthDp * 10),
                Expanded(
                  child: KeicyTextFormField(
                    controller: _b2bMinQuantityForBulkOrderController,
                    focusNode: _b2bMinQuantityForBulkOrderFocusNode,
                    width: double.infinity,
                    height: heightDp * 40,
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    errorBorder: Border.all(color: Colors.red),
                    borderRadius: heightDp * 6,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    label: "BulkOrder Quantity",
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    hintText: "BulkOrder Quantity",
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                    errorStringFontSize: fontSp * 10,
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    readOnly: _b2bPriceFromController.text.isEmpty || !_serviceModel.b2bAcceptBulkOrder!,
                    onChangeHandler: (input) {
                      if (input.isEmpty) return;
                      _serviceModel.b2bMinQuantityForBulkOrder = double.parse(input);
                    },
                    validatorHandler: (input) {
                      if (_serviceModel.b2bAcceptBulkOrder != null && _serviceModel.b2bAcceptBulkOrder! && input.trim().isEmpty)
                        return "Enter the Min Quantity";
                      if (input.isEmpty) return null;
                      if (double.parse(input) < 0) return "Enter the price more than 0";

                      return null;
                    },
                    onSaveHandler: (input) {
                      if (input.isEmpty) return;
                      _serviceModel.b2bMinQuantityForBulkOrder = double.parse(input);
                    },
                    onEditingCompleteHandler: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              ],
            );
          }),

          ///
          SizedBox(height: heightDp * 10),
          Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: KeicyDropDownFormField(
                    width: double.infinity,
                    height: heightDp * 40,
                    menuItems: [
                      {"text": "Inclusive", "value": "Inclusive"},
                      {"text": "Exclusive", "value": "Exclusive"},
                    ],
                    label: "Tax Type",
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    value: _serviceModel.b2bTaxType ?? "Inclusive",
                    selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    borderRadius: heightDp * 6,
                    isDisabled: _b2bPriceFromController.text.isEmpty,
                    onChangeHandler: (value) {
                      _serviceModel.b2bTaxType = value;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: widthDp * 10),
                Expanded(
                  child: KeicyTextFormField(
                    controller: _b2bTaxPercentageController,
                    focusNode: _b2bTaxPercentageFocusNode,
                    width: double.infinity,
                    height: heightDp * 40,
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    errorBorder: Border.all(color: Colors.red),
                    borderRadius: heightDp * 6,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    label: "Tax Percentage",
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    hintText: "Tax Percentage",
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                    errorStringFontSize: fontSp * 10,
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    keyboardType: TextInputType.number,
                    prefixIcons: [
                      Text(
                        "%",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                    ],
                    autovalidateMode: AutovalidateMode.always,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    readOnly: _b2bPriceFromController.text.isEmpty,
                    onChangeHandler: (input) {
                      if (input.isEmpty) return;
                      _serviceModel.b2bTaxPercentage = double.parse(input);
                    },
                    validatorHandler: (input) {
                      if (input.trim().isEmpty) {
                        return null;
                      }
                      if (double.parse(input) < 0) return "Enter the value more than 0";
                      if (double.parse(input) >= 100) return "Enter the value less than 100";

                      return null;
                    },
                    onSaveHandler: (input) {
                      if (input.isEmpty) return;
                      _serviceModel.b2bTaxPercentage = double.parse(input);
                    },
                    onEditingCompleteHandler: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _bargainDetail() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bargain Details",
            style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyCheckBox(
            iconSize: heightDp * 25,
            trueIconColor: config.Colors().mainColor(1),
            falseIconColor: Colors.grey,
            label: "Bargain Available",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            labelSpacing: widthDp * 10,
            value: _serviceModel.bargainAvailable!,
            onChangeHandler: (value) {
              _serviceModel.bargainAvailable = value;

              _serviceModel.bargainAttributes = null;
              setState(() {});
            },
          ),

          ///
          if (_serviceModel.bargainAvailable!)
            Column(
              children: [
                SizedBox(height: heightDp * 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: KeicyTextFormField(
                        controller: _bargainMinAmountController,
                        focusNode: _bargainMinAmountFocusNode,
                        width: double.infinity,
                        height: heightDp * 40,
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        errorBorder: Border.all(color: Colors.red),
                        borderRadius: heightDp * 6,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        label: "Min Amount",
                        labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        labelSpacing: heightDp * 5,
                        hintText: "Min Amount",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        errorStringFontSize: fontSp * 10,
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                            decimalDigits: 2,
                            symbol: '₹ ',
                            turnOffGrouping: true,
                          ),
                        ],
                        readOnly: !_serviceModel.bargainAvailable!,
                        onChangeHandler: (input) {
                          if (_serviceModel.bargainAttributes == null) _serviceModel.bargainAttributes = Map<String, dynamic>();
                          _serviceModel.bargainAttributes!["minAmount"] = double.parse(input.replaceAll("₹ ", ""));
                        },
                        validatorHandler: (input) {
                          if (input.trim().isEmpty) return "Please enter the min Amount";

                          return null;
                        },
                        onSaveHandler: (input) {
                          if (_serviceModel.bargainAttributes == null) _serviceModel.bargainAttributes = Map<String, dynamic>();
                          _serviceModel.bargainAttributes!["minAmount"] = double.parse(input.replaceAll("₹ ", ""));
                        },
                        onEditingCompleteHandler: () {
                          FocusScope.of(context).requestFocus(_bargainMinQuantityFocusNode);
                        },
                      ),
                    ),
                    SizedBox(width: widthDp * 10),
                    Expanded(
                      child: KeicyTextFormField(
                        controller: _bargainMinQuantityController,
                        focusNode: _bargainMinQuantityFocusNode,
                        width: double.infinity,
                        height: heightDp * 40,
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        errorBorder: Border.all(color: Colors.red),
                        borderRadius: heightDp * 6,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        label: "Min Quantity",
                        labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        labelSpacing: heightDp * 5,
                        hintText: "Min Quantity",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        errorStringFontSize: fontSp * 10,
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
                        ],
                        readOnly: !_serviceModel.bargainAvailable!,
                        onChangeHandler: (input) {
                          if (_serviceModel.bargainAttributes == null) _serviceModel.bargainAttributes = Map<String, dynamic>();
                          _serviceModel.bargainAttributes!["minQuantity"] = double.parse(input.replaceAll("₹ ", ""));
                        },
                        validatorHandler: (input) {
                          if (input.trim().isEmpty) return "Please enter the min Quantity";

                          return null;
                        },
                        onSaveHandler: (input) {
                          if (_serviceModel.bargainAttributes == null) _serviceModel.bargainAttributes = Map<String, dynamic>();
                          _serviceModel.bargainAttributes!["minQuantity"] = double.parse(input.replaceAll("₹ ", ""));
                        },
                        onEditingCompleteHandler: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _attributesDetail() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Custom Fields",
            style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "+ Define your own custom fields for your store services.",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          ),
          SizedBox(height: heightDp * 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeicyRaisedButton(
                width: widthDp * 170,
                height: heightDp * 40,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 8,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                child: Text(
                  "Add CustomField",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: () async {
                  var result = await CustomAttributesDialog.show(context);

                  if (result != null) {
                    if (_serviceModel.attributes == null) _serviceModel.attributes = [];
                    _serviceModel.attributes!.add(result);
                    setState(() {});
                  }
                },
              ),
            ],
          ),
          _serviceModel.attributes == null || _serviceModel.attributes!.length == 0 ? SizedBox() : SizedBox(height: heightDp * 10),
          _serviceModel.attributes == null || _serviceModel.attributes!.length == 0 ? SizedBox() : Divider(color: Colors.grey.withOpacity(0.6)),
          _serviceModel.attributes == null || _serviceModel.attributes!.length == 0
              ? SizedBox()
              : Column(
                  children: List.generate(
                    _serviceModel.attributes!.length,
                    (index) {
                      Map<String, dynamic> attributes = _serviceModel.attributes![index];

                      if (attributes["type"] == null) return SizedBox();

                      return GestureDetector(
                        child: Column(
                          children: [
                            ProductAttributeWidget(
                              attributes: attributes,
                              editHandler: (attributes) {
                                if (attributes != null) {
                                  _serviceModel.attributes![index] = attributes;
                                  setState(() {});
                                }
                              },
                              deleteHandler: () {
                                _serviceModel.attributes!.removeAt(index);
                                setState(() {});
                              },
                            ),
                            Divider(color: Colors.grey.withOpacity(0.6))
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _otherPanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Images & Other Details",
            style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyCheckBox(
            iconSize: heightDp * 25,
            trueIconColor: config.Colors().mainColor(1),
            falseIconColor: Colors.grey,
            label: "Service Available",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            labelSpacing: widthDp * 10,
            value: _serviceModel.isAvailable!,
            onChangeHandler: (value) {
              _serviceModel.isAvailable = value;
              setState(() {});
            },
          ),
          SizedBox(height: heightDp * 20),
          KeicyCheckBox(
            iconSize: heightDp * 25,
            trueIconColor: config.Colors().mainColor(1),
            falseIconColor: Colors.grey,
            label: "List Online",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            labelSpacing: widthDp * 10,
            value: _serviceModel.listonline!,
            onChangeHandler: (value) {
              _serviceModel.listonline = value;
              setState(() {});
            },
          ),
          SizedBox(height: heightDp * 20),
          KeicyCheckBox(
            iconSize: heightDp * 25,
            trueIconColor: config.Colors().mainColor(1),
            falseIconColor: Colors.grey,
            label: "Display Price To Customer",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            labelSpacing: widthDp * 10,
            value: _serviceModel.showPriceToUsers!,
            onChangeHandler: (value) {
              _serviceModel.showPriceToUsers = value;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _imagePanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeicyRaisedButton(
                width: widthDp * 120,
                height: heightDp * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 8,
                child: Text("Add Image", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                onPressed: _selectOptionBottomSheet,
              ),
            ],
          ),
          SizedBox(height: heightDp * 20),
          Container(
            width: deviceWidth,
            child: Wrap(
              spacing: widthDp * 10,
              runSpacing: heightDp * 10,
              children: List.generate(_serviceModel.images!.length + _imageFiles.length, (index) {
                String url = "";
                File? imageFile;
                if (index < _serviceModel.images!.length) {
                  url = _serviceModel.images![index];
                } else if (index >= _serviceModel.images!.length && _imageFiles.isNotEmpty) {
                  int length = _serviceModel.images!.length;
                  imageFile = _imageFiles[index - length];
                }

                return Column(
                  children: [
                    Container(
                      width: heightDp * 80,
                      height: heightDp * 80,
                      child: KeicyAvatarImage(
                        url: url,
                        width: heightDp * 80,
                        height: heightDp * 80,
                        imageFile: imageFile,
                        backColor: Colors.grey.withOpacity(0.6),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (index >= _serviceModel.images!.length) {
                          int length = _serviceModel.images!.length;
                          _imageFiles.removeAt(index - length);
                          setState(() {});
                        } else {
                          NormalAskDialog.show(
                            context,
                            content: "Are you sure to delete this image",
                            callback: () {
                              _serviceModel.images!.removeAt(index);
                              setState(() {});
                            },
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(heightDp * 5),
                        color: Colors.transparent,
                        child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _selectOptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(heightDp * 8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: deviceWidth,
                    padding: EdgeInsets.all(heightDp * 10.0),
                    child: Text(
                      "Choose Option",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _getAvatarImage(ImageSource.camera);
                    },
                    child: Container(
                      width: deviceWidth,
                      padding: EdgeInsets.all(heightDp * 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt,
                            color: Colors.black.withOpacity(0.7),
                            size: heightDp * 25.0,
                          ),
                          SizedBox(width: widthDp * 10.0),
                          Text(
                            "From Camera",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _getAvatarImage(ImageSource.gallery);
                    },
                    child: Container(
                      width: deviceWidth,
                      padding: EdgeInsets.all(heightDp * 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.photo, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                          SizedBox(width: widthDp * 10.0),
                          Text(
                            "From Gallery",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future _getAvatarImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, maxWidth: 500, maxHeight: 500);

    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
    } else {
      FlutterLogs.logInfo(
        "new_service_view",
        "_getAvatarImage",
        "No image selected.",
      );
    }
  }
}
