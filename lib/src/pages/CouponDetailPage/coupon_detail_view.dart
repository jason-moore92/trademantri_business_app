import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_item_for_coupon_widget.dart';
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/elements/servicce_item_for_coupon_widget.dart';
import 'package:trapp/src/elements/service_item_for_selection_widget.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BusinessStoresPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/pages/NewCustomerForChatPage/index.dart';
import 'package:trapp/src/pages/ProductListPage/index.dart';
import 'package:trapp/src/pages/ServiceListPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import '../../elements/keicy_progress_dialog.dart';

class CouponDetailView extends StatefulWidget {
  final bool? isNew;
  final CouponModel? couponModel;

  CouponDetailView({Key? key, this.isNew, this.couponModel}) : super(key: key);

  @override
  _CouponDetailViewState createState() => _CouponDetailViewState();
}

class _CouponDetailViewState extends State<CouponDetailView> with SingleTickerProviderStateMixin {
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

  AuthProvider? _authProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _discountCodeController = TextEditingController();
  TextEditingController _discountValueController = TextEditingController();
  TextEditingController _discountMaxAmountController = TextEditingController();
  TextEditingController _discountBuyQuantityController = TextEditingController();
  TextEditingController _discountGetQuantityController = TextEditingController();
  TextEditingController _discountGetPercentValueController = TextEditingController();
  TextEditingController _minReqAmountController = TextEditingController();
  TextEditingController _minReqQuantityController = TextEditingController();
  TextEditingController _limitNumberController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _termsController = TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _discountCodeFocusNode = FocusNode();
  FocusNode _discountValueFocusNode = FocusNode();
  FocusNode _discountMaxAmountFocusNode = FocusNode();
  FocusNode _discountBuyQuantityFocusNode = FocusNode();
  FocusNode _discountGetQuantityFocusNode = FocusNode();
  FocusNode _discountGetPercentValueFocusNode = FocusNode();
  FocusNode _minReqAmountFocusNode = FocusNode();
  FocusNode _minReqQuantityFocusNode = FocusNode();
  FocusNode _limitNumberCodeFocusNode = FocusNode();
  FocusNode _startDateFocusNode = FocusNode();
  FocusNode _endDateFocusNode = FocusNode();
  FocusNode _termsFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  CouponModel? _couponModel;

  List<dynamic> _selectedCustomerData = [];
  List<dynamic> _selectedCustomerIds = [];

  List<dynamic> _selectedBusinessData = [];
  List<dynamic> _selectedBusinessIds = [];

  List<ProductModel> _appliedSelectedProducts = [];
  List<dynamic> _appliedSelectedProductIds = [];
  List<ServiceModel> _appliedSelectedServices = [];
  List<dynamic> _appliedSelectedServiceIds = [];

  List<dynamic> _appliedProductCategoryList = [];
  List<dynamic> _appliedServiceCategoryList = [];

  List<ProductModel> _discountBuyProducts = [];
  List<dynamic> _discountBuyProductIds = [];
  List<ServiceModel> _discountBuyServices = [];
  List<dynamic> _discountBuyServiceIds = [];
  List<ProductModel> _discountGetProducts = [];
  List<dynamic> _discountGetProductIds = [];
  List<ServiceModel> _discountGetServices = [];
  List<dynamic> _discountGetServiceIds = [];

  ImagePicker picker = ImagePicker();
  List<File> _imageFiles = [];

  bool? _isNew;
  Map<String, dynamic> _isUpdatedData = {
    "isUpdated": false,
  };

  DateTime? _startDate;
  DateTime? _endDate;

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

    _authProvider = AuthProvider.of(context);

    _couponModel = widget.couponModel ?? CouponModel();

    _isNew = widget.isNew;

