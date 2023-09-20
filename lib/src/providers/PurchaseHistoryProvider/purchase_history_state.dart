import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class PurchaseHistoryState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? itemList;
  final Map<String, dynamic>? purchaseData;
  final Map<String, dynamic>? itemListMetaData;
  final bool? isRefresh;

  PurchaseHistoryState({
    @required this.progressState,
    @required this.message,
    @required this.itemList,
    @required this.purchaseData,
    @required this.itemListMetaData,
    @required this.isRefresh,
  });

  factory PurchaseHistoryState.init() {
    return PurchaseHistoryState(
      progressState: 0,
      message: "",
      itemList: Map<String, dynamic>(),
      purchaseData: Map<String, dynamic>(),
      itemListMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  PurchaseHistoryState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? itemList,
    Map<String, dynamic>? purchaseData,
    Map<String, dynamic>? itemListMetaData,
    bool? isRefresh,
  }) {
    return PurchaseHistoryState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      itemList: itemList ?? this.itemList,
      purchaseData: purchaseData ?? this.purchaseData,
      itemListMetaData: itemListMetaData ?? this.itemListMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  PurchaseHistoryState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? itemList,
    Map<String, dynamic>? purchaseData,
    Map<String, dynamic>? itemListMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      itemList: itemList,
      purchaseData: purchaseData,
      itemListMetaData: itemListMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "itemList": itemList,
      "purchaseData": purchaseData,
      "itemListMetaData": itemListMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        itemList!,
        purchaseData!,
        itemListMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
