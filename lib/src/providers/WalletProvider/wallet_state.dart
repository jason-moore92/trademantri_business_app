import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/index.dart';

class WalletState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final WalletAccount? accountData;
  final Map<String, List<WalletTransaction>>? transactionsListData;
  final Map<String, dynamic>? transactionsMetaData;
  final bool? isRefresh;

  WalletState({
    @required this.progressState,
    @required this.message,
    @required this.accountData,
    @required this.transactionsListData,
    @required this.transactionsMetaData,
    @required this.isRefresh,
  });

  factory WalletState.init() {
    return WalletState(
      progressState: 0,
      message: "",
      accountData: WalletAccount.fromJson({}),
      transactionsListData: Map<String, List<WalletTransaction>>(),
      transactionsMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  WalletState copyWith({
    int? progressState,
    String? message,
    WalletAccount? accountData,
    Map<String, List<WalletTransaction>>? transactionsListData,
    Map<String, dynamic>? transactionsMetaData,
    bool? isRefresh,
  }) {
    return WalletState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      accountData: accountData ?? this.accountData,
      transactionsListData: transactionsListData ?? this.transactionsListData,
      transactionsMetaData: transactionsMetaData ?? this.transactionsMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  WalletState update({
    int? progressState,
    String? message,
    OrderModel? newOrderModel,
    WalletAccount? accountData,
    Map<String, List<WalletTransaction>>? transactionsListData,
    Map<String, dynamic>? transactionsMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      accountData: accountData,
      transactionsListData: transactionsListData,
      transactionsMetaData: transactionsMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "accountData": accountData,
      "transactionsListData": transactionsListData,
      "transactionsMetaData": transactionsMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        accountData!,
        transactionsListData!,
        transactionsMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
