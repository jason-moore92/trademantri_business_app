import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/dto/customer_frequent_order.dart';
import 'package:trapp/src/entities/fliter_type.dart';

part 'customer_frequent_orders_state.freezed.dart';

@freezed
class CustomerFrequentOrdersState with _$CustomerFrequentOrdersState {
  factory CustomerFrequentOrdersState({
    // String? progressState,
    String? errorMessage,
    bool? isRefresh,
    @Default(false) bool isLoading,
    List<CustomerFrequentOrder>? cfos,
    Map<String, dynamic>? searchData,
    @Default(FilterType.simple) FilterType filterType,
    @Default([]) List<Map<String, String>> years,
    @Default([]) List<Map<String, String>> months,
  }) = _CustomerFrequentOrdersState;
}
