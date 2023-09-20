import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/index.dart';

class StoreTypeBottomSheetDialog {
  static show(BuildContext context, List<dynamic> selectedStoreTypes) {
    /// Responsive design variables
    double deviceWidth = 0;
    double deviceHeight = 0;
    double widthDp = 0;
    double heightDp = 0;
    double fontSp = 0;
    ///////////////////////////////

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    List<dynamic> _selectedStoreTypes = [];

    List<dynamic> _storeTypes = AppConfig.storeType.split(',');

    for (var i = 0; i < selectedStoreTypes.length; i++) {
      _selectedStoreTypes.add(selectedStoreTypes[i]);
    }

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      // isScrollControlled: false,
      builder: (context) {
        return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
          return Container(
            width: deviceWidth,
            height: deviceHeight,
            padding: EdgeInsets.symmetric(vertical: heightDp * 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(heightDp * 20), topRight: Radius.circular(heightDp * 20)),
            ),
            child: Column(
              children: [
                SizedBox(height: heightDp * 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                  child: Text(
                    "Choose the Store Type",
                    style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                  ),
                ),
                SizedBox(height: heightDp * 10),
                ListTile(
                  dense: true,
                  leading: IconButton(
                    icon: Icon(
                      _selectedStoreTypes.length == _storeTypes.length ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
                      size: heightDp * 25,
                      color: config.Colors().mainColor(1),
                    ),
                    onPressed: () {
                      if (_selectedStoreTypes.length != _storeTypes.length) {
                        _selectedStoreTypes = [];
                        for (var i = 0; i < _storeTypes.length; i++) {
                          _selectedStoreTypes.add(_storeTypes[i]);
                        }
                      } else {
                        _selectedStoreTypes = [];
                      }

                      refreshProvider.refresh();
                    },
                  ),
                  title: Text("ALL Categories", style: TextStyle(fontSize: fontSp * 16)),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6), indent: widthDp * 20, endIndent: widthDp * 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _storeTypes.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            dense: true,
                            leading: IconButton(
                              icon: Icon(
                                _selectedStoreTypes.contains(_storeTypes[index]) ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
                                size: heightDp * 25,
                                color: config.Colors().mainColor(1),
                              ),
                              onPressed: () {
                                if (_selectedStoreTypes.contains(_storeTypes[index])) {
                                  _selectedStoreTypes.remove(_storeTypes[index]);
                                } else {
                                  _selectedStoreTypes.add(_storeTypes[index]);
                                }

                                refreshProvider.refresh();
                              },
                            ),
                            title: Text("${_storeTypes[index]}", style: TextStyle(fontSize: fontSp * 16)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: heightDp * 20),
                KeicyRaisedButton(
                  width: widthDp * 120,
                  height: heightDp * 35,
                  color: _selectedStoreTypes.length != 0 ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                  borderRadius: heightDp * 8,
                  child: Text(
                    "Choose",
                    style: TextStyle(fontSize: fontSp * 14, color: _selectedStoreTypes.length != 0 ? Colors.white : Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(_selectedStoreTypes);
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
