// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ProductStock _$$_ProductStockFromJson(Map<String, dynamic> json) =>
    _$_ProductStock(
      id: json['id'] as String?,
      productId: json['productId'] as String?,
      notes: json['notes'] as String?,
      mode: json['mode'] as String?,
      type: json['type'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      storeId: json['storeId'] as String?,
      product: json['product'] == null
          ? null
          : ProductModel.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ProductStockToJson(_$_ProductStock instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'notes': instance.notes,
      'mode': instance.mode,
      'type': instance.type,
      'amount': instance.amount,
      'storeId': instance.storeId,
      'product': instance.product,
    };
