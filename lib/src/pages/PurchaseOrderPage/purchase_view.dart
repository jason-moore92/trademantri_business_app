import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/maps_sheet.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_for_purchase_widget.dart';
import 'package:trapp/src/elements/service_for_purchase_widget.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/product_item_bottom_sheet.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/validators.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BusinessStoresPage/index.dart';
import 'package:trapp/src/providers/index.dart';

import '../../../environment.dart';

class PurchaseOrderView extends StatefulWidget {
  PurchaseOrderView({Key? key}) : super(key: key);

  @override
  _PurchaseOrderViewState createState() => _PurchaseOrderViewState();
}

class _PurchaseOrderViewState extends State<PurchaseOrderView> with SingleTickerProviderStateMixin {
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

  TextEditingController? _emailListController = TextEditingController();
  TextEditingController? _mailingAddressController = TextEditingController();
  TextEditingController? _shipViaController = TextEditingController();
  TextEditingController? _salesRepController = TextEditingController();
  TextEditingController? _messageController = TextEditingController();
  TextEditingController? _purchaseDateController = TextEditingController();
  TextEditingController? _dueDateController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _mailingAddressFocusNode = FocusNode();
  FocusNode _shipViaFocusNode = FocusNode();
  FocusNode _salesRepFocusNode = FocusNode();
  FocusNode _messageFocusNode = FocusNode();
  FocusNode _purchaseDateFocusNode = FocusNode();
  FocusNode _dueDateFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  PurchaseModel _purchaseModel = PurchaseModel();
  DateTime? _dueDate;

  bool _isValidated = false;

  KeicyProgressDialog? _keicyProgressDialog;

  SharedPreferences? _sharedPreferences;

  File? _attachFile;
  String? _fileName;
  double? _size;

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

    _purchaseModel.myStoreModel = AuthProvider.of(context).authState.storeModel;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _sharedPreferences = await SharedPreferences.getInstance();

      String? result = _sharedPreferences!.getString("invoice_order");
      // if (result != null) {
      //   Map<String, dynamic> storedData = json.decode(result);

      //   _selectedProducts = [];
      //   for (var i = 0; i < storedData["selectedProducts"].length; i++) {
      //     _selectedProducts.add(PurchaseItemModel.fromJson(storedData["selectedProducts"][i]));
      //   }
      //   _selectedServices = [];
      //   for (var i = 0; i < storedData["selectedServices"].length; i++) {
      //     _selectedServices.add(ServicePurchaseModel.fromJson(storedData["selectedServices"][i]));
      //   }
      //   // _customProducts = storedData["customProducts"];

      //   _paymentForController!.text = storedData["paymentFor"].toString();
      //   _noteTitleController!.text = storedData["notes"]["title"];
      //   _noteBodyController!.text = storedData["notes"]["description"];

      //   if (storedData["deliveryProvider"] != null && storedData["deliveryAddress"] != null && storedData["deliveryAddress"].isNotEmpty) {
      //     _deliveryAddressProvider!.setDeliveryAddressState(
      //       _deliveryAddressProvider!.deliveryAddressState.update(
      //         progressState: storedData["deliveryProvider"]["progressState"],
      //         message: storedData["deliveryProvider"]["message"],
      //         deliveryAddressData: storedData["deliveryProvider"]["deliveryAddressData"],
      //         selectedDeliveryAddress: storedData["deliveryProvider"]["selectedDeliveryAddress"],
      //         maxDeliveryDistance: storedData["deliveryProvider"]["maxDeliveryDistance"],
      //       ),
      //       isNotifiable: false,
      //     );
      //   }

