import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_status_group.freezed.dart';
part 'order_status_group.g.dart';

/**
 * product that is inclused in no. of orders
 */

@freezed
class OrderStatusGroup with _$OrderStatusGroup {
  factory OrderStatusGroup({
    @JsonKey(name: "_id") String? id,
    int? count,
  }) = _OrderStatusGroup;

  factory OrderStatusGroup.fromJson(Map<String, dynamic> json) => _$OrderStatusGroupFromJson(json);
}
