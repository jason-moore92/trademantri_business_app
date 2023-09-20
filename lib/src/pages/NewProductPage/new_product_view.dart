import 'dart:convert';
import 'dart:io';

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
import 'package:trapp/src/pages/ProductStockListPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class NewProductView extends StatefulWidget {
  final String? type;
  final bool? isNew;
  final ProductModel? productModel;

  NewProductView({Key? key, this.type, this.isNew, this.productModel}) : super(key: key);

  @override
  _NewProductViewState createState() => _NewProductViewState();
}

class _NewProductViewState extends State<NewProductView> with SingleTickerProviderStateMixin {
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
  TextEditingController _productIdentifyController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _quantityTypeController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _stockAvailableController = TextEditingController();
  TextEditingController _racklocationController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _sellingPriceController = TextEditingController();
  TextEditingController _buyingPriceController = TextEditingController();
  TextEditingController _marginController = TextEditingController();
  TextEditingController _cessPercentController = TextEditingController();
  TextEditingController _cessValueController = TextEditingController();
  TextEditingController _bargainMinQuantityController = TextEditingController();
  TextEditingController _bargainMinAmountController = TextEditingController();
  TextEditingController _bulkMinQuantityController = TextEditingController();
  TextEditingController _b2bPriceFromController = TextEditingController();
  TextEditingController _b2bPriceToController = TextEditingController();
  TextEditingController _b2bDiscountController = TextEditingController();
  TextEditingController _b2bMinQuantityForBulkOrderController = TextEditingController();
  TextEditingController _b2bTaxPercentageController = TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _productIdentifyNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _quantityFocusNode = FocusNode();
  FocusNode _stockAvailableFocusNode = FocusNode();
  FocusNode _racklocationFocusNode = FocusNode();
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
  FocusNode _bulkMinQuantityFocusNode = FocusNode();
  FocusNode _b2bPriceFromFocusNode = FocusNode();
  FocusNode _b2bPriceToFocusNode = FocusNode();
  FocusNode _b2bDiscountFocusNode = FocusNode();
  FocusNode _b2bMinQuantityForBulkOrderFocusNode = FocusNode();
  FocusNode _b2bTaxPercentageFocusNode = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProductModel _productModel = ProductModel();

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

    _productModel.storeId = AuthProvider.of(context).authState.storeModel!.id;
    _productModel.discount = 0;
    _productModel.bargainAvailable = true;
    _productModel.acceptBulkOrder = false;
    _productModel.isAvailable = true;
    _productModel.listonline = true;
    _productModel.showPriceToUsers = true;
    _productModel.taxPercentage = 0;
    _productModel.minQuantityForBulkOrder = 0;
    _productModel.taxPercentage = 0;
    _productModel.isDeleted = false;
    _productModel.images = [];
    _discountController.text = "0";
    _b2bDiscountController.text = "0";

