import 'dart:ffi';

import "package:equatable/equatable.dart";
import 'package:trapp/src/models/wallet_meta.dart';

class Settlement extends Equatable {
  String? id;
  String? storeId;
  String? userId;

  double? amount;
  String? notes;
  String? status;
  String? referenceNumber;
  String? mode;
  String? method;
  String? rrn;
  Map<String, dynamic>? accountDetails;
  Map<String, dynamic>? bankResponse;
  String? walletTransactionId;
  String? walletRefundId;
  String? failedReason;

  DateTime? createdAt;
  DateTime? updatedAt;

  Settlement({
    this.id,
    this.storeId = "",
    this.userId = "",
    this.amount = 0.0,
    this.notes = "",
    this.status = "",
    this.referenceNumber = "",
    this.mode = "",
    this.method = "",
    this.rrn = "",
    this.accountDetails,
    this.bankResponse,
    this.walletTransactionId,
    this.walletRefundId,
    this.failedReason,
    this.createdAt,
    this.updatedAt,
  });

  factory Settlement.fromJson(Map<String, dynamic> map) {
    return Settlement(
      id: map["_id"] ?? null,
      storeId: map["storeId"] ?? "",
      userId: map["userId"] ?? "",
      amount: map["amount"] != null ? double.parse(map["amount"].toString()) : 0.0,
      notes: map["notes"] ?? "",
      status: map["status"],
      referenceNumber: map["referenceNumber"],
      mode: map["mode"],
      method: map["method"],
      rrn: map["rrn"],
      accountDetails: map["accountDetails"],
      bankResponse: map["bankResponse"],
      walletTransactionId: map["walletTransactionId"],
      walletRefundId: map["walletRefundId"],
      failedReason: map["failedReason"],
      updatedAt: map["updatedAt"] != null ? DateTime.tryParse(map["updatedAt"])!.toLocal() : null,
      createdAt: map["createdAt"] != null ? DateTime.tryParse(map["createdAt"])!.toLocal() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "storeId": storeId ?? "",
      "userId": userId ?? "",
      "amount": amount ?? 0.0,
      "notes": notes ?? "",
      "status": status,
      "referenceNumber": referenceNumber,
      "mode": mode,
      "method": method,
      "rrn": rrn,
      "accountDetails": accountDetails,
      "bankResponse": bankResponse,
      "walletTransactionId": walletTransactionId,
      "walletRefundId": walletRefundId,
      "failedReason": failedReason,
      "updatedAt": updatedAt != null ? updatedAt!.toUtc().toIso8601String() : null,
      "createdAt": createdAt != null ? createdAt!.toUtc().toIso8601String() : null,
    };
  }

  factory Settlement.copy(Settlement settlementModel) {
    return Settlement(
      id: settlementModel.id,
      storeId: settlementModel.storeId,
      userId: settlementModel.userId,
      amount: settlementModel.amount,
      notes: settlementModel.notes,
      status: settlementModel.status,
      referenceNumber: settlementModel.referenceNumber,
      mode: settlementModel.mode,
      method: settlementModel.method,
      rrn: settlementModel.rrn,
      accountDetails: settlementModel.accountDetails,
      bankResponse: settlementModel.bankResponse,
      walletTransactionId: settlementModel.walletTransactionId,
      walletRefundId: settlementModel.walletRefundId,
      failedReason: settlementModel.failedReason,
      createdAt: settlementModel.createdAt,
      updatedAt: settlementModel.updatedAt,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        storeId!,
        userId!,
        amount!,
        notes!,
        status!,
        referenceNumber!,
        mode!,
        method!,
        rrn!,
        accountDetails!,
        bankResponse!,
        walletTransactionId!,
        walletRefundId!,
        failedReason!,
        createdAt!,
        // updatedAt!,
      ];

  @override
  bool get stringify => true;
}
