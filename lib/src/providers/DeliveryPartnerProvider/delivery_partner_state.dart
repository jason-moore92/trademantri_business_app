import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class DeliveryPartnerState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? deliveryPartnerData;
  final bool? noDeliveryPartner;
  final List<dynamic>? deliveryPartnerListData;
  final Map<String, dynamic>? deliveryPartnerMetaData;
  final bool? isRefresh;

  DeliveryPartnerState({
    @required this.progressState,
    @required this.message,
    @required this.deliveryPartnerData,
    @required this.noDeliveryPartner,
    @required this.deliveryPartnerListData,
    @required this.deliveryPartnerMetaData,
    @required this.isRefresh,
  });

  factory DeliveryPartnerState.init() {
    return DeliveryPartnerState(
      progressState: 0,
      message: "",
      deliveryPartnerData: [],
      noDeliveryPartner: false,
      deliveryPartnerListData: [],
      deliveryPartnerMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  DeliveryPartnerState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? deliveryPartnerData,
    bool? noDeliveryPartner,
    List<dynamic>? deliveryPartnerListData,
    Map<String, dynamic>? deliveryPartnerMetaData,
    bool? isRefresh,
  }) {
    return DeliveryPartnerState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      deliveryPartnerData: deliveryPartnerData ?? this.deliveryPartnerData,
      noDeliveryPartner: noDeliveryPartner ?? this.noDeliveryPartner,
      deliveryPartnerListData: deliveryPartnerListData ?? this.deliveryPartnerListData,
      deliveryPartnerMetaData: deliveryPartnerMetaData ?? this.deliveryPartnerMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  DeliveryPartnerState update({
    int? progressState,
    String? message,
    List<dynamic>? deliveryPartnerData,
    bool? noDeliveryPartner,
    List<dynamic>? deliveryPartnerListData,
    Map<String, dynamic>? deliveryPartnerMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      deliveryPartnerData: deliveryPartnerData,
      noDeliveryPartner: noDeliveryPartner,
      deliveryPartnerListData: deliveryPartnerListData,
      deliveryPartnerMetaData: deliveryPartnerMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "deliveryPartnerData": deliveryPartnerData,
      "noDeliveryPartner": noDeliveryPartner,
      "deliveryPartnerListData": deliveryPartnerListData,
      "deliveryPartnerMetaData": deliveryPartnerMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        deliveryPartnerData!,
        noDeliveryPartner!,
        deliveryPartnerListData!,
        deliveryPartnerMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
