// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProductOrder _$$_ProductOrderFromJson(Map<String, dynamic> json) =>
    _$_ProductOrder(
      id: json['_id'] as String?,
      count: json['count'] as int?,
      productCount: json['productCount'] as int?,
      serviceCount: json['serviceCount'] as int?,
    );

Map<String, dynamic> _$$_ProductOrderToJson(_$_ProductOrder instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'count': instance.count,
      'productCount': instance.productCount,
      'serviceCount': instance.serviceCount,
    };
