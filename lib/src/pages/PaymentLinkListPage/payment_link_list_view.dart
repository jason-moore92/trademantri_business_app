import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/payment_link_widget.dart';
import 'package:trapp/src/models/store_model.dart';
import 'package:trapp/src/pages/GeneratePaymentLinkPage/index.dart';
import 'package:trapp/src/pages/NewCustomerForChatPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class PaymentLinkListView extends StatefulWidget {
  PaymentLinkListView({Key? key}) : super(key: key);

  @override
  _PaymentLinkListViewState createState() => _PaymentLinkListViewState();
}

class _PaymentLinkListViewState extends State<PaymentLinkListView> with SingleTickerProviderStateMixin {
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
  PaymentLinkProvider? _paymentLinkProvider;
  KeicyProgressDialog? _keicyProgressDialog;

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

    _paymentLinkProvider = PaymentLinkProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _paymentLinkProvider!.setPaymentLinkState(
      _paymentLinkProvider!.paymentLinkState.update(
        progressState: 0,
        paymentLinkListData: [],
        paymentLinkMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _paymentLinkProvider!.addListener(_paymentLinkProviderListener);

      _paymentLinkProvider!.setPaymentLinkState(_paymentLinkProvider!.paymentLinkState.update(progressState: 1));
      _paymentLinkProvider!.getNotificationData(
        storeId: _authProvider!.authState.storeModel!.id,
      );
    });
  }

  @override
  void dispose() {
    _paymentLinkProvider!.removeListener(_paymentLinkProviderListener);

    super.dispose();
  }

  void _paymentLinkProviderListener() async {
    if (_paymentLinkProvider!.paymentLinkState.progressState == -1) {
      if (_paymentLinkProvider!.paymentLinkState.isRefresh!) {
        _paymentLinkProvider!.setPaymentLinkState(
          _paymentLinkProvider!.paymentLinkState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_paymentLinkProvider!.paymentLinkState.progressState == 2) {
      if (_paymentLinkProvider!.paymentLinkState.isRefresh!) {
        _paymentLinkProvider!.setPaymentLinkState(
          _paymentLinkProvider!.paymentLinkState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic>? paymentLinkListData = _paymentLinkProvider!.paymentLinkState.paymentLinkListData;
    Map<String, dynamic>? paymentLinkMetaData = _paymentLinkProvider!.paymentLinkState.paymentLinkMetaData;

    paymentLinkListData = [];
    paymentLinkMetaData = Map<String, dynamic>();
    _paymentLinkProvider!.setPaymentLinkState(
      _paymentLinkProvider!.paymentLinkState.update(
        progressState: 1,
        paymentLinkListData: paymentLinkListData,
        paymentLinkMetaData: paymentLinkMetaData,
        isRefresh: true,
      ),
    );

    _paymentLinkProvider!.getNotificationData(
      storeId: _authProvider!.authState.storeModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _paymentLinkProvider!.setPaymentLinkState(
      _paymentLinkProvider!.paymentLinkState.update(progressState: 1),
    );
    _paymentLinkProvider!.getNotificationData(
      storeId: _authProvider!.authState.storeModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyPaymentLinkListHandler() {
    List<dynamic>? paymentLinkListData = _paymentLinkProvider!.paymentLinkState.paymentLinkListData;
    Map<String, dynamic>? paymentLinkMetaData = _paymentLinkProvider!.paymentLinkState.paymentLinkMetaData;

    paymentLinkListData = [];
    paymentLinkMetaData = Map<String, dynamic>();
    _paymentLinkProvider!.setPaymentLinkState(
      _paymentLinkProvider!.paymentLinkState.update(
        progressState: 1,
        paymentLinkListData: paymentLinkListData,
        paymentLinkMetaData: paymentLinkMetaData,
      ),
    );

    _paymentLinkProvider!.getNotificationData(
      storeId: _authProvider!.authState.storeModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Payment Links",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<PaymentLinkProvider>(builder: (context, paymentLinkProvider, _) {
        if (paymentLinkProvider.paymentLinkState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Create payment links and send payments to customers to do your business at ease.",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: widthDp * 5),
                    KeicyRaisedButton(
                      width: widthDp * 140,
                      height: heightDp * 35,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 6,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                      child: Text(
                        "+ New Payment",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      ),
                      onPressed: () async {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => NewCustomerForChatPage(),
                          ),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => GeneratePaymentLinkPage(
                              customerData: result,
                              storeModel: AuthProvider.of(context).authState.storeModel,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightDp * 10),
              _searchField(),
              SizedBox(height: heightDp * 10),
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
        hintText: PaymentLinkListPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyPaymentLinkListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyPaymentLinkListHandler();
        },
      ),
    );
  }

  Widget _notificationListPanel() {
    List<dynamic> notificationList = [];
    Map<String, dynamic> paymentLinkMetaData = Map<String, dynamic>();

    if (_paymentLinkProvider!.paymentLinkState.paymentLinkListData != null) {
      notificationList = _paymentLinkProvider!.paymentLinkState.paymentLinkListData!;
    }
    if (_paymentLinkProvider!.paymentLinkState.paymentLinkMetaData != null) {
      paymentLinkMetaData = _paymentLinkProvider!.paymentLinkState.paymentLinkMetaData!;
    }

    int itemCount = 0;

    if (_paymentLinkProvider!.paymentLinkState.paymentLinkListData != null) {
      itemCount += _paymentLinkProvider!.paymentLinkState.paymentLinkListData!.length;
    }

    if (_paymentLinkProvider!.paymentLinkState.progressState == 1) {
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
              enablePullUp: (paymentLinkMetaData["nextPage"] != null && _paymentLinkProvider!.paymentLinkState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No PaymentLink Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> paymentLinkData = (index >= notificationList.length) ? Map<String, dynamic>() : notificationList[index];

                        return PaymentLinkWidget(
                          paymentLinkData: paymentLinkData,
                          isLoading: paymentLinkData.isEmpty,
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
