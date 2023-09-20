import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/store_type_bottom_dialog.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/qrcode_icon_widget.dart';
import 'package:trapp/src/elements/store_connection_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ChatListPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/pages/SearchCategoryPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class BusinessConectionsView extends StatefulWidget {
  BusinessConectionsView({Key? key}) : super(key: key);

  @override
  _BusinessConectionsViewState createState() => _BusinessConectionsViewState();
}

class _BusinessConectionsViewState extends State<BusinessConectionsView> with SingleTickerProviderStateMixin {
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
  BusinessConnectionsProvider? _businessConnectionsProvider;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<dynamic> _selectedStoreTypes = [];
  List<dynamic> _selectedCategoryData = [];
  Map<String, dynamic>? _selectedLocation;
  String? _selectedCity;

  RefreshController? _refreshController = RefreshController(initialRefresh: false);

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

    _authProvider = AuthProvider.of(context);
    _businessConnectionsProvider = BusinessConnectionsProvider.of(context);

    _businessConnectionsProvider!.setBusinessConnectionsState(
      BusinessConnectionsState.init(),
      isNotifiable: false,
    );
    _selectedLocation = Map<String, dynamic>();
    _selectedLocation!["lat"] = _authProvider!.authState.storeModel!.location!.latitude;
    _selectedLocation!["lng"] = _authProvider!.authState.storeModel!.location!.longitude;
    _selectedCity = _authProvider!.authState.storeModel!.city;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _businessConnectionsProvider!.addListener(_businessConnectionsProviderListener);
      if (CategoryProvider.of(context).categoryState.progressState != 2) {
        CategoryProvider.of(context).getCategoryAll();
      }

      _businessConnectionsProvider!.setBusinessConnectionsState(
        _businessConnectionsProvider!.businessConnectionsState.update(
          progressState: 1,
        ),
      );

