import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/dto/product_order.dart';
import 'package:trapp/src/entities/fliter_type.dart';
import 'package:trapp/src/models/index.dart';

part 'product_orders_state.freezed.dart';

@freezed
class ProductOrdersState with _$ProductOrdersState {
  factory ProductOrdersState({
    // String? progressState,
    String? errorMessage,
    bool? isRefresh,
    @Default(false) bool isLoading,
    List<ProductOrder>? pos,
    Map<String, dynamic>? searchData,
    ProductModel? product,
    @Default(FilterType.simple) FilterType filterType,
    @Default([]) List<Map<String, String>> years,
    @Default([]) List<Map<String, String>> months,
    @Default([]) List<Map<String, String>> weekNumbers,
  }) = _ProductOrdersState;
}
