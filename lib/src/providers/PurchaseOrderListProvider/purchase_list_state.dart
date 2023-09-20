import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/index.dart';

class PurchaseListState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, List<PurchaseModel>?>? purchaseLists;
  final Map<String, dynamic>? purchaseListMetaData;
  final bool? isRefresh;

  PurchaseListState({
    @required this.progressState,
    @required this.message,
    @required this.purchaseLists,
    @required this.purchaseListMetaData,
    @required this.isRefresh,
  });

  factory PurchaseListState.init() {
    return PurchaseListState(
      progressState: 0,
      message: "",
      purchaseLists: Map<String, List<PurchaseModel>?>(),
      purchaseListMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  PurchaseListState copyWith({
    int? progressState,
    String? message,
    Map<String, List<PurchaseModel>?>? purchaseLists,
    Map<String, dynamic>? purchaseListMetaData,
    bool? isRefresh,
  }) {
    return PurchaseListState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      purchaseLists: purchaseLists ?? this.purchaseLists,
      purchaseListMetaData: purchaseListMetaData ?? this.purchaseListMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  PurchaseListState update({
    int? progressState,
    String? message,
    Map<String, List<PurchaseModel>?>? purchaseLists,
    Map<String, dynamic>? purchaseListMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      purchaseLists: purchaseLists,
      purchaseListMetaData: purchaseListMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "purchaseLists": purchaseLists,
      "purchaseListMetaData": purchaseListMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        purchaseLists!,
        purchaseListMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
