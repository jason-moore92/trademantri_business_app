import 'dart:ffi';

import "package:equatable/equatable.dart";

class WalletAccount extends Equatable {
  String? id;
  String? storeId;
  double? balance;
  double? unSettledBalance;
  double? settledBalance;
  bool? allowOverdraft;
  String? createdAt;
  String? updatedAt;

  WalletAccount({
    this.id,
    this.storeId = "",
    this.balance = 0.0,
    this.unSettledBalance = 0.0,
    this.settledBalance = 0.0,
    this.allowOverdraft = false,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletAccount.fromJson(Map<String, dynamic> map) {
    return WalletAccount(
      id: map["_id"] ?? null,
      storeId: map["storeId"] ?? "",
      balance: map["balance"] != null ? double.parse(map["balance"].toString()) : 0.0,
      unSettledBalance: map["unSettledBalance"] != null ? double.parse(map["unSettledBalance"].toString()) : 0.0,
      settledBalance: map["settledBalance"] != null ? double.parse(map["settledBalance"].toString()) : 0.0,
      allowOverdraft: map["allowOverdraft"],
      createdAt: map["createdAt"] ?? "",
      updatedAt: map["updatedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "storeId": storeId ?? "",
      "balance": balance ?? 0.0,
      "unSettledBalance": unSettledBalance ?? 0.0,
      "settledBalance": settledBalance ?? 0.0,
      "allowOverdraft": allowOverdraft,
      "createdAt": createdAt ?? "",
      "updatedAt": updatedAt ?? "",
    };
  }

  factory WalletAccount.copy(WalletAccount walletAccountModel) {
    return WalletAccount(
      id: walletAccountModel.id,
      storeId: walletAccountModel.storeId,
      balance: walletAccountModel.balance,
      unSettledBalance: walletAccountModel.unSettledBalance,
      settledBalance: walletAccountModel.settledBalance,
      allowOverdraft: walletAccountModel.allowOverdraft,
      createdAt: walletAccountModel.createdAt,
      updatedAt: walletAccountModel.updatedAt,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        storeId!,
        balance!,
        unSettledBalance!,
        settledBalance!,
        allowOverdraft!,
        createdAt!,
        updatedAt!,
      ];

  @override
  bool get stringify => true;
}
