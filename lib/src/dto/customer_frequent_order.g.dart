// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_frequent_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CustomerFrequentOrder _$$_CustomerFrequentOrderFromJson(
        Map<String, dynamic> json) =>
    _$_CustomerFrequentOrder(
      id: json['_id'] as String?,
      totalOrderCount: json['totalOrderCount'] as int?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CustomerFrequentOrderToJson(
        _$_CustomerFrequentOrder instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'totalOrderCount': instance.totalOrderCount,
      'user': instance.user,
    };
