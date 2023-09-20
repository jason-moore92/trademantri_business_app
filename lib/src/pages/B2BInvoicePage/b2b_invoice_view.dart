import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/maps_sheet.dart';
import 'package:trapp/src/elements/b2b_payment_detail_panel.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_order_b2b_widget.dart';
import 'package:trapp/src/elements/service_order_b2b_widget.dart';
import 'package:trapp/src/helpers/b2b_price_functions.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/product_item_bottom_sheet.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BusinessStoresPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class B2BInvoiceView extends StatefulWidget {
  final B2BOrderModel? b2bOrderModel;
  final bool? isEditItems;
  final bool? isChangeBusiness;

  B2BInvoiceView({
    Key? key,
    this.b2bOrderModel,
    this.isEditItems,
    this.isChangeBusiness,
  }) : super(key: key);

  @override
  _B2BInvoiceViewState createState() => _B2BInvoiceViewState();
}

class _B2BInvoiceViewState extends State<B2BInvoiceView> with SingleTickerProviderStateMixin {
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

  TextEditingController? _descriptionController = TextEditingController();
  TextEditingController? _paymentForController = TextEditingController();

  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _paymentForFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _isValidated = false;

  KeicyProgressDialog? _keicyProgressDialog;

  B2BOrderProvider? _b2bOrderProvider;

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

    _descriptionController = TextEditingController(text: widget.b2bOrderModel!.paymentFor);

