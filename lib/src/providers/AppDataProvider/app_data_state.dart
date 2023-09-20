import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class AppDataState extends Equatable {
  final int? progressState;
  final String? message;

  AppDataState({
    @required this.message,
    @required this.progressState,
  });

  factory AppDataState.init() {
    return AppDataState(
      progressState: 0,
      message: "",
    );
  }

  AppDataState copyWith({
    int? progressState,
    String? message,
  }) {
    return AppDataState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
    );
  }

  AppDataState update({
    int? progressState,
    String? message,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
      ];

  @override
  bool get stringify => true;
}
