import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_string/random_string.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_checkbox.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_invoice_widget.dart';
import 'package:trapp/src/elements/product_for_payment_widget_old.dart';
import 'package:trapp/src/elements/service_for_payment_widget.dart';
import 'package:trapp/src/elements/service_for_payment_widget_old.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/price_functions.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/product_item_bottom_sheet.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/product_order_model.dart';
import 'package:trapp/src/models/service_order_model.dart';
import 'package:trapp/src/models/store_model.dart';
import 'package:trapp/src/providers/index.dart';

class GeneratePaymentLinkView extends StatefulWidget {
  final Map<String, dynamic>? customerData;
  final StoreModel? storeModel;

  GeneratePaymentLinkView({
    Key? key,
    this.customerData,
    this.storeModel,
  }) : super(key: key);

  @override
  _GeneratePaymentLinkViewState createState() => _GeneratePaymentLinkViewState();
}

class _GeneratePaymentLinkViewState extends State<GeneratePaymentLinkView> with SingleTickerProviderStateMixin {
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

  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _priceController;
  TextEditingController? _referenceIdController;
  TextEditingController? _descriptionController;
  TextEditingController? _minPartialController;
  TextEditingController? _noteTitleController;
  TextEditingController? _noteBodyController;

  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _referenceIdFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _minPartialFocusNode = FocusNode();
  FocusNode _noteTitleFocusNode = FocusNode();
  FocusNode _noteBodyFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<ProductOrderModel> _selectedProducts = [];
  List<ServiceOrderModel> _selectedServices = [];
  List<dynamic> _customProducts = [];

  Map<String, dynamic> _paymentData = Map<String, dynamic>();
  DateTime? _expiredDate;

  bool _isValidated = false;

  KeicyProgressDialog? _keicyProgressDialog;
  PaymentLinkProvider? _paymentLinkProvider;

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

    _paymentData["currency"] = "INR";
    _paymentData["reminder_enable"] = true;
    _paymentData["accept_partial"] = false;
    _paymentData["first_min_partial_amount"] = null;
    _paymentData["description"] = "";
    _paymentData["reference_id"] = randomAlphaNumeric(12);
    if (widget.customerData!.isNotEmpty) {
      _paymentData["customer"] = {
        "name": widget.customerData!["firstName"] + " " + widget.customerData!["lastName"],
        "contact": "",
        "email": widget.customerData!["email"],
      };

      _firstNameController = TextEditingController(text: widget.customerData!["firstName"]);
      _lastNameController = TextEditingController(text: widget.customerData!["lastName"]);
      _emailController = TextEditingController(text: widget.customerData!["email"]);
      _phoneController = TextEditingController(text: widget.customerData!["mobile"]);
    } else {
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController(text: "");
    }

    _paymentData["notify"] = {"sms": false, "email": true};
    _priceController = TextEditingController();
    _referenceIdController = TextEditingController(text: _paymentData["reference_id"]);
    _descriptionController = TextEditingController(text: _paymentData["description"]);
    _minPartialController = TextEditingController();
    _noteTitleController = TextEditingController();
    _noteBodyController = TextEditingController();

    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _paymentLinkProvider = PaymentLinkProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _createPaymentHandler() async {
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

    if (_phoneController!.text.trim().isEmpty && _paymentData["notify"]["sms"]) {
      NormalDialog.show(
        context,
        content: "You didn't input phone number.\nplease uncheck 'Notify via SMS'",
      );
      return;
    }

    if (_emailController!.text.trim().isEmpty && _paymentData["notify"]["email"]) {
      NormalDialog.show(
        context,
        content: "You didn't input email.\nplease uncheck 'Notify via Email'",
      );
      return;
    }

    _paymentData["customer"] = {
      "name": _firstNameController!.text.trim() + " " + _lastNameController!.text.trim(),
      "contact": _phoneController!.text.trim(),
      "email": _emailController!.text.trim(),
    };
    _paymentData["expire_by"] = _expiredDate!.millisecondsSinceEpoch ~/ 1000;
    _paymentData["reference_id"] = _referenceIdController!.text.trim();
    _paymentData["description"] = _descriptionController!.text.trim();
    _paymentData["notes"] = {
      _noteTitleController!.text.trim(): _noteBodyController!.text.trim(),
    };

    Map<String, dynamic> request = {
      "storeId": AuthProvider.of(context).authState.storeModel!.id,
      "userId": widget.customerData!["_id"],
      "products": _paymentData["products"],
      "services": _paymentData["services"],
      "paymentData": _paymentData,
    };

    request["paymentData"].remove("products");
    request["paymentData"].remove("services");

    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    var result = await _paymentLinkProvider!.addPaymentLink(request);
    await _keicyProgressDialog!.hide();

    if (!result["success"]) {
      ErrorDialog.show(context, widthDp: widthDp, heightDp: heightDp, fontSp: fontSp, text: result["message"]);
      setState(() {});
      return;
    }

    Navigator.of(context).pop(result["data"]);
  }