    widget.b2bOrderModel!.orderType = B2BOrderType.delivery;

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _b2bOrderProvider = B2BOrderProvider.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _b2bOrderProvider!.addListener(_b2bOrderProviderListener);
    });
  }

  @override
  void dispose() {
    _b2bOrderProvider!.removeListener(_b2bOrderProviderListener);

    super.dispose();
  }

  void _b2bOrderProviderListener() async {
    if (_b2bOrderProvider!.b2bOrderState.sentProgressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_b2bOrderProvider!.b2bOrderState.sentProgressState == 2) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Order Placed Success",
        callBack: () {
          widget.b2bOrderModel!.status = AppConfig.b2bOrderStatusData[1]["id"];
          Navigator.of(context).pop(_b2bOrderProvider!.b2bOrderState.newB2bOrderModel);
        },
      );
    } else if (_b2bOrderProvider!.b2bOrderState.sentProgressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _b2bOrderProvider!.b2bOrderState.sentMessage ?? "Something was wrong",
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
    await _keicyProgressDialog!.show();

    _b2bOrderProvider!.addOrder(
      b2bOrderModel: widget.b2bOrderModel,
      status: AppConfig.b2bOrderStatusData[1]["id"],
    );
  }

  void _validationHandler() {
    _isValidated = true;

    if (widget.b2bOrderModel!.services!.isEmpty && widget.b2bOrderModel!.products!.isEmpty) {
      _isValidated = false;
    }

    if (_descriptionController!.text.trim().isEmpty) {
      _isValidated = false;
    }

    if (_paymentForController!.text.trim().isEmpty) {
      _isValidated = false;
    }

    if (widget.b2bOrderModel!.orderType == "Pickup" && widget.b2bOrderModel!.pickupDateTime == null) {
      _isValidated = false;
    }
  }

  void _calculateOrderPrice() {
    for (var i = 0; i < widget.b2bOrderModel!.products!.length; i++) {
      ProductOrderModel productOrderModel = widget.b2bOrderModel!.products![i];

      if (productOrderModel.productModel!.realBulkOrder! &&
          productOrderModel.productModel!.minQuantityForBulkOrder! > productOrderModel.orderQuantity!) {
        productOrderModel.orderPrice = productOrderModel.productModel!.price;
      } else {
        productOrderModel.orderPrice = productOrderModel.productModel!.price! - productOrderModel.productModel!.discount!;
      }

      if (productOrderModel.productModel!.taxType == null || productOrderModel.productModel!.taxType == AppConfig.taxTypes.first["value"]) {
      } else if (productOrderModel.productModel!.taxType == AppConfig.taxTypes.last["value"]) {
        double taxPrice = (productOrderModel.orderPrice! * productOrderModel.productModel!.taxPercentage!) / (100);
        productOrderModel.orderPrice = productOrderModel.orderPrice! + taxPrice;
      }
    }

    for (var i = 0; i < widget.b2bOrderModel!.services!.length; i++) {
      ServiceOrderModel serviceOrderModel = widget.b2bOrderModel!.services![i];

      if (serviceOrderModel.serviceModel!.realBulkOrder! &&
          serviceOrderModel.serviceModel!.minQuantityForBulkOrder! > serviceOrderModel.orderQuantity!) {
        serviceOrderModel.orderPrice = serviceOrderModel.serviceModel!.price;
      } else {
        serviceOrderModel.orderPrice = serviceOrderModel.serviceModel!.price! - serviceOrderModel.serviceModel!.discount!;
      }

      if (serviceOrderModel.serviceModel!.taxType == null || serviceOrderModel.serviceModel!.taxType == AppConfig.taxTypes.first["value"]) {
      } else if (serviceOrderModel.serviceModel!.taxType == AppConfig.taxTypes.last["value"]) {
        double taxPrice = (serviceOrderModel.orderPrice! * serviceOrderModel.serviceModel!.taxPercentage!) / (100);
        serviceOrderModel.orderPrice = serviceOrderModel.orderPrice! + taxPrice;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _calculateOrderPrice();

    _validationHandler();

    B2BPriceFunctions.calculateDiscount(b2bOrderModel: widget.b2bOrderModel!);
    widget.b2bOrderModel!.paymentDetail = B2BPriceFunctions.calclatePaymentDetail(b2bOrderModel: widget.b2bOrderModel!);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text("B2B Invoice", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///
                      SizedBox(height: heightDp * 15),
                      _businessPanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      if (widget.isEditItems!) _chooseItemPanel(),
                      SizedBox(height: heightDp * 5),
                      _productsPanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio<String?>(
                                      value: B2BOrderType.delivery,
                                      groupValue: widget.b2bOrderModel!.orderType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          widget.b2bOrderModel!.orderType = value;
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          widget.b2bOrderModel!.orderType = B2BOrderType.delivery;
                                        });
                                      },
                                      child: Text(
                                        "Delivery",
                                        style: TextStyle(
                                          fontSize: fontSp * 14,
                                          color:
                                              B2BOrderType.delivery == widget.b2bOrderModel!.orderType ? config.Colors().mainColor(1) : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio<String?>(
                                      value: B2BOrderType.pickup,
                                      groupValue: widget.b2bOrderModel!.orderType,
                                      onChanged: (String? value) {
                                        setState(() {
                                          widget.b2bOrderModel!.orderType = value;
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          setState(() {
                                            widget.b2bOrderModel!.orderType = B2BOrderType.pickup;
                                          });
                                        });
                                      },
                                      child: Text(
                                        "Pick up",
                                        style: TextStyle(
                                          fontSize: fontSp * 14,
                                          color: B2BOrderType.pickup == widget.b2bOrderModel!.orderType ? config.Colors().mainColor(1) : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (B2BOrderType.delivery == widget.b2bOrderModel!.orderType) _deliveryPanel(),
                      if (B2BOrderType.pickup == widget.b2bOrderModel!.orderType) _PickupPanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _descriptionPanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _paymentForPanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      _dueDatePanel(),

                      ///
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                      B2BPaymentDetailPanel(b2bOrderModel: widget.b2bOrderModel),

                      ///
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

  Widget _businessPanel() {
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
                      "Business Name",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        "${widget.b2bOrderModel!.businessStoreModel!.name}",
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
                      "Business Email",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    SizedBox(width: widthDp * 5),
                    Expanded(
                      child: Text(
                        (widget.b2bOrderModel!.businessStoreModel!.email.toString().length < 20
                            ? "${widget.b2bOrderModel!.businessStoreModel!.email}"
                            : "${widget.b2bOrderModel!.businessStoreModel!.email.toString().substring(0, 20)}..."),
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
          if (widget.isChangeBusiness!) SizedBox(height: heightDp * 10),
          if (widget.isChangeBusiness!)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                KeicyRaisedButton(
                  width: widthDp * 100,
                  height: heightDp * 30,
                  color: widget.b2bOrderModel!.businessStoreModel == null ? Colors.grey.withOpacity(0.7) : config.Colors().mainColor(1),
                  borderRadius: heightDp * 6,
                  child: Text(
                    "Change",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
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
                      widget.b2bOrderModel!.businessStoreModel = StoreModel.fromJson(result);
                      widget.b2bOrderModel!.products = [];
                      widget.b2bOrderModel!.services = [];
                      widget.b2bOrderModel!.deliveryAddress = AddressModel(
                        address: widget.b2bOrderModel!.businessStoreModel!.address,
                        city: widget.b2bOrderModel!.businessStoreModel!.city,
                        state: widget.b2bOrderModel!.businessStoreModel!.state,
                        zipCode: widget.b2bOrderModel!.businessStoreModel!.zipCode,
                        location: widget.b2bOrderModel!.businessStoreModel!.location,
                      );

                      setState(() {});
                    }
                  },
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
                color: widget.b2bOrderModel!.businessStoreModel == null ? Colors.grey.withOpacity(0.7) : config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  "Choose",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                ),
                onPressed: widget.b2bOrderModel!.businessStoreModel == null
                    ? null
                    : () {
                        List<ProductModel> productModels = [];
                        List<ServiceModel> serviceModels = [];

                        for (var i = 0; i < widget.b2bOrderModel!.products!.length; i++) {
                          productModels.add(widget.b2bOrderModel!.products![i].productModel!);
                        }

                        for (var i = 0; i < widget.b2bOrderModel!.services!.length; i++) {
                          serviceModels.add(widget.b2bOrderModel!.services![i].serviceModel!);
                        }

                        ProductItemBottomSheet.show(
                          context,
                          storeIds: [
                            AuthProvider.of(context).authState.storeModel!.id!,
                          ],
                          storeModel: AuthProvider.of(context).authState.storeModel,
                          selectedProducts: productModels,
                          selectedServices: serviceModels,
                          isShowCustom: false,
                          isForB2b: true,
                          showDetailButton: false,
                          callback: (String type, List<dynamic> items) {
                            if (type == "product") {
                              List<String?> productIds = [];
                              for (var k = 0; k < widget.b2bOrderModel!.products!.length; k++) {
                                productIds.add(widget.b2bOrderModel!.products![k].productModel!.id);
                              }

                              for (var i = 0; i < items.length; i++) {
                                ProductModel productModel = ProductModel.fromJson(items[i]);

                                if (productIds.contains(productModel.id)) {
                                  continue;
                                }

                                if (productModel.b2bPriceFrom != 0) {
                                  productModel.price = productModel.b2bPriceFrom;
                                  if (productModel.b2bDiscountValue != 0) {
                                    if (productModel.b2bDiscountType == "Amount") {
                                      productModel.discount = productModel.b2bDiscountValue;
                                    } else if (productModel.b2bDiscountType == "Percentage") {
                                      productModel.discount = (productModel.b2bDiscountValue! / 100) * productModel.b2bPriceFrom!;
                                    } else {
                                      productModel.discount = 0;
                                    }
                                  } else {
                                    productModel.discount = 0;
                                  }
                                  productModel.taxPercentage = productModel.b2bTaxPercentage;
                                  productModel.taxType = productModel.b2bTaxType ?? "Inclusive";
                                  productModel.acceptBulkOrder = productModel.b2bAcceptBulkOrder;
                                  productModel.realBulkOrder = productModel.b2bAcceptBulkOrder;
                                  productModel.minQuantityForBulkOrder = productModel.b2bMinQuantityForBulkOrder;
                                } else {
                                  productModel.acceptBulkOrder = false;
                                  productModel.realBulkOrder = false;
                                  productModel.minQuantityForBulkOrder = 0;
                                }

                                widget.b2bOrderModel!.products!.add(ProductOrderModel.fromJson({
                                  "orderQuantity": 1,
                                  "couponQuantity": 1,
                                  "data": productModel.toJson(),
                                }));
                              }
                            } else if (type == "service") {
                              List<String?> serviceIds = [];
                              for (var k = 0; k < widget.b2bOrderModel!.services!.length; k++) {
                                serviceIds.add(widget.b2bOrderModel!.services![k].serviceModel!.id);
                              }

                              for (var i = 0; i < items.length; i++) {
                                ServiceModel serviceModel = ServiceModel.fromJson(items[i]);

                                if (serviceIds.contains(serviceModel.id)) {
                                  continue;
                                }

                                if (serviceModel.b2bPriceFrom != 0) {
                                  serviceModel.price = serviceModel.b2bPriceFrom;
                                  if (serviceModel.b2bDiscountValue != 0) {
                                    if (serviceModel.b2bDiscountType == "Amount") {
                                      serviceModel.discount = serviceModel.b2bDiscountValue;
                                    } else if (serviceModel.b2bDiscountType == "Percentage") {
                                      serviceModel.discount = (serviceModel.b2bDiscountValue! / 100) * serviceModel.b2bPriceFrom!;
                                    } else {
                                      serviceModel.discount = 0;
                                    }
                                  } else {
                                    serviceModel.discount = 0;
                                  }
                                  serviceModel.taxPercentage = serviceModel.b2bTaxPercentage;
                                  serviceModel.taxType = serviceModel.b2bTaxType ?? "Inclusive";
                                  serviceModel.acceptBulkOrder = serviceModel.b2bAcceptBulkOrder;
                                  serviceModel.realBulkOrder = serviceModel.b2bAcceptBulkOrder;
                                  serviceModel.minQuantityForBulkOrder = serviceModel.b2bMinQuantityForBulkOrder;
                                } else {
                                  serviceModel.acceptBulkOrder = false;
                                  serviceModel.realBulkOrder = false;
                                  serviceModel.minQuantityForBulkOrder = 0;
                                }

                                widget.b2bOrderModel!.services!.add(ServiceOrderModel.fromJson({
                                  "orderQuantity": 1,
                                  "couponQuantity": 1,
                                  "data": serviceModel.toJson(),
                                }));
                              }
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
          children: List.generate(widget.b2bOrderModel!.products!.length, (index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ProductOrderB2BWidget(
                    productOrderModel: widget.b2bOrderModel!.products![index],
                    index: index,
                    readOnly: !widget.isEditItems!,
                    isAddQuantity: true,
                    isShowReductDialog: false,
                    deleteCallback: (String id) {
                      int? deleteIndex;
                      for (var i = 0; i < widget.b2bOrderModel!.products!.length; i++) {
                        if (widget.b2bOrderModel!.products![i].productModel!.id == id) {
                          deleteIndex = i;
                          break;
                        }
                      }
                      if (deleteIndex != null) {
                        widget.b2bOrderModel!.products!.removeAt(deleteIndex);
                        setState(() {});
                        return;
                      }
                    },
                    refreshCallback: (ProductOrderModel? productOrderModel) {
                      if (productOrderModel == null) return;

                      for (var i = 0; i < widget.b2bOrderModel!.products!.length; i++) {
                        if (widget.b2bOrderModel!.products![i].productModel!.id == productOrderModel.productModel!.id) {
                          widget.b2bOrderModel!.products![i] = productOrderModel;
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
          children: List.generate(widget.b2bOrderModel!.services!.length, (index) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ServiceOrderB2BWidget(
                    serviceOrderModel: widget.b2bOrderModel!.services![index],
                    index: index,
                    readOnly: !widget.isEditItems!,
                    isAddQuantity: true,
                    isShowReductDialog: false,
                    deleteCallback: (String id) {
                      int? deleteIndex;
                      for (var i = 0; i < widget.b2bOrderModel!.services!.length; i++) {
                        if (widget.b2bOrderModel!.services![i].serviceModel!.id == id) {
                          deleteIndex = i;
                          break;
                        }
                      }
                      if (deleteIndex != null) {
                        widget.b2bOrderModel!.services!.removeAt(deleteIndex);
                        setState(() {});
                        return;
                      }
                    },
                    refreshCallback: (ServiceOrderModel? serviceOrderModel) {
                      if (serviceOrderModel == null) return;

                      for (var i = 0; i < widget.b2bOrderModel!.services!.length; i++) {
                        if (widget.b2bOrderModel!.services![i].serviceModel!.id == serviceOrderModel.serviceModel!.id) {
                          widget.b2bOrderModel!.services![i] = serviceOrderModel;
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

  Widget _deliveryPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Delivery Address",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: widthDp * 10),
                  GestureDetector(
                    onTap: () {
                      MapsSheet.show(
                        context: context,
                        onMapTap: (map) {
                          map.showMarker(
                            coords: Coords(
                              widget.b2bOrderModel!.deliveryAddress!.location!.latitude,
                              widget.b2bOrderModel!.deliveryAddress!.location!.longitude,
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
                    widget.b2bOrderModel!.deliveryAddress = AddressModel.fromJson({
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
            "${widget.b2bOrderModel!.deliveryAddress!.address}",
            style: TextStyle(fontSize: fontSp * 14),
          ),
        ],
      ),
    );
  }

  Widget _PickupPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Pickup Address:",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: widthDp * 10),
                  GestureDetector(
                    onTap: () {
                      MapsSheet.show(
                        context: context,
                        onMapTap: (map) {
                          map.showMarker(
                            coords: Coords(
                              widget.b2bOrderModel!.myStoreModel!.location!.latitude,
                              widget.b2bOrderModel!.myStoreModel!.location!.longitude,
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
            ],
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "${widget.b2bOrderModel!.myStoreModel!.address}",
            style: TextStyle(fontSize: fontSp * 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: heightDp * 15),
                child: Row(
                  children: [
                    Text(
                      widget.b2bOrderModel!.pickupDateTime == null
                          ? "Please select date"
                          : "${KeicyDateTime.convertDateTimeToDateString(
                              dateTime: widget.b2bOrderModel!.pickupDateTime!,
                              formats: 'Y-m-d',
                              isUTC: false,
                            )}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    widget.b2bOrderModel!.pickupDateTime == null
                        ? Text(
                            " *",
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.red, fontWeight: FontWeight.bold),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _selectPickupDateTimeHandler,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                  decoration: BoxDecoration(color: config.Colors().mainColor(1), borderRadius: BorderRadius.circular(heightDp * 6)),
                  child: Text(
                    "Pick a date",
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _selectPickupDateTimeHandler() async {
    DateTime initialTime = DateTime.now();
    while (!_decideDate(initialTime)) {
      initialTime = initialTime.add(Duration(days: 1));
    }

    DateTime pickupDateTime = widget.b2bOrderModel!.pickupDateTime != null ? widget.b2bOrderModel!.pickupDateTime!.toLocal() : initialTime;

    DateTime? selecteDate = await showDatePicker(
      context: context,
      initialDate: pickupDateTime,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
      selectableDayPredicate: _decideDate,
    );
    if (selecteDate == null) return;

    // Map<String, DateTime> openCloseTime = _getOpenColseTime(selecteDate);

    // TimeOfDay time = await showCustomTimePicker(
    //   context: context,
    //   onFailValidation: (context) => print('Unavailable selection'),
    //   initialTime: openCloseTime["openTime"] != null
    //       ? TimeOfDay(hour: openCloseTime["openTime"].hour, minute: openCloseTime["openTime"].minute)
    //       : TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute),
    //   selectableTimePredicate: (time) {
    //     if (openCloseTime["openTime"] == null || openCloseTime["closeTime"] == null) return true;
    //     if (selecteDate.add(Duration(hours: time.hour, minutes: time.minute)).difference(openCloseTime["openTime"]).inSeconds >= 0 &&
    //         selecteDate.add(Duration(hours: time.hour, minutes: time.minute)).difference(openCloseTime["closeTime"]).inSeconds <= 0) {
    //       return true;
    //     }
    //     return false;
    //   },
    // );

    // if (time == null) return;
    // selecteDate = selecteDate.add(Duration(hours: time.hour, minutes: time.minute));
    setState(() {
      widget.b2bOrderModel!.pickupDateTime = selecteDate;
    });
  }

  bool _decideDate(DateTime dateTime) {
    if (dateTime.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
    if (dateTime.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
    return true;
  }

  Widget _descriptionPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Message On Invoice",
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
              widget.b2bOrderModel!.description = input.trim();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _paymentForPanel() {
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
            focusNode: _paymentForFocusNode,
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
              widget.b2bOrderModel!.paymentFor = input.trim();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _dueDatePanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Invoice Due Date",
            style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
          ),
          Text(
            KeicyDateTime.convertDateTimeToDateString(dateTime: widget.b2bOrderModel!.dueDate, isUTC: false),
            style: TextStyle(fontSize: fontSp * 14),
          ),
        ],
      ),
    );
  }

  Widget _paymentLinkButton() {
    return Center(
      child: KeicyRaisedButton(
        width: widthDp * 180,
        height: heightDp * 35,
        color: _isValidated ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
        borderRadius: heightDp * 6,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
        child: Text(
          "Create B2B Invoice",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: _isValidated ? _placeOrderHandler : null,
      ),
    );
  }
}
