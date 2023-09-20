import 'dart:convert';

import "package:equatable/equatable.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'index.dart';

class B2BOrderCategory {
  static String invoice = "Invoice";
  static String reverseAuction = "Reverse Auction";
  static String bargain = "Bargain";
}

class B2BOrderType {
  static String pickup = "Pickup";
  static String delivery = "Delivery";
}

class B2BOrderModel extends Equatable {
  String? id;
  String? orderId;
  String? invoiceId;
  StoreModel? myStoreModel;
  StoreModel? businessStoreModel;
  String? category; // Cart, Assistant, Reverse Auction, Bargain,
  String? orderType;
  String? status;
  // String? qrcodeImgUrl;
  String? qrCodeData;
  String? invoicePdfUrl;
  String? invoicePdfUrlForStore;
  List<ProductOrderModel>? products;
  List<ServiceOrderModel>? services;
  // Pickup Data
  DateTime? pickupDateTime;
  // Delivery Data
  AddressModel? deliveryAddress;
  String? deliveryDetails;
  String? description;
  String? paymentFor;
  PaymentDetailModel? paymentDetail;
  DateTime? invoiceDate;
  DateTime? dueDate;
  String? reasonForCancelOrReject;
  String? paymentProofImage;
  List<dynamic>? orderHistorySteps;
  List<dynamic>? orderFutureSteps;
  List<dynamic>? orderHistoryStatus;
  List<dynamic>? orderFutureStatus;
  DateTime? updatedAt;

  B2BOrderModel({
    String? id,
    String? orderId,
    String? invoiceId,
    StoreModel? myStoreModel,
    StoreModel? businessStoreModel,
    String? category,
    String? orderType,
    String? status,
    // String? qrcodeImgUrl,
    String? qrCodeData,
    String? invoicePdfUrl,
    String? invoicePdfUrlForStore,
    List<ProductOrderModel>? products,
    List<ServiceOrderModel>? services,
    DateTime? pickupDateTime,
    AddressModel? deliveryAddress,
    String? deliveryDetails,
    String? description,
    String? paymentFor,
    PaymentDetailModel? paymentDetail,
    DateTime? invoiceDate,
    DateTime? dueDate,
    String? reasonForCancelOrReject,
    String? paymentProofImage,
    List<dynamic>? orderHistorySteps,
    List<dynamic>? orderFutureSteps,
    List<dynamic>? orderHistoryStatus,
    List<dynamic>? orderFutureStatus,
    DateTime? updatedAt,
  }) {
    this.id = id ?? null;
    this.orderId = orderId ?? "";
    this.invoiceId = invoiceId ?? "";
    this.myStoreModel = myStoreModel ?? null;
    this.businessStoreModel = businessStoreModel ?? null;
    this.category = category ?? "";
    this.orderType = orderType ?? "";
    this.status = status ?? "";
    // this.qrcodeImgUrl = qrcodeImgUrl ?? "";
    this.qrCodeData = qrCodeData ?? "";
    this.invoicePdfUrl = invoicePdfUrl ?? "";
    this.invoicePdfUrlForStore = invoicePdfUrlForStore ?? "";
    this.products = products ?? [];
    this.services = services ?? [];
    this.pickupDateTime = pickupDateTime ?? null;
    this.deliveryAddress = deliveryAddress ?? null;
    this.deliveryDetails = deliveryDetails ?? "";
    this.description = description ?? "";
    this.paymentFor = paymentFor ?? "";
    this.paymentDetail = paymentDetail ?? null;
    this.invoiceDate = invoiceDate ?? null;
    this.dueDate = dueDate ?? null;
    this.reasonForCancelOrReject = reasonForCancelOrReject ?? "";
    this.paymentProofImage = paymentProofImage ?? "";
    this.orderHistorySteps = orderHistorySteps ?? [];
    this.orderFutureSteps = orderFutureSteps ?? [];
    this.orderHistoryStatus = orderHistoryStatus ?? [];
    this.orderFutureStatus = orderFutureStatus ?? [];
    this.updatedAt = updatedAt ?? null;
  }

