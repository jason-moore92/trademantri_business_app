import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class AppointmentPage extends StatefulWidget {
  final AppointmentModel? appointmentModel;
  final String? appointmentId;
  final bool? isNew;

  AppointmentPage({this.appointmentModel, this.appointmentId, this.isNew = true});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
  double heightDp = ScreenUtil().setWidth(1);

  @override
  Widget build(BuildContext context) {
    if (widget.appointmentModel == null && widget.appointmentId != null) {
      return StreamBuilder<dynamic>(
          stream: Stream.fromFuture(
            AppointmentApiProvider.get(id: widget.appointmentId),
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isNotEmpty) {
                  AppointmentModel appointmentModel = AppointmentModel.fromJson(snapshot.data["data"][0]);

                  return AppointmentView(appointmentModel: appointmentModel, isNew: widget.isNew);
                } else if (snapshot.hasData && snapshot.data["success"] && snapshot.data["data"].isEmpty) {
                  return Scaffold(
                    body: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: heightDp * 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your store is not part of this appointment",
                              style: TextStyle(fontSize: fontSp * 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: heightDp * 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: heightDp * 80,
                                padding: EdgeInsets.symmetric(horizontal: heightDp * 15, vertical: heightDp * 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: config.Colors().mainColor(1),
                                  borderRadius: BorderRadius.circular(heightDp * 8),
                                ),
                                child: Text(
                                  "Ok",
                                  style: TextStyle(fontSize: fontSp * 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return ErrorPage(
                    message: snapshot.hasData ? snapshot.data["message"] ?? "" : "Something Wrong",
                    callback: () {
                      setState(() {});
                    },
                  );
                }
              default:
            }
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          });
    }
    return AppointmentView(appointmentModel: widget.appointmentModel, isNew: widget.isNew);
  }
}
