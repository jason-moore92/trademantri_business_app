import 'package:trapp/src/models/index.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_selling_product.freezed.dart';
part 'top_selling_product.g.dart';

@freezed
class TopSellingProduct with _$TopSellingProduct {
  factory TopSellingProduct({
    @JsonKey(name: "_id") String? id,
    int? count,
    ProductModel? product,
  }) = _TopSellingProduct;

  factory TopSellingProduct.fromJson(Map<String, dynamic> json) => _$TopSellingProductFromJson(json);
}
