import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/pages/RewardPointsForCustomerPage/reward_points_for_customer_page.dart';

class CreateRewardPointsView extends StatefulWidget {
  final Map<String, dynamic>? rewardPointsData;
  final bool isNew;

  CreateRewardPointsView({Key? key, this.rewardPointsData, this.isNew = true}) : super(key: key);

  @override
  _CreateRewardPointsViewState createState() => _CreateRewardPointsViewState();
}

class _CreateRewardPointsViewState extends State<CreateRewardPointsView> {
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

  TextEditingController _buyController = TextEditingController();
  TextEditingController _redeemController = TextEditingController();
  TextEditingController _minOrderController = TextEditingController();
  TextEditingController _maxRewardsController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  FocusNode _buyFocusNode = FocusNode();
  FocusNode _redeemFocusNode = FocusNode();
  FocusNode _minOrderFocusNode = FocusNode();
  FocusNode _maxRewardsFocusNode = FocusNode();
  FocusNode _startDateFocusNode = FocusNode();
  FocusNode _endDateFocusNode = FocusNode();

  DateTime? _startDate;
  DateTime? _endDate;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  KeicyProgressDialog? _keicyProgressDialog;

  Map<String, dynamic>? _newRewardPointsData;

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

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    if (!widget.isNew && widget.rewardPointsData != null) {
      _buyController.text = widget.rewardPointsData!["buy"]["value"].toString();
      _redeemController.text = widget.rewardPointsData!["redeem"]["rewardPoints"].toString();
      _minOrderController.text = widget.rewardPointsData!["minOrderAmount"].toString();
      _maxRewardsController.text = widget.rewardPointsData!["maxRewardsPerOrder"].toString();
      _startDate = DateTime.tryParse(widget.rewardPointsData!["validity"]["startDate"])!.toLocal();
      _startDateController.text = KeicyDateTime.convertDateTimeToDateString(
        dateTime: _startDate,
        isUTC: false,
      );
      if (widget.rewardPointsData!["validity"]["endDate"] != null && widget.rewardPointsData!["validity"]["endDate"] != "") {
        _endDate = DateTime.tryParse(widget.rewardPointsData!["validity"]["endDate"])!.toLocal();
        _endDateController.text = KeicyDateTime.convertDateTimeToDateString(
          dateTime: _endDate,
          isUTC: false,
        );
      }
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  void _createRewardPoints() async {
    if (!_formKey.currentState!.validate()) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Please fix missing fields that are marked as red",
      );
      return;
    }
    await _keicyProgressDialog!.show();
    var result = await RewardPointApiProvider.createOrUpdateRewardPoints(
      rewardPointData: {
        "buy": {"rewardPoints": 1, "value": int.parse(_buyController.text.trim())},
        "redeem": {"rewardPoints": int.parse(_redeemController.text.trim()), "value": 1},
        "validity": {
          "startDate": _startDate!.toUtc().toIso8601String(),
          "endDate": _endDate != null ? _endDate!.toUtc().toIso8601String() : null,
        },
        "minOrderAmount": int.parse(_minOrderController.text.trim()),
        "maxRewardsPerOrder": int.parse(_maxRewardsController.text.trim()),
      },
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _newRewardPointsData = result["data"];
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp, callBack: () {
        Navigator.of(context).pop(_newRewardPointsData);
      });
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_newRewardPointsData);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: heightDp * 20),
            onPressed: () {
              Navigator.of(context).pop(_newRewardPointsData);
            },
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Configure Reward Points",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Container(
              width: deviceWidth,
              padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Configure reward points to attract more customers",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),

                    ///
                    SizedBox(height: heightDp * 30),
                    Text(
                      "Buy (When Customer is buying)",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: heightDp * 10),
                    Text(
                      "Rupee (₹)",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: KeicyTextFormField(
                            controller: _buyController,
                            focusNode: _buyFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 8,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validatorHandler: (input) => input.isEmpty ? "Please enther a rupee" : null,
                            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_redeemFocusNode),
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_redeemFocusNode),
                          ),
                        ),
                        SizedBox(width: widthDp * 10),
                        Text(
                          " = 1 Reward Point",
                          style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    ///
                    SizedBox(height: heightDp * 30),
                    Text(
                      "Redeem (When Customer is redeeming)",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: heightDp * 10),
                    Text(
                      "Reward Points",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: KeicyTextFormField(
                            controller: _redeemController,
                            focusNode: _redeemFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 8,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            keyboardType: TextInputType.number,
                            readOnly: !widget.isNew,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validatorHandler: (input) => input.isEmpty ? "Please enther a reward point" : null,
                            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                          ),
                        ),
                        SizedBox(width: widthDp * 10),
                        Text(
                          " = 1 Rupee",
                          style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    ///
                    SizedBox(height: heightDp * 30),
                    Text(
                      "Validity",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: heightDp * 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Start Date",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                              KeicyTextFormField(
                                controller: _startDateController,
                                focusNode: _startDateFocusNode,
                                width: double.infinity,
                                height: heightDp * 40,
                                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                                borderRadius: heightDp * 8,
                                contentHorizontalPadding: widthDp * 10,
                                contentVerticalPadding: heightDp * 8,
                                readOnly: true,
                                validatorHandler: (input) {
                                  if (_startDate == null || (_endDate != null && _startDate!.isAfter(_endDate!)))
                                    return "Please enter correct date";
                                  else
                                    return null;
                                },
                                onTapHandler: () async {
                                  DateTime? selecteDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
                                    selectableDayPredicate: (date) {
                                      if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
                                      if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
                                      return true;
                                    },
                                  );

                                  if (selecteDate == null) return;

                                  _startDateController.text = KeicyDateTime.convertDateTimeToDateString(
                                    dateTime: selecteDate,
                                    isUTC: false,
                                  );

                                  _startDate = selecteDate;

                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: widthDp * 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "End Date",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                              KeicyTextFormField(
                                controller: _endDateController,
                                focusNode: _endDateFocusNode,
                                width: double.infinity,
                                height: heightDp * 40,
                                border: Border.all(color: Colors.grey.withOpacity(0.7)),
                                errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                                borderRadius: heightDp * 8,
                                contentHorizontalPadding: widthDp * 10,
                                contentVerticalPadding: heightDp * 8,
                                readOnly: true,
                                suffixIcons: [
                                  _endDateController.text.isEmpty
                                      ? SizedBox()
                                      : GestureDetector(
                                          onTap: () {
                                            _endDate = null;
                                            _endDateController.clear();
                                            setState(() {});
                                          },
                                          child: Icon(Icons.close, size: heightDp * 20, color: Colors.black),
                                        ),
                                ],
                                validatorHandler: (input) {
                                  if (_startDate == null || _endDate == null) return null;
                                  if (_startDate!.isAfter(_endDate!))
                                    return "Please enter correct date";
                                  else
                                    return null;
                                },
                                onTapHandler: () async {
                                  DateTime? selecteDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year, DateTime.now().month + 3, 1).subtract(Duration(days: 1)),
                                    selectableDayPredicate: (date) {
                                      if (date.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) return false;
                                      if (date.isAfter(DateTime(DateTime.now().year, DateTime.now().month + 2, DateTime.now().day))) return false;
                                      return true;
                                    },
                                  );

                                  if (selecteDate == null) return;

                                  _endDateController.text = KeicyDateTime.convertDateTimeToDateString(
                                    dateTime: selecteDate,
                                    isUTC: false,
                                  );

                                  _endDate = selecteDate;

                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    ///

                    SizedBox(height: heightDp * 10),
                    Text(
                      "Min Amount",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: KeicyTextFormField(
                            controller: _minOrderController,
                            focusNode: _minOrderFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 8,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validatorHandler: (input) => input.isEmpty ? "Please enter a value" : null,
                            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(_maxRewardsFocusNode),
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(_maxRewardsFocusNode),
                          ),
                        ),
                        SizedBox(width: widthDp * 10),
                        Text(
                          " Per Order",
                          style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    SizedBox(height: heightDp * 10),
                    Text(
                      "Max Rewards",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: KeicyTextFormField(
                            controller: _maxRewardsController,
                            focusNode: _maxRewardsFocusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            errorBorder: Border.all(color: Colors.red.withOpacity(0.7)),
                            borderRadius: heightDp * 8,
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validatorHandler: (input) => input.isEmpty ? "Please enter a value" : null,
                            onEditingCompleteHandler: () => FocusScope.of(context).requestFocus(FocusNode()),
                            onFieldSubmittedHandler: (input) => FocusScope.of(context).requestFocus(FocusNode()),
                          ),
                        ),
                        SizedBox(width: widthDp * 10),
                        Text(
                          " Per Order",
                          style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    SizedBox(height: heightDp * 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        KeicyRaisedButton(
                          width: widthDp * 130,
                          height: heightDp * 40,
                          color: config.Colors().mainColor(1),
                          borderRadius: heightDp * 6,
                          child: Text(
                            "Configure",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.white),
                          ),
                          onPressed: _createRewardPoints,
                        ),
                      ],
                    ),

                    ///
                    SizedBox(height: heightDp * 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
