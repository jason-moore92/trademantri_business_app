import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class StoreState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? storeData;

  StoreState({
    @required this.progressState,
    @required this.message,
    @required this.storeData,
  });

  factory StoreState.init() {
    return StoreState(
      progressState: 0,
      message: "",
      storeData: Map<String, dynamic>(),
    );
  }

  StoreState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeData,
  }) {
    return StoreState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      storeData: storeData ?? this.storeData,
    );
  }

  StoreState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? storeData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      storeData: storeData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "storeData": storeData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        storeData!,
      ];

  @override
  bool get stringify => true;
}
