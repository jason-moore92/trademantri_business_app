// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'top_selling_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TopSellingProduct _$TopSellingProductFromJson(Map<String, dynamic> json) {
  return _TopSellingProduct.fromJson(json);
}

/// @nodoc
class _$TopSellingProductTearOff {
  const _$TopSellingProductTearOff();

  _TopSellingProduct call(
      {@JsonKey(name: "_id") String? id, int? count, ProductModel? product}) {
    return _TopSellingProduct(
      id: id,
      count: count,
      product: product,
    );
  }

  TopSellingProduct fromJson(Map<String, Object?> json) {
    return TopSellingProduct.fromJson(json);
  }
}

/// @nodoc
const $TopSellingProduct = _$TopSellingProductTearOff();

/// @nodoc
mixin _$TopSellingProduct {
  @JsonKey(name: "_id")
  String? get id => throw _privateConstructorUsedError;
  int? get count => throw _privateConstructorUsedError;
  ProductModel? get product => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TopSellingProductCopyWith<TopSellingProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopSellingProductCopyWith<$Res> {
  factory $TopSellingProductCopyWith(
          TopSellingProduct value, $Res Function(TopSellingProduct) then) =
      _$TopSellingProductCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: "_id") String? id, int? count, ProductModel? product});
}

/// @nodoc
class _$TopSellingProductCopyWithImpl<$Res>
    implements $TopSellingProductCopyWith<$Res> {
  _$TopSellingProductCopyWithImpl(this._value, this._then);

  final TopSellingProduct _value;
  // ignore: unused_field
  final $Res Function(TopSellingProduct) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? count = freezed,
    Object? product = freezed,
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
      product: product == freezed
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductModel?,
    ));
  }
}

/// @nodoc
abstract class _$TopSellingProductCopyWith<$Res>
    implements $TopSellingProductCopyWith<$Res> {
  factory _$TopSellingProductCopyWith(
          _TopSellingProduct value, $Res Function(_TopSellingProduct) then) =
      __$TopSellingProductCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: "_id") String? id, int? count, ProductModel? product});
}

/// @nodoc
class __$TopSellingProductCopyWithImpl<$Res>
    extends _$TopSellingProductCopyWithImpl<$Res>
    implements _$TopSellingProductCopyWith<$Res> {
  __$TopSellingProductCopyWithImpl(
      _TopSellingProduct _value, $Res Function(_TopSellingProduct) _then)
      : super(_value, (v) => _then(v as _TopSellingProduct));

  @override
  _TopSellingProduct get _value => super._value as _TopSellingProduct;

  @override
  $Res call({
    Object? id = freezed,
    Object? count = freezed,
    Object? product = freezed,
  }) {
    return _then(_TopSellingProduct(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      product: product == freezed
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TopSellingProduct implements _TopSellingProduct {
  _$_TopSellingProduct(
      {@JsonKey(name: "_id") this.id, this.count, this.product});

  factory _$_TopSellingProduct.fromJson(Map<String, dynamic> json) =>
      _$$_TopSellingProductFromJson(json);

  @override
  @JsonKey(name: "_id")
  final String? id;
  @override
  final int? count;
  @override
  final ProductModel? product;

  @override
  String toString() {
    return 'TopSellingProduct(id: $id, count: $count, product: $product)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TopSellingProduct &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.count, count) &&
            const DeepCollectionEquality().equals(other.product, product));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(count),
      const DeepCollectionEquality().hash(product));

  @JsonKey(ignore: true)
  @override
  _$TopSellingProductCopyWith<_TopSellingProduct> get copyWith =>
      __$TopSellingProductCopyWithImpl<_TopSellingProduct>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TopSellingProductToJson(this);
  }
}

abstract class _TopSellingProduct implements TopSellingProduct {
  factory _TopSellingProduct(
      {@JsonKey(name: "_id") String? id,
      int? count,
      ProductModel? product}) = _$_TopSellingProduct;

  factory _TopSellingProduct.fromJson(Map<String, dynamic> json) =
      _$_TopSellingProduct.fromJson;

  @override
  @JsonKey(name: "_id")
  String? get id;
  @override
  int? get count;
  @override
  ProductModel? get product;
  @override
  @JsonKey(ignore: true)
  _$TopSellingProductCopyWith<_TopSellingProduct> get copyWith =>
      throw _privateConstructorUsedError;
}
