import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class BusinessConnectionsState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? storeList;
  final Map<String, dynamic>? storeMetaData;
  final bool? isRefresh;

  BusinessConnectionsState({
    @required this.progressState,
    @required this.message,
    @required this.storeList,
    @required this.storeMetaData,
    @required this.isRefresh,
  });

  factory BusinessConnectionsState.init() {
    return BusinessConnectionsState(
      progressState: 0,
      message: "",
      storeList: [],
      storeMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  BusinessConnectionsState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? storeList,
    Map<String, dynamic>? storeMetaData,
    bool? isRefresh,
  }) {
    return BusinessConnectionsState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      storeList: storeList ?? this.storeList,
      storeMetaData: storeMetaData ?? this.storeMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  BusinessConnectionsState update({
    int? progressState,
    String? message,
    List<dynamic>? storeList,
    Map<String, dynamic>? storeMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      storeList: storeList,
      storeMetaData: storeMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "storeList": storeList,
      "storeMetaData": storeMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        storeList!,
        storeMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
