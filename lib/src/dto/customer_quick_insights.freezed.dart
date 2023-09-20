// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'customer_quick_insights.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CustomerQuickInsights _$CustomerQuickInsightsFromJson(
    Map<String, dynamic> json) {
  return _CustomerQuickInsights.fromJson(json);
}

/// @nodoc
class _$CustomerQuickInsightsTearOff {
  const _$CustomerQuickInsightsTearOff();

  _CustomerQuickInsights call(
      {DateTime? customerSince,
      double? totalOrdersAmount,
      double? noOfOrders,
      DateTime? lastPurchaseDate,
      double? lastPurchaseAmount}) {
    return _CustomerQuickInsights(
      customerSince: customerSince,
      totalOrdersAmount: totalOrdersAmount,
      noOfOrders: noOfOrders,
      lastPurchaseDate: lastPurchaseDate,
      lastPurchaseAmount: lastPurchaseAmount,
    );
  }

  CustomerQuickInsights fromJson(Map<String, Object?> json) {
    return CustomerQuickInsights.fromJson(json);
  }
}

/// @nodoc
const $CustomerQuickInsights = _$CustomerQuickInsightsTearOff();

/// @nodoc
mixin _$CustomerQuickInsights {
  DateTime? get customerSince => throw _privateConstructorUsedError;
  double? get totalOrdersAmount => throw _privateConstructorUsedError;
  double? get noOfOrders => throw _privateConstructorUsedError;
  DateTime? get lastPurchaseDate => throw _privateConstructorUsedError;
  double? get lastPurchaseAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerQuickInsightsCopyWith<CustomerQuickInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerQuickInsightsCopyWith<$Res> {
  factory $CustomerQuickInsightsCopyWith(CustomerQuickInsights value,
          $Res Function(CustomerQuickInsights) then) =
      _$CustomerQuickInsightsCopyWithImpl<$Res>;
  $Res call(
      {DateTime? customerSince,
      double? totalOrdersAmount,
      double? noOfOrders,
      DateTime? lastPurchaseDate,
      double? lastPurchaseAmount});
}

/// @nodoc
class _$CustomerQuickInsightsCopyWithImpl<$Res>
    implements $CustomerQuickInsightsCopyWith<$Res> {
  _$CustomerQuickInsightsCopyWithImpl(this._value, this._then);

  final CustomerQuickInsights _value;
  // ignore: unused_field
  final $Res Function(CustomerQuickInsights) _then;

  @override
  $Res call({
    Object? customerSince = freezed,
    Object? totalOrdersAmount = freezed,
    Object? noOfOrders = freezed,
    Object? lastPurchaseDate = freezed,
    Object? lastPurchaseAmount = freezed,
  }) {
    return _then(_value.copyWith(
      customerSince: customerSince == freezed
          ? _value.customerSince
          : customerSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalOrdersAmount: totalOrdersAmount == freezed
          ? _value.totalOrdersAmount
          : totalOrdersAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      noOfOrders: noOfOrders == freezed
          ? _value.noOfOrders
          : noOfOrders // ignore: cast_nullable_to_non_nullable
              as double?,
      lastPurchaseDate: lastPurchaseDate == freezed
          ? _value.lastPurchaseDate
          : lastPurchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastPurchaseAmount: lastPurchaseAmount == freezed
          ? _value.lastPurchaseAmount
          : lastPurchaseAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
abstract class _$CustomerQuickInsightsCopyWith<$Res>
    implements $CustomerQuickInsightsCopyWith<$Res> {
  factory _$CustomerQuickInsightsCopyWith(_CustomerQuickInsights value,
          $Res Function(_CustomerQuickInsights) then) =
      __$CustomerQuickInsightsCopyWithImpl<$Res>;
  @override
  $Res call(
      {DateTime? customerSince,
      double? totalOrdersAmount,
      double? noOfOrders,
      DateTime? lastPurchaseDate,
      double? lastPurchaseAmount});
}

/// @nodoc
class __$CustomerQuickInsightsCopyWithImpl<$Res>
    extends _$CustomerQuickInsightsCopyWithImpl<$Res>
    implements _$CustomerQuickInsightsCopyWith<$Res> {
  __$CustomerQuickInsightsCopyWithImpl(_CustomerQuickInsights _value,
      $Res Function(_CustomerQuickInsights) _then)
      : super(_value, (v) => _then(v as _CustomerQuickInsights));

  @override
  _CustomerQuickInsights get _value => super._value as _CustomerQuickInsights;

  @override
  $Res call({
    Object? customerSince = freezed,
    Object? totalOrdersAmount = freezed,
    Object? noOfOrders = freezed,
    Object? lastPurchaseDate = freezed,
    Object? lastPurchaseAmount = freezed,
  }) {
    return _then(_CustomerQuickInsights(
      customerSince: customerSince == freezed
          ? _value.customerSince
          : customerSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalOrdersAmount: totalOrdersAmount == freezed
          ? _value.totalOrdersAmount
          : totalOrdersAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      noOfOrders: noOfOrders == freezed
          ? _value.noOfOrders
          : noOfOrders // ignore: cast_nullable_to_non_nullable
              as double?,
      lastPurchaseDate: lastPurchaseDate == freezed
          ? _value.lastPurchaseDate
          : lastPurchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastPurchaseAmount: lastPurchaseAmount == freezed
          ? _value.lastPurchaseAmount
          : lastPurchaseAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CustomerQuickInsights implements _CustomerQuickInsights {
  _$_CustomerQuickInsights(
      {this.customerSince,
      this.totalOrdersAmount,
      this.noOfOrders,
      this.lastPurchaseDate,
      this.lastPurchaseAmount});

  factory _$_CustomerQuickInsights.fromJson(Map<String, dynamic> json) =>
      _$$_CustomerQuickInsightsFromJson(json);

  @override
  final DateTime? customerSince;
  @override
  final double? totalOrdersAmount;
  @override
  final double? noOfOrders;
  @override
  final DateTime? lastPurchaseDate;
  @override
  final double? lastPurchaseAmount;

  @override
  String toString() {
    return 'CustomerQuickInsights(customerSince: $customerSince, totalOrdersAmount: $totalOrdersAmount, noOfOrders: $noOfOrders, lastPurchaseDate: $lastPurchaseDate, lastPurchaseAmount: $lastPurchaseAmount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomerQuickInsights &&
            const DeepCollectionEquality()
                .equals(other.customerSince, customerSince) &&
            const DeepCollectionEquality()
                .equals(other.totalOrdersAmount, totalOrdersAmount) &&
            const DeepCollectionEquality()
                .equals(other.noOfOrders, noOfOrders) &&
            const DeepCollectionEquality()
                .equals(other.lastPurchaseDate, lastPurchaseDate) &&
            const DeepCollectionEquality()
                .equals(other.lastPurchaseAmount, lastPurchaseAmount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(customerSince),
      const DeepCollectionEquality().hash(totalOrdersAmount),
      const DeepCollectionEquality().hash(noOfOrders),
      const DeepCollectionEquality().hash(lastPurchaseDate),
      const DeepCollectionEquality().hash(lastPurchaseAmount));

  @JsonKey(ignore: true)
  @override
  _$CustomerQuickInsightsCopyWith<_CustomerQuickInsights> get copyWith =>
      __$CustomerQuickInsightsCopyWithImpl<_CustomerQuickInsights>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CustomerQuickInsightsToJson(this);
  }
}

abstract class _CustomerQuickInsights implements CustomerQuickInsights {
  factory _CustomerQuickInsights(
      {DateTime? customerSince,
      double? totalOrdersAmount,
      double? noOfOrders,
      DateTime? lastPurchaseDate,
      double? lastPurchaseAmount}) = _$_CustomerQuickInsights;

  factory _CustomerQuickInsights.fromJson(Map<String, dynamic> json) =
      _$_CustomerQuickInsights.fromJson;

  @override
  DateTime? get customerSince;
  @override
  double? get totalOrdersAmount;
  @override
  double? get noOfOrders;
  @override
  DateTime? get lastPurchaseDate;
  @override
  double? get lastPurchaseAmount;
  @override
  @JsonKey(ignore: true)
  _$CustomerQuickInsightsCopyWith<_CustomerQuickInsights> get copyWith =>
      throw _privateConstructorUsedError;
}
