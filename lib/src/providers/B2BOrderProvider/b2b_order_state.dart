import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/order_model.dart';

class B2BOrderState extends Equatable {
  final int? sentProgressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? sentMessage;
  final Map<String, dynamic>? sentOrderListData;
  final Map<String, dynamic>? sentOrderMetaData;
  final bool? sentIsRefresh;
  final B2BOrderModel? newB2bOrderModel;
  final int? receivedProgressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? receivedMessage;
  final Map<String, dynamic>? receivedOrderListData;
  final Map<String, dynamic>? receivedOrderMetaData;
  final bool? receivedIsRefresh;

  B2BOrderState({
    @required this.sentProgressState,
    @required this.sentMessage,
    @required this.sentOrderListData,
    @required this.sentOrderMetaData,
    @required this.sentIsRefresh,
    @required this.newB2bOrderModel,
    @required this.receivedProgressState,
    @required this.receivedMessage,
    @required this.receivedOrderListData,
    @required this.receivedOrderMetaData,
    @required this.receivedIsRefresh,
  });

  factory B2BOrderState.init() {
    return B2BOrderState(
      sentProgressState: 0,
      sentMessage: "",
      sentOrderListData: Map<String, dynamic>(),
      sentOrderMetaData: Map<String, dynamic>(),
      sentIsRefresh: false,
      newB2bOrderModel: null,
      receivedProgressState: 0,
      receivedMessage: "",
      receivedOrderListData: Map<String, dynamic>(),
      receivedOrderMetaData: Map<String, dynamic>(),
      receivedIsRefresh: false,
    );
  }

  B2BOrderState copyWith({
    int? sentProgressState,
    String? sentMessage,
    Map<String, dynamic>? sentOrderListData,
    Map<String, dynamic>? sentOrderMetaData,
    bool? sentIsRefresh,
    B2BOrderModel? newB2bOrderModel,
    int? receivedProgressState,
    String? receivedMessage,
    Map<String, dynamic>? receivedOrderListData,
    Map<String, dynamic>? receivedOrderMetaData,
    bool? receivedIsRefresh,
  }) {
    return B2BOrderState(
      sentProgressState: sentProgressState ?? this.sentProgressState,
      sentMessage: sentMessage ?? this.sentMessage,
      sentOrderListData: sentOrderListData ?? this.sentOrderListData,
      sentOrderMetaData: sentOrderMetaData ?? this.sentOrderMetaData,
      sentIsRefresh: sentIsRefresh ?? this.sentIsRefresh,
      newB2bOrderModel: newB2bOrderModel ?? this.newB2bOrderModel,
      receivedProgressState: receivedProgressState ?? this.receivedProgressState,
      receivedMessage: receivedMessage ?? this.receivedMessage,
      receivedOrderListData: receivedOrderListData ?? this.receivedOrderListData,
      receivedOrderMetaData: receivedOrderMetaData ?? this.receivedOrderMetaData,
      receivedIsRefresh: receivedIsRefresh ?? this.receivedIsRefresh,
    );
  }

  B2BOrderState update({
    int? sentProgressState,
    String? sentMessage,
    Map<String, dynamic>? sentOrderListData,
    Map<String, dynamic>? sentOrderMetaData,
    bool? sentIsRefresh,
    B2BOrderModel? newB2bOrderModel,
    int? receivedProgressState,
    String? receivedMessage,
    Map<String, dynamic>? receivedOrderListData,
    Map<String, dynamic>? receivedOrderMetaData,
    bool? receivedIsRefresh,
  }) {
    return copyWith(
      sentProgressState: sentProgressState,
      sentMessage: sentMessage,
      sentOrderListData: sentOrderListData,
      sentOrderMetaData: sentOrderMetaData,
      sentIsRefresh: sentIsRefresh,
      newB2bOrderModel: newB2bOrderModel,
      receivedProgressState: receivedProgressState,
      receivedMessage: receivedMessage,
      receivedOrderListData: receivedOrderListData,
      receivedOrderMetaData: receivedOrderMetaData,
      receivedIsRefresh: receivedIsRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sentProgressState": sentProgressState,
      "sentMessage": sentMessage,
      "sentOrderListData": sentOrderListData,
      "sentOrderMetaData": sentOrderMetaData,
      "sentIsRefresh": sentIsRefresh,
      "newB2bOrderModel": newB2bOrderModel,
      "receivedProgressState": receivedProgressState,
      "receivedMessage": receivedMessage,
      "receivedOrderListData": receivedOrderListData,
      "receivedOrderMetaData": receivedOrderMetaData,
      "receivedIsRefresh": receivedIsRefresh,
    };
  }

  @override
  List<Object> get props => [
        sentProgressState!,
        sentMessage!,
        sentOrderListData!,
        sentOrderMetaData!,
        sentIsRefresh!,
        newB2bOrderModel ?? Object(),
        receivedProgressState!,
        receivedMessage!,
        receivedOrderListData!,
        receivedOrderMetaData!,
        receivedIsRefresh!,
      ];

  @override
  bool get stringify => true;
}
