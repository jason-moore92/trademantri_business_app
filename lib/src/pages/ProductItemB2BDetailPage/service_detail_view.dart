import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/elements/review_and_rating_widget.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/ProductItemReviewPage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

class ServiceDetailView extends StatefulWidget {
  final StoreModel? storeModel;
  final String? type;
  final ServiceModel? serviceModel;
  final bool isForCart;

  ServiceDetailView({
    Key? key,
    this.storeModel,
    this.type,
    this.serviceModel,
    this.isForCart = false,
  }) : super(key: key);

  @override
  _ServiceDetailViewState createState() => _ServiceDetailViewState();
}

class _ServiceDetailViewState extends State<ServiceDetailView> {
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

  int _selectedImageIndex = 0;
  int _selectedAddtionalInfoCategory = 0;

  var numFormat = NumberFormat.currency(symbol: "", name: "");

  AuthProvider? _authProvider;
  ProductItemReviewProvider? _productItemReviewProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  String? reviewKey;
  int? selectedCount;

  bool? isNew;

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    _productItemReviewProvider = ProductItemReviewProvider.of(context);
    _authProvider = AuthProvider.of(context);

    reviewKey = "${_authProvider!.authState.businessUserModel!.id}_${widget.serviceModel!.id}_${widget.type}";

