import 'dart:ffi';

import "package:equatable/equatable.dart";

class WalletMeta extends Equatable {
  String? id;
  String? orderId;

  WalletMeta({
    this.id,
    this.orderId = "",
  });

  factory WalletMeta.fromJson(Map<String, dynamic> map) {
    return WalletMeta(
      id: map["_id"] ?? null,
      orderId: map["orderId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "orderId": orderId ?? "",
    };
  }

  factory WalletMeta.copy(WalletMeta walletAccountModel) {
    return WalletMeta(
      id: walletAccountModel.id,
      orderId: walletAccountModel.orderId,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        orderId!,
      ];

  @override
  bool get stringify => true;
}
