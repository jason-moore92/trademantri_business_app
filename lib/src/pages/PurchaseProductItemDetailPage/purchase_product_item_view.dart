import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_for_purchase_widget.dart';
import 'package:trapp/src/elements/service_for_purchase_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/purchase_model.dart';
import 'package:trapp/src/providers/index.dart';

class PurchaseProductItemDetailView extends StatefulWidget {
  final String? category;
  final PurchaseModel? purchaseModel;
  final PurchaseItemModel? purchaseItemModel;

  PurchaseProductItemDetailView({
    Key? key,
    this.category,
    this.purchaseModel,
    this.purchaseItemModel,
  }) : super(key: key);

  @override
  _PurchaseProductItemDetailViewState createState() => _PurchaseProductItemDetailViewState();
}

class _PurchaseProductItemDetailViewState extends State<PurchaseProductItemDetailView> with SingleTickerProviderStateMixin {
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

// FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}")),
//                       FilteringTextInputFormatter.allow(RegExp(r"^100(\.0{0,2}?)?$|^\d{0,2}(\.\d{0,2})?$")),

  TextEditingController? _priceController = TextEditingController();
  TextEditingController? _quantityController = TextEditingController();

  FocusNode _priceFocusNode = FocusNode();
  FocusNode _quantityFocusNode = FocusNode();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  PurchaseHistoryProvider? _purchaseHistoryProvider;

  RefreshController _refreshController = RefreshController();

  String status = "";

  PurchaseItemModel? _purchaseItemModel;

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    _purchaseItemModel = PurchaseItemModel.copy(widget.purchaseItemModel!);

    _priceController!.text = _purchaseItemModel!.itemPrice != 0 ? numFormat.format(_purchaseItemModel!.itemPrice) : "";
    _quantityController!.text = _purchaseItemModel!.quantity != 0 ? numFormat.format(_purchaseItemModel!.quantity) : "";

    if (_purchaseItemModel!.taxType == null || _purchaseItemModel!.taxType == "") _purchaseItemModel!.taxType = AppConfig.taxTypes.first["value"];

    _purchaseHistoryProvider = PurchaseHistoryProvider.of(context);

    status =
        "${widget.category}-${widget.purchaseModel!.myStoreModel!.id}-${widget.purchaseModel!.businessStoreModel!.id}-${_purchaseItemModel!.productId}";

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _purchaseHistoryProvider!.addListener(_purchaseHistoryProviderListener);

