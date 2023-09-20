import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/store_product_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/NewProductPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/services/dynamic_link_service.dart';

class ProductsPanel extends StatefulWidget {
  const ProductsPanel({Key? key}) : super(key: key);

  @override
  _ProductsPanelState createState() => _ProductsPanelState();
}

class _ProductsPanelState extends State<ProductsPanel> {
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

  ProductListPageProvider? _productListPageProvider;

  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  KeicyProgressDialog? _keicyProgressDialog;

  List<String>? _storeIds;
  List<dynamic> _categoryList = [];
  List<dynamic> _brandList = [];

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

    _productListPageProvider = ProductListPageProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshController = RefreshController();

    _categoryList = [];
    _brandList = [];

    for (var i = 0; i < StoreDataProvider.of(context).storeDataState.productCategoryList!.length; i++) {
      _categoryList.add(StoreDataProvider.of(context).storeDataState.productCategoryList![i]);
    }

    for (var i = 0; i < StoreDataProvider.of(context).storeDataState.productBrandList!.length; i++) {
      _brandList.add(StoreDataProvider.of(context).storeDataState.productBrandList![i]);
    }

    _storeIds = [AuthProvider.of(context).authState.storeModel!.id!];

    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(
        progressState: 0,
        productListData: Map<String, dynamic>(),
        productMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _productListPageProvider!.addListener(_productListPageProviderListener);

      _productListPageProvider!.setProductListPageState(
        _productListPageProvider!.productListPageState.update(progressState: 1),
      );

      _productListPageProvider!.getProductList(
        storeIds: _storeIds,
        categories: _categoryList,
        brands: _brandList,
        isDeleted: null,
        listonline: null,
      );
    });
  }

  @override
  void dispose() {
    _productListPageProvider!.removeListener(_productListPageProviderListener);

    super.dispose();
  }

  void _productListPageProviderListener() async {
    if (_productListPageProvider!.productListPageState.progressState == -1) {
      if (_productListPageProvider!.productListPageState.isRefresh!) {
        _refreshController!.refreshFailed();
        _productListPageProvider!.setProductListPageState(
          _productListPageProvider!.productListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_productListPageProvider!.productListPageState.progressState == 2) {
      if (_productListPageProvider!.productListPageState.isRefresh!) {
        _refreshController!.refreshCompleted();
        _productListPageProvider!.setProductListPageState(
          _productListPageProvider!.productListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? productListData = _productListPageProvider!.productListPageState.productListData;
    Map<String, dynamic>? productMetaData = _productListPageProvider!.productListPageState.productMetaData;

    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";

    productListData![category] = [];
    productMetaData![category] = Map<String, dynamic>();
    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(
        progressState: 1,
        productListData: productListData,
        productMetaData: productMetaData,
        isRefresh: true,
      ),
    );

    _productListPageProvider!.getProductList(
      storeIds: _storeIds,
      categories: _categoryList,
      brands: _brandList,
      searchKey: _controller.text.trim(),
      isDeleted: null,
      listonline: null,
    );
  }

  void _onLoading() async {
    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(progressState: 1),
    );
    _productListPageProvider!.getProductList(
      storeIds: _storeIds,
      categories: _categoryList,
      brands: _brandList,
      searchKey: _controller.text.trim(),
      isDeleted: null,
      listonline: null,
    );
  }

  void _searchKeyStoreProductListHandler() {
    Map<String, dynamic>? productListData = _productListPageProvider!.productListPageState.productListData;
    Map<String, dynamic>? productMetaData = _productListPageProvider!.productListPageState.productMetaData;

    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";

    productListData![category] = [];
    productMetaData![category] = Map<String, dynamic>();
    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(
        progressState: 1,
        productListData: productListData,
        productMetaData: productMetaData,
      ),
    );

    _productListPageProvider!.getProductList(
      storeIds: _storeIds,
      categories: _categoryList,
      brands: _brandList,
      searchKey: _controller.text.trim(),
      isDeleted: null,
      listonline: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductListPageProvider>(
      builder: (context, productListPageProvider, _) {
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              SizedBox(height: heightDp * 10),
              _searchField(),
              SizedBox(height: heightDp * 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KeicyRaisedButton(
                      width: widthDp * 165,
                      height: heightDp * 35,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 8,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Text(
                        "Search By Category",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      ),
                      onPressed: () async {
                        var result = await ProductCategoryBottomSheetDialog.show(
                          context,
                          _categoryList,
                        );

                        if (result != null && result != _categoryList) {
                          _categoryList = result;
                          _onRefresh();
                        }
                      },
                    ),
                    KeicyRaisedButton(
                      width: widthDp * 165,
                      height: heightDp * 35,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 8,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Text(
                        "Search By Brand",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      ),
                      onPressed: () async {
                        var result = await ProductBrandBottomSheetDialog.show(
                          context,
                          _brandList,
                        );

                        if (result != null && result != _brandList) {
                          _brandList = result;
                          _onRefresh();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightDp * 5),
              Expanded(child: _storeProductListPanel()),
            ],
          ),
        );
      },
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: Row(
        children: [
          Expanded(
            child: KeicyTextFormField(
              controller: _controller,
              focusNode: _focusNode,
              width: null,
              height: heightDp * 40,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
              errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
              borderRadius: heightDp * 6,
              contentHorizontalPadding: widthDp * 10,
              contentVerticalPadding: heightDp * 8,
              textStyle: TextStyle(fontSize: fontSp * 12, color: Colors.black),
              hintStyle: TextStyle(fontSize: fontSp * 12, color: Colors.grey.withOpacity(0.6)),
              hintText: StoreProductListPageString.searchHint,
              prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
              suffixIcons: [
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                    _searchKeyStoreProductListHandler();
                  },
                  child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                ),
              ],
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchKeyStoreProductListHandler();
              },
            ),
          ),
          SizedBox(width: widthDp * 10),
          KeicyRaisedButton(
            width: widthDp * 110,
            height: heightDp * 40,
            color: config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            child: Text(
              "+ Add New",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: () async {
              var result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => NewProductPage(type: "product", isNew: true),
                ),
              );

              if (result != null) {
                if (!_categoryList.contains(result["category"])) {
                  _categoryList.add(result["category"]);
                }
                if (!_brandList.contains(result["brand"])) {
                  _brandList.add(result["brand"]);
                }

                _onRefresh();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _storeProductListPanel() {
    List<dynamic> storeProductList = [];
    Map<String, dynamic> productMetaData = Map<String, dynamic>();

    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";

    if (_productListPageProvider!.productListPageState.productListData![category] != null) {
      storeProductList = _productListPageProvider!.productListPageState.productListData![category];
    }
    if (_productListPageProvider!.productListPageState.productMetaData![category] != null) {
      productMetaData = _productListPageProvider!.productListPageState.productMetaData![category];
    }

    int itemCount = 0;

    if (_productListPageProvider!.productListPageState.productListData![category] != null) {
      int length = _productListPageProvider!.productListPageState.productListData![category].length;
      itemCount += length;
    }

    if (_productListPageProvider!.productListPageState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (productMetaData["nextPage"] != null && _productListPageProvider!.productListPageState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshController!,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Product Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: itemCount % 2 == 0 ? itemCount ~/ 2 : itemCount ~/ 2 + 1,
                itemBuilder: (context, index) {
                  Map<String, dynamic> productData1 = (index * 2 >= storeProductList.length) ? Map<String, dynamic>() : storeProductList[index * 2];
                  Map<String, dynamic> productData2 =
                      (index * 2 + 1 >= storeProductList.length) ? Map<String, dynamic>() : storeProductList[index * 2 + 1];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StoreProductWidget(
                        productModel: productData1.isEmpty ? null : ProductModel.fromJson(productData1),
                        isLoading: productData1.isEmpty,
                        editHandler: () {
                          _editHandler(productData1);
                        },
                        shareHandler: () {
                          _shareHandler(productData1);
                        },
                        deleteHandler: () {
                          NormalAskDialog.show(
                            context,
                            title: "Delete Product",
                            content: "Are you sure you want to delete the product?",
                            callback: () {
                              _deleteHandler(productData1);
                            },
                          );
                        },
                        availableHandler: (bool isAvailable) {
                          _availableHandler(productData1, index * 2, isAvailable);
                        },
                        listonlineHandler: (bool listonline) {
                          _listonlineHandler(productData1, index * 2, listonline);
                        },
                      ),
                      (_productListPageProvider!.productListPageState.progressState == 2 && productData2.isEmpty)
                          ? Container(
                              width: widthDp * 170,
                              height: heightDp * 240,
                              margin: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                            )
                          : StoreProductWidget(
                              productModel: productData2.isEmpty ? null : ProductModel.fromJson(productData2),
                              isLoading: productData2.isEmpty,
                              editHandler: () {
                                _editHandler(productData2);
                              },
                              shareHandler: () {
                                _shareHandler(productData2);
                              },
                              deleteHandler: () {
                                NormalAskDialog.show(
                                  context,
                                  title: "Delete Product",
                                  content: "Are you sure you want to delete the product?",
                                  callback: () {
                                    _deleteHandler(productData2);
                                  },
                                );
                              },
                              availableHandler: (bool isAvailable) {
                                _availableHandler(productData2, index * 2 + 1, isAvailable);
                              },
                              listonlineHandler: (bool listonline) {
                                _listonlineHandler(productData2, index * 2 + 1, listonline);
                              },
                            ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  void _editHandler(Map<String, dynamic> productData) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => NewProductPage(
          type: "product",
          isNew: false,
          productModel: ProductModel.fromJson(productData),
        ),
      ),
    );

    if (result != null) {
      if (!_categoryList.contains(result["category"])) {
        _categoryList.add(result["category"]);
      }
      if (!_brandList.contains(result["brand"])) {
        _brandList.add(result["brand"]);
      }

      _onRefresh();
    }
  }

  void _shareHandler(Map<String, dynamic> productData) async {
    Uri dynamicUrl = await DynamicLinkService.createProductDynamicLink(
      itemData: productData,
      storeModel: AuthProvider.of(context).authState.storeModel,
      type: "products",
      isForCart: true,
    );
    Share.share(dynamicUrl.toString());
  }

  void _deleteHandler(Map<String, dynamic> productData) async {
    await _keicyProgressDialog!.show();
    var result = await ProductApiProvider.deleteProduct(
      productId: productData["_id"],
      token: AuthProvider.of(context).authState.businessUserModel!.token,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _onRefresh();
    }
  }

  void _availableHandler(Map<String, dynamic> productData, int index, bool isAvailable) async {
    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";
    Map<String, dynamic> newProductData = json.decode(json.encode(productData));
    newProductData["isAvailable"] = isAvailable;

    await _keicyProgressDialog!.show();
    var result = await ProductApiProvider.addProduct(
      productData: newProductData,
      token: AuthProvider.of(context).authState.businessUserModel!.token,
      isNew: false,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _productListPageProvider!.productListPageState.productListData![category][index] = newProductData;
      setState(() {});
    }
  }

  void _listonlineHandler(Map<String, dynamic> productData, int index, bool listonline) async {
    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";
    Map<String, dynamic> newProductData = json.decode(json.encode(productData));
    newProductData["listonline"] = listonline;

    await _keicyProgressDialog!.show();
    var result = await ProductApiProvider.addProduct(
      productData: newProductData,
      token: AuthProvider.of(context).authState.businessUserModel!.token,
      isNew: false,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _productListPageProvider!.productListPageState.productListData![category][index] = newProductData;
      setState(() {});
    }
  }
}
