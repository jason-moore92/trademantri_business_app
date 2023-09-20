import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class RewardPointsForCustomerState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final int? sumRewardPoint;
  final List<dynamic>? rewardPointListData;
  final Map<String, dynamic>? rewardPointMetaData;
  final bool? isRefresh;

  RewardPointsForCustomerState({
    @required this.message,
    @required this.progressState,
    @required this.sumRewardPoint,
    @required this.rewardPointListData,
    @required this.rewardPointMetaData,
    @required this.isRefresh,
  });

  factory RewardPointsForCustomerState.init() {
    return RewardPointsForCustomerState(
      progressState: 0,
      message: "",
      sumRewardPoint: 0,
      rewardPointListData: [],
      rewardPointMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  RewardPointsForCustomerState copyWith({
    int? progressState,
    String? message,
    int? sumRewardPoint,
    List<dynamic>? rewardPointListData,
    Map<String, dynamic>? rewardPointMetaData,
    bool? isRefresh,
  }) {
    return RewardPointsForCustomerState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      sumRewardPoint: sumRewardPoint ?? this.sumRewardPoint,
      rewardPointListData: rewardPointListData ?? this.rewardPointListData,
      rewardPointMetaData: rewardPointMetaData ?? this.rewardPointMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  RewardPointsForCustomerState update({
    int? progressState,
    String? message,
    int? sumRewardPoint,
    List<dynamic>? rewardPointListData,
    Map<String, dynamic>? rewardPointMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      sumRewardPoint: sumRewardPoint,
      rewardPointListData: rewardPointListData,
      rewardPointMetaData: rewardPointMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "sumRewardPoint": sumRewardPoint,
      "rewardPointListData": rewardPointListData,
      "rewardPointMetaData": rewardPointMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        sumRewardPoint!,
        rewardPointListData!,
        rewardPointMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
