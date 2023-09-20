import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/appointment_widget.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/elements/notification_widget.dart';
import 'package:trapp/src/models/appointment_model.dart';
import 'package:trapp/src/pages/AppointmentPage/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class AppointmentListView extends StatefulWidget {
  AppointmentListView({Key? key}) : super(key: key);

  @override
  _AppointmentListViewState createState() => _AppointmentListViewState();
}

class _AppointmentListViewState extends State<AppointmentListView> with SingleTickerProviderStateMixin {
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
  AppointmentProvider? _appointmentProvider;

  RefreshController? _refreshController;

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  String status = "ALL";

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

    _appointmentProvider = AppointmentProvider.of(context);
    _authProvider = AuthProvider.of(context);

    _refreshController = RefreshController(initialRefresh: false);

    _appointmentProvider!.setAppointmentState(
      _appointmentProvider!.appointmentState.update(
        progressState: 0,
        appointmentsData: Map<String, dynamic>(),
        appointmentsMetaData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _appointmentProvider!.addListener(_appointmentProviderListener);
      if (_appointmentProvider!.appointmentState.progressState == 2) return;

      _appointmentProvider!.setAppointmentState(_appointmentProvider!.appointmentState.update(progressState: 1));
      _appointmentProvider!.getAppointments(
        storeId: _authProvider!.authState.storeModel!.id,
        status: status,
      );
    });
  }

  @override
  void dispose() {
    _appointmentProvider!.removeListener(_appointmentProviderListener);

    super.dispose();
  }

  void _appointmentProviderListener() async {
    if (_appointmentProvider!.appointmentState.progressState == -1) {
      if (_appointmentProvider!.appointmentState.isRefresh!) {
        _appointmentProvider!.setAppointmentState(
          _appointmentProvider!.appointmentState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshFailed();
      } else {
        _refreshController!.loadFailed();
      }
    } else if (_appointmentProvider!.appointmentState.progressState == 2) {
      if (_appointmentProvider!.appointmentState.isRefresh!) {
        _appointmentProvider!.setAppointmentState(
          _appointmentProvider!.appointmentState.update(isRefresh: false),
          isNotifiable: false,
        );
        _refreshController!.refreshCompleted();
      } else {
        _refreshController!.loadComplete();
      }
    }
  }

  void _onRefresh() async {
    Map<String, dynamic>? appointmentsData = _appointmentProvider!.appointmentState.appointmentsData;
    Map<String, dynamic>? appointmentsMetaData = _appointmentProvider!.appointmentState.appointmentsMetaData;

    appointmentsData![status] = [];
    appointmentsMetaData![status] = Map<String, dynamic>();
    _appointmentProvider!.setAppointmentState(
      _appointmentProvider!.appointmentState.update(
        progressState: 1,
        appointmentsData: appointmentsData,
        appointmentsMetaData: appointmentsMetaData,
        isRefresh: true,
      ),
    );

    _appointmentProvider!.getAppointments(
      storeId: _authProvider!.authState.storeModel!.id,
      status: status,
      searchKey: _controller.text.trim(),
    );
  }

  void _onLoading() async {
    _appointmentProvider!.setAppointmentState(
      _appointmentProvider!.appointmentState.update(progressState: 1),
    );
    _appointmentProvider!.getAppointments(
      storeId: _authProvider!.authState.storeModel!.id,
      status: status,
      searchKey: _controller.text.trim(),
    );
  }

  void _searchKeyAppointmentListHandler() {
    Map<String, dynamic>? appointmentsData = _appointmentProvider!.appointmentState.appointmentsData;
    Map<String, dynamic>? appointmentsMetaData = _appointmentProvider!.appointmentState.appointmentsMetaData;

    appointmentsData![status] = [];
    appointmentsMetaData![status] = Map<String, dynamic>();
    _appointmentProvider!.setAppointmentState(
      _appointmentProvider!.appointmentState.update(
        progressState: 1,
        appointmentsData: appointmentsData,
        appointmentsMetaData: appointmentsMetaData,
      ),
    );

    _appointmentProvider!.getAppointments(
      storeId: _authProvider!.authState.storeModel!.id,
      status: status,
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
          "Appointments",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<AppointmentProvider>(builder: (context, appointmentProvider, _) {
        if (appointmentProvider.appointmentState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (appointmentProvider.appointmentState.progressState == -1) {
          return ErrorPage(
            message: appointmentProvider.appointmentState.message,
            callback: () {
              _appointmentProvider!.setAppointmentState(_appointmentProvider!.appointmentState.update(progressState: 1));
              _appointmentProvider!.getAppointments(
                storeId: _authProvider!.authState.storeModel!.id,
                status: status,
              );
            },
          );
        }

        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "One-on-One",
                            style: TextStyle(fontSize: fontSp * 16),
                          ),
                          Text(
                            "Let an invitee pick a time to meet with you",
                            style: TextStyle(fontSize: fontSp * 14),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: widthDp * 10),
                    KeicyRaisedButton(
                      width: widthDp * 100,
                      height: heightDp * 30,
                      color: config.Colors().mainColor(1),
                      borderRadius: heightDp * 6,
                      child: Text(
                        "Create",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                      ),
                      onPressed: _addHandler,
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightDp * 10),
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
        hintText: "Search for appointment name",
        prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
        suffixIcons: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              _searchKeyAppointmentListHandler();
            },
            child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
        onFieldSubmittedHandler: (input) {
          FocusScope.of(context).requestFocus(FocusNode());
          _searchKeyAppointmentListHandler();
        },
      ),
    );
  }

  Widget _notificationListPanel() {
    List<dynamic> notificationList = [];
    Map<String, dynamic> appointmentsMetaData = Map<String, dynamic>();

    if (_appointmentProvider!.appointmentState.appointmentsData![status] != null) {
      notificationList = _appointmentProvider!.appointmentState.appointmentsData![status];
    }
    if (_appointmentProvider!.appointmentState.appointmentsMetaData![status] != null) {
      appointmentsMetaData = _appointmentProvider!.appointmentState.appointmentsMetaData![status];
    }

    int itemCount = 0;

    if (_appointmentProvider!.appointmentState.appointmentsData![status] != null) {
      int length = _appointmentProvider!.appointmentState.appointmentsData![status].length;
      itemCount += length;
    }

    if (_appointmentProvider!.appointmentState.progressState == 1) {
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
              enablePullUp: (appointmentsMetaData["nextPage"] != null && _appointmentProvider!.appointmentState.progressState != 1),
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController!,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: itemCount == 0
                  ? Center(
                      child: Text(
                        "No Appointment Available",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = (index >= notificationList.length) ? Map<String, dynamic>() : notificationList[index];

                        return ApointmentWidget(
                          appointmentModel: data.isEmpty ? null : AppointmentModel.fromJson(data),
                          isLoading: data.isEmpty,
                          tapHandler: () {
                            _detailHandler(index, AppointmentModel.fromJson(data));
                          },
                          eventEnableHandler: (bool value) {
                            _eventEnableHandler(index, value, data);
                          },
                          deleteHandler: () {
                            NormalAskDialog.show(
                              context,
                              title: "Delete Appointment",
                              content: "Do you want to delete this appointment",
                              callback: () {
                                _deleteHandler(AppointmentModel.fromJson(data));
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  void _detailHandler(int index, AppointmentModel appointmentModel) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AppointmentPage(
          isNew: false,
          appointmentModel: appointmentModel,
        ),
      ),
    );

    if (result != null && result["success"] && result["data"] != null) {
      Map<String, dynamic>? appointmentsData = _appointmentProvider!.appointmentState.appointmentsData;

      appointmentsData![status][index] = result["data"];
      _appointmentProvider!.setAppointmentState(_appointmentProvider!.appointmentState.update(
        appointmentsData: appointmentsData,
      ));
      setState(() {});
    }
  }

  void _deleteHandler(AppointmentModel appointmentModel) async {
    await _keicyProgressDialog!.show();
    var result = await AppointmentApiProvider.deleteAppointment(id: appointmentModel.id);
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      _onRefresh();
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"] ?? "Something was wrong",
      );
    }
  }

  void _addHandler() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AppointmentPage(isNew: true),
      ),
    );

    if (result != null && result["success"] && result["data"] != null) {
      Map<String, dynamic>? appointmentsData = _appointmentProvider!.appointmentState.appointmentsData;
      appointmentsData![status].insert(0, result["data"]);
      _appointmentProvider!.setAppointmentState(_appointmentProvider!.appointmentState.update(
        appointmentsData: appointmentsData,
      ));
      setState(() {});
    }
  }

  void _eventEnableHandler(
    int index,
    bool value,
    Map<String, dynamic> data,
  ) async {
    await _keicyProgressDialog!.show();
    var result = await AppointmentApiProvider.eventAction(
      eventid: data["_id"],
      eventenable: value,
    );
    await _keicyProgressDialog!.hide();

    if (result["success"]) {
      data["eventenable"] = value;
      Map<String, dynamic>? appointmentsData = _appointmentProvider!.appointmentState.appointmentsData;

      appointmentsData![status][index] = data;
      _appointmentProvider!.setAppointmentState(_appointmentProvider!.appointmentState.update(
        appointmentsData: appointmentsData,
      ));
      setState(() {});
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"] ?? "Something was wrong",
      );
    }
  }
}
