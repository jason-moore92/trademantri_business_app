import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/dialogs/normal_ask_dialog.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/AuthProvider/auth_provider.dart';

class StoreInvitationWidget extends StatefulWidget {
  final StoreModel? storeModel;
  final BusinessConnectionModel? connectionModel;
  final bool? loadingStatus;
  final String buttonString;
  final Function(StoreModel?, BusinessConnectionModel?)? invitationCallback;
  final Function(StoreModel?, BusinessConnectionModel?)? tapHandler;

  StoreInvitationWidget({
    @required this.storeModel,
    @required this.connectionModel,
    @required this.loadingStatus,
    this.buttonString = "",
    this.invitationCallback,
    this.tapHandler,
  });

  @override
  _StoreInvitationWidgetState createState() => _StoreInvitationWidgetState();
}

class _StoreInvitationWidgetState extends State<StoreInvitationWidget> {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double fontSp = 0;
  ///////////////////////////////

  BusinessConnectionModel? connectionModel;
  KeicyProgressDialog? keicyProgressDialog;

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
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    keicyProgressDialog = KeicyProgressDialog.of(context);
  }

  @override
  Widget build(BuildContext context) {
    connectionModel = widget.connectionModel != null ? BusinessConnectionModel.copy(widget.connectionModel!) : null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
      color: Colors.transparent,
      child: widget.loadingStatus! ? _shimmerWidget() : _storeWidget(),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Row(
        children: [
          Container(
            width: widthDp * 80,
            height: widthDp * 80,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(heightDp * 6)),
          ),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: widthDp * 100,
                  color: Colors.white,
                  child: Text(
                    "Loading ...",
                    style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.transparent),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  width: widthDp * 140,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        'storeModel city',
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                      SizedBox(width: widthDp * 15),
                      Text(
                        'Km',
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  width: widthDp * 200,
                  color: Colors.white,
                  child: Text(
                    "storeModel address",
                    style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  width: widthDp * 100,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, size: heightDp * 15, color: Colors.white),
                      SizedBox(width: widthDp * 5),
                      Text(
                        "type",
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.transparent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeWidget() {
    Color storeTypeColor = Colors.white;
    if (widget.storeModel!.type != null) {
      switch (widget.storeModel!.type) {
        case "Retailer":
          storeTypeColor = Colors.blue;
          break;
        case "Wholesaler":
          storeTypeColor = Colors.green;
          break;
        case "Service":
          storeTypeColor = Colors.red;
          break;
        default:
          storeTypeColor = Colors.white;
      }
    }

    return GestureDetector(
      onTap: () {
        if (widget.tapHandler != null) {
          widget.tapHandler!(widget.storeModel, connectionModel);
        }
      },
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          children: [
            KeicyAvatarImage(
              url: widget.storeModel!.profile!["image"],
              width: widthDp * 70,
              height: widthDp * 70,
              backColor: Colors.grey.withOpacity(0.4),
              borderRadius: heightDp * 6,
              shimmerEnable: widget.loadingStatus,
              errorWidget: ClipRRect(
                borderRadius: BorderRadius.circular(heightDp * 6),
                child: Image.asset(
                  "img/store-icon/${widget.storeModel!.subType.toString().toLowerCase()}-store.png",
                  width: widthDp * 80,
                  height: widthDp * 80,
                ),
              ),
            ),
            SizedBox(width: widthDp * 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.storeModel!.name} Store",
                    style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: heightDp * 3),
                  Text(
                    '${widget.storeModel!.city}',
                    style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                  ),
                  SizedBox(height: heightDp * 3),
                  Text(
                    "${widget.storeModel!.address}",
                    style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: heightDp * 3),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 7, vertical: heightDp * 3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: storeTypeColor.withOpacity(0.4)),
                    child: Wrap(
                      children: [
                        Icon(Icons.star, size: heightDp * 15, color: storeTypeColor),
                        SizedBox(width: widthDp * 5),
                        Text(
                          "${widget.storeModel!.type}",
                          style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (connectionModel!.requestedId != AuthProvider.of(context).authState.storeModel!.id)
              GestureDetector(
                onTap: () async {
                  var rejectNote = await ConnectionRejectDialog.show(
                    context,
                  );

                  if (rejectNote == null) return;

                  connectionModel!.status = ConnectionStatus.rejected;
                  connectionModel!.rejectNote = rejectNote;

                  _invitationHandler(widget.storeModel, connectionModel);
                },
                child: Container(
                  padding: EdgeInsets.all(heightDp * 5),
                  color: Colors.transparent,
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Icon(
                      Icons.add_circle_outline_outlined,
                      size: heightDp * 35,
                    ),
                  ),
                ),
              ),
            if (connectionModel!.requestedId != AuthProvider.of(context).authState.storeModel!.id)
              GestureDetector(
                onTap: () {
                  NormalAskDialog.show(
                    context,
                    content: "Are you going to accept this request",
                    callback: () {
                      connectionModel!.status = ConnectionStatus.active;

                      _invitationHandler(widget.storeModel, connectionModel);
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(heightDp * 5),
                  color: Colors.transparent,
                  child: Icon(
                    Icons.check_circle_outline_outlined,
                    size: heightDp * 35,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _invitationHandler(StoreModel? storeModel, BusinessConnectionModel? connectionModel) async {
    await keicyProgressDialog!.show();

    var result = await BusinessConnectionsApiProvider.update(businessConnectionModel: connectionModel);
    await keicyProgressDialog!.hide();
    if (result["success"]) {
      if (widget.invitationCallback != null) {
        widget.invitationCallback!(storeModel, connectionModel);
      }
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
