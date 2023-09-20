import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/announcement_widget.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/AnnouncementDetailPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/error_page.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'index.dart';

class AnnouncementListView extends StatefulWidget {
  final StoreModel? storeModel;
  final bool? isForBusiness;

  AnnouncementListView({Key? key, this.storeModel, this.isForBusiness}) : super(key: key);

  @override
  _AnnouncementListViewState createState() => _AnnouncementListViewState();
}

class _AnnouncementListViewState extends State<AnnouncementListView> with SingleTickerProviderStateMixin {
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

  AnnouncementListProvider? _announcementListProvider;

  List<RefreshController> _refreshControllerList = [];

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

    _announcementListProvider = AnnouncementListProvider.of(context);

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshControllerList = [];

    _oldTabIndex = widget.isForBusiness! ? 1 : 0;

    _announcementListProvider!.setAnnouncementListState(
      _announcementListProvider!.announcementState.update(
        progressState: 0,
        announcementListData: Map<String, dynamic>(),
        announcementMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    _tabController = TabController(
      initialIndex: widget.isForBusiness! ? 1 : 0,
      length: AppConfig.announcementTo.length,
      vsync: this,
    );

    for (var i = 0; i < AppConfig.announcementTo.length; i++) {
      _refreshControllerList.add(RefreshController(initialRefresh: false));
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _announcementListProvider!.addListener(_announcementListProviderListener);
      _tabController!.addListener(_tabControllerListener);

      _announcementListProvider!.setAnnouncementListState(
        _announcementListProvider!.announcementState.update(progressState: 1),
      );

      _announcementListProvider!.getAnnouncementListData(
        storeId: widget.storeModel!.id,
        announcementto: AppConfig.announcementTo[_oldTabIndex]["value"],
        searchKey: _controller.text.trim(),
      );
    });
  }

