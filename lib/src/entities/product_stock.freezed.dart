// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'product_stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ProductStock _$ProductStockFromJson(Map<String, dynamic> json) {
  return _ProductStock.fromJson(json);
}

/// @nodoc
class _$ProductStockTearOff {
  const _$ProductStockTearOff();

  _ProductStock call(
      {String? id,
      String? productId,
      String? notes,
      String? mode,
      String? type,
      double? amount,
      String? storeId,
      ProductModel? product}) {
    return _ProductStock(
      id: id,
      productId: productId,
      notes: notes,
      mode: mode,
      type: type,
      amount: amount,
      storeId: storeId,
      product: product,
    );
  }

  ProductStock fromJson(Map<String, Object?> json) {
    return ProductStock.fromJson(json);
  }
}

/// @nodoc
const $ProductStock = _$ProductStockTearOff();

/// @nodoc
mixin _$ProductStock {
  String? get id => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get mode => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  ProductModel? get product => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductStockCopyWith<ProductStock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductStockCopyWith<$Res> {
  factory $ProductStockCopyWith(
          ProductStock value, $Res Function(ProductStock) then) =
      _$ProductStockCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String? productId,
      String? notes,
      String? mode,
      String? type,
      double? amount,
      String? storeId,
      ProductModel? product});
}

/// @nodoc
class _$ProductStockCopyWithImpl<$Res> implements $ProductStockCopyWith<$Res> {
  _$ProductStockCopyWithImpl(this._value, this._then);

  final ProductStock _value;
  // ignore: unused_field
  final $Res Function(ProductStock) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? productId = freezed,
    Object? notes = freezed,
    Object? mode = freezed,
    Object? type = freezed,
    Object? amount = freezed,
    Object? storeId = freezed,
    Object? product = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: productId == freezed
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      storeId: storeId == freezed
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      product: product == freezed
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductModel?,
    ));
  }
}

/// @nodoc
abstract class _$ProductStockCopyWith<$Res>
    implements $ProductStockCopyWith<$Res> {
  factory _$ProductStockCopyWith(
          _ProductStock value, $Res Function(_ProductStock) then) =
      __$ProductStockCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      String? productId,
      String? notes,
      String? mode,
      String? type,
      double? amount,
      String? storeId,
      ProductModel? product});
}

/// @nodoc
class __$ProductStockCopyWithImpl<$Res> extends _$ProductStockCopyWithImpl<$Res>
    implements _$ProductStockCopyWith<$Res> {
  __$ProductStockCopyWithImpl(
      _ProductStock _value, $Res Function(_ProductStock) _then)
      : super(_value, (v) => _then(v as _ProductStock));

  @override
  _ProductStock get _value => super._value as _ProductStock;

  @override
  $Res call({
    Object? id = freezed,
    Object? productId = freezed,
    Object? notes = freezed,
    Object? mode = freezed,
    Object? type = freezed,
    Object? amount = freezed,
    Object? storeId = freezed,
    Object? product = freezed,
  }) {
    return _then(_ProductStock(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: productId == freezed
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: amount == freezed
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      storeId: storeId == freezed
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      product: product == freezed
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProductStock implements _ProductStock {
  _$_ProductStock(
      {this.id,
      this.productId,
      this.notes,
      this.mode,
      this.type,
      this.amount,
      this.storeId,
      this.product});

  factory _$_ProductStock.fromJson(Map<String, dynamic> json) =>
      _$$_ProductStockFromJson(json);

  @override
  final String? id;
  @override
  final String? productId;
  @override
  final String? notes;
  @override
  final String? mode;
  @override
  final String? type;
  @override
  final double? amount;
  @override
  final String? storeId;
  @override
  final ProductModel? product;

  @override
  String toString() {
    return 'ProductStock(id: $id, productId: $productId, notes: $notes, mode: $mode, type: $type, amount: $amount, storeId: $storeId, product: $product)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductStock &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.productId, productId) &&
            const DeepCollectionEquality().equals(other.notes, notes) &&
            const DeepCollectionEquality().equals(other.mode, mode) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.amount, amount) &&
            const DeepCollectionEquality().equals(other.storeId, storeId) &&
            const DeepCollectionEquality().equals(other.product, product));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(productId),
      const DeepCollectionEquality().hash(notes),
      const DeepCollectionEquality().hash(mode),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(amount),
      const DeepCollectionEquality().hash(storeId),
      const DeepCollectionEquality().hash(product));

  @JsonKey(ignore: true)
  @override
  _$ProductStockCopyWith<_ProductStock> get copyWith =>
      __$ProductStockCopyWithImpl<_ProductStock>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProductStockToJson(this);
  }
}

abstract class _ProductStock implements ProductStock {
  factory _ProductStock(
      {String? id,
      String? productId,
      String? notes,
      String? mode,
      String? type,
      double? amount,
      String? storeId,
      ProductModel? product}) = _$_ProductStock;

  factory _ProductStock.fromJson(Map<String, dynamic> json) =
      _$_ProductStock.fromJson;

  @override
  String? get id;
  @override
  String? get productId;
  @override
  String? get notes;
  @override
  String? get mode;
  @override
  String? get type;
  @override
  double? get amount;
  @override
  String? get storeId;
  @override
  ProductModel? get product;
  @override
  @JsonKey(ignore: true)
  _$ProductStockCopyWith<_ProductStock> get copyWith =>
      throw _privateConstructorUsedError;
}