      //   if (storedData["dueDate"] != null) _dueDate = DateTime.tryParse(storedData["dueDate"])!.toLocal();
      //   setState(() {});
      // }
    });
  }

  void _storeToLocal() async {
    // if (_sharedPreferences == null) _sharedPreferences = await SharedPreferences.getInstance();
    // Map<String, dynamic> storedData = Map<String, dynamic>();

    // storedData["paymentFor"] = _paymentForController!.text.trim();
    // storedData["notes"] = {
    //   "title": _noteTitleController!.text.trim(),
    //   "description": _noteBodyController!.text.trim(),
    // };
    // storedData["selectedProducts"] = [];
    // for (var i = 0; i < _selectedProducts.length; i++) {
    //   storedData["selectedProducts"].add(_selectedProducts[i].toJson());
    // }
    // storedData["selectedServices"] = [];
    // for (var i = 0; i < _selectedServices.length; i++) {
    //   storedData["selectedServices"].add(_selectedServices[i].toJson());
    // }
    // // storedData["customProducts"] = _customProducts;
    // // List<dynamic> customProducts = [];
    // // for (var i = 0; i < _customProducts.length; i++) {
    // //   if (_customProducts[i]["type"] == "product") {
    // //     customProducts.add(PurchaseItemModel.fromJson(_customProducts[i]).toJson());
    // //     customProducts.last["type"] = "product";
    // //   } else {
    // //     customProducts.add(ServicePurchaseModel.fromJson(_customProducts[i]).toJson());
    // //     customProducts.last["type"] = "service";
    // //   }
    // // }
    // // storedData["customProducts"] = customProducts;
    // storedData["deliveryProvider"] = _deliveryAddressProvider!.deliveryAddressState.toJson();
    // if (_dueDate != null) storedData["dueDate"] = _dueDate!.toUtc().toIso8601String();
    // _sharedPreferences!.setString("invoice_order", json.encode(storedData));
  }

  @override
  void dispose() {
    super.dispose();
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

    await _keicyProgressDialog!.show();
    if (_attachFile != null) {
      var result = await UploadFileApiProvider.uploadFile(
        file: _attachFile,
        directoryName: "PurchaseOrders/",
        fileName: DateTime.now().millisecondsSinceEpoch.toString(),
        bucketName: "INVOICES_BUCKET",
      );

      if (result["success"]) {
        _purchaseModel.attachFile = result["data"];
      }
    }
    _purchaseModel.status = "open";
    var result = await PurchaseOrderApiProvider.addPurchaseOrder(purchaseModel: _purchaseModel);
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Purchase Order Success",
        callBack: () {
          Navigator.of(context).pop(true);
        },
      );
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

  void _validationHandler() {
    _isValidated = true;

    if (_purchaseModel.businessStoreModel == null) {
      _isValidated = false;
    }

    if (_mailingAddressController!.text.trim().isEmpty) {
      _isValidated = false;
    }

    // if (_shipViaController!.text.trim().isEmpty) {
    //   _isValidated = false;
    // }

    // if (_salesRepController!.text.trim().isEmpty) {
    //   _isValidated = false;
    // }

    if (_purchaseModel.purchaseDate == null) {
      _isValidated = false;
    }

    if (_purchaseModel.purchaseProducts!.isEmpty && _purchaseModel.purchaseServices!.isEmpty) {
      _isValidated = false;
    }

    if (_purchaseModel.dueDate == null) {
      _isValidated = false;
    }

    if (_messageController!.text.trim().isEmpty) {
      _isValidated = false;
    }

    for (var i = 0; i < _purchaseModel.purchaseProducts!.length; i++) {
      if (_purchaseModel.purchaseProducts![i].orderPrice == 0) {
        _isValidated = false;
        break;
      }
    }
    for (var i = 0; i < _purchaseModel.purchaseServices!.length; i++) {
      if (_purchaseModel.purchaseServices![i].orderPrice == 0) {
        _isValidated = false;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text("Purchase Order", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
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
                      _businessPanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _chooseItemPanel(),
                      SizedBox(height: heightDp * 5),
                      _productsPanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _purchaseDatePanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _messagePanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _attachments(),

                      ///
                      SizedBox(height: heightDp * 20),
                      Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
                        _validationHandler();

                        return KeicyRaisedButton(
                          width: widthDp * 120,
                          height: heightDp * 30,
                          color: _isValidated ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                          borderRadius: heightDp * 6,
                          child: Text(
                            "Purchase",
                            style: TextStyle(fontSize: fontSp * 16, color: _isValidated ? Colors.white : Colors.white),
                          ),
                          onPressed: _isValidated ? _placeOrderHandler : null,
                        );
                      }),
                      SizedBox(height: heightDp * 20),
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

  Widget _businessPanel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeicyRaisedButton(
                width: widthDp * 175,
                height: heightDp * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                child: Text(
                  _purchaseModel.businessStoreModel == null ? "Add Business" : "Change Business",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  var result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BusinessStoresPage(
                        status: ConnectionStatus.active,
                        forSelection: true,
                      ),
                    ),
                  );

                  if (result != null) {
                    _purchaseModel.businessStoreModel = StoreModel.fromJson(result);

                    _emailListController!.clear();
                    _purchaseModel.additionalMails = [];

                    _mailingAddressController!.text = _purchaseModel.businessStoreModel!.address!;
                    _purchaseModel.mailingAddress = _purchaseModel.businessStoreModel!.address;
                    _purchaseModel.mailingLocation = _purchaseModel.businessStoreModel!.location;

                    _purchaseModel.shipTo = _purchaseModel.myStoreModel!.name;

                    _purchaseModel.shippingAddress = AddressModel.fromJson({
                      "placeId": "",
                      "name": "",
                      "address": _purchaseModel.myStoreModel!.address,
                      "city": _purchaseModel.myStoreModel!.city,
                      "state": _purchaseModel.myStoreModel!.state,
                      "zipCode": _purchaseModel.myStoreModel!.zipCode,
                      "countryCode": _purchaseModel.myStoreModel!.country,
                      "location": {
                        "lat": _purchaseModel.myStoreModel!.location!.latitude,
                        "lng": _purchaseModel.myStoreModel!.location!.longitude,
                      },
                    });

                    _shipViaController!.clear();
                    _purchaseModel.shipVia = "";

                    _salesRepController!.clear();
                    _purchaseModel.salesRep = "";

                    _purchaseModel.purchaseDate = DateTime.now();
                    _purchaseDateController!.text = KeicyDateTime.convertDateTimeToDateString(dateTime: _purchaseModel.purchaseDate, isUTC: false);

                    _purchaseModel.productsData = Map<String, ProductModel>();
                    _purchaseModel.servicesData = Map<String, ServiceModel>();
                    _purchaseModel.purchaseProducts = [];
                    _purchaseModel.purchaseServices = [];

                    _purchaseModel.dueDate = null;
                    _dueDateController!.text = "";

                    _messageController!.clear();
                    _purchaseModel.message = "";

                    _purchaseModel.attachFile = "";
                    _attachFile = null;
                    _fileName = "";
                    _size = 0;

                    setState(() {});
                  }
                },
              )
            ],
          ),
          SizedBox(height: heightDp * 10),
          if (_purchaseModel.businessStoreModel != null)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Business Name : ",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        "${_purchaseModel.businessStoreModel!.name}",
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
                      "Business Email : ",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    SizedBox(width: widthDp * 5),
                    Expanded(
                      child: Text(
                        (_purchaseModel.businessStoreModel!.email.toString().length < 20
                            ? "${_purchaseModel.businessStoreModel!.email}"
                            : "${_purchaseModel.businessStoreModel!.email.toString().substring(0, 20)}..."),
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 10),
                KeicyTextFormField(
                  controller: _emailListController,
                  focusNode: _emailFocusNode,
                  width: double.infinity,
                  height: null,
                  maxHeight: heightDp * 70,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  hintText: "Email (Separate emails with a comma)",
                  hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  onChangeHandler: (input) {},
                  onSaveHandler: (input) {
                    List<dynamic> list = input.trim().split(',');
                    _purchaseModel.additionalMails = [];
                    for (var i = 0; i < list.length; i++) {
                      if (KeicyValidators.isValidEmail(list[i].toString().trim())) {
                        _purchaseModel.additionalMails!.add(list[i].toString().trim());
                      }
                    }
                  },
                ),

                ///
                SizedBox(height: heightDp * 10),
                Row(
                  children: [
                    Text(
                      "Mailing Address",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Text(
                      "  *",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: widthDp * 10),
                    GestureDetector(
                      onTap: () {
                        MapsSheet.show(
                          context: context,
                          onMapTap: (map) {
                            map.showMarker(
                              coords: Coords(
                                _purchaseModel.mailingLocation!.latitude,
                                _purchaseModel.mailingLocation!.longitude,
                              ),
                              title: "",
                            );
                          },
                        );
                      },
                      child: Image.asset("img/location.png", width: heightDp * 30, height: heightDp * 30),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                KeicyTextFormField(
                  controller: _mailingAddressController,
                  focusNode: _mailingAddressFocusNode,
                  width: double.infinity,
                  height: heightDp * 100,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  hintText: "Mailing Address",
                  hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  isImportant: true,
                  onChangeHandler: (input) {
                    RefreshProvider.of(context).refresh();
                  },
                  validatorHandler: (input) {
                    if (input.isEmpty) return "Please enter mailing address";
                    return null;
                  },
                  onSaveHandler: (input) => _purchaseModel.mailingAddress = input.trim(),
                ),

                ///
                SizedBox(height: heightDp * 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ship To : ",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        "${_purchaseModel.myStoreModel!.name}",
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Shipping Address : ",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                            ),
                            SizedBox(width: widthDp * 10),
                            GestureDetector(
                              onTap: () {
                                MapsSheet.show(
                                  context: context,
                                  onMapTap: (map) {
                                    map.showMarker(
                                      coords: Coords(
                                        _purchaseModel.shippingAddress!.location!.latitude,
                                        _purchaseModel.shippingAddress!.location!.longitude,
                                      ),
                                      title: "",
                                    );
                                  },
                                );
                              },
                              child: Image.asset("img/location.png", width: heightDp * 30, height: heightDp * 30),
                            ),
                          ],
                        ),
                        KeicyRaisedButton(
                          width: widthDp * 150,
                          height: heightDp * 35,
                          color: config.Colors().mainColor(1),
                          borderRadius: heightDp * 6,
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                          child: Text(
                            "Change Address",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            LocationResult? result = await showLocationPicker(
                              context,
                              Environment.googleApiKey!,
                              initialCenter: LatLng(31.1975844, 29.9598339),
                              myLocationButtonEnabled: true,
                              layersButtonEnabled: true,
                              // necessaryField: "city",
                              // countries: ['AE', 'NG'],
                            );
                            if (result != null) {
                              _purchaseModel.shippingAddress = AddressModel.fromJson({
                                "placeId": result.placeId,
                                "name": "",
                                "address": result.address,
                                "city": result.city,
                                "state": result.state,
                                "zipCode": result.zipCode,
                                "location": {
                                  "lat": result.latLng!.latitude,
                                  "lng": result.latLng!.longitude,
                                },
                              });

                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      "${_purchaseModel.shippingAddress!.address}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 10),
                Row(
                  children: [
                    Text(
                      "Ship Via : ",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    SizedBox(width: widthDp * 10),
                    Expanded(
                      child: KeicyTextFormField(
                        controller: _shipViaController,
                        focusNode: _shipViaFocusNode,
                        width: double.infinity,
                        height: heightDp * 40,
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        borderRadius: heightDp * 6,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        hintText: "Ship Via",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        keyboardType: TextInputType.emailAddress,
                        onChangeHandler: (input) {
                          RefreshProvider.of(context).refresh();
                        },
                        // validatorHandler: (input) => input.isEmpty ? "Please enter string" : null,
                        onSaveHandler: (input) => _purchaseModel.shipVia = input.trim(),
                      ),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 10),
                Row(
                  children: [
                    Text(
                      "Sales Rep : ",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    SizedBox(width: widthDp * 10),
                    Expanded(
                      child: KeicyTextFormField(
                        controller: _salesRepController,
                        focusNode: _salesRepFocusNode,
                        width: double.infinity,
                        height: heightDp * 40,
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        borderRadius: heightDp * 6,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        hintText: "Sales Rep",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        keyboardType: TextInputType.emailAddress,
                        onChangeHandler: (input) {
                          RefreshProvider.of(context).refresh();
                        },
                        // validatorHandler: (input) => input.isEmpty ? "Please enter string" : null,
                        onSaveHandler: (input) => _purchaseModel.salesRep = input.trim(),
                      ),
                    ),
                  ],
                ),

                ///
                SizedBox(height: heightDp * 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Purchase Order Date : ",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    SizedBox(width: widthDp * 5),
                    Expanded(
                      child: KeicyTextFormField(
                        controller: _purchaseDateController,
                        focusNode: _purchaseDateFocusNode,
                        width: double.infinity,
                        height: heightDp * 40,
                        border: Border.all(color: Colors.grey.withOpacity(0.6)),
                        borderRadius: heightDp * 6,
                        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                        hintText: "Choose Date",
                        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                        contentHorizontalPadding: widthDp * 10,
                        contentVerticalPadding: heightDp * 8,
                        readOnly: true,
                        // onTapHandler: () async {
                        //   DateTime? dateTime = await _selectPickupDateTimeHandler();
                        //   if (dateTime == null) return;

                        //   _purchaseModel.purchase = dateTime;
                        //   _purchaseDateController!.text = KeicyDateTime.convertDateTimeToDateString(dateTime: _purchaseModel.purchase, isUTC: false);
                        // },
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
                color: _purchaseModel.businessStoreModel == null ? Colors.grey.withOpacity(0.7) : config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  "Choose",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: _purchaseModel.businessStoreModel == null
                    ? null
                    : () {
                        List<ProductModel> productModels = [];
                        List<ServiceModel> serviceModels = [];

                        _purchaseModel.productsData!.forEach((id, productModel) {
                          productModels.add(productModel);
                        });

                        _purchaseModel.servicesData!.forEach((id, serviceModel) {
                          serviceModels.add(serviceModel);
                        });

                        ProductItemBottomSheet.show(
                          context,
                          storeIds: [_purchaseModel.businessStoreModel!.id!],
                          storeModel: _purchaseModel.businessStoreModel,
                          // storeIds: [
                          //   AuthProvider.of(context).authState.storeModel!.id!,
                          // ],
                          // storeModel: AuthProvider.of(context).authState.storeModel,
                          selectedProducts: productModels,
                          selectedServices: serviceModels,
                          isShowCustom: false,
                          isForB2b: true,
                          showDetailButton: false,
                          callback: (String type, List<dynamic> items) {
                            if (type == "product") {
                              for (var i = 0; i < items.length; i++) {
                                if (_purchaseModel.productsData![items[i]["_id"]] != null) continue;

                                double quantity = 1;
                                double price = 0;
                                double discount = 0;
                                double taxPrice = 0;
                                bool acceptBulkOrder = false;
                                double minQuantityForBulkOrder = 0;
                                double taxPercentage = 0;
                                String? taxType;
                                double orderPrice;

                                if (items[i]["b2bPriceFrom"] != null && items[i]["b2bPriceFrom"] != "" && items[i]["b2bPriceFrom"] != 0) {
                                  price = items[i]["b2bPriceFrom"] != null && items[i]["b2bPriceFrom"] != ""
                                      ? double.parse(items[i]["b2bPriceFrom"].toString())
                                      : 0;
                                  if (items[i]["b2bDiscountValue"] != 0) {
                                    if (items[i]["b2bDiscountType"] == "Amount") {
                                      discount = double.parse(items[i]["b2bDiscountValue"].toString());
                                    } else if (items[i]["b2bDiscountType"] == "Percentage") {
                                      discount = (double.parse(items[i]["b2bDiscountValue"].toString()) / 100) *
                                          double.parse(items[i]["b2bPriceFrom"].toString());
                                    }
                                  }
                                  taxPercentage = double.parse(items[i]["b2bTaxPercentage"].toString());
                                  taxType = items[i]["b2bTaxType"] ?? "Inclusive";
                                  acceptBulkOrder = items[i]["b2bAcceptBulkOrder"];
                                  minQuantityForBulkOrder = items[i]["minQuantityForBulkOrder"] != null && items[i]["minQuantityForBulkOrder"] != ""
                                      ? double.parse(items[i]["minQuantityForBulkOrder"].toString())
                                      : 0;

                                  orderPrice = acceptBulkOrder ? price : price - discount;
                                } else {
                                  price = items[i]["price"] != null && items[i]["price"] != "" ? double.parse(items[i]["price"].toString()) : 0;
                                  discount =
                                      items[i]["discount"] != null && items[i]["discount"] != "" ? double.parse(items[i]["discount"].toString()) : 0;
                                  taxPercentage = double.parse(items[i]["taxPercentage"].toString());
                                  taxType = taxPercentage != 0 ? "Inclusive" : null;
                                  minQuantityForBulkOrder = 0;
                                  orderPrice = price - discount;
                                }

                                _purchaseModel.productsData![items[i]["_id"]] = ProductModel.fromJson(items[i]);

                                PurchaseItemModel purchaseItemModel = PurchaseItemModel.fromJson({
                                  "category": "product",
                                  "name": items[i]["name"],
                                  "images": items[i]["images"],
                                  "quantity": quantity,
                                  "price": price,
                                  "discount": discount,
                                  "acceptBulkOrder": acceptBulkOrder,
                                  "minQuantityForBulkOrder": minQuantityForBulkOrder,
                                  "itemPrice": orderPrice,
                                  "orderPrice": orderPrice,
                                  "taxPrice": taxPrice,
                                  "taxPercentage": taxPercentage,
                                  "taxType": taxType,
                                  "productId": items[i]["_id"],
                                  "status": AppConfig.purchaseItemStatus["open"],
                                  "updateAt": DateTime.now().toUtc().toIso8601String(),
                                });

                                if (!purchaseItemModel.acceptBulkOrder! ||
                                    purchaseItemModel.quantity! >= purchaseItemModel.minQuantityForBulkOrder!) {
                                  purchaseItemModel.itemPrice = purchaseItemModel.price! - purchaseItemModel.discount!;
                                } else {
                                  purchaseItemModel.itemPrice = purchaseItemModel.price;
                                }

                                if (purchaseItemModel.taxType == AppConfig.taxTypes.first["value"]) {
                                  purchaseItemModel.taxPrice =
                                      (purchaseItemModel.itemPrice! * purchaseItemModel.taxPercentage!) / (100 + purchaseItemModel.taxPercentage!);
                                  purchaseItemModel.itemPrice = purchaseItemModel.itemPrice! - purchaseItemModel.taxPrice!;
                                  purchaseItemModel.orderPrice = purchaseItemModel.itemPrice! + purchaseItemModel.taxPrice!;
                                } else if (purchaseItemModel.taxType == AppConfig.taxTypes.last["value"]) {
                                  purchaseItemModel.taxPrice = (purchaseItemModel.itemPrice! * purchaseItemModel.taxPercentage!) / (100);
                                  purchaseItemModel.orderPrice = purchaseItemModel.itemPrice! + purchaseItemModel.taxPrice!;
                                } else {
                                  purchaseItemModel.orderPrice = purchaseItemModel.itemPrice!;
                                }

                                _purchaseModel.purchaseProducts!.add(purchaseItemModel);
                              }
                            } else if (type == "service") {
                              for (var i = 0; i < items.length; i++) {
                                if (_purchaseModel.servicesData![items[i]["_id"]] != null) continue;

                                double quantity = 1;
                                double price = 0;
                                double discount = 0;
                                double taxPrice = 0;
                                bool acceptBulkOrder = false;

                                double minQuantityForBulkOrder = 0;
                                double taxPercentage = 0;
                                String? taxType;
                                double orderPrice;

                                if (items[i]["b2bPriceFrom"] != null && items[i]["b2bPriceFrom"] != "" && items[i]["b2bPriceFrom"] != 0) {
                                  price = items[i]["b2bPriceFrom"] != null && items[i]["b2bPriceFrom"] != ""
                                      ? double.parse(items[i]["b2bPriceFrom"].toString())
                                      : 0;
                                  if (items[i]["b2bDiscountValue"] != 0) {
                                    if (items[i]["b2bDiscountType"] == "Amount") {
                                      discount = double.parse(items[i]["b2bDiscountValue"].toString());
                                    } else if (items[i]["b2bDiscountType"] == "Percentage") {
                                      discount = (double.parse(items[i]["b2bDiscountValue"].toString()) / 100) *
                                          double.parse(items[i]["b2bPriceFrom"].toString());
                                    }
                                  }
                                  taxPercentage = double.parse(items[i]["b2bTaxPercentage"].toString());
                                  taxType = items[i]["b2bTaxType"] ?? "Inclusive";
                                  acceptBulkOrder = items[i]["b2bAcceptBulkOrder"];
                                  minQuantityForBulkOrder = items[i]["minQuantityForBulkOrder"] != null && items[i]["minQuantityForBulkOrder"] != ""
                                      ? double.parse(items[i]["minQuantityForBulkOrder"].toString())
                                      : 0;
                                  orderPrice = acceptBulkOrder ? price : price - discount;
                                } else {
                                  price = items[i]["price"] != null && items[i]["price"] != "" ? double.parse(items[i]["price"].toString()) : 0;
                                  discount =
                                      items[i]["discount"] != null && items[i]["discount"] != "" ? double.parse(items[i]["discount"].toString()) : 0;
                                  taxPercentage = double.parse(items[i]["taxPercentage"].toString());
                                  taxType = taxPercentage != 0 ? "Inclusive" : null;
                                  minQuantityForBulkOrder = 0;
                                  orderPrice = price - discount;
                                }

                                _purchaseModel.servicesData![items[i]["_id"]] = ServiceModel.fromJson(items[i]);

                                PurchaseItemModel purchaseItemModel = PurchaseItemModel.fromJson({
                                  "category": "service",
                                  "name": items[i]["name"],
                                  "images": items[i]["images"],
                                  "quantity": quantity,
                                  "price": price,
                                  "discount": discount,
                                  "acceptBulkOrder": acceptBulkOrder,
                                  "minQuantityForBulkOrder": minQuantityForBulkOrder,
                                  "itemPrice": orderPrice,
                                  "orderPrice": orderPrice,
                                  "taxPrice": taxPrice,
                                  "taxPercentage": taxPercentage,
                                  "taxType": taxType,
                                  "productId": items[i]["_id"],
                                  "status": AppConfig.purchaseItemStatus["open"],
                                  "updateAt": DateTime.now().toUtc().toIso8601String(),
                                });

                                if (!purchaseItemModel.acceptBulkOrder! ||
                                    purchaseItemModel.quantity! >= purchaseItemModel.minQuantityForBulkOrder!) {
                                  purchaseItemModel.itemPrice = purchaseItemModel.price! - purchaseItemModel.discount!;
                                } else {
                                  purchaseItemModel.itemPrice = purchaseItemModel.price;
                                }

                                if (purchaseItemModel.taxType == AppConfig.taxTypes.first["value"]) {
                                  purchaseItemModel.taxPrice =
                                      (purchaseItemModel.itemPrice! * purchaseItemModel.taxPercentage!) / (100 + purchaseItemModel.taxPercentage!);
                                  purchaseItemModel.itemPrice = purchaseItemModel.itemPrice! - purchaseItemModel.taxPrice!;
                                  purchaseItemModel.orderPrice = purchaseItemModel.itemPrice! + purchaseItemModel.taxPrice!;
                                } else if (purchaseItemModel.taxType == AppConfig.taxTypes.last["value"]) {
                                  purchaseItemModel.taxPrice = (purchaseItemModel.itemPrice! * purchaseItemModel.taxPercentage!) / (100);
                                  purchaseItemModel.orderPrice = purchaseItemModel.itemPrice! + purchaseItemModel.taxPrice!;
                                } else {
                                  purchaseItemModel.orderPrice = purchaseItemModel.itemPrice!;
                                }

                                _purchaseModel.purchaseServices!.add(purchaseItemModel);
                              }
                            }
                            print("----");

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
          children: List.generate(_purchaseModel.purchaseProducts!.length, (index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ProductPuchaseWidget(
                    purchaseModel: _purchaseModel,
                    purchaseItemModel: _purchaseModel.purchaseProducts![index],
                    index: index,
                    deleteCallback: (String id, int index) {
                      for (var i = 0; i < _purchaseModel.purchaseProducts!.length; i++) {
                        if (_purchaseModel.purchaseProducts![i].productId == id) {
                          _purchaseModel.purchaseProducts!.removeAt(i);
                          _purchaseModel.productsData!.remove(id);
                          break;
                        }
                      }
                      setState(() {});
                    },
                    refreshCallback: (PurchaseItemModel? productPurchaseModel, int index) {
                      if (productPurchaseModel == null) return;

                      for (var i = 0; i < _purchaseModel.purchaseProducts!.length; i++) {
                        if (_purchaseModel.purchaseProducts![i].productId == productPurchaseModel.productId) {
                          _purchaseModel.purchaseProducts![i] = productPurchaseModel;

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
          children: List.generate(_purchaseModel.purchaseServices!.length, (index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ServicePurchaseWidget(
                    purchaseModel: _purchaseModel,
                    purchaseItemModel: _purchaseModel.purchaseServices![index],
                    index: index,
                    deleteCallback: (String id, int index) {
                      for (var i = 0; i < _purchaseModel.purchaseServices!.length; i++) {
                        if (_purchaseModel.purchaseServices![i].productId == id) {
                          _purchaseModel.purchaseServices!.removeAt(i);
                          _purchaseModel.servicesData!.remove(id);
                          break;
                        }
                      }
                      setState(() {});
                    },
                    refreshCallback: (PurchaseItemModel? productPurchaseModel, int index) {
                      if (productPurchaseModel == null) return;

                      for (var i = 0; i < _purchaseModel.purchaseServices!.length; i++) {
                        if (_purchaseModel.purchaseServices![i].productId == productPurchaseModel.productId) {
                          _purchaseModel.purchaseServices![i] = productPurchaseModel;
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

  Widget _messagePanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 0),
      child: Column(
        children: [
          ///
          KeicyTextFormField(
            controller: _messageController,
            focusNode: _messageFocusNode,
            width: double.infinity,
            height: heightDp * 100,
            border: Border.all(color: Colors.grey.withOpacity(0.6)),
            borderRadius: heightDp * 6,
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            label: "Message on Purchase Order",
            labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            labelSpacing: heightDp * 5,
            hintText: "This will be show purchase order",
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
            contentHorizontalPadding: widthDp * 10,
            contentVerticalPadding: heightDp * 8,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: null,
            isImportant: true,
            onChangeHandler: (input) {
              RefreshProvider.of(context).refresh();
            },
            validatorHandler: (input) {
              if (input.isEmpty) return "Please enter message";
              return null;
            },
            onSaveHandler: (input) => _purchaseModel.message = input.trim(),
          ),
        ],
      ),
    );
  }

  Widget _purchaseDatePanel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 0),
      child: Column(
        children: [
          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Purchase Due Date : ",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
              SizedBox(width: widthDp * 5),
              Expanded(
                child: KeicyTextFormField(
                  controller: _dueDateController,
                  focusNode: _dueDateFocusNode,
                  width: double.infinity,
                  height: heightDp * 40,
                  border: Border.all(color: Colors.grey.withOpacity(0.6)),
                  borderRadius: heightDp * 6,
                  textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  hintText: "Choose Date",
                  hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                  contentHorizontalPadding: widthDp * 10,
                  contentVerticalPadding: heightDp * 8,
                  readOnly: true,
                  onTapHandler: () async {
                    DateTime? dateTime = await _selectPickupDateTimeHandler();
                    if (dateTime == null) return;

                    _purchaseModel.dueDate = dateTime;
                    _dueDateController!.text = KeicyDateTime.convertDateTimeToDateString(dateTime: dateTime, isUTC: false);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _selectPickupDateTimeHandler() async {
    DateTime? selecteDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
      selectableDayPredicate: (date) {
        if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
        if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
        return true;
      },
    );
    return selecteDate;
  }

  Widget _attachments() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.attach_file_outlined, size: heightDp * 25),
                  Text("Attachments", style: TextStyle(fontSize: fontSp * 16)),
                ],
              ),
              KeicyRaisedButton(
                width: widthDp * 100,
                height: heightDp * 30,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  "Choose",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result == null) return;

                  if (result.files.first.size / 1024 / 1024 > 20) {
                    ErrorDialog.show(
                      context,
                      widthDp: widthDp,
                      heightDp: heightDp,
                      fontSp: fontSp,
                      text: "Please choose the file less than 20 M",
                    );
                    return;
                  }

                  _attachFile = File(result.files.first.path!);
                  _fileName = result.files.first.name;
                  _size = double.parse((result.files.first.size / 1024 / 1024).toStringAsFixed(2));
                  setState(() {});
                },
              ),
            ],
          ),
          SizedBox(height: heightDp * 10),
          _attachFile == null
              ? Text("Maximum size : 20M", style: TextStyle(fontSize: fontSp * 16))
              : Text("$_fileName ($_size M)", style: TextStyle(fontSize: fontSp * 16)),
        ],
      ),
    );
  }
}
