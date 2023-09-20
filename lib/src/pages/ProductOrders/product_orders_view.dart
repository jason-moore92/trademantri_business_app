import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/dto/product_order.dart';
import 'package:trapp/src/elements/keicy_dropdown_form_field.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/entities/fliter_type.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/providers/product_orders_provider.dart';

class ProductOrdersView extends StatefulWidget {
  final String? productId;
  ProductOrdersView({
    Key? key,
    this.productId,
  }) : super(key: key);

  @override
  _ProductOrdersViewState createState() => _ProductOrdersViewState();
}

class _ProductOrdersViewState extends State<ProductOrdersView> with SingleTickerProviderStateMixin {
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

  ProductOrdersProvider? _provider;
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

    _provider = ProductOrdersProvider.of(context);
    _refreshController = RefreshController();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _provider!.init();
      if (!_provider!.state.isLoading) {
        _provider!.getData(
          storeId: AuthProvider.of(context).authState.storeModel!.id,
          productId: widget.productId,
        );

        if (widget.productId != null) {
          _provider!.getProductData(
            storeId: AuthProvider.of(context).authState.storeModel!.id,
            productId: widget.productId,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductOrdersProvider>(
      builder: (context, provider, _) {
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
            title: Text(
              _provider!.state.product != null ? _provider!.state.product!.name! : "Orders, Products and Services",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            ),
            elevation: 0,
          ),
          body: Container(
            width: deviceWidth,
            height: deviceHeight,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // _tabPanel(),
                _filterPanel(),
                _bodyPanel(),
                _footerPanel(),
              ],
            ),
          ),
        );
      },
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
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: KeicyDropDownFormField(
                width: double.infinity,
                height: heightDp * 25,
                label: "Week",
                menuItems: _provider!.state.weekNumbers,
                value: _provider!.state.searchData != null ? _provider!.state.searchData!["weekNumber"].toString() : null,
                updateValueNewly: true,
                selectedItemStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black, height: 1),
                border: Border.all(),
                borderRadius: heightDp * 3,
                onChangeHandler: (value) {
                  _provider!.setWeekNumber(value);
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
                    productId: widget.productId,
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
          bottom: 32,
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
                    productId: widget.productId,
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
    double graphPanelWidth = widthDp * 370;
    double graphPanelHeight = heightDp * 280;
    int _currentDotIndex = 0;

    if (_provider!.state.isLoading) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }

    List<ProductOrder>? poss = _provider!.state.pos;

