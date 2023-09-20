import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/entities/fliter_type.dart';
import 'package:trapp/src/models/index.dart';

part 'customer_monetary_orders_state.freezed.dart';

@freezed
class CustomerMonetaryOrdersState with _$CustomerMonetaryOrdersState {
  factory CustomerMonetaryOrdersState({
    // String? progressState,
    String? errorMessage,
    bool? isRefresh,
    @Default(false) bool isLoading,
    List<OrderModel>? orders,
    Map<String, dynamic>? searchData,
    @Default(FilterType.simple) FilterType filterType,
    @Default([]) List<Map<String, String>> years,
    @Default([]) List<Map<String, String>> months,
  }) = _CustomerMonetaryOrdersState;
}
