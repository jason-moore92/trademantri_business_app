import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/store_connection_widget.dart';
import 'package:trapp/src/elements/store_invitation_widget.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/BusinessConnectionsPage/index.dart';
import 'package:trapp/src/pages/BusinessInvitationsPage/index.dart';
import 'package:trapp/src/pages/BusinessNetworkPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class BusinessDashboardView extends StatefulWidget {
  BusinessDashboardView({Key? key}) : super(key: key);

  @override
  _BusinessDashboardViewState createState() => _BusinessDashboardViewState();
}

class _BusinessDashboardViewState extends State<BusinessDashboardView> with SingleTickerProviderStateMixin {
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
  BusinessInvitationsProvider? _businessInvitationsProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  GlobalKey<AnimatedFloatingActionButtonState> _floatingButtonKey = GlobalKey<AnimatedFloatingActionButtonState>();

  RefreshController? _refreshController = RefreshController(initialRefresh: false);

  List<dynamic>? _requestedStoreList;

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
    _businessStoresProvider = BusinessStoresProvider.of(context);
    _businessInvitationsProvider = BusinessInvitationsProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _businessStoresProvider!.setBusinessStoresState(
      BusinessStoresState.init(),
      isNotifiable: false,
    );

    _businessInvitationsProvider!.setBusinessInvitationsState(
      BusinessInvitationsState.init(),
      isNotifiable: false,
    );

    statusStr = [ConnectionStatus.pending].join('_');

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _businessStoresProvider!.addListener(_businessStoresProviderListener);

      _businessStoresProvider!.setBusinessStoresState(
        _businessStoresProvider!.businessStoresState.update(
          progressState: 1,
        ),
      );

      _businessStoresProvider!.getStoreList(
        storeId: _authProvider!.authState.storeModel!.id,
        status: ConnectionStatus.active,
      );