      if (_purchaseHistoryProvider!.purchaseHistoryState.itemList![status] == null) {
        _purchaseHistoryProvider!.setPurchaseHistoryState(
          _purchaseHistoryProvider!.purchaseHistoryState.update(
            progressState: 1,
          ),
        );

        _purchaseHistoryProvider!.getPurchaseHistoryData(
          myStoreId: widget.purchaseModel!.myStoreModel!.id,
          businessStoreId: widget.purchaseModel!.businessStoreModel!.id,
          itemId: _purchaseItemModel!.productId,
          category: widget.category,
        );
      }
    });
  }

  @override
  void dispose() {
    _purchaseHistoryProvider!.removeListener(_purchaseHistoryProviderListener);
    super.dispose();
  }

  void _purchaseHistoryProviderListener() async {
    if (_purchaseHistoryProvider!.purchaseHistoryState.progressState == -1) {
      if (_purchaseHistoryProvider!.purchaseHistoryState.isRefresh!) {
        _refreshController.refreshFailed();
        _purchaseHistoryProvider!.setPurchaseHistoryState(
          _purchaseHistoryProvider!.purchaseHistoryState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadFailed();
      }
    } else if (_purchaseHistoryProvider!.purchaseHistoryState.progressState == 2) {
      if (_purchaseHistoryProvider!.purchaseHistoryState.isRefresh!) {
        _refreshController.refreshCompleted();
        _purchaseHistoryProvider!.setPurchaseHistoryState(
          _purchaseHistoryProvider!.purchaseHistoryState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? itemList = _purchaseHistoryProvider!.purchaseHistoryState.itemList;
    Map<String, dynamic>? itemListMetaData = _purchaseHistoryProvider!.purchaseHistoryState.itemListMetaData;

    itemList![status] = [];
    itemListMetaData![status] = Map<String, dynamic>();
    _purchaseHistoryProvider!.setPurchaseHistoryState(
      _purchaseHistoryProvider!.purchaseHistoryState.update(
        progressState: 1,
        itemList: itemList,
        itemListMetaData: itemListMetaData,
        isRefresh: true,
      ),
    );

    _purchaseHistoryProvider!.getPurchaseHistoryData(
      myStoreId: widget.purchaseModel!.myStoreModel!.id,
      businessStoreId: widget.purchaseModel!.businessStoreModel!.id,
      itemId: _purchaseItemModel!.productId,
      category: widget.category,
    );
  }

  void _onLoading() async {
    _purchaseHistoryProvider!.setPurchaseHistoryState(
      _purchaseHistoryProvider!.purchaseHistoryState.update(progressState: 1),
    );

    _purchaseHistoryProvider!.getPurchaseHistoryData(
      myStoreId: widget.purchaseModel!.myStoreModel!.id,
      businessStoreId: widget.purchaseModel!.businessStoreModel!.id,
      itemId: _purchaseItemModel!.productId,
      category: widget.category,
    );
  }

  void _saveHandler() {
    if (!_formkey.currentState!.validate()) return;
    _formkey.currentState!.save();

    Navigator.of(context).pop(_purchaseItemModel);
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text("Purchase Order Product Details", style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
          // elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: deviceHeight - statusbarHeight - appbarHeight,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: _mainPanel(),
                  ),
                ),
                SizedBox(height: heightDp * 20),
                KeicyRaisedButton(
                  width: widthDp * 140,
                  height: heightDp * 35,
                  color: config.Colors().mainColor(1),
                  borderRadius: heightDp * 6,
                  child: Text("Save", style: TextStyle(fontSize: fontSp * 16, color: Colors.white)),
                  onPressed: _saveHandler,
                ),
                SizedBox(height: heightDp * 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainPanel() {
    if (!_purchaseItemModel!.acceptBulkOrder! || _purchaseItemModel!.quantity! >= _purchaseItemModel!.minQuantityForBulkOrder!) {
      _purchaseItemModel!.itemPrice = _purchaseItemModel!.price! - _purchaseItemModel!.discount!;
    } else {
      _purchaseItemModel!.itemPrice = _purchaseItemModel!.price;
    }
    _priceController!.text = _purchaseItemModel!.itemPrice != 0 ? numFormat.format(_purchaseItemModel!.itemPrice) : "";

    // _purchaseItemModel!.taxPrice = _purchaseItemModel!.itemPrice! * _purchaseItemModel!.taxPercentage! / 100;

    if (_purchaseItemModel!.taxType == AppConfig.taxTypes.first["value"]) {
      _purchaseItemModel!.taxPrice =
          (_purchaseItemModel!.itemPrice! * _purchaseItemModel!.taxPercentage!) / (100 + _purchaseItemModel!.taxPercentage!);
      _purchaseItemModel!.itemPrice = _purchaseItemModel!.itemPrice! - _purchaseItemModel!.taxPrice!;
      _purchaseItemModel!.orderPrice = _purchaseItemModel!.itemPrice! + _purchaseItemModel!.taxPrice!;
    } else if (_purchaseItemModel!.taxType == AppConfig.taxTypes.last["value"]) {
      _purchaseItemModel!.taxPrice = (_purchaseItemModel!.itemPrice! * _purchaseItemModel!.taxPercentage!) / (100);
      _purchaseItemModel!.orderPrice = _purchaseItemModel!.itemPrice! + _purchaseItemModel!.taxPrice!;
    } else {
      _purchaseItemModel!.orderPrice = _purchaseItemModel!.itemPrice!;
    }

    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 15),
      color: Colors.transparent,
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            ///
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Name :",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    (widget.category == "products")
                        ? "${widget.purchaseModel!.productsData![_purchaseItemModel!.productId]!.name}"
                        : "${widget.purchaseModel!.servicesData![_purchaseItemModel!.productId]!.name}",
                    style: TextStyle(fontSize: fontSp * 16),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Buying Price :",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: KeicyTextFormField(
                    controller: _priceController,
                    focusNode: _priceFocusNode,
                    width: double.infinity,
                    height: null,
                    maxHeight: heightDp * 70,
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                    borderRadius: heightDp * 6,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    hintText: "Buying Price",
                    hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    readOnly: true,
                    onChangeHandler: (input) {
                      if (input.isEmpty) {
                        _purchaseItemModel!.itemPrice = 0;
                      } else {
                        _purchaseItemModel!.itemPrice = double.parse(input.trim());
                      }
                      setState(() {});
                    },
                    validatorHandler: (input) => input.isEmpty ? "Please enter price" : null,
                    onSaveHandler: (input) => _purchaseItemModel!.itemPrice = double.parse(input.trim()),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Qunatity :",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: KeicyTextFormField(
                    controller: _quantityController,
                    focusNode: _quantityFocusNode,
                    width: double.infinity,
                    height: null,
                    maxHeight: heightDp * 70,
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                    borderRadius: heightDp * 6,
                    textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    hintText: "Quantity",
                    hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.7)),
                    contentHorizontalPadding: widthDp * 10,
                    contentVerticalPadding: heightDp * 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"))],
                    onChangeHandler: (input) {
                      if (input.isEmpty) {
                        _purchaseItemModel!.quantity = 0;
                      } else {
                        _purchaseItemModel!.quantity = double.parse(input.trim());
                      }
                      setState(() {});
                    },
                    validatorHandler: (input) => input.isEmpty
                        ? "Please enter quantity"
                        : double.parse(input.trim()) == 0
                            ? "Please enter value more than 1"
                            : null,
                    onSaveHandler: (input) => _purchaseItemModel!.quantity = double.parse(input.trim()),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Amount :",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: (_purchaseItemModel!.itemPrice! * _purchaseItemModel!.quantity! != 0)
                      ? Text(
                          "${_purchaseItemModel!.itemPrice! * _purchaseItemModel!.quantity!}",
                          style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                        )
                      : SizedBox(),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Tax (%) :",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: KeicyDropDownFormField(
                    width: double.infinity,
                    height: heightDp * 25,
                    menuItems: AppConfig.taxValues,
                    value: _purchaseItemModel!.taxPercentage != null ? _purchaseItemModel!.taxPercentage : 0,
                    selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    borderRadius: heightDp * 6,
                    onChangeHandler: (value) {
                      _purchaseItemModel!.taxPercentage = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Tax Type :",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: KeicyDropDownFormField(
                    width: double.infinity,
                    height: heightDp * 25,
                    menuItems: AppConfig.taxTypes,
                    value: _purchaseItemModel!.taxType,
                    selectedItemStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                    border: Border.all(color: Colors.grey.withOpacity(0.7)),
                    borderRadius: heightDp * 6,
                    onChangeHandler: (value) {
                      _purchaseItemModel!.taxType = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Tax Value :",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    numFormat.format(_purchaseItemModel!.taxPrice),
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Item Price :",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    numFormat.format(_purchaseItemModel!.itemPrice),
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: heightDp * 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Total :",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "${_purchaseItemModel!.orderPrice! * _purchaseItemModel!.quantity!}",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            if (_purchaseItemModel!.acceptBulkOrder! && _purchaseItemModel!.quantity! >= _purchaseItemModel!.minQuantityForBulkOrder!)
              Row(
                children: [
                  Text(
                    "* Bulk order discount applied\nDiscount : ₹ ${_purchaseItemModel!.discount}\nMinimum bulk order items: ${_purchaseItemModel!.minQuantityForBulkOrder} ",
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

            ///
            SizedBox(height: heightDp * 20),
            Text(
              "Previous Purchase Orders :",
              style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: heightDp * 20),
            Expanded(
              child: Consumer<PurchaseHistoryProvider>(builder: (context, purchaseHistoryProvider, _) {
                if (purchaseHistoryProvider.purchaseHistoryState.progressState == 0 ||
                    purchaseHistoryProvider.purchaseHistoryState.progressState == 1) {
                  return Center(child: CupertinoActivityIndicator());
                }

                return _itemListPanel();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemListPanel() {
    List<dynamic> itemList = [];
    Map<String, dynamic> itemListMetaData = Map<String, dynamic>();

    if (_purchaseHistoryProvider!.purchaseHistoryState.itemList![status] != null) {
      itemList = _purchaseHistoryProvider!.purchaseHistoryState.itemList![status];
    }
    if (_purchaseHistoryProvider!.purchaseHistoryState.itemListMetaData![status] != null) {
      itemListMetaData = _purchaseHistoryProvider!.purchaseHistoryState.itemListMetaData![status];
    }

    int itemCount = 0;

    if (_purchaseHistoryProvider!.purchaseHistoryState.itemList![status] != null) {
      int length = _purchaseHistoryProvider!.purchaseHistoryState.itemList![status].length;
      itemCount += length;
    }

    if (_purchaseHistoryProvider!.purchaseHistoryState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return Column(
      children: [
        Expanded(
          child: itemCount == 0
              ? Center(
                  child: Text(
                    "No Items",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                  ),
                )
              : NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (notification) {
                    notification.disallowGlow();
                    return true;
                  },
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: (itemListMetaData["nextPage"] != null && _purchaseHistoryProvider!.purchaseHistoryState.progressState != 1),
                    header: WaterDropHeader(),
                    footer: ClassicFooter(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.separated(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        var itemData = (index >= itemList.length) ? Map<String, dynamic>() : itemList[index];
                        if (widget.category == "products")
                          return Column(
                            children: [
                              if (index == 0) Divider(height: heightDp * 5, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: widthDp * 0),
                                child: ProductPuchaseWidget(
                                  purchaseModel: _purchaseHistoryProvider!.purchaseHistoryState.purchaseData![status],
                                  purchaseItemModel: itemData,
                                  index: index,
                                  isReadOnly: true,
                                  showOrderId: true,
                                ),
                              ),
                              Divider(height: heightDp * 5, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                            ],
                          );

                        if (widget.category == "services")
                          return Column(
                            children: [
                              if (index == 0) Divider(height: heightDp * 5, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: widthDp * 0),
                                child: ServicePurchaseWidget(
                                  purchaseModel: _purchaseHistoryProvider!.purchaseHistoryState.purchaseData![status],
                                  purchaseItemModel: itemData,
                                  index: index,
                                  isReadOnly: true,
                                ),
                              ),
                              Divider(height: heightDp * 5, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                            ],
                          );

                        return SizedBox();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox();
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
