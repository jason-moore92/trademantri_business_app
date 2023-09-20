import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ProductListPage/index.dart';
import 'package:trapp/src/pages/ServiceListPage/index.dart';
import 'package:trapp/src/pages/CustomProductPage/index.dart';

class ProductItemBottomSheet {
  static void show(
    context, {
    @required List<String>? storeIds,
    @required StoreModel? storeModel,
    @required List<ProductModel>? selectedProducts,
    @required List<ServiceModel>? selectedServices,
    @required Function(String, List<dynamic>)? callback,
    bool isShowCustom = true,
    bool isForB2b = false,
    bool showDetailButton = true,
  }) {
    /// Responsive design variables
    double deviceWidth = 0;
    double widthDp = 0;
    double heightDp = 0;
    double fontSp = 0;
    ///////////////////////////////

    /// Responsive design variables
    deviceWidth = 1.sw;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return new Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(heightDp * 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(heightDp * 30),
                  topRight: Radius.circular(heightDp * 30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: deviceWidth,
                    padding: EdgeInsets.all(heightDp * 10.0),
                    child: Text(
                      "Choose Option",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          List<ProductModel>? result = await Navigator.of(context).push<List<ProductModel>?>(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ProductListPage(
                                selectedProducts: selectedProducts,
                                storeIds: storeIds,
                                storeModel: storeModel,
                                isForSelection: true,
                                isForB2b: isForB2b,
                                showDetailButton: showDetailButton,
                              ),
                            ),
                          );

                          if (result != null) {
                            Navigator.of(context).pop();
                            List<dynamic> products = [];
                            for (var i = 0; i < result.length; i++) {
                              products.add(result[i].toJson());
                            }

                            callback!("product", products);
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                          color: Colors.white,
                          elevation: 4,
                          child: Container(
                            width: heightDp * 110,
                            height: heightDp * 130,
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "img/products.png",
                                  width: heightDp * 70,
                                  height: heightDp * 70,
                                ),
                                Text(
                                  "Products",
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          List<ServiceModel>? result = await Navigator.of(context).push<List<ServiceModel>?>(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ServiceListPage(
                                selectedServices: selectedServices,
                                storeIds: storeIds,
                                storeModel: storeModel,
                                isForSelection: true,
                                isForB2b: isForB2b,
                                showDetailButton: showDetailButton,
                              ),
                            ),
                          );

                          if (result != null) {
                            Navigator.of(context).pop();
                            List<dynamic> services = [];
                            for (var i = 0; i < result.length; i++) {
                              services.add(result[i].toJson());
                            }

                            callback!("service", services);
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                          color: Colors.white,
                          elevation: 4,
                          child: Container(
                            width: heightDp * 110,
                            height: heightDp * 130,
                            padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "img/services.png",
                                  width: heightDp * 70,
                                  height: heightDp * 70,
                                ),
                                Text(
                                  "Services",
                                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isShowCustom)
                        GestureDetector(
                          onTap: () async {
                            var result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => CustomProductPage(
                                  callback: callback,
                                ),
                              ),
                            );

                            if (result != null) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                            color: Colors.white,
                            elevation: 4,
                            child: Container(
                              width: heightDp * 110,
                              height: heightDp * 130,
                              padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "img/custom.png",
                                    width: heightDp * 70,
                                    height: heightDp * 70,
                                  ),
                                  Text(
                                    "Custom",
                                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
