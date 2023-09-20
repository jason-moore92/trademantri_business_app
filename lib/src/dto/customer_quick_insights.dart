import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_quick_insights.freezed.dart';
part 'customer_quick_insights.g.dart';

/**
 * product that is inclused in no. of orders
 */

@freezed
class CustomerQuickInsights with _$CustomerQuickInsights {
  factory CustomerQuickInsights({
    DateTime? customerSince,
    double? totalOrdersAmount,
    double? noOfOrders,
    DateTime? lastPurchaseDate,
    double? lastPurchaseAmount,
  }) = _CustomerQuickInsights;

  factory CustomerQuickInsights.fromJson(Map<String, dynamic> json) => _$CustomerQuickInsightsFromJson(json);
}
