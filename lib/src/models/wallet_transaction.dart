import 'dart:ffi';

import "package:equatable/equatable.dart";
import 'package:trapp/src/models/wallet_meta.dart';

class WalletTransaction extends Equatable {
  String? id;
  String? accountId;
  String? otherAccountId;

  double? credit;
  double? debit;
  double? outStanding;
  String? narration;
  WalletMeta? meta;
  bool? isRefund;
  String? parentId;
  WalletTransaction? parent;
  bool? settled;
  String? reqReferenceId;

  DateTime? date;

  WalletTransaction({
    this.id,
    this.accountId = "",
    this.otherAccountId = "",
    this.credit = 0.0,
    this.debit = 0.0,
    this.outStanding = 0.0,
    this.narration = "",
    this.meta,
    this.isRefund = false,
    this.parentId = "",
    this.parent,
    this.settled = false,
    this.reqReferenceId = "",
    this.date,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> map) {
    return WalletTransaction(
      id: map["_id"] ?? null,
      accountId: map["accountId"] ?? "",
      otherAccountId: map["otherAccountId"] ?? "",
      credit: map["credit"] != null ? double.parse(map["credit"].toString()) : 0.0,
      debit: map["debit"] != null ? double.parse(map["debit"].toString()) : 0.0,
      outStanding: map["outStanding"] != null ? double.parse(map["outStanding"].toString()) : 0.0,
      narration: map["narration"] ?? "",
      meta: map["meta"] != null ? WalletMeta.fromJson(map["meta"]) : WalletMeta.fromJson({}),
      isRefund: map["isRefund"],
      parentId: map["parentId"],
      parent: map['parent'] != null ? WalletTransaction.fromJson(map["parent"]) : null,
      settled: map["settled"],
      reqReferenceId: map["reqReferenceId"],
      date: map["date"] != null ? DateTime.tryParse(map["date"])!.toLocal() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "accountId": accountId ?? "",
      "otherAccountId": otherAccountId ?? "",
      "credit": credit ?? 0.0,
      "debit": debit ?? 0.0,
      "outStanding": outStanding ?? 0.0,
      "narration": narration ?? "",
      "meta": meta!.toJson(),
      "isRefund": isRefund,
      "parentId": parentId,
      "settled": settled,
      "reqReferenceId": reqReferenceId,
      "date": date != null ? date!.toUtc().toIso8601String() : null,
    };
  }

  factory WalletTransaction.copy(WalletTransaction model) {
    return WalletTransaction(
      id: model.id,
      accountId: model.accountId,
      otherAccountId: model.otherAccountId,
      credit: model.credit,
      debit: model.debit,
      outStanding: model.outStanding,
      narration: model.narration,
      meta: WalletMeta.copy(model.meta!),
      isRefund: model.isRefund,
      parentId: model.parentId,
      parent: model.parent,
      settled: model.settled,
      reqReferenceId: model.reqReferenceId,
      date: model.date,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        accountId!,
        otherAccountId!,
        credit!,
        debit!,
        outStanding!,
        narration!,
        meta!,
        isRefund!,
        // parentId!,
        //parent,
        settled!,
        reqReferenceId!,
        date!,
      ];

  @override
  bool get stringify => true;
}
