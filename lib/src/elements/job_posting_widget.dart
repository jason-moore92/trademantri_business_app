import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

class JobPostingWidget extends StatelessWidget {
  final StoreJobPostModel? storeJobPostModel;
  final bool? isLoading;
  final Function()? editHandler;
  final Function()? applicantsHandler;

  JobPostingWidget({
    @required this.storeJobPostModel,
    @required this.isLoading,
    @required this.editHandler,
    @required this.applicantsHandler,
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
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Job Title : ",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Text(
                  "${storeJobPostModel!.jobTitle}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Job Desc : ",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Text(
                  "${storeJobPostModel!.description}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          ///
          SizedBox(height: heightDp * 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Number Of People : ",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Text(
                  "${storeJobPostModel!.peopleNumber}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Uri dynamicUrl = await DynamicLinkService.createJobDynamicLink(
                    storeJobPostModel: storeJobPostModel,
                    storeModel: AuthProvider.of(context).authState.storeModel,
                  );
                  Share.share(dynamicUrl.toString());
                },
                child: Icon(Icons.share, size: heightDp * 25, color: config.Colors().mainColor(1)),
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
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  "Applicants",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: applicantsHandler,
              ),
              KeicyRaisedButton(
                width: widthDp * 140,
                height: heightDp * 35,
                color: config.Colors().mainColor(1),
                borderRadius: heightDp * 6,
                child: Text(
                  "Edit Job",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                ),
                onPressed: editHandler,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
