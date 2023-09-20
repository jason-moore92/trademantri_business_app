import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class BusinessNetworkStatusState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? networkStatus;

  BusinessNetworkStatusState({
    @required this.progressState,
    @required this.message,
    @required this.networkStatus,
  });

  factory BusinessNetworkStatusState.init() {
    return BusinessNetworkStatusState(
      progressState: 0,
      message: "",
      networkStatus: Map<String, dynamic>(),
    );
  }

  BusinessNetworkStatusState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? networkStatus,
  }) {
    return BusinessNetworkStatusState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      networkStatus: networkStatus ?? this.networkStatus,
    );
  }

  BusinessNetworkStatusState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? networkStatus,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      networkStatus: networkStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "networkStatus": networkStatus,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        networkStatus!,
      ];

  @override
  bool get stringify => true;
}