      _businessInvitationsProvider!.requestedStores(
        recepientId: _authProvider!.authState.storeModel!.id,
        status: [ConnectionStatus.pending],
      );
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
    Map<String, dynamic>? storeList = _businessStoresProvider!.businessStoresState.storeList;
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
      status: ConnectionStatus.active,
    );
  }

  void _onLoading() async {
    _businessStoresProvider!.setBusinessStoresState(
      _businessStoresProvider!.businessStoresState.update(progressState: 1),
    );
    _businessStoresProvider!.getStoreList(
      storeId: _authProvider!.authState.storeModel!.id,
      status: ConnectionStatus.active,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Connections",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer2<BusinessInvitationsProvider, BusinessStoresProvider>(builder: (
        context,
        businessInvitationsProvider,
        businessStoresProvider,
        _,
      ) {
        _requestedStoreList = [];
        if (businessInvitationsProvider.businessInvitationsPageState.requestedStoreList![statusStr] != null) {
          for (var i = 0; i < businessInvitationsProvider.businessInvitationsPageState.requestedStoreList![statusStr]!.length; i++) {
            if (businessInvitationsProvider.businessInvitationsPageState.requestedStoreList![statusStr][i]["status"] == ConnectionStatus.pending) {
              _requestedStoreList!.add(businessInvitationsProvider.businessInvitationsPageState.requestedStoreList![statusStr][i]);
            }
          }
        }

        Map<String, dynamic>? requestedStoreListData = businessInvitationsProvider.businessInvitationsPageState.requestedStoreList;
        requestedStoreListData![statusStr] = _requestedStoreList;

        businessInvitationsProvider.setBusinessInvitationsState(
          businessInvitationsProvider.businessInvitationsPageState.update(
            requestedStoreList: requestedStoreListData,
          ),
          isNotifiable: false,
        );

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
              businessStoresProvider.getStoreList(
                storeId: _authProvider!.authState.storeModel!.id,
                status: ConnectionStatus.active,
              );
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
                Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 2, height: heightDp * 2),
                _mangeNetworkPanel(),

                ///
                Column(
                  children: [
                    Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 2, height: heightDp * 2),
                    _invitationPanel(),
                  ],
                ),

                ///
                Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 2, height: heightDp * 2),
                _connectionPanel(),

                ///
                Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 2, height: heightDp * 2),
                SizedBox(height: heightDp * 10),
                Center(
                  child: Text(
                    "Connected Businesses",
                    style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: heightDp * 10),
                Expanded(
                  child: _connectedBusinessPanel(),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: _floatingButton(),
    );
  }

  Widget _floatingButton() {
    return AnimatedFloatingActionButton(
      key: _floatingButtonKey,
      fabButtons: [
        Row(
          children: [
            Card(
              elevation: 7,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(heightDp * 4),
                ),
                child: Text(
                  "Connect Store",
                  style: TextStyle(fontSize: fontSp * 14),
                ),
              ),
            ),
            SizedBox(width: widthDp * 10),
            FloatingActionButton(
              onPressed: () async {
                _floatingButtonKey.currentState?.closeFABs();
                _businessStoresProvider!.removeListener(_businessStoresProviderListener);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => BusinessConectionsPage(),
                  ),
                );
                _businessStoresProvider!.addListener(_businessStoresProviderListener);
              },
              heroTag: "Connect Store",
              child: Icon(Icons.storefront_outlined, size: heightDp * 25, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Card(
              elevation: 7,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(heightDp * 4),
                ),
                child: Text(
                  "Scan QR Code",
                  style: TextStyle(fontSize: fontSp * 14),
                ),
              ),
            ),
            SizedBox(width: widthDp * 10),
            FloatingActionButton(
              onPressed: () {
                _floatingButtonKey.currentState?.closeFABs();
                _qrCodeScan();
              },
              heroTag: "Scan QR Code",
              child: Icon(
                Icons.qr_code_2_outlined,
                size: heightDp * 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
      colorStartAnimation: config.Colors().mainColor(1),
      colorEndAnimation: config.Colors().mainColor(1),
      animatedIconData: AnimatedIcons.menu_close,
    );
  }

  void _qrCodeScan() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      var newStatus = await Permission.camera.request();
      if (!newStatus.isGranted) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "Your camera permission isn't granted",
          isTryButton: false,
          callBack: () {
            Navigator.of(context).pop();
          },
        );
        return;
      }
    }
    NormalDialog.show(
      context,
      content: "Scan Order QR-code/Bargain QR-code/Reverse auction QR-code to open the details",
      callback: () async {
        var result = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
        if (result == "-1") return;
        String qrCodeString = Encrypt.decryptString(result);

        if (qrCodeString.contains("http")) {
          String str = Uri.decodeFull(qrCodeString);
          if (str.contains("store?id=")) {
            if (Uri.decodeFull(qrCodeString).split("store?id=").last != AuthProvider.of(context).authState.storeModel!.id) {
              ErrorDialog.show(
                context,
                widthDp: widthDp,
                heightDp: heightDp,
                fontSp: fontSp,
                text: "This is your store Qr code.",
              );
            } else {
              _getStoreInfoHandler(Uri.decodeFull(qrCodeString).split("store?id=").last);
            }
          }
          return;
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "This qr code is invalid. Please try again",
            callBack: () {
              _qrCodeScan();
            },
            isTryButton: true,
          );
        }
      },
    );
  }

  void _getStoreInfoHandler(String storeId) async {
    // storeId = "5f9a559665e766002360d070";
    await _keicyProgressDialog!.show();
    var result = await BusinessConnectionsApiProvider.getConnection(
      recepientId: storeId,
      requestedId: AuthProvider.of(context).authState.storeModel!.id,
    );

    if (!result["success"]) {
      await _keicyProgressDialog!.hide();
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
      );
    }
    BusinessConnectionModel? connectionModel;
    if (result["data"] != null) connectionModel = BusinessConnectionModel.fromJson(result["data"]);

    result = await StoreApiProvider.getStoreData(id: storeId);

    if (!result["success"]) {
      await _keicyProgressDialog!.hide();
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
      );
    }

    StoreModel storeModel = StoreModel.fromJson(result["data"]['store']);
    await _keicyProgressDialog!.hide();

    result = await StoreConnectionDialog.show(
      context,
      storeModel: storeModel,
      connectionModel: connectionModel,
      invitationCallback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
        _businessInvitationsProvider!.update(connectionModel: connectionModel, storeModel: storeModel, statusStr: statusStr);
      },
      connectionHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
        BusinessConnectionsProvider.of(context).updateHandler(storeModel: storeModel, connectionModel: connectionModel);
      },
    );
  }

  Widget _mangeNetworkPanel() {
    return GestureDetector(
      onTap: () async {
        _businessStoresProvider!.removeListener(_businessStoresProviderListener);
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => BusinessNetworkPage(),
          ),
        );
        _businessStoresProvider!.addListener(_businessStoresProviderListener);
      },
      child: Container(
        color: Colors.transparent,
        height: heightDp * 55,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Manage My Network",
              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Container(
              color: Colors.transparent,
              child: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _invitationPanel() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            _businessStoresProvider!.removeListener(_businessStoresProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => BusinessInvitationsPage(
                  status: [ConnectionStatus.pending],
                ),
              ),
            );
            _businessStoresProvider!.addListener(_businessStoresProviderListener);
          },
          child: Container(
            color: Colors.transparent,
            height: heightDp * 55,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Invitations",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
              ],
            ),
          ),
        ),
        if (_requestedStoreList!.isNotEmpty) Divider(color: Colors.grey.withOpacity(0.6), thickness: 1, height: 1),
        if (_requestedStoreList!.isNotEmpty)
          Column(
            children: List.generate(_requestedStoreList!.length > 2 ? 2 : _requestedStoreList!.length, (index) {
              StoreModel storeModel = StoreModel.fromJson(_requestedStoreList![index]["requestedStore"]);
              BusinessConnectionModel? connectionModel = BusinessConnectionModel.fromJson(_requestedStoreList![index]);

              return Column(
                children: [
                  StoreInvitationWidget(
                    storeModel: storeModel,
                    connectionModel: connectionModel,
                    loadingStatus: false,
                    invitationCallback: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {
                      _businessInvitationsProvider!.update(connectionModel: connectionModel, storeModel: storeModel, statusStr: statusStr);
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
            }),
          ),
        if (_requestedStoreList!.length > 2)
          GestureDetector(
            onTap: () async {
              _businessStoresProvider!.removeListener(_businessStoresProviderListener);
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BusinessInvitationsPage(
                    status: [ConnectionStatus.pending],
                  ),
                ),
              );
              _businessStoresProvider!.addListener(_businessStoresProviderListener);
            },
            child: Container(
              padding: EdgeInsets.all(heightDp * 15),
              color: Colors.transparent,
              child: Text(
                "Show More",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.blue, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  Widget _connectionPanel() {
    return Container(
      width: deviceWidth,
      height: heightDp * 55,
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Search/Connect With Stores",
            style: TextStyle(fontSize: fontSp * 16, fontWeight: FontWeight.w600),
          ),
          KeicyRaisedButton(
            width: widthDp * 100,
            height: heightDp * 35,
            color: config.Colors().mainColor(1),
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
            borderRadius: heightDp * 6,
            child: Text(
              "Connect",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
            ),
            onPressed: () async {
              _businessStoresProvider!.removeListener(_businessStoresProviderListener);
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BusinessConectionsPage(),
                ),
              );
              _businessStoresProvider!.addListener(_businessStoresProviderListener);
            },
          ),
        ],
      ),
    );
  }

  Widget _connectedBusinessPanel() {
    if (_businessStoresProvider!.businessStoresState.progressState == 0) {
      return Center(child: CupertinoActivityIndicator());
    }
    List<dynamic> storeList = [];
    Map<String, dynamic> storeMetaData = Map<String, dynamic>();

    if (_businessStoresProvider!.businessStoresState.storeList![ConnectionStatus.active] != null) {
      storeList = _businessStoresProvider!.businessStoresState.storeList![ConnectionStatus.active];
    }
    if (_businessStoresProvider!.businessStoresState.storeMetaData != null) {
      storeMetaData = _businessStoresProvider!.businessStoresState.storeMetaData!;
    }

    int itemCount = 0;

    if (_businessStoresProvider!.businessStoresState.storeList![ConnectionStatus.active] != null) {
      int length = _businessStoresProvider!.businessStoresState.storeList![ConnectionStatus.active].length;
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
                                  _viewHandler(
                                    storeModel: storeModel,
                                    connectionModel: connectionModel,
                                    index: index * 2,
                                  );
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

  // void _invitationHandler({@required BusinessConnectionModel? connectionModel, @required StoreModel? storeModel}) {
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
      StoreConnectionDialog.show(
        context,
        storeModel: storeModel,
        connectionModel: connectionModel,
        connectionHandler: (StoreModel? storeModel, BusinessConnectionModel? connectionModel) {},
      );
    }
  }
}
