import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/wallet_info_dialog.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
// import 'package:trapp/src/elements/wallet_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/transaction_details.dart';
import 'package:trapp/src/pages/transaction_item.dart';
import 'package:trapp/src/pages/withdrawal.dart';
// import 'package:trapp/src/pages/WalletDetailNewPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class WalletView extends StatefulWidget {
  final bool haveAppBar;

  WalletView({Key? key, this.haveAppBar = false}) : super(key: key);

  @override
  _WalletViewState createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> with SingleTickerProviderStateMixin {
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

  WalletProvider? _walletProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  List<RefreshController> _refreshControllerList = [];

  TabController? _tabController;
  ScrollController? _controller;

  TextEditingController _textController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int _oldTabIndex = 0;

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

    _walletProvider = WalletProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _controller = ScrollController();

    _refreshControllerList = [];
    for (var i = 0; i < AppConfig.transactionStatusData.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    _oldTabIndex = 1;

    _tabController = TabController(length: AppConfig.transactionStatusData.length, vsync: this, initialIndex: _oldTabIndex);

    _tabController!.addListener(_tabControllerListener);

    _walletProvider!.setWalletState(
      _walletProvider!.walletState.update(
        transactionsListData: Map<String, List<WalletTransaction>>(),
        transactionsMetaData: Map<String, dynamic>(),
        progressState: 0,
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _walletProvider!.addListener(_walletProviderListener);

      _walletProvider!.setWalletState(_walletProvider!.walletState.update(progressState: 1));
      _walletProvider!.getTransactions(
        storeId: AuthProvider.of(context).authState.storeModel!.id,
        status: AppConfig.transactionStatusData[0]["id"],
      );
      _walletProvider!.getAccount(
        storeId: AuthProvider.of(context).authState.storeModel!.id,
      );
    });
  }

  @override
  void dispose() {
    _walletProvider!.removeListener(_walletProviderListener);

    super.dispose();
  }

  void _walletProviderListener() async {
    if (_walletProvider!.walletState.progressState == -1) {
      if (_walletProvider!.walletState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _walletProvider!.setWalletState(
          _walletProvider!.walletState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_walletProvider!.walletState.progressState == 2) {
      if (_walletProvider!.walletState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _walletProvider!.setWalletState(
          _walletProvider!.walletState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _tabControllerListener() {
    if ((_walletProvider!.walletState.progressState != 1) &&
        (_textController.text.isNotEmpty ||
            _walletProvider!.walletState.transactionsListData![AppConfig.transactionStatusData[_tabController!.index]["id"]] == null ||
            _walletProvider!.walletState.transactionsListData![AppConfig.transactionStatusData[_tabController!.index]["id"]]!.isEmpty)) {
      Map<String, List<WalletTransaction>>? transactionsListData = _walletProvider!.walletState.transactionsListData;
      Map<String, dynamic>? transactionsMetaData = _walletProvider!.walletState.transactionsMetaData;

      if (_oldTabIndex != _tabController!.index && _textController.text.isNotEmpty) {
        transactionsListData![AppConfig.transactionStatusData[_oldTabIndex]["id"]] = [];
        transactionsMetaData![AppConfig.transactionStatusData[_oldTabIndex]["id"]] = Map<String, dynamic>();
      }

      _walletProvider!.setWalletState(
        _walletProvider!.walletState.update(
          progressState: 1,
          transactionsListData: transactionsListData,
          transactionsMetaData: transactionsMetaData,
        ),
        isNotifiable: false,
      );

      _textController.clear();
      _oldTabIndex = _tabController!.index;

      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _walletProvider!.getTransactions(
          storeId: AuthProvider.of(context).authState.storeModel!.id,
          status: AppConfig.transactionStatusData[_tabController!.index]["id"],
          narration: _textController.text.trim(),
        );
      });
    } else {
      _oldTabIndex = _tabController!.index;
      setState(() {});
    }
  }

  void _onRefresh() async {
    Map<String, List<WalletTransaction>>? transactionsListData = _walletProvider!.walletState.transactionsListData;
    Map<String, dynamic>? transactionsMetaData = _walletProvider!.walletState.transactionsMetaData;

    transactionsListData![AppConfig.transactionStatusData[_tabController!.index]["id"]] = [];
    transactionsMetaData![AppConfig.transactionStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _walletProvider!.setWalletState(
      _walletProvider!.walletState.update(
        progressState: 1,
        transactionsListData: transactionsListData,
        transactionsMetaData: transactionsMetaData,
        isRefresh: true,
      ),
    );

    _walletProvider!.getTransactions(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.transactionStatusData[_tabController!.index]["id"],
      narration: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _walletProvider!.setWalletState(
      _walletProvider!.walletState.update(progressState: 1),
    );
    _walletProvider!.getTransactions(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.transactionStatusData[_tabController!.index]["id"],
      narration: _textController.text.trim(),
    );
  }

  void _searchKeyWalletHandler() {
    Map<String, List<WalletTransaction>>? transactionsListData = _walletProvider!.walletState.transactionsListData;
    Map<String, dynamic>? transactionsMetaData = _walletProvider!.walletState.transactionsMetaData;

    transactionsListData![AppConfig.transactionStatusData[_tabController!.index]["id"]] = [];
    transactionsMetaData![AppConfig.transactionStatusData[_tabController!.index]["id"]] = Map<String, dynamic>();
    _walletProvider!.setWalletState(
      _walletProvider!.walletState.update(
        progressState: 1,
        transactionsListData: transactionsListData,
        transactionsMetaData: transactionsMetaData,
      ),
    );

    _walletProvider!.getTransactions(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      status: AppConfig.transactionStatusData[_tabController!.index]["id"],
      narration: _textController.text.trim(),
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
                "Wallet",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    // Fluttertoast.showToast(msg: "Manual withdraw is not supported for now.");
                    _goToWithdrawal();
                  },
                  icon: Icon(Icons.save_alt),
                ),
                IconButton(
                  onPressed: () {
                    WalletInfoDialog.show(
                      context,
                      widthDp: widthDp,
                      heightDp: heightDp,
                      fontSp: fontSp,
                    );
                  },
                  icon: Icon(Icons.info_outline),
                )
              ],
            ),
      body: Consumer<WalletProvider>(builder: (context, walletProvider, _) {
        if (walletProvider.walletState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return DefaultTabController(
          length: AppConfig.transactionStatusData.length,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                _accountPanel(),
                _searchField(),
                _tabBar(),
                Expanded(child: _walletListPanel()),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _accountPanel() {
    WalletAccount? account = _walletProvider!.walletState.accountData;

    if (account == null && account!.id == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        direction: ShimmerDirection.ltr,
        period: Duration(milliseconds: 1000),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              child: Text(
                "Balance",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ),
            SizedBox(height: heightDp * 10),
            Container(
              color: Colors.white,
              child: Text(
                "₹ 00.00",
                style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 3, bottom: heightDp * 17),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(heightDp * 10),
          color: Colors.white,
        ),
        height: deviceHeight * 0.15,
        width: deviceWidth * 0.9,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Unsettled",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightDp * 10),
                  Text(
                    "₹ ${account.unSettledBalance.toString()}",
                    style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Settled",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightDp * 10),
                  Text(
                    "₹ ${account.settledBalance.toString()}",
                    style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: heightDp * 10),
                  Text(
                    "₹ ${account.balance.toString()}",
                    style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
      child: KeicyTextFormField(
        controller: _textController,
        focusNode: _focusNode,
        width: null,
        height: heightDp * 50,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: heightDp * 6,
        contentHorizontalPadding: widthDp * 10,
        contentVerticalPadding: heightDp * 8,
        textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
        hintText: WalletPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _textController.clear();
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyWalletHandler();
        },
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
        isScrollable: true,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        indicatorWeight: 1,
        labelPadding: EdgeInsets.symmetric(horizontal: widthDp * 5),
        labelStyle: TextStyle(fontSize: fontSp * 14),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: List.generate(AppConfig.transactionStatusData.length, (index) {
          // if (index == 0) return SizedBox();
          return Tab(
            child: Container(
              width: widthDp * 120,
              height: heightDp * 35,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _tabController!.index == index ? config.Colors().mainColor(1) : Colors.white,
                borderRadius: BorderRadius.circular(heightDp * 30),
              ),
              child: Text(
                "${AppConfig.transactionStatusData[index]["name"]}",
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _walletListPanel() {
    String status = AppConfig.transactionStatusData[_tabController!.index]["id"];

    List<WalletTransaction> walletList = [];
    Map<String, dynamic> transactionsMetaData = Map<String, dynamic>();

    if (_walletProvider!.walletState.transactionsListData![status] != null) {
      walletList = _walletProvider!.walletState.transactionsListData![status] ?? [];
    }
    if (_walletProvider!.walletState.transactionsMetaData![status] != null) {
      transactionsMetaData = _walletProvider!.walletState.transactionsMetaData![status];
    }

    int itemCount = 0;

    if (_walletProvider!.walletState.transactionsListData![status] != null) {
      int length = _walletProvider!.walletState.transactionsListData![status]!.length;
      itemCount += length;
    }

    if (_walletProvider!.walletState.progressState == 1) {
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
              enablePullUp: (transactionsMetaData["nextPage"] != null && _walletProvider!.walletState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshControllerList[_tabController!.index],
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No transactions available.",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.separated(
                      controller: _controller,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        WalletTransaction transaction = (index >= walletList.length) ? WalletTransaction() : walletList[index];

                        return TransactionItem(
                          transaction: transaction,
                          detailCallback: () {
                            _detailCallback(
                              transaction: transaction,
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _detailCallback({@required WalletTransaction? transaction}) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => TransactionDetails(
          transaction: transaction,
        ),
      ),
    );
    if (result != null) {}
  }

  void _goToWithdrawal() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Withdraw(),
      ),
    );
    if (result != null) {}
  }
}
