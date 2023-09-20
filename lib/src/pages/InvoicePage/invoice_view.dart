import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/payment_detail_panel.dart';
import 'package:trapp/src/elements/pickup_delivery_option_panel.dart';
import 'package:trapp/src/elements/product_invoice_widget.dart';
import 'package:trapp/src/elements/service_for_payment_widget.dart';
import 'package:trapp/src/elements/service_time_panel.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/product_item_bottom_sheet.dart';
import 'package:trapp/src/helpers/price_functions1.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/NewCustomerForChatPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class InvoiceView extends StatefulWidget {
  final UserModel? userModel;
  final bool? changeCustomer;

  InvoiceView({Key? key, this.userModel, this.changeCustomer}) : super(key: key);

  @override
  _InvoiceViewState createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> with SingleTickerProviderStateMixin {
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

  TextEditingController? _paymentForController;
  TextEditingController? _noteTitleController;
  TextEditingController? _noteBodyController;

  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _noteTitleFocusNode = FocusNode();
  FocusNode _noteBodyFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<ProductOrderModel> _selectedProducts = [];
  List<ServiceOrderModel> _selectedServices = [];
  List<dynamic> _customProducts = [];

  OrderModel _orderModel = OrderModel();
  DateTime? _dueDate;

  bool _isValidated = false;

  KeicyProgressDialog? _keicyProgressDialog;
  OrderProvider? _orderProvider;

  DeliveryAddressProvider? _deliveryAddressProvider;
  PromocodeProvider? _promocodeProvider;
  SharedPreferences? _sharedPreferences;

  UserModel? _userModel;

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

    _userModel = widget.userModel;

    if (_orderModel.redeemRewardData!.isEmpty) {
      _orderModel.redeemRewardData = Map<String, dynamic>();
      _orderModel.redeemRewardData!["sumRewardPoint"] = 0;
      _orderModel.redeemRewardData!["redeemRewardValue"] = 0;
      _orderModel.redeemRewardData!["redeemRewardPoint"] = 0;
      _orderModel.redeemRewardData!["tradeSumRewardPoint"] = 0;
      _orderModel.redeemRewardData!["tradeRedeemRewardPoint"] = 0;
      _orderModel.redeemRewardData!["tradeRedeemRewardValue"] = 0;
    }
    _orderModel.storeModel = AuthProvider.of(context).authState.storeModel;
    _orderModel.userModel = _userModel;

    _paymentForController = TextEditingController(text: _orderModel.paymentFor);
    _noteTitleController = TextEditingController();
    _noteBodyController = TextEditingController();

    _orderProvider = OrderProvider.of(context);

    _orderModel.noContactDelivery = true;
    _orderModel.orderType = "Pickup";

    _deliveryAddressProvider = DeliveryAddressProvider.of(context);
    _promocodeProvider = PromocodeProvider.of(context);
    _orderProvider = OrderProvider.of(context);

    _deliveryAddressProvider!.setDeliveryAddressState(
      _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
      isNotifiable: false,
    );
    _promocodeProvider!.setPromocodeState(_promocodeProvider!.promocodeState.update(progressState: 0), isNotifiable: false);

    if (CategoryProvider.of(context).categoryState.progressState != 2) {
      CategoryProvider.of(context).getCategoryAll();
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _orderProvider!.addListener(_orderProviderListener);
      _sharedPreferences = await SharedPreferences.getInstance();

      String? result = _sharedPreferences!.getString("invoice_order");
      if (result != null) {
        Map<String, dynamic> storedData = json.decode(result);

        _selectedProducts = [];
        for (var i = 0; i < storedData["selectedProducts"].length; i++) {
          _selectedProducts.add(ProductOrderModel.fromJson(storedData["selectedProducts"][i]));
        }
        _selectedServices = [];
        for (var i = 0; i < storedData["selectedServices"].length; i++) {
          _selectedServices.add(ServiceOrderModel.fromJson(storedData["selectedServices"][i]));
        }
        _customProducts = storedData["customProducts"];

        _paymentForController!.text = storedData["paymentFor"].toString();
        _noteTitleController!.text = storedData["notes"]["title"];
        _noteBodyController!.text = storedData["notes"]["description"];

        if (storedData["deliveryProvider"] != null && storedData["deliveryAddress"] != null && storedData["deliveryAddress"].isNotEmpty) {
          _deliveryAddressProvider!.setDeliveryAddressState(
            _deliveryAddressProvider!.deliveryAddressState.update(
              progressState: storedData["deliveryProvider"]["progressState"],
              message: storedData["deliveryProvider"]["message"],
              deliveryAddressData: storedData["deliveryProvider"]["deliveryAddressData"],
              selectedDeliveryAddress: storedData["deliveryProvider"]["selectedDeliveryAddress"],
              maxDeliveryDistance: storedData["deliveryProvider"]["maxDeliveryDistance"],
            ),
            isNotifiable: false,
          );
        }

        if (storedData["dueDate"] != null) _dueDate = DateTime.tryParse(storedData["dueDate"])!.toLocal();
        setState(() {});
      }
    });
  }

  void _storeToLocal() async {
    if (_sharedPreferences == null) _sharedPreferences = await SharedPreferences.getInstance();
    Map<String, dynamic> storedData = Map<String, dynamic>();

    storedData["paymentFor"] = _paymentForController!.text.trim();
    storedData["notes"] = {
      "title": _noteTitleController!.text.trim(),
      "description": _noteBodyController!.text.trim(),
    };
    storedData["selectedProducts"] = [];
    for (var i = 0; i < _selectedProducts.length; i++) {
      storedData["selectedProducts"].add(_selectedProducts[i].toJson());
    }
    storedData["selectedServices"] = [];
    for (var i = 0; i < _selectedServices.length; i++) {
      storedData["selectedServices"].add(_selectedServices[i].toJson());
    }
    storedData["customProducts"] = _customProducts;
    List<dynamic> customProducts = [];
    for (var i = 0; i < _customProducts.length; i++) {
      if (_customProducts[i]["type"] == "product") {
        customProducts.add(ProductOrderModel.fromJson(_customProducts[i]).toJson());
        customProducts.last["type"] = "product";
      } else {
        customProducts.add(ServiceOrderModel.fromJson(_customProducts[i]).toJson());
        customProducts.last["type"] = "service";
      }
    }
    storedData["customProducts"] = customProducts;
    storedData["deliveryProvider"] = _deliveryAddressProvider!.deliveryAddressState.toJson();
    if (_dueDate != null) storedData["dueDate"] = _dueDate!.toUtc().toIso8601String();
    _sharedPreferences!.setString("invoice_order", json.encode(storedData));
  }

  @override
  void dispose() {
    _orderProvider!.removeListener(_orderProviderListener);
    super.dispose();
  }

  void _orderProviderListener() async {
    if (_orderProvider!.orderState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_orderProvider!.orderState.progressState == 2) {
      if (_sharedPreferences == null) _sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences!.remove("invoice_order");
      Navigator.of(context).pop(_orderProvider!.orderState.newOrderModel);
    } else if (_orderProvider!.orderState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _orderProvider!.orderState.message!,
        isTryButton: true,
        callBack: _placeOrderHandler,
      );
    }
  }

  void _placeOrderHandler() async {
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

    if (_orderProvider!.orderState.progressState == 1) return;
    _orderProvider!.setOrderState(_orderProvider!.orderState.update(progressState: 1));
    _keicyProgressDialog = KeicyProgressDialog.of(context);
    await _keicyProgressDialog!.show();

    String categoryDesc = "";
    List<dynamic> _categories;
    _categories = _orderModel.storeModel!.businessType == "store"
        ? CategoryProvider.of(context).categoryState.categoryData!["store"]
        : CategoryProvider.of(context).categoryState.categoryData!["services"];

    for (var i = 0; i < _categories.length; i++) {
      if (_categories[i]["categoryId"] == _orderModel.storeModel!.subType) {
        categoryDesc = _categories[i]["categoryDesc"];
        break;
      }
    }

    _orderModel.userModel = _userModel;
    _orderModel.storeModel = AuthProvider.of(context).authState.storeModel;
    _orderModel.storeCategoryId = _orderModel.storeModel!.subType;
    _orderModel.storeCategoryDesc = categoryDesc;
    _orderModel.storeLocation = _orderModel.storeModel!.location;
    _orderModel.deliveryDetail = {
      "ongoing": false,
      "assignedDeliveryUserId": "",
      "status": "",
    };

    _orderModel.paymentFor = _paymentForController!.text.trim();
    _orderModel.notes = {
      "title": _noteTitleController!.text.trim(),
      "description": _noteBodyController!.text.trim(),
    };
    _orderModel.initiatedBy = "Store";
    _orderModel.dueDate = _dueDate;

    String status = AppConfig.orderStatusData[1]["id"];

    _orderProvider!.addOrder(
      orderModel: _orderModel,
      category: "InvoiceFromStore",
      status: status,
    );
  }

  void _produtsAndServiceHandler() {
    _orderModel.products = [];
    _orderModel.services = [];

    for (var i = 0; i < _selectedProducts.length; i++) {
      _orderModel.products!.add(_selectedProducts[i]);
    }

    for (var i = 0; i < _selectedServices.length; i++) {
      _orderModel.services!.add(_selectedServices[i]);
    }

    for (var i = 0; i < _customProducts.length; i++) {
      if (_customProducts[i]["type"] == "product") {
        if (_customProducts[i]["data"]["_id"] == null) {
          _customProducts[i]["data"]["_id"] = "custom_$i";
        }
        _orderModel.products!.add(ProductOrderModel.fromJson(_customProducts[i]));

        if (_orderModel.products!.last.productModel!.price == 0) {
          _isValidated = false;
          continue;
        }
      } else if (_customProducts[i]["type"] == "service") {
        if (_customProducts[i]["data"]["_id"] == null) {
          _customProducts[i]["data"]["_id"] = "custom_$i";
        }
        _orderModel.services!.add(ServiceOrderModel.fromJson(_customProducts[i]));

        if (_orderModel.services!.last.serviceModel!.price == 0) {
          _isValidated = false;
          continue;
        }
      }
    }
  }

  void _validationHandler() {
    _isValidated = true;

    if (_orderModel.products!.isNotEmpty) {
      if (_orderModel.orderType == "Pickup") {
        if (_orderModel.pickupDateTime == null) {
          _isValidated = false;
        }
      } else {
        if (_orderModel.deliveryAddress == null) {
          _isValidated = false;
        }
      }
    }

    if (_orderModel.services!.isNotEmpty) {
      if (_orderModel.serviceDateTime == null) {
        _isValidated = false;
      }
    }

    if (_orderModel.services!.isEmpty && _orderModel.products!.isEmpty) {
      _isValidated = false;
    }

    if (_dueDate == null) {
      _isValidated = false;
    }

    if (_orderModel.products!.isEmpty && _orderModel.services!.isEmpty) {
      _isValidated = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _produtsAndServiceHandler();
    _validationHandler();

    PriceFunctions1.calculateDiscount(orderModel: _orderModel);
    _orderModel.paymentDetail = PriceFunctions1.calclatePaymentDetail(orderModel: _orderModel);

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    return WillPopScope(
      onWillPop: () async {
        _storeToLocal();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
            onPressed: () {
              _storeToLocal();
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text("Invoice", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
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
                padding: EdgeInsets.only(bottom: heightDp * 20),
                color: Colors.transparent,
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(height: heightDp * 15),
                      _customerPanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _chooseItemPanel(),
                      SizedBox(height: heightDp * 5),
                      _productsPanel(),

                      // ///
                      // Column(
                      //   children: [
                      //     Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      //     PromocodePanel(
                      //       orderModel: _orderModel,
                      //       refreshCallback: () {
                      //         setState(() {});
                      //       },
                      //     ),
                      //   ],
                      // ),

                      if (_orderModel.products!.isNotEmpty)
                        Column(
                          children: [
                            Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                            PickupDeliveryOptionPanel(
                              orderModel: _orderModel,
                              deliveryPartner: null,
                              pickupCallback: () {
                                setState(() {
                                  _orderModel.orderType = "Pickup";
                                  _orderModel.payAtStore = false;
                                  _orderModel.cashOnDelivery = false;
                                  _orderModel.pickupDateTime = null;
                                  _orderModel.deliveryAddress = null;
                                  _orderModel.paymentDetail!.tip = 0;
                                  _deliveryAddressProvider!.setDeliveryAddressState(
                                    _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
                                    isNotifiable: false,
                                  );
                                });
                              },
                              deliveryCallback: () {
                                _orderModel.orderType = "Delivery";
                                _orderModel.payAtStore = false;
                                _orderModel.cashOnDelivery = false;
                                _orderModel.pickupDateTime = null;
                                _orderModel.deliveryAddress = null;
                                _orderModel.paymentDetail!.tip = 0;
                                _deliveryAddressProvider!.setDeliveryAddressState(
                                  _deliveryAddressProvider!.deliveryAddressState.update(selectedDeliveryAddress: Map<String, dynamic>()),
                                  isNotifiable: false,
                                );
                              },
                              refreshCallback: () {
                                setState(() {});
                                _dateValidationHandler();
                              },
                            ),
                          ],
                        ),

                      if (_orderModel.services!.isNotEmpty)
                        Column(
                          children: [
                            Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                            ServiceTimePanel(
                              orderModel: _orderModel,
                              refreshCallback: () {
                                setState(() {});
                                _dateValidationHandler();
                              },
                            ),
                          ],
                        ),

                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _descriptionPanel(),

                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _notesPanel(),

                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _expireDatePanel(),

                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      PaymentDetailPanel(
                        orderModel: _orderModel,
                      ),

                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _paymentLinkButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customerPanel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(heightDp * 6),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "User Name",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        "${_userModel!.firstName} ${_userModel!.lastName}",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "User Email",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    SizedBox(width: widthDp * 5),
                    Expanded(
                      child: Text(
                        (_userModel!.email.toString().length < 20 ? "${_userModel!.email}" : "${_userModel!.email.toString().substring(0, 20)}..."),
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: heightDp * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeicyRaisedButton(
                width: widthDp * 175,
                height: heightDp * 35,
                color: !widget.changeCustomer! ? Colors.grey.withOpacity(0.7) : config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                child: Text(
                  "Change Customer",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: !widget.changeCustomer!
                    ? null
                    : () async {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => NewCustomerForChatPage(),
                          ),
                        );
                        if (result != null) {
                          _userModel = UserModel.fromJson(result);
                          _orderModel.userModel = _userModel;

                          setState(() {});
                        }
                      },
              )
            ],
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
                    storeIds: [
                      AuthProvider.of(context).authState.storeModel!.id!,
                    ],
                    storeModel: AuthProvider.of(context).authState.storeModel,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(_orderModel.products!.length, (index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ProductInvoiceWidget(
                    productOrderModel: _orderModel.products![index],
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
                    refreshCallback: (ProductOrderModel? productOrderModel) {
                      if (productOrderModel == null) return;

                      for (var i = 0; i < _selectedProducts.length; i++) {
                        if (_selectedProducts[i].productModel!.id == productOrderModel.productModel!.id) {
                          _selectedProducts[i] = productOrderModel;
                          break;
                        }
                      }
                      for (var i = 0; i < _customProducts.length; i++) {
                        if (_customProducts[i]["data"]["_id"] == productOrderModel.productModel!.id) {
                          _customProducts[i] = productOrderModel.toJson();
                          _customProducts[i]["type"] = "product";
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
          children: List.generate(_orderModel.services!.length, (index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ServicePaymentWidget(
                    serviceOrderModel: _orderModel.services![index],
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
                    refreshCallback: (ServiceOrderModel? serviceOrderModel) {
                      for (var i = 0; i < _selectedServices.length; i++) {
                        if (_selectedServices[i].serviceModel!.id == serviceOrderModel!.serviceModel!.id) {
                          _selectedServices[i] = serviceOrderModel;
                          break;
                        }
                      }
                      for (var i = 0; i < _customProducts.length; i++) {
                        if (_customProducts[i]["data"]["_id"] == serviceOrderModel!.serviceModel!.id) {
                          _customProducts[i] = serviceOrderModel.toJson();
                          _customProducts[i]["type"] = "service";
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
            controller: _paymentForController,
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
              _orderModel.paymentFor = input.trim();
            },
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
                    hintText: "Title",
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
                  ),
                  // validator: (input) => input.isEmpty ? "Please input title" : null,
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                TextFormField(
                  controller: _noteBodyController,
                  focusNode: _noteBodyFocusNode,
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: "Descrition",
                    hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
                  ),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  // validator: (input) => input.isEmpty ? "Please input description" : null,
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
              _dueDate == null
                  ? "Please choose due date"
                  : "Due Date: " +
                      KeicyDateTime.convertDateTimeToDateString(
                        dateTime: _dueDate!.toLocal(),
                        formats: "Y-m-d",
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
      _dueDate = selecteDate;
    });
    _dateValidationHandler();
  }

  void _dateValidationHandler() {
    if ((_dueDate != null && _orderModel.pickupDateTime != null && _dueDate!.isAfter(_orderModel.pickupDateTime!)) ||
        (_dueDate != null && _orderModel.serviceDateTime != null && _dueDate!.isAfter(_orderModel.serviceDateTime!))) {
      NormalDialog.show(
        context,
        content: "Your due date for payment is after pickup/service date",
      );
    }
  }

  Widget _paymentLinkButton() {
    return KeicyRaisedButton(
      width: widthDp * 180,
      height: heightDp * 35,
      color: _isValidated ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
      borderRadius: heightDp * 6,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
      child: Text(
        "Create Invoice",
        style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
      ),
      onPressed: _isValidated ? _placeOrderHandler : null,
    );
  }
}
