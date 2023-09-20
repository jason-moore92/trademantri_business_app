import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class RewardPointsListState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? rewardPointsList;
  final Map<String, dynamic>? rewardPointsListData;
  final Map<String, dynamic>? rewardPointsMetaData;
  final bool? isRefresh;

  RewardPointsListState({
    @required this.progressState,
    @required this.message,
    @required this.rewardPointsList,
    @required this.rewardPointsListData,
    @required this.rewardPointsMetaData,
    @required this.isRefresh,
  });

  factory RewardPointsListState.init() {
    return RewardPointsListState(
      progressState: 0,
      message: "",
      rewardPointsList: [],
      rewardPointsListData: Map<String, dynamic>(),
      rewardPointsMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  RewardPointsListState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? rewardPointsList,
    Map<String, dynamic>? rewardPointsListData,
    Map<String, dynamic>? rewardPointsMetaData,
    bool? isRefresh,
  }) {
    return RewardPointsListState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      rewardPointsList: rewardPointsList ?? this.rewardPointsList,
      rewardPointsListData: rewardPointsListData ?? this.rewardPointsListData,
      rewardPointsMetaData: rewardPointsMetaData ?? this.rewardPointsMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  RewardPointsListState update({
    int? progressState,
    String? message,
    List<dynamic>? rewardPointsList,
    Map<String, dynamic>? rewardPointsListData,
    Map<String, dynamic>? rewardPointsMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      rewardPointsList: rewardPointsList,
      rewardPointsListData: rewardPointsListData,
      rewardPointsMetaData: rewardPointsMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "rewardPointsList": rewardPointsList,
      "rewardPointsListData": rewardPointsListData,
      "rewardPointsMetaData": rewardPointsMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        rewardPointsList!,
        rewardPointsListData!,
        rewardPointsMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
