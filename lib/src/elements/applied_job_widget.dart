import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/helpers/string_helper.dart';

import 'keicy_avatar_image.dart';

class AppliedJobWidget extends StatelessWidget {
  final Map<String, dynamic>? appliedJobData;
  final bool? isLoading;
  final Function()? detailHandler;

  AppliedJobWidget({
    @required this.appliedJobData,
    @required this.isLoading,
    @required this.detailHandler,
  });

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

  @override
  Widget build(BuildContext context) {
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

    return Card(
      margin: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 5),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 15),
        color: Colors.transparent,
        child: isLoading! ? _shimmerWidget() : _jobPostingWidget(context),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: isLoading!,
      period: Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Job Title : ",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    "asf asdf adsf asdf asdf asdf asdf asd asdf asd fasdf asdf asdf asdfasf asdfasdf asdf asdfas dfas fasd fa",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Job Desc : ",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    "adsf asdf asdf asf asdf asdf asdfasdfsdf asdfasdfsd fasdfasd fasdfasdfasdf asdfsdfa dfasdfsd asdfasdf asdfasdf",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Text(
                  "Number Of People : ",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    "54",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              KeicyRaisedButton(
                width: widthDp * 140,
                height: heightDp * 35,
                color: Colors.white,
                borderRadius: heightDp * 6,
                child: Text(
                  "Applicants",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
              ),
              KeicyRaisedButton(
                width: widthDp * 140,
                height: heightDp * 35,
                color: Colors.white,
                borderRadius: heightDp * 6,
                child: Text(
                  "Edit Job",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _jobPostingWidget(BuildContext context) {
    String approvealStatus = "";
    for (var i = 0; i < AppConfig.appliedJobApprovalStatusType.length; i++) {
      if (appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[i]["id"]) {
        approvealStatus = AppConfig.appliedJobApprovalStatusType[i]["text"];
      }
    }

    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              KeicyAvatarImage(
                url: appliedJobData!["user"]["imageUrl"],
                width: widthDp * 70,
                height: widthDp * 70,
                backColor: Colors.grey.withOpacity(0.4),
                borderRadius: heightDp * 6,
                userName: StringHelper.getUpperCaseString("${appliedJobData!["user"]["firstName"]} ${appliedJobData!["user"]["lastName"]}"),
                textStyle: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
              SizedBox(width: widthDp * 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${appliedJobData!["user"]["firstName"]} ${appliedJobData!["user"]["lastName"]}",
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: heightDp * 5),
                    Text(
                      appliedJobData!["user"]["email"],
                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),

          ///
          Stack(
            children: [
              Divider(height: heightDp * 30, thickness: 1, color: Colors.grey.withOpacity(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: widthDp * 10, height: heightDp * 30, color: Colors.white),
                  Container(
                    height: heightDp * 30,
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(heightDp * 6),
                      color: appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[1]["id"]
                          ? Colors.yellow
                          : appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[2]["id"]
                              ? Colors.green
                              : appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[3]["id"]
                                  ? Colors.red
                                  : Color(0xFFDBDBDB),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          approvealStatus,
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[1]["id"]
                                ? Colors.black
                                : appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[2]["id"]
                                    ? Colors.white
                                    : appliedJobData!["approvalStatus"] == AppConfig.appliedJobApprovalStatusType[3]["id"]
                                        ? Colors.white
                                        : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: widthDp * 10, height: heightDp * 30, color: Colors.white),
                ],
              ),
            ],
          ),

          ///
          Row(
            children: [
              Icon(Icons.schedule_outlined, size: heightDp * 20, color: Colors.black),
              SizedBox(width: widthDp * 5),
              Text(
                "${appliedJobData!["jobPosting"]["minYearExperience"]}+ years",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, size: heightDp * 20, color: Colors.black),
              SizedBox(width: widthDp * 5),
              Expanded(
                child: Text(
                  "${appliedJobData!["address"]}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 10),
          Text(
            "Experience : ",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: heightDp * 5),
          Text(
            "${appliedJobData!["experience"]}",
            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          ///
          SizedBox(height: heightDp * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeicyRaisedButton(
                width: widthDp * 170,
                height: heightDp * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  "View Application",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: detailHandler,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
