import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class StoreBankDetailState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? storeBankDetail;

  StoreBankDetailState({
    @required this.progressState,
    @required this.message,
    @required this.storeBankDetail,
  });

  factory StoreBankDetailState.init() {
    return StoreBankDetailState(
      progressState: 0,
      message: "",
      storeBankDetail: Map<String, dynamic>(),
    );
  }

  StoreBankDetailState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeBankDetail,
  }) {
    return StoreBankDetailState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      storeBankDetail: storeBankDetail ?? this.storeBankDetail,
    );
  }

  StoreBankDetailState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeBankDetail,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      storeBankDetail: storeBankDetail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "storeBankDetail": storeBankDetail,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        storeBankDetail!,
      ];

  @override
  bool get stringify => true;
}
