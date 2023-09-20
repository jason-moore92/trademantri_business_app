import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/index.dart';

class SettlementState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<Settlement>? settlementsListData;
  final Map<String, dynamic>? settlementsMetaData;
  final bool? isRefresh;

  SettlementState({
    @required this.progressState,
    @required this.message,
    @required this.settlementsListData,
    @required this.settlementsMetaData,
    @required this.isRefresh,
  });

  factory SettlementState.init() {
    return SettlementState(
      progressState: 0,
      message: "",
      settlementsListData: [],
      settlementsMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  SettlementState copyWith({
    int? progressState,
    String? message,
    List<Settlement>? settlementsListData,
    Map<String, dynamic>? settlementsMetaData,
    bool? isRefresh,
  }) {
    return SettlementState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      settlementsListData: settlementsListData ?? this.settlementsListData,
      settlementsMetaData: settlementsMetaData ?? this.settlementsMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  SettlementState update({
    int? progressState,
    String? message,
    OrderModel? newOrderModel,
    List<Settlement>? settlementsListData,
    Map<String, dynamic>? settlementsMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      settlementsListData: settlementsListData,
      settlementsMetaData: settlementsMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "settlementsListData": settlementsListData,
      "settlementsMetaData": settlementsMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        settlementsListData!,
        settlementsMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
