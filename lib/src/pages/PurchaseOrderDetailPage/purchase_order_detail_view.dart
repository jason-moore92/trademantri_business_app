import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/product_for_purchase_widget.dart';
import 'package:trapp/src/elements/service_for_purchase_widget.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/B2BInvoicePage/b2b_invoice_page.dart';
import 'package:trapp/src/providers/index.dart';

class PurchaseDetailView extends StatefulWidget {
  final PurchaseModel? purchaseModel;

  PurchaseDetailView({Key? key, this.purchaseModel}) : super(key: key);

  @override
  _PurchaseDetailViewState createState() => _PurchaseDetailViewState();
}

class _PurchaseDetailViewState extends State<PurchaseDetailView> with SingleTickerProviderStateMixin {
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

  PurchaseModel? _purchaseModel;
  DateTime? _dueDate;

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

    widget.purchaseModel!.purchaseProducts!.sort((a, b) {
      return a.updateAt!.isAfter(b.updateAt!) ? -1 : 1;
    });

    widget.purchaseModel!.purchaseServices!.sort((a, b) {
      return a.updateAt!.isAfter(b.updateAt!) ? -1 : 1;
    });

    _purchaseModel = PurchaseModel.copy(widget.purchaseModel!);

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateHandler() async {
    await _keicyProgressDialog!.show();
    _purchaseModel!.status = "update";
    var result = await PurchaseOrderApiProvider.updatePurchaseOrder(purchaseModel: _purchaseModel);
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Purchase Order Update Success",
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

  void _cancelHandler() async {
    await _keicyProgressDialog!.show();
    for (var i = 0; i < _purchaseModel!.purchaseProducts!.length; i++) {
      if (_purchaseModel!.purchaseProducts![i].status == AppConfig.purchaseItemStatus["open"]) {
        _purchaseModel!.purchaseProducts![i].status = AppConfig.purchaseItemStatus["close"];
      }
    }
    for (var i = 0; i < _purchaseModel!.purchaseServices!.length; i++) {
      if (_purchaseModel!.purchaseServices![i].status == AppConfig.purchaseItemStatus["open"]) {
        _purchaseModel!.purchaseServices![i].status = AppConfig.purchaseItemStatus["close"];
      }
    }

    _purchaseModel!.status = "cancel";
    var result = await PurchaseOrderApiProvider.updatePurchaseOrder(purchaseModel: _purchaseModel);
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Purchase Order updated successfully",
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

  void _rejectHandler() async {
    await _keicyProgressDialog!.show();
    for (var i = 0; i < _purchaseModel!.purchaseProducts!.length; i++) {
      if (_purchaseModel!.purchaseProducts![i].status == AppConfig.purchaseItemStatus["open"]) {
        _purchaseModel!.purchaseProducts![i].status = AppConfig.purchaseItemStatus["reject"];
      }
    }
    for (var i = 0; i < _purchaseModel!.purchaseServices!.length; i++) {
      if (_purchaseModel!.purchaseServices![i].status == AppConfig.purchaseItemStatus["open"]) {
        _purchaseModel!.purchaseServices![i].status = AppConfig.purchaseItemStatus["reject"];
      }
    }

    _purchaseModel!.status = "reject";
    var result = await PurchaseOrderApiProvider.updatePurchaseOrder(purchaseModel: _purchaseModel);
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

  void _acceptHandler() async {
    List<PurchaseItemModel> purchaseProducts = [];
    List<dynamic> purchaseProductIds = [];

    B2BOrderModel _b2bOrderModel = B2BOrderModel();
    List<ProductOrderModel> _productOrderModels = [];
    List<ServiceOrderModel> _serviceOrderModels = [];

    for (var i = _purchaseModel!.purchaseProducts!.length - 1; i >= 0; i--) {
      if (_purchaseModel!.purchaseProducts![i].status == AppConfig.purchaseItemStatus["open"]) {
        purchaseProductIds.add(_purchaseModel!.purchaseProducts![i].productId);
        _purchaseModel!.purchaseProducts![i].updateAt = DateTime.now();
        purchaseProducts.add(_purchaseModel!.purchaseProducts![i]);

        ///
        _productOrderModels.add(ProductOrderModel.fromJson({
          "orderQuantity": purchaseProducts.last.quantity,
          "couponQuantity": purchaseProducts.last.quantity,
          "orderPrice": purchaseProducts.last.orderPrice,
          "promocodeDiscount": 0,
          "promocodePercent": 0,
          "couponDiscount": 0,
          "taxType": purchaseProducts.last.taxType,
          "taxPercentage": purchaseProducts.last.taxPercentage,
          "taxPriceBeforeDiscount": purchaseProducts.last.taxPrice,
          "taxPriceAfterCouponDiscount": purchaseProducts.last.taxPrice,
          "taxPriceAfterDiscount": purchaseProducts.last.taxPrice,
          "data": _purchaseModel!.productsData![purchaseProducts.last.productId]!.toJson(),
        }));

        _productOrderModels.last.productModel!.b2bPriceFrom = purchaseProducts.last.orderPrice;
        _productOrderModels.last.productModel!.b2bDiscount = 0;
        _productOrderModels.last.productModel!.b2bTaxPercentage = 0;
        _productOrderModels.last.productModel!.b2bTaxType = purchaseProducts.last.taxType;
      }
    }

    List<PurchaseItemModel> purchaseServices = [];
    List<dynamic> purchaseServiceIds = [];
    for (var i = _purchaseModel!.purchaseServices!.length - 1; i >= 0; i--) {
      if (_purchaseModel!.purchaseServices![i].status == AppConfig.purchaseItemStatus["open"]) {
        purchaseServiceIds.add(_purchaseModel!.purchaseServices![i].productId);
        _purchaseModel!.purchaseServices![i].updateAt = DateTime.now();
        purchaseServices.add(_purchaseModel!.purchaseServices![i]);

        ///
        _serviceOrderModels.add(ServiceOrderModel.fromJson({
          "orderQuantity": purchaseServices.last.quantity,
          "couponQuantity": purchaseServices.last.quantity,
          "orderPrice": purchaseServices.last.orderPrice,
          "promocodeDiscount": 0,
          "promocodePercent": 0,
          "couponDiscount": 0,
          "taxType": purchaseServices.last.taxType,
          "taxPercentage": purchaseServices.last.taxPercentage,
          "taxPriceBeforeDiscount": purchaseServices.last.taxPrice,
          "taxPriceAfterCouponDiscount": purchaseServices.last.taxPrice,
          "taxPriceAfterDiscount": purchaseServices.last.taxPrice,
          "data": _purchaseModel!.servicesData![purchaseServices.last.productId]!.toJson(),
        }));
        _serviceOrderModels.last.serviceModel!.b2bPriceFrom = purchaseServices.last.orderPrice;
        _serviceOrderModels.last.serviceModel!.b2bDiscount = 0;
        _serviceOrderModels.last.serviceModel!.b2bTaxPercentage = 0;
        _serviceOrderModels.last.serviceModel!.b2bTaxType = purchaseServices.last.taxType;
      }
    }

    _b2bOrderModel.category = B2BOrderCategory.invoice;
    _b2bOrderModel.myStoreModel = _purchaseModel!.businessStoreModel;
    _b2bOrderModel.businessStoreModel = _purchaseModel!.myStoreModel;
    _b2bOrderModel.products = _productOrderModels;
    _b2bOrderModel.services = _serviceOrderModels;
    _b2bOrderModel.deliveryAddress = _purchaseModel!.shippingAddress;
    _b2bOrderModel.invoiceDate = DateTime.now();
    _b2bOrderModel.dueDate = _purchaseModel!.dueDate;

    var result1 = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => B2BInvoicePage(
          b2bOrderModel: _b2bOrderModel,
        ),
      ),
    );

    if (result1 == null) return;

    await _keicyProgressDialog!.show();

    for (var i = 0; i < purchaseProducts.length; i++) {
      purchaseProducts[i].status = AppConfig.purchaseItemStatus["fullfilled"];
    }
    for (var i = 0; i < purchaseServices.length; i++) {
      purchaseServices[i].status = AppConfig.purchaseItemStatus["fullfilled"];
    }

    for (var i = widget.purchaseModel!.purchaseProducts!.length - 1; i >= 0; i--) {
      if (purchaseProductIds.contains(widget.purchaseModel!.purchaseProducts![i].productId)) {
        int index = purchaseProductIds.indexOf(widget.purchaseModel!.purchaseProducts![i].productId);

        if (widget.purchaseModel!.purchaseProducts![i].status == AppConfig.purchaseItemStatus["open"] &&
            widget.purchaseModel!.purchaseProducts![i].quantity != purchaseProducts[index].quantity) {
          PurchaseItemModel purchaseItemModel = PurchaseItemModel.copy(widget.purchaseModel!.purchaseProducts![i]);
          purchaseItemModel.quantity = widget.purchaseModel!.purchaseProducts![i].quantity! - purchaseProducts[index].quantity!;
          purchaseItemModel.updateAt = DateTime.now();
          purchaseProducts.add(purchaseItemModel);
        } else if (widget.purchaseModel!.purchaseProducts![i].status != AppConfig.purchaseItemStatus["open"]) {
          purchaseProducts.add(widget.purchaseModel!.purchaseProducts![i]);
        }
      } else {
        purchaseProducts.add(widget.purchaseModel!.purchaseProducts![i]);
      }
    }

    for (var i = widget.purchaseModel!.purchaseServices!.length - 1; i >= 0; i--) {
      if (purchaseServiceIds.contains(widget.purchaseModel!.purchaseServices![i].productId)) {
        int index = purchaseServiceIds.indexOf(widget.purchaseModel!.purchaseServices![i].productId);

        if (widget.purchaseModel!.purchaseServices![i].status == AppConfig.purchaseItemStatus["open"] &&
            widget.purchaseModel!.purchaseServices![i].quantity != purchaseServices[index].quantity) {
          PurchaseItemModel purchaseItemModel = PurchaseItemModel.copy(widget.purchaseModel!.purchaseServices![i]);
          purchaseItemModel.quantity = widget.purchaseModel!.purchaseServices![i].quantity! - purchaseServices[index].quantity!;
          purchaseItemModel.updateAt = DateTime.now();
          purchaseServices.add(purchaseItemModel);
        } else if (widget.purchaseModel!.purchaseServices![i].status != AppConfig.purchaseItemStatus["open"]) {
          purchaseServices.add(widget.purchaseModel!.purchaseServices![i]);
        }
      } else {
        purchaseServices.add(widget.purchaseModel!.purchaseServices![i]);
      }
    }

    _purchaseModel!.purchaseProducts = purchaseProducts;
    _purchaseModel!.purchaseServices = purchaseServices;

    _purchaseModel!.status = "accept";
    var result = await PurchaseOrderApiProvider.updatePurchaseOrder(purchaseModel: _purchaseModel);
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Purchase Order Accept Success",
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

  @override
  Widget build(BuildContext context) {
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
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
          title: Text("Purchase Order Detail", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: heightDp * 15),
                    _businessPanel(),

                    ///
                    _openProductsPanel(),

                    ///
                    _fullProductsPanel(),

                    ///
                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _purchaseDatePanel(),

                    ///
                    Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    _messagePanel(),

                    ///
                    if (_purchaseModel!.attachFile != "")
                      Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
                    if (_purchaseModel!.attachFile != "") _attachments(),

                    ///
                    SizedBox(height: heightDp * 20),
                    _purchaseModel!.myStoreModel!.id == AuthProvider.of(context).authState.storeModel!.id
                        ? _sentButtonPanel()
                        : _receiveButtonPanel(),
                    SizedBox(height: heightDp * 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _businessPanel() {
    StoreModel? businessStoreModel;
    StoreModel? myStoreModel;

    myStoreModel = _purchaseModel!.myStoreModel;
    businessStoreModel = _purchaseModel!.businessStoreModel;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Business Name : ",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Text(
                  "${businessStoreModel!.name}",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Business Email : ",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: widthDp * 5),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      (businessStoreModel.email.toString().length < 20
                          ? "${businessStoreModel.email}"
                          : "${businessStoreModel.email.toString().substring(0, 20)}..."),
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 10),
          Text(
            "Mailing Address : ",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "${_purchaseModel!.mailingAddress}",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          ),

          ///
          SizedBox(height: heightDp * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ship To : ",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Text(
                  "${myStoreModel!.name}",
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
              Text(
                "Shipping Address : ",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: heightDp * 5),
              Text(
                "${_purchaseModel!.shippingAddress!.address}",
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
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Text(
                  "${_purchaseModel!.shipVia}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
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
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Text(
                  "${_purchaseModel!.salesRep}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
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
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: widthDp * 5),
              Expanded(
                child: Text(
                  "${KeicyDateTime.convertDateTimeToDateString(dateTime: _purchaseModel!.purchaseDate, isUTC: false)}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _openProductsPanel() {
    int totalIndex = 0;

    for (PurchaseItemModel product in _purchaseModel!.purchaseProducts!) {
      if (product.status == AppConfig.purchaseItemStatus["open"]) totalIndex++;
    }

    for (PurchaseItemModel service in _purchaseModel!.purchaseServices!) {
      if (service.status == AppConfig.purchaseItemStatus["open"]) totalIndex++;
    }

    if (totalIndex == 0) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
        Column(
          children: List.generate(_purchaseModel!.purchaseProducts!.length, (index) {
            if (_purchaseModel!.purchaseProducts![index].status != AppConfig.purchaseItemStatus["open"]) return SizedBox();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ProductPuchaseWidget(
                    purchaseModel: _purchaseModel,
                    purchaseItemModel: _purchaseModel!.purchaseProducts![index],
                    maxAmount: widget.purchaseModel!.purchaseProducts![index].quantity!,
                    index: index,
                    showStatus: true,
                    isReadOnly: _purchaseModel!.purchaseProducts![index].status != AppConfig.purchaseItemStatus["open"],
                    isAddable: _purchaseModel!.myStoreModel!.id == AuthProvider.of(context).authState.storeModel!.id,
                    deleteCallback: (String id, int index) {
                      _purchaseModel!.purchaseProducts!.removeAt(index);
                      setState(() {});
                    },
                    refreshCallback: (PurchaseItemModel? productPurchaseModel, int index) {
                      if (productPurchaseModel == null) return;

                      _purchaseModel!.purchaseProducts![index] = productPurchaseModel;

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
          children: List.generate(_purchaseModel!.purchaseServices!.length, (index) {
            if (_purchaseModel!.purchaseServices![index].status != AppConfig.purchaseItemStatus["open"]) return SizedBox();
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ServicePurchaseWidget(
                    purchaseModel: _purchaseModel,
                    purchaseItemModel: _purchaseModel!.purchaseServices![index],
                    index: index,
                    maxAmount: widget.purchaseModel!.purchaseServices![index].quantity!,
                    showStatus: true,
                    isReadOnly: _purchaseModel!.purchaseServices![index].status != AppConfig.purchaseItemStatus["open"],
                    isAddable: _purchaseModel!.myStoreModel!.id == AuthProvider.of(context).authState.storeModel!.id,
                    deleteCallback: (String id, int index) {
                      _purchaseModel!.purchaseServices!.removeAt(index);
                      setState(() {});
                    },
                    refreshCallback: (PurchaseItemModel? productPurchaseModel, int index) {
                      if (productPurchaseModel == null) return;
                      _purchaseModel!.purchaseServices![index] = productPurchaseModel;

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

  Widget _fullProductsPanel() {
    int totalIndex = 0;

    for (PurchaseItemModel product in _purchaseModel!.purchaseProducts!) {
      if (product.status != AppConfig.purchaseItemStatus["open"]) totalIndex++;
    }

    for (PurchaseItemModel service in _purchaseModel!.purchaseServices!) {
      if (service.status != AppConfig.purchaseItemStatus["open"]) totalIndex++;
    }

    if (totalIndex == 0) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: heightDp * 30, thickness: heightDp * 3, color: Colors.grey.withOpacity(0.4)),
        Column(
          children: List.generate(_purchaseModel!.purchaseProducts!.length, (index) {
            if (_purchaseModel!.purchaseProducts![index].status == AppConfig.purchaseItemStatus["open"]) return SizedBox();
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ProductPuchaseWidget(
                    purchaseModel: _purchaseModel,
                    purchaseItemModel: _purchaseModel!.purchaseProducts![index],
                    maxAmount: widget.purchaseModel!.purchaseProducts![index].quantity!,
                    index: index,
                    showStatus: true,
                    isReadOnly: _purchaseModel!.purchaseProducts![index].status != AppConfig.purchaseItemStatus["open"],
                    isAddable: _purchaseModel!.myStoreModel!.id == AuthProvider.of(context).authState.storeModel!.id,
                    deleteCallback: (String id, int index) {
                      _purchaseModel!.purchaseProducts!.removeAt(index);
                      setState(() {});
                    },
                    refreshCallback: (PurchaseItemModel? productPurchaseModel, int index) {
                      if (productPurchaseModel == null) return;

                      _purchaseModel!.purchaseProducts![index] = productPurchaseModel;

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
          children: List.generate(_purchaseModel!.purchaseServices!.length, (index) {
            if (_purchaseModel!.purchaseServices![index].status == AppConfig.purchaseItemStatus["open"]) return SizedBox();
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                  child: ServicePurchaseWidget(
                    purchaseModel: _purchaseModel,
                    purchaseItemModel: _purchaseModel!.purchaseServices![index],
                    index: index,
                    maxAmount: widget.purchaseModel!.purchaseServices![index].quantity!,
                    showStatus: true,
                    isReadOnly: _purchaseModel!.purchaseServices![index].status != AppConfig.purchaseItemStatus["open"],
                    isAddable: _purchaseModel!.myStoreModel!.id == AuthProvider.of(context).authState.storeModel!.id,
                    deleteCallback: (String id, int index) {
                      _purchaseModel!.purchaseServices!.removeAt(index);
                      setState(() {});
                    },
                    refreshCallback: (PurchaseItemModel? productPurchaseModel, int index) {
                      if (productPurchaseModel == null) return;
                      _purchaseModel!.purchaseServices![index] = productPurchaseModel;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Message on Purchase Order : ",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: widthDp * 10),
          Text(
            "${_purchaseModel!.message}",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
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
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: widthDp * 5),
              Expanded(
                child: Text(
                  "${KeicyDateTime.convertDateTimeToDateString(dateTime: _purchaseModel!.dueDate, isUTC: false)}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              Text(
                "${_purchaseModel!.attachFile!.split('/').last}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sentButtonPanel() {
    bool isAvailable = false;
    for (var i = 0; i < _purchaseModel!.purchaseProducts!.length; i++) {
      if (_purchaseModel!.purchaseProducts![i].status == AppConfig.purchaseItemStatus["open"]) {
        isAvailable = true;
        break;
      }
    }
    for (var i = 0; i < _purchaseModel!.purchaseServices!.length; i++) {
      if (_purchaseModel!.purchaseServices![i].status == AppConfig.purchaseItemStatus["open"]) {
        isAvailable = true;
        break;
      }
    }

    if (!isAvailable) return SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        KeicyRaisedButton(
          width: widthDp * 120,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 6,
          child: Text(
            "Update",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
          ),
          onPressed: _updateHandler,
        ),
        KeicyRaisedButton(
          width: widthDp * 120,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 6,
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              content: "Do you want really to cancel?",
              callback: () {
                _cancelHandler();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _receiveButtonPanel() {
    bool isAvailable = false;
    for (var i = 0; i < _purchaseModel!.purchaseProducts!.length; i++) {
      if (_purchaseModel!.purchaseProducts![i].status == AppConfig.purchaseItemStatus["open"]) {
        isAvailable = true;
        break;
      }
    }
    for (var i = 0; i < _purchaseModel!.purchaseServices!.length; i++) {
      if (_purchaseModel!.purchaseServices![i].status == AppConfig.purchaseItemStatus["open"]) {
        isAvailable = true;
        break;
      }
    }

    if (!isAvailable) return SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        KeicyRaisedButton(
          width: widthDp * 120,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 6,
          child: Text(
            "Accept",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              content: "You are accepting this Purchase Order from ${_purchaseModel!.myStoreModel!.name}, "
                  "based on availability and prices you can edit before you generate invoice. "
                  "Is everything good to generate invoice?",
              okayButton: "Generate Invoice",
              cancelButton: "Cancel",
              callback: () {
                _acceptHandler();
              },
            );
          },
        ),
        KeicyRaisedButton(
          width: widthDp * 120,
          height: heightDp * 30,
          color: config.Colors().mainColor(1),
          borderRadius: heightDp * 6,
          child: Text(
            "Reject",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
          ),
          onPressed: () {
            NormalAskDialog.show(
              context,
              content: "Do you want really to reject?",
              callback: () {
                _rejectHandler();
              },
            );
          },
        ),
      ],
    );
  }
}
