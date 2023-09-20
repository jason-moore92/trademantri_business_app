import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/entities/product_stock.dart';
import 'package:trapp/src/models/index.dart';

class ProductStockState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? newProductStockData;
  final List<ProductStock>? entryListData;
  final Map<String, dynamic>? entryMetaData;
  final bool? isRefresh;

  ProductStockState({
    @required this.progressState,
    @required this.message,
    @required this.newProductStockData,
    @required this.entryListData,
    @required this.entryMetaData,
    @required this.isRefresh,
  });

  factory ProductStockState.init() {
    return ProductStockState(
      progressState: 0,
      message: "",
      newProductStockData: Map<String, dynamic>(),
      entryListData: [],
      entryMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  ProductStockState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? newProductStockData,
    List<ProductStock>? entryListData,
    Map<String, dynamic>? entryMetaData,
    bool? isRefresh,
  }) {
    return ProductStockState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      newProductStockData: newProductStockData ?? this.newProductStockData,
      entryListData: entryListData ?? this.entryListData,
      entryMetaData: entryMetaData ?? this.entryMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  ProductStockState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? newProductStockData,
    List<ProductStock>? entryListData,
    Map<String, dynamic>? entryMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      newProductStockData: newProductStockData,
      entryListData: entryListData,
      entryMetaData: entryMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "newProductStockData": newProductStockData,
      "entryListData": entryListData,
      "entryMetaData": entryMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        newProductStockData!,
        entryListData!,
        entryMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
