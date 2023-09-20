import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/index.dart';

enum LoginState {
  IsLogin,
  IsNotLogin,
}

class AuthState extends Equatable {
  final int? progressState;
  final String? message;
  final int? errorCode;
  final LoginState? loginState;
  final StoreModel? storeModel;
  final BusinessUserModel? businessUserModel;
  final BusinessCardModel? businessCardModel;
  final Map<String, dynamic>? galleryData;
  final Function? callback;

  AuthState({
    @required this.message,
    @required this.errorCode,
    @required this.progressState,
    @required this.loginState,
    @required this.storeModel,
    @required this.businessUserModel,
    @required this.businessCardModel,
    @required this.galleryData,
    @required this.callback,
  });

  factory AuthState.init() {
    return AuthState(
      errorCode: 0,
      progressState: 0,
      message: "",
      loginState: LoginState.IsNotLogin,
      storeModel: StoreModel(),
      businessUserModel: BusinessUserModel(),
      businessCardModel: BusinessCardModel(),
      galleryData: Map<String, dynamic>(),
      callback: () {},
    );
  }

  AuthState copyWith({
    int? progressState,
    int? errorCode,
    String? message,
    LoginState? loginState,
    StoreModel? storeModel,
    BusinessUserModel? businessUserModel,
    BusinessCardModel? businessCardModel,
    Map<String, dynamic>? galleryData,
    Function? callback,
  }) {
    return AuthState(
      progressState: progressState ?? this.progressState,
      errorCode: errorCode ?? this.errorCode,
      message: message ?? this.message,
      loginState: loginState ?? this.loginState,
      storeModel: storeModel ?? this.storeModel,
      businessUserModel: businessUserModel ?? this.businessUserModel,
      businessCardModel: businessCardModel ?? this.businessCardModel,
      galleryData: galleryData ?? this.galleryData,
      callback: callback ?? this.callback,
    );
  }

  AuthState update({
    int? progressState,
    int? errorCode,
    String? message,
    LoginState? loginState,
    StoreModel? storeModel,
    BusinessUserModel? businessUserModel,
    BusinessCardModel? businessCardModel,
    Map<String, dynamic>? galleryData,
    Function? callback,
  }) {
    return copyWith(
      progressState: progressState,
      errorCode: errorCode,
      message: message,
      loginState: loginState,
      storeModel: storeModel,
      businessUserModel: businessUserModel,
      businessCardModel: businessCardModel,
      galleryData: galleryData,
      callback: callback,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorCode": errorCode,
      "message": message,
      "loginState": loginState,
      "storeModel": storeModel,
      "businessUserModel": businessUserModel,
      "businessCardModel": businessCardModel,
      "galleryData": galleryData,
      "callback": callback,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        errorCode!,
        message!,
        loginState!,
        storeModel!,
        businessUserModel!,
        businessCardModel!,
        galleryData!,
        callback!,
      ];

  @override
  bool get stringify => true;
}
