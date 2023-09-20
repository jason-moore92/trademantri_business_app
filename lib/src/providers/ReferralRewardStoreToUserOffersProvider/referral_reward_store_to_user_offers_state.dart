import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class ReferralRewardS2UOffersState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? newReferralRewardS2UOffersData;
  final Map<String, dynamic>? referralRewardOffersListData;
  final Map<String, dynamic>? referralRewardOffersMetaData;
  final bool? isRefresh;

  ReferralRewardS2UOffersState({
    @required this.progressState,
    @required this.message,
    @required this.newReferralRewardS2UOffersData,
    @required this.referralRewardOffersListData,
    @required this.referralRewardOffersMetaData,
    @required this.isRefresh,
  });

  factory ReferralRewardS2UOffersState.init() {
    return ReferralRewardS2UOffersState(
      progressState: 0,
      message: "",
      newReferralRewardS2UOffersData: Map<String, dynamic>(),
      referralRewardOffersListData: Map<String, dynamic>(),
      referralRewardOffersMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  ReferralRewardS2UOffersState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? newReferralRewardS2UOffersData,
    Map<String, dynamic>? referralRewardOffersListData,
    Map<String, dynamic>? referralRewardOffersMetaData,
    bool? isRefresh,
  }) {
    return ReferralRewardS2UOffersState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      newReferralRewardS2UOffersData: newReferralRewardS2UOffersData ?? this.newReferralRewardS2UOffersData,
      referralRewardOffersListData: referralRewardOffersListData ?? this.referralRewardOffersListData,
      referralRewardOffersMetaData: referralRewardOffersMetaData ?? this.referralRewardOffersMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  ReferralRewardS2UOffersState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? newReferralRewardS2UOffersData,
    Map<String, dynamic>? referralRewardOffersListData,
    Map<String, dynamic>? referralRewardOffersMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      newReferralRewardS2UOffersData: newReferralRewardS2UOffersData,
      referralRewardOffersListData: referralRewardOffersListData,
      referralRewardOffersMetaData: referralRewardOffersMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "newReferralRewardS2UOffersData": newReferralRewardS2UOffersData,
      "referralRewardOffersListData": referralRewardOffersListData,
      "referralRewardOffersMetaData": referralRewardOffersMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        newReferralRewardS2UOffersData!,
        referralRewardOffersListData!,
        referralRewardOffersMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
