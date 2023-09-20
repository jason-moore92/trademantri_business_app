import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/pages/ErrorPage/error_page.dart';
import 'package:trapp/src/providers/index.dart';

import 'Components/catalog_products_panel.dart';
import 'index.dart';

class StoreProductListView extends StatefulWidget {
  StoreProductListView({Key? key}) : super(key: key);

  @override
  _StoreProductListViewState createState() => _StoreProductListViewState();
}

class _StoreProductListViewState extends State<StoreProductListView> with SingleTickerProviderStateMixin {
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

  StoreDataProvider? _storeDataProvider;

  TabController? _tabController;

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

    _storeDataProvider = StoreDataProvider.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_storeDataProvider!.storeDataState.progressState != 2) {
        _storeDataProvider!.init(
          storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
          storeSubType: AuthProvider.of(context).authState.storeModel!.subType,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
        ),
        body: Consumer<StoreDataProvider>(builder: (context, storeDataProvider, _) {
          if (storeDataProvider.storeDataState.progressState == 0 || storeDataProvider.storeDataState.progressState == 1) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (storeDataProvider.storeDataState.progressState == -1) {
            return ErrorPage(
              message: storeDataProvider.storeDataState.message,
              callback: () {
                storeDataProvider.setStoreDataState(storeDataProvider.storeDataState.update(progressState: 1));
                _storeDataProvider!.init(
                  storeIds: [AuthProvider.of(context).authState.storeModel!.id!],
                  storeSubType: AuthProvider.of(context).authState.storeModel!.subType,
                );
              },
            );
          }

          return Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _tabBar(),
                Expanded(
                  child: TabBarView(
                    children: [
                      ProductsPanel(),
                      CatalogProductsPanel(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
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
        isScrollable: false,
        indicatorColor: config.Colors().mainColor(1),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        // labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 15),
        labelStyle: TextStyle(fontSize: fontSp * 16),
        labelColor: config.Colors().mainColor(1),
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(
            text: "Store Products",
          ),
          Tab(
            text: "TradeMantri Catalog",
          ),
        ],
      ),
    );
  }
}
