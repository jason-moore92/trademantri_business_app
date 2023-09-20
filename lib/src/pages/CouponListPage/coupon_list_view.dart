import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/coupon_widget.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/CouponDetailPage/coupon_detail_page.dart';
import 'package:trapp/src/pages/ErrorPage/error_page.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'index.dart';

class CouponListView extends StatefulWidget {
  final bool? isForSelection;
  final StoreModel? storeModel;
  final bool? isForBusiness;

  CouponListView({Key? key, this.storeModel, this.isForSelection, this.isForBusiness}) : super(key: key);

  @override
  _CouponListViewState createState() => _CouponListViewState();
}

class _CouponListViewState extends State<CouponListView> with SingleTickerProviderStateMixin {
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

  CouponListProvider? _couponListProvider;

  List<RefreshController> _refreshControllerList = [];
  List<String> _categoryList = ["ALL", "Active", "Future", "Expired"];

  TabController? _tabController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 0;

  KeicyProgressDialog? _keicyProgressDialog;

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

    _couponListProvider = CouponListProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshControllerList = [];

    _oldTabIndex = 0;
    if (widget.isForSelection!) _oldTabIndex = 1;

    _couponListProvider!.setCouponListState(
      _couponListProvider!.couponState.update(
        progressState: _oldTabIndex,
        couponModels: Map<String, dynamic>(),
        couponMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    _tabController = TabController(length: _categoryList.length, vsync: this);

    for (var i = 0; i < _categoryList.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _couponListProvider!.addListener(_couponListProviderListener);
      _tabController!.addListener(_tabControllerListener);

      _couponListProvider!.setCouponListState(
        _couponListProvider!.couponState.update(progressState: 1),
      );

      _couponListProvider!.getCouponListData(
        storeId: widget.storeModel!.id,
        status: _categoryList[0],
        searchKey: _controller.text.trim(),
        enabled: widget.isForBusiness! || widget.isForSelection! ? true : null,
        eligibility: widget.isForBusiness! ? AppConfig.eligibilityForCoupon.last["value"] : null,
      );
    });
  }

