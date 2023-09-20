import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/store_model.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'index.dart';

class AnnouncementViewPage extends StatefulWidget {
  final Map<String, dynamic>? announcementData;
  final StoreModel? storeModel;
  final String? announcementId;

  AnnouncementViewPage({@required this.storeModel, this.announcementData, this.announcementId});

  @override
  _AnnouncementViewPageState createState() => _AnnouncementViewPageState();
}

class _AnnouncementViewPageState extends State<AnnouncementViewPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.announcementData == null && widget.announcementId != null) {
      return StreamBuilder<dynamic>(
        stream: Stream.fromFuture(
          AnnouncementsApiProvider.getAnnouncement(announcementId: widget.announcementId),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          }

          if (snapshot.hasError || !snapshot.data["success"] || snapshot.data["data"].isEmpty) {
            return ErrorPage(
              message: "Something Wrong",
              callback: () {
                setState(() {});
              },
            );
          }

          return AnnouncementViewView(
            storeModel: StoreModel.fromJson(snapshot.data["data"][0]["store"]),
            announcementData: snapshot.data["data"][0],
          );
        },
      );
    }
    return AnnouncementViewView(storeModel: widget.storeModel, announcementData: widget.announcementData);
  }
}
