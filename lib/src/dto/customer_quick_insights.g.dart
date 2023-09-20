// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quick_insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CustomerQuickInsights _$$_CustomerQuickInsightsFromJson(
        Map<String, dynamic> json) =>
    _$_CustomerQuickInsights(
      customerSince: json['customerSince'] == null
          ? null
          : DateTime.parse(json['customerSince'] as String),
      totalOrdersAmount: (json['totalOrdersAmount'] as num?)?.toDouble(),
      noOfOrders: (json['noOfOrders'] as num?)?.toDouble(),
      lastPurchaseDate: json['lastPurchaseDate'] == null
          ? null
          : DateTime.parse(json['lastPurchaseDate'] as String),
      lastPurchaseAmount: (json['lastPurchaseAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$_CustomerQuickInsightsToJson(
        _$_CustomerQuickInsights instance) =>
    <String, dynamic>{
      'customerSince': instance.customerSince?.toIso8601String(),
      'totalOrdersAmount': instance.totalOrdersAmount,
      'noOfOrders': instance.noOfOrders,
      'lastPurchaseDate': instance.lastPurchaseDate?.toIso8601String(),
      'lastPurchaseAmount': instance.lastPurchaseAmount,
    };