    if (_isNew!) {
      _couponModel!.discountType = AppConfig.discountTypeForCoupon[0]["value"];
      _couponModel!.appliedFor = AppConfig.appliesToForCoupon[0]["value"];
      _couponModel!.minimumRequirements = AppConfig.minRequirementsForCoupon[0]["value"];
      _couponModel!.customerEligibility =
          _couponModel!.customerEligibility != "" ? _couponModel!.customerEligibility : AppConfig.customerEligibilityForCoupon[0]["value"];
      _couponModel!.businessEligibility =
          _couponModel!.businessEligibility != "" ? _couponModel!.businessEligibility : AppConfig.businessEligibilityForCoupon[0]["value"];
      _couponModel!.eligibility = _couponModel!.eligibility != "" ? _couponModel!.eligibility : AppConfig.eligibilityForCoupon[0]["value"];
      _couponModel!.usageLimits = AppConfig.usageLimitsForCoupon[0]["value"];
      _couponModel!.images = [];
      _discountGetQuantityController.text = "1";
      _minReqAmountController.text = "0";
      _minReqQuantityController.text = "1";

      if (_couponModel!.specificCustomers!.isNotEmpty) {
        _selectedCustomerData = _couponModel!.specificCustomers!;
        for (var i = 0; i < _selectedCustomerData.length; i++) {
          _selectedCustomerIds.add(_selectedCustomerData[i]["_id"]);
        }
      }

      if (_couponModel!.specificBusinesses!.isNotEmpty) {
        _selectedBusinessData = _couponModel!.specificBusinesses!;
        for (var i = 0; i < _selectedBusinessData.length; i++) {
          _selectedBusinessIds.add(_selectedBusinessData[i]["_id"]);
        }
      }
    } else if (!_isNew! && widget.couponModel != null) {
      _couponModel = CouponModel.copy(widget.couponModel!);

      _couponModel!.customerEligibility =
          _couponModel!.customerEligibility != "" ? _couponModel!.customerEligibility : AppConfig.customerEligibilityForCoupon[0]["value"];
      _couponModel!.businessEligibility =
          _couponModel!.businessEligibility != "" ? _couponModel!.businessEligibility : AppConfig.businessEligibilityForCoupon[0]["value"];
      _couponModel!.eligibility = _couponModel!.eligibility != "" ? _couponModel!.eligibility : AppConfig.eligibilityForCoupon[0]["value"];

      _nameController.text = _couponModel!.name!;
      _descriptionController.text = _couponModel!.description!;
      _discountCodeController.text = _couponModel!.discountCode!;
      if (_couponModel!.discountData != null && _couponModel!.discountData!["discountValue"] != null) {
        _discountValueController.text = _couponModel!.discountData!["discountValue"].toString();
      }
      if (_couponModel!.discountData != null && _couponModel!.discountData!["discountMaxAmount"] != null) {
        _discountMaxAmountController.text = _couponModel!.discountData!["discountMaxAmount"].toString();
      }
      if (_couponModel!.discountData != null && _couponModel!.discountData!["customerBogo"]["buy"]["products"].isNotEmpty ||
          _couponModel!.discountData!["customerBogo"]["buy"]["services"].isNotEmpty ||
          _couponModel!.discountData!["customerBogo"]["get"]["products"].isNotEmpty ||
          _couponModel!.discountData!["customerBogo"]["get"]["services"].isNotEmpty) {
        _discountBuyProducts = [];
        _discountBuyServices = [];
        _discountGetProducts = [];
        _discountGetServices = [];

        if (_couponModel!.discountData!["customerBogo"]["buy"]["products"] != null) {
          for (var i = 0; i < _couponModel!.discountData!["customerBogo"]["buy"]["products"].length; i++) {
            if (_couponModel!.discountData!["customerBogo"]["buy"]["products"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
              _discountBuyProducts.add(ProductModel.fromJson(_couponModel!.discountData!["customerBogo"]["buy"]["products"][i]));
              _discountBuyProductIds.add(_couponModel!.discountData!["customerBogo"]["buy"]["products"][i]["_id"]);
            } else {
              _discountBuyProducts.add(_couponModel!.discountData!["customerBogo"]["buy"]["products"][i]);
              _discountBuyProductIds.add(_couponModel!.discountData!["customerBogo"]["buy"]["products"][i].productModel.id);
            }
          }
        }

        if (_couponModel!.discountData!["customerBogo"]["buy"]["services"] != null) {
          for (var i = 0; i < _couponModel!.discountData!["customerBogo"]["buy"]["services"].length; i++) {
            if (_couponModel!.discountData!["customerBogo"]["buy"]["services"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
              _discountBuyServices.add(ServiceModel.fromJson(_couponModel!.discountData!["customerBogo"]["buy"]["services"][i]));
              _discountBuyServiceIds.add(_couponModel!.discountData!["customerBogo"]["buy"]["services"][i]["_id"]);
            } else {
              _discountBuyServices.add(_couponModel!.discountData!["customerBogo"]["buy"]["services"][i]);
              _discountBuyServiceIds.add(_couponModel!.discountData!["customerBogo"]["buy"]["services"][i].serviceModel.id);
            }
          }
        }

        if (_couponModel!.discountData!["customerBogo"]["get"]["products"] != null) {
          for (var i = 0; i < _couponModel!.discountData!["customerBogo"]["get"]["products"].length; i++) {
            if (_couponModel!.discountData!["customerBogo"]["get"]["products"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
              _discountGetProducts.add(ProductModel.fromJson(_couponModel!.discountData!["customerBogo"]["get"]["products"][i]));
              _discountGetProductIds.add(_couponModel!.discountData!["customerBogo"]["get"]["products"][i]["_id"]);
            } else {
              _discountGetProducts.add(_couponModel!.discountData!["customerBogo"]["get"]["products"][i]);
              _discountGetProductIds.add(_couponModel!.discountData!["customerBogo"]["get"]["products"][i].productModel.id);
            }
          }
        }

        if (_couponModel!.discountData!["customerBogo"]["get"]["services"] != null) {
          for (var i = 0; i < _couponModel!.discountData!["customerBogo"]["get"]["services"].length; i++) {
            if (_couponModel!.discountData!["customerBogo"]["get"]["services"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
              _discountGetServices.add(ServiceModel.fromJson(_couponModel!.discountData!["customerBogo"]["get"]["services"][i]));
              _discountGetServiceIds.add(_couponModel!.discountData!["customerBogo"]["get"]["services"][i]["_id"]);
            } else {
              _discountGetServices.add(_couponModel!.discountData!["customerBogo"]["get"]["services"][i]);
              _discountGetServiceIds.add(_couponModel!.discountData!["customerBogo"]["get"]["services"][i].serviceModel.id);
            }
          }
        }

        _discountBuyQuantityController.text = _couponModel!.discountData!["customerBogo"]["buy"]["quantity"] != null
            ? _couponModel!.discountData!["customerBogo"]["buy"]["quantity"].toString()
            : "";
        _discountGetQuantityController.text = _couponModel!.discountData!["customerBogo"]["get"]["quantity"] != null
            ? _couponModel!.discountData!["customerBogo"]["get"]["quantity"].toString()
            : "1";
        _discountGetPercentValueController.text = _couponModel!.discountData!["customerBogo"]["get"]["percentValue"] != null
            ? _couponModel!.discountData!["customerBogo"]["get"]["percentValue"].toString()
            : "";
      }

      _appliedProductCategoryList = _couponModel!.appliedData!["appliedCategories"]["productCategories"] != null
          ? _couponModel!.appliedData!["appliedCategories"]["productCategories"]
          : [];
      _appliedServiceCategoryList = _couponModel!.appliedData!["appliedCategories"]["serviceCategories"] != null
          ? _couponModel!.appliedData!["appliedCategories"]["serviceCategories"]
          : [];

      _appliedSelectedProducts = [];
      if (_couponModel!.appliedData!["appliedItems"]["products"] != null) {
        for (var i = 0; i < _couponModel!.appliedData!["appliedItems"]["products"].length; i++) {
          if (_couponModel!.appliedData!["appliedItems"]["products"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
            _appliedSelectedProducts.add(ProductModel.fromJson(_couponModel!.appliedData!["appliedItems"]["products"][i]));
            _appliedSelectedProductIds.add(_couponModel!.appliedData!["appliedItems"]["products"][i]["_id"]);
          } else {
            _discountBuyServices.add(_couponModel!.appliedData!["appliedItems"]["products"][i]);
            _discountBuyServiceIds.add(_couponModel!.discountData!["customerBogo"]["buy"]["services"][i].serviceModel.id);
          }
        }
      }

      _appliedSelectedServices = [];
      if (_couponModel!.appliedData!["appliedItems"]["services"] != null) {
        for (var i = 0; i < _couponModel!.appliedData!["appliedItems"]["services"].length; i++) {
          if (_couponModel!.appliedData!["appliedItems"]["services"][i].runtimeType.toString().contains("Map<String, dynamic>")) {
            _appliedSelectedServices.add(ServiceModel.fromJson(_couponModel!.appliedData!["appliedItems"]["services"][i]));
            _appliedSelectedServiceIds.add(_couponModel!.appliedData!["appliedItems"]["services"][i]["_id"]);
          } else {
            _appliedSelectedServices.add(_couponModel!.appliedData!["appliedItems"]["services"][i]);
            _appliedSelectedServiceIds.add(_couponModel!.appliedData!["appliedItems"]["services"][i]["_id"]);
          }
        }
      }

      _minReqAmountController.text = _couponModel!.minimumAmount != null ? _couponModel!.minimumAmount.toString() : "";
      _minReqQuantityController.text = _couponModel!.minimumQuantity != null ? _couponModel!.minimumQuantity.toString() : "";

      _limitNumberController.text = _couponModel!.limitNumbers != null ? _couponModel!.limitNumbers.toString() : "";

      _selectedCustomerData = _couponModel!.specificCustomers != null ? _couponModel!.specificCustomers! : [];
      for (var i = 0; i < _selectedCustomerData.length; i++) {
        _selectedCustomerIds.add(_selectedCustomerData[i]["_id"]);
      }

      _selectedBusinessData = _couponModel!.specificBusinesses != null ? _couponModel!.specificBusinesses! : [];
      for (var i = 0; i < _selectedBusinessData.length; i++) {
        _selectedBusinessIds.add(_selectedBusinessData[i]["_id"]);
      }

      _termsController.text = _couponModel!.terms != null ? _couponModel!.terms! : "";

      _couponModel!.images = _couponModel!.images != null ? _couponModel!.images : [];

      _startDate = _couponModel!.startDate!.toLocal();
      _startDateController.text = KeicyDateTime.convertDateTimeToDateString(
        dateTime: _startDate,
        isUTC: false,
      );
      if (_couponModel!.endDate != null) {
        _endDate = _couponModel!.endDate!.toLocal();
        _endDateController.text = KeicyDateTime.convertDateTimeToDateString(
          dateTime: _endDate,
          isUTC: false,
        );
      }
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if (StoreDataProvider.of(context).storeDataState.progressState != 2) {
        StoreDataProvider.of(context).init(
          storeSubType: AuthProvider.of(context).authState.storeModel!.subType,
          storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _jobPostHandler() async {
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

    _formkey.currentState!.save();

    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();

    _couponModel!.images = _couponModel!.images ?? [];
    if (_imageFiles.isNotEmpty) {
      for (var i = 0; i < _imageFiles.length; i++) {
        var result = await UploadFileApiProvider.uploadFile(
          file: _imageFiles[i],
          directoryName: "Coupons/",
          fileName: DateTime.now().millisecondsSinceEpoch.toString(),
          bucketName: "COUPONS_BUCKET",
        );

        if (result["success"]) {
          _couponModel!.images!.add(result["data"]);
        }
      }
    }

    _couponModel = CouponModel.fromJson({
      "_id": _couponModel!.id,
      "name": _nameController.text.trim(),
      "description": _descriptionController.text.trim(),
      "discountCode": _discountCodeController.text.trim(),
      "discountType": _couponModel!.discountType,
      "discountData": {
        "discountValue": _discountValueController.text.trim(),
        "discountMaxAmount": _discountMaxAmountController.text.trim(),
        "customerBogo": {
          "buy": {
            // "products": _discountBuyProducts,
            "products": _discountBuyProductIds,
            // "services": _discountBuyServices,
            "services": _discountBuyServiceIds,
            "quantity": _discountBuyQuantityController.text.trim(),
          },
          "get": {
            // "products": _discountGetProducts,
            "products": _discountGetProductIds,
            // "services": _discountGetServices,
            "services": _discountGetServiceIds,
            "quantity": _discountGetQuantityController.text.trim(),
            // "quantity": "1",
            "type": _couponModel!.discountData!["customerBogo"]["get"]["type"],
            "percentValue": _discountGetPercentValueController.text.trim(),
          },
        },
      },
      "appliedFor": _couponModel!.appliedFor,
      "appliedData": {
        "appliedCategories": {
          "productCategories": _appliedProductCategoryList,
          "serviceCategories": _appliedServiceCategoryList,
        },
        "appliedItems": {
          // "products": _appliedSelectedProducts,
          "products": _appliedSelectedProductIds,
          // "services": _appliedSelectedServices,
          "services": _appliedSelectedServiceIds,
        },
      },
      "minimumRequirements": _couponModel!.minimumRequirements,
      "minimumAmount": _minReqAmountController.text != "" ? double.parse(_minReqAmountController.text.trim()) : null,
      "minimumQuantity": _minReqQuantityController.text != "" ? double.parse(_minReqQuantityController.text.trim()) : null,
      "customerEligibility": _couponModel!.customerEligibility,
      "businessEligibility": _couponModel!.businessEligibility,
      "eligibility": _couponModel!.eligibility,
      "specificCustomers": _couponModel!.customerEligibility == AppConfig.customerEligibilityForCoupon[0]["value"] ? [] : _selectedCustomerIds,
      // "specificCustomers": _selectedCustomerData,
      "specificBusinesses": _couponModel!.businessEligibility == AppConfig.businessEligibilityForCoupon[0]["value"] ? [] : _selectedBusinessIds,
      // "specificBusinesses": _selectedBusinessData,
      "usageLimits": _couponModel!.usageLimits,
      "limitNumbers": _limitNumberController.text.trim() != "" ? int.parse(_limitNumberController.text.trim()) : null,
      "startDate": _startDate!.toUtc().toIso8601String(),
      "endDate": _endDate != null ? (_endDate!.add(Duration(days: 1)).subtract(Duration(seconds: 1))).toUtc().toIso8601String() : null,
      "terms": _termsController.text.trim(),
      "images": _couponModel!.images,
      "enabled": true,
    });

    _couponModel!.storeId = _authProvider!.authState.storeModel!.id;

    var result;
    if (_isNew!) {
      result = await CouponsApiProvider.addCoupons(couponModel: _couponModel);
    } else {
      result = await CouponsApiProvider.updateCoupons(couponModel: _couponModel);
    }
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _couponModel!.discountData!["customerBogo"]["buy"]["products"] = _discountBuyProducts;
      _couponModel!.discountData!["customerBogo"]["buy"]["services"] = _discountBuyServices;
      _couponModel!.discountData!["customerBogo"]["get"]["products"] = _discountGetProducts;
      _couponModel!.discountData!["customerBogo"]["get"]["services"] = _discountGetServices;
      _couponModel!.appliedData!["appliedItems"]["products"] = _appliedSelectedProducts;
      _couponModel!.appliedData!["appliedItems"]["services"] = _appliedSelectedServices;
      _couponModel!.specificCustomers = _selectedCustomerData;
      _couponModel!.specificBusinesses = _selectedBusinessData;

      _couponModel!.id = result["data"]["_id"];
      _isNew = false;
      _isUpdatedData = {
        "isUpdated": true,
        "couponModel": _couponModel,
      };
      setState(() {});

      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp, callBack: () {
        Navigator.of(context).pop(_isUpdatedData);
      });
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
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_isUpdatedData);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop(_isUpdatedData);
            },
          ),
          centerTitle: true,
          title: Text(
            _isNew! ? "New Coupon" : "Edit Coupon",
            style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Consumer<StoreDataProvider>(builder: (context, storeDataProvider, _) {
          if (storeDataProvider.storeDataState.progressState == 0 || storeDataProvider.storeDataState.progressState == 1) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (storeDataProvider.storeDataState.progressState == -1) {
            return ErrorPage(
              message: storeDataProvider.storeDataState.message,
              callback: () {
                storeDataProvider.setStoreDataState(storeDataProvider.storeDataState.update(progressState: 1));
                storeDataProvider.init(
                  storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
                  storeSubType: AuthProvider.of(context).authState.storeModel!.subType,
                );
              },
            );
          }
          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();

              return false;
            },
            child: SingleChildScrollView(
              child: Container(
                width: deviceWidth,
                padding: EdgeInsets.symmetric(vertical: heightDp * 10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: KeicyTextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          width: double.infinity,
                          height: heightDp * 40,
                          border: Border.all(color: Colors.grey.withOpacity(0.7)),
                          errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                          borderRadius: heightDp * 6,
                          contentHorizontalPadding: widthDp * 10,
                          contentVerticalPadding: heightDp * 8,
                          isImportant: true,
                          label: "Name",
                          labelSpacing: heightDp * 5,
                          labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                          textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          hintText: "coupon name",
                          hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                          validatorHandler: (input) => input.isEmpty ? "Please enter name" : null,
                          onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                          onSaveHandler: (input) => _couponModel!.name = input.trim(),
                          onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                        ),
                      ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: KeicyTextFormField(
                          controller: _descriptionController,
                          focusNode: _descriptionFocusNode,
                          width: double.infinity,
                          height: heightDp * 100,
                          // maxHeight: heightDp * 100,
                          border: Border.all(color: Colors.grey.withOpacity(0.7)),
                          errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                          borderRadius: heightDp * 6,
                          contentHorizontalPadding: widthDp * 10,
                          contentVerticalPadding: heightDp * 8,
                          isImportant: true,
                          label: "Description",
                          labelSpacing: heightDp * 5,
                          labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                          textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          hintText: "Description",
                          hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: null,
                          validatorHandler: (input) => input.isEmpty ? "Please enter description" : null,
                          onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                          onSaveHandler: (input) => _couponModel!.description = input.trim(),
                          onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_discountCodeFocusNode),
                        ),
                      ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: KeicyTextFormField(
                          controller: _discountCodeController,
                          focusNode: _discountCodeFocusNode,
                          width: double.infinity,
                          height: heightDp * 40,
                          border: Border.all(color: Colors.grey.withOpacity(0.7)),
                          errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                          borderRadius: heightDp * 6,
                          contentHorizontalPadding: widthDp * 10,
                          contentVerticalPadding: heightDp * 8,
                          isImportant: true,
                          label: "Discount Code",
                          labelSpacing: heightDp * 5,
                          labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                          textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          hintText: "Discount Code",
                          hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                          onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                          validatorHandler: (input) => input.isEmpty ? "Please enter discount code" : null,
                          onSaveHandler: (input) => _couponModel!.discountCode = input.trim(),
                          onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                        ),
                      ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: _discountTypePanel(),
                      ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: _appliedToPanel(),
                      ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: _minimumRequirementPanel(),
                      ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: _eligibility(),
                      ),

                      ///
                      if (_couponModel!.eligibility == AppConfig.eligibilityForCoupon[0]["value"])
                        Column(
                          children: [
                            Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                              child: _customerEligibility(),
                            ),
                          ],
                        ),

                      ///
                      if (_couponModel!.eligibility == AppConfig.eligibilityForCoupon[1]["value"])
                        Column(
                          children: [
                            Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                              child: _businessEligibility(),
                            ),
                          ],
                        ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: _userLimitsPanle(),
                      ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: _activeDatePanel(),
                      ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: KeicyTextFormField(
                          controller: _termsController,
                          focusNode: _termsFocusNode,
                          width: double.infinity,
                          height: heightDp * 100,
                          // maxHeight: heightDp * 100,
                          border: Border.all(color: Colors.grey.withOpacity(0.7)),
                          errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                          borderRadius: heightDp * 6,
                          contentHorizontalPadding: widthDp * 10,
                          contentVerticalPadding: heightDp * 8,
                          isImportant: true,
                          label: "Terms And Conditions",
                          labelSpacing: heightDp * 5,
                          labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                          textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          hintText: "Terms And Conditions",
                          hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: null,
                          onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                          validatorHandler: (input) => input.isEmpty ? "Please enter terms" : null,
                          onSaveHandler: (input) => _couponModel!.terms = input.trim(),
                          onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_discountCodeFocusNode),
                        ),
                      ),

                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                        child: _imagePanel(),
                      ),

                      ///
                      Divider(height: heightDp * 30, thickness: 2, color: Colors.grey.withOpacity(0.6)),
                      _buttonPanel(),

                      ///
                      SizedBox(height: heightDp * 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _discountTypePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Discount Type",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(AppConfig.discountTypeForCoupon.length, (index) {
            return Column(
              children: [
                Container(
                  height: heightDp * 35,
                  child: Row(
                    children: [
                      Radio(
                        groupValue: _couponModel!.discountType,
                        value: AppConfig.discountTypeForCoupon[index]["value"].toString(),
                        onChanged: (String? value) {
                          _couponModel!.discountType = value;
                          _discountValueController.clear();
                          _discountMaxAmountController.clear();
                          _couponModel!.discountData!["customerBogo"]["get"]["type"] = AppConfig.discountBuyValueForCoupon[0]["value"];
                          _discountBuyProducts = [];
                          _discountBuyProductIds = [];
                          _discountBuyServices = [];
                          _discountBuyServiceIds = [];
                          _discountGetProducts = [];
                          _discountGetProductIds = [];
                          _discountGetServices = [];
                          _discountGetServiceIds = [];
                          _discountGetPercentValueController.clear();

                          if (value == AppConfig.discountTypeForCoupon.last["value"]) {
                            _appliedSelectedProducts = [];
                            _appliedSelectedProductIds = [];
                            _appliedSelectedServices = [];
                            _appliedSelectedServiceIds = [];
                            _appliedProductCategoryList = [];
                            _appliedServiceCategoryList = [];
                            _couponModel!.discountData!["discountValue"] = null;
                            _couponModel!.discountData!["discountMaxAmount"] = null;
                            _couponModel!.minimumRequirements = AppConfig.minRequirementsForCoupon.first["value"];
                            _couponModel!.appliedFor = AppConfig.appliesToForCoupon.first["value"];
                          }
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Text(
                          AppConfig.discountTypeForCoupon[index]["text"],
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),

        ///
        SizedBox(height: heightDp * 5),
        if (_couponModel!.discountType == AppConfig.discountTypeForCoupon[0]["value"].toString() ||
            _couponModel!.discountType == AppConfig.discountTypeForCoupon[1]["value"].toString())
          KeicyTextFormField(
            controller: _discountValueController,
            focusNode: _discountValueFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            border: Border.all(color: Colors.grey.withOpacity(0.7)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
            borderRadius: heightDp * 6,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            isImportant: true,
            label: "Discount Value",
            labelSpacing: heightDp * 5,
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
            suffixIcons: [
              Container(
                height: heightDp * 40,
                child: Center(
                  child: Text(
                    _couponModel!.discountType == AppConfig.discountTypeForCoupon[0]["value"].toString()
                        ? "%"
                        : _couponModel!.discountType == AppConfig.discountTypeForCoupon[1]["value"].toString()
                            ? "₹"
                            : "",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
            hintText: "Discount Value",
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
            validatorHandler: (input) {
              if (input.isEmpty) return "Please enter discount value";

              if (_couponModel!.discountType == AppConfig.discountTypeForCoupon[0]["value"].toString() &&
                  (double.parse(input) == 0 || double.parse(input) >= 100)) {
                return "Please enter percent value";
              }

              return null;
            },
            onSaveHandler: (input) => _couponModel!.discountData!["discountValue"] = input.trim(),
            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_discountMaxAmountFocusNode),
          ),

        ///
        SizedBox(height: heightDp * 10),
        if (_couponModel!.discountType == AppConfig.discountTypeForCoupon[0]["value"].toString() ||
            _couponModel!.discountType == AppConfig.discountTypeForCoupon[1]["value"].toString())
          KeicyTextFormField(
            controller: _discountMaxAmountController,
            focusNode: _discountMaxAmountFocusNode,
            width: double.infinity,
            height: heightDp * 40,
            border: Border.all(color: Colors.grey.withOpacity(0.7)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
            borderRadius: heightDp * 6,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            label: "Discount Max Amount",
            labelSpacing: heightDp * 5,
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
            suffixIcons: [
              Container(
                height: heightDp * 40,
                child: Center(
                  child: Text(
                    "₹",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
            hintText: "Discount Max Amount",
            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
            onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
            // validatorHandler: (input) {
            //   if (input.isEmpty) return "Please enter max amuont";

            //   return null;
            // },
            onSaveHandler: (input) => input.isNotEmpty
                ? _couponModel!.discountData!["discountMaxAmount"] = input.trim()
                : _couponModel!.discountData!["discountMaxAmount"] = null,
            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
          ),

        ///
        if (_couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"].toString())
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightDp * 10),
              Text(
                "Customer Buys",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "Customer can buy any of the following product(s)/ service(s) with specified quantity",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
              SizedBox(height: heightDp * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Quantity: ",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                  KeicyTextFormField(
                    controller: _discountBuyQuantityController,
                    focusNode: _discountBuyQuantityFocusNode,
                    width: widthDp * 150,
                    height: heightDp * 35,
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                    borderRadius: heightDp * 6,
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                    validatorHandler: (input) {
                      if (input.isEmpty) return "Please enter quantity";
                    },
                    onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: widthDp * 5),
                        Icon(Icons.arrow_forward, size: heightDp * 15),
                        SizedBox(width: widthDp * 5),
                        Expanded(
                          child: Text(
                            "Search product list",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  KeicyRaisedButton(
                    width: widthDp * 100,
                    height: heightDp * 35,
                    borderRadius: heightDp * 6,
                    color: config.Colors().mainColor(1),
                    child: Text(
                      "Browse",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                    onPressed: () async {
                      List<ProductModel> selectedProducts = [];

                      for (var i = 0; i < _discountBuyProducts.length; i++) {
                        selectedProducts.add(_discountBuyProducts[i]);
                      }

                      List<ProductModel>? result = await Navigator.of(context).push<List<ProductModel>?>(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProductListPage(
                            selectedProducts: selectedProducts,
                            storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
                            storeModel: AuthProvider.of(context).authState.storeModel,
                            isForSelection: true,
                          ),
                        ),
                      );

                      if (result != null) {
                        _discountBuyProducts = [];
                        _discountBuyProductIds = [];
                        for (var i = 0; i < result.length; i++) {
                          _discountBuyProducts.add(result[i]);
                          _discountBuyProductIds.add(result[i].id);
                        }
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              if (_discountBuyProducts.isNotEmpty)
                Text(
                  "Selected Products:",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              if (_discountBuyProducts.isNotEmpty) SizedBox(height: heightDp * 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_discountBuyProducts.length, (index) {
                  ProductModel? productModel = _discountBuyProducts[index];
                  return Column(
                    children: [
                      ProductItemForCouponWidget(
                        productModel: productModel,
                        padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                        deleteCallback: (ProductModel? productModel) {
                          _discountBuyProducts.removeAt(index);
                          setState(() {});
                        },
                      ),
                    ],
                  );
                }),
              )
            ],
          ),
        if (_couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"].toString())
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: widthDp * 5),
                        Icon(Icons.arrow_forward, size: heightDp * 15),
                        SizedBox(width: widthDp * 5),
                        Expanded(
                          child: Text(
                            "Search service list",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  KeicyRaisedButton(
                    width: widthDp * 100,
                    height: heightDp * 35,
                    borderRadius: heightDp * 6,
                    color: config.Colors().mainColor(1),
                    child: Text(
                      "Browse",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                    onPressed: () async {
                      List<ServiceModel> selectedServices = [];

                      for (var i = 0; i < _discountBuyServices.length; i++) {
                        selectedServices.add(_discountBuyServices[i]);
                      }

                      List<ServiceModel>? result = await Navigator.of(context).push<List<ServiceModel>?>(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ServiceListPage(
                            selectedServices: selectedServices,
                            storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
                            storeModel: AuthProvider.of(context).authState.storeModel,
                            isForSelection: true,
                          ),
                        ),
                      );

                      if (result != null) {
                        _discountBuyServices = [];
                        _discountBuyServiceIds = [];
                        for (var i = 0; i < result.length; i++) {
                          _discountBuyServices.add(result[i]);
                          _discountBuyServiceIds.add(result[i].id);
                        }
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              if (_discountBuyServices.isNotEmpty)
                Text(
                  "Selected Services:",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              if (_discountBuyServices.isNotEmpty) SizedBox(height: heightDp * 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_discountBuyServices.length, (index) {
                  ServiceModel serviceModel = _discountBuyServices[index];
                  return Column(
                    children: [
                      ServiceItemForCouponWidget(
                        serviceModel: serviceModel,
                        padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                        deleteCallback: (ServiceModel? serviceModel) {
                          _discountBuyServices.removeAt(index);
                          setState(() {});
                        },
                      ),
                    ],
                  );
                }),
              )
            ],
          ),

        ///
        if (_couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"].toString())
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.7)),
        if (_couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"].toString())
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightDp * 10),
              Text(
                "Customer Gets",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "Customer can get any of the following product(s)/ service(s) with specified discount",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
              SizedBox(height: heightDp * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Quantity: ",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                  KeicyTextFormField(
                    controller: _discountGetQuantityController,
                    focusNode: _discountGetQuantityFocusNode,
                    width: widthDp * 150,
                    height: heightDp * 35,
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                    borderRadius: heightDp * 6,
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                    validatorHandler: (input) {
                      if (input.isEmpty) return "Please enter quantity";
                    },
                    onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: widthDp * 5),
                        Icon(Icons.arrow_forward, size: heightDp * 15),
                        SizedBox(width: widthDp * 5),
                        Expanded(
                          child: Text(
                            "Search product list",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  KeicyRaisedButton(
                    width: widthDp * 100,
                    height: heightDp * 35,
                    borderRadius: heightDp * 6,
                    color: config.Colors().mainColor(1),
                    child: Text(
                      "Browse",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                    onPressed: () async {
                      List<ProductModel> selectedProducts = [];

                      for (var i = 0; i < _discountGetProducts.length; i++) {
                        selectedProducts.add(_discountGetProducts[i]);
                      }

                      var result = await Navigator.of(context).push<List<ProductModel>?>(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProductListPage(
                            selectedProducts: selectedProducts,
                            storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
                            storeModel: AuthProvider.of(context).authState.storeModel,
                            isForSelection: true,
                          ),
                        ),
                      );

                      if (result != null) {
                        _discountGetProducts = [];
                        _discountGetProductIds = [];
                        for (var i = 0; i < result.length; i++) {
                          _discountGetProducts.add(result[i]);
                          _discountGetProductIds.add(result[i].id);
                        }
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              if (_discountGetProducts.isNotEmpty)
                Text(
                  "Selected Products:",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              if (_discountGetProducts.isNotEmpty) SizedBox(height: heightDp * 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_discountGetProducts.length, (index) {
                  ProductModel? productModel = _discountGetProducts[index];
                  return Column(
                    children: [
                      ProductItemForCouponWidget(
                        productModel: productModel,
                        padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                        deleteCallback: (ProductModel? productOrderModel) {
                          _discountGetProducts.removeAt(index);

                          setState(() {});
                        },
                      ),
                    ],
                  );
                }),
              )
            ],
          ),
        if (_couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"].toString())
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: widthDp * 5),
                        Icon(Icons.arrow_forward, size: heightDp * 15),
                        SizedBox(width: widthDp * 5),
                        Expanded(
                          child: Text(
                            "Search service list",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  KeicyRaisedButton(
                    width: widthDp * 100,
                    height: heightDp * 35,
                    borderRadius: heightDp * 6,
                    color: config.Colors().mainColor(1),
                    child: Text(
                      "Browse",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                    onPressed: () async {
                      List<ServiceModel> selectedServices = [];

                      for (var i = 0; i < _discountGetServices.length; i++) {
                        selectedServices.add(_discountGetServices[i]);
                      }

                      List<ServiceModel>? result = await Navigator.of(context).push<List<ServiceModel>?>(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ServiceListPage(
                            selectedServices: selectedServices,
                            storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
                            storeModel: AuthProvider.of(context).authState.storeModel,
                            isForSelection: true,
                          ),
                        ),
                      );

                      if (result != null) {
                        _discountGetServices = [];
                        _discountGetServiceIds = [];
                        for (var i = 0; i < result.length; i++) {
                          _discountGetServices.add(result[i]);
                          _discountGetServiceIds.add(result[i].id);
                        }
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: heightDp * 10),
              if (_discountGetServices.isNotEmpty)
                Text(
                  "Selected Services:",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              if (_discountGetServices.isNotEmpty) SizedBox(height: heightDp * 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_discountGetServices.length, (index) {
                  ServiceModel? serviceModel = _discountGetServices[index];
                  return Column(
                    children: [
                      ServiceItemForCouponWidget(
                        serviceModel: serviceModel,
                        padding: EdgeInsets.symmetric(vertical: heightDp * 5),
                        deleteCallback: (ServiceModel? serviceModel) {
                          _discountGetServices.removeAt(index);

                          setState(() {});
                        },
                      ),
                    ],
                  );
                }),
              )
            ],
          ),

        ///
        if (_couponModel!.discountType == AppConfig.discountTypeForCoupon[2]["value"].toString())
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightDp * 10),
              Text(
                "At a discount value",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: heightDp * 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(AppConfig.discountBuyValueForCoupon.length, (index) {
                  return Column(
                    children: [
                      Container(
                        height: heightDp * 35,
                        child: Row(
                          children: [
                            Radio(
                              groupValue: _couponModel!.discountData!.isNotEmpty ? _couponModel!.discountData!["customerBogo"]["get"]["type"] : null,
                              value: AppConfig.discountBuyValueForCoupon[index]["value"].toString(),
                              onChanged: (value) {
                                _couponModel!.discountData!["customerBogo"]["get"]["type"] = value;
                                _discountValueController.clear();
                                setState(() {});
                              },
                            ),
                            Expanded(
                              child: Text(
                                AppConfig.discountBuyValueForCoupon[index]["text"],
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
              if (_couponModel!.discountData!.isNotEmpty &&
                  _couponModel!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[1]["value"])
                KeicyTextFormField(
                  controller: _discountGetPercentValueController,
                  focusNode: _discountGetPercentValueFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.7)),
                  errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                  borderRadius: heightDp * 6,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  isImportant: true,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                  suffixIcons: [
                    Container(
                      height: heightDp * 40,
                      child: Center(
                        child: Text(
                          "%",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                  onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                  validatorHandler: (input) {
                    if (input.isEmpty) return "Please enter percent value";

                    if (double.parse(input) == 0 || double.parse(input) >= 100) {
                      return "Please enter percent value";
                    }
                    return null;
                  },
                  onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                ),
            ],
          ),
      ],
    );
  }

  Widget _minimumRequirementPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Minimum requirements",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(AppConfig.minRequirementsForCoupon.length, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: heightDp * 35,
                  child: Row(
                    children: [
                      Radio(
                        groupValue: _couponModel!.minimumRequirements.toString(),
                        value: AppConfig.minRequirementsForCoupon[index]["value"].toString(),
                        onChanged: _couponModel!.discountType == AppConfig.discountTypeForCoupon.last["value"]
                            ? null
                            : (String? value) {
                                _couponModel!.minimumRequirements = value;
                                _minReqAmountController.text = "0";
                                _minReqQuantityController.text = "1";
                                setState(() {});
                              },
                      ),
                      Expanded(
                        child: Text(
                          AppConfig.minRequirementsForCoupon[index]["text"],
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                if ((index == 1 && _couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[1]["value"].toString()))
                  Row(
                    children: [
                      SizedBox(width: widthDp * 50),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KeicyTextFormField(
                              controller: _minReqAmountController,
                              focusNode: _minReqAmountFocusNode,
                              width: double.infinity,
                              height: heightDp * 40,
                              border: Border.all(color: Colors.grey.withOpacity(0.7)),
                              errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                              borderRadius: heightDp * 6,
                              contentHorizontalPadding: widthDp * 10,
                              contentVerticalPadding: heightDp * 8,
                              isImportant: true,
                              textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                              suffixIcons: _couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[1]["value"].toString()
                                  ? [
                                      Container(
                                        height: heightDp * 40,
                                        child: Center(
                                          child: Text(
                                            "₹",
                                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ]
                                  : [],
                              onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                              validatorHandler: (input) {
                                if (input.isEmpty) return "Please enter value";

                                return null;
                              },
                              onSaveHandler: (input) => _couponModel!.minimumAmount = double.parse(input.trim()),
                              onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                            ),
                            SizedBox(height: heightDp * 5),
                            Text(
                              "Applies only to selected products/services",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                if ((index == 2 && _couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[2]["value"].toString()))
                  Row(
                    children: [
                      SizedBox(width: widthDp * 50),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KeicyTextFormField(
                              controller: _minReqQuantityController,
                              focusNode: _minReqQuantityFocusNode,
                              width: double.infinity,
                              height: heightDp * 40,
                              border: Border.all(color: Colors.grey.withOpacity(0.7)),
                              errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                              borderRadius: heightDp * 6,
                              contentHorizontalPadding: widthDp * 10,
                              contentVerticalPadding: heightDp * 8,
                              isImportant: true,
                              textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                              onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                              validatorHandler: (input) {
                                if (input.isEmpty) return "Please enter value";

                                return null;
                              },
                              onSaveHandler: (input) => _couponModel!.minimumAmount = double.parse(input.trim()),
                              onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                            ),
                            SizedBox(height: heightDp * 5),
                            Text(
                              "Applies only to selected products/services",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _appliedToPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KeicyDropDownFormField(
          width: double.infinity,
          height: heightDp * 40,
          value: _couponModel!.appliedFor,
          updateValueNewly: true,
          isDisabled: _couponModel!.discountType == AppConfig.discountTypeForCoupon.last["value"],
          menuItems: AppConfig.appliesToForCoupon,
          selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          border: Border.all(color: Colors.grey.withOpacity(0.7)),
          errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
          borderRadius: heightDp * 6,
          contentHorizontalPadding: widthDp * 10,
          contentVerticalPadding: heightDp * 8,
          isImportant: true,
          label: "Applies To",
          labelSpacing: heightDp * 5,
          labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
          hintText: "Applies To",
          hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
          onValidateHandler: (value) => value == null ? "Please select appliesTo" : null,
          onChangeHandler: (value) {
            _couponModel!.appliedFor = value;
            setState(() {});
          },
        ),
        if (_couponModel!.appliedFor == AppConfig.appliesToForCoupon[2]["value"]) _specificProducts(),
        if (_couponModel!.appliedFor == AppConfig.appliesToForCoupon[1]["value"]) _specificCategories(),
      ],
    );
  }

  Widget _specificProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: heightDp * 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 5),
                      Icon(Icons.arrow_forward, size: heightDp * 15),
                      SizedBox(width: widthDp * 5),
                      Expanded(
                        child: Text(
                          "Search product list",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                KeicyRaisedButton(
                  width: widthDp * 100,
                  height: heightDp * 35,
                  borderRadius: heightDp * 6,
                  color: config.Colors().mainColor(1),
                  child: Text(
                    "Browse",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: () async {
                    List<ProductModel>? result = await Navigator.of(context).push<List<ProductModel>?>(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductListPage(
                          selectedProducts: _appliedSelectedProducts,
                          storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
                          storeModel: AuthProvider.of(context).authState.storeModel,
                          isForSelection: true,
                        ),
                      ),
                    );

                    if (result != null) {
                      _appliedSelectedProducts = result;
                      _appliedSelectedProductIds = [];
                      for (var i = 0; i < _appliedSelectedProducts.length; i++) {
                        _appliedSelectedProductIds.add(_appliedSelectedProducts[i].id);
                      }
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: heightDp * 10),
            if (_appliedSelectedProducts.isNotEmpty)
              Text(
                "Selected Products:",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            if (_appliedSelectedProducts.isNotEmpty) SizedBox(height: heightDp * 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_appliedSelectedProducts.length, (index) {
                ProductModel productModel = _appliedSelectedProducts[index];
                return ProductItemForSelectionWidget(
                  selectedProducts: [],
                  productModel: productModel,
                  isLoading: false,
                  storeModel: AuthProvider.of(context).authState.storeModel,
                );
              }),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 5),
                      Icon(Icons.arrow_forward, size: heightDp * 15),
                      SizedBox(width: widthDp * 5),
                      Expanded(
                        child: Text(
                          "Search service list",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                KeicyRaisedButton(
                  width: widthDp * 100,
                  height: heightDp * 35,
                  borderRadius: heightDp * 6,
                  color: config.Colors().mainColor(1),
                  child: Text(
                    "Browse",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: () async {
                    List<ServiceModel>? result = await Navigator.of(context).push<List<ServiceModel>?>(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ServiceListPage(
                          selectedServices: _appliedSelectedServices,
                          storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
                          storeModel: AuthProvider.of(context).authState.storeModel,
                          isForSelection: true,
                        ),
                      ),
                    );

                    if (result != null) {
                      _appliedSelectedServices = result;
                      _appliedSelectedServiceIds = [];
                      for (var i = 0; i < _appliedSelectedServices.length; i++) {
                        _appliedSelectedServiceIds.add(_appliedSelectedServices[i].id);
                      }
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: heightDp * 10),
            if (_appliedSelectedServices.isNotEmpty)
              Text(
                "Selected Services:",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            if (_appliedSelectedServices.isNotEmpty) SizedBox(height: heightDp * 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_appliedSelectedServices.length, (index) {
                ServiceModel serviceModel = _appliedSelectedServices[index];

                return ServiceItemForSelectionWidget(
                  selectedServices: [],
                  serviceModel: serviceModel,
                  isLoading: false,
                  storeModel: AuthProvider.of(context).authState.storeModel,
                );
              }),
            )
          ],
        ),
      ],
    );
  }

  Widget _specificCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: heightDp * 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 5),
                      Icon(Icons.arrow_forward, size: heightDp * 15),
                      SizedBox(width: widthDp * 5),
                      Expanded(
                        child: Text(
                          "Search product category",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                KeicyRaisedButton(
                  width: widthDp * 100,
                  height: heightDp * 35,
                  borderRadius: heightDp * 6,
                  color: config.Colors().mainColor(1),
                  child: Text(
                    "Browse",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: () async {
                    var result = await ProductCategoryBottomSheetDialog.show(
                      context,
                      _appliedProductCategoryList,
                    );

                    if (result != null && result != _appliedProductCategoryList) {
                      _appliedProductCategoryList = result;
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: heightDp * 10),
            if (_appliedProductCategoryList.isNotEmpty)
              Text(
                "Selected product categories:",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            if (_appliedProductCategoryList.isNotEmpty) SizedBox(height: heightDp * 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_appliedProductCategoryList.length, (index) {
                String productCategory = _appliedProductCategoryList[index];

                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        "$productCategory",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _appliedProductCategoryList.removeAt(index);
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                        child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                      ),
                    ),
                  ],
                );
              }),
            )
          ],
        ),

        ///
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: widthDp * 5),
                      Icon(Icons.arrow_forward, size: heightDp * 15),
                      SizedBox(width: widthDp * 5),
                      Expanded(
                        child: Text(
                          "Search service category",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                KeicyRaisedButton(
                  width: widthDp * 100,
                  height: heightDp * 35,
                  borderRadius: heightDp * 6,
                  color: config.Colors().mainColor(1),
                  child: Text(
                    "Browse",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                  onPressed: () async {
                    var result = await ServiceCategoryBottomSheetDialog.show(
                      context,
                      _appliedServiceCategoryList,
                    );

                    if (result != null && result != _appliedServiceCategoryList) {
                      _appliedServiceCategoryList = result;
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: heightDp * 10),
            if (_appliedServiceCategoryList.isNotEmpty)
              Text(
                "Selected service categories:",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            if (_appliedServiceCategoryList.isNotEmpty) SizedBox(height: heightDp * 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_appliedServiceCategoryList.length, (index) {
                String serviceCategory = _appliedServiceCategoryList[index];

                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        "$serviceCategory",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _appliedServiceCategoryList.removeAt(index);
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                        child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                      ),
                    ),
                  ],
                );
              }),
            )
          ],
        ),
      ],
    );
  }

  Widget _eligibility() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Eligibility",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(AppConfig.eligibilityForCoupon.length, (index) {
            return Column(
              children: [
                Container(
                  height: heightDp * 35,
                  child: Row(
                    children: [
                      Radio(
                        groupValue: _couponModel!.eligibility.toString(),
                        value: AppConfig.eligibilityForCoupon[index]["value"].toString(),
                        onChanged: (widget.couponModel != null && widget.couponModel!.eligibility != "")
                            ? null
                            : (String? value) {
                                _couponModel!.eligibility = value;
                                setState(() {});
                              },
                      ),
                      Expanded(
                        child: Text(
                          AppConfig.eligibilityForCoupon[index]["text"],
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _customerEligibility() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer Eligibility",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(AppConfig.customerEligibilityForCoupon.length, (index) {
            return Column(
              children: [
                Container(
                  height: heightDp * 35,
                  child: Row(
                    children: [
                      Radio(
                        groupValue: _couponModel!.customerEligibility.toString(),
                        value: AppConfig.customerEligibilityForCoupon[index]["value"].toString(),
                        onChanged: (widget.couponModel != null && widget.couponModel!.customerEligibility != "" && widget.isNew!)
                            ? null
                            : (String? value) {
                                _couponModel!.customerEligibility = value;
                                setState(() {});
                              },
                      ),
                      Expanded(
                        child: Text(
                          AppConfig.customerEligibilityForCoupon[index]["text"],
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_couponModel!.customerEligibility == AppConfig.customerEligibilityForCoupon[1]["value"] && index == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 10),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: widthDp * 5),
                                Icon(Icons.arrow_forward, size: heightDp * 15),
                                SizedBox(width: widthDp * 5),
                                Expanded(
                                  child: Text(
                                    "Search your customers list",
                                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          KeicyRaisedButton(
                            width: widthDp * 100,
                            height: heightDp * 35,
                            borderRadius: heightDp * 6,
                            color: config.Colors().mainColor(1),
                            child: Text(
                              "Browse",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                            ),
                            onPressed: () async {
                              var result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => NewCustomerForChatPage(),
                                ),
                              );
                              if (result != null) {
                                bool isAdded = false;
                                for (var i = 0; i < _selectedCustomerData.length; i++) {
                                  if (_selectedCustomerData[i]["_id"] == result["_id"]) {
                                    isAdded = true;
                                    break;
                                  }
                                }
                                if (!isAdded) {
                                  _selectedCustomerData.add(result);
                                  _selectedCustomerIds.add(result["_id"]);
                                  setState(() {});
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 10),
                      if (_selectedCustomerData.isNotEmpty)
                        Text(
                          "Selected Customers:",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      if (_selectedCustomerData.isNotEmpty) SizedBox(height: heightDp * 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(_selectedCustomerData.length, (index) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${_selectedCustomerData[index]["firstName"]} ${_selectedCustomerData[index]["lastName"]}",
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _selectedCustomerData.removeAt(index);
                                  _selectedCustomerIds.removeAt(index);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                                  child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        }),
                      )
                    ],
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _businessEligibility() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Business Eligibility",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(AppConfig.businessEligibilityForCoupon.length, (index) {
            return Column(
              children: [
                Container(
                  height: heightDp * 35,
                  child: Row(
                    children: [
                      Radio(
                        groupValue: _couponModel!.businessEligibility.toString(),
                        value: AppConfig.businessEligibilityForCoupon[index]["value"].toString(),
                        onChanged: (widget.couponModel != null && widget.couponModel!.businessEligibility != "" && widget.isNew!)
                            ? null
                            : (String? value) {
                                _couponModel!.businessEligibility = value;
                                setState(() {});
                              },
                      ),
                      Expanded(
                        child: Text(
                          AppConfig.businessEligibilityForCoupon[index]["text"],
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_couponModel!.businessEligibility == AppConfig.businessEligibilityForCoupon[1]["value"] && index == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: heightDp * 10),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: widthDp * 5),
                                Icon(Icons.arrow_forward, size: heightDp * 15),
                                SizedBox(width: widthDp * 5),
                                Expanded(
                                  child: Text(
                                    "Search your business list",
                                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          KeicyRaisedButton(
                            width: widthDp * 100,
                            height: heightDp * 35,
                            borderRadius: heightDp * 6,
                            color: config.Colors().mainColor(1),
                            child: Text(
                              "Browse",
                              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                            ),
                            onPressed: () async {
                              var result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => BusinessStoresPage(
                                    status: ConnectionStatus.active,
                                    forSelection: true,
                                  ),
                                ),
                              );
                              if (result != null) {
                                bool isAdded = false;
                                for (var i = 0; i < _selectedBusinessData.length; i++) {
                                  if (_selectedBusinessData[i]["_id"] == result["_id"]) {
                                    isAdded = true;
                                    break;
                                  }
                                }
                                if (!isAdded) {
                                  _selectedBusinessData.add(result);
                                  _selectedBusinessIds.add(result["_id"]);
                                  setState(() {});
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 10),
                      if (_selectedBusinessData.isNotEmpty)
                        Text(
                          "Selected Business:",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      if (_selectedBusinessData.isNotEmpty) SizedBox(height: heightDp * 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(_selectedBusinessData.length, (index) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${_selectedBusinessData[index]["name"]}",
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _selectedBusinessData.removeAt(index);
                                  _selectedBusinessIds.removeAt(index);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                                  child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        }),
                      )
                    ],
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _userLimitsPanle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Usage Limits",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(AppConfig.usageLimitsForCoupon.length, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: heightDp * 35,
                  child: Row(
                    children: [
                      Radio(
                        groupValue: _couponModel!.usageLimits.toString(),
                        value: AppConfig.usageLimitsForCoupon[index]["value"].toString(),
                        onChanged: (String? value) {
                          _couponModel!.usageLimits = value;
                          _limitNumberController.clear();
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Text(
                          AppConfig.usageLimitsForCoupon[index]["text"],
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index == 1 && _couponModel!.usageLimits == AppConfig.usageLimitsForCoupon[index]["value"].toString())
                  Column(
                    children: [
                      SizedBox(height: heightDp * 10),
                      Row(
                        children: [
                          SizedBox(width: widthDp * 50),
                          Expanded(
                            child: KeicyTextFormField(
                              controller: _limitNumberController,
                              focusNode: _limitNumberCodeFocusNode,
                              width: double.infinity,
                              height: heightDp * 40,
                              border: Border.all(color: Colors.grey.withOpacity(0.7)),
                              errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                              borderRadius: heightDp * 6,
                              contentHorizontalPadding: widthDp * 10,
                              contentVerticalPadding: heightDp * 8,
                              isImportant: true,
                              textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              hintText: "Enter Number Of Times",
                              hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onChangeHandler: (input) => RefreshProvider.of(context).refresh(),
                              validatorHandler: (input) => input.isEmpty
                                  ? "Please enter number"
                                  : double.parse(input.trim()) <= 0
                                      ? "Please enter value more than 0 "
                                      : null,
                              onSaveHandler: (input) => _couponModel!.limitNumbers = int.parse(input.trim()),
                              onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 10),
                    ],
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _activeDatePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Active dates",
          style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: heightDp * 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: KeicyTextFormField(
                controller: _startDateController,
                focusNode: _startDateFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                isImportant: true,
                label: "Start Date",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "Start Date",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                readOnly: true,
                onTapHandler: () async {
                  DateTime? selecteDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
                    selectableDayPredicate: (date) {
                      if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
                      if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
                      return true;
                    },
                  );

                  if (selecteDate == null) return;

                  _startDateController.text = KeicyDateTime.convertDateTimeToDateString(
                    dateTime: selecteDate,
                    isUTC: false,
                  );

                  _startDate = selecteDate;

                  setState(() {});
                },
                validatorHandler: (input) {
                  if (input.isEmpty) {
                    return "Please enter start date";
                  }

                  if (_endDateController.text.isNotEmpty && _startDate!.isAfter(_endDate!)) {
                    return "Please enter the start date before end date";
                  }

                  return null;
                },
                onSaveHandler: (input) => _couponModel!.startDate = _startDate,
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
              ),
            ),
            SizedBox(width: widthDp * 10),
            Expanded(
              child: KeicyTextFormField(
                controller: _endDateController,
                focusNode: _endDateFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                autovalidateMode: AutovalidateMode.disabled,
                label: "End Date",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "End Date",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                readOnly: true,
                validatorHandler: (input) {
                  if (input.isNotEmpty && _startDate!.isAfter(_endDate!)) {
                    return "Please enter the end date after start date";
                  }

                  return null;
                },
                onTapHandler: () async {
                  DateTime? selecteDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
                    selectableDayPredicate: (date) {
                      if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
                      if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
                      return true;
                    },
                  );

                  if (selecteDate == null) return;

                  _endDateController.text = KeicyDateTime.convertDateTimeToDateString(
                    dateTime: selecteDate,
                    isUTC: false,
                  );

                  _endDate = selecteDate;

                  setState(() {});
                },
                onSaveHandler: (input) {
                  if (_endDate == null) return;
                  _couponModel!.endDate = _endDate;
                },
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
              ),
            ),
          ],
        ),
      ],
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
              children: List.generate(_couponModel!.images!.length + _imageFiles.length, (index) {
                String url = "";
                File? imageFile;

                if (index < _couponModel!.images!.length) {
                  url = _couponModel!.images![index];
                } else if (index >= _couponModel!.images!.length && _imageFiles.isNotEmpty) {
                  int length = _couponModel!.images!.length;
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
                        if (index >= _couponModel!.images!.length) {
                          int length = _couponModel!.images!.length;
                          _imageFiles.removeAt(index - length);
                          setState(() {});
                        } else {
                          NormalAskDialog.show(
                            context,
                            content: "Are you sure to delete this image",
                            callback: () {
                              _couponModel!.images!.removeAt(index);
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
        "coupon_detail_view",
        "_getAvatarImage",
        "No image selected.",
      );
    }
  }

  Widget _buttonPanel() {
    return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
      bool isValidated = true;

      if (_nameController.text.trim().isEmpty) isValidated = false;
      if (_descriptionController.text.trim().isEmpty) isValidated = false;
      if (_discountCodeController.text.trim().isEmpty) isValidated = false;
      if ((_couponModel!.discountType == AppConfig.discountTypeForCoupon[0]["value"].toString() ||
              _couponModel!.discountType == AppConfig.discountTypeForCoupon[1]["value"].toString()) &&
          _discountValueController.text.trim().isEmpty) {
        isValidated = false;
      }

      if (_couponModel!.discountType == AppConfig.discountTypeForCoupon.last["value"].toString() &&
          (_discountBuyQuantityController.text.trim().isEmpty ||
              (_discountBuyProducts.isEmpty && _discountBuyServices.isEmpty) ||
              _discountGetQuantityController.text.trim().isEmpty ||
              (_discountGetProducts.isEmpty && _discountGetServices.isEmpty) ||
              (_couponModel!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[1]["value"] &&
                  _discountGetPercentValueController.text.trim().isEmpty))) {
        isValidated = false;
      }

      if (_couponModel!.appliedFor == AppConfig.appliesToForCoupon[1]["value"] &&
          (_appliedProductCategoryList.isEmpty && _appliedServiceCategoryList.isEmpty)) {
        isValidated = false;
      }

      if (_couponModel!.appliedFor == AppConfig.appliesToForCoupon[2]["value"] &&
          (_appliedSelectedProducts.isEmpty && _appliedSelectedServices.isEmpty)) {
        isValidated = false;
      }

      if (_couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[1]["value"].toString() &&
          _minReqAmountController.text.trim().isEmpty) {
        isValidated = false;
      }
      if (_couponModel!.minimumRequirements == AppConfig.minRequirementsForCoupon[2]["value"].toString() &&
          _minReqQuantityController.text.trim().isEmpty) {
        isValidated = false;
      }

      if (_couponModel!.customerEligibility == AppConfig.customerEligibilityForCoupon[1]["value"].toString() && _selectedCustomerData.isEmpty) {
        isValidated = false;
      }

      if (_couponModel!.businessEligibility == AppConfig.businessEligibilityForCoupon[1]["value"].toString() && _selectedBusinessData.isEmpty) {
        isValidated = false;
      }

      if (_couponModel!.usageLimits == AppConfig.usageLimitsForCoupon[1]["value"] && _limitNumberController.text.trim().isEmpty) {
        isValidated = false;
      }

      if (_startDateController.text.trim().isEmpty) {
        isValidated = false;
      }

      if (_termsController.text.trim().isEmpty) {
        isValidated = false;
      }

      return Column(
        children: [
          SizedBox(height: heightDp * 20),
          Center(
            child: KeicyRaisedButton(
              width: widthDp * 150,
              height: heightDp * 35,
              color: isValidated ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.7),
              borderRadius: heightDp * 6,
              child: Text(
                "Save",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: isValidated ? _jobPostHandler : null,
            ),
          ),
        ],
      );
    });
  }
}
