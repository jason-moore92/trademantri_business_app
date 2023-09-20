// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'customer_frequent_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CustomerFrequentOrder _$CustomerFrequentOrderFromJson(
    Map<String, dynamic> json) {
  return _CustomerFrequentOrder.fromJson(json);
}

/// @nodoc
class _$CustomerFrequentOrderTearOff {
  const _$CustomerFrequentOrderTearOff();

  _CustomerFrequentOrder call(
      {@JsonKey(name: "_id") String? id,
      int? totalOrderCount,
      UserModel? user}) {
    return _CustomerFrequentOrder(
      id: id,
      totalOrderCount: totalOrderCount,
      user: user,
    );
  }

  CustomerFrequentOrder fromJson(Map<String, Object?> json) {
    return CustomerFrequentOrder.fromJson(json);
  }
}

/// @nodoc
const $CustomerFrequentOrder = _$CustomerFrequentOrderTearOff();

/// @nodoc
mixin _$CustomerFrequentOrder {
  @JsonKey(name: "_id")
  String? get id => throw _privateConstructorUsedError;
  int? get totalOrderCount => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerFrequentOrderCopyWith<CustomerFrequentOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerFrequentOrderCopyWith<$Res> {
  factory $CustomerFrequentOrderCopyWith(CustomerFrequentOrder value,
          $Res Function(CustomerFrequentOrder) then) =
      _$CustomerFrequentOrderCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: "_id") String? id,
      int? totalOrderCount,
      UserModel? user});
}

/// @nodoc
class _$CustomerFrequentOrderCopyWithImpl<$Res>
    implements $CustomerFrequentOrderCopyWith<$Res> {
  _$CustomerFrequentOrderCopyWithImpl(this._value, this._then);

  final CustomerFrequentOrder _value;
  // ignore: unused_field
  final $Res Function(CustomerFrequentOrder) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? totalOrderCount = freezed,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      totalOrderCount: totalOrderCount == freezed
          ? _value.totalOrderCount
          : totalOrderCount // ignore: cast_nullable_to_non_nullable
              as int?,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ));
  }
}

/// @nodoc
abstract class _$CustomerFrequentOrderCopyWith<$Res>
    implements $CustomerFrequentOrderCopyWith<$Res> {
  factory _$CustomerFrequentOrderCopyWith(_CustomerFrequentOrder value,
          $Res Function(_CustomerFrequentOrder) then) =
      __$CustomerFrequentOrderCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: "_id") String? id,
      int? totalOrderCount,
      UserModel? user});
}

/// @nodoc
class __$CustomerFrequentOrderCopyWithImpl<$Res>
    extends _$CustomerFrequentOrderCopyWithImpl<$Res>
    implements _$CustomerFrequentOrderCopyWith<$Res> {
  __$CustomerFrequentOrderCopyWithImpl(_CustomerFrequentOrder _value,
      $Res Function(_CustomerFrequentOrder) _then)
      : super(_value, (v) => _then(v as _CustomerFrequentOrder));

  @override
  _CustomerFrequentOrder get _value => super._value as _CustomerFrequentOrder;

  @override
  $Res call({
    Object? id = freezed,
    Object? totalOrderCount = freezed,
    Object? user = freezed,
  }) {
    return _then(_CustomerFrequentOrder(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      totalOrderCount: totalOrderCount == freezed
          ? _value.totalOrderCount
          : totalOrderCount // ignore: cast_nullable_to_non_nullable
              as int?,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CustomerFrequentOrder implements _CustomerFrequentOrder {
  _$_CustomerFrequentOrder(
      {@JsonKey(name: "_id") this.id, this.totalOrderCount, this.user});

  factory _$_CustomerFrequentOrder.fromJson(Map<String, dynamic> json) =>
      _$$_CustomerFrequentOrderFromJson(json);

  @override
  @JsonKey(name: "_id")
  final String? id;
  @override
  final int? totalOrderCount;
  @override
  final UserModel? user;

  @override
  String toString() {
    return 'CustomerFrequentOrder(id: $id, totalOrderCount: $totalOrderCount, user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomerFrequentOrder &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.totalOrderCount, totalOrderCount) &&
            const DeepCollectionEquality().equals(other.user, user));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(totalOrderCount),
      const DeepCollectionEquality().hash(user));

  @JsonKey(ignore: true)
  @override
  _$CustomerFrequentOrderCopyWith<_CustomerFrequentOrder> get copyWith =>
      __$CustomerFrequentOrderCopyWithImpl<_CustomerFrequentOrder>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CustomerFrequentOrderToJson(this);
  }
}

abstract class _CustomerFrequentOrder implements CustomerFrequentOrder {
  factory _CustomerFrequentOrder(
      {@JsonKey(name: "_id") String? id,
      int? totalOrderCount,
      UserModel? user}) = _$_CustomerFrequentOrder;

  factory _CustomerFrequentOrder.fromJson(Map<String, dynamic> json) =
      _$_CustomerFrequentOrder.fromJson;

  @override
  @JsonKey(name: "_id")
  String? get id;
  @override
  int? get totalOrderCount;
  @override
  UserModel? get user;
  @override
  @JsonKey(ignore: true)
  _$CustomerFrequentOrderCopyWith<_CustomerFrequentOrder> get copyWith =>
      throw _privateConstructorUsedError;
}
