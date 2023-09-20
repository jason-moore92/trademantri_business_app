import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class StoreDataState extends Equatable {
  final int? progressState;
  final String? message;
  final List<dynamic>? productCategoryList;
  final List<dynamic>? productBrandList;
  final List<dynamic>? serviceCategoryList;
  final List<dynamic>? serviceProvidedList;
  final List<dynamic>? productCatalogCategoryList;
  final List<dynamic>? productCatalogSubCategoryList;
  final List<dynamic>? serviceCatalogCategoryList;
  final List<dynamic>? serviceCatalogSubCategoryList;

  StoreDataState({
    @required this.message,
    @required this.progressState,
    @required this.productCategoryList,
    @required this.productBrandList,
    @required this.serviceCategoryList,
    @required this.serviceProvidedList,
    @required this.productCatalogCategoryList,
    @required this.productCatalogSubCategoryList,
    @required this.serviceCatalogCategoryList,
    @required this.serviceCatalogSubCategoryList,
  });

  factory StoreDataState.init() {
    return StoreDataState(
      progressState: 0,
      message: "",
      productCategoryList: [],
      productBrandList: [],
      serviceCategoryList: [],
      serviceProvidedList: [],
      productCatalogCategoryList: [],
      productCatalogSubCategoryList: [],
      serviceCatalogCategoryList: [],
      serviceCatalogSubCategoryList: [],
    );
  }

  StoreDataState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? productCategoryList,
    List<dynamic>? productBrandList,
    List<dynamic>? serviceCategoryList,
    List<dynamic>? serviceProvidedList,
    List<dynamic>? productCatalogCategoryList,
    List<dynamic>? productCatalogSubCategoryList,
    List<dynamic>? serviceCatalogCategoryList,
    List<dynamic>? serviceCatalogSubCategoryList,
  }) {
    return StoreDataState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      productCategoryList: productCategoryList ?? this.productCategoryList,
      productBrandList: productBrandList ?? this.productBrandList,
      serviceCategoryList: serviceCategoryList ?? this.serviceCategoryList,
      serviceProvidedList: serviceProvidedList ?? this.serviceProvidedList,
      productCatalogCategoryList: productCatalogCategoryList ?? this.productCatalogCategoryList,
      productCatalogSubCategoryList: productCatalogSubCategoryList ?? this.productCatalogSubCategoryList,
      serviceCatalogCategoryList: serviceCatalogCategoryList ?? this.serviceCatalogCategoryList,
      serviceCatalogSubCategoryList: serviceCatalogSubCategoryList ?? this.serviceCatalogSubCategoryList,
    );
  }

  StoreDataState update({
    int? progressState,
    String? message,
    List<dynamic>? productCategoryList,
    List<dynamic>? productBrandList,
    List<dynamic>? serviceCategoryList,
    List<dynamic>? serviceProvidedList,
    List<dynamic>? productCatalogCategoryList,
    List<dynamic>? productCatalogSubCategoryList,
    List<dynamic>? serviceCatalogCategoryList,
    List<dynamic>? serviceCatalogSubCategoryList,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      productCategoryList: productCategoryList,
      productBrandList: productBrandList,
      serviceCategoryList: serviceCategoryList,
      serviceProvidedList: serviceProvidedList,
      productCatalogCategoryList: productCatalogCategoryList,
      productCatalogSubCategoryList: productCatalogSubCategoryList,
      serviceCatalogCategoryList: serviceCatalogCategoryList,
      serviceCatalogSubCategoryList: serviceCatalogSubCategoryList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "productCategoryList": productCategoryList,
      "productBrandList": productBrandList,
      "serviceCategoryList": serviceCategoryList,
      "serviceProvidedList": serviceProvidedList,
      "productCatalogCategoryList": productCatalogCategoryList,
      "productCatalogSubCategoryList": productCatalogSubCategoryList,
      "serviceCatalogCategoryList": serviceCatalogCategoryList,
      "serviceCatalogSubCategoryList": serviceCatalogSubCategoryList,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        productCategoryList!,
        productBrandList!,
        serviceCategoryList!,
        serviceProvidedList!,
        productCatalogCategoryList!,
        productCatalogSubCategoryList!,
        serviceCatalogCategoryList!,
        serviceCatalogSubCategoryList!,
      ];

  @override
  bool get stringify => true;
}
