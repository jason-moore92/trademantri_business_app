import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/index.dart';

class ItemSelectDialog {
  static show(
    BuildContext context, {
    @required String? heading,
    @required List<dynamic>? itemList,
    bool barrierDismissible = false,
    Function? callBack,
  }) {
    TextEditingController _controller = TextEditingController();

    double deviceHeight = 1.sh;
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    String? selectedItem;

    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // barrierColor: barrierColor ?? Colors.black.withOpacity(0.3),
      builder: (BuildContext context1) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
          title: Column(
            children: [
              Text(
                heading!,
                style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: heightDp * 10),
              Text(
                "Add New / Select",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          titlePadding: EdgeInsets.only(
            left: heightDp * 10,
            right: heightDp * 10,
            top: heightDp * 20,
            bottom: heightDp * 10,
          ),
          contentPadding: EdgeInsets.only(
            left: heightDp * 0,
            right: heightDp * 0,
            top: heightDp * 10,
            bottom: heightDp * 20,
          ),
          children: [
            Container(
              height: deviceHeight * 0.6,
              child: Column(
                children: [
                  Expanded(
                    child: Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
                      return Column(
                        children: [
                          KeicyRaisedButton(
                            width: widthDp * 120,
                            height: heightDp * 35,
                            color: selectedItem != null || _controller.text.trim().isNotEmpty
                                ? config.Colors().mainColor(1)
                                : Colors.grey.withOpacity(0.6),
                            borderRadius: heightDp * 8,
                            child: Text(
                              "Choose",
                              style: TextStyle(
                                  fontSize: fontSp * 14,
                                  color: selectedItem != null || _controller.text.trim().isNotEmpty ? Colors.white : Colors.black),
                            ),
                            onPressed: selectedItem == null && _controller.text.isEmpty
                                ? null
                                : () {
                                    Navigator.of(context).pop(selectedItem != null ? selectedItem : _controller.text.trim());
                                  },
                          ),
                          SizedBox(height: heightDp * 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: heightDp * 20),
                            child: KeicyTextFormField(
                              controller: _controller,
                              width: double.infinity,
                              height: heightDp * 40,
                              border: Border.all(color: Colors.grey.withOpacity(0.7)),
                              borderRadius: heightDp * 8,
                              contentHorizontalPadding: widthDp * 10,
                              contentVerticalPadding: heightDp * 8,
                              hintText: "+ Add New",
                              hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.7)),
                              textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                              onChangeHandler: (input) {
                                RefreshProvider.of(context).refresh();
                              },
                            ),
                          ),
                          SizedBox(height: heightDp * 15),
                          Expanded(
                            child: NotificationListener<OverscrollIndicatorNotification>(
                              onNotification: (notification) {
                                notification.disallowGlow();
                                return true;
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(itemList!.length, (index) {
                                    if (!itemList[index].toString().toLowerCase().contains(_controller.text.toLowerCase())) {
                                      if (itemList[index] == selectedItem) {
                                        selectedItem = null;
                                        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                                          refreshProvider.refresh();
                                        });
                                      }
                                      return SizedBox();
                                    }

                                    return Column(
                                      children: [
                                        ListTile(
                                          dense: true,
                                          leading: IconButton(
                                            icon: Icon(
                                              selectedItem != null && selectedItem == itemList[index]
                                                  ? Icons.check_box_outlined
                                                  : Icons.check_box_outline_blank_outlined,
                                              size: heightDp * 25,
                                              color: config.Colors().mainColor(1),
                                            ),
                                            onPressed: () {
                                              if (selectedItem != null && selectedItem == itemList[index]) {
                                                selectedItem = null;
                                              } else {
                                                selectedItem = itemList[index];
                                                // _controller.text = selectedItem;
                                              }

                                              refreshProvider.refresh();
                                            },
                                          ),
                                          title: Text("${itemList[index]}", style: TextStyle(fontSize: fontSp * 16, color: Colors.black)),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
