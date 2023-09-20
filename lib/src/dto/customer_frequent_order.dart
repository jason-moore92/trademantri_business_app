import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/models/index.dart';

part 'customer_frequent_order.freezed.dart';
part 'customer_frequent_order.g.dart';

/**
 * product that is inclused in no. of orders
 */

@freezed
class CustomerFrequentOrder with _$CustomerFrequentOrder {
  factory CustomerFrequentOrder({
    @JsonKey(name: "_id") String? id,
    int? totalOrderCount,
    UserModel? user,
  }) = _CustomerFrequentOrder;

  factory CustomerFrequentOrder.fromJson(Map<String, dynamic> json) => _$CustomerFrequentOrderFromJson(json);
}
