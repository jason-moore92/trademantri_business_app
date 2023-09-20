import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/providers/index.dart';

import 'index.dart';

class StoreConnectionDialog {
  static show(
    BuildContext context, {
    @required StoreModel? storeModel,
    @required BusinessConnectionModel? connectionModel,
    Function(StoreModel?, BusinessConnectionModel?)? invitationCallback,
    Function(StoreModel?, BusinessConnectionModel?)? connectionHandler,
  }) {
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    String connectionStatus = "";

    KeicyProgressDialog? keicyProgressDialog;

    void _invitationHandler(StoreModel? storeModel, BusinessConnectionModel? connectionModel) async {
      await keicyProgressDialog!.show();

      var result = await BusinessConnectionsApiProvider.update(businessConnectionModel: connectionModel);
      await keicyProgressDialog!.hide();
      if (result["success"]) {
        if (invitationCallback != null) {
          invitationCallback(storeModel, connectionModel);
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

    void _connectionHandler() async {
      Navigator.of(context).pop();
      var note = await ConnectionNoteDialog.show(context);
      if (note == null) {
        // StoreConnectionDialog.show(
        //   context,
        //   storeModel: storeModel,
        //   connectionModel: connectionModel,
        // );
        return;
      }
      BusinessConnectionModel newConnectionModel = BusinessConnectionModel();
      newConnectionModel.requestType = ConnectionRequestType.storeTostore;
      newConnectionModel.requestedId = AuthProvider.of(context).authState.storeModel!.id;
      newConnectionModel.recepientId = storeModel!.id;
      newConnectionModel.status = ConnectionStatus.pending;
      newConnectionModel.note = note;

      connectionStatus = "Pending";
      await keicyProgressDialog!.show();
      var result = await BusinessConnectionsApiProvider.create(businessConnectionModel: newConnectionModel);
      await keicyProgressDialog!.hide();
      if (result["success"]) {
        newConnectionModel = BusinessConnectionModel.fromJson(result["data"]);
        if (connectionHandler != null) connectionHandler(storeModel, newConnectionModel);
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
    }

    return showDialog(
      context: context,
      barrierDismissible: true,
      // barrierColor: barrierColor ?? Colors.black.withOpacity(0.3),
      builder: (BuildContext context1) {
        keicyProgressDialog = KeicyProgressDialog.of(context);

        Color storeTypeColor = Colors.white;
        if (storeModel!.type != null) {
          switch (storeModel.type) {
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

        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.close, size: heightDp * 25, color: Colors.transparent),
              ),
              Text(
                "Store Information",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
              ),
            ],
          ),
          titlePadding: EdgeInsets.only(
            left: heightDp * 10,
            right: heightDp * 10,
            top: heightDp * 10,
            bottom: heightDp * 0,
          ),
          contentPadding: EdgeInsets.only(
            left: heightDp * 0,
            right: heightDp * 0,
            top: heightDp * 10,
            bottom: heightDp * 20,
          ),
          children: [
            Consumer<RefreshProvider>(builder: (context2, refreshProvider, _) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                    child: Column(
                      children: [
                        Container(
                          width: widthDp * 100,
                          height: widthDp * 100,
                          child: KeicyAvatarImage(
                            url: storeModel.profile!["image"],
                            width: widthDp * 100,
                            height: widthDp * 100,
                            backColor: Colors.grey.withOpacity(0.4),
                            borderRadius: heightDp * 6,
                            shimmerEnable: false,
                            errorWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(heightDp * 6),
                              child: Image.asset(
                                "img/store-icon/${storeModel.subType.toString().toLowerCase()}-store.png",
                                width: heightDp * 100,
                                height: heightDp * 100,
                              ),
                            ),
                          ),
                        ),

                        ///
                        SizedBox(height: heightDp * 15),
                        Text(
                          storeModel.name!,
                          style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.w600),
                        ),

                        SizedBox(height: heightDp * 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 7, vertical: heightDp * 3),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 5), color: storeTypeColor.withOpacity(0.4)),
                          child: Wrap(
                            children: [
                              Icon(Icons.star, size: heightDp * 15, color: storeTypeColor),
                              SizedBox(width: widthDp * 5),
                              Text(
                                "${storeModel.type}",
                                style: TextStyle(fontSize: fontSp * 11, color: Colors.black),
                              ),
                            ],
                          ),
                        ),

                        ///
                        SizedBox(height: heightDp * 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address :",
                              style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: widthDp * 10),
                            Expanded(
                              child: Text(
                                storeModel.address!,
                                style: TextStyle(fontSize: fontSp * 14),
                              ),
                            ),
                          ],
                        ),

                        ///
                        SizedBox(height: heightDp * 10),
                        if (connectionModel != null &&
                            connectionModel.status == ConnectionStatus.pending &&
                            connectionModel.requestedId == storeModel.id)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              KeicyRaisedButton(
                                width: widthDp * 100,
                                height: heightDp * 30,
                                color: config.Colors().mainColor(1),
                                borderRadius: heightDp * 8,
                                child: Text(
                                  "Accept",
                                  style: TextStyle(
                                    fontSize: fontSp * 14,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  NormalAskDialog.show(
                                    context,
                                    content: "Are you going to accept this request",
                                    callback: () {
                                      Navigator.of(context).pop();
                                      connectionModel.status = ConnectionStatus.active;

                                      _invitationHandler(storeModel, connectionModel);
                                    },
                                  );
                                },
                              ),
                              KeicyRaisedButton(
                                width: widthDp * 100,
                                height: heightDp * 35,
                                color: Colors.white,
                                borderWidth: 1.5,
                                borderColor: Colors.grey.withOpacity(0.8),
                                borderRadius: heightDp * 8,
                                child: Text(
                                  "Reject",
                                  style: TextStyle(
                                    fontSize: fontSp * 14,
                                    color: Colors.grey.withOpacity(1),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  var rejectNote = await ConnectionRejectDialog.show(
                                    context,
                                  );

                                  if (rejectNote == null) {
                                    StoreConnectionDialog.show(
                                      context,
                                      storeModel: storeModel,
                                      connectionModel: connectionModel,
                                      invitationCallback: invitationCallback,
                                    );
                                    return;
                                  }

                                  connectionModel.status = ConnectionStatus.rejected;
                                  connectionModel.rejectNote = rejectNote;

                                  _invitationHandler(storeModel, connectionModel);
                                },
                              )
                            ],
                          )
                        else
                          KeicyRaisedButton(
                            width: widthDp * 100,
                            height: heightDp * 35,
                            color: connectionModel == null || connectionModel.status != "Pending" ? config.Colors().mainColor(1) : Colors.white,
                            borderWidth: 1.5,
                            borderColor:
                                connectionModel == null || connectionModel.status != "Pending" ? Colors.transparent : Colors.grey.withOpacity(0.8),
                            borderRadius: heightDp * 8,
                            child: connectionStatus == "Pending"
                                ? Theme(
                                    data: Theme.of(context).copyWith(brightness: Brightness.dark),
                                    child: CupertinoActivityIndicator(),
                                  )
                                : Text(
                                    connectionModel == null ? "Connect" : connectionModel.status!,
                                    style: TextStyle(
                                      fontSize: fontSp * 14,
                                      color:
                                          connectionModel == null || connectionModel.status != "Pending" ? Colors.white : Colors.grey.withOpacity(1),
                                    ),
                                  ),
                            onPressed: connectionModel == null ? _connectionHandler : null,
                          ),
                      ],
                    ),
                  ),

                  ///
                  SizedBox(height: heightDp * 15),
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.7)),
                  SizedBox(height: heightDp * 15),

                  ///
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description :",
                          style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: widthDp * 10),
                        Text(
                          storeModel.description!,
                          style: TextStyle(fontSize: fontSp * 14),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
