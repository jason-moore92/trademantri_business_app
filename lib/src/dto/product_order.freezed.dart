// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'product_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ProductOrder _$ProductOrderFromJson(Map<String, dynamic> json) {
  return _ProductOrder.fromJson(json);
}

/// @nodoc
class _$ProductOrderTearOff {
  const _$ProductOrderTearOff();

  _ProductOrder call(
      {@JsonKey(name: "_id") String? id,
      int? count,
      int? productCount,
      int? serviceCount}) {
    return _ProductOrder(
      id: id,
      count: count,
      productCount: productCount,
      serviceCount: serviceCount,
    );
  }

  ProductOrder fromJson(Map<String, Object?> json) {
    return ProductOrder.fromJson(json);
  }
}

/// @nodoc
const $ProductOrder = _$ProductOrderTearOff();

/// @nodoc
mixin _$ProductOrder {
  @JsonKey(name: "_id")
  String? get id => throw _privateConstructorUsedError;
  int? get count => throw _privateConstructorUsedError;
  int? get productCount => throw _privateConstructorUsedError;
  int? get serviceCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductOrderCopyWith<ProductOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductOrderCopyWith<$Res> {
  factory $ProductOrderCopyWith(
          ProductOrder value, $Res Function(ProductOrder) then) =
      _$ProductOrderCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: "_id") String? id,
      int? count,
      int? productCount,
      int? serviceCount});
}

/// @nodoc
class _$ProductOrderCopyWithImpl<$Res> implements $ProductOrderCopyWith<$Res> {
  _$ProductOrderCopyWithImpl(this._value, this._then);

  final ProductOrder _value;
  // ignore: unused_field
  final $Res Function(ProductOrder) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? count = freezed,
    Object? productCount = freezed,
    Object? serviceCount = freezed,
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
      productCount: productCount == freezed
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceCount: serviceCount == freezed
          ? _value.serviceCount
          : serviceCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$ProductOrderCopyWith<$Res>
    implements $ProductOrderCopyWith<$Res> {
  factory _$ProductOrderCopyWith(
          _ProductOrder value, $Res Function(_ProductOrder) then) =
      __$ProductOrderCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: "_id") String? id,
      int? count,
      int? productCount,
      int? serviceCount});
}

/// @nodoc
class __$ProductOrderCopyWithImpl<$Res> extends _$ProductOrderCopyWithImpl<$Res>
    implements _$ProductOrderCopyWith<$Res> {
  __$ProductOrderCopyWithImpl(
      _ProductOrder _value, $Res Function(_ProductOrder) _then)
      : super(_value, (v) => _then(v as _ProductOrder));

  @override
  _ProductOrder get _value => super._value as _ProductOrder;

  @override
  $Res call({
    Object? id = freezed,
    Object? count = freezed,
    Object? productCount = freezed,
    Object? serviceCount = freezed,
  }) {
    return _then(_ProductOrder(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      productCount: productCount == freezed
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceCount: serviceCount == freezed
          ? _value.serviceCount
          : serviceCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProductOrder implements _ProductOrder {
  _$_ProductOrder(
      {@JsonKey(name: "_id") this.id,
      this.count,
      this.productCount,
      this.serviceCount});

  factory _$_ProductOrder.fromJson(Map<String, dynamic> json) =>
      _$$_ProductOrderFromJson(json);

  @override
  @JsonKey(name: "_id")
  final String? id;
  @override
  final int? count;
  @override
  final int? productCount;
  @override
  final int? serviceCount;

  @override
  String toString() {
    return 'ProductOrder(id: $id, count: $count, productCount: $productCount, serviceCount: $serviceCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductOrder &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.count, count) &&
            const DeepCollectionEquality()
                .equals(other.productCount, productCount) &&
            const DeepCollectionEquality()
                .equals(other.serviceCount, serviceCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(count),
      const DeepCollectionEquality().hash(productCount),
      const DeepCollectionEquality().hash(serviceCount));

  @JsonKey(ignore: true)
  @override
  _$ProductOrderCopyWith<_ProductOrder> get copyWith =>
      __$ProductOrderCopyWithImpl<_ProductOrder>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProductOrderToJson(this);
  }
}

abstract class _ProductOrder implements ProductOrder {
  factory _ProductOrder(
      {@JsonKey(name: "_id") String? id,
      int? count,
      int? productCount,
      int? serviceCount}) = _$_ProductOrder;

  factory _ProductOrder.fromJson(Map<String, dynamic> json) =
      _$_ProductOrder.fromJson;

  @override
  @JsonKey(name: "_id")
  String? get id;
  @override
  int? get count;
  @override
  int? get productCount;
  @override
  int? get serviceCount;
  @override
  @JsonKey(ignore: true)
  _$ProductOrderCopyWith<_ProductOrder> get copyWith =>
      throw _privateConstructorUsedError;
}
