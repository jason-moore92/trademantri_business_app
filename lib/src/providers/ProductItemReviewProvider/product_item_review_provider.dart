import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:trapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';

import 'index.dart';

class ProductItemReviewProvider extends ChangeNotifier {
  static ProductItemReviewProvider of(BuildContext context, {bool listen = false}) => Provider.of<ProductItemReviewProvider>(context, listen: listen);

  ProductItemReviewState _productItemReviewState = ProductItemReviewState.init();
  ProductItemReviewState get productItemReviewState => _productItemReviewState;

  void setProductItemReviewState(ProductItemReviewState productItemReviewState, {bool isNotifiable = true}) {
    if (_productItemReviewState != productItemReviewState) {
      _productItemReviewState = productItemReviewState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getProductItemReviewList({@required String? itemId, @required String? type}) async {
    Map<String, dynamic> reviewMetaData = _productItemReviewState.reviewMetaData!;
    List<dynamic> reviewList = _productItemReviewState.reviewList!;

    reviewMetaData = Map<String, dynamic>();
    reviewList = [];

    var result = await ProductItemReviewApiProvider.getReviewList(
      itemId: itemId,
      type: type,
      page: reviewMetaData["nextPage"] ?? 1,
      limit: AppConfig.countLimitForList,
    );

    if (result["success"]) {
      reviewList.addAll(result["data"]["docs"]);
      result["data"].remove("docs");
      reviewMetaData = result["data"];

      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: "",
        reviewList: reviewList,
        reviewMetaData: reviewMetaData,
      );
    } else {
      _productItemReviewState = _productItemReviewState.update(
        progressState: reviewList.isEmpty ? -1 : 2,
        message: result["messsage"],
      );
    }
    notifyListeners();
  }

  Future<void> getAverageRating({@required String? itemId, @required String? type}) async {
    try {
      var result = await ProductItemReviewApiProvider.getAverageRating(itemId: itemId, type: type);

      if (result["success"] && result["data"].isNotEmpty) {
        Map<String, dynamic> averateRatingData = _productItemReviewState.averateRatingData!;
        averateRatingData = result["data"][0];

        _productItemReviewState = _productItemReviewState.update(
          progressState: 2,
          message: "",
          averateRatingData: averateRatingData,
        );
      } else {
        _productItemReviewState = _productItemReviewState.update(
          progressState: 2,
          message: result["messsage"],
        );
      }

      notifyListeners();
    } catch (e) {
      FlutterLogs.logThis(
        tag: "product_item_review_provider",
        level: LogLevel.ERROR,
        subTag: "getAverageRating",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<void> getTopReviewList({@required String? itemId, @required String? type}) async {
    var result = await ProductItemReviewApiProvider.getReviewList(itemId: itemId, type: type, page: 1, limit: 3);

    if (result["success"]) {
      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: "",
        topReviewList: result["data"]["docs"],
        isLoadMore: result["data"]["hasNextPage"],
      );
    } else {
      _productItemReviewState = _productItemReviewState.update(
        progressState: 2,
        message: "",
        topReviewList: [],
        isLoadMore: false,
      );
    }
    notifyListeners();
  }
}
