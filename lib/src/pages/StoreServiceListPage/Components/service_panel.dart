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
import 'package:trapp/src/elements/store_service_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/NewServicePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/services/dynamic_link_service.dart';

import '../index.dart';

class ServicesPanel extends StatefulWidget {
  const ServicesPanel({Key? key}) : super(key: key);

  @override
  _ServicesPanelState createState() => _ServicesPanelState();
}

class _ServicesPanelState extends State<ServicesPanel> {
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

  ServiceListPageProvider? _serviceListPageProvider;

  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  KeicyProgressDialog? _keicyProgressDialog;

  List<String>? _storeIds;
  List<dynamic> _categoryList = [];
  List<dynamic> _providedList = [];

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

    _serviceListPageProvider = ServiceListPageProvider.of(context);

    _refreshController = RefreshController();
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _categoryList = [];
    _providedList = [];

    for (var i = 0; i < StoreDataProvider.of(context).storeDataState.serviceCategoryList!.length; i++) {
      _categoryList.add(StoreDataProvider.of(context).storeDataState.serviceCategoryList![i]);
    }

    for (var i = 0; i < StoreDataProvider.of(context).storeDataState.serviceProvidedList!.length; i++) {
      _providedList.add(StoreDataProvider.of(context).storeDataState.serviceProvidedList![i]);
    }

    _storeIds = [AuthProvider.of(context).authState.storeModel!.id!];

