import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class CatalogProductListPageState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? productListData;
  final Map<String, dynamic>? productMetaData;
  final bool? isRefresh;

  CatalogProductListPageState({
    @required this.message,
    @required this.progressState,
    @required this.productListData,
    @required this.productMetaData,
    @required this.isRefresh,
  });

  factory CatalogProductListPageState.init() {
    return CatalogProductListPageState(
      progressState: 0,
      message: "",
      productListData: [],
      productMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  CatalogProductListPageState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? productListData,
    Map<String, dynamic>? productMetaData,
    bool? isRefresh,
  }) {
    return CatalogProductListPageState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      productListData: productListData ?? this.productListData,
      productMetaData: productMetaData ?? this.productMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  CatalogProductListPageState update({
    int? progressState,
    String? message,
    List<dynamic>? productListData,
    Map<String, dynamic>? productMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      productListData: productListData,
      productMetaData: productMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "productListData": productListData,
      "productMetaData": productMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        productListData!,
        productMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
