import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/providers/index.dart';

class ProductBrandBottomSheetDialog {
  static show(BuildContext context, List<dynamic> productBrandList) {
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

    List<dynamic> selectedBrands = [];

    for (var i = 0; i < productBrandList.length; i++) {
      selectedBrands.add(productBrandList[i]);
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
                    "Choose the Brands",
                    style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                  ),
                ),
                SizedBox(height: heightDp * 10),
                ListTile(
                  dense: true,
                  leading: IconButton(
                    icon: Icon(
                      selectedBrands.length == StoreDataProvider.of(context).storeDataState.productBrandList!.length
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank_outlined,
                      size: heightDp * 25,
                      color: config.Colors().mainColor(1),
                    ),
                    onPressed: () {
                      if (selectedBrands.length != StoreDataProvider.of(context).storeDataState.productBrandList!.length) {
                        selectedBrands = [];
                        for (var i = 0; i < StoreDataProvider.of(context).storeDataState.productBrandList!.length; i++) {
                          selectedBrands.add(StoreDataProvider.of(context).storeDataState.productBrandList![i]);
                        }
                      } else {
                        selectedBrands = [];
                      }

                      refreshProvider.refresh();
                    },
                  ),
                  title: Text("ALL Brands", style: TextStyle(fontSize: fontSp * 16)),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6), indent: widthDp * 20, endIndent: widthDp * 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: StoreDataProvider.of(context).storeDataState.productBrandList!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            dense: true,
                            leading: IconButton(
                              icon: Icon(
                                selectedBrands.contains(StoreDataProvider.of(context).storeDataState.productBrandList![index])
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank_outlined,
                                size: heightDp * 25,
                                color: config.Colors().mainColor(1),
                              ),
                              onPressed: () {
                                if (selectedBrands.contains(StoreDataProvider.of(context).storeDataState.productBrandList![index])) {
                                  selectedBrands.remove(StoreDataProvider.of(context).storeDataState.productBrandList![index]);
                                } else {
                                  selectedBrands.add(StoreDataProvider.of(context).storeDataState.productBrandList![index]);
                                }

                                refreshProvider.refresh();
                              },
                            ),
                            title: Text("${StoreDataProvider.of(context).storeDataState.productBrandList![index]}",
                                style: TextStyle(fontSize: fontSp * 16)),
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
                  color: selectedBrands.length != 0 ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                  borderRadius: heightDp * 8,
                  child: Text(
                    "Choose",
                    style: TextStyle(fontSize: fontSp * 14, color: selectedBrands.length != 0 ? Colors.white : Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(selectedBrands);
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
