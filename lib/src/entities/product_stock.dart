import 'package:trapp/src/models/index.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_stock.freezed.dart';
part 'product_stock.g.dart';

@freezed
class ProductStock with _$ProductStock {
  factory ProductStock({
    String? id,
    String? productId,
    String? notes,
    String? mode,
    String? type,
    double? amount,
    String? storeId,
    ProductModel? product,
  }) = _ProductStock;

  factory ProductStock.fromJson(Map<String, dynamic> json) => _$ProductStockFromJson(json);
}
