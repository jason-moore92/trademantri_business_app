import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/qrcode_icon_widget.dart';
import 'package:trapp/src/elements/store_connection_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ChatListPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class BusinessStoresView extends StatefulWidget {
  final String? status;
  final bool? forSelection;

  BusinessStoresView({Key? key, this.status, this.forSelection}) : super(key: key);

  @override
  _BusinessStoresViewState createState() => _BusinessStoresViewState();
}

class _BusinessStoresViewState extends State<BusinessStoresView> with SingleTickerProviderStateMixin {
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
  BusinessStoresProvider? _businessStoresProvider;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

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
    _businessStoresProvider = BusinessStoresProvider.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _businessStoresProvider!.addListener(_businessStoresProviderListener);

      if (_businessStoresProvider!.businessStoresState.storeList![widget.status] == null) {
        _businessStoresProvider!.setBusinessStoresState(
          _businessStoresProvider!.businessStoresState.update(
            progressState: 1,
          ),
        );

        _businessStoresProvider!.getStoreList(
          storeId: _authProvider!.authState.storeModel!.id,
          status: widget.status,
          searchKey: _controller.text.trim(),
        );
      }
    });
  }

  @override
  void dispose() {
    _businessStoresProvider!.removeListener(_businessStoresProviderListener);
    super.dispose();
  }

  void _businessStoresProviderListener() async {
    if (_businessStoresProvider!.businessStoresState.progressState == -1) {
      if (_businessStoresProvider!.businessStoresState.isRefresh!) {
        _businessStoresProvider!.setBusinessStoresState(
          _businessStoresProvider!.businessStoresState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_businessStoresProvider!.businessStoresState.progressState == 2) {
      if (_businessStoresProvider!.businessStoresState.isRefresh!) {
        _businessStoresProvider!.setBusinessStoresState(
          _businessStoresProvider!.businessStoresState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? storeList = _businessStoresProvider!.businessStoresState.storeList!;
    Map<String, dynamic>? storeMetaData = _businessStoresProvider!.businessStoresState.storeMetaData;

    storeList = Map<String, dynamic>();
    storeMetaData = Map<String, dynamic>();
    _businessStoresProvider!.setBusinessStoresState(
      _businessStoresProvider!.businessStoresState.update(
        progressState: 1,
        storeList: storeList,
        storeMetaData: storeMetaData,
        isRefresh: true,
      ),
    );

    _businessStoresProvider!.getStoreList(
      storeId: _authProvider!.authState.storeModel!.id,
      status: widget.status,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _businessStoresProvider!.setBusinessStoresState(
      _businessStoresProvider!.businessStoresState.update(progressState: 1),
    );

    _businessStoresProvider!.getStoreList(
      storeId: _authProvider!.authState.storeModel!.id,
      status: widget.status,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyBusinessStoresHandler() {
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Connected Stores",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<BusinessStoresProvider>(builder: (context, businessStoresProvider, _) {
        if (businessStoresProvider.businessStoresState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (businessStoresProvider.businessStoresState.progressState == -1) {
          return ErrorPage(
            message: businessStoresProvider.businessStoresState.message,
            callback: () {
              businessStoresProvider.setBusinessStoresState(
                businessStoresProvider.businessStoresState.update(progressState: 1),
              );
              _businessStoresProvider!.getStoreList(
                storeId: _authProvider!.authState.storeModel!.id,
                status: widget.status,
                searchKey: _controller.text.trim(),
              );
            },
          );
        }

        return SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            height: deviceHeight - appbarHeight - statusbarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchField(),
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
            hintText: BusinessStoresPageString.searchHint,
            prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
            suffixIcons: [
              GestureDetector(
                onTap: () {
                  _controller.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                  _searchKeyBusinessStoresHandler();
                },
                child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
              ),
            ],
            onFieldSubmittedHandler: (input) {
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyBusinessStoresHandler();
            },
          ),
        ),
        QRCodeIconWidget(
          isOnlyStore: true,
          connectionHandler: ({StoreModel? storeModel, BusinessConnectionModel? connectionModel}) {
            BusinessConnectionsProvider.of(context).updateHandler(storeModel: storeModel, connectionModel: connectionModel);
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

  Widget _storeListPanel() {
    if (_businessStoresProvider!.businessStoresState.progressState == 0) {
      return Center(child: CupertinoActivityIndicator());
    }
    List<dynamic> storeList = [];
    Map<String, dynamic> storeMetaData = Map<String, dynamic>();

    if (_businessStoresProvider!.businessStoresState.storeList![widget.status] != null) {
      storeList = _businessStoresProvider!.businessStoresState.storeList![widget.status];
    }
    if (_businessStoresProvider!.businessStoresState.storeMetaData != null) {
      storeMetaData = _businessStoresProvider!.businessStoresState.storeMetaData!;
    }

    int itemCount = 0;

    if (_businessStoresProvider!.businessStoresState.storeList![widget.status] != null) {
      int length = _businessStoresProvider!.businessStoresState.storeList![widget.status].length;
      itemCount += length;
    }

    if (_businessStoresProvider!.businessStoresState.progressState != 2) {
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
              enablePullUp: (storeMetaData["nextPage"] != null && _businessStoresProvider!.businessStoresState.progressState != 1),
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
                                storeModel: storeData1.isNotEmpty &&
                                        storeData1["recepientStore"] != null &&
                                        _authProvider!.authState.storeModel!.id != storeData1["recepientStore"]["_id"]
                                    ? StoreModel.fromJson(storeData1["recepientStore"])
                                    : storeData1.isNotEmpty &&
                                            storeData1["requestedStore"] != null &&
                                            _authProvider!.authState.storeModel!.id != storeData1["requestedStore"]["_id"]
                                        ? StoreModel.fromJson(storeData1["requestedStore"])
                                        : null,
                                connectionModel: storeData1.isEmpty ? null : BusinessConnectionModel.fromJson(storeData1),
                                loadingStatus: storeData1.isEmpty,
                                margin: EdgeInsets.only(left: widthDp * 20, right: widthDp * 5, top: heightDp * 5, bottom: heightDp * 5),
                                callback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {},
                                tapHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) async {
                                  if (widget.forSelection!) {
                                    Navigator.of(context).pop(storeModel!.toJson());
                                  } else {
                                    _viewHandler(
                                      storeModel: storeModel,
                                      connectionModel: connectionModel,
                                      index: index * 2,
                                    );
                                  }
                                },
                              ),
                              if (_businessStoresProvider!.businessStoresState.progressState == 2 && storeData2.isEmpty)
                                SizedBox()
                              else
                                StoreConnectionWidget(
                                  storeModel: storeData2.isNotEmpty &&
                                          storeData2["recepientStore"] != null &&
                                          _authProvider!.authState.storeModel!.id != storeData2["recepientStore"]["_id"]
                                      ? StoreModel.fromJson(storeData2["recepientStore"])
                                      : storeData2.isNotEmpty &&
                                              storeData2["requestedStore"] != null &&
                                              _authProvider!.authState.storeModel!.id != storeData2["requestedStore"]["_id"]
                                          ? StoreModel.fromJson(storeData2["requestedStore"])
                                          : null,
                                  connectionModel: storeData2.isEmpty ? null : BusinessConnectionModel.fromJson(storeData2),
                                  loadingStatus: storeData2.isEmpty,
                                  margin: EdgeInsets.only(left: widthDp * 5, right: widthDp * 20, top: heightDp * 5, bottom: heightDp * 5),
                                  callback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {},
                                  tapHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) async {
                                    if (widget.forSelection!) {
                                      Navigator.of(context).pop(storeModel!.toJson());
                                    } else {
                                      _viewHandler(
                                        storeModel: storeModel,
                                        connectionModel: connectionModel,
                                        index: index * 2,
                                      );
                                    }
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

  void _viewHandler({@required StoreModel? storeModel, @required BusinessConnectionModel? connectionModel, @required int? index}) async {
    if (connectionModel!.status == ConnectionStatus.active) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => StorePage(storeModel: storeModel),
        ),
      );
    } else {
      StoreConnectionDialog.show(
        context,
        storeModel: storeModel,
        connectionModel: connectionModel,
        connectionHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {},
      );
    }
  }
}
