// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'customer_age_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CustomerAgeGroup _$CustomerAgeGroupFromJson(Map<String, dynamic> json) {
  return _CustomerAgeGroup.fromJson(json);
}

/// @nodoc
class _$CustomerAgeGroupTearOff {
  const _$CustomerAgeGroupTearOff();

  _CustomerAgeGroup call(
      {String? name, String? key, int? from, int? to, int? count}) {
    return _CustomerAgeGroup(
      name: name,
      key: key,
      from: from,
      to: to,
      count: count,
    );
  }

  CustomerAgeGroup fromJson(Map<String, Object?> json) {
    return CustomerAgeGroup.fromJson(json);
  }
}

/// @nodoc
const $CustomerAgeGroup = _$CustomerAgeGroupTearOff();

/// @nodoc
mixin _$CustomerAgeGroup {
  String? get name => throw _privateConstructorUsedError;
  String? get key => throw _privateConstructorUsedError;
  int? get from => throw _privateConstructorUsedError;
  int? get to => throw _privateConstructorUsedError;
  int? get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerAgeGroupCopyWith<CustomerAgeGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerAgeGroupCopyWith<$Res> {
  factory $CustomerAgeGroupCopyWith(
          CustomerAgeGroup value, $Res Function(CustomerAgeGroup) then) =
      _$CustomerAgeGroupCopyWithImpl<$Res>;
  $Res call({String? name, String? key, int? from, int? to, int? count});
}

/// @nodoc
class _$CustomerAgeGroupCopyWithImpl<$Res>
    implements $CustomerAgeGroupCopyWith<$Res> {
  _$CustomerAgeGroupCopyWithImpl(this._value, this._then);

  final CustomerAgeGroup _value;
  // ignore: unused_field
  final $Res Function(CustomerAgeGroup) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? key = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? count = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      from: from == freezed
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as int?,
      to: to == freezed
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as int?,
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$CustomerAgeGroupCopyWith<$Res>
    implements $CustomerAgeGroupCopyWith<$Res> {
  factory _$CustomerAgeGroupCopyWith(
          _CustomerAgeGroup value, $Res Function(_CustomerAgeGroup) then) =
      __$CustomerAgeGroupCopyWithImpl<$Res>;
  @override
  $Res call({String? name, String? key, int? from, int? to, int? count});
}

/// @nodoc
class __$CustomerAgeGroupCopyWithImpl<$Res>
    extends _$CustomerAgeGroupCopyWithImpl<$Res>
    implements _$CustomerAgeGroupCopyWith<$Res> {
  __$CustomerAgeGroupCopyWithImpl(
      _CustomerAgeGroup _value, $Res Function(_CustomerAgeGroup) _then)
      : super(_value, (v) => _then(v as _CustomerAgeGroup));

  @override
  _CustomerAgeGroup get _value => super._value as _CustomerAgeGroup;

  @override
  $Res call({
    Object? name = freezed,
    Object? key = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? count = freezed,
  }) {
    return _then(_CustomerAgeGroup(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      from: from == freezed
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as int?,
      to: to == freezed
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as int?,
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CustomerAgeGroup implements _CustomerAgeGroup {
  _$_CustomerAgeGroup({this.name, this.key, this.from, this.to, this.count});

  factory _$_CustomerAgeGroup.fromJson(Map<String, dynamic> json) =>
      _$$_CustomerAgeGroupFromJson(json);

  @override
  final String? name;
  @override
  final String? key;
  @override
  final int? from;
  @override
  final int? to;
  @override
  final int? count;

  @override
  String toString() {
    return 'CustomerAgeGroup(name: $name, key: $key, from: $from, to: $to, count: $count)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomerAgeGroup &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality().equals(other.from, from) &&
            const DeepCollectionEquality().equals(other.to, to) &&
            const DeepCollectionEquality().equals(other.count, count));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(from),
      const DeepCollectionEquality().hash(to),
      const DeepCollectionEquality().hash(count));

  @JsonKey(ignore: true)
  @override
  _$CustomerAgeGroupCopyWith<_CustomerAgeGroup> get copyWith =>
      __$CustomerAgeGroupCopyWithImpl<_CustomerAgeGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CustomerAgeGroupToJson(this);
  }
}

abstract class _CustomerAgeGroup implements CustomerAgeGroup {
  factory _CustomerAgeGroup(
      {String? name,
      String? key,
      int? from,
      int? to,
      int? count}) = _$_CustomerAgeGroup;

  factory _CustomerAgeGroup.fromJson(Map<String, dynamic> json) =
      _$_CustomerAgeGroup.fromJson;

  @override
  String? get name;
  @override
  String? get key;
  @override
  int? get from;
  @override
  int? get to;
  @override
  int? get count;
  @override
  @JsonKey(ignore: true)
  _$CustomerAgeGroupCopyWith<_CustomerAgeGroup> get copyWith =>
      throw _privateConstructorUsedError;
}
