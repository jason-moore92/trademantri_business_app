import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class NewCustomerForChatPageState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? customerListData;
  final Map<String, dynamic>? customerListMetaData;
  final bool? isRefresh;

  NewCustomerForChatPageState({
    @required this.progressState,
    @required this.message,
    @required this.customerListData,
    @required this.customerListMetaData,
    @required this.isRefresh,
  });

  factory NewCustomerForChatPageState.init() {
    return NewCustomerForChatPageState(
      progressState: 0,
      message: "",
      customerListData: [],
      customerListMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  NewCustomerForChatPageState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? customerListData,
    Map<String, dynamic>? customerListMetaData,
    bool? isRefresh,
  }) {
    return NewCustomerForChatPageState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      customerListData: customerListData ?? this.customerListData,
      customerListMetaData: customerListMetaData ?? this.customerListMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  NewCustomerForChatPageState update({
    int? progressState,
    String? message,
    List<dynamic>? customerListData,
    Map<String, dynamic>? customerListMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      customerListData: customerListData,
      customerListMetaData: customerListMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "customerListData": customerListData,
      "customerListMetaData": customerListMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        customerListData!,
        customerListMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
