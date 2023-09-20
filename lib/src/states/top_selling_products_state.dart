import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/dto/top_selling_product.dart';
import 'package:trapp/src/entities/fliter_type.dart';

part 'top_selling_products_state.freezed.dart';

@freezed
class TopSellingProductsState with _$TopSellingProductsState {
  factory TopSellingProductsState({
    // String? progressState,
    String? errorMessage,
    bool? isRefresh,
    @Default(false) bool isLoading,
    List<TopSellingProduct>? tsps,
    Map<String, dynamic>? searchData,
    @Default(FilterType.simple) FilterType filterType,
    @Default([]) List<Map<String, String>> years,
    @Default([]) List<Map<String, String>> months,
  }) = _TopSellingProductsState;
}
