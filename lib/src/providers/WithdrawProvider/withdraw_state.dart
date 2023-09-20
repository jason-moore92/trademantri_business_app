import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class WithdrawState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? settlementData;

  WithdrawState({
    @required this.progressState,
    @required this.message,
    @required this.settlementData,
  });

  factory WithdrawState.init() {
    return WithdrawState(
      progressState: 0,
      message: "",
      settlementData: Map<String, dynamic>(),
    );
  }

  WithdrawState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? settlementData,
  }) {
    return WithdrawState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      settlementData: settlementData ?? this.settlementData,
    );
  }

  WithdrawState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? settlementData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      settlementData: settlementData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "settlementData": settlementData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        settlementData!,
      ];

  @override
  bool get stringify => true;
}
