import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class BusinessInvitationsState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? requestedStoreList;
  final Map<String, dynamic>? requestedStoreMetaData;
  final bool? isRequestedRefresh;
  final Map<String, dynamic>? recepientStoreList;
  final Map<String, dynamic>? recepientStoreMetaData;
  final bool? isRecepientRefresh;

  BusinessInvitationsState({
    @required this.progressState,
    @required this.message,
    @required this.requestedStoreList,
    @required this.requestedStoreMetaData,
    @required this.isRequestedRefresh,
    @required this.recepientStoreList,
    @required this.recepientStoreMetaData,
    @required this.isRecepientRefresh,
  });

  factory BusinessInvitationsState.init() {
    return BusinessInvitationsState(
      progressState: 0,
      message: "",
      requestedStoreList: Map<String, dynamic>(),
      requestedStoreMetaData: Map<String, dynamic>(),
      isRequestedRefresh: false,
      recepientStoreList: Map<String, dynamic>(),
      recepientStoreMetaData: Map<String, dynamic>(),
      isRecepientRefresh: false,
    );
  }

  BusinessInvitationsState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeList,
    Map<String, dynamic>? storeMetaData,
    bool? isRefresh,
    Map<String, dynamic>? requestedStoreList,
    Map<String, dynamic>? requestedStoreMetaData,
    bool? isRequestedRefresh,
    Map<String, dynamic>? recepientStoreList,
    Map<String, dynamic>? recepientStoreMetaData,
    bool? isRecepientRefresh,
  }) {
    return BusinessInvitationsState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      requestedStoreList: requestedStoreList ?? this.requestedStoreList,
      requestedStoreMetaData: requestedStoreMetaData ?? this.requestedStoreMetaData,
      isRequestedRefresh: isRequestedRefresh ?? this.isRequestedRefresh,
      recepientStoreList: recepientStoreList ?? this.recepientStoreList,
      recepientStoreMetaData: recepientStoreMetaData ?? this.recepientStoreMetaData,
      isRecepientRefresh: isRecepientRefresh ?? this.isRecepientRefresh,
    );
  }

  BusinessInvitationsState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeList,
    Map<String, dynamic>? storeMetaData,
    bool? isRefresh,
    Map<String, dynamic>? requestedStoreList,
    Map<String, dynamic>? requestedStoreMetaData,
    bool? isRequestedRefresh,
    Map<String, dynamic>? recepientStoreList,
    Map<String, dynamic>? recepientStoreMetaData,
    bool? isRecepientRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      storeList: storeList,
      storeMetaData: storeMetaData,
      isRefresh: isRefresh,
      requestedStoreList: requestedStoreList,
      requestedStoreMetaData: requestedStoreMetaData,
      isRequestedRefresh: isRequestedRefresh,
      recepientStoreList: recepientStoreList,
      recepientStoreMetaData: recepientStoreMetaData,
      isRecepientRefresh: isRecepientRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "requestedStoreList": requestedStoreList,
      "requestedStoreMetaData": requestedStoreMetaData,
      "isRequestedRefresh": isRequestedRefresh,
      "recepientStoreList": recepientStoreList,
      "recepientStoreMetaData": recepientStoreMetaData,
      "isRecepientRefresh": isRecepientRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        requestedStoreList!,
        requestedStoreMetaData!,
        isRequestedRefresh!,
        recepientStoreList!,
        recepientStoreMetaData!,
        isRecepientRefresh!,
      ];

  @override
  bool get stringify => true;
}
