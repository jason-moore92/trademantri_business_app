import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_age_group.freezed.dart';
part 'customer_age_group.g.dart';

/**
 * product that is inclused in no. of orders
 */

@freezed
class CustomerAgeGroup with _$CustomerAgeGroup {
  factory CustomerAgeGroup({
    String? name,
    String? key,
    int? from,
    int? to,
    int? count,
  }) = _CustomerAgeGroup;

  factory CustomerAgeGroup.fromJson(Map<String, dynamic> json) => _$CustomerAgeGroupFromJson(json);
}
