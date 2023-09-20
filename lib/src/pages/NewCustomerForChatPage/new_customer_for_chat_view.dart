import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ChatPage/index.dart';
import 'package:trapp/src/pages/customer_insights.dart';
import 'package:trapp/src/pages/customers_insights.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class NewCustomerForChatView extends StatefulWidget {
  final bool fromSidebar;
  final bool fromBottomBar;
  final bool haveAppbar;

  NewCustomerForChatView({
    Key? key,
    this.fromSidebar = false,
    this.fromBottomBar = false,
    this.haveAppbar = true,
  }) : super(key: key);

  @override
  _NewCustomerForChatViewState createState() => _NewCustomerForChatViewState();
}

class _NewCustomerForChatViewState extends State<NewCustomerForChatView> with SingleTickerProviderStateMixin {
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
  NewCustomerForChatPageProvider? _newCustomerProvider;
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

    _newCustomerProvider = NewCustomerForChatPageProvider.of(context);
    _authProvider = AuthProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _newCustomerProvider!.setNewCustomerForChatPageState(
      _newCustomerProvider!.newCustomerForChatPageState.update(
        progressState: 0,
        message: "",
        customerListData: [],
        customerListMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _newCustomerProvider!.addListener(_newCustomerProviderListener);

      _newCustomerProvider!.getNewCustomerForChatPageData(
        storeId: AuthProvider.of(context).authState.storeModel!.id,
      );
    });
  }

  @override
  void dispose() {
    _newCustomerProvider!.removeListener(_newCustomerProviderListener);

    super.dispose();
  }

  void _newCustomerProviderListener() async {
    if (_newCustomerProvider!.newCustomerForChatPageState.progressState == -1) {
      if (_newCustomerProvider!.newCustomerForChatPageState.isRefresh!) {
        _newCustomerProvider!.setNewCustomerForChatPageState(
          _newCustomerProvider!.newCustomerForChatPageState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_newCustomerProvider!.newCustomerForChatPageState.progressState == 2) {
      if (_newCustomerProvider!.newCustomerForChatPageState.isRefresh!) {
        _newCustomerProvider!.setNewCustomerForChatPageState(
          _newCustomerProvider!.newCustomerForChatPageState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    List<dynamic>? customerListData = _newCustomerProvider!.newCustomerForChatPageState.customerListData;
    Map<String, dynamic>? customerListMetaData = _newCustomerProvider!.newCustomerForChatPageState.customerListMetaData;

    customerListData = [];
    customerListMetaData = Map<String, dynamic>();
    _newCustomerProvider!.setNewCustomerForChatPageState(
      _newCustomerProvider!.newCustomerForChatPageState.update(
        progressState: 1,
        customerListData: customerListData,
        customerListMetaData: customerListMetaData,
        isRefresh: true,
      ),
    );

    _newCustomerProvider!.getNewCustomerForChatPageData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _newCustomerProvider!.setNewCustomerForChatPageState(
      _newCustomerProvider!.newCustomerForChatPageState.update(progressState: 1),
    );
    _newCustomerProvider!.getNewCustomerForChatPageData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyNewCustomerForChatHandler() {
    List<dynamic>? customerListData = _newCustomerProvider!.newCustomerForChatPageState.customerListData;
    Map<String, dynamic>? customerListMetaData = _newCustomerProvider!.newCustomerForChatPageState.customerListMetaData;

    customerListData = [];
    customerListMetaData = Map<String, dynamic>();
    _newCustomerProvider!.setNewCustomerForChatPageState(
      _newCustomerProvider!.newCustomerForChatPageState.update(
        progressState: 1,
        customerListData: customerListData,
        customerListMetaData: customerListMetaData,
      ),
    );

    _newCustomerProvider!.getNewCustomerForChatPageData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      searchKey: _controller.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.haveAppbar
          ? AppBar(
              centerTitle: true,
              title: Text(
                "Customers",
                style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
              ),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => CustomersInsightsPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.assessment),
                )
              ],
            )
          : null,
      body: Consumer<NewCustomerForChatPageProvider>(builder: (context, newCustomerProvider, _) {
        if (newCustomerProvider.newCustomerForChatPageState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              SizedBox(height: heightDp * 10),
              _searchField(),
              Expanded(child: _customerListPanel()),
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
        hintText: NewCustomerForChatPageString.searchHint,
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyNewCustomerForChatHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyNewCustomerForChatHandler();
        },
      ),
    );
  }

  Widget _customerListPanel() {
    List<dynamic> customerList = [];
    Map<String, dynamic> customerListMetaData = Map<String, dynamic>();

    if (_newCustomerProvider!.newCustomerForChatPageState.customerListData != null) {
      customerList = _newCustomerProvider!.newCustomerForChatPageState.customerListData!;
    }
    if (_newCustomerProvider!.newCustomerForChatPageState.customerListMetaData != null) {
      customerListMetaData = _newCustomerProvider!.newCustomerForChatPageState.customerListMetaData!;
    }

    int itemCount = 0;

    if (_newCustomerProvider!.newCustomerForChatPageState.customerListData != null) {
      itemCount += _newCustomerProvider!.newCustomerForChatPageState.customerListData!.length;
    }

    if (_newCustomerProvider!.newCustomerForChatPageState.progressState == 1) {
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
              enablePullUp: (customerListMetaData["nextPage"] != null && _newCustomerProvider!.newCustomerForChatPageState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Customer Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.separated(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> customerData = (index >= customerList.length) ? Map<String, dynamic>() : customerList[index];

                        return NewCustomerWidget(
                          customerData: customerData["user"],
                          loadingStatus: customerData.isEmpty,
                          callback: (operation) {
                            if (widget.fromBottomBar) {
                              if (operation != null && operation == "Insights") {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => CustomerInsightsPage(
                                      user: UserModel.fromJson(customerData["user"]),
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ChatPage(
                                      chatRoomType: ChatRoomTypes.b2c,
                                      userData: customerData["user"],
                                      operation: operation,
                                    ),
                                  ),
                                );
                              }
                            } else if (widget.fromSidebar) {
                              if (operation != null && operation == "Insights") {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => CustomerInsightsPage(
                                      user: UserModel.fromJson(customerData["user"]),
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => ChatPage(
                                      chatRoomType: ChatRoomTypes.b2c,
                                      userData: customerData["user"],
                                      operation: operation,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              Navigator.of(context).pop(customerData["user"]);
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey.withOpacity(0.3), height: 1, thickness: 1);
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