    if (poss == null) {
      return Center(
        child: Text(
          "....",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
      );
    }

    if (poss.length == 0 || !_provider!.checkData(poss)) {
      return Center(
        child: Text(
          _provider!.isSearchData() ? "No products in dates mentioned." : "No products sold yet.",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
      );
    }

    List<FlSpot> spots = _provider!.convertToGraph(poss);
    List<FlSpot> prodSpots = [];
    if (widget.productId == null) {
      prodSpots = _provider!.convertToGraphProductCount(poss);
    }

    List<FlSpot> serviceSpots = [];
    if (widget.productId == null) {
      serviceSpots = _provider!.convertToGraphServiceCount(poss);
    }

    List<LineChartBarData> lineBarsData = [
      LineChartBarData(
        // showingIndicators: showingIndicators, // tooltip will always show
        isStepLineChart: false,
        spots: spots,
        isCurved: false,
        barWidth: 2,
        colors: [config.Colors().mainColor(1)],
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: heightDp * 3,
              color: config.Colors().mainColor(1),
              strokeWidth: heightDp * 3,
              strokeColor: config.Colors().mainColor(1),
            );
          },
          // checkToShowDot: (spot, barData) {
          //   return spot.x == _currentDotIndex;
          // },
        ),
        belowBarData: BarAreaData(
          show: false,
          // gradientColorStops: [0.5, 1.0],
          // gradientFrom: const Offset(0, 0),
          // gradientTo: const Offset(0, 1),
          colors: [Colors.transparent],
          spotsLine: BarAreaSpotsLine(
            show: true,
            flLineStyle: FlLine(
              color: config.Colors().mainColor(1),
              strokeWidth: 2,
            ),
            checkToShowSpotLine: (spot) {
              if (spot.x == _currentDotIndex) {
                return true;
              }

              return false;
            },
          ),
        ),
      ),
      if (widget.productId == null)
        LineChartBarData(
          // showingIndicators: showingIndicators, // tooltip will always show
          isStepLineChart: false,
          spots: prodSpots,
          isCurved: false,
          barWidth: 2,
          colors: [config.Colors().main1DarkColor(1)],
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: heightDp * 3,
                color: config.Colors().main1DarkColor(1),
                strokeWidth: heightDp * 3,
                strokeColor: config.Colors().main1DarkColor(1),
              );
            },
            // checkToShowDot: (spot, barData) {
            //   return spot.x == _currentDotIndex;
            // },
          ),
          belowBarData: BarAreaData(
            show: false,
            // gradientColorStops: [0.5, 1.0],
            // gradientFrom: const Offset(0, 0),
            // gradientTo: const Offset(0, 1),
            colors: [Colors.transparent],
            spotsLine: BarAreaSpotsLine(
              show: true,
              flLineStyle: FlLine(
                color: config.Colors().mainColor(1),
                strokeWidth: 2,
              ),
              checkToShowSpotLine: (spot) {
                if (spot.x == _currentDotIndex) {
                  return true;
                }

                return false;
              },
            ),
          ),
        ),
      if (widget.productId == null)
        LineChartBarData(
          // showingIndicators: showingIndicators, // tooltip will always show
          isStepLineChart: false,
          spots: serviceSpots,
          isCurved: false,
          barWidth: 2,
          colors: [config.Colors().main2DarkColor(1)],
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: heightDp * 3,
                color: config.Colors().main2DarkColor(1),
                strokeWidth: heightDp * 3,
                strokeColor: config.Colors().main2DarkColor(1),
              );
            },
            // checkToShowDot: (spot, barData) {
            //   return spot.x == _currentDotIndex;
            // },
          ),
          belowBarData: BarAreaData(
            show: false,
            // gradientColorStops: [0.5, 1.0],
            // gradientFrom: const Offset(0, 0),
            // gradientTo: const Offset(0, 1),
            colors: [Colors.transparent],
            spotsLine: BarAreaSpotsLine(
              show: true,
              flLineStyle: FlLine(
                color: config.Colors().mainColor(1),
                strokeWidth: 2,
              ),
              checkToShowSpotLine: (spot) {
                if (spot.x == _currentDotIndex) {
                  return true;
                }

                return false;
              },
            ),
          ),
        ),
    ];

    return Container(
      width: graphPanelWidth,
      height: graphPanelHeight,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: false,
            handleBuiltInTouches: true,
            getTouchLineStart: (barData, index) => -double.infinity, // default: from bottom,
            getTouchLineEnd: (barData, index) => double.infinity, //to top,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Color(0xFF8B8B8B),
              tooltipRoundedRadius: heightDp * 5,
              fitInsideHorizontally: false,
              // length: spots.length,
              tooltipPadding: EdgeInsets.symmetric(
                horizontal: widthDp * 5,
                vertical: heightDp * 7,
              ),
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map((lineBarSpot) {
                  return LineTooltipItem(
                    "sample",
                    TextStyle(),
                    // children: [
                    //   TextSpan(
                    //     text: 'sf',
                    //     style: TextStyle(
                    //       fontFamily: "Avenir-Black",
                    //       color: Colors.white,
                    //       fontSize: fontSp * 15,
                    //     ),
                    //   ),
                    //   TextSpan(
                    //     text: "data",
                    //     style: TextStyle(
                    //       fontFamily: "Avenir-Black",
                    //       color: Colors.white,
                    //       fontSize: fontSp * 9,
                    //       height: 1,
                    //     ),
                    //   ),
                    //   TextSpan(
                    //     text: '\nPNL   ',
                    //     style: TextStyle(
                    //       fontFamily: "Avenir-Black",
                    //       color: Colors.white,
                    //       fontSize: fontSp * 10,
                    //       height: 1.5,
                    //     ),
                    //   ),
                    // ],
                  );
                }).toList();
              },
            ),
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.transparent,
                    strokeWidth: 2,
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: heightDp * 3,
                        color: config.Colors().mainColor(1),
                        strokeWidth: heightDp * 3,
                        strokeColor: config.Colors().mainColor(1),
                      );
                    },
                  ),
                );
              }).toList();
            },
            touchCallback: (LineTouchResponse lineTouch) {
              // if (lineTouch.lineBarSpots.length == 1 && lineTouch.touchInput is! FlLongPressEnd && lineTouch.touchInput is! FlPanEnd) {
              if (lineTouch.lineBarSpots != null && lineTouch.lineBarSpots!.length == 1 && lineTouch.clickHappened) {
                setState(() {
                  _currentDotIndex = lineTouch.lineBarSpots![0].spotIndex;
                });
              } else {
                setState(() {});
              }
            },
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: lineBarsData,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, double xIndex) {
                return TextStyle(
                  fontSize: 8,
                );
              },
              getTitles: (double xIndex) {
                String dateString = poss[xIndex.toInt()].id!;

                String? dateString1 = KeicyDateTime.convertDateStringToDateString(
                  dateString: dateString,
                  isUTC: false,
                  formats: "d M\nY",
                );

                if (dateString1 != null) {
                  dateString = dateString1;
                }
                return dateString;
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
            ),
            rightTitles: SideTitles(
              showTitles: false,
            ),
          ),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }

  Widget _footerPanel() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: config.Colors().mainColor(1)),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text("Orders count"),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: config.Colors().main1DarkColor(1)),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text("Products count"),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: config.Colors().main2DarkColor(1)),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text("Services count"),
            ],
          )
        ],
      ),
    );
  }
}
