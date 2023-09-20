import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/product_item_b2b_widget.dart';
import 'package:trapp/src/elements/product_item_for_selection_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/error_page.dart';
import 'package:trapp/src/pages/ProductOrders/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class ProductListView extends StatefulWidget {
  final List<ProductModel>? selectedProducts;
  final List<String>? storeIds;
  final StoreModel? storeModel;
  final bool isForSelection;
  final bool isForB2b;
  final bool showDetailButton;

  ProductListView({
    Key? key,
    this.selectedProducts,
    this.storeIds,
    this.storeModel,
    this.isForSelection = false,
    this.isForB2b = false,
    this.showDetailButton = true,
  }) : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> with SingleTickerProviderStateMixin {
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

  List<dynamic>? _productCategoryData = [];

  ProductListPageProvider? _productListPageProvider;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 0;

  List<ProductModel>? selectedProducts = [];

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

    _refreshControllerList = [];

    _oldTabIndex = 0;

    selectedProducts!.addAll((widget.selectedProducts ?? []));

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

      _productListPageProvider!.getProductCategories(
        storeIds: widget.storeIds,
        storeSubType: AuthProvider.of(context).authState.storeModel!.subType,
      );
    });
  }

  void _tabControllerListener() {
    if ((_productListPageProvider!.productListPageState.progressState != 1) &&
        (_controller.text.isNotEmpty ||
            _productListPageProvider!.productListPageState.productListData![_productCategoryData![_tabController!.index]["category"]] == null ||
            _productListPageProvider!.productListPageState.productListData![_productCategoryData![_tabController!.index]["category"]].isEmpty)) {
      Map<String, dynamic>? productListData = _productListPageProvider!.productListPageState.productListData;
      Map<String, dynamic>? productMetaData = _productListPageProvider!.productListPageState.productMetaData;

      if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
        productListData![_productCategoryData![_oldTabIndex]["category"]] = [];
        productMetaData![_productCategoryData![_oldTabIndex]["category"]] = Map<String, dynamic>();
      }

      _productListPageProvider!.setProductListPageState(
        _productListPageProvider!.productListPageState.update(
          progressState: 1,
          productListData: productListData,
          productMetaData: productMetaData,
        ),
      );

      _controller.clear();
      _oldTabIndex = _tabController!.index;

      _productListPageProvider!.setProductListPageState(
        _productListPageProvider!.productListPageState.update(progressState: 1),
        isNotifiable: false,
      );

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _productListPageProvider!.getProductList(
          storeIds: widget.storeIds,
          categories: [_productCategoryData![_tabController!.index]["category"]],
          searchKey: _controller.text.trim(),
          isDeleted: false,
          listonline: true,
        );
      });
    }
    _oldTabIndex = _tabController!.index;
    setState(() {});
  }

  @override
  void dispose() {
    _productListPageProvider!.removeListener(_productListPageProviderListener);

    super.dispose();
  }

  void _productListPageProviderListener() async {
    if (_tabController == null) return;
    if (_productListPageProvider!.productListPageState.progressState == -1) {
      if (_productListPageProvider!.productListPageState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _productListPageProvider!.setProductListPageState(
          _productListPageProvider!.productListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_productListPageProvider!.productListPageState.progressState == 2) {
      if (_productListPageProvider!.productListPageState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _productListPageProvider!.setProductListPageState(
          _productListPageProvider!.productListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? productListData = _productListPageProvider!.productListPageState.productListData;
    Map<String, dynamic>? productMetaData = _productListPageProvider!.productListPageState.productMetaData;

    productListData![_productCategoryData![_tabController!.index]["category"]] = [];
    productMetaData![_productCategoryData![_tabController!.index]["category"]] = Map<String, dynamic>();
    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(
        progressState: 1,
        productListData: productListData,
        productMetaData: productMetaData,
        isRefresh: true,
      ),
    );

    _productListPageProvider!.getProductList(
      storeIds: widget.storeIds,
      categories: [_productCategoryData![_tabController!.index]["category"]],
      searchKey: _controller.text.trim(),
      isDeleted: false,
      listonline: true,
    );
  }

  void _onLoading() async {
    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(progressState: 1),
    );
    _productListPageProvider!.getProductList(
      storeIds: widget.storeIds,
      categories: [_productCategoryData![_tabController!.index]["category"]],
      searchKey: _controller.text.trim(),
      isDeleted: false,
      listonline: true,
    );
  }

  void _searchKeyProductListHandler() {
    Map<String, dynamic>? productListData = _productListPageProvider!.productListPageState.productListData;
    Map<String, dynamic>? productMetaData = _productListPageProvider!.productListPageState.productMetaData;

    productListData![_productCategoryData![_tabController!.index]["category"]] = [];
    productMetaData![_productCategoryData![_tabController!.index]["category"]] = Map<String, dynamic>();
    _productListPageProvider!.setProductListPageState(
      _productListPageProvider!.productListPageState.update(
        progressState: 1,
        productListData: productListData,
        productMetaData: productMetaData,
      ),
    );

    _productListPageProvider!.getProductList(
      storeIds: widget.storeIds,
      categories: [_productCategoryData![_tabController!.index]["category"]],
      searchKey: _controller.text.trim(),
      isDeleted: false,
      listonline: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Products",
          style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ProductOrdersPage(),
                ),
              );
            },
            icon: Icon(Icons.assessment),
          ),
        ],
      ),
      body: Consumer<ProductListPageProvider>(builder: (context, productListPageProvider, _) {
        _productCategoryData = productListPageProvider.productListPageState.productCategoryData![widget.storeIds!.join(',')];

        if (productListPageProvider.productListPageState.progressState == 0 && _productCategoryData == null) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (productListPageProvider.productListPageState.progressState == -1) {
          return ErrorPage(
            message: productListPageProvider.productListPageState.message,
            callback: () {
              _productListPageProvider!.setProductListPageState(
                _productListPageProvider!.productListPageState.update(progressState: 0),
              );
              _productListPageProvider!.getProductCategories(
                storeIds: widget.storeIds,
                storeSubType: AuthProvider.of(context).authState.storeModel!.subType,
              );
            },
          );
        }
        if (productListPageProvider.productListPageState.progressState == 3) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widthDp * 30),
              child: Center(
                child: Image.asset(
                  "img/NoProducts.png",
                  height: heightDp * 150,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          );
        }

        if (_tabController == null) {
          _tabController = TabController(
            length: _productCategoryData!.length,
            vsync: this,
          );

          _tabController!.addListener(_tabControllerListener);
          _productListPageProvider!.setProductListPageState(
            _productListPageProvider!.productListPageState.update(progressState: 1),
            isNotifiable: false,
          );

          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            _productListPageProvider!.getProductList(
              storeIds: widget.storeIds,
              categories: [_productCategoryData![0]["category"]],
              isDeleted: false,
              listonline: true,
            );
          });
        }

        if (_refreshControllerList.isEmpty) {
          for (var i = 0; i < _productCategoryData!.length; i++) {
            _refreshControllerList.add(RefreshController(initialRefresh: false));
          }
        }

        return DefaultTabController(
          length: _productCategoryData!.length,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _searchField(),
                _tabBar(),
                Expanded(child: _productListPanel()),
                widget.isForSelection ? _selectedProductPanel() : SizedBox(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: KeicyTextFormField(
        controller: _controller,
        focusNode: _focusNode,
        width: null,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        contentVerticalPadding: heightDp * 8,
        textStyle: TextStyle(fontSize: fontSp * 12, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 12, color: Colors.grey.withOpacity(0.6)),
        hintText: ProductListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyProductListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyProductListHandler();
        },
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      ),
      alignment: Alignment.center,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: config.Colors().mainColor(1),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        // labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 15),
        labelStyle: TextStyle(fontSize: fontSp * 16),
        labelColor: config.Colors().mainColor(1),
        unselectedLabelColor: Colors.black,
        tabs: List.generate(_productCategoryData!.length, (index) {
          return Tab(
            text: "${_productCategoryData![index]["category"]}",
          );
        }),
      ),
    );
  }

  Widget _productListPanel() {
    int index = _tabController!.index;
    String category = _productCategoryData![index]["category"];

    List<dynamic> productList = [];
    Map<String, dynamic> productMetaData = Map<String, dynamic>();

    if (_productListPageProvider!.productListPageState.productListData![category] != null) {
      productList = _productListPageProvider!.productListPageState.productListData![category];
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
        controller: _refreshControllerList[index],
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Prouduct Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.separated(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  Map<String, dynamic> productData = (index >= productList.length) ? Map<String, dynamic>() : productList[index];
                  return GestureDetector(
                    onTap: () {
                      if (productData.isEmpty) return;
                      if (!widget.isForSelection) return;
                      bool isSelected = false;
                      int? index;

                      for (var i = 0; i < selectedProducts!.length; i++) {
                        if (selectedProducts![i].id == productData["_id"]) {
                          index = i;
                          isSelected = true;
                          break;
                        }
                      }

                      if (isSelected) {
                        selectedProducts!.removeAt(index!);
                      } else {
                        selectedProducts!.add(ProductModel.fromJson(productData));
                      }

                      setState(() {});
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: widget.isForB2b
                          ? ProductItemB2BWidget(
                              selectedProducts: selectedProducts,
                              productModel: productData.isEmpty ? null : ProductModel.fromJson(productData),
                              storeModel: widget.storeModel,
                              isLoading: productData.isEmpty,
                              showDetailButton: widget.showDetailButton,
                            )
                          : ProductItemForSelectionWidget(
                              selectedProducts: selectedProducts,
                              productModel: productData.isEmpty ? null : ProductModel.fromJson(productData),
                              storeModel: widget.storeModel,
                              isLoading: productData.isEmpty,
                              showDetailButton: widget.showDetailButton,
                            ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.grey.withOpacity(0.3), height: 1, thickness: 1);
                },
              ),
      ),
    );
  }

  Widget _selectedProductPanel() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.4), offset: Offset(0, -1), blurRadius: 2),
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedProducts!.isEmpty ? "Please choose Product" : "${selectedProducts!.length} Items",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
          ),
          KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            color: selectedProducts!.isEmpty ? Colors.grey.withOpacity(0.6) : config.Colors().mainColor(1),
            borderRadius: heightDp * 8,
            child: Text("OK", style: TextStyle(fontSize: fontSp * 16, color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop(selectedProducts);
            },
          ),
        ],
      ),
    );
  }
}
