import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/delivery_partner_widget.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class DeliveryPartnerListView extends StatefulWidget {
  final bool haveAppBar;

  DeliveryPartnerListView({Key? key, this.haveAppBar = true}) : super(key: key);

  @override
  _DeliveryPartnerListViewState createState() => _DeliveryPartnerListViewState();
}

class _DeliveryPartnerListViewState extends State<DeliveryPartnerListView> with SingleTickerProviderStateMixin {
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
  DeliveryPartnerProvider? _deliveryPartnerProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String status = "ALL";

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

    _deliveryPartnerProvider = DeliveryPartnerProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    // _deliveryPartnerProvider!.setDeliveryPartnerState(
    //   _deliveryPartnerProvider!.deliveryPartnerState.update(
    //     progressState: 0,
    //     deliveryPartnerListData: [],
    //     deliveryPartnerMetaData: Map<String, dynamic>(),
    //   ),
    //   isNotifiable: false,
    // );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _deliveryPartnerProvider!.addListener(_deliveryPartnerProviderListener);
      if (_deliveryPartnerProvider!.deliveryPartnerState.progressState != 2) {
        _deliveryPartnerProvider!.setDeliveryPartnerState(_deliveryPartnerProvider!.deliveryPartnerState.update(progressState: 1));
        _deliveryPartnerProvider!.getDeliveryPartnerListData(
          zipCode: _authProvider!.authState.storeModel!.zipCode,
        );
      }
    });
  }

  @override
  void dispose() {
    _deliveryPartnerProvider!.removeListener(_deliveryPartnerProviderListener);

    super.dispose();
  }

  void _deliveryPartnerProviderListener() async {
    if (_deliveryPartnerProvider!.deliveryPartnerState.progressState == -1) {
      if (_deliveryPartnerProvider!.deliveryPartnerState.isRefresh!) {
        _deliveryPartnerProvider!.setDeliveryPartnerState(
          _deliveryPartnerProvider!.deliveryPartnerState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_deliveryPartnerProvider!.deliveryPartnerState.progressState == 2) {
      if (_deliveryPartnerProvider!.deliveryPartnerState.isRefresh!) {
        _deliveryPartnerProvider!.setDeliveryPartnerState(
          _deliveryPartnerProvider!.deliveryPartnerState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic>? deliveryPartnerListData = _deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerListData;
    Map<String, dynamic>? deliveryPartnerMetaData = _deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerMetaData;

    deliveryPartnerListData = [];
    deliveryPartnerMetaData = Map<String, dynamic>();
    _deliveryPartnerProvider!.setDeliveryPartnerState(
      _deliveryPartnerProvider!.deliveryPartnerState.update(
        progressState: 1,
        deliveryPartnerListData: deliveryPartnerListData,
        deliveryPartnerMetaData: deliveryPartnerMetaData,
        isRefresh: true,
      ),
    );
    _deliveryPartnerProvider!.getDeliveryPartnerListData(
      zipCode: _authProvider!.authState.storeModel!.zipCode,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _deliveryPartnerProvider!.setDeliveryPartnerState(
      _deliveryPartnerProvider!.deliveryPartnerState.update(progressState: 1),
    );
    _deliveryPartnerProvider!.getDeliveryPartnerListData(
      zipCode: _authProvider!.authState.storeModel!.zipCode,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyDeliveryPartnerListHandler() {
    List<dynamic>? deliveryPartnerListData = _deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerListData;
    Map<String, dynamic>? deliveryPartnerMetaData = _deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerMetaData;

    deliveryPartnerListData = [];
    deliveryPartnerMetaData = Map<String, dynamic>();
    _deliveryPartnerProvider!.setDeliveryPartnerState(
      _deliveryPartnerProvider!.deliveryPartnerState.update(
        progressState: 1,
        deliveryPartnerListData: deliveryPartnerListData,
        deliveryPartnerMetaData: deliveryPartnerMetaData,
      ),
    );

    _deliveryPartnerProvider!.getDeliveryPartnerListData(
      zipCode: _authProvider!.authState.storeModel!.zipCode,
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !widget.haveAppBar
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                "Delivery Partners",
                style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
              ),
              elevation: 0,
            ),
      body: Consumer<DeliveryPartnerProvider>(builder: (context, deliveryPartnerProvider, _) {
        if (deliveryPartnerProvider.deliveryPartnerState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _searchField(),
              Expanded(child: _notificationListPanel()),
            ],
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
        textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.6)),
        hintText: DeliveryPartnerListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyDeliveryPartnerListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyDeliveryPartnerListHandler();
        },
      ),
    );
  }

  Widget _notificationListPanel() {
    List<dynamic> notificationList = [];
    Map<String, dynamic> deliveryPartnerMetaData = Map<String, dynamic>();

    if (_deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerListData != null) {
      notificationList = _deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerListData!;
    }
    if (_deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerMetaData != null) {
      deliveryPartnerMetaData = _deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerMetaData!;
    }

    int itemCount = 0;

    if (_deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerListData != null) {
      itemCount += _deliveryPartnerProvider!.deliveryPartnerState.deliveryPartnerListData!.length;
    }

    if (_deliveryPartnerProvider!.deliveryPartnerState.progressState == 1) {
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
              enablePullUp: (deliveryPartnerMetaData["nextPage"] != null && _deliveryPartnerProvider!.deliveryPartnerState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Delivery Partner Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> deliveryPartnerData =
                            (index >= notificationList.length) ? Map<String, dynamic>() : notificationList[index];

                        return DeliveryPartnerWidget(
                          deliveryPartnerData: deliveryPartnerData,
                          isLoading: deliveryPartnerData.isEmpty,
                          tapHandler: () {
                            Navigator.of(context).pop(deliveryPartnerData);
                          },
                        );
                      },
                      // separatorBuilder: (context, index) {
                      //   return Divider(color: Colors.grey.withOpacity(0.3), height: 5, thickness: 5);
                      // },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
