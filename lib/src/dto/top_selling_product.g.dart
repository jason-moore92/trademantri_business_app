// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_selling_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TopSellingProduct _$$_TopSellingProductFromJson(Map<String, dynamic> json) =>
    _$_TopSellingProduct(
      id: json['_id'] as String?,
      count: json['count'] as int?,
      product: json['product'] == null
          ? null
          : ProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_TopSellingProductToJson(
        _$_TopSellingProduct instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'count': instance.count,
      'product': instance.product,
    };
