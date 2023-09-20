import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_order.freezed.dart';
part 'product_order.g.dart';

/**
 * product that is inclused in no. of orders
 */

@freezed
class ProductOrder with _$ProductOrder {
  factory ProductOrder({
    @JsonKey(name: "_id") String? id,
    int? count,
    int? productCount,
    int? serviceCount,
  }) = _ProductOrder;

  factory ProductOrder.fromJson(Map<String, dynamic> json) => _$ProductOrderFromJson(json);
}