    _productItemReviewProvider!.setProductItemReviewState(
      _productItemReviewProvider!.productItemReviewState.update(
        topReviewList: [],
        isLoadMore: false,
        averateRatingData: Map<String, dynamic>(),
      ),
      isNotifiable: false,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _productItemReviewProvider!.getAverageRating(itemId: widget.serviceModel!.id, type: widget.type);

      _productItemReviewProvider!.getTopReviewList(
        itemId: widget.serviceModel!.id,
        type: widget.type,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    // List<dynamic> attributes = [];
    // for (var i = 0; i < widget.serviceModel!.attributes!.length; i++) {
    //   if (widget.serviceModel!.attributes![i]["type"] != "" && widget.serviceModel!.attributes![i]["type"] != null) {
    //     attributes.add(widget.serviceModel!.attributes![i]);
    //   }
    // }
    // widget.serviceModel!.attributes = attributes;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          widget.type == "products" ? "Product Details" : "Service Detials",
          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<ProductItemReviewProvider>(builder: (context, productItemReviewProvider, _) {
        if (productItemReviewProvider.productItemReviewState.progressState == 0) {
          return Center(child: CupertinoActivityIndicator());
        }
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notifiation) {
            notifiation.disallowGlow();
            return true;
          },
          child: Container(
            width: deviceWidth,
            height: deviceHeight - statusbarHeight - appbarHeight,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: deviceWidth,
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
                      child: Column(
                        children: [
                          _productImagePanel(),
                          SizedBox(height: heightDp * 20),
                          _productInfoPanel(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _productImagePanel() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: widthDp * 200,
              height: heightDp * 200,
              child: KeicyAvatarImage(
                url: widget.serviceModel!.images!.isNotEmpty ? widget.serviceModel!.images![_selectedImageIndex] : "",
                width: widthDp * 200,
                height: heightDp * 200,
                backColor: Colors.grey.withOpacity(0.3),
              ),
            ),
            !widget.serviceModel!.isAvailable! ? Image.asset("img/unavailable.png", width: widthDp * 100, fit: BoxFit.fitWidth) : SizedBox(),
          ],
        ),
        if (widget.serviceModel!.images!.isNotEmpty) SizedBox(height: heightDp * 20),
        if (widget.serviceModel!.images!.isNotEmpty)
          Container(
            height: heightDp * 60,
            child: Row(
              children: [
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (notification) {
                      notification.disallowGlow();
                      return true;
                    },
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.serviceModel!.images!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedImageIndex != index) {
                                _selectedImageIndex = index;
                              }
                            });
                          },
                          child: Container(
                            width: widthDp * 70,
                            height: heightDp * 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedImageIndex == index ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                                width: 2,
                              ),
                            ),
                            child: KeicyAvatarImage(
                              url: widget.serviceModel!.images![index],
                              width: widthDp * 70,
                              height: heightDp * 70,
                              backColor: Colors.white,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: widthDp * 10);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _productInfoPanel() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.serviceModel!.name!,
                  style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: widthDp * 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(heightDp * 6),
                ),
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _productItemReviewProvider!.productItemReviewState.averateRatingData!.isEmpty
                          ? "0"
                          : (_productItemReviewProvider!.productItemReviewState.averateRatingData!["totalRating"] /
                                  _productItemReviewProvider!.productItemReviewState.averateRatingData!["totalCount"])
                              .toStringAsFixed(1),
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: widthDp * 5),
                    Icon(Icons.star, size: heightDp * 17, color: Colors.green),
                  ],
                ),
              ),
            ],
          ),

          if (widget.serviceModel!.provided != null)
            Column(
              children: [
                SizedBox(height: heightDp * 5),
                Text(
                  "${widget.serviceModel!.provided}",
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ],
            ),

          ///
          SizedBox(height: heightDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _priceWidget(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      Uri dynamicUrl = await DynamicLinkService.createProductDynamicLink(
                        itemData: widget.serviceModel!.toJson(),
                        storeModel: widget.storeModel,
                        type: widget.type,
                        isForCart: widget.isForCart,
                      );
                      Share.share(dynamicUrl.toString());
                    },
                    child: Icon(Icons.share, size: heightDp * 30, color: config.Colors().mainColor(1)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: heightDp * 20),
          if (widget.serviceModel!.attributes!.isNotEmpty) _attributesDetail(),
          SizedBox(height: heightDp * 20),
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
          SizedBox(height: heightDp * 20),
          _additionalInfoPanel(),
        ],
      ),
    );
  }

  Widget _attributesDetail() {
    return Container(
      width: deviceWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "Custom Fields",
          //   style: TextStyle(fontSize: fontSp * 18, fontWeight: FontWeight.w600, color: Colors.black),
          // ),
          // SizedBox(height: heightDp * 10),
          Column(
            children: List.generate(
              widget.serviceModel!.attributes!.length,
              (index) {
                Map<String, dynamic> attributes = widget.serviceModel!.attributes![index];

                if (attributes["type"] == null) return SizedBox();

                return Column(
                  children: [
                    Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: heightDp * 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "${attributes["type"]}" + (attributes["units"] != null && attributes["units"] != "" ? "(${attributes["units"]})" : ""),
                              style: TextStyle(
                                fontSize: fontSp * 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: widthDp * 5),
                          Expanded(
                            child: Text(
                              "${attributes["value"]}",
                              style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    if (widget.serviceModel!.b2bPriceFrom == 0 && widget.serviceModel!.b2bPriceTo == 0)
      return Text(
        "Price Not Available",
        style: TextStyle(fontSize: fontSp * 14, color: Colors.red, fontWeight: FontWeight.w500),
      );
    return widget.serviceModel!.b2bDiscount == 0
        ? Text(
            "₹ ${numFormat.format(widget.serviceModel!.b2bPriceFrom)}",
            style: TextStyle(fontSize: fontSp * 20, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "₹ ${numFormat.format(widget.serviceModel!.b2bPriceFrom! - widget.serviceModel!.b2bDiscount!)}",
                    style: TextStyle(fontSize: fontSp * 20, color: config.Colors().mainColor(1), fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: widthDp * 10),
                  Text(
                    "₹ ${numFormat.format(widget.serviceModel!.b2bPriceFrom)}",
                    style: TextStyle(
                      fontSize: fontSp * 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 2,
                    ),
                  ),
                ],
              ),
              Text(
                "Saved ₹ ${numFormat.format(widget.serviceModel!.b2bDiscount)}",
                style: TextStyle(fontSize: fontSp * 16, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          );
  }

  Widget _additionalInfoPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _additionalInfoCategoryTab(),
        SizedBox(height: heightDp * 20),
        if (_selectedAddtionalInfoCategory == 0) _descriptionPanel(),
        if (_selectedAddtionalInfoCategory == 1) _reviewPanel(),
      ],
    );
  }

  Widget _additionalInfoCategoryTab() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedAddtionalInfoCategory = 0;
            });
          },
          child: Container(
            width: widthDp * 120,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
            decoration: BoxDecoration(
              color: _selectedAddtionalInfoCategory == 0 ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.4),
            ),
            alignment: Alignment.center,
            child: Text(
              "Description",
              style: TextStyle(
                fontSize: fontSp * 16,
                color: _selectedAddtionalInfoCategory == 0 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedAddtionalInfoCategory = 1;
            });
          },
          child: Container(
            width: widthDp * 120,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 10),
            decoration: BoxDecoration(
              color: _selectedAddtionalInfoCategory == 1 ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.2),
            ),
            alignment: Alignment.center,
            child: Text(
              "Reviews",
              style: TextStyle(
                fontSize: fontSp * 16,
                color: _selectedAddtionalInfoCategory == 1 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _descriptionPanel() {
    return Container(
      child: Text(
        widget.serviceModel!.description == "" ? "No Description" : widget.serviceModel!.description!,
        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
      ),
    );
  }

  Widget _reviewPanel() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !_productItemReviewProvider!.productItemReviewState.isLoadMore!
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProductItemReviewPage(
                            itemData: widget.serviceModel!.toJson(),
                            type: widget.type!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: heightDp * 15),
                      color: Colors.transparent,
                      child: Text(
                        "Show all reviews",
                        style: TextStyle(
                          fontSize: fontSp * 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          decorationColor: Colors.black,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ),
            // KeicyRaisedButton(
            //   width: widthDp * 150,
            //   height: heightDp * 30,
            //   borderRadius: heightDp * 6,
            //   color: config.Colors().mainColor(1),
            //   child: Text(
            //     _authProvider!.authState.loginState == LoginState.IsNotLogin ||
            //             _productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey].isEmpty
            //         ? "Add Review"
            //         : "Edit Review",
            //     style: TextStyle(fontSize: fontSp * 14, color: Colors.white, fontWeight: FontWeight.w500),
            //   ),
            //   onPressed: () async {
            //     // _reviewHandler();
            //   },
            // ),
          ],
        ),
        SizedBox(height: heightDp * 10),

        /// top 3 review list
        Column(
          children: List.generate(
            _productItemReviewProvider!.productItemReviewState.topReviewList!.length,
            (index) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: heightDp * 20),
                    child: ReviewAndRatingWidget(
                      reviewAndRatingData: _productItemReviewProvider!.productItemReviewState.topReviewList![index],
                      isLoading: _productItemReviewProvider!.productItemReviewState.topReviewList![index].isEmpty,
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.4))
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // void _reviewHandler() async {
  //   bool isNew = _productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey].isEmpty;
  //   ReviewAndRatingDialog.show(
  //     context,
  //     _productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey] ?? Map<String, dynamic>(),
  //     callback: (Map<String, dynamic> reviewAndRating) async {
  //       try {
  //         _productItemReviewProvider!.setProductItemReviewState(
  //           _productItemReviewProvider!.productItemReviewState.update(progressState: 1),
  //           isNotifiable: false,
  //         );
  //         await _keicyProgressDialog!.show();
  //         reviewAndRating["userId"] = _authProvider!.authState.userModel!.id;
  //         reviewAndRating["itemId"] = widget.serviceModel!.id;
  //         reviewAndRating["type"] = widget.type;
  //         reviewAndRating["approve"] = false;

  //         if (_productItemReviewProvider!.productItemReviewState.productItemReviewData![reviewKey].isEmpty) {
  //           await _productItemReviewProvider!.createProductItemReview(productItemReview: reviewAndRating);
  //         } else {
  //           await _productItemReviewProvider!.updateProductItemReview(productItemReview: reviewAndRating);
  //         }
  //         await _productItemReviewProvider!.getTopReviewList(
  //           itemId: widget.serviceModel!.id,
  //           type: widget.type,
  //         );
  //         _keicyProgressDialog!.hide();

  //         if (isNew) {
  //           SuccessDialog.show(
  //             context,
  //             heightDp: heightDp,
  //             fontSp: fontSp,
  //             text: "Your review is added. It will have to go through approval process. Once it's approved, you will be able to see it",
  //           );
  //         } else {
  //           SuccessDialog.show(
  //             context,
  //             heightDp: heightDp,
  //             fontSp: fontSp,
  //             text: "Your review is updated. It will have to go through approval process. Once it's approved, you will be able to see it",
  //           );
  //         }
  //       } catch (e) {
  //         print(e);
  //       }
  //     },
  //   );
  // }
}
