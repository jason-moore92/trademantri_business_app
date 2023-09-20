import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/notification_widget.dart';
import 'package:trapp/src/entities/product_stock.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ProductStockPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class ProductStockListView extends StatefulWidget {
  final bool haveAppBar;
  final ProductModel? product;

  ProductStockListView({Key? key, this.haveAppBar = false, this.product}) : super(key: key);

  @override
  _ProductStockListViewState createState() => _ProductStockListViewState();
}

class _ProductStockListViewState extends State<ProductStockListView> with SingleTickerProviderStateMixin {
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
  ProductStockProvider? _productStockProvider;

  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

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

    _productStockProvider = ProductStockProvider.of(context);
    _authProvider = AuthProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _productStockProvider!.setProductStockState(
      _productStockProvider!.productStockState.update(
        progressState: 0,
        entryListData: [],
        entryMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _productStockProvider!.addListener(_productStockProviderListener);

      _productStockProvider!.setProductStockState(_productStockProvider!.productStockState.update(progressState: 1));
      _productStockProvider!.getAll(
        storeId: _authProvider!.authState.storeModel!.id,
        productId: widget.product!.id!,
      );
    });
  }

  @override
  void dispose() {
    _productStockProvider!.removeListener(_productStockProviderListener);

    super.dispose();
  }

  void _productStockProviderListener() async {
    if (_productStockProvider!.productStockState.progressState == -1) {
      if (_productStockProvider!.productStockState.isRefresh!) {
        _productStockProvider!.setProductStockState(
          _productStockProvider!.productStockState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_productStockProvider!.productStockState.progressState == 2) {
      if (_productStockProvider!.productStockState.isRefresh!) {
        _productStockProvider!.setProductStockState(
          _productStockProvider!.productStockState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<ProductStock>? entryListData = _productStockProvider!.productStockState.entryListData;
    Map<String, dynamic>? entryMetaData = _productStockProvider!.productStockState.entryMetaData;

    entryListData = [];
    entryMetaData = Map<String, dynamic>();
    _productStockProvider!.setProductStockState(
      _productStockProvider!.productStockState.update(
        progressState: 1,
        entryListData: entryListData,
        entryMetaData: entryMetaData,
        isRefresh: true,
      ),
    );

    _productStockProvider!.getAll(
      storeId: _authProvider!.authState.storeModel!.id,
      productId: widget.product!.id!,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _productStockProvider!.setProductStockState(
      _productStockProvider!.productStockState.update(progressState: 1),
    );
    _productStockProvider!.getAll(
      storeId: _authProvider!.authState.storeModel!.id,
      productId: widget.product!.id!,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyProductStockListHandler() {
    List<ProductStock>? entryListData = _productStockProvider!.productStockState.entryListData;
    Map<String, dynamic>? entryMetaData = _productStockProvider!.productStockState.entryMetaData;

    entryListData = [];
    entryMetaData = Map<String, dynamic>();
    _productStockProvider!.setProductStockState(
      _productStockProvider!.productStockState.update(
        progressState: 1,
        entryListData: entryListData,
        entryMetaData: entryMetaData,
      ),
    );

    _productStockProvider!.getAll(
      storeId: _authProvider!.authState.storeModel!.id,
      productId: widget.product!.id!,
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addHandler();
        },
      ),
      appBar: !widget.haveAppBar
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                "Stock History",
                style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: Consumer<ProductStockProvider>(builder: (context, productStockProvider, _) {
        if (productStockProvider.productStockState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _searchField(),
              Expanded(child: _entiresListPanel()),
            ],
          ),
        );
      }),
    );
  }

  void _addHandler() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ProductStockPage(
          product: widget.product,
        ),
      ),
    );
    if (result != null && result) {
      // _onRefresh();
    }
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
        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.6)),
        hintText: ProductStockListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyProductStockListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyProductStockListHandler();
        },
      ),
    );
  }

  Widget _entiresListPanel() {
    List<ProductStock> entriesList = [];
    Map<String, dynamic> entryMetaData = Map<String, dynamic>();

    if (_productStockProvider!.productStockState.entryListData != null) {
      entriesList = _productStockProvider!.productStockState.entryListData == null ? [] : _productStockProvider!.productStockState.entryListData!;
    }
    if (_productStockProvider!.productStockState.entryMetaData != null) {
      entryMetaData = _productStockProvider!.productStockState.entryMetaData!;
    }

    int itemCount = 0;

    if (_productStockProvider!.productStockState.entryListData != null) {
      int length = _productStockProvider!.productStockState.entryListData!.length;
      itemCount += length;
    }

    // if (_productStockProvider!.productStockState.progressState == 1) {
    //   itemCount += AppConfig.countLimitForList;
    // }

    return Column(
      children: [
        Expanded(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();
              return true;
            },
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: (entryMetaData["nextPage"] != null && _productStockProvider!.productStockState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No History Available",
                        style: TextStyle(
                          fontSize: fontSp * 14,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        // ProductStock entry = (index >= entriesList.length) ? ProductStock() : entriesList[index];
                        ProductStock entry = entriesList[index];

                        return Container(
                          child: Text(entry.notes!),
                        );
                        // return ProductStockWidget(
                        //   entries: entries,
                        //   isLoading: entries.isEmpty,
                        // );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey.withOpacity(0.3), height: 5, thickness: 5);
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