  void _tabControllerListener() {
    if ((_couponListProvider!.couponState.progressState != 1) &&
        (_controller.text.isNotEmpty ||
            _couponListProvider!.couponState.couponModels![_categoryList[_tabController!.index]] == null ||
            _couponListProvider!.couponState.couponModels![_categoryList[_tabController!.index]].isEmpty)) {
      Map<String, dynamic>? couponModels = _couponListProvider!.couponState.couponModels;
      Map<String, dynamic>? couponMetaData = _couponListProvider!.couponState.couponMetaData;

      if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
        couponModels![_categoryList[_oldTabIndex]] = [];
        couponMetaData![_categoryList[_oldTabIndex]] = Map<String, dynamic>();
      }

      _couponListProvider!.setCouponListState(
        _couponListProvider!.couponState.update(
          progressState: 1,
          couponModels: couponModels,
          couponMetaData: couponMetaData,
        ),
      );

      _controller.clear();
      _oldTabIndex = _tabController!.index;

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _couponListProvider!.getCouponListData(
          storeId: widget.storeModel!.id,
          status: _categoryList[_tabController!.index],
          searchKey: _controller.text.trim(),
          enabled: widget.isForBusiness! || widget.isForSelection! ? true : null,
          eligibility: widget.isForBusiness! ? AppConfig.eligibilityForCoupon.last["value"] : null,
        );
      });
    }
    _oldTabIndex = _tabController!.index;
    setState(() {});
  }

  @override
  void dispose() {
    _couponListProvider!.removeListener(_couponListProviderListener);

    super.dispose();
  }

  void _couponListProviderListener() async {
    if (_tabController == null) return;
    if (_couponListProvider!.couponState.progressState == -1) {
      if (_couponListProvider!.couponState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _couponListProvider!.setCouponListState(
          _couponListProvider!.couponState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_couponListProvider!.couponState.progressState == 2) {
      if (_couponListProvider!.couponState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _couponListProvider!.setCouponListState(
          _couponListProvider!.couponState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? couponModels = _couponListProvider!.couponState.couponModels;
    Map<String, dynamic>? couponMetaData = _couponListProvider!.couponState.couponMetaData;

    couponModels![_categoryList[_tabController!.index]] = [];
    couponMetaData![_categoryList[_tabController!.index]] = Map<String, dynamic>();
    _couponListProvider!.setCouponListState(
      _couponListProvider!.couponState.update(
        progressState: 1,
        couponModels: couponModels,
        couponMetaData: couponMetaData,
        isRefresh: true,
      ),
    );

    _couponListProvider!.getCouponListData(
      storeId: widget.storeModel!.id,
      status: _categoryList[_tabController!.index],
      searchKey: _controller.text.trim(),
      enabled: widget.isForBusiness! || widget.isForSelection! ? true : null,
      eligibility: widget.isForBusiness! ? AppConfig.eligibilityForCoupon.last["value"] : null,
    );
  }

  void _onLoading() async {
    _couponListProvider!.setCouponListState(
      _couponListProvider!.couponState.update(progressState: 1),
    );
    _couponListProvider!.getCouponListData(
      storeId: widget.storeModel!.id,
      status: _categoryList[_tabController!.index],
      searchKey: _controller.text.trim(),
      enabled: widget.isForBusiness! || widget.isForSelection! ? true : null,
      eligibility: widget.isForBusiness! ? AppConfig.eligibilityForCoupon.last["value"] : null,
    );
  }

  void _searchKeyCouponListHandler() {
    Map<String, dynamic>? couponModels = _couponListProvider!.couponState.couponModels;
    Map<String, dynamic>? couponMetaData = _couponListProvider!.couponState.couponMetaData;

    couponModels![_categoryList[_tabController!.index]] = [];
    couponMetaData![_categoryList[_tabController!.index]] = Map<String, dynamic>();
    _couponListProvider!.setCouponListState(
      _couponListProvider!.couponState.update(
        progressState: 1,
        couponModels: couponModels,
        couponMetaData: couponMetaData,
      ),
    );

    _couponListProvider!.getCouponListData(
      storeId: widget.storeModel!.id,
      status: _categoryList[_tabController!.index],
      searchKey: _controller.text.trim(),
      enabled: widget.isForBusiness! || widget.isForSelection! ? true : null,
      eligibility: widget.isForBusiness! ? AppConfig.eligibilityForCoupon.last["value"] : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Column(
          children: [
            _appBar(),
            SizedBox(height: heightDp * 10),
            Expanded(
              child: Consumer<CouponListProvider>(builder: (context, couponListProvider, _) {
                if (couponListProvider.couponState.progressState == 0) {
                  return Center(child: CupertinoActivityIndicator());
                }

                if (couponListProvider.couponState.progressState == -1) {
                  return ErrorPage(
                    message: couponListProvider.couponState.message,
                    callback: () {
                      _couponListProvider!.setCouponListState(
                        _couponListProvider!.couponState.update(
                          progressState: 1,
                          isRefresh: true,
                        ),
                      );

                      _couponListProvider!.getCouponListData(
                        storeId: widget.storeModel!.id,
                        status: _categoryList[0],
                        searchKey: _controller.text.trim(),
                        enabled: widget.isForBusiness! || widget.isForSelection! ? true : null,
                        eligibility: widget.isForBusiness! ? AppConfig.eligibilityForCoupon.last["value"] : null,
                      );
                    },
                  );
                }

                return DefaultTabController(
                  length: _categoryList.length,
                  child: Container(
                    width: deviceWidth,
                    height: deviceHeight,
                    child: Column(
                      children: [
                        _searchField(),
                        SizedBox(height: heightDp * 10),
                        Expanded(child: _productListPanel()),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      width: deviceWidth,
      child: Column(
        children: [
          Container(
            height: statusbarHeight,
            color: config.Colors().mainColor(1).withOpacity(1),
          ),
          Stack(
            children: [
              Container(
                width: deviceWidth,
                child: Column(
                  children: [
                    Container(
                      width: deviceWidth,
                      alignment: Alignment.topCenter,
                      color: config.Colors().mainColor(1).withOpacity(1),
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: heightDp * 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Coupons",
                                style: TextStyle(fontSize: fontSp * 24, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                "img/coupons.png",
                                width: heightDp * 100,
                                height: heightDp * 100,
                                color: Colors.white,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          if (!widget.isForSelection! && !widget.isForBusiness!) SizedBox(height: heightDp * 15),
                          if (widget.isForSelection!)
                            Text(
                              "Select a coupon",
                              style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                            ),
                          if (widget.isForSelection!) SizedBox(height: heightDp * 10),
                        ],
                      ),
                    ),
                    if (!widget.isForSelection! && !widget.isForBusiness!) SizedBox(height: heightDp * 22.5),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      SizedBox(height: heightDp * 10),
                      Icon(Icons.arrow_back_ios, size: heightDp * 25, color: Colors.white),
                    ],
                  ),
                ),
              ),
              if (!widget.isForSelection! && !widget.isForBusiness!)
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: deviceWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: deviceWidth * 0.9,
                          height: heightDp * 45,
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(heightDp * 45),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                offset: Offset(0, 3),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: _tabBar(),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
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
              hintText: CouponListPageString.searchHint,
              prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
              suffixIcons: [
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                    _searchKeyCouponListHandler();
                  },
                  child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                ),
              ],
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchKeyCouponListHandler();
              },
            ),
          ),
          if (!widget.isForSelection! && !widget.isForBusiness!) SizedBox(width: widthDp * 10),
          if (!widget.isForSelection! && !widget.isForBusiness!)
            KeicyRaisedButton(
              width: widthDp * 110,
              height: heightDp * 40,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "New Coupon",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: () async {
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CouponDetailPage(isNew: true),
                  ),
                );

                if (result != null && result["isUpdated"]) {
                  _onRefresh();
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: false,
      indicatorColor: config.Colors().mainColor(1),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.zero,
      labelStyle: TextStyle(fontSize: fontSp * 16),
      labelColor: config.Colors().mainColor(1),
      unselectedLabelColor: Colors.black,
      tabs: List.generate(_categoryList.length, (index) {
        return Tab(
          text: "${_categoryList[index]}",
        );
      }),
    );
  }

  Widget _productListPanel() {
    int index = _tabController!.index;
    String category = _categoryList[index];

    List<dynamic> couponModels = [];
    Map<String, dynamic> couponMetaData = Map<String, dynamic>();

    if (_couponListProvider!.couponState.couponModels![category] != null) {
      couponModels = _couponListProvider!.couponState.couponModels![category];
    }
    if (_couponListProvider!.couponState.couponMetaData![category] != null) {
      couponMetaData = _couponListProvider!.couponState.couponMetaData![category];
    }

    int itemCount = 0;

    if (_couponListProvider!.couponState.couponModels![category] != null) {
      int length = _couponListProvider!.couponState.couponModels![category].length;
      itemCount += length;
    }

    if (_couponListProvider!.couponState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (couponMetaData["nextPage"] != null && _couponListProvider!.couponState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshControllerList[index],
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Coupon Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: itemCount % 2 == 0 ? itemCount ~/ 2 : itemCount ~/ 2 + 1,
                itemBuilder: (context, index) {
                  CouponModel? couponModel1 = (index * 2 >= couponModels.length) ? null : couponModels[index * 2];
                  CouponModel? couponModel2 = (index * 2 + 1 >= couponModels.length) ? null : couponModels[index * 2 + 1];
                  return Container(
                    width: deviceWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CouponWidget(
                          storeModel: widget.storeModel,
                          couponModel: couponModel1,
                          isLoading: couponModel1 == null,
                          isForView: widget.isForSelection! || widget.isForBusiness!,
                          margin: EdgeInsets.only(
                            left: widthDp * 20,
                            right: widthDp * 10,
                            top: heightDp * 5,
                            bottom: heightDp * 10,
                          ),
                          editHandler: () {
                            _editHandler(couponModel1, index * 2);
                          },
                          shareHandler: () {
                            _shareHandler(couponModel1);
                          },
                          enableHandler: (bool enable) {
                            String message = enable
                                ? "Are you sure you want to enable this coupon, if you do this, this coupon will be shown to all customers visiting your store"
                                : "Are you sure you want to disable this coupon, if you do this, this coupon will not be shown to your customers";

                            NormalAskDialog.show(context, content: message, callback: () {
                              _enableHandler(couponModel1, index, enable);
                            });
                          },
                          tapHandler: widget.isForSelection!
                              ? () {
                                  _tapHandler(couponModel1);
                                }
                              : null,
                        ),
                        if (_couponListProvider!.couponState.progressState == 2 && couponModel2 == null)
                          SizedBox()
                        else
                          CouponWidget(
                            storeModel: widget.storeModel,
                            couponModel: couponModel2,
                            isLoading: couponModel1 == null,
                            isForView: widget.isForSelection! || widget.isForBusiness!,
                            margin: EdgeInsets.only(
                              left: widthDp * 10,
                              right: widthDp * 20,
                              top: heightDp * 5,
                              bottom: heightDp * 10,
                            ),
                            editHandler: () {
                              _editHandler(couponModel2, index * 2 + 1);
                            },
                            shareHandler: () {
                              _shareHandler(couponModel2);
                            },
                            enableHandler: (bool enable) {
                              String message = enable
                                  ? "Are you sure you want to enable this coupon, if you do this, this coupon will be shown to all customers visiting your store"
                                  : "Are you sure you want to disable this coupon, if you do this, this coupon will not be shown to your customers";

                              NormalAskDialog.show(context, content: message, callback: () {
                                _enableHandler(couponModel2, index * 2 + 1, enable);
                              });
                            },
                            tapHandler: widget.isForSelection!
                                ? () {
                                    _tapHandler(couponModel2);
                                  }
                                : null,
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _editHandler(CouponModel? couponModel, int index) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => CouponDetailPage(
          isNew: false,
          couponModel: couponModel,
        ),
      ),
    );

    if (result != null && result["isUpdated"]) {
      String category = _categoryList[_tabController!.index];

      List<dynamic> couponModels = _couponListProvider!.couponState.couponModels![category];
      couponModels[index] = result["couponModel"];
      setState(() {});
    }
  }

  void _enableHandler(CouponModel? couponModel, int index, bool enabled) async {
    await _keicyProgressDialog!.show();
    var result = await CouponsApiProvider.enableCoupons(couponId: couponModel!.id, enabled: enabled);
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      couponModel.enabled = enabled;
      String category = _categoryList[_tabController!.index];

      List<dynamic> couponModels = _couponListProvider!.couponState.couponModels![category];
      couponModels[index] = couponModel;
      setState(() {});
    }
  }

  void _shareHandler(CouponModel? couponModel) async {
    Uri dynamicUrl = await DynamicLinkService.createCouponDynamicLink(
      storeModel: widget.storeModel,
      couponModel: couponModel,
    );
    Share.share(dynamicUrl.toString());
  }

  void _tapHandler(CouponModel? couponModel) async {
    Navigator.of(context).pop(couponModel);
  }
}
