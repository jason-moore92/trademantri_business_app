import 'dart:ffi';

import "package:equatable/equatable.dart";
import 'package:trapp/src/models/wallet_meta.dart';

class WalletTransfer extends Equatable {
  String? id;
  String? fromAccountId;
  String? toAccountId;

  double? amount;
  double? fromOutStanding;
  double? toOutStanding;
  String? narration;
  WalletMeta? meta;
  bool? isRefund;
  String? parentId;
  bool? settled;
  String? reqReferenceId;

  DateTime? createdAt;
  DateTime? updatedAt;

  WalletTransfer({
    this.id,
    this.fromAccountId = "",
    this.toAccountId = "",
    this.amount = 0.0,
    this.fromOutStanding = 0.0,
    this.toOutStanding = 0.0,
    this.narration = "",
    this.meta,
    this.isRefund = false,
    this.parentId = "",
    this.settled = false,
    this.reqReferenceId = "",
    this.createdAt,
    this.updatedAt,
  });

  factory WalletTransfer.fromJson(Map<String, dynamic> map) {
    return WalletTransfer(
      id: map["_id"] ?? null,
      fromAccountId: map["fromAccountId"] ?? "",
      toAccountId: map["toAccountId"] ?? "",
      amount: map["amount"] ? double.parse(map["amount"].toString()) : 0.0,
      fromOutStanding: map["fromOutStanding"] ? double.parse(map["fromOutStanding"].toString()) : 0.0,
      toOutStanding: map["fromOutStanding"] ? double.parse(map["fromOutStanding"].toString()) : 0.0,
      narration: map["narration"] ?? "",
      meta: map["meta"] ?? WalletMeta.fromJson(map["meta"]),
      isRefund: map["isRefund"],
      parentId: map["parentId"],
      settled: map["settled"],
      reqReferenceId: map["reqReferenceId"],
      updatedAt: map["updatedAt"] != null ? DateTime.tryParse(map["updatedAt"])!.toLocal() : null,
      createdAt: map["createdAt"] != null ? DateTime.tryParse(map["createdAt"])!.toLocal() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "fromAccountId": fromAccountId ?? "",
      "toAccountId": toAccountId ?? "",
      "amount": amount ?? 0.0,
      "fromOutStanding": fromOutStanding ?? 0.0,
      "toOutStanding": toOutStanding ?? 0.0,
      "narration": narration ?? "",
      "meta": meta!.toJson(),
      "isRefund": isRefund,
      "parentId": parentId,
      "settled": settled,
      "reqReferenceId": reqReferenceId,
      "updatedAt": updatedAt != null ? updatedAt!.toUtc().toIso8601String() : null,
      "createdAt": createdAt != null ? createdAt!.toUtc().toIso8601String() : null,
    };
  }

  factory WalletTransfer.copy(WalletTransfer walletAccountModel) {
    return WalletTransfer(
      id: walletAccountModel.id,
      fromAccountId: walletAccountModel.fromAccountId,
      toAccountId: walletAccountModel.toAccountId,
      amount: walletAccountModel.amount,
      fromOutStanding: walletAccountModel.fromOutStanding,
      toOutStanding: walletAccountModel.toOutStanding,
      narration: walletAccountModel.narration,
      meta: WalletMeta.copy(walletAccountModel.meta!),
      isRefund: walletAccountModel.isRefund,
      parentId: walletAccountModel.parentId,
      settled: walletAccountModel.settled,
      reqReferenceId: walletAccountModel.reqReferenceId,
      createdAt: walletAccountModel.createdAt,
      updatedAt: walletAccountModel.updatedAt,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        fromAccountId!,
        toAccountId!,
        amount!,
        fromOutStanding!,
        toOutStanding!,
        narration!,
        meta!,
        isRefund!,
        parentId!,
        settled!,
        reqReferenceId!,
        createdAt!,
        updatedAt!,
      ];

  @override
  bool get stringify => true;
}