  factory B2BOrderModel.fromJson(Map<String, dynamic> map) {
    map = json.decode(json.encode(map));

    map["products"] = map["products"] ?? [];
    map["services"] = map["services"] ?? [];

    List<ProductOrderModel> products = [];
    List<ServiceOrderModel> services = [];

    for (var i = 0; i < map["products"].length; i++) {
      products.add(ProductOrderModel.fromJson(map["products"][i]));
    }

    for (var i = 0; i < map["services"].length; i++) {
      services.add(ServiceOrderModel.fromJson(map["services"][i]));
    }

    if (map["myStore"] != null && map["myStore"].runtimeType.toString().contains("Map<String, dynamic>")) {
      map["myStore"] = StoreModel.fromJson(map["myStore"]);
    }

    if (map["businessStore"] != null && map["businessStore"].runtimeType.toString().contains("Map<String, dynamic>")) {
      map["businessStore"] = StoreModel.fromJson(map["businessStore"]);
    }

    return B2BOrderModel(
      id: map["_id"] ?? null,
      orderId: map["orderId"] ?? "",
      invoiceId: map["invoiceId"] ?? "",
      myStoreModel: map["myStore"] ?? null,
      businessStoreModel: map["businessStore"] ?? null,
      category: map["category"] ?? "",
      orderType: map["orderType"] ?? "",
      status: map["status"] ?? "",
      // qrcodeImgUrl: map["qrcodeImgUrl"] ?? "",
      qrCodeData: map["qrCodeData"] ?? "",
      invoicePdfUrl: map["invoicePdfUrl"] ?? "",
      invoicePdfUrlForStore: map["invoicePdfUrlForStore"] ?? "",
      products: products,
      services: services,
      pickupDateTime: map["pickupDateTime"] != null ? DateTime.tryParse(map["pickupDateTime"])!.toLocal() : null,
      deliveryAddress: map["deliveryAddress"] != null ? AddressModel.fromJson(map["deliveryAddress"]) : null,
      deliveryDetails: map["deliveryDetails"] ?? "",
      description: map["description"] ?? "",
      paymentFor: map["paymentFor"] ?? "",
      paymentDetail: map["paymentDetail"] != null ? PaymentDetailModel.fromJson(map["paymentDetail"]) : null,
      invoiceDate: map["invoiceDate"] != null ? DateTime.tryParse(map["invoiceDate"])!.toLocal() : null,
      dueDate: map["dueDate"] != null ? DateTime.tryParse(map["dueDate"])!.toLocal() : null,
      reasonForCancelOrReject: map["reasonForCancelOrReject"] ?? "",
      paymentProofImage: map["paymentProofImage"] ?? "",
      orderFutureSteps: map["orderFutureSteps"] ?? [],
      orderHistorySteps: map["orderHistorySteps"] ?? [],
      orderFutureStatus: map["orderFutureStatus"] ?? [],
      orderHistoryStatus: map["orderHistoryStatus"] ?? [],
      updatedAt: map["updatedAt"] != null ? DateTime.tryParse(map["updatedAt"])!.toLocal() : null,
    );
  }

