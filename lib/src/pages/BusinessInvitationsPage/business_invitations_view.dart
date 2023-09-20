import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/store_connection_widget.dart';
import 'package:trapp/src/elements/store_invitation_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class BusinessInvitationsView extends StatefulWidget {
  final List<String>? status;

  BusinessInvitationsView({Key? key, this.status}) : super(key: key);

  @override
  _BusinessInvitationsViewState createState() => _BusinessInvitationsViewState();
}

class _BusinessInvitationsViewState extends State<BusinessInvitationsView> with SingleTickerProviderStateMixin {
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
  BusinessInvitationsProvider? _businessInvitationsProvider;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<RefreshController?>? _refreshControllerList = [];

  int _step = 0;

  String statusStr = "";

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
    _businessInvitationsProvider = BusinessInvitationsProvider.of(context);

    for (var i = 0; i < 2; i++) {
      _refreshControllerList!.add(RefreshController(initialRefresh: false));
    }

    statusStr = widget.status!.join('_');

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _businessInvitationsProvider!.addListener(_businessInvitationsProviderListener);

      if (_businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList![statusStr] == null) {
        _businessInvitationsProvider!.setBusinessInvitationsState(
          _businessInvitationsProvider!.businessInvitationsPageState.update(
            progressState: 1,
          ),
        );

        _businessInvitationsProvider!.requestedStores(
          recepientId: _authProvider!.authState.storeModel!.id,
          status: widget.status,
        );
      }
    });
  }

  @override
  void dispose() {
    _businessInvitationsProvider!.removeListener(_businessInvitationsProviderListener);
    super.dispose();
  }

  void _businessInvitationsProviderListener() async {
    if (_step == 0) {
      if (_businessInvitationsProvider!.businessInvitationsPageState.progressState == -1) {
        if (_businessInvitationsProvider!.businessInvitationsPageState.isRequestedRefresh!) {
          _businessInvitationsProvider!.setBusinessInvitationsState(
            _businessInvitationsProvider!.businessInvitationsPageState.update(isRequestedRefresh: false),
            isNotifiable: false,
          );
          _refreshControllerList![_step]!.refreshFailed();
        } else {
          _refreshControllerList![_step]!.loadFailed();
        }
      } else if (_businessInvitationsProvider!.businessInvitationsPageState.progressState == 2 ||
          _businessInvitationsProvider!.businessInvitationsPageState.progressState == 3) {
        if (_businessInvitationsProvider!.businessInvitationsPageState.isRequestedRefresh!) {
          _businessInvitationsProvider!.setBusinessInvitationsState(
            _businessInvitationsProvider!.businessInvitationsPageState.update(isRequestedRefresh: false),
            isNotifiable: false,
          );
          _refreshControllerList![_step]!.refreshCompleted();
        } else {
          _refreshControllerList![_step]!.loadComplete();
        }
      }
    } else {
      if (_businessInvitationsProvider!.businessInvitationsPageState.progressState == -1) {
        if (_businessInvitationsProvider!.businessInvitationsPageState.isRecepientRefresh!) {
          _businessInvitationsProvider!.setBusinessInvitationsState(
            _businessInvitationsProvider!.businessInvitationsPageState.update(isRecepientRefresh: false),
            isNotifiable: false,
          );
          _refreshControllerList![_step]!.refreshFailed();
        } else {
          _refreshControllerList![_step]!.loadFailed();
        }
      } else if (_businessInvitationsProvider!.businessInvitationsPageState.progressState == 2 ||
          _businessInvitationsProvider!.businessInvitationsPageState.progressState == 3) {
        if (_businessInvitationsProvider!.businessInvitationsPageState.isRecepientRefresh!) {
          _businessInvitationsProvider!.setBusinessInvitationsState(
            _businessInvitationsProvider!.businessInvitationsPageState.update(isRecepientRefresh: false),
            isNotifiable: false,
          );
          _refreshControllerList![_step]!.refreshCompleted();
        } else {
          _refreshControllerList![_step]!.loadComplete();
        }
      }
    }
  }

  void _onRefresh() async {
    if (_step == 0) {
      Map<String, dynamic>? requestedStoreList = _businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList;
      Map<String, dynamic>? requestedStoreMetaData = _businessInvitationsProvider!.businessInvitationsPageState.requestedStoreMetaData;

      requestedStoreList = Map<String, dynamic>();
      requestedStoreMetaData = Map<String, dynamic>();
      _businessInvitationsProvider!.setBusinessInvitationsState(
        _businessInvitationsProvider!.businessInvitationsPageState.update(
          progressState: 1,
          requestedStoreList: requestedStoreList,
          requestedStoreMetaData: requestedStoreMetaData,
          isRequestedRefresh: true,
        ),
      );

      _businessInvitationsProvider!.requestedStores(
        recepientId: _authProvider!.authState.storeModel!.id,
        status: [ConnectionStatus.pending],
      );
    } else {
      Map<String, dynamic>? recepientStoreList = _businessInvitationsProvider!.businessInvitationsPageState.recepientStoreList;
      Map<String, dynamic>? recepientStoreMetaData = _businessInvitationsProvider!.businessInvitationsPageState.recepientStoreMetaData;

      recepientStoreList = Map<String, dynamic>();
      recepientStoreMetaData = Map<String, dynamic>();
      _businessInvitationsProvider!.setBusinessInvitationsState(
        _businessInvitationsProvider!.businessInvitationsPageState.update(
          progressState: 1,
          recepientStoreList: recepientStoreList,
          recepientStoreMetaData: recepientStoreMetaData,
          isRecepientRefresh: true,
        ),
      );

      _businessInvitationsProvider!.recepientStores(
        requestedId: _authProvider!.authState.storeModel!.id,
        status: widget.status,
      );
    }
  }

  void _onLoading() async {
    if (_step == 0) {
      _businessInvitationsProvider!.setBusinessInvitationsState(
        _businessInvitationsProvider!.businessInvitationsPageState.update(progressState: 1),
      );
      _businessInvitationsProvider!.requestedStores(
        recepientId: _authProvider!.authState.storeModel!.id,
        status: [ConnectionStatus.pending],
      );
    } else {
      _businessInvitationsProvider!.setBusinessInvitationsState(
        _businessInvitationsProvider!.businessInvitationsPageState.update(progressState: 1),
      );
      _businessInvitationsProvider!.recepientStores(
        requestedId: _authProvider!.authState.storeModel!.id,
        status: [ConnectionStatus.pending],
      );
    }
  }

  void _searchKeyBusinessInvitationsHandler() {
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (_step != 0) {
                  setState(() {
                    _step = 0;
                  });
                  _onRefresh();
                }
              },
              child: Container(
                width: widthDp * 120,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _step == 0 ? Colors.green : Colors.grey.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(heightDp * 40),
                    bottomLeft: Radius.circular(heightDp * 40),
                  ),
                ),
                child: Text(
                  "Received",
                  style: TextStyle(fontSize: fontSp * 16, color: _step == 0 ? Colors.white : Colors.black),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_step != 1) {
                  setState(() {
                    _step = 1;
                  });
                  _onRefresh();
                }
              },
              child: Container(
                width: widthDp * 120,
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _step == 1 ? Colors.green : Colors.grey.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(heightDp * 40),
                    bottomRight: Radius.circular(heightDp * 40),
                  ),
                ),
                child: Text(
                  "Sent",
                  style: TextStyle(fontSize: fontSp * 16, color: _step == 1 ? Colors.white : Colors.black),
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Consumer<BusinessInvitationsProvider>(builder: (context, businessInvitationsProvider, _) {
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 3, height: heightDp * 3),
              SizedBox(height: heightDp * 10),
              Expanded(child: _step == 0 ? _requestedStoreListPanel() : _recepientStoreListPanel()),
              SizedBox(height: heightDp * 10),
            ],
          ),
        );
      }),
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
            hintText: BusinessInvitationsPageString.searchHint,
            prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
            suffixIcons: [
              GestureDetector(
                onTap: () {
                  _controller.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                  _searchKeyBusinessInvitationsHandler();
                },
                child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
              ),
            ],
            onFieldSubmittedHandler: (input) {
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyBusinessInvitationsHandler();
            },
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
            color: Colors.transparent,
            child: Image.asset("img/qrcode_scan.png", width: heightDp * 35, height: heightDp * 35),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(right: widthDp * 10),
            color: Colors.transparent,
            child: Icon(Icons.chat_outlined, size: heightDp * 35),
          ),
        )
      ],
    );
  }

  Widget _requestedStoreListPanel() {
    if (_businessInvitationsProvider!.businessInvitationsPageState.progressState == 0) {
      return Center(child: CupertinoActivityIndicator());
    }
    List<dynamic> requestedStoreList = [];
    Map<String, dynamic> requestedStoreMetaData = Map<String, dynamic>();

    if (_businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList![statusStr] != null) {
      requestedStoreList = _businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList![statusStr];
    }
    if (_businessInvitationsProvider!.businessInvitationsPageState.requestedStoreMetaData != null) {
      requestedStoreMetaData = _businessInvitationsProvider!.businessInvitationsPageState.requestedStoreMetaData!;
    }

    int itemCount = 0;

    if (_businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList![statusStr] != null) {
      int length = _businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList![statusStr]!.length;
      itemCount += length;
    }

    if (_businessInvitationsProvider!.businessInvitationsPageState.progressState == 1) {
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
              enablePullUp:
                  (requestedStoreMetaData["nextPage"] != null && _businessInvitationsProvider!.businessInvitationsPageState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList![_step]!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  Map<String, dynamic> storeData =
                      (index >= requestedStoreList.length) ? Map<String, dynamic>() : requestedStoreList[index]["requestedStore"];
                  BusinessConnectionModel? connectionModel =
                      (index >= requestedStoreList.length) ? null : BusinessConnectionModel.fromJson(requestedStoreList[index]);

                  return Column(
                    children: [
                      StoreInvitationWidget(
                        storeModel: storeData.isEmpty ? null : StoreModel.fromJson(storeData),
                        connectionModel: connectionModel,
                        loadingStatus: storeData.isEmpty,
                        invitationCallback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
                          _businessInvitationsProvider!.update(connectionModel: connectionModel, storeModel: storeModel, statusStr: statusStr);
                          _onRefresh();
                        },
                        tapHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) async {
                          _viewHandler(
                            storeModel: storeModel,
                            connectionModel: connectionModel,
                            index: index,
                          );
                        },
                      ),
                      Divider(color: Colors.grey.withOpacity(0.6), thickness: 1, height: 1),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _recepientStoreListPanel() {
    if (_businessInvitationsProvider!.businessInvitationsPageState.progressState == 0) {
      return Center(child: CupertinoActivityIndicator());
    }
    List<dynamic> recepientStoreList = [];
    Map<String, dynamic> recepientStoreMetaData = Map<String, dynamic>();

    if (_businessInvitationsProvider!.businessInvitationsPageState.recepientStoreList![statusStr] != null) {
      recepientStoreList = _businessInvitationsProvider!.businessInvitationsPageState.recepientStoreList![statusStr];
    }
    if (_businessInvitationsProvider!.businessInvitationsPageState.requestedStoreMetaData != null) {
      recepientStoreMetaData = _businessInvitationsProvider!.businessInvitationsPageState.recepientStoreMetaData!;
    }

    int itemCount = 0;

    if (_businessInvitationsProvider!.businessInvitationsPageState.recepientStoreList![statusStr] != null) {
      int length = _businessInvitationsProvider!.businessInvitationsPageState.recepientStoreList![statusStr].length;
      itemCount += length;
    }

    if (_businessInvitationsProvider!.businessInvitationsPageState.progressState == 1) {
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
              enablePullUp:
                  (recepientStoreMetaData["nextPage"] != null && _businessInvitationsProvider!.businessInvitationsPageState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList![_step]!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: itemCount % 2 == 0 ? itemCount ~/ 2 : itemCount ~/ 2 + 1,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data1 = (index * 2 >= recepientStoreList.length) ? Map<String, dynamic>() : recepientStoreList[index * 2];
                  Map<String, dynamic> data2 =
                      (index * 2 + 1 >= recepientStoreList.length) ? Map<String, dynamic>() : recepientStoreList[index * 2 + 1];

                  return Container(
                    width: deviceWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StoreConnectionWidget(
                          storeModel: data1.isNotEmpty &&
                                  data1["recepientStore"] != null &&
                                  _authProvider!.authState.storeModel!.id != data1["recepientStore"]["_id"]
                              ? StoreModel.fromJson(data1["recepientStore"])
                              : data1.isNotEmpty &&
                                      data1["requestedStore"] != null &&
                                      _authProvider!.authState.storeModel!.id != data1["requestedStore"]["_id"]
                                  ? StoreModel.fromJson(data1["requestedStore"])
                                  : null,
                          connectionModel: data1.isEmpty ? null : BusinessConnectionModel.fromJson(data1),
                          loadingStatus: data1.isEmpty,
                          margin: EdgeInsets.only(left: widthDp * 20, right: widthDp * 5, top: heightDp * 5, bottom: heightDp * 5),
                          callback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {},
                          tapHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) async {
                            _viewHandler(
                              storeModel: storeModel,
                              connectionModel: connectionModel,
                              index: index * 2,
                            );
                          },
                        ),
                        if ((_businessInvitationsProvider!.businessInvitationsPageState.progressState == 2 ||
                                _businessInvitationsProvider!.businessInvitationsPageState.progressState == 3) &&
                            data2.isEmpty)
                          SizedBox()
                        else
                          StoreConnectionWidget(
                            storeModel: data2.isNotEmpty &&
                                    data2["recepientStore"] != null &&
                                    _authProvider!.authState.storeModel!.id != data2["recepientStore"]["_id"]
                                ? StoreModel.fromJson(data2["recepientStore"])
                                : data2.isNotEmpty &&
                                        data2["requestedStore"] != null &&
                                        _authProvider!.authState.storeModel!.id != data2["requestedStore"]["_id"]
                                    ? StoreModel.fromJson(data2["requestedStore"])
                                    : null,
                            connectionModel: data2.isEmpty ? null : BusinessConnectionModel.fromJson(data2),
                            loadingStatus: data2.isEmpty,
                            margin: EdgeInsets.only(left: widthDp * 5, right: widthDp * 20, top: heightDp * 5, bottom: heightDp * 5),
                            callback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {},
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

  // void _invitationHandler({@required BusinessConnectionModel? connectionModel, @required StoreModel? storeModel, @required int? index}) {
  //   Map<String, dynamic> connectionData = connectionModel!.toJson();
  //   connectionData["requestedStore"] = storeModel!.toJson();

  //   for (var i = 0; i < _businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList![statusStr].length; i++) {
  //     if (_businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList![statusStr][i]["_id"] == connectionData["_id"]) {
  //       _businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList![statusStr][i] = connectionData;
  //       break;
  //     }
  //   }

  //   _businessInvitationsProvider!.setBusinessInvitationsState(
  //     _businessInvitationsProvider!.businessInvitationsPageState.update(
  //       requestedStoreList: _businessInvitationsProvider!.businessInvitationsPageState.requestedStoreList,
  //     ),
  //   );
  //   _onRefresh();
  // }

  void _viewHandler({@required StoreModel? storeModel, @required BusinessConnectionModel? connectionModel, @required int? index}) async {
    StoreConnectionDialog.show(
      context,
      storeModel: storeModel,
      connectionModel: connectionModel,
      invitationCallback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
        _businessInvitationsProvider!.update(connectionModel: connectionModel, storeModel: storeModel, statusStr: statusStr);
        _onRefresh();
      },
    );
  }
}