  @override
  Widget build(BuildContext context) {
    _isValidated = true;

    if (_firstNameController!.text.isEmpty) {
      _isValidated = false;
    }

    if (_lastNameController!.text.isEmpty) {
      _isValidated = false;
    }

    if (_emailController!.text.isEmpty) {
      _isValidated = false;
    }

    if (_paymentData["amount"] == null || _paymentData["amount"] == 0) {
      _isValidated = false;
    }

    if (_paymentData["accept_partial"] && (_paymentData["first_min_partial_amount"] == null || _paymentData["first_min_partial_amount"] == 0)) {
      _isValidated = false;
    }

    if (_expiredDate == null) {
      _isValidated = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text("Payment Link", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
        elevation: 0,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: deviceWidth,
              padding: EdgeInsets.symmetric(vertical: heightDp * 20),
              color: Colors.transparent,
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    _customerPanel(),

                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _notifyPanel(),

                    ///
                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _chooseItemPanel(),
                    _productsPanel(),

                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _referenceIdPanel(),

                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _descriptionPanel(),

                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _partialPaymentPanel(),

                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _notesPanel(),

                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _expireDatePanel(),

                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _paymentLinkButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customerPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        children: [
          ///
          KeicyTextFormField(
            controller: _firstNameController,
            focusNode: _firstNameFocusNode,
            width: double.infinity,
            height: heightDp * 35,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
            label: "First Name",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            borderRadius: heightDp * 6,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            validatorHandler: (input) => input.isEmpty ? "Please enter a first name" : null,
            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_lastNameFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _lastNameController,
            focusNode: _lastNameFocusNode,
            width: double.infinity,
            height: heightDp * 35,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
            label: "Last Name",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            borderRadius: heightDp * 6,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            validatorHandler: (input) => input.isEmpty ? "Please enter a last name" : null,
            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_emailFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            width: double.infinity,
            height: heightDp * 35,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
            label: "Email",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            borderRadius: heightDp * 6,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            keyboardType: TextInputType.emailAddress,
            validatorHandler: (input) =>
                input.trim().isNotEmpty && !KeicyValidators.isValidEmail(input.trim()) ? "Please enter the correct email" : null,
            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_phoneFocusNode),
          ),

          ///
          SizedBox(height: heightDp * 20),
          KeicyTextFormField(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            width: double.infinity,
            height: heightDp * 35,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
            label: "Phone number",
            labelSpacing: heightDp * 5,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            borderRadius: heightDp * 6,
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            keyboardType: TextInputType.number,
            validatorHandler: (input) => input.trim().isNotEmpty && input.trim().length != 10 ? "Please enter 10 digits" : null,
            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
          ),
        ],
      ),
    );
  }

  Widget _chooseItemPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Please add Product/Service", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
              SizedBox(width: widthDp * 10),
              KeicyRaisedButton(
                width: widthDp * 100,
                height: heightDp * 30,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  "Choose",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: () {
                  List<ProductModel> products = [];
                  List<ServiceModel> services = [];

                  for (var i = 0; i < _selectedProducts.length; i++) {
                    products.add(_selectedProducts[i].productModel!);
                  }

                  for (var i = 0; i < _selectedServices.length; i++) {
                    services.add(_selectedServices[i].serviceModel!);
                  }

                  ProductItemBottomSheet.show(
                    context,
                    storeIds: [widget.storeModel!.id!],
                    storeModel: widget.storeModel,
                    selectedProducts: products,
                    selectedServices: services,
                    callback: (String type, List<dynamic> items) {
                      if (type == "product") {
                        List<ProductOrderModel> newProducts = [];
                        for (var i = 0; i < items.length; i++) {
                          double orderQuantity = 1;
                          for (var k = 0; k < _selectedProducts.length; k++) {
                            if (_selectedProducts[k].productModel!.id == items[i]["_id"]) {
                              orderQuantity = _selectedProducts[k].orderQuantity!;
                              break;
                            }
                          }

                          newProducts.add(ProductOrderModel.fromJson({
                            "orderQuantity": orderQuantity,
                            "couponQuantity": orderQuantity,
                            "data": items[i],
                          }));
                        }
                        _selectedProducts = newProducts;
                      } else if (type == "service") {
                        List<ServiceOrderModel> newServices = [];
                        for (var i = 0; i < items.length; i++) {
                          double orderQuantity = 1;
                          for (var k = 0; k < _selectedServices.length; k++) {
                            if (_selectedServices[k].serviceModel!.id == items[i]["_id"]) {
                              orderQuantity = _selectedServices[k].orderQuantity!;
                              break;
                            }
                          }

                          newServices.add(ServiceOrderModel.fromJson({
                            "orderQuantity": orderQuantity,
                            "couponQuantity": orderQuantity,
                            "data": items[i],
                          }));
                        }
                        _selectedServices = newServices;
                      } else if (type == "custom") {
                        _customProducts.add(items.first);
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productsPanel() {
    _paymentData["products"] = [];
    _paymentData["services"] = [];

    double? _totalPrice = 0;

    for (var i = 0; i < _selectedProducts.length; i++) {
      _paymentData["products"].add(_selectedProducts[i].toJson());
      double price = double.parse(_paymentData["products"].last["price"].toString());
      double discount = double.parse(_paymentData["products"].last["discount"].toString());
      double taxPercentage = double.parse(_paymentData["products"].last["taxPercentage"].toString());

      _totalPrice = _totalPrice! + ((price - discount) * (1 + taxPercentage / 100)) * _paymentData["products"].last["orderQuantity"];
    }

    for (var i = 0; i < _selectedServices.length; i++) {
      _paymentData["services"].add(_selectedServices[i].toJson());

      double price = double.parse(_paymentData["services"].last["price"].toString());
      double discount = double.parse(_paymentData["services"].last["discount"].toString());
      double taxPercentage = double.parse(_paymentData["services"].last["taxPercentage"].toString());

      _totalPrice = _totalPrice! + ((price - discount) * (1 + taxPercentage / 100)) * _paymentData["services"].last["orderQuantity"];
    }

    for (var i = 0; i < _customProducts.length; i++) {
      if (_customProducts[i]["type"] == "product") {
        _paymentData["products"].add(_customProducts[i]["data"]);
        _paymentData["products"].last["orderQuantity"] = _customProducts[i]["orderQuantity"];
        _paymentData["products"].last["_id"] = "custom_$i";

        var priceResult = PriceFunctions.getPriceDataForProduct(orderData: _paymentData, data: _paymentData["products"].last);
        _paymentData["products"].last.addAll(priceResult);
        _paymentData["products"].last["taxPercentage"] = _paymentData["products"].last["taxPercentage"] ?? 0;

        double price = double.parse(_paymentData["products"].last["price"].toString());
        double discount = double.parse(_paymentData["products"].last["discount"].toString());
        double taxPercentage = double.parse(_paymentData["products"].last["taxPercentage"].toString());

        _totalPrice = _totalPrice! + ((price - discount) * (1 + taxPercentage / 100)) * _paymentData["products"].last["orderQuantity"];
      } else if (_customProducts[i]["type"] == "service") {
        _paymentData["services"].add(_customProducts[i]["data"]);
        _paymentData["services"].last["orderQuantity"] = _customProducts[i]["orderQuantity"];
        _paymentData["services"].last["_id"] = "custom_$i";

        var priceResult = PriceFunctions.getPriceDataForProduct(orderData: _paymentData, data: _paymentData["services"].last);
        _paymentData["services"].last.addAll(priceResult);
        _paymentData["services"].last["taxPercentage"] = _paymentData["services"].last["taxPercentage"] ?? 0;

        double price = double.parse(_paymentData["services"].last["price"].toString());
        double discount = double.parse(_paymentData["services"].last["discount"].toString());
        double taxPercentage = double.parse(_paymentData["services"].last["taxPercentage"].toString());

        _totalPrice = _totalPrice! + ((price - discount) * (1 + taxPercentage / 100)) * _paymentData["services"].last["orderQuantity"];
      }
    }

    if (_totalPrice != null && _totalPrice != 0) {
      _priceController!.text = "₹ " + _totalPrice.toStringAsFixed(2);
      _paymentData["amount"] = double.parse(_totalPrice.toStringAsFixed(2));
    } else if (_totalPrice == null || _totalPrice == 0 && _priceController!.text.isNotEmpty) {
      _paymentData["amount"] = double.parse(_priceController!.text.replaceAll("₹", "").replaceAll(" ", ""));
    }

    if (_paymentData["products"].isEmpty && _paymentData["services"].isEmpty) {
      _isValidated = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: heightDp * 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("Total Price:  ", style: TextStyle(fontSize: fontSp * 18, color: Colors.black))),
              Expanded(
                child: KeicyTextFormField(
                  controller: _priceController,
                  focusNode: _priceFocusNode,
                  width: double.infinity,
                  height: heightDp * 35,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  borderRadius: heightDp * 6,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  readOnly: true,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      decimalDigits: 0,
                      symbol: '₹ ',
                      turnOffGrouping: true,
                    )
                  ],
                  onChangeHandler: (input) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: heightDp * 5),
        Column(
          children: List.generate(_paymentData["products"].length, (index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ProductPaymentOldWidget(
                    productData: _paymentData["products"][index],
                    orderData: _paymentData,
                    index: index,
                    deleteCallback: (String id) {
                      int? deleteIndex;
                      for (var i = 0; i < _selectedProducts.length; i++) {
                        if (_selectedProducts[i].productModel!.id == id) {
                          deleteIndex = i;
                          break;
                        }
                      }
                      if (deleteIndex != null) {
                        _selectedProducts.removeAt(deleteIndex);
                        setState(() {});
                        return;
                      }

                      for (var i = 0; i < _customProducts.length; i++) {
                        if (_customProducts[i]["data"]["_id"] == id) {
                          deleteIndex = i;
                          break;
                        }
                      }
                      if (deleteIndex != null) {
                        _customProducts.removeAt(deleteIndex);
                        setState(() {});
                        return;
                      }
                    },
                    refreshCallback: (String id, int orderQuantity) {
                      for (var i = 0; i < _selectedProducts.length; i++) {
                        if (_selectedProducts[i].productModel!.id == id) {
                          _selectedProducts[i].orderQuantity = orderQuantity.toDouble();
                          _selectedProducts[i].couponQuantity = orderQuantity.toDouble();
                          break;
                        }
                      }
                      for (var i = 0; i < _customProducts.length; i++) {
                        if (_customProducts[i]["data"]["_id"] == id) {
                          _customProducts[i]["orderQuantity"] = orderQuantity;
                          break;
                        }
                      }
                      setState(() {});
                    },
                  ),
                ),
                Divider(height: heightDp * 5, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              ],
            );
          }),
        ),
        Column(
          children: List.generate(_paymentData["services"].length, (index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ServicePaymentOldWidget(
                    serviceData: _paymentData["services"][index],
                    orderData: _paymentData,
                    index: index,
                    deleteCallback: (String id) {
                      int? deleteIndex;
                      for (var i = 0; i < _selectedServices.length; i++) {
                        if (_selectedServices[i].serviceModel!.id == id) {
                          deleteIndex = i;
                          break;
                        }
                      }
                      if (deleteIndex != null) {
                        _selectedServices.removeAt(deleteIndex);
                        setState(() {});
                        return;
                      }

                      for (var i = 0; i < _customProducts.length; i++) {
                        if (_customProducts[i]["data"]["_id"] == id) {
                          deleteIndex = i;
                          break;
                        }
                      }
                      if (deleteIndex != null) {
                        _customProducts.removeAt(deleteIndex);
                        setState(() {});
                        return;
                      }
                    },
                    refreshCallback: (String id, int orderQuantity) {
                      for (var i = 0; i < _selectedServices.length; i++) {
                        if (_selectedServices[i].serviceModel!.id == id) {
                          _selectedServices[i].orderQuantity = orderQuantity.toDouble();
                          _selectedServices[i].couponQuantity = orderQuantity.toDouble();
                          break;
                        }
                      }
                      for (var i = 0; i < _customProducts.length; i++) {
                        if (_customProducts[i]["data"]["_id"] == id) {
                          _customProducts[i]["orderQuantity"] = orderQuantity;
                          break;
                        }
                      }
                      setState(() {});
                    },
                  ),
                ),
                Divider(height: heightDp * 5, thickness: 1, color: Colors.grey.withOpacity(0.6)),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _notifyPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KeicyCheckBox(
            iconSize: heightDp * 25,
            value: _paymentData["notify"]["email"],
            iconColor: config.Colors().mainColor(1),
            label: "Notify via Email",
            labelSpacing: widthDp * 5,
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            onChangeHandler: (value) {
              setState(() {
                _paymentData["notify"]["email"] = !_paymentData["notify"]["email"];
              });
            },
          ),
          KeicyCheckBox(
            iconSize: heightDp * 25,
            value: _paymentData["notify"]["sms"],
            iconColor: config.Colors().mainColor(1),
            label: "Notify via SMS",
            labelSpacing: widthDp * 5,
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            onChangeHandler: (value) {
              setState(() {
                _paymentData["notify"]["sms"] = !_paymentData["notify"]["sms"];
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _referenceIdPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reference Id",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          Row(
            children: [
              Text(
                "TMPL - ",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
              Expanded(
                child: KeicyTextFormField(
                  controller: _referenceIdController,
                  focusNode: _referenceIdFocusNode,
                  width: double.infinity,
                  height: heightDp * 35,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  borderRadius: heightDp * 6,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _descriptionPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment For",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          KeicyTextFormField(
            controller: _descriptionController,
            focusNode: _descriptionFocusNode,
            width: double.infinity,
            height: heightDp * 80,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            borderRadius: heightDp * 6,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChangeHandler: (input) {
              _paymentData["description"] = input.trim();
            },
          ),
        ],
      ),
    );
  }

  Widget _partialPaymentPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Partial Payment",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          KeicyCheckBox(
            iconSize: heightDp * 25,
            value: _paymentData["accept_partial"],
            iconColor: config.Colors().mainColor(1),
            label: "Enable Partial Payment",
            labelSpacing: widthDp * 5,
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            onChangeHandler: (value) {
              setState(() {
                _paymentData["accept_partial"] = !_paymentData["accept_partial"];
                _paymentData["first_min_partial_amount"] = null;
              });
            },
          ),
          _paymentData["accept_partial"] ? SizedBox(height: heightDp * 5) : SizedBox(),
          if (!_paymentData["accept_partial"])
            SizedBox()
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "First Partial Amount",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
                SizedBox(height: heightDp * 5),
                KeicyTextFormField(
                  controller: _minPartialController,
                  focusNode: _minPartialFocusNode,
                  width: double.infinity,
                  height: heightDp * 35,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  errorBorder: Border.all(color: Colors.red.withOpacity(0.6)),
                  borderRadius: heightDp * 6,
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.number,
                  readOnly: _paymentData["amount"] == null || _paymentData["amount"] == 0,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      decimalDigits: 0,
                      symbol: '₹ ',
                      turnOffGrouping: true,
                    )
                  ],
                  onChangeHandler: (input) {
                    _paymentData["first_min_partial_amount"] = null;
                    if (input.isNotEmpty) {
                      double partialPrice = double.parse(input.replaceAll("₹", "").replaceAll(" ", ""));
                      if (partialPrice < _paymentData["amount"]) {
                        _paymentData["first_min_partial_amount"] = partialPrice;
                      }
                    }
                    setState(() {});
                  },
                ),
                !(_paymentData["accept_partial"] &&
                        (_paymentData["first_min_partial_amount"] == null || _paymentData["first_min_partial_amount"] == 0))
                    ? SizedBox()
                    : Text(
                        "Please input the value less than ${_paymentData["amount"]}",
                        style: TextStyle(fontSize: fontSp * 13, color: Colors.red),
                      )
              ],
            ),
        ],
      ),
    );
  }

  Widget _notesPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notes",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(heightDp * 6),
            ),
            padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
            child: Column(
              children: [
                TextFormField(
                  controller: _noteTitleController,
                  focusNode: _noteTitleFocusNode,
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: "Title:(key)",
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
                  ),
                  validator: (input) => input!.isEmpty ? "Please input title" : null,
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                TextFormField(
                  controller: _noteBodyController,
                  focusNode: _noteBodyFocusNode,
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: "Descrition:(value)",
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
                  ),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  validator: (input) => input!.isEmpty ? "Please input description" : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _expireDatePanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              _expiredDate == null
                  ? "Please choose expired date"
                  : "Expired Date: " +
                      KeicyDateTime.convertDateTimeToDateString(
                        dateTime: _expiredDate!.toLocal(),
                        formats: "Y-m-d H:i",
                        isUTC: false,
                      ),
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            ),
          ),
          KeicyRaisedButton(
            width: widthDp * 130,
            height: heightDp * 35,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 6,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "Choose date",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: _selectPickupDateHandler,
          )
        ],
      ),
    );
  }

  void _selectPickupDateHandler() async {
    DateTime? selecteDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 2)),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
      selectableDayPredicate: (date) {
        if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2))) return false;
        if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
        return true;
      },
    );
    if (selecteDate == null) return;

    // TimeOfDay time = await showCustomTimePicker(
    //   context: context,
    //   onFailValidation: (context) => print('Unavailable selection'),
    //   initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    // );

    // if (time == null) return;
    // selecteDate = selecteDate.add(Duration(hours: time.hour, minutes: time.minute));
    setState(() {
      if (!selecteDate!.isUtc) selecteDate = selecteDate!.toUtc();
      _expiredDate = selecteDate;
    });
  }

  Widget _paymentLinkButton() {
    return KeicyRaisedButton(
      width: widthDp * 180,
      height: heightDp * 35,
      color: _isValidated ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
      borderRadius: heightDp * 6,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
      child: Text(
        "Create Payment Link",
        style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
      ),
      onPressed: _isValidated ? _createPaymentHandler : null,
    );
  }
}
