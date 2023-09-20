import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/entities/fliter_type.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/helpers/helper.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/pages/customer_insights.dart';
import 'package:trapp/src/providers/customers_monetary_orders_provider.dart';
import 'package:trapp/src/providers/index.dart';

class CustomerMonetaryOrdersView extends StatefulWidget {
  final UserModel? user;

  CustomerMonetaryOrdersView({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _CustomerMonetaryOrdersViewState createState() => _CustomerMonetaryOrdersViewState();
}

class _CustomerMonetaryOrdersViewState extends State<CustomerMonetaryOrdersView> with SingleTickerProviderStateMixin {
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

  CustomerMonetaryOrdersProvider? _provider;
  RefreshController? _refreshController;
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
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

    _provider = CustomerMonetaryOrdersProvider.of(context);
    _refreshController = RefreshController();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _provider!.init();
      if (!_provider!.state.isLoading) {
        _provider!.getData(
          storeId: AuthProvider.of(context).authState.storeModel!.id,
          userId: widget.user != null ? widget.user!.id : null,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRefresh() async {
    _provider!.getData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      userId: widget.user != null ? widget.user!.id : null,
      isRefresh: true,
    );
  }

  void _onLoading() async {
    _provider!.getData(
      storeId: AuthProvider.of(context).authState.storeModel!.id,
      userId: widget.user != null ? widget.user!.id : null,
      isRefresh: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Customer monetary orders",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            ),
            if (widget.user != null)
              Text(
                "(${widget.user!.firstName!} ${widget.user!.lastName!})",
                style: TextStyle(fontSize: 10),
              )
          ],
        ),
        elevation: 0,
      ),
      body: Consumer<CustomerMonetaryOrdersProvider>(builder: (context, provider, _) {
        return Container(
          width: deviceWidth,
          height: deviceHeight,
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _tabPanel(),
              _filterPanel(),
              _bodyPanel(),
            ],
          ),
        );
      }),
    );
  }

  Widget _tabPanel() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        children: FilterType.values
            .map(
              (e) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    _provider!.toggleMode();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widthDp * 10,
                      vertical: heightDp * 10,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _provider!.state.filterType == e ? config.Colors().mainColor(1) : Colors.white,
                      borderRadius: BorderRadius.circular(heightDp * 30),
                    ),
                    child: Text(
                      e.toString().split(".").last.toUpperCase(),
                      style: TextStyle(
                        color: _provider!.state.filterType == e ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _filterPanel() {
    if (_provider!.state.searchData != null && _provider!.state.searchData!["from"] != null) {
      _fromController.text = _provider!.state.searchData!["from"];
    }

    if (_provider!.state.searchData != null && _provider!.state.searchData!["to"] != null) {
      _toController.text = _provider!.state.searchData!["to"];
    }
    if (_provider!.state.filterType == FilterType.simple) {
      return Container(
        padding: EdgeInsets.only(
          bottom: 32.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: KeicyDropDownFormField(
                width: double.infinity,
                height: heightDp * 25,
                label: "Year",
                menuItems: _provider!.state.years,
                value: _provider!.state.searchData != null ? _provider!.state.searchData!["year"].toString() : null,
                selectedItemStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, height: 1),
                border: Border.all(),
                updateValueNewly: true,
                borderRadius: heightDp * 3,
                onChangeHandler: (value) {
                  _provider!.setYear(value);
                },
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: KeicyDropDownFormField(
                width: double.infinity,
                height: heightDp * 25,
                label: "Month",
                menuItems: _provider!.state.months,
                value: _provider!.state.searchData != null ? _provider!.state.searchData!["month"].toString() : null,
                updateValueNewly: true,
                selectedItemStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, height: 1),
                border: Border.all(),
                borderRadius: heightDp * 3,
                onChangeHandler: (value) {
                  _provider!.setMonth(value);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 13, left: 8),
              child: KeicyRaisedButton(
                width: widthDp * 65,
                color: config.Colors().mainColor(1),
                height: heightDp * 40,
                textColor: Colors.white,
                borderRadius: heightDp * 3,
                child: Text(
                  "GO",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _provider!.getData(
                    storeId: AuthProvider.of(context).authState.storeModel!.id,
                    userId: widget.user != null ? widget.user!.id : null,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    if (_provider!.state.filterType == FilterType.advanced) {
      return Container(
        padding: EdgeInsets.only(
          bottom: 32.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: KeicyTextFormField(
                controller: _fromController,
                // focusNode: _postedDateFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                isImportant: true,
                label: "From Date",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "From Date",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                readOnly: true,
                initialValue: _provider!.state.searchData != null ? _provider!.state.searchData!["from"] : null,
                onTapHandler: () async {
                  DateTime? selecteDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(AppConfig.establishedYear, 1, 1),
                    lastDate: DateTime.now(),
                    // selectableDayPredicate: (date) {
                    //   // if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return true;
                    //   // if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
                    //   return true;
                    // },
                  );

                  if (selecteDate == null) return;
                  String datey = KeicyDateTime.convertDateTimeToDateString(
                    dateTime: selecteDate,
                    isUTC: false,
                  );

                  _fromController.text = datey;
                  _provider!.setFrom(datey);
                },
                validatorHandler: (input) {
                  if (input.isEmpty) {
                    return "Please enter from date";
                  }

                  return null;
                },
                // onSaveHandler: (input) => _announcementData!["datetobeposted"] = _postedDate!.toUtc().toIso8601String(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: KeicyTextFormField(
                controller: _toController,
                // focusNode: _postedDateFocusNode,
                width: double.infinity,
                height: heightDp * 40,
                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                borderRadius: heightDp * 6,
                contentHorizontalPadding: widthDp * 10,
                contentVerticalPadding: heightDp * 8,
                isImportant: true,
                label: "To Date",
                labelSpacing: heightDp * 5,
                labelStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                hintText: "To Date",
                hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                readOnly: true,
                initialValue: _provider!.state.searchData != null ? _provider!.state.searchData!["to"] : null,
                onTapHandler: () async {
                  DateTime firstDate = DateTime(AppConfig.establishedYear, 1, 1);

                  if (_provider!.state.searchData != null && _provider!.state.searchData!["from"] != null) {
                    DateTime? resFirstDate =
                        KeicyDateTime.convertDateStringToDateTime(dateString: _provider!.state.searchData!["from"], isUTC: false);
                    if (resFirstDate != null) {
                      firstDate = resFirstDate;
                    }
                  }
                  DateTime? selecteDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: firstDate,
                    lastDate: DateTime.now(),
                    // selectableDayPredicate: (date) {
                    //   if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
                    //   if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
                    //   return true;
                    // },
                  );

                  if (selecteDate == null) return;
                  String datey = KeicyDateTime.convertDateTimeToDateString(
                    dateTime: selecteDate,
                    isUTC: false,
                  );

                  _toController.text = datey;
                  _provider!.setTo(datey);
                },
                validatorHandler: (input) {
                  if (input.isEmpty) {
                    return "Please enter to date";
                  }

                  return null;
                },
                // onSaveHandler: (input) => _announcementData!["datetobeposted"] = _postedDate!.toUtc().toIso8601String(),
                onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 13, left: 8),
              child: KeicyRaisedButton(
                width: widthDp * 65,
                color: config.Colors().mainColor(1),
                height: heightDp * 40,
                textColor: Colors.white,
                borderRadius: heightDp * 3,
                child: Text(
                  "GO",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _provider!.getData(
                    storeId: AuthProvider.of(context).authState.storeModel!.id,
                    userId: widget.user != null ? widget.user!.id : null,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _bodyPanel() {
    if (_provider!.state.isLoading) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }

    List<OrderModel>? orders = _provider!.state.orders;

    if (orders == null) {
      return Center(
        child: Text(
          "....",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
      );
    }

    if (orders.length == 0) {
      return Center(
        child: Text(
          _provider!.isSearchData() ? "No data in dates mentioned." : "No data.",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
      );
    }

    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        controller: _refreshController!,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemCount: orders.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text(
                      widget.user == null ? "Customer Name" : "Order Id",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: Container()),
                    Text(
                      "Amount",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              );
            }

            OrderModel order = orders[index - 1];
            if (widget.user != null) {
              return GestureDetector(
                onTap: () async {
                  var result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => OrderDetailNewPage(
                        orderModel: order,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.remove_red_eye),
                      SizedBox(
                        width: 4.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${order.orderId}",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: heightDp * 8,
                          ),
                          Text(
                            "${getOrderStatusName(order.status!)}",
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      Text(
                        "₹ ${order.paymentDetail!.toPay.toString()}",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CustomerInsightsPage(
                      user: order.userModel,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.assessment),
                    SizedBox(
                      width: 4.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${order.userModel!.firstName!} ${order.userModel!.lastName!}",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "${order.orderId}",
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Text(
                      "₹ ${order.paymentDetail!.toPay.toString()}",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