    _serviceListPageProvider!.setServiceListPageState(
      _serviceListPageProvider!.serviceListPageState.update(
        progressState: 0,
        serviceListData: Map<String, dynamic>(),
        serviceMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _serviceListPageProvider!.addListener(_serviceListPageProviderListener);

      _serviceListPageProvider!.setServiceListPageState(
        _serviceListPageProvider!.serviceListPageState.update(progressState: 1),
      );

      _serviceListPageProvider!.getServiceList(
        storeIds: _storeIds,
        categories: _categoryList,
        provideds: _providedList,
        isDeleted: null,
        listonline: null,
      );
    });
  }

  @override
  void dispose() {
    _serviceListPageProvider!.removeListener(_serviceListPageProviderListener);

    super.dispose();
  }

  void _serviceListPageProviderListener() async {
    if (_serviceListPageProvider!.serviceListPageState.progressState == -1) {
      if (_serviceListPageProvider!.serviceListPageState.isRefresh!) {
        _refreshController!.refreshFailed();
        _serviceListPageProvider!.setServiceListPageState(
          _serviceListPageProvider!.serviceListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_serviceListPageProvider!.serviceListPageState.progressState == 2) {
      if (_serviceListPageProvider!.serviceListPageState.isRefresh!) {
        _refreshController!.refreshCompleted();
        _serviceListPageProvider!.setServiceListPageState(
          _serviceListPageProvider!.serviceListPageState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? serviceListData = _serviceListPageProvider!.serviceListPageState.serviceListData;
    Map<String, dynamic>? serviceMetaData = _serviceListPageProvider!.serviceListPageState.serviceMetaData;

    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";

    serviceListData![category] = [];
    serviceMetaData![category] = Map<String, dynamic>();
    _serviceListPageProvider!.setServiceListPageState(
      _serviceListPageProvider!.serviceListPageState.update(
        progressState: 1,
        serviceListData: serviceListData,
        serviceMetaData: serviceMetaData,
        isRefresh: true,
      ),
    );

    _serviceListPageProvider!.getServiceList(
      storeIds: _storeIds,
      categories: _categoryList,
      provideds: _providedList,
      searchKey: _controller.text.trim(),
      isDeleted: null,
      listonline: null,
    );
  }

  void _onLoading() async {
    _serviceListPageProvider!.setServiceListPageState(
      _serviceListPageProvider!.serviceListPageState.update(progressState: 1),
    );
    _serviceListPageProvider!.getServiceList(
      storeIds: _storeIds,
      categories: _categoryList,
      provideds: _providedList,
      searchKey: _controller.text.trim(),
      isDeleted: null,
      listonline: null,
    );
  }

  void _searchKeyStoreServiceListHandler() {
    Map<String, dynamic>? serviceListData = _serviceListPageProvider!.serviceListPageState.serviceListData;
    Map<String, dynamic>? serviceMetaData = _serviceListPageProvider!.serviceListPageState.serviceMetaData;

    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";

    serviceListData![category] = [];
    serviceMetaData![category] = Map<String, dynamic>();
    _serviceListPageProvider!.setServiceListPageState(
      _serviceListPageProvider!.serviceListPageState.update(
        progressState: 1,
        serviceListData: serviceListData,
        serviceMetaData: serviceMetaData,
      ),
    );

    _serviceListPageProvider!.getServiceList(
      storeIds: _storeIds,
      categories: _categoryList,
      provideds: _providedList,
      searchKey: _controller.text.trim(),
      isDeleted: null,
      listonline: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceListPageProvider>(
      builder: (context, serviceListPageProvider, _) {
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
                        var result = await ServiceCategoryBottomSheetDialog.show(
                          context,
                          _categoryList,
                        );

                        if (result != null && result != _categoryList) {
                          _categoryList = result;
                          _onRefresh();
                        }
                      },
                    ),
                    SizedBox(),
                    KeicyRaisedButton(
                      width: widthDp * 165,
                      height: heightDp * 35,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 8,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Text(
                        "Search By Provided",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      ),
                      onPressed: () async {
                        var result = await ServiceProvidedBottomSheetDialog.show(
                          context,
                          _providedList,
                        );

                        if (result != null && result != _providedList) {
                          _providedList = result;
                          _onRefresh();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightDp * 5),
              Expanded(child: _storeServiceListPanel()),
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
              hintText: StoreServiceListPageString.searchHint,
              prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
              suffixIcons: [
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                    _searchKeyStoreServiceListHandler();
                  },
                  child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                ),
              ],
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchKeyStoreServiceListHandler();
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
                  builder: (BuildContext context) => NewServicePage(type: "service", isNew: true),
                ),
              );

              if (result != null) {
                if (!_categoryList.contains(result["category"])) {
                  _categoryList.add(result["category"]);
                }
                if (!_providedList.contains(result["provided"])) {
                  _providedList.add(result["provided"]);
                }

                _onRefresh();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _storeServiceListPanel() {
    List<dynamic> storeServiceList = [];
    Map<String, dynamic> serviceMetaData = Map<String, dynamic>();

    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";

    if (_serviceListPageProvider!.serviceListPageState.serviceListData![category] != null) {
      storeServiceList = _serviceListPageProvider!.serviceListPageState.serviceListData![category];
    }
    if (_serviceListPageProvider!.serviceListPageState.serviceMetaData![category] != null) {
      serviceMetaData = _serviceListPageProvider!.serviceListPageState.serviceMetaData![category];
    }

    int itemCount = 0;

    if (_serviceListPageProvider!.serviceListPageState.serviceListData![category] != null) {
      int length = _serviceListPageProvider!.serviceListPageState.serviceListData![category].length;
      itemCount += length;
    }

    if (_serviceListPageProvider!.serviceListPageState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (serviceMetaData["nextPage"] != null && _serviceListPageProvider!.serviceListPageState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshController!,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Service Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: itemCount % 2 == 0 ? itemCount ~/ 2 : itemCount ~/ 2 + 1,
                itemBuilder: (context, index) {
                  Map<String, dynamic> serviceData1 = (index * 2 >= storeServiceList.length) ? Map<String, dynamic>() : storeServiceList[index * 2];
                  Map<String, dynamic> serviceData2 =
                      (index * 2 + 1 >= storeServiceList.length) ? Map<String, dynamic>() : storeServiceList[index * 2 + 1];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: StoreServiceWidget(
                          serviceModel: serviceData1.isEmpty ? null : ServiceModel.fromJson(serviceData1),
                          isLoading: serviceData1.isEmpty,
                          editHandler: () {
                            _editHandler(serviceData1);
                          },
                          shareHandler: () {
                            _shareHandler(serviceData1);
                          },
                          deleteHandler: () {
                            NormalAskDialog.show(
                              context,
                              title: "Delete Service",
                              content: "Are you sure you want to delete the service?",
                              callback: () {
                                _deleteHandler(serviceData1);
                              },
                            );
                          },
                          availableHandler: (bool isAvailable) {
                            _availableHandler(serviceData1, index * 2, isAvailable);
                          },
                          listonlineHandler: (bool listonline) {
                            _listonlineHandler(serviceData1, index * 2, listonline);
                          },
                        ),
                      ),
                      (_serviceListPageProvider!.serviceListPageState.progressState == 2 && serviceData2.isEmpty)
                          ? Container(
                              width: widthDp * 170,
                              height: heightDp * 240,
                              margin: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                            )
                          : GestureDetector(
                              onTap: () {},
                              child: StoreServiceWidget(
                                serviceModel: serviceData2.isEmpty ? null : ServiceModel.fromJson(serviceData2),
                                isLoading: serviceData2.isEmpty,
                                editHandler: () {
                                  _editHandler(serviceData2);
                                },
                                shareHandler: () {
                                  _shareHandler(serviceData2);
                                },
                                deleteHandler: () {
                                  NormalAskDialog.show(
                                    context,
                                    title: "Delete Service",
                                    content: "Are you sure you want to delete the service?",
                                    callback: () {
                                      _deleteHandler(serviceData2);
                                    },
                                  );
                                },
                                availableHandler: (bool isAvailable) {
                                  _availableHandler(serviceData2, index * 2 + 1, isAvailable);
                                },
                                listonlineHandler: (bool listonline) {
                                  _listonlineHandler(serviceData2, index * 2 + 1, listonline);
                                },
                              ),
                            ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  void _editHandler(Map<String, dynamic> serviceData) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => NewServicePage(
          type: "service",
          isNew: false,
          serviceModel: ServiceModel.fromJson(serviceData),
        ),
      ),
    );

    if (result != null) {
      if (!_categoryList.contains(result["category"])) {
        _categoryList.add(result["category"]);
      }
      if (!_providedList.contains(result["provided"])) {
        _providedList.add(result["provided"]);
      }

      _onRefresh();
    }
  }

  void _shareHandler(Map<String, dynamic> serviceData) async {
    Uri dynamicUrl = await DynamicLinkService.createProductDynamicLink(
      itemData: serviceData,
      storeModel: AuthProvider.of(context).authState.storeModel,
      type: "services",
      isForCart: true,
    );
    Share.share(dynamicUrl.toString());
  }

  void _deleteHandler(Map<String, dynamic> serviceData) async {
    await _keicyProgressDialog!.show();
    var result = await ServiceApiProvider.deleteService(
      serviceId: serviceData["_id"],
      token: AuthProvider.of(context).authState.businessUserModel!.token,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _onRefresh();
    }
  }

  void _availableHandler(Map<String, dynamic> serviceData, int index, bool isAvailable) async {
    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";
    Map<String, dynamic> newServiceData = json.decode(json.encode(serviceData));
    newServiceData["isAvailable"] = isAvailable;

    await _keicyProgressDialog!.show();
    var result = await ServiceApiProvider.addService(
      serviceData: newServiceData,
      token: AuthProvider.of(context).authState.businessUserModel!.token,
      isNew: false,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _serviceListPageProvider!.serviceListPageState.serviceListData![category][index] = newServiceData;
      setState(() {});
    }
  }

  void _listonlineHandler(Map<String, dynamic> serviceData, int index, bool listonline) async {
    String category = _categoryList.isNotEmpty ? _categoryList.join("_") : "ALL";
    Map<String, dynamic> newServiceData = json.decode(json.encode(serviceData));
    newServiceData["listonline"] = listonline;

    await _keicyProgressDialog!.show();
    var result = await ServiceApiProvider.addService(
      serviceData: newServiceData,
      token: AuthProvider.of(context).authState.businessUserModel!.token,
      isNew: false,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _serviceListPageProvider!.serviceListPageState.serviceListData![category][index] = newServiceData;
      setState(() {});
    }
  }
}