    if (!widget.isNew! && widget.productModel != null) {
      _productModel = ProductModel.copy(widget.productModel!);
      _productModel.images = _productModel.images ?? [];

      _nameController.text = _productModel.name ?? "";
      _categoryController.text = _productModel.category ?? "";
      _brandController.text = _productModel.brand ?? "";
      _quantityController.text = _productModel.quantity != null ? _productModel.quantity.toString() : "";
      _quantityTypeController.text = _productModel.quantityType ?? "";
      _descriptionController.text = _productModel.description ?? "";
      _productIdentifyController.text = _productModel.productIdentificationCode ?? "";
      _racklocationController.text = _productModel.racklocation ?? "";
      _stockAvailableController.text = _productModel.stockavailable != null ? _productModel.stockavailable.toString() : "";
      _priceController.text = _productModel.price.toString();
      _discountController.text = _productModel.discount.toString();
      _sellingPriceController.text = (_productModel.priceAttributes != null && _productModel.priceAttributes!["selling"] != null)
          ? _productModel.priceAttributes!["selling"].toString()
          : "";
      _buyingPriceController.text = (_productModel.priceAttributes != null && _productModel.priceAttributes!["buying"] != null)
          ? _productModel.priceAttributes!["buying"].toString()
          : "";
      _marginController.text = _productModel.margin != null ? _productModel.margin.toString() : "";
      _cessPercentController.text = (_productModel.extraCharges != null &&
              _productModel.extraCharges!["cess"] != null &&
              _productModel.extraCharges!["cess"]["percentage"] != null)
          ? _productModel.extraCharges!["cess"]["percentage"].toString()
          : "";
      _cessValueController.text =
          (_productModel.extraCharges != null && _productModel.extraCharges!["cess"] != null && _productModel.extraCharges!["cess"]["value"] != null)
              ? _productModel.extraCharges!["cess"]["value"].toString()
              : "";
      _bargainMinAmountController.text = (_productModel.bargainAttributes != null && _productModel.bargainAttributes!["minAmount"] != null)
          ? _productModel.bargainAttributes!["minAmount"].toString()
          : "";
      _bargainMinQuantityController.text = (_productModel.bargainAttributes != null && _productModel.bargainAttributes!["minQuantity"] != null)
          ? _productModel.bargainAttributes!["minQuantity"].toString()
          : "";
      _bulkMinQuantityController.text =
          (_productModel.acceptBulkOrder! && _productModel.minQuantityForBulkOrder != null) ? _productModel.minQuantityForBulkOrder.toString() : "";
      if (_productModel.attributes == null) _productModel.attributes = [];
      List<dynamic> attributes = [];
      for (var i = 0; i < _productModel.attributes!.length; i++) {
        if (_productModel.attributes![i]["type"] != "" && _productModel.attributes![i]["type"] != null) {
          attributes.add(_productModel.attributes![i]);
        }
      }
      _productModel.attributes = attributes;

      //////
      if (_productModel.b2bPriceFrom != null) _b2bPriceFromController.text = _productModel.b2bPriceFrom.toString();
      if (_productModel.b2bPriceTo != null) _b2bPriceToController.text = _productModel.b2bPriceTo.toString();
      if (_productModel.b2bDiscountValue != null) _b2bDiscountController.text = _productModel.b2bDiscountValue.toString();
      if (_productModel.b2bMinQuantityForBulkOrder != null)
        _b2bMinQuantityForBulkOrderController.text = _productModel.b2bMinQuantityForBulkOrder.toString();
      if (_productModel.b2bTaxPercentage != null) _b2bTaxPercentageController.text = _productModel.b2bTaxPercentage.toString();
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (!widget.isNew! && widget.productModel != null) {
        _priceHandler(isPrice: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _priceHandler({bool isPrice = false, bool isDiscount = false, bool isSelling = false}) {
    if (_productModel.price == null) return;
    if (_productModel.priceAttributes == null) {
      _productModel.priceAttributes = Map<String, dynamic>();
    }

    if (isDiscount) {
      _productModel.priceAttributes!["selling"] = double.parse((_productModel.price! - _productModel.discount!).toStringAsFixed(2));
      _priceController.text = numFormat.format(_productModel.price);
      _sellingPriceController.text = numFormat.format(_productModel.priceAttributes!["selling"]);
    }

    if (isSelling && _productModel.price! >= _productModel.priceAttributes!["selling"]) {
      _productModel.discount = double.parse((_productModel.price! - _productModel.priceAttributes!["selling"]).toStringAsFixed(2));
      _priceController.text = numFormat.format(_productModel.price);
      _discountController.text = numFormat.format(_productModel.discount);
    }

    if (isPrice) {
      _productModel.priceAttributes!["selling"] = double.parse((_productModel.price! - _productModel.discount!).toStringAsFixed(2));
      _discountController.text = numFormat.format(_productModel.discount);
      _sellingPriceController.text = numFormat.format(_productModel.priceAttributes!["selling"]);
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

    await _keicyProgressDialog!.show();
    var result;
    if (_imageFiles.isNotEmpty) {
      var result = await ProductApiProvider.uploadImage(
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
      _productModel.images!.addAll(result["data"]);
    }

    if (widget.isNew!) {
      result = await ProductApiProvider.addProduct(
        productData: _productModel.toJson(),
        token: AuthProvider.of(context).authState.businessUserModel!.token,
        isNew: widget.isNew,
      );
    } else {
      result = await ProductApiProvider.addProduct(
        productData: _productModel.toJson(),
        token: AuthProvider.of(context).authState.businessUserModel!.token,
        isNew: widget.isNew,
      );
    }

    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      List<dynamic> productCategoryList = StoreDataProvider.of(context).storeDataState.productCategoryList!;
      List<dynamic> productBrandList = StoreDataProvider.of(context).storeDataState.productBrandList!;

      if (!productCategoryList.contains(_productModel.category)) {
        productCategoryList.add(_productModel.category);
      }

      if (!productBrandList.contains(_productModel.brand)) {
        productBrandList.add(_productModel.brand);
      }

      StoreDataProvider.of(context).setStoreDataState(
        StoreDataProvider.of(context).storeDataState.update(
              productCategoryList: productCategoryList,
              productBrandList: productBrandList,
            ),
      );

      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: widget.isNew! ? "Create Success" : "Update Success!",
        callBack: () {
          Navigator.of(context).pop({
            "category": _productModel.category,
            "brand": _productModel.brand,
          });
        },
      );
      _productModel.id = result["oid"];
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
            widget.isNew! ? "New Product" : "Edit Product",
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
                    _bulkOrderPanel(),
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
                    isImportant: true,
                    label: "Name",
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    labelSpacing: heightDp * 5,
                    hintText: "Name",
                    textCapitalization: TextCapitalization.words,
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                    errorStringFontSize: fontSp * 10,
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    readOnly: !widget.isNew!,
                    textInputAction: TextInputAction.newline,
                    onChangeHandler: (input) => _productModel.name = input.trim(),
                    validatorHandler: (input) => (input.trim().isEmpty) ? "Enter the name" : null,
                    onSaveHandler: (input) => _productModel.name = input.trim(),
                    onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                  ),
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
                  controller: _productIdentifyController,
                  focusNode: _productIdentifyNode,
                  width: double.infinity,
                  height: null,
                  maxHeight: heightDp * 80,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: "SKU",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "SKU",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  textInputAction: TextInputAction.newline,
                  onChangeHandler: (input) => _productModel.productIdentificationCode = input.trim(),
                  // validatorHandler: (input) => (input.trim().isEmpty) ? "Enter the name" : null,
                  onSaveHandler: (input) => _productModel.productIdentificationCode = input.trim(),
                  onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_descriptionFocusNode),
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
            isImportant: true,
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
            onChangeHandler: (input) => _productModel.description = input.trim(),
            validatorHandler: (input) => (input.trim().isEmpty) ? "Enter the name" : null,
            onSaveHandler: (input) => _productModel.description = input.trim(),
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
                  onSaveHandler: (input) => _productModel.category = input.trim(),
                  onTapHandler: () async {
                    var result = await ItemSelectDialog.show(
                      context,
                      heading: "Category",
                      itemList: _storeDataProvider!.storeDataState.productCategoryList,
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
                  controller: _brandController,
                  width: double.infinity,
                  height: null,
                  maxHeight: heightDp * 80,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  isImportant: true,
                  label: "Brand",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Brand",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  readOnly: true,
                  validatorHandler: (input) => (input.trim().isEmpty) ? "Select a brand" : null,
                  onSaveHandler: (input) => _productModel.brand = input.trim(),
                  onTapHandler: () async {
                    var result = await ItemSelectDialog.show(
                      context,
                      heading: "Brand",
                      itemList: _storeDataProvider!.storeDataState.productBrandList,
                    );
                    if (result != null) {
                      _brandController.text = result;
                      setState(() {});
                    }
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
                  controller: _quantityController,
                  focusNode: _quantityFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  isImportant: true,
                  label: "Quantity",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Quantity",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
                  ],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    _productModel.quantity = double.parse(input.trim());
                  },
                  validatorHandler: (input) => (input.trim().isEmpty) ? "Enter the quantity" : null,
                  onSaveHandler: (input) => _productModel.quantity = double.parse(input.trim()),
                  onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
                ),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: KeicyTextFormField(
                  controller: _quantityTypeController,
                  width: double.infinity,
                  height: null,
                  maxHeight: heightDp * 80,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle:
                      TextStyle(fontSize: fontSp * 16, color: _quantityTypeController.text.isNotEmpty && !widget.isNew! ? Colors.grey : Colors.black),
                  isImportant: true,
                  label: "Quantity Type",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Quantity Type",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  readOnly: true,
                  validatorHandler: (input) => (input.trim().isEmpty) ? "Select a quantity type" : null,
                  onSaveHandler: (input) => _productModel.quantityType = input.trim(),
                  onTapHandler: () async {
                    if (_quantityTypeController.text.isNotEmpty && !widget.isNew!) return;
                    var result = await ItemSelectDialog.show(
                      context,
                      heading: "Quantity Type",
                      itemList: AppConfig.quantityTypeList,
                    );
                    if (result != null) {
                      _quantityTypeController.text = result;
                      setState(() {});
                    }
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
                  controller: _racklocationController,
                  focusNode: _racklocationFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  label: "Rack Location",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Rack Location",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  onChangeHandler: (input) {
                    _productModel.racklocation = input.trim();
                  },
                  // validatorHandler: (input) => (input.trim().isEmpty) ? "Enter the rack location" : null,
                  onSaveHandler: (input) => _productModel.racklocation = input.trim(),
                  onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_stockAvailableFocusNode),
                ),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: KeicyTextFormField(
                  controller: _stockAvailableController,
                  focusNode: _stockAvailableFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  isImportant: true,
                  label: "Total Stock Available",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: "Total Stock Available",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) => _productModel.stockavailable = double.parse(input.trim()),
                  validatorHandler: (input) => (input.trim().isEmpty) ? "Enter the stock" : null,
                  onSaveHandler: (input) => _productModel.stockavailable = double.parse(input.trim()),
                  onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_priceFocusNode),
                ),
              ),
            ],
          ),

          // if (!widget.isNew!) ...[
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       InkWell(
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(
          //             vertical: 8.0,
          //           ),
          //           child: Text(
          //             "Inventory",
          //             style: TextStyle(
          //               decoration: TextDecoration.underline,
          //               color: Colors.blue,
          //             ),
          //           ),
          //         ),
          //         onTap: () {
          //           _detailHandler(_productModel);
          //         },
          //       ),
          //     ],
          //   )
          // ]
        ],
      ),
    );
  }

  void _detailHandler(ProductModel? product) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ProductStockListPage(
          haveAppBar: true,
          product: product,
        ),
      ),
    );
    if (result != null && result) {
      // _onRefresh();
    }
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
                    _productModel.price = double.parse(input);
                    _priceHandler(isPrice: true);
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) {
                      return "Enter the price";
                    }
                    if (double.parse(input) < 0) return "Enter the price more than 0";

                    if (_sellingPriceController.text.trim().isNotEmpty &&
                        double.parse(_sellingPriceController.text.replaceAll("₹ ", "")) > double.parse(input.replaceAll("₹ ", ""))) {
                      return "Enter the price more than ${_productModel.priceAttributes!["selling"]}";
                    }

                    return null;
                  },
                  onSaveHandler: (input) {
                    _productModel.price = double.parse(input);
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
                    _productModel.discount = double.parse(input);
                    _priceHandler(isDiscount: true);
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) return "Enter the discount";
                    if (double.parse(input) < 0) return "Enter the price more than 0";
                    if (_priceController.text.isNotEmpty && _productModel.price! < double.parse(input))
                      return "Enter the price less than ${_priceController.text}";
                    return null;
                  },
                  onSaveHandler: (input) {
                    _productModel.discount = double.parse(input);
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
                    if (_productModel.priceAttributes == null) {
                      _productModel.priceAttributes = Map<String, dynamic>();
                    }
                    _productModel.priceAttributes!["selling"] = double.parse(input);

                    if (_productModel.priceAttributes!["selling"] != null &&
                        _productModel.priceAttributes!["buying"] != null &&
                        _productModel.priceAttributes!["selling"] >= _productModel.priceAttributes!["buying"]) {
                      _productModel.margin = double.parse(
                        numFormat.format(
                          (_productModel.priceAttributes!["selling"] - _productModel.priceAttributes!["buying"]) /
                              _productModel.priceAttributes!["selling"] *
                              100,
                        ),
                      );
                      _marginController.text = numFormat.format(_productModel.margin);
                    }
                    _priceHandler(isSelling: true);
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) {
                      return "Enter the selling price";
                    }

                    if (_priceController.text.trim().isNotEmpty &&
                        double.parse(_priceController.text.replaceAll("₹ ", "")) < double.parse(input.replaceAll("₹ ", ""))) {
                      return "Enter the price less than ${_productModel.price}";
                    }

                    if (double.parse(input) < 0) {
                      return "Enter the price more than 0";
                    }

                    return null;
                  },
                  onSaveHandler: (input) {
                    if (input.isEmpty) return;
                    if (_productModel.priceAttributes == null) {
                      _productModel.priceAttributes = Map<String, dynamic>();
                    }
                    _productModel.priceAttributes!["selling"] = double.parse(input);

                    if (_productModel.priceAttributes!["selling"] != null &&
                        _productModel.priceAttributes!["buying"] != null &&
                        _productModel.priceAttributes!["selling"] >= _productModel.priceAttributes!["buying"]) {
                      _productModel.margin = double.parse(
                        numFormat.format(
                          (_productModel.priceAttributes!["selling"] - _productModel.priceAttributes!["buying"]) /
                              _productModel.priceAttributes!["selling"] *
                              100,
                        ),
                      );
                      _marginController.text = numFormat.format(_productModel.margin);
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
                    if (_productModel.priceAttributes == null) {
                      _productModel.priceAttributes = Map<String, dynamic>();
                    }
                    _productModel.priceAttributes!["buying"] = double.parse(input);

                    if (_productModel.priceAttributes!["selling"] != null &&
                        _productModel.priceAttributes!["buying"] != null &&
                        _productModel.priceAttributes!["selling"] >= _productModel.priceAttributes!["buying"]) {
                      _productModel.margin = double.parse(
                        numFormat.format(
                          (_productModel.priceAttributes!["selling"] - _productModel.priceAttributes!["buying"]) /
                              _productModel.priceAttributes!["selling"] *
                              100,
                        ),
                      );
                      _marginController.text = numFormat.format(_productModel.margin);
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
                    if (input.trim().isEmpty) return;
                    if (_productModel.priceAttributes == null) {
                      _productModel.priceAttributes = Map<String, dynamic>();
                    }
                    _productModel.priceAttributes!["buying"] = double.parse(input.replaceAll("₹ ", ""));

                    if (_productModel.priceAttributes!["selling"] != null &&
                        _productModel.priceAttributes!["buying"] != null &&
                        _productModel.priceAttributes!["selling"] >= _productModel.priceAttributes!["buying"]) {
                      _productModel.margin = double.parse(
                        numFormat.format(
                          (_productModel.priceAttributes!["selling"] - _productModel.priceAttributes!["buying"]) /
                              _productModel.priceAttributes!["selling"] *
                              100,
                        ),
                      );
                      _marginController.text = numFormat.format(_productModel.margin);
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
            "The Margin Amount is: ${_productModel.priceAttributes != null && _productModel.priceAttributes!["selling"] != null && _productModel.priceAttributes!["buying"] != null ? '₹ ' + numFormat.format(_productModel.priceAttributes!["selling"] - _productModel.priceAttributes!["buying"]) : ""}",
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
                  prefixIcons: [
                    Text("%", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                  ],
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
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
                      value: !widget.isNew! && _productModel.taxPercentage != null ? _productModel.taxPercentage : 0,
                      selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      border: Border.all(color: Colors.grey.withOpacity(0.6)),
                      borderRadius: heightDp * 6,
                      onChangeHandler: (value) {
                        _productModel.taxPercentage = double.parse(value.toString());
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
                  hintText: "Sale Cess",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  errorStringFontSize: fontSp * 10,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  prefixIcons: [
                    Text("%", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                  ],
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    if (_productModel.extraCharges == null) _productModel.extraCharges = Map<String, dynamic>();
                    if (_productModel.extraCharges!["cess"] == null) _productModel.extraCharges!["cess"] = Map<String, dynamic>();
                    _productModel.extraCharges!["cess"]["percentage"] = double.parse(input.replaceAll("% ", ""));
                  },
                  // validatorHandler: (input) {
                  //   if (input.trim().isEmpty) return "Enter the tax";

                  //   return null;
                  // },
                  onSaveHandler: (input) {
                    if (input.trim().isEmpty) return;
                    if (_productModel.extraCharges == null) _productModel.extraCharges = Map<String, dynamic>();
                    if (_productModel.extraCharges!["cess"] == null) _productModel.extraCharges!["cess"] = Map<String, dynamic>();
                    _productModel.extraCharges!["cess"]["percentage"] = double.parse(input.replaceAll("% ", ""));
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
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  onChangeHandler: (input) {
                    if (input.isEmpty) return;
                    if (_productModel.extraCharges == null) _productModel.extraCharges = Map<String, dynamic>();
                    if (_productModel.extraCharges!["cess"] == null) _productModel.extraCharges!["cess"] = Map<String, dynamic>();
                    _productModel.extraCharges!["cess"]["value"] = double.parse(input.replaceAll("₹ ", ""));
                  },
                  // validatorHandler: (input) {
                  //   if (input.trim().isEmpty) return "Enter the tax";

                  //   return null;
                  // },
                  onSaveHandler: (input) {
                    if (input.trim().isEmpty) return;
                    if (_productModel.extraCharges == null) _productModel.extraCharges = Map<String, dynamic>();
                    if (_productModel.extraCharges!["cess"] == null) _productModel.extraCharges!["cess"] = Map<String, dynamic>();
                    _productModel.extraCharges!["cess"]["value"] = double.parse(input.replaceAll("₹ ", ""));
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
          //   value: _productModel.b2bPriceType == null || _productModel.b2bPriceType == "Fixed" ? true : false,
          //   iconSize: heightDp * 25,
          //   iconColor: config.Colors().mainColor(1),
          //   label: "Fixed Amount",
          //   labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //   onChangeHandler: (value) {
          //     if (value)
          //       _productModel.b2bPriceType = "Fixed";
          //     else
          //       _productModel.b2bPriceType = "Range";

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
                  label: (_productModel.b2bPriceType == null || _productModel.b2bPriceType == "Fixed") ? "B2B Price" : "From Price(MRP)",
                  labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  labelSpacing: heightDp * 5,
                  hintText: (_productModel.b2bPriceType == null || _productModel.b2bPriceType == "Fixed") ? "B2B Price" : "From Price(MRP)",
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
                      _productModel.b2bPriceFrom = 0;
                      _productModel.b2bDiscountValue = 0;
                      _b2bDiscountController.clear();
                      _productModel.b2bAcceptBulkOrder = false;
                      _productModel.b2bMinQuantityForBulkOrder = 0;
                      _b2bMinQuantityForBulkOrderController.clear();
                      _productModel.b2bTaxPercentage = 0;
                      _b2bTaxPercentageController.clear();
                    } else {
                      _productModel.b2bPriceFrom = double.parse(input);
                    }
                    RefreshProvider.of(context).refresh();
                  },
                  validatorHandler: (input) {
                    if (input.trim().isEmpty) {
                      return null;
                    }
                    if (double.parse(input) < 0) return "Enter the price more than 0";

                    if (_productModel.b2bPriceType != null &&
                        _productModel.b2bPriceType != "Fixed" &&
                        _b2bPriceToController.text.isNotEmpty &&
                        _productModel.b2bPriceFrom! >= _productModel.b2bPriceTo!) {
                      return "Enter the price less than ${_productModel.b2bPriceTo}";
                    }

                    return null;
                  },
                  onSaveHandler: (input) {
                    if (input.isEmpty) return;
                    _productModel.b2bPriceFrom = double.parse(input);
                  },
                  onEditingCompleteHandler: () {
                    FocusScope.of(context).requestFocus(_b2bPriceToFocusNode);
                  },
                ),
              ),
              (_productModel.b2bPriceType == null || _productModel.b2bPriceType == "Fixed") ? SizedBox() : SizedBox(width: widthDp * 10),
              (_productModel.b2bPriceType == null || _productModel.b2bPriceType == "Fixed")
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
                        readOnly: (_productModel.b2bPriceType == null || _productModel.b2bPriceType == "Fixed"),
                        prefixIcons: [
                          Text("₹", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                        ],
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                        onChangeHandler: (input) {
                          if (input.isEmpty) return;
                          _productModel.b2bPriceTo = double.parse(input);
                        },
                        validatorHandler: (input) {
                          if (input.trim().isEmpty) {
                            return null;
                          }
                          if (double.parse(input) < 0) return "Enter the price more than 0";

                          if (_productModel.b2bPriceType != null &&
                              _productModel.b2bPriceType != "Fixed" &&
                              _b2bPriceFromController.text.isNotEmpty &&
                              _productModel.b2bPriceFrom! >= _productModel.b2bPriceTo!) {
                            return "Enter the price more than ${_productModel.b2bPriceFrom}";
                          }

                          return null;
                        },
                        onSaveHandler: (input) {
                          if (input.isEmpty) return;
                          _productModel.b2bPriceTo = double.parse(input);
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
                    value: _productModel.b2bDiscountType ?? "Amount",
                    selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    borderRadius: heightDp * 6,
                    isDisabled: _b2bPriceFromController.text.isEmpty,
                    onChangeHandler: (value) {
                      _productModel.b2bDiscountType = value;
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
                    readOnly: _b2bPriceFromController.text.isEmpty,
                    prefixIcons: [
                      Text(
                        _productModel.b2bDiscountType == null || _productModel.b2bDiscountType == "Amount" ? "₹" : "%",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                    ],
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    onChangeHandler: (input) {
                      if (input.isEmpty) return;
                      _productModel.b2bDiscountValue = double.parse(input);
                    },
                    validatorHandler: (input) {
                      if (input.trim().isEmpty) {
                        return null;
                      }
                      if (double.parse(input) < 0) return "Enter the price more than 0";
                      if (_productModel.b2bDiscountType == "Percentage" && double.parse(input) >= 100) {
                        return "Enter the price less than 100";
                      }

                      if (_b2bPriceFromController.text.isNotEmpty && _productModel.b2bPriceFrom! < double.parse(input)) {
                        return "Enter the price less than ${_b2bPriceFromController.text}";
                      }

                      if (_productModel.b2bPriceType != "Fixed" &&
                          _b2bPriceToController.text.isNotEmpty &&
                          _productModel.b2bPriceTo! < double.parse(input)) {
                        return "Enter the price less than ${_b2bPriceToController.text}";
                      }

                      return null;
                    },
                    onSaveHandler: (input) {
                      if (input.isEmpty) return;
                      _productModel.b2bDiscountValue = double.parse(input);
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
                  flex: 2,
                  child: KeicyCheckBox(
                    value: _productModel.b2bAcceptBulkOrder ?? false,
                    iconSize: heightDp * 25,
                    iconColor: config.Colors().mainColor(1),
                    label: "Discount Applied\nif only bulk order",
                    labelSpacing: widthDp * 5,
                    labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    readOnly: _b2bPriceFromController.text.isEmpty,
                    onChangeHandler: (value) {
                      _productModel.b2bAcceptBulkOrder = value;
                      _b2bMinQuantityForBulkOrderController.clear();
                      _productModel.b2bMinQuantityForBulkOrder = 0;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: widthDp * 10),
                Expanded(
                  flex: 2,
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
                    readOnly: _b2bPriceFromController.text.isEmpty || !_productModel.b2bAcceptBulkOrder!,
                    onChangeHandler: (input) {
                      if (input.isEmpty) return;
                      _productModel.b2bMinQuantityForBulkOrder = double.parse(input);
                    },
                    validatorHandler: (input) {
                      if (_productModel.b2bAcceptBulkOrder != null && _productModel.b2bAcceptBulkOrder! && input.trim().isEmpty)
                        return "Enter the Min Quantity";
                      if (input.isEmpty) return null;
                      if (double.parse(input) < 0) return "Enter the price more than 0";

                      return null;
                    },
                    onSaveHandler: (input) {
                      if (input.isEmpty) return;
                      _productModel.b2bMinQuantityForBulkOrder = double.parse(input);
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
                    value: _productModel.b2bTaxType ?? "Inclusive",
                    selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    borderRadius: heightDp * 6,
                    isDisabled: _b2bPriceFromController.text.isEmpty,
                    onChangeHandler: (value) {
                      _productModel.b2bTaxType = value;
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
                      _productModel.b2bTaxPercentage = double.parse(input);
                      setState(() {});
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
                      _productModel.b2bTaxPercentage = double.parse(input);
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
            value: _productModel.bargainAvailable!,
            onChangeHandler: (value) {
              _productModel.bargainAvailable = value;

              _productModel.bargainAttributes = null;
              setState(() {});
            },
          ),

          ///
          if (_productModel.bargainAvailable!)
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
                        isImportant: true,
                        label: "Min Amount",
                        labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        labelSpacing: heightDp * 5,
                        hintText: "Min Amount",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        errorStringFontSize: fontSp * 10,
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        keyboardType: TextInputType.number,
                        prefixIcons: [
                          Text("₹", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                        ],
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                        readOnly: !_productModel.bargainAvailable!,
                        onChangeHandler: (input) {
                          if (_productModel.bargainAttributes == null) _productModel.bargainAttributes = Map<String, dynamic>();
                          _productModel.bargainAttributes!["minAmount"] = double.parse(input.replaceAll("₹ ", ""));
                        },
                        // validatorHandler: (input) {
                        //   if (input.trim().isEmpty) return "Enter the min Amount";

                        //   return null;
                        // },
                        onSaveHandler: (input) {
                          if (input.isEmpty) return;
                          if (_productModel.bargainAttributes == null) _productModel.bargainAttributes = Map<String, dynamic>();
                          _productModel.bargainAttributes!["minAmount"] = double.parse(input.replaceAll("₹ ", ""));
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
                        isImportant: true,
                        label: "Min Quantity",
                        labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        labelSpacing: heightDp * 5,
                        hintText: "Min Quantity",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        errorStringFontSize: fontSp * 10,
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                        readOnly: !_productModel.bargainAvailable!,
                        onChangeHandler: (input) {
                          if (_productModel.bargainAttributes == null) _productModel.bargainAttributes = Map<String, dynamic>();
                          _productModel.bargainAttributes!["minQuantity"] = double.parse(input.replaceAll("₹ ", ""));
                        },
                        // validatorHandler: (input) {
                        //   if (input.trim().isEmpty) return "Enter the min Quantity";

                        //   return null;
                        // },
                        onSaveHandler: (input) {
                          if (input.isEmpty) return;
                          if (_productModel.bargainAttributes == null) _productModel.bargainAttributes = Map<String, dynamic>();
                          _productModel.bargainAttributes!["minQuantity"] = double.parse(input.replaceAll("₹ ", ""));
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
            "+ Define your own custom fields for your store products.",
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
                    if (_productModel.attributes == null) _productModel.attributes = [];
                    _productModel.attributes!.add(result);
                    setState(() {});
                  }
                },
              ),
            ],
          ),
          _productModel.attributes == null || _productModel.attributes!.length == 0 ? SizedBox() : SizedBox(height: heightDp * 10),
          _productModel.attributes == null || _productModel.attributes!.length == 0 ? SizedBox() : Divider(color: Colors.grey.withOpacity(0.6)),
          _productModel.attributes == null || _productModel.attributes!.length == 0
              ? SizedBox()
              : Column(
                  children: List.generate(
                    _productModel.attributes!.length,
                    (index) {
                      Map<String, dynamic> attributes = _productModel.attributes![index];

                      if (attributes["type"] == null) return SizedBox();

                      return GestureDetector(
                        child: Column(
                          children: [
                            ProductAttributeWidget(
                              attributes: attributes,
                              editHandler: (attributes) {
                                if (attributes != null) {
                                  _productModel.attributes![index] = attributes;
                                  setState(() {});
                                }
                              },
                              deleteHandler: () {
                                _productModel.attributes!.removeAt(index);
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

  Widget _bulkOrderPanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bulk Order Details",
            style: TextStyle(fontSize: fontSp * 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyCheckBox(
            iconSize: heightDp * 25,
            trueIconColor: config.Colors().mainColor(1),
            falseIconColor: Colors.grey,
            label: "Bulk Order Available",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            labelSpacing: widthDp * 10,
            value: _productModel.acceptBulkOrder!,
            onChangeHandler: (value) {
              _productModel.acceptBulkOrder = value;
              _productModel.minQuantityForBulkOrder = 0;
              setState(() {});
            },
          ),

          if (_productModel.acceptBulkOrder!)
            Column(
              children: [
                SizedBox(height: heightDp * 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: KeicyTextFormField(
                        controller: _bulkMinQuantityController,
                        focusNode: _bulkMinQuantityFocusNode,
                        width: double.infinity,
                        height: heightDp * 40,
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        errorBorder: Border.all(color: Colors.red),
                        borderRadius: heightDp * 6,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        isImportant: true,
                        label: "Min Quantity Bulk Order",
                        labelStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        labelSpacing: heightDp * 5,
                        hintText: "Min Quantity Bulk Order",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        errorStringFontSize: fontSp * 10,
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
                        ],
                        readOnly: !_productModel.acceptBulkOrder!,
                        onChangeHandler: (input) {
                          _productModel.minQuantityForBulkOrder = double.parse(input.replaceAll("₹ ", ""));
                        },
                        validatorHandler: (input) {
                          if (input.trim().isEmpty) return "Enter the min Quantity";

                          return null;
                        },
                        onSaveHandler: (input) {
                          _productModel.minQuantityForBulkOrder = double.parse(input.replaceAll("₹ ", ""));
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
            label: "Product Available",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            labelSpacing: widthDp * 10,
            value: _productModel.isAvailable!,
            onChangeHandler: (value) {
              _productModel.isAvailable = value;
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
            value: _productModel.listonline!,
            onChangeHandler: (value) {
              _productModel.listonline = value;
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
            value: _productModel.showPriceToUsers!,
            onChangeHandler: (value) {
              _productModel.showPriceToUsers = value;
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
              children: List.generate(_productModel.images!.length + _imageFiles.length, (index) {
                String url = "";
                File? imageFile;
                if (index < _productModel.images!.length) {
                  url = _productModel.images![index];
                } else if (index >= _productModel.images!.length && _imageFiles.isNotEmpty) {
                  int length = _productModel.images!.length;
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
                        if (index >= _productModel.images!.length) {
                          int length = _productModel.images!.length;
                          _imageFiles.removeAt(index - length);
                          setState(() {});
                        } else {
                          NormalAskDialog.show(
                            context,
                            content: "Are you sure to delete this image",
                            callback: () {
                              _productModel.images!.removeAt(index);
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
        "new_product_view",
        "_getAvatarImage",
        "No image selected.",
      );
    }
  }
}
