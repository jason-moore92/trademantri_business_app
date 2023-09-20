import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trapp/src/dto/customer_age_group.dart';
import 'package:trapp/src/entities/fliter_type.dart';
import 'package:trapp/src/models/index.dart';

part 'customer_age_group_state.freezed.dart';

@freezed
class CustomerAgeGroupsState with _$CustomerAgeGroupsState {
  factory CustomerAgeGroupsState({
    // String? progressState,
    String? errorMessage,
    bool? isRefresh,
    @Default(false) bool isLoading,
    List<CustomerAgeGroup>? groups,
    Map<String, dynamic>? searchData,
    @Default(FilterType.simple) FilterType filterType,
    @Default([]) List<Map<String, String>> years,
    @Default([]) List<Map<String, String>> months,
  }) = _CustomerAgeGroupsState;
}
