import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/dialogs/settlement_info_dialog.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/settlement_details.dart';
import 'package:trapp/src/pages/settlement_item.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class SettlementsView extends StatefulWidget {
  final bool haveAppBar;

  SettlementsView({Key? key, this.haveAppBar = false}) : super(key: key);

  @override
  _SettlementsViewState createState() => _SettlementsViewState();
}

class _SettlementsViewState extends State<SettlementsView> with SingleTickerProviderStateMixin {
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

  SettlementProvider? _settlementProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  RefreshController? _refreshController;

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

    _settlementProvider = SettlementProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _controller = ScrollController();

    _refreshController = RefreshController(initialRefresh: false);

    _settlementProvider!.setSettlementState(
      _settlementProvider!.settlementState.update(
        settlementsListData: <Settlement>[],
        settlementsMetaData: Map<String, dynamic>(),
        progressState: 0,
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _settlementProvider!.addListener(_settlementProviderListener);

      _settlementProvider!.setSettlementState(_settlementProvider!.settlementState.update(progressState: 1));
      _settlementProvider!.getSettlements(
        storeId: AuthProvider.of(context).authState.storeModel!.id,
        // status: AppConfig.settlementStatusData[0]["id"],
      );
    });
  }

  @override
  void dispose() {
    _settlementProvider!.removeListener(_settlementProviderListener);

    super.dispose();
  }

  void _settlementProviderListener() async {
    if (_settlementProvider!.settlementState.progressState == -1) {
      if (_settlementProvider!.settlementState.isRefresh!) {
        _refreshController!.refreshFailed();
        _settlementProvider!.setSettlementState(
          _settlementProvider!.settlementState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_settlementProvider!.settlementState.progressState == 2) {
      if (_settlementProvider!.settlementState.isRefresh!) {
        _refreshController!.refreshCompleted();
        _settlementProvider!.setSettlementState(
          _settlementProvider!.settlementState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<Settlement>? settlementsListData = _settlementProvider!.settlementState.settlementsListData;
    Map<String, dynamic>? settlementsMetaData = _settlementProvider!.settlementState.settlementsMetaData;

    settlementsListData = [];
    settlementsMetaData = Map<String, dynamic>();
    _settlementProvider!.setSettlementState(
      _settlementProvider!.settlementState.update(
        progressState: 1,
        settlementsListData: settlementsListData,
        settlementsMetaData: settlementsMetaData,
        isRefresh: true,
      ),
    );

    _settlementProvider!.getSettlements(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      // status: AppConfig.settlementStatusData[_tabController!.index]["id"],
      // narration: _textController.text.trim(),
    );
  }

  void _onLoading() async {
    _settlementProvider!.setSettlementState(
      _settlementProvider!.settlementState.update(progressState: 1),
    );
    _settlementProvider!.getSettlements(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      // status: AppConfig.settlementStatusData[_tabController!.index]["id"],
      // narration: _textController.text.trim(),
    );
  }

  void _searchKeySettlementsHandler() {
    List<Settlement>? settlementsListData = _settlementProvider!.settlementState.settlementsListData;
    Map<String, dynamic>? settlementsMetaData = _settlementProvider!.settlementState.settlementsMetaData;

    settlementsListData = [];
    settlementsMetaData = Map<String, dynamic>();
    _settlementProvider!.setSettlementState(
      _settlementProvider!.settlementState.update(
        progressState: 1,
        settlementsListData: settlementsListData,
        settlementsMetaData: settlementsMetaData,
      ),
    );

    _settlementProvider!.getSettlements(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      // status: AppConfig.settlementStatusData[_tabController!.index]["id"],
      // narration: _textController.text.trim(),
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
                "Settlements",
                style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
              ),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    SettlementInfoDialog.show(
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
      body: Consumer<SettlementProvider>(builder: (context, settlementsProvider, _) {
        if (settlementsProvider.settlementState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              _searchField(),
              Expanded(child: _settlementsListPanel()),
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
        hintText: SettlementsPageString.searchHint,
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
          _searchKeySettlementsHandler();
        },
      ),
    );
  }

  Widget _settlementsListPanel() {
    List<Settlement> settlementsList = [];
    Map<String, dynamic> settlementsMetaData = Map<String, dynamic>();

    if (_settlementProvider!.settlementState.settlementsListData != null) {
      settlementsList = _settlementProvider!.settlementState.settlementsListData ?? [];
    }
    if (_settlementProvider!.settlementState.settlementsMetaData != null) {
      settlementsMetaData = _settlementProvider!.settlementState.settlementsMetaData ?? {};
    }

    int itemCount = 0;

    if (_settlementProvider!.settlementState.settlementsListData != null) {
      int length = _settlementProvider!.settlementState.settlementsListData!.length;
      itemCount += length;
    }

    if (_settlementProvider!.settlementState.progressState == 1) {
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
              enablePullUp: (settlementsMetaData["nextPage"] != null && _settlementProvider!.settlementState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No settlements available.",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.separated(
                      controller: _controller,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Settlement settlement = (index >= settlementsList.length) ? Settlement() : settlementsList[index];

                        return SettlementItem(
                          settlement: settlement,
                          detailCallback: () {
                            _detailCallback(
                              settlement: settlement,
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

  void _detailCallback({@required Settlement? settlement}) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => SettlementDetails(
          settlement: settlement,
        ),
      ),
    );
    if (result != null) {}
  }
}
