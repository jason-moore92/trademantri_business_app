import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/catalog_product_widget.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/pages/NewProductPage/index.dart';
import 'package:trapp/src/pages/VarientsProductListPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class CatalogServicesPanel extends StatefulWidget {
  const CatalogServicesPanel({Key? key}) : super(key: key);

  @override
  _CatalogServicesPanelState createState() => _CatalogServicesPanelState();
}

class _CatalogServicesPanelState extends State<CatalogServicesPanel> {
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

  CatalogServiceListPageProvider? _catalogServiceListPageProvider;

  RefreshController? _refreshController;

  TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();

  String _selectedCategory = "";
  String _selectedSubCategory = "";

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

    _catalogServiceListPageProvider = CatalogServiceListPageProvider.of(context);

    _refreshController = RefreshController();

    _catalogServiceListPageProvider!.setCatalogServiceListPageState(
      _catalogServiceListPageProvider!.catalogServiceListPageState.update(
        progressState: 0,
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _catalogServiceListPageProvider!.addListener(_catalogServiceListPageProviderListener);

      if (_catalogServiceListPageProvider!.catalogServiceListPageState.progressState != 2) {
        _catalogServiceListPageProvider!.setCatalogServiceListPageState(
          _catalogServiceListPageProvider!.catalogServiceListPageState.update(progressState: 1),
        );

        _catalogServiceListPageProvider!.getCatalogServiceList(
          searchTerm: "",
          cat: "",
          subCat: "",
        );
      }
    });
  }

  @override
  void dispose() {
    _catalogServiceListPageProvider!.removeListener(_catalogServiceListPageProviderListener);

    super.dispose();
  }

  void _catalogServiceListPageProviderListener() async {
    if (_catalogServiceListPageProvider!.catalogServiceListPageState.progressState == -1) {
      if (_catalogServiceListPageProvider!.catalogServiceListPageState.isRefresh!) {
        _refreshController!.refreshFailed();
        _catalogServiceListPageProvider!.setCatalogServiceListPageState(
          _catalogServiceListPageProvider!.catalogServiceListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_catalogServiceListPageProvider!.catalogServiceListPageState.progressState == 2) {
      if (_catalogServiceListPageProvider!.catalogServiceListPageState.isRefresh!) {
        _refreshController!.refreshCompleted();
        _catalogServiceListPageProvider!.setCatalogServiceListPageState(
          _catalogServiceListPageProvider!.catalogServiceListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic>? serviceListData = _catalogServiceListPageProvider!.catalogServiceListPageState.serviceListData;
    Map<String, dynamic>? serviceMetaData = _catalogServiceListPageProvider!.catalogServiceListPageState.serviceMetaData;

    serviceListData = [];
    serviceMetaData = Map<String, dynamic>();
    _catalogServiceListPageProvider!.setCatalogServiceListPageState(
      _catalogServiceListPageProvider!.catalogServiceListPageState.update(
        progressState: 1,
        serviceListData: serviceListData,
        serviceMetaData: serviceMetaData,
        isRefresh: true,
      ),
    );

    _catalogServiceListPageProvider!.getCatalogServiceList(
      searchTerm: _nameController.text.trim(),
      cat: _selectedCategory,
      subCat: _selectedSubCategory,
    );
  }

  void _onLoading() async {
    _catalogServiceListPageProvider!.setCatalogServiceListPageState(
      _catalogServiceListPageProvider!.catalogServiceListPageState.update(progressState: 1),
    );
    _catalogServiceListPageProvider!.getCatalogServiceList(
      searchTerm: _nameController.text.trim(),
      cat: _selectedCategory,
      subCat: _selectedSubCategory,
    );
  }

  void _searchKeyStoreProductListHandler() {
    List<dynamic>? serviceListData = _catalogServiceListPageProvider!.catalogServiceListPageState.serviceListData;
    Map<String, dynamic>? serviceMetaData = _catalogServiceListPageProvider!.catalogServiceListPageState.serviceMetaData;

    serviceListData = [];
    serviceMetaData = Map<String, dynamic>();
    _catalogServiceListPageProvider!.setCatalogServiceListPageState(
      _catalogServiceListPageProvider!.catalogServiceListPageState.update(
        progressState: 1,
        serviceListData: serviceListData,
        serviceMetaData: serviceMetaData,
      ),
    );

    _catalogServiceListPageProvider!.getCatalogServiceList(
      searchTerm: _nameController.text.trim(),
      cat: _selectedCategory,
      subCat: _selectedSubCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatalogServiceListPageProvider>(
      builder: (context, catalogServiceListPageProvider, _) {
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              SizedBox(height: heightDp * 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Text(
                  "Check for products and variants available here and add them to your store.",
                  style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                ),
              ),
              SizedBox(height: heightDp * 10),
              _searchForProductField(),
              SizedBox(height: heightDp * 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KeicyRaisedButton(
                      width: widthDp * 170,
                      height: heightDp * 35,
                      color: StoreDataProvider.of(context).storeDataState.serviceCatalogCategoryList!.length == 0
                          ? Colors.grey.withOpacity(0.7)
                          : config.Colors().mainColor(1),
                      borderRadius: heightDp * 8,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Text(
                        "Search By Category",
                        style: TextStyle(
                          fontSize: fontSp * 14,
                          color: StoreDataProvider.of(context).storeDataState.serviceCatalogCategoryList!.length == 0 ? Colors.black : Colors.white,
                        ),
                      ),
                      onPressed: StoreDataProvider.of(context).storeDataState.serviceCatalogCategoryList!.length == 0
                          ? null
                          : () async {
                              var result = await CatalogCategoryBottomSheetDialog.show(
                                context,
                                StoreDataProvider.of(context).storeDataState.serviceCatalogCategoryList,
                                _selectedCategory,
                              );

                              if (result != null && result != _selectedCategory) {
                                _selectedCategory = result;
                                _onRefresh();
                              }
                            },
                    ),
                    KeicyRaisedButton(
                      width: widthDp * 185,
                      height: heightDp * 35,
                      color: StoreDataProvider.of(context).storeDataState.serviceCatalogSubCategoryList!.length == 0
                          ? Colors.grey.withOpacity(0.6)
                          : config.Colors().mainColor(1),
                      borderRadius: heightDp * 8,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Text(
                        "Search By SubCategory",
                        style: TextStyle(
                          fontSize: fontSp * 14,
                          color:
                              StoreDataProvider.of(context).storeDataState.serviceCatalogSubCategoryList!.length == 0 ? Colors.black : Colors.white,
                        ),
                      ),
                      onPressed: StoreDataProvider.of(context).storeDataState.serviceCatalogSubCategoryList!.length == 0
                          ? null
                          : () async {
                              var result = await CatalogSubCategoryBottomSheetDialog.show(
                                context,
                                StoreDataProvider.of(context).storeDataState.serviceCatalogSubCategoryList!,
                                _selectedSubCategory,
                              );

                              if (result != null && result != _selectedSubCategory) {
                                _selectedSubCategory = result;
                                _onRefresh();
                              }
                            },
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightDp * 10),
              Expanded(child: _storeProductListPanel()),
            ],
          ),
        );
      },
    );
  }

  Widget _searchForProductField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: Row(
        children: [
          Expanded(
            child: KeicyTextFormField(
              controller: _nameController,
              focusNode: _nameFocusNode,
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
                    _nameController.clear();
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
        ],
      ),
    );
  }

  Widget _storeProductListPanel() {
    List<dynamic> storeProductList = [];
    Map<String, dynamic> serviceMetaData = Map<String, dynamic>();

    if (_catalogServiceListPageProvider!.catalogServiceListPageState.serviceListData != null) {
      storeProductList = _catalogServiceListPageProvider!.catalogServiceListPageState.serviceListData!;
    }
    if (_catalogServiceListPageProvider!.catalogServiceListPageState.serviceMetaData != null) {
      serviceMetaData = _catalogServiceListPageProvider!.catalogServiceListPageState.serviceMetaData!;
    }

    int itemCount = 0;

    if (_catalogServiceListPageProvider!.catalogServiceListPageState.serviceListData != null) {
      itemCount += _catalogServiceListPageProvider!.catalogServiceListPageState.serviceListData!.length;
    }

    if (_catalogServiceListPageProvider!.catalogServiceListPageState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (serviceMetaData["page"] != null &&
            serviceMetaData["page"] != serviceMetaData["total"] - 1 &&
            _catalogServiceListPageProvider!.catalogServiceListPageState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshController!,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Catalog Service Available",
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
                      CatalogProductWidget(
                        productData: productData1,
                        isLoading: productData1.isEmpty,
                        varientsHandler: () {
                          _varientsHandler(productData1);
                        },
                      ),
                      (_catalogServiceListPageProvider!.catalogServiceListPageState.progressState == 2 && productData2.isEmpty)
                          ? Container(
                              width: widthDp * 170,
                              height: heightDp * 240,
                              margin: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                            )
                          : CatalogProductWidget(
                              productData: productData2,
                              isLoading: productData2.isEmpty,
                              varientsHandler: () {
                                _varientsHandler(productData2);
                              },
                            ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  void _varientsHandler(Map<String, dynamic> productData) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => VarientsProuctListPage(
          varients: productData["item"]["variants"],
          productData: productData,
          imgLocation: productData["imgLocation"],
        ),
      ),
    );

    // if (result != null) {
    //   _onRefresh();
    // }
  }
}
