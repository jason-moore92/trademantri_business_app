// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'order_status_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OrderStatusGroup _$OrderStatusGroupFromJson(Map<String, dynamic> json) {
  return _OrderStatusGroup.fromJson(json);
}

/// @nodoc
class _$OrderStatusGroupTearOff {
  const _$OrderStatusGroupTearOff();

  _OrderStatusGroup call({@JsonKey(name: "_id") String? id, int? count}) {
    return _OrderStatusGroup(
      id: id,
      count: count,
    );
  }

  OrderStatusGroup fromJson(Map<String, Object?> json) {
    return OrderStatusGroup.fromJson(json);
  }
}

/// @nodoc
const $OrderStatusGroup = _$OrderStatusGroupTearOff();

/// @nodoc
mixin _$OrderStatusGroup {
  @JsonKey(name: "_id")
  String? get id => throw _privateConstructorUsedError;
  int? get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderStatusGroupCopyWith<OrderStatusGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStatusGroupCopyWith<$Res> {
  factory $OrderStatusGroupCopyWith(
          OrderStatusGroup value, $Res Function(OrderStatusGroup) then) =
      _$OrderStatusGroupCopyWithImpl<$Res>;
  $Res call({@JsonKey(name: "_id") String? id, int? count});
}

/// @nodoc
class _$OrderStatusGroupCopyWithImpl<$Res>
    implements $OrderStatusGroupCopyWith<$Res> {
  _$OrderStatusGroupCopyWithImpl(this._value, this._then);

  final OrderStatusGroup _value;
  // ignore: unused_field
  final $Res Function(OrderStatusGroup) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? count = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$OrderStatusGroupCopyWith<$Res>
    implements $OrderStatusGroupCopyWith<$Res> {
  factory _$OrderStatusGroupCopyWith(
          _OrderStatusGroup value, $Res Function(_OrderStatusGroup) then) =
      __$OrderStatusGroupCopyWithImpl<$Res>;
  @override
  $Res call({@JsonKey(name: "_id") String? id, int? count});
}

/// @nodoc
class __$OrderStatusGroupCopyWithImpl<$Res>
    extends _$OrderStatusGroupCopyWithImpl<$Res>
    implements _$OrderStatusGroupCopyWith<$Res> {
  __$OrderStatusGroupCopyWithImpl(
      _OrderStatusGroup _value, $Res Function(_OrderStatusGroup) _then)
      : super(_value, (v) => _then(v as _OrderStatusGroup));

  @override
  _OrderStatusGroup get _value => super._value as _OrderStatusGroup;

  @override
  $Res call({
    Object? id = freezed,
    Object? count = freezed,
  }) {
    return _then(_OrderStatusGroup(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_OrderStatusGroup implements _OrderStatusGroup {
  _$_OrderStatusGroup({@JsonKey(name: "_id") this.id, this.count});

  factory _$_OrderStatusGroup.fromJson(Map<String, dynamic> json) =>
      _$$_OrderStatusGroupFromJson(json);

  @override
  @JsonKey(name: "_id")
  final String? id;
  @override
  final int? count;

  @override
  String toString() {
    return 'OrderStatusGroup(id: $id, count: $count)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderStatusGroup &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.count, count));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(count));

  @JsonKey(ignore: true)
  @override
  _$OrderStatusGroupCopyWith<_OrderStatusGroup> get copyWith =>
      __$OrderStatusGroupCopyWithImpl<_OrderStatusGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OrderStatusGroupToJson(this);
  }
}

abstract class _OrderStatusGroup implements OrderStatusGroup {
  factory _OrderStatusGroup({@JsonKey(name: "_id") String? id, int? count}) =
      _$_OrderStatusGroup;

  factory _OrderStatusGroup.fromJson(Map<String, dynamic> json) =
      _$_OrderStatusGroup.fromJson;

  @override
  @JsonKey(name: "_id")
  String? get id;
  @override
  int? get count;
  @override
  @JsonKey(ignore: true)
  _$OrderStatusGroupCopyWith<_OrderStatusGroup> get copyWith =>
      throw _privateConstructorUsedError;
}