      _businessConnectionsProvider!.getStoreList(
        storeId: _authProvider!.authState.storeModel!.id,
        types: _selectedStoreTypes,
        categoryData: _selectedCategoryData,
        location: _selectedLocation,
      );
    });
  }

  @override
  void dispose() {
    _businessConnectionsProvider!.removeListener(_businessConnectionsProviderListener);
    super.dispose();
  }

  void _businessConnectionsProviderListener() async {
    if (_businessConnectionsProvider!.businessConnectionsState.progressState == -1) {
      if (_businessConnectionsProvider!.businessConnectionsState.isRefresh!) {
        _businessConnectionsProvider!.setBusinessConnectionsState(
          _businessConnectionsProvider!.businessConnectionsState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_businessConnectionsProvider!.businessConnectionsState.progressState == 2) {
      if (_businessConnectionsProvider!.businessConnectionsState.isRefresh!) {
        _businessConnectionsProvider!.setBusinessConnectionsState(
          _businessConnectionsProvider!.businessConnectionsState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic>? storeList = _businessConnectionsProvider!.businessConnectionsState.storeList;
    Map<String, dynamic>? storeMetaData = _businessConnectionsProvider!.businessConnectionsState.storeMetaData;

    storeList = [];
    storeMetaData = Map<String, dynamic>();
    _businessConnectionsProvider!.setBusinessConnectionsState(
      _businessConnectionsProvider!.businessConnectionsState.update(
        progressState: 1,
        storeList: storeList,
        storeMetaData: storeMetaData,
        isRefresh: true,
      ),
    );

    _businessConnectionsProvider!.getStoreList(
      storeId: _authProvider!.authState.storeModel!.id,
      types: _selectedStoreTypes,
      categoryData: _selectedCategoryData,
      location: _selectedLocation,
    );
  }

  void _onLoading() async {
    _businessConnectionsProvider!.setBusinessConnectionsState(
      _businessConnectionsProvider!.businessConnectionsState.update(progressState: 1),
    );
    _businessConnectionsProvider!.getStoreList(
      storeId: _authProvider!.authState.storeModel!.id,
      types: _selectedStoreTypes,
      categoryData: _selectedCategoryData,
      location: _selectedLocation,
    );
  }

  void _searchKeyBusinessConectionsHandler() {
    List<dynamic>? storeList = _businessConnectionsProvider!.businessConnectionsState.storeList;
    Map<String, dynamic>? storeMetaData = _businessConnectionsProvider!.businessConnectionsState.storeMetaData;

    storeList = [];
    storeMetaData = Map<String, dynamic>();
    _businessConnectionsProvider!.setBusinessConnectionsState(
      _businessConnectionsProvider!.businessConnectionsState.update(
        progressState: 1,
        storeList: storeList,
        storeMetaData: storeMetaData,
        isRefresh: true,
      ),
    );

    _businessConnectionsProvider!.getStoreList(
      storeId: _authProvider!.authState.storeModel!.id,
      types: _selectedStoreTypes,
      categoryData: _selectedCategoryData,
      location: _selectedLocation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Search/Connect With Stores",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer2<CategoryProvider, BusinessConnectionsProvider>(builder: (context, categoryProvider, businessConnectionsProvider, _) {
        if (categoryProvider.categoryState.progressState == 0 || categoryProvider.categoryState.progressState == 1) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (categoryProvider.categoryState.progressState == -1) {
          return ErrorPage(
            message: categoryProvider.categoryState.message,
            callback: () {
              categoryProvider.setCategoryState(
                categoryProvider.categoryState.update(progressState: 1),
              );
              categoryProvider.getCategoryAll();
            },
          );
        }

        return SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            height: deviceHeight - statusbarHeight - appbarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchField(),

                ///
                SizedBox(height: heightDp * 10),
                _connectionPanel(),
                SizedBox(height: heightDp * 10),
                Expanded(child: _storeListPanel()),
              ],
            ),
          ),
        );
      }),
      // floatingActionButton: _floatingButton(),
    );
  }

  Widget _searchField() {
    return Row(
      children: [
        SizedBox(width: widthDp * 15),
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
            textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.6)),
            hintText: BusinessConectionsPageString.searchHint,
            prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
            suffixIcons: [
              GestureDetector(
                onTap: () {
                  _controller.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                  _searchKeyBusinessConectionsHandler();
                },
                child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
              ),
            ],
            onFieldSubmittedHandler: (input) {
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyBusinessConectionsHandler();
            },
          ),
        ),
        QRCodeIconWidget(
          isOnlyStore: true,
          connectionHandler: ({StoreModel? storeModel, BusinessConnectionModel? connectionModel}) {
            _businessConnectionsProvider!.updateHandler(storeModel: storeModel, connectionModel: connectionModel);
          },
          invitationHandler: ({@required BusinessConnectionModel? connectionModel, @required StoreModel? storeModel}) {
            BusinessInvitationsProvider.of(context).update(
              connectionModel: connectionModel,
              storeModel: storeModel,
              statusStr: ConnectionStatus.pending,
            );
          },
        ),
        SizedBox(width: widthDp * 10),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ChatListPage(initIndex: 1),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.only(right: widthDp * 10),
            color: Colors.transparent,
            child: Icon(Icons.chat_outlined, size: heightDp * 35),
          ),
        )
      ],
    );
  }

  Widget _connectionPanel() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: deviceWidth,
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () async {
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
                      if (_selectedLocation == null) _selectedLocation = Map<String, dynamic>();
                      _selectedLocation!["lat"] = result.latLng!.latitude;
                      _selectedLocation!["lng"] = result.latLng!.longitude;
                      _selectedCity = result.city;
                      _onRefresh();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(heightDp * 6),
                      color: config.Colors().mainColor(1),
                    ),
                    child: Text(
                      "Location",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SearchCategoryPage(
                          isMultiple: true,
                          selectedCategoryData: _selectedCategoryData,
                        ),
                      ),
                    );

                    if (result != null) {
                      _selectedCategoryData = result;
                      _onRefresh();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 8, vertical: heightDp * 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(heightDp * 6),
                      color: config.Colors().mainColor(1),
                    ),
                    child: Text(
                      "Categories",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var result = await StoreTypeBottomSheetDialog.show(context, _selectedStoreTypes);

                    if (result != null) {
                      _selectedStoreTypes = result;
                      _onRefresh();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 8, vertical: heightDp * 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(heightDp * 6),
                      color: config.Colors().mainColor(1),
                    ),
                    child: Text(
                      "Store Type",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // if(_selectedLocation!=null || _selectedStoreTypes.isNotEmpty ||_selectedCategoryData.isNotEmpty )
          if (_selectedLocation != null)
            Column(
              children: [
                SizedBox(height: heightDp * 10),
                Row(
                  children: [
                    Text(
                      "Location: ",
                      style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: widthDp * 5),
                    Text(
                      "$_selectedCity",
                      style: TextStyle(fontSize: fontSp * 14),
                    ),
                  ],
                )
              ],
            ),
          if (_selectedCategoryData.isNotEmpty)
            Column(
              children: [
                SizedBox(height: heightDp * 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Categories: ",
                      style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: widthDp * 5),
                    Expanded(
                      child: Text(
                        "${_selectedCategoryData.first["categoryDesc"]}" + (_selectedCategoryData.length > 1 ? " and More" : ""),
                        style: TextStyle(fontSize: fontSp * 14),
                      ),
                    ),
                  ],
                )
              ],
            ),
          if (_selectedStoreTypes.isNotEmpty)
            Column(
              children: [
                SizedBox(height: heightDp * 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Types: ",
                      style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: widthDp * 5),
                    Expanded(
                      child: Text(
                        "${_selectedStoreTypes.first}" + (_selectedCategoryData.length > 1 ? " and More" : ""),
                        style: TextStyle(fontSize: fontSp * 14),
                      ),
                    ),
                  ],
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget _storeListPanel() {
    if (_businessConnectionsProvider!.businessConnectionsState.progressState == 0) {
      return Center(child: CupertinoActivityIndicator());
    }
    List<dynamic> storeList = [];
    Map<String, dynamic> storeMetaData = Map<String, dynamic>();

    if (_businessConnectionsProvider!.businessConnectionsState.storeList != null) {
      storeList = _businessConnectionsProvider!.businessConnectionsState.storeList!;
    }
    if (_businessConnectionsProvider!.businessConnectionsState.storeMetaData != null) {
      storeMetaData = _businessConnectionsProvider!.businessConnectionsState.storeMetaData!;
    }

    int itemCount = 0;

    if (_businessConnectionsProvider!.businessConnectionsState.storeList != null) {
      int length = _businessConnectionsProvider!.businessConnectionsState.storeList!.length;
      itemCount += length;
    }

    if (_businessConnectionsProvider!.businessConnectionsState.progressState != 2) {
      itemCount += AppConfig.countLimitForList;
    }

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
              enablePullUp: (storeMetaData["nextPage"] != null && _businessConnectionsProvider!.businessConnectionsState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Store Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount % 2 == 0 ? itemCount ~/ 2 : itemCount ~/ 2 + 1,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> storeData1 = (index * 2 >= storeList.length) ? Map<String, dynamic>() : storeList[index * 2];
                        Map<String, dynamic> storeData2 = (index * 2 + 1 >= storeList.length) ? Map<String, dynamic>() : storeList[index * 2 + 1];
                        return Container(
                          width: deviceWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StoreConnectionWidget(
                                storeModel: storeData1.isEmpty ? null : StoreModel.fromJson(storeData1),
                                connectionModel:
                                    storeData1["connectionModel"] != null ? BusinessConnectionModel.fromJson(storeData1["connectionModel"]) : null,
                                loadingStatus: storeData1.isEmpty,
                                margin: EdgeInsets.only(left: widthDp * 20, right: widthDp * 5, top: heightDp * 5, bottom: heightDp * 5),
                                callback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
                                  _businessConnectionsProvider!.updateHandler(storeModel: storeModel, connectionModel: connectionModel);
                                },
                                tapHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) async {
                                  _viewHandler(
                                    storeModel: storeModel,
                                    connectionModel: connectionModel,
                                    index: index * 2,
                                  );
                                },
                              ),
                              if (_businessConnectionsProvider!.businessConnectionsState.progressState == 2 && storeData2.isEmpty)
                                SizedBox()
                              else
                                StoreConnectionWidget(
                                  storeModel: storeData2.isEmpty ? null : StoreModel.fromJson(storeData2),
                                  connectionModel:
                                      storeData2["connectionModel"] != null ? BusinessConnectionModel.fromJson(storeData2["connectionModel"]) : null,
                                  loadingStatus: storeData2.isEmpty,
                                  margin: EdgeInsets.only(left: widthDp * 5, right: widthDp * 20, top: heightDp * 5, bottom: heightDp * 5),
                                  callback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
                                    _businessConnectionsProvider!.updateHandler(storeModel: storeModel, connectionModel: connectionModel);
                                  },
                                  tapHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) async {
                                    _viewHandler(
                                      storeModel: storeModel,
                                      connectionModel: connectionModel,
                                      index: index * 2 + 1,
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // void _storeConnectionHandler({
  //   @required StoreModel? storeModel,
  //   @required BusinessConnectionModel? connectionModel,
  // }) {
  //   for (var i = 0; i < _businessConnectionsProvider!.businessConnectionsState.storeList!.length; i++) {
  //     if (_businessConnectionsProvider!.businessConnectionsState.storeList![i]["_id"] == storeModel!.id) {
  //       _businessConnectionsProvider!.businessConnectionsState.storeList![i] = storeModel.toJson();
  //       _businessConnectionsProvider!.businessConnectionsState.storeList![i]["connectionModel"] = connectionModel!.toJson();
  //       _businessConnectionsProvider!.setBusinessConnectionsState(
  //         _businessConnectionsProvider!.businessConnectionsState.update(
  //           storeList: _businessConnectionsProvider!.businessConnectionsState.storeList,
  //         ),
  //       );

  //       break;
  //     }
  //   }

  //   setState(() {});
  // }

  // void _invitationHandler({@required BusinessConnectionModel? connectionModel, @required StoreModel? storeModel}) {
  //   Map<String, dynamic> connectionData = connectionModel!.toJson();
  //   connectionData["requestedStore"] = storeModel!.toJson();

  //   for (var i = 0;
  //       i < BusinessInvitationsProvider.of(context).businessInvitationsPageState.requestedStoreList![ConnectionStatus.pending].length;
  //       i++) {
  //     if (BusinessInvitationsProvider.of(context).businessInvitationsPageState.requestedStoreList![ConnectionStatus.pending][i]["_id"] ==
  //         connectionData["_id"]) {
  //       BusinessInvitationsProvider.of(context).businessInvitationsPageState.requestedStoreList![ConnectionStatus.pending][i] = connectionData;
  //       break;
  //     }
  //   }

  //   BusinessInvitationsProvider.of(context).setBusinessInvitationsState(
  //     BusinessInvitationsProvider.of(context).businessInvitationsPageState.update(
  //           requestedStoreList: BusinessInvitationsProvider.of(context).businessInvitationsPageState.requestedStoreList,
  //         ),
  //     isRefresh: true,
  //   );
  //   setState(() {});
  // }

  void _viewHandler({@required StoreModel? storeModel, @required BusinessConnectionModel? connectionModel, @required int? index}) async {
    if (connectionModel!.status == ConnectionStatus.active) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => StorePage(storeModel: storeModel),
        ),
      );
    } else {
      var result = await StoreConnectionDialog.show(
        context,
        storeModel: storeModel,
        connectionModel: connectionModel,
        connectionHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
          _businessConnectionsProvider!.updateHandler(storeModel: storeModel, connectionModel: connectionModel);
        },
      );
    }
  }
}
