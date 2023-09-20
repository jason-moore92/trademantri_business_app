import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class CouponListState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? couponModels;
  final Map<String, dynamic>? couponMetaData;
  final bool? isRefresh;

  CouponListState({
    @required this.progressState,
    @required this.message,
    @required this.couponModels,
    @required this.couponMetaData,
    @required this.isRefresh,
  });

  factory CouponListState.init() {
    return CouponListState(
      progressState: 0,
      message: "",
      couponModels: Map<String, dynamic>(),
      couponMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  CouponListState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? couponModels,
    Map<String, dynamic>? couponMetaData,
    bool? isRefresh,
  }) {
    return CouponListState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      couponModels: couponModels ?? this.couponModels,
      couponMetaData: couponMetaData ?? this.couponMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  CouponListState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? couponModels,
    Map<String, dynamic>? couponMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      couponModels: couponModels,
      couponMetaData: couponMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "couponModels": couponModels,
      "couponMetaData": couponMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        couponModels!,
        couponMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
