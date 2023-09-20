import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/connection_note_dialog.dart';
import 'package:trapp/src/dialogs/error_dialog.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/AuthProvider/auth_provider.dart';
import 'package:trapp/src/providers/RefreshProvider/refresh_provider.dart';

class StoreConnectionWidget extends StatefulWidget {
  final StoreModel? storeModel;
  final BusinessConnectionModel? connectionModel;
  final bool? loadingStatus;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String buttonString;
  final Function(StoreModel?, BusinessConnectionModel?)? callback;
  final Function(StoreModel?, BusinessConnectionModel?)? tapHandler;

  StoreConnectionWidget({
    @required this.storeModel,
    @required this.connectionModel,
    @required this.loadingStatus,
    this.padding,
    this.margin,
    this.buttonString = "",
    this.callback,
    this.tapHandler,
  });

  @override
  _StoreConnectionWidgetState createState() => _StoreConnectionWidgetState();
}

class _StoreConnectionWidgetState extends State<StoreConnectionWidget> {
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
  String connectionStatus = "";
  RefreshProvider? _refreshProvider;

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
  }

  @override
  Widget build(BuildContext context) {
    connectionModel = widget.connectionModel != null ? BusinessConnectionModel.copy(widget.connectionModel!) : null;

    return Card(
      margin: widget.margin ??
          EdgeInsets.only(
            left: widthDp * 10,
            right: widthDp * 10,
            top: heightDp * 5,
            bottom: heightDp * 10,
          ),
      elevation: 5,
      child: Container(
        width: widthDp * 175,
        height: heightDp * 290,
        color: Colors.transparent,
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
        child: widget.loadingStatus! ? _shimmerWidget() : _storeWidget(),
      ),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: widget.loadingStatus!,
      period: Duration(milliseconds: 1000),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widthDp * 70,
              height: widthDp * 70,
              color: Colors.white,
            ),
            SizedBox(height: heightDp * 10),
            Column(
              children: [
                Container(
                  height: fontSp * 14 * 2,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text(
                    "sdfasd asdfas asdf Store",
                    style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: heightDp * 3),
                Container(
                  color: Colors.white,
                  child: Text(
                    'sdf as adf a',
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: heightDp * 3),
                    Container(
                      color: Colors.white,
                      child: Text(
                        "dfasdf asdfasdf asdf",
                        style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 3),
                Container(
                  height: fontSp * 12 * 2,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text(
                    " sdfas dfasd asdf asdf asdf adfas dfas dfasdfasdf",
                    style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 7, vertical: heightDp * 3),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: Colors.white),
                  child: Wrap(
                    children: [
                      Icon(Icons.star, size: heightDp * 15, color: Colors.white),
                      SizedBox(width: widthDp * 5),
                      Text(
                        "sdfsdfs",
                        style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heightDp * 10),
                KeicyRaisedButton(
                  width: widthDp * 100,
                  height: heightDp * 30,
                  color: Colors.white,
                  borderRadius: heightDp * 8,
                  child: Text(
                    "Connect",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RefreshProvider()),
      ],
      child: GestureDetector(
        onTap: () {
          if (widget.tapHandler != null && connectionModel != null) {
            widget.tapHandler!(widget.storeModel, connectionModel);
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: widthDp * 70,
                height: widthDp * 70,
                child: KeicyAvatarImage(
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
                      width: heightDp * 80,
                      height: heightDp * 80,
                    ),
                  ),
                ),
              ),
              SizedBox(height: heightDp * 10),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "${widget.storeModel!.name} Store",
                  style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: heightDp * 3),
              Text(
                '${widget.storeModel!.city}',
                style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (widget.storeModel!.distance != 0)
                Column(
                  children: [
                    SizedBox(height: heightDp * 3),
                    Text(
                      '${(widget.storeModel!.distance! / 1000).toStringAsFixed(3)}Km',
                      style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                    ),
                  ],
                ),
              SizedBox(height: heightDp * 3),
              Text(
                "${widget.storeModel!.address}",
                style: TextStyle(fontSize: fontSp * 12, color: Colors.black, height: 1),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heightDp * 5),
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
              SizedBox(height: heightDp * 10),
              Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
                _refreshProvider = refreshProvider;
                return KeicyRaisedButton(
                  width: widthDp * 100,
                  height: heightDp * 30,
                  color: connectionModel == null || connectionModel!.status != "Pending" ? config.Colors().mainColor(1) : Colors.white,
                  borderWidth: 1.5,
                  borderColor:
                      connectionModel == null || connectionModel!.status != "Pending" ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.8),
                  borderRadius: heightDp * 8,
                  child: connectionStatus == "Pending"
                      ? Theme(
                          data: Theme.of(context).copyWith(brightness: Brightness.dark),
                          child: CupertinoActivityIndicator(),
                        )
                      : Text(
                          connectionModel == null ? "Connect" : connectionModel!.status!,
                          style: TextStyle(
                            fontSize: fontSp * 14,
                            color: connectionModel == null || connectionModel!.status != "Pending" ? Colors.white : Colors.grey.withOpacity(1),
                          ),
                        ),
                  onPressed: connectionModel == null ? _connectionHandler : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _connectionHandler() async {
    var note = await ConnectionNoteDialog.show(context);
    if (note == null) return;
    BusinessConnectionModel connectionModel = BusinessConnectionModel();
    connectionModel.requestType = ConnectionRequestType.storeTostore;
    connectionModel.requestedId = AuthProvider.of(context).authState.storeModel!.id;
    connectionModel.recepientId = widget.storeModel!.id;
    connectionModel.status = ConnectionStatus.pending;
    connectionModel.note = note;

    connectionStatus = "Pending";
    _refreshProvider!.refresh();
    var result = await BusinessConnectionsApiProvider.create(businessConnectionModel: connectionModel);
    if (result["success"]) {
      connectionModel = BusinessConnectionModel.fromJson(result["data"]);
      if (widget.callback != null) widget.callback!(widget.storeModel, connectionModel);
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"] ?? "Something was wrong",
      );
    }
    connectionStatus = "";
    _refreshProvider!.refresh();
    setState(() {});
  }
}
