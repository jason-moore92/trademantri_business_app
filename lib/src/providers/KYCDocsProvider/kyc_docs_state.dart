import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class KYCDocsState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? kycDocsData;

  KYCDocsState({
    @required this.progressState,
    @required this.message,
    @required this.kycDocsData,
  });

  factory KYCDocsState.init() {
    return KYCDocsState(
      progressState: 0,
      message: "",
      kycDocsData: Map<String, dynamic>(),
    );
  }

  KYCDocsState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? kycDocsData,
  }) {
    return KYCDocsState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      kycDocsData: kycDocsData ?? this.kycDocsData,
    );
  }

  KYCDocsState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? kycDocsData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      kycDocsData: kycDocsData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "kycDocsData": kycDocsData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        kycDocsData!,
      ];

  @override
  bool get stringify => true;
}
