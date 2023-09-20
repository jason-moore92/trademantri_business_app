import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;

class VideoPickDialog {
  static Future<void> show(
    BuildContext context, {
    int? fileLengthLimit,
    double? limitSize,
    Function(Map<String, dynamic>?)? callback,
  }) async {
    double deviceWidth = 1.sw;
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    GlobalKey<FormState> _formkey = new GlobalKey<FormState>();

    TextEditingController _urlController = TextEditingController();
    FocusNode _urlFocusNode = FocusNode();
    TextEditingController _descriptionController = TextEditingController();
    FocusNode _descriptionFocusNode = FocusNode();

    TextEditingController _tagsController = TextEditingController();
    FocusNode _tagsFocusNode = FocusNode();

    var videpType = await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              Container(
                child: Container(
                  padding: EdgeInsets.all(heightDp * 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: deviceWidth,
                        padding: EdgeInsets.all(heightDp * 10.0),
                        child: Text(
                          "Content and Tools",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: fileLengthLimit != null && fileLengthLimit >= 15
                            ? null
                            : () {
                                Navigator.pop(context, "file");
                              },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.file_present_outlined,
                                    color: (fileLengthLimit != null && fileLengthLimit >= 15) ? Colors.grey : Colors.black.withOpacity(0.7),
                                    size: heightDp * 25.0,
                                  ),
                                  SizedBox(width: widthDp * 10.0),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                      fontSize: fontSp * 16,
                                      color: (fileLengthLimit != null && fileLengthLimit >= 15) ? Colors.grey : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              if (fileLengthLimit != null && fileLengthLimit >= 15)
                                Text(
                                  "You can upload videos at most 15",
                                  style: TextStyle(fontSize: fontSp * 12, color: Colors.red),
                                ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, "youtube");
                        },
                        child: Container(
                          width: deviceWidth,
                          padding: EdgeInsets.all(heightDp * 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.youtube_searched_for, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                              SizedBox(width: widthDp * 10.0),
                              Text(
                                "Youtube",
                                style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
    if (videpType != null) {
      File? videoFile;

      void saveHandler() async {
        FocusScope.of(context).requestFocus(FocusNode());
        if (!_formkey.currentState!.validate()) return;

        if (videpType == "file" && videoFile == null) return;

        Navigator.pop(context);
        if (callback != null) {
          if (videpType == "file") {
            callback({
              "type": "file",
              "file": videoFile,
              "description": _descriptionController.text.trim(),
              "tags": _tagsController.text.trim(),
            });
          } else if (videpType == "youtube") {
            callback({
              "type": "youtube",
              "path": _urlController.text.trim(),
              "description": _descriptionController.text.trim(),
              "tags": _tagsController.text.trim(),
            });
          }
        }
      }

      showDialog(
        context: context,
        builder: (context) {
          return Consumer<RefreshProvider>(builder: (context, statusProvider, _) {
            return SimpleDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 20),
              titlePadding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 20),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Video Info', style: TextStyle(fontSize: fontSp * 18, color: Colors.black)),
                ],
              ),
              children: <Widget>[
                Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      if (videpType == "youtube")
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Youtube Url:",
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                                ),
                                Text(
                                  "  *  ",
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.bold, height: 1),
                                ),
                              ],
                            ),
                            SizedBox(height: heightDp * 5),
                            TextFormField(
                              controller: _urlController,
                              focusNode: _urlFocusNode,
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.8))),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                              ),
                              onChanged: (input) {},
                              validator: (input) {
                                if (input!.trim().isEmpty) return "Please enter youtubeUrl";
                                if (!input.contains("youtube.com/")) return "Please enter youtubeUrl";
                                return null;
                              },
                            ),
                          ],
                        ),

                      if (videpType == "file")
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "File:",
                                      style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                                    ),
                                    Text(
                                      "  *  ",
                                      style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.bold, height: 1),
                                    ),
                                  ],
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.video,
                                    );

                                    if (result != null) {
                                      if (limitSize != null) {
                                        double size = (result.files.single.size / 1024 / 1024);
                                        if (size > limitSize) {
                                          ErrorDialog.show(
                                            context,
                                            widthDp: widthDp,
                                            heightDp: heightDp,
                                            fontSp: fontSp,
                                            text: "This file size is ${size.toStringAsFixed(2)} Mb.\nYou can select the file at most ${limitSize} Mb",
                                          );
                                          return;
                                        }
                                      }

                                      videoFile = File(result.files.single.path!);
                                      statusProvider.refresh();
                                    }
                                  },
                                  color: config.Colors().mainColor(1),
                                  padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 0),
                                  child: Text("Choose", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                                ),
                              ],
                            ),
                            if (videoFile != null)
                              Text(
                                videoFile!.path,
                                style: TextStyle(fontSize: fontSp * 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),

                      ///
                      SizedBox(height: heightDp * 10),
                      Row(
                        children: [
                          Text(
                            "Description:",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                          ),
                          Text(
                            "  *  ",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.red, fontWeight: FontWeight.bold, height: 1),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      TextFormField(
                        controller: _descriptionController,
                        focusNode: _descriptionFocusNode,
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.8))),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                        ),
                        maxLines: 3,
                        onChanged: (input) {},
                        validator: (input) => input!.trim().isEmpty ? "Please enter description" : null,
                      ),

                      ///
                      SizedBox(height: heightDp * 10),
                      Row(
                        children: [
                          Text(
                            "Tags:",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      TextFormField(
                        controller: _tagsController,
                        focusNode: _tagsFocusNode,
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, height: 1),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.8))),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                        ),
                        maxLines: 3,
                        onChanged: (input) {},
                        // validator: (input) => input!.trim().isEmpty ? "Please enter tags" : null,
                      ),

                      ///
                      SizedBox(height: heightDp * 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton(
                            onPressed: saveHandler,
                            color: config.Colors().mainColor(1),
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 3),
                            child: Text("Save", style: TextStyle(fontSize: fontSp * 14, color: Colors.white)),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.grey.withOpacity(0.4),
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 3),
                            child: Text("Cancel", style: TextStyle(fontSize: fontSp * 14, color: Colors.black)),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 20),
                    ],
                  ),
                ),
              ],
            );
          });
        },
      );
    }
  }
}