  void _tabControllerListener() {
    if ((_announcementListProvider!.announcementState.progressState != 1) &&
        (_controller.text.isNotEmpty ||
            _announcementListProvider!.announcementState.announcementListData![AppConfig.announcementTo[_tabController!.index]["value"]] == null ||
            _announcementListProvider!.announcementState.announcementListData![AppConfig.announcementTo[_tabController!.index]["value"]].isEmpty)) {
      Map<String, dynamic>? announcementListData = _announcementListProvider!.announcementState.announcementListData;
      Map<String, dynamic>? announcementMetaData = _announcementListProvider!.announcementState.announcementMetaData;

      if (_oldTabIndex != _tabController!.index && _controller.text.isNotEmpty) {
        announcementListData![AppConfig.announcementTo[_tabController!.index]["value"]] = [];
        announcementMetaData![AppConfig.announcementTo[_tabController!.index]["value"]] = Map<String, dynamic>();
      }

      _announcementListProvider!.setAnnouncementListState(
        _announcementListProvider!.announcementState.update(
          progressState: 1,
          announcementListData: announcementListData,
          announcementMetaData: announcementMetaData,
        ),
      );

      _controller.clear();
      _oldTabIndex = _tabController!.index;

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _announcementListProvider!.getAnnouncementListData(
          storeId: widget.storeModel!.id,
          announcementto: AppConfig.announcementTo[_tabController!.index]["value"],
          searchKey: _controller.text.trim(),
        );
      });
    }
    _oldTabIndex = _tabController!.index;
    setState(() {});
  }

  @override
  void dispose() {
    _announcementListProvider!.removeListener(_announcementListProviderListener);

    super.dispose();
  }

  void _announcementListProviderListener() async {
    if (_tabController == null) return;
    if (_announcementListProvider!.announcementState.progressState == -1) {
      if (_announcementListProvider!.announcementState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshFailed();
        _announcementListProvider!.setAnnouncementListState(
          _announcementListProvider!.announcementState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadFailed();
      }
    } else if (_announcementListProvider!.announcementState.progressState == 2) {
      if (_announcementListProvider!.announcementState.isRefresh!) {
        _refreshControllerList[_tabController!.index].refreshCompleted();
        _announcementListProvider!.setAnnouncementListState(
          _announcementListProvider!.announcementState.update(isRefresh: false),
          isNotifiable: false,
        );
      } else {
        _refreshControllerList[_tabController!.index].loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? announcementListData = _announcementListProvider!.announcementState.announcementListData;
    Map<String, dynamic>? announcementMetaData = _announcementListProvider!.announcementState.announcementMetaData;

    announcementListData![AppConfig.announcementTo[_tabController!.index]["value"]] = [];
    announcementMetaData![AppConfig.announcementTo[_tabController!.index]["value"]] = Map<String, dynamic>();
    _announcementListProvider!.setAnnouncementListState(
      _announcementListProvider!.announcementState.update(
        progressState: 1,
        announcementListData: announcementListData,
        announcementMetaData: announcementMetaData,
        isRefresh: true,
      ),
    );

    _announcementListProvider!.getAnnouncementListData(
      storeId: widget.storeModel!.id,
      announcementto: AppConfig.announcementTo[_tabController!.index]["value"],
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _announcementListProvider!.setAnnouncementListState(
      _announcementListProvider!.announcementState.update(progressState: 1),
    );
    _announcementListProvider!.getAnnouncementListData(
      storeId: widget.storeModel!.id,
      announcementto: AppConfig.announcementTo[_tabController!.index]["value"],
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyAnnouncementListHandler() {
    Map<String, dynamic>? announcementListData = _announcementListProvider!.announcementState.announcementListData;
    Map<String, dynamic>? announcementMetaData = _announcementListProvider!.announcementState.announcementMetaData;

    announcementListData![AppConfig.announcementTo[_tabController!.index]["value"]] = [];
    announcementMetaData![AppConfig.announcementTo[_tabController!.index]["value"]] = Map<String, dynamic>();
    _announcementListProvider!.setAnnouncementListState(
      _announcementListProvider!.announcementState.update(
        progressState: 1,
        announcementListData: announcementListData,
        announcementMetaData: announcementMetaData,
      ),
    );

    _announcementListProvider!.getAnnouncementListData(
      storeId: widget.storeModel!.id,
      announcementto: AppConfig.announcementTo[_tabController!.index]["value"],
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
          "Announcements",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<AnnouncementListProvider>(builder: (context, announcementListProvider, _) {
        if (announcementListProvider.announcementState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (announcementListProvider.announcementState.progressState == -1) {
          return ErrorPage(
            message: announcementListProvider.announcementState.message,
            callback: () {
              _announcementListProvider!.setAnnouncementListState(
                _announcementListProvider!.announcementState.update(
                  progressState: 1,
                  isRefresh: true,
                ),
              );

              _announcementListProvider!.getAnnouncementListData(
                storeId: widget.storeModel!.id,
                announcementto: AppConfig.announcementTo[_oldTabIndex]["value"],
                searchKey: _controller.text.trim(),
              );
            },
          );
        }

        return DefaultTabController(
          length: AppConfig.announcementTo.length,
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              children: [
                if (!widget.isForBusiness!) _tabBar(),
                if (!widget.isForBusiness!) SizedBox(height: heightDp * 10),
                _searchField(),
                SizedBox(height: heightDp * 10),
                Expanded(child: _productListPanel()),
              ],
            ),
          ),
        );
      }),
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
              hintText: AnnouncementListPageString.searchHint,
              prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
              suffixIcons: [
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                    _searchKeyAnnouncementListHandler();
                  },
                  child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
                ),
              ],
              onFieldSubmittedHandler: (input) {
                FocusScope.of(context).requestFocus(FocusNode());
                _searchKeyAnnouncementListHandler();
              },
            ),
          ),
          if (!widget.isForBusiness!) SizedBox(width: widthDp * 10),
          if (!widget.isForBusiness!)
            KeicyRaisedButton(
              width: widthDp * 100,
              height: heightDp * 40,
              color: config.Colors().mainColor(1),
              borderRadius: heightDp * 6,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
              child: Text(
                "+ New",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
              ),
              onPressed: () async {
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AnnouncementDetailPage(
                      storeModel: widget.storeModel,
                      isNew: true,
                      announcementData: {
                        "announcementto": AppConfig.announcementTo[_tabController!.index]["value"],
                      },
                    ),
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
      isScrollable: true,
      indicatorColor: config.Colors().mainColor(1),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.zero,
      labelStyle: TextStyle(fontSize: fontSp * 16),
      labelColor: config.Colors().mainColor(1),
      unselectedLabelColor: Colors.black,
      tabs: List.generate(AppConfig.announcementTo.length, (index) {
        String str = "";
        switch (index) {
          case 0:
            str = "Customers";

            break;
          case 1:
            str = "Business";
            break;
          case 2:
            str = "Customers & Business";
            break;
          default:
        }
        return Tab(
          text: "$str",
        );
      }),
    );
  }

  Widget _productListPanel() {
    int index = _tabController!.index;
    String category = AppConfig.announcementTo[index]["value"];

    List<dynamic> announcementListData = [];
    Map<String, dynamic> announcementMetaData = Map<String, dynamic>();

    if (_announcementListProvider!.announcementState.announcementListData![category] != null) {
      announcementListData = _announcementListProvider!.announcementState.announcementListData![category];
    }
    if (_announcementListProvider!.announcementState.announcementMetaData![category] != null) {
      announcementMetaData = _announcementListProvider!.announcementState.announcementMetaData![category];
    }

    int itemCount = 0;

    if (_announcementListProvider!.announcementState.announcementListData![category] != null) {
      int length = _announcementListProvider!.announcementState.announcementListData![category].length;
      itemCount += length;
    }

    if (_announcementListProvider!.announcementState.progressState == 1) {
      itemCount += AppConfig.countLimitForList;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: (announcementMetaData["nextPage"] != null && _announcementListProvider!.announcementState.progressState != 1),
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshControllerList[index],
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: itemCount == 0
            ? Center(
                child: Text(
                  "No Announcements Available",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              )
            : ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  Map<String, dynamic> announcementData =
                      (index >= announcementListData.length) ? Map<String, dynamic>() : announcementListData[index];
                  return AnnouncementWidget(
                    announcementData: announcementData,
                    storeModel: widget.storeModel,
                    isLoading: announcementData.isEmpty,
                    isForView: widget.isForBusiness,
                    editHandler: () {
                      _editHandler(announcementData, index);
                    },
                    shareHandler: () {
                      _shareHandler(announcementData);
                    },
                    enableHandler: (bool enable) {
                      String message = enable
                          ? "Are you sure you want to enable this announcement, if you do this, this announcement will be shown to all customers visiting your store"
                          : "Are you sure you want to disable this announcement, if you do this, this announcement will not be shown to your customers";

                      NormalAskDialog.show(context, content: message, callback: () {
                        _enableHandler(announcementData, index, enable);
                      });
                    },
                  );
                },
              ),
      ),
    );
  }

  void _editHandler(Map<String, dynamic> announcementData, int index) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AnnouncementDetailPage(
          storeModel: widget.storeModel,
          isNew: false,
          announcementData: announcementData,
        ),
      ),
    );

    if (result != null && result["isUpdated"]) {
      String announcementTo = AppConfig.announcementTo[_tabController!.index]["value"];

      List<dynamic> announcementListData = _announcementListProvider!.announcementState.announcementListData![announcementTo];
      announcementListData[index] = result["announcementData"];
      setState(() {});
    }
  }

  void _enableHandler(Map<String, dynamic> announcementData, int index, bool enabled) async {
    await _keicyProgressDialog!.show();
    var result = await AnnouncementsApiProvider.enableAnnouncements(announcementId: announcementData["_id"], enabled: enabled);
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      announcementData["active"] = enabled;
      String announcementTo = AppConfig.announcementTo[_tabController!.index]["value"];

      List<dynamic> announcementListData = _announcementListProvider!.announcementState.announcementListData![announcementTo];
      announcementListData[index] = announcementData;
      setState(() {});
    }
  }

  void _shareHandler(Map<String, dynamic> announcementData) async {
    Uri dynamicUrl = await DynamicLinkService.createAnnouncementDynamicLink(
      storeModel: StoreModel.fromJson(announcementData["store"]),
      announcementData: announcementData,
    );
    Share.share(dynamicUrl.toString());
  }
}