  Map<String, dynamic> toJson() {
    List<dynamic> productsJson = [];
    List<dynamic> servicesJson = [];

    for (var i = 0; i < products!.length; i++) {
      productsJson.add(products![i].toJson());
    }

    for (var i = 0; i < services!.length; i++) {
      servicesJson.add(services![i].toJson());
    }

    return {
      "_id": id ?? null,
      "orderId": orderId ?? "",
      "invoiceId": invoiceId ?? "",
      "myStoreId": myStoreModel!.id ?? "",
      "businessStoreId": businessStoreModel!.id ?? "",
      "category": category ?? "",
      "orderType": orderType ?? "",
      "status": status ?? "",
      // "qrcodeImgUrl": qrcodeImgUrl ?? "",
      "qrCodeData": qrCodeData ?? "",
      "invoicePdfUrl": invoicePdfUrl ?? "",
      "invoicePdfUrlForStore": invoicePdfUrlForStore ?? "",
      "products": productsJson,
      "services": servicesJson,
      "pickupDateTime": pickupDateTime != null ? pickupDateTime!.toUtc().toIso8601String() : null,
      "deliveryAddress": deliveryAddress != null ? deliveryAddress!.toJson() : null,
      "deliveryDetails": deliveryDetails ?? "",
      "description": description ?? "",
      "paymentFor": paymentFor ?? "",
      "paymentDetail": paymentDetail != null ? paymentDetail!.toJson() : null,
      "invoiceDate": invoiceDate != null ? invoiceDate!.toUtc().toIso8601String() : null,
      "dueDate": dueDate != null ? dueDate!.toUtc().toIso8601String() : null,
      "reasonForCancelOrReject": reasonForCancelOrReject ?? "",
      "paymentProofImage": paymentProofImage ?? "",
      "orderHistorySteps": orderHistorySteps ?? [],
      "orderFutureSteps": orderFutureSteps ?? [],
      "orderHistoryStatus": orderHistoryStatus ?? [],
      "orderFutureStatus": orderFutureStatus ?? [],
      "updatedAt": updatedAt != null ? updatedAt!.toUtc().toIso8601String() : null,
    };
  }

  factory B2BOrderModel.copy(B2BOrderModel model) {
    List<ProductOrderModel> products = [];
    List<ServiceOrderModel> services = [];

    for (var i = 0; i < model.products!.length; i++) {
      products.add(ProductOrderModel.fromJson(model.products![i].toJson()));
    }

    for (var i = 0; i < model.services!.length; i++) {
      services.add(ServiceOrderModel.fromJson(model.services![i].toJson()));
    }

    return B2BOrderModel(
      id: model.id,
      orderId: model.orderId,
      invoiceId: model.invoiceId,
      myStoreModel: StoreModel.copy(model.myStoreModel!),
      businessStoreModel: StoreModel.copy(model.businessStoreModel!),
      category: model.category,
      orderType: model.orderType,
      status: model.status,
      // qrcodeImgUrl: model.qrcodeImgUrl,
      qrCodeData: model.qrCodeData,
      invoicePdfUrl: model.invoicePdfUrl,
      invoicePdfUrlForStore: model.invoicePdfUrlForStore,
      products: products,
      services: services,
      pickupDateTime: model.pickupDateTime,
      deliveryAddress: AddressModel.copy(model.deliveryAddress!),
      deliveryDetails: model.deliveryDetails,
      description: model.description,
      paymentFor: model.paymentFor,
      paymentDetail: PaymentDetailModel.copy(model.paymentDetail!),
      invoiceDate: model.invoiceDate,
      dueDate: model.dueDate,
      reasonForCancelOrReject: model.reasonForCancelOrReject,
      paymentProofImage: model.paymentProofImage,
      orderHistorySteps: model.orderHistorySteps,
      orderFutureSteps: model.orderFutureSteps,
      orderHistoryStatus: model.orderHistoryStatus,
      orderFutureStatus: model.orderFutureStatus,
      updatedAt: model.updatedAt,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        orderId!,
        invoiceId!,
        myStoreModel ?? Object(),
        businessStoreModel ?? Object(),
        category!,
        orderType!,
        status!,
        // qrcodeImgUrl!,
        // qrCodeData!,
        invoicePdfUrl!,
        invoicePdfUrlForStore!,
        products!,
        services!,
        pickupDateTime ?? Object(),
        deliveryAddress ?? Object(),
        deliveryDetails!,
        description!,
        paymentFor!,
        paymentDetail!,
        invoiceDate ?? Object(),
        dueDate ?? Object(),
        reasonForCancelOrReject!,
        paymentProofImage!,
        orderHistorySteps!,
        orderFutureSteps!,
        orderHistoryStatus!,
        orderFutureStatus!,
        updatedAt ?? Object(),
      ];

  @override
  bool get stringify => true;
}
