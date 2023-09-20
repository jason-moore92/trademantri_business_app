import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class CatalogServiceListPageState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? serviceListData;
  final Map<String, dynamic>? serviceMetaData;
  final bool? isRefresh;

  CatalogServiceListPageState({
    @required this.message,
    @required this.progressState,
    @required this.serviceListData,
    @required this.serviceMetaData,
    @required this.isRefresh,
  });

  factory CatalogServiceListPageState.init() {
    return CatalogServiceListPageState(
      progressState: 0,
      message: "",
      serviceListData: [],
      serviceMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  CatalogServiceListPageState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? serviceListData,
    Map<String, dynamic>? serviceMetaData,
    bool? isRefresh,
  }) {
    return CatalogServiceListPageState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      serviceListData: serviceListData ?? this.serviceListData,
      serviceMetaData: serviceMetaData ?? this.serviceMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  CatalogServiceListPageState update({
    int? progressState,
    String? message,
    List<dynamic>? serviceListData,
    Map<String, dynamic>? serviceMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      serviceListData: serviceListData,
      serviceMetaData: serviceMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "serviceListData": serviceListData,
      "serviceMetaData": serviceMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        serviceListData!,
        serviceMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
