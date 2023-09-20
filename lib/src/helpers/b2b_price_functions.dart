import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/src/models/index.dart';

class B2BPriceFunctions {
  static NumberFormat numFormat = NumberFormat.currency(symbol: "", name: "");

  static double getTotalOrignPrice({@required B2BOrderModel? b2bOrderModel}) {
    double totalPrice = 0;
    for (var i = 0; i < b2bOrderModel!.products!.length; i++) {
      ProductOrderModel productOrderModel = b2bOrderModel.products![i];
      totalPrice += productOrderModel.orderQuantity! * productOrderModel.orderPrice!;
    }

    for (var i = 0; i < b2bOrderModel.services!.length; i++) {
      ServiceOrderModel serviceOrderModel = b2bOrderModel.services![i];
      totalPrice += serviceOrderModel.orderQuantity! * serviceOrderModel.orderPrice!;
    }

    return totalPrice;
  }

  static double getTotalPrice({@required B2BOrderModel? b2bOrderModel}) {
    double totalPrice = 0;
    for (var i = 0; i < b2bOrderModel!.products!.length; i++) {
      ProductOrderModel productOrderModel = b2bOrderModel.products![i];
      totalPrice += productOrderModel.orderQuantity! *
          (productOrderModel.orderPrice! - productOrderModel.couponDiscount! - productOrderModel.promocodeDiscount!);
    }

    for (var i = 0; i < b2bOrderModel.services!.length; i++) {
      ServiceOrderModel serviceOrderModel = b2bOrderModel.services![i];
      totalPrice += serviceOrderModel.orderQuantity! *
          (serviceOrderModel.orderPrice! - serviceOrderModel.couponDiscount! - serviceOrderModel.promocodeDiscount!);
    }

    return totalPrice;
  }

  static void calculateDiscount({@required B2BOrderModel? b2bOrderModel}) {
    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    for (var i = 0; i < b2bOrderModel!.products!.length; i++) {
      b2bOrderModel.products![i].couponQuantity = b2bOrderModel.products![i].orderQuantity;
      b2bOrderModel.products![i].promocodePercent = 0;
      b2bOrderModel.products![i].promocodeDiscount = 0;
      b2bOrderModel.products![i].couponDiscount = 0;
    }

    for (var i = 0; i < b2bOrderModel.services!.length; i++) {
      b2bOrderModel.services![i].couponQuantity = b2bOrderModel.services![i].orderQuantity;
      b2bOrderModel.services![i].promocodePercent = 0;
      b2bOrderModel.services![i].promocodeDiscount = 0;
      b2bOrderModel.services![i].couponDiscount = 0;
    }
    // b2bOrderModel.bogoProducts = [];
    // b2bOrderModel.bogoServices = [];

    // /// calculate coupon
    // if (b2bOrderModel.coupon != null) {
    //   /// check Applied
    //   var result = CouponModel.checkAppliedFor(b2bOrderModel: b2bOrderModel, couponModel: b2bOrderModel.coupon);
    //   String matchedProductIds = "";
    //   String matchedServiceIds = "";
    //   if (result["message"] == "") {
    //     for (var i = 0; i < result["matchedItems"]["products"].length; i++) {
    //       matchedProductIds += "," + result["matchedItems"]["products"][i].productModel.id;
    //     }
    //     for (var i = 0; i < result["matchedItems"]["services"].length; i++) {
    //       matchedServiceIds += "," + result["matchedItems"]["services"][i].serviceModel.id;
    //     }
    //   } else if (result["message"] == "ALL") {
    //     matchedProductIds = "ALL";
    //     matchedServiceIds = "ALL";
    //   }

    //   /// disount type is percent
    //   if (b2bOrderModel.coupon!.discountType == AppConfig.discountTypeForCoupon[0]["value"]) {
    //     double totalCouponDiscount = 0;
    //     double totalPrice = 0;
    //     for (var i = 0; i < b2bOrderModel.products!.length; i++) {
    //       if (matchedProductIds == "ALL" || matchedProductIds.contains(b2bOrderModel.products![i].productModel!.id!)) {
    //         double price = b2bOrderModel.products![i].orderPrice! - b2bOrderModel.products![i].promocodeDiscount!;
    //         b2bOrderModel.products![i].couponDiscount = price * double.parse(b2bOrderModel.coupon!.discountData!["discountValue"].toString()) / 100;
    //         // b2bOrderModel.products![i].couponDiscount = double.parse(numFormat.format(b2bOrderModel.products![i].couponDiscount));

    //         totalCouponDiscount += b2bOrderModel.products![i].couponDiscount! * b2bOrderModel.products![i].orderQuantity!;
    //         totalPrice += price * b2bOrderModel.products![i].orderQuantity!;
    //       }
    //     }

    //     for (var i = 0; i < b2bOrderModel.services!.length; i++) {
    //       if (matchedServiceIds == "ALL" || matchedServiceIds.contains(b2bOrderModel.services![i].serviceModel!.id!)) {
    //         double price = b2bOrderModel.services![i].orderPrice! - b2bOrderModel.services![i].promocodeDiscount!;
    //         b2bOrderModel.services![i].couponDiscount = price * double.parse(b2bOrderModel.coupon!.discountData!["discountValue"].toString()) / 100;
    //         // b2bOrderModel.services![i].couponDiscount = double.parse(numFormat.format(b2bOrderModel.services![i].couponDiscount));

    //         totalCouponDiscount += b2bOrderModel.services![i].couponDiscount! * b2bOrderModel.services![i].orderQuantity!;
    //         totalPrice += price * b2bOrderModel.services![i].orderQuantity!;
    //       }
    //     }

    //     if (b2bOrderModel.coupon!.discountData!["discountMaxAmount"] != null &&
    //         b2bOrderModel.coupon!.discountData!["discountMaxAmount"] != "" &&
    //         totalCouponDiscount > double.parse(b2bOrderModel.coupon!.discountData!["discountMaxAmount"].toString())) {
    //       double changedPercent = double.parse(b2bOrderModel.coupon!.discountData!["discountMaxAmount"].toString()) / totalPrice * 100;

    //       for (var i = 0; i < b2bOrderModel.products!.length; i++) {
    //         if (matchedProductIds == "ALL" || matchedProductIds.contains(b2bOrderModel.products![i].productModel!.id!)) {
    //           double price = b2bOrderModel.products![i].orderPrice! - b2bOrderModel.products![i].promocodeDiscount!;
    //           b2bOrderModel.products![i].couponDiscount = price * changedPercent / 100;
    //           // b2bOrderModel.products![i].couponDiscount = double.parse(numFormat.format(b2bOrderModel.products![i].couponDiscount));
    //         }
    //       }

    //       for (var i = 0; i < b2bOrderModel.services!.length; i++) {
    //         if (matchedServiceIds == "ALL" || matchedServiceIds.contains(b2bOrderModel.services![i].serviceModel!.id!)) {
    //           double price = b2bOrderModel.services![i].orderPrice! - b2bOrderModel.services![i].promocodeDiscount!;
    //           b2bOrderModel.services![i].couponDiscount = price * changedPercent / 100;
    //           // b2bOrderModel.services![i].couponDiscount = double.parse(numFormat.format(b2bOrderModel.services![i].couponDiscount));
    //         }
    //       }
    //     }
    //   }
    //   // disount type is fixed amount
    //   else if (b2bOrderModel.coupon!.discountType == AppConfig.discountTypeForCoupon[1]["value"]) {
    //     double totalPrice = 0;
    //     for (var i = 0; i < b2bOrderModel.products!.length; i++) {
    //       if (matchedProductIds == "ALL" || matchedProductIds.contains(b2bOrderModel.products![i].productModel!.id!)) {
    //         double price = b2bOrderModel.products![i].orderPrice! - b2bOrderModel.products![i].promocodeDiscount!;
    //         totalPrice += price * b2bOrderModel.products![i].orderQuantity!;
    //       }
    //     }

    //     for (var i = 0; i < b2bOrderModel.services!.length; i++) {
    //       if (matchedServiceIds == "ALL" || matchedServiceIds.contains(b2bOrderModel.services![i].serviceModel!.id!)) {
    //         double price = b2bOrderModel.services![i].orderPrice! - b2bOrderModel.services![i].promocodeDiscount!;
    //         totalPrice += price * b2bOrderModel.services![i].orderQuantity!;
    //       }
    //     }

    //     double changedPercent = double.parse(b2bOrderModel.coupon!.discountData!["discountValue"].toString()) / totalPrice * 100;

    //     for (var i = 0; i < b2bOrderModel.products!.length; i++) {
    //       if (matchedProductIds == "ALL" || matchedProductIds.contains(b2bOrderModel.products![i].productModel!.id!)) {
    //         double price = b2bOrderModel.products![i].orderPrice! - b2bOrderModel.products![i].promocodeDiscount!;
    //         b2bOrderModel.products![i].couponDiscount = price * changedPercent / 100;
    //         // b2bOrderModel.products![i].couponDiscount = double.parse(numFormat.format(b2bOrderModel.products![i].couponDiscount));
    //       }
    //     }

    //     for (var i = 0; i < b2bOrderModel.services!.length; i++) {
    //       if (matchedServiceIds == "ALL" || matchedServiceIds.contains(b2bOrderModel.services![i].serviceModel!.id!)) {
    //         double price = b2bOrderModel.services![i].orderPrice! - b2bOrderModel.services![i].promocodeDiscount!;
    //         b2bOrderModel.services![i].couponDiscount = price * changedPercent / 100;
    //         // b2bOrderModel.services![i].couponDiscount = double.parse(numFormat.format(b2bOrderModel.services![i].couponDiscount));
    //       }
    //     }
    //   }
    //   // disount type is BOGO
    //   else if (b2bOrderModel.coupon!.discountType == AppConfig.discountTypeForCoupon[2]["value"]) {
    //     var getMatchedItems = CouponModel.getBOGOGetItemsMatch(b2bOrderModel: b2bOrderModel, couponModel: b2bOrderModel.coupon);

    //     List<dynamic> sortedItems = [];
    //     for (var i = 0; i < getMatchedItems["products"].length; i++) {
    //       sortedItems.add({"type": "products", "item": getMatchedItems["products"][i]});
    //     }
    //     for (var i = 0; i < getMatchedItems["services"].length; i++) {
    //       sortedItems.add({"type": "services", "item": getMatchedItems["services"][i]});
    //     }

    //     sortedItems.sort((a, b) {
    //       double aPrice = a["item"].orderPrice!;
    //       double bPrice = b["item"].orderPrice!;

    //       if (aPrice > bPrice) {
    //         return 1;
    //       } else {
    //         return -1;
    //       }
    //     });

    //     double getQuantity = double.parse(b2bOrderModel.coupon!.discountData!["customerBogo"]["get"]["quantity"].toString());

    //     for (var i = 0; i < sortedItems.length; i++) {
    //       double orderQuantity = 0;
    //       if (getQuantity >= sortedItems[i]["item"].couponQuantity) {
    //         orderQuantity = sortedItems[i]["item"].couponQuantity;
    //       } else {
    //         orderQuantity = getQuantity;
    //       }

    //       getQuantity = getQuantity - sortedItems[i]["item"].couponQuantity;

    //       if (sortedItems[i]["type"] == "products") {
    //         ProductOrderModel productOrderModel = ProductOrderModel.copy(sortedItems[i]["item"]);
    //         productOrderModel.orderQuantity = orderQuantity;
    //         productOrderModel.couponQuantity = orderQuantity;

    //         if (b2bOrderModel.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]) {
    //           double price = productOrderModel.orderPrice! - productOrderModel.promocodeDiscount!;
    //           productOrderModel.couponDiscount = price;
    //         } else if (b2bOrderModel.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[1]["value"]) {
    //           double price = productOrderModel.orderPrice! - productOrderModel.promocodeDiscount!;
    //           productOrderModel.couponDiscount = price *
    //               double.parse(
    //                 b2bOrderModel.coupon!.discountData!["customerBogo"]["get"]["percentValue"].toString(),
    //               ) /
    //               100;
    //           // productOrderModel.couponDiscount = double.parse(numFormat.format(productOrderModel.couponDiscount));
    //         }

    //         b2bOrderModel.bogoProducts!.add(productOrderModel);

    //         for (var i = 0; i < b2bOrderModel.products!.length; i++) {
    //           if (b2bOrderModel.products![i].productModel!.id == productOrderModel.productModel!.id) {
    //             b2bOrderModel.products![i].couponQuantity = b2bOrderModel.products![i].couponQuantity! - productOrderModel.orderQuantity!;
    //             // if (b2bOrderModel.products![i].couponQuantity == 0) {
    //             //   b2bOrderModel.products!.removeAt(i);
    //             // }
    //             break;
    //           }
    //         }
    //       } else if (sortedItems[i]["type"] == "services") {
    //         ServiceOrderModel serviceOrderModel = ServiceOrderModel.copy(sortedItems[i]["item"]);
    //         serviceOrderModel.orderQuantity = orderQuantity;
    //         serviceOrderModel.couponQuantity = orderQuantity;

    //         if (b2bOrderModel.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[0]["value"]) {
    //           double price = serviceOrderModel.orderPrice! - serviceOrderModel.promocodeDiscount!;
    //           serviceOrderModel.couponDiscount = price;
    //         } else if (b2bOrderModel.coupon!.discountData!["customerBogo"]["get"]["type"] == AppConfig.discountBuyValueForCoupon[1]["value"]) {
    //           double price = serviceOrderModel.orderPrice! - serviceOrderModel.promocodeDiscount!;
    //           serviceOrderModel.couponDiscount = price *
    //               double.parse(
    //                 b2bOrderModel.coupon!.discountData!["customerBogo"]["get"]["percentValue"].toString(),
    //               ) /
    //               100;
    //           // serviceOrderModel.couponDiscount = double.parse(numFormat.format(serviceOrderModel.couponDiscount));
    //         }
    //         b2bOrderModel.bogoServices!.add(serviceOrderModel);

    //         for (var i = 0; i < b2bOrderModel.services!.length; i++) {
    //           if (b2bOrderModel.services![i].serviceModel!.id == serviceOrderModel.serviceModel!.id) {
    //             b2bOrderModel.services![i].couponQuantity = b2bOrderModel.services![i].couponQuantity! - serviceOrderModel.orderQuantity!;
    //             // if (b2bOrderModel.services![i].couponQuantity == 0) {
    //             //   b2bOrderModel.services!.removeAt(i);
    //             // }
    //             break;
    //           }
    //         }
    //       }
    //       if (getQuantity <= 0) {
    //         print("finish");
    //         break;
    //       }
    //     }
    //   }
    // }

    // /// calculate promocode
    // if (b2bOrderModel.promocode != null) {
    //   _calculatePercentPromocodeDiscount(b2bOrderModel: b2bOrderModel);
    //   _calculateINRPromocode(b2bOrderModel: b2bOrderModel);
    // }
  }

  // static void _calculatePercentPromocodeDiscount({@required B2BOrderModel? b2bOrderModel}) {
  //   numFormat.maximumFractionDigits = 2;
  //   numFormat.minimumFractionDigits = 0;
  //   numFormat.turnOffGrouping();

  //   if (b2bOrderModel!.promocode != null && b2bOrderModel.promocode!.promocodeType!.toLowerCase() == "percentage") {
  //     double promocodePercent = 0;

  //     if (b2bOrderModel.promocode!.maximumDiscount != null) {
  //       double totalPrice = getTotalPrice(b2bOrderModel: b2bOrderModel);

  //       double totalPromocodeDisount = b2bOrderModel.promocode!.promocodeValue! / 100 * (totalPrice);

  //       if (totalPromocodeDisount > b2bOrderModel.promocode!.maximumDiscount!) {
  //         promocodePercent = b2bOrderModel.promocode!.maximumDiscount! / totalPrice * 100;
  //       } else {
  //         promocodePercent = b2bOrderModel.promocode!.promocodeValue!;
  //       }
  //     } else {
  //       promocodePercent = b2bOrderModel.promocode!.promocodeValue!;
  //     }

  //     for (var i = 0; i < b2bOrderModel.products!.length; i++) {
  //       b2bOrderModel.products![i].promocodePercent = promocodePercent;
  //       b2bOrderModel.products![i].promocodeDiscount =
  //           (b2bOrderModel.products![i].orderPrice! - b2bOrderModel.products![i].couponDiscount!) * promocodePercent / 100;
  //     }

  //     for (var i = 0; i < b2bOrderModel.services!.length; i++) {
  //       b2bOrderModel.services![i].promocodePercent = promocodePercent;
  //       b2bOrderModel.services![i].promocodeDiscount =
  //           (b2bOrderModel.services![i].orderPrice! - b2bOrderModel.services![i].couponDiscount!) * promocodePercent / 100;
  //     }
  //   }
  // }

  // static void _calculateINRPromocode({@required B2BOrderModel? b2bOrderModel}) {
  //   numFormat.maximumFractionDigits = 2;
  //   numFormat.minimumFractionDigits = 0;
  //   numFormat.turnOffGrouping();

  //   //// if promocode is "INR", calculate promocode discount percent.
  //   if (b2bOrderModel!.promocode != null && b2bOrderModel.promocode!.promocodeType!.contains("INR")) {
  //     double totalPrice = getTotalPrice(b2bOrderModel: b2bOrderModel);

  //     double percentageForINR = b2bOrderModel.promocode!.promocodeValue! / totalPrice * 100;
  //     // percentageForINR = double.parse(numFormat.format(percentageForINR));

  //     for (var i = 0; i < b2bOrderModel.products!.length; i++) {
  //       b2bOrderModel.products![i].promocodePercent = percentageForINR;
  //       b2bOrderModel.products![i].promocodeDiscount = b2bOrderModel.products![i].orderPrice! * percentageForINR / 100;
  //       // b2bOrderModel.products![i].promocodeDiscount = double.parse(numFormat.format(b2bOrderModel.products![i].promocodeDiscount));
  //     }

  //     for (var i = 0; i < b2bOrderModel.services!.length; i++) {
  //       b2bOrderModel.services![i].promocodePercent = percentageForINR;
  //       b2bOrderModel.services![i].promocodeDiscount = b2bOrderModel.products![i].orderPrice! * percentageForINR / 100;
  //       // b2bOrderModel.services![i].promocodeDiscount = double.parse(numFormat.format(b2bOrderModel.services![i].promocodeDiscount));
  //     }
  //   }
  // }

  static PaymentDetailModel calclatePaymentDetail({@required B2BOrderModel? b2bOrderModel}) {
    NumberFormat numFormat = NumberFormat.currency(symbol: "", name: "");
    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
    numFormat.turnOffGrouping();

    PaymentDetailModel paymentDetailModel = b2bOrderModel!.paymentDetail ?? PaymentDetailModel();
    double totalQuantity = 0;
    double totalOriginPrice = 0;
    double totalPrice = 0;
    double totalTaxBeforeDiscount = 0;
    double totalTaxAfterCouponDiscount = 0;
    double totalTaxAfterDiscount = 0;
    double totalPromocodeDiscount = 0;
    double totalCouponDiscount = 0;
    double deliveryPrice = 0;
    double deliveryDiscount = 0;

    for (var i = 0; i < b2bOrderModel.products!.length; i++) {
      ProductOrderModel productOrderModel = b2bOrderModel.products![i];
      double orderQuantity = productOrderModel.couponQuantity!;
      double orderPrice = productOrderModel.orderPrice!;
      double promocodeDiscount = productOrderModel.promocodeDiscount!;
      double couponDiscount = productOrderModel.couponDiscount!;
      double taxPercentage = 0;
      double taxPriceBeforeDiscount = 0;
      double taxPriceAfterCouponDiscount = 0;
      double taxPriceAfterDiscount = 0;

      ///
      if (productOrderModel.taxPriceBeforeDiscount == 0 && productOrderModel.productModel!.taxPercentage != 0) {
        taxPercentage = productOrderModel.productModel!.taxPercentage!;
        taxPriceBeforeDiscount = orderPrice * taxPercentage / (100 + taxPercentage);
        taxPriceAfterCouponDiscount = (orderPrice - couponDiscount) * taxPercentage / (100 + taxPercentage);
        taxPriceAfterDiscount = (orderPrice - promocodeDiscount - couponDiscount) * taxPercentage / (100 + taxPercentage);

        productOrderModel.taxPercentage = taxPercentage;
        productOrderModel.taxPriceBeforeDiscount = taxPriceBeforeDiscount;
        productOrderModel.taxPriceAfterCouponDiscount = taxPriceAfterCouponDiscount;
        productOrderModel.taxPriceAfterDiscount = taxPriceAfterDiscount;
      } else {
        taxPriceBeforeDiscount = productOrderModel.taxPriceBeforeDiscount!;
        taxPriceAfterCouponDiscount = productOrderModel.taxPriceAfterCouponDiscount!;
        taxPriceAfterDiscount = productOrderModel.taxPriceAfterDiscount!;
      }

      ///
      totalQuantity += orderQuantity;
      totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
      totalTaxAfterCouponDiscount += orderQuantity * taxPriceAfterCouponDiscount;
      totalTaxAfterDiscount += orderQuantity * taxPriceAfterDiscount;
      totalPrice += orderQuantity * (orderPrice - promocodeDiscount - couponDiscount);
      totalOriginPrice += orderQuantity * orderPrice;
      totalPromocodeDiscount += orderQuantity * promocodeDiscount;
      totalCouponDiscount += orderQuantity * couponDiscount;
    }

    for (var i = 0; i < b2bOrderModel.services!.length; i++) {
      ServiceOrderModel serviceOrderModel = b2bOrderModel.services![i];
      double orderQuantity = serviceOrderModel.couponQuantity!;
      double orderPrice = serviceOrderModel.orderPrice!;
      double promocodeDiscount = serviceOrderModel.promocodeDiscount!;
      double couponDiscount = serviceOrderModel.couponDiscount!;
      double taxPercentage = 0;
      double taxPriceBeforeDiscount = 0;
      double taxPriceAfterCouponDiscount = 0;
      double taxPriceAfterDiscount = 0;

      ///
      if (serviceOrderModel.taxPriceBeforeDiscount == 0 && serviceOrderModel.serviceModel!.taxPercentage != 0) {
        taxPercentage = serviceOrderModel.serviceModel!.taxPercentage!;
        taxPriceBeforeDiscount = orderPrice * taxPercentage / (100 + taxPercentage);
        taxPriceAfterCouponDiscount = (orderPrice - couponDiscount) * taxPercentage / (100 + taxPercentage);
        taxPriceAfterDiscount = (orderPrice - promocodeDiscount - couponDiscount) * taxPercentage / (100 + taxPercentage);

        serviceOrderModel.taxPercentage = taxPercentage;
        serviceOrderModel.taxPriceAfterDiscount = taxPriceAfterDiscount;
        serviceOrderModel.taxPriceAfterCouponDiscount = taxPriceAfterCouponDiscount;
        serviceOrderModel.taxPriceBeforeDiscount = taxPriceBeforeDiscount;
      } else {
        taxPriceBeforeDiscount = serviceOrderModel.taxPriceBeforeDiscount!;
        taxPriceAfterCouponDiscount = serviceOrderModel.taxPriceAfterCouponDiscount!;
        taxPriceAfterDiscount = serviceOrderModel.taxPriceAfterDiscount!;
      }

      ///
      totalQuantity += orderQuantity;
      totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
      totalTaxAfterCouponDiscount += orderQuantity * taxPriceAfterCouponDiscount;
      totalTaxAfterDiscount += orderQuantity * taxPriceAfterDiscount;
      totalPrice += orderQuantity * (orderPrice - promocodeDiscount - couponDiscount);
      totalOriginPrice += orderQuantity * orderPrice;
      totalPromocodeDiscount += orderQuantity * promocodeDiscount;
      totalCouponDiscount += orderQuantity * couponDiscount;
    }

    // for (var i = 0; i < b2bOrderModel.bogoProducts!.length; i++) {
    //   ProductOrderModel productOrderModel = b2bOrderModel.bogoProducts![i];
    //   double orderQuantity = productOrderModel.couponQuantity!;
    //   double orderPrice = productOrderModel.orderPrice!;
    //   double promocodeDiscount = productOrderModel.promocodeDiscount!;
    //   double couponDiscount = productOrderModel.couponDiscount!;
    //   double taxPercentage = 0;
    //   double taxPriceBeforeDiscount = 0;
    //   double taxPriceAfterDiscount = 0;
    //   double taxPriceAfterCouponDiscount = 0;
    //   if (productOrderModel.productModel!.taxPercentage != 0) {
    //     taxPercentage = productOrderModel.productModel!.taxPercentage!;
    //     taxPriceAfterCouponDiscount = (orderPrice - couponDiscount) * taxPercentage / (100 + taxPercentage);
    //     taxPriceAfterDiscount = (orderPrice - promocodeDiscount - couponDiscount) * taxPercentage / (100 + taxPercentage);
    //     taxPriceBeforeDiscount = orderPrice * taxPercentage / (100 + taxPercentage);

    //     // taxPriceAfterCouponDiscount = double.parse(numFormat.format(taxPriceAfterCouponDiscount));
    //     // taxPriceAfterDiscount = double.parse(numFormat.format(taxPriceAfterDiscount));
    //     // taxPriceBeforeDiscount = double.parse(numFormat.format(taxPriceBeforeDiscount));
    //   }
    //   productOrderModel.taxPercentage = taxPercentage;
    //   productOrderModel.taxPriceAfterCouponDiscount = taxPriceAfterCouponDiscount;
    //   productOrderModel.taxPriceAfterDiscount = taxPriceAfterDiscount;
    //   productOrderModel.taxPriceBeforeDiscount = taxPriceBeforeDiscount;

    //   totalQuantity += orderQuantity;
    //   totalTaxAfterCouponDiscount += orderQuantity * taxPriceAfterCouponDiscount;
    //   totalTaxAfterDiscount += orderQuantity * taxPriceAfterDiscount;
    //   totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
    //   totalPrice += orderQuantity * (orderPrice - promocodeDiscount - couponDiscount);
    //   totalOriginPrice += orderQuantity * orderPrice;
    //   totalPromocodeDiscount += orderQuantity * promocodeDiscount;
    //   totalCouponDiscount += orderQuantity * couponDiscount;
    // }

    // for (var i = 0; i < b2bOrderModel.bogoServices!.length; i++) {
    //   ServiceOrderModel serviceOrderModel = b2bOrderModel.bogoServices![i];
    //   double orderQuantity = serviceOrderModel.couponQuantity!;
    //   double orderPrice = serviceOrderModel.orderPrice!;
    //   double promocodeDiscount = serviceOrderModel.promocodeDiscount!;
    //   double couponDiscount = serviceOrderModel.couponDiscount!;
    //   double taxPercentage = 0;
    //   double taxPriceBeforeDiscount = 0;
    //   double taxPriceAfterDiscount = 0;
    //   double taxPriceAfterCouponDiscount = 0;
    //   if (serviceOrderModel.serviceModel!.taxPercentage != 0) {
    //     taxPercentage = serviceOrderModel.serviceModel!.taxPercentage!;
    //     taxPriceAfterCouponDiscount = (orderPrice - couponDiscount) * taxPercentage / (100 + taxPercentage);
    //     taxPriceAfterDiscount = (orderPrice - promocodeDiscount - couponDiscount) * taxPercentage / (100 + taxPercentage);
    //     taxPriceBeforeDiscount = orderPrice * taxPercentage / (100 + taxPercentage);

    //     // taxPriceAfterCouponDiscount = double.parse(numFormat.format(taxPriceAfterCouponDiscount));
    //     // taxPriceAfterDiscount = double.parse(numFormat.format(taxPriceAfterDiscount));
    //     // taxPriceBeforeDiscount = double.parse(numFormat.format(taxPriceBeforeDiscount));
    //   }
    //   serviceOrderModel.taxPercentage = taxPercentage;
    //   serviceOrderModel.taxPriceAfterCouponDiscount = taxPriceAfterCouponDiscount;
    //   serviceOrderModel.taxPriceAfterDiscount = taxPriceAfterDiscount;
    //   serviceOrderModel.taxPriceBeforeDiscount = taxPriceBeforeDiscount;

    //   totalQuantity += orderQuantity;
    //   totalTaxAfterCouponDiscount += orderQuantity * taxPriceAfterCouponDiscount;
    //   totalTaxAfterDiscount += orderQuantity * taxPriceAfterDiscount;
    //   totalTaxBeforeDiscount += orderQuantity * taxPriceBeforeDiscount;
    //   totalPrice += orderQuantity * (orderPrice - promocodeDiscount - couponDiscount);
    //   totalOriginPrice += orderQuantity * orderPrice;
    //   totalPromocodeDiscount += orderQuantity * promocodeDiscount;
    //   totalCouponDiscount += orderQuantity * couponDiscount;
    // }

    // if (b2bOrderModel.deliveryAddress != null && b2bOrderModel.deliveryPartnerDetails!.isNotEmpty) {
    //   deliveryPrice = double.parse(b2bOrderModel.deliveryPartnerDetails!["charge"]["deliveryPrice"].toString());
    //   if (b2bOrderModel.promocode != null && b2bOrderModel.promocode!.promocodeType == "Delivery") {
    //     deliveryDiscount = (b2bOrderModel.promocode!.promocodeValue! * deliveryPrice / 100);
    //     // deliveryDiscount = double.parse(numFormat.format(deliveryDiscount));
    //   }
    // }

    paymentDetailModel.totalQuantity = double.parse(numFormat.format(totalQuantity));
    paymentDetailModel.totalOriginPrice = double.parse(numFormat.format(totalOriginPrice));
    paymentDetailModel.totalPrice = double.parse(numFormat.format(totalPrice));
    paymentDetailModel.totalPromocodeDiscount = double.parse(numFormat.format(totalPromocodeDiscount));
    paymentDetailModel.totalCouponDiscount = double.parse(numFormat.format(totalCouponDiscount));
    paymentDetailModel.totalTaxAfterDiscount = double.parse(numFormat.format(totalTaxAfterDiscount));
    paymentDetailModel.totalTaxAfterCouponDiscount = double.parse(numFormat.format(totalTaxAfterCouponDiscount));
    paymentDetailModel.totalTaxBeforeDiscount = double.parse(numFormat.format(totalTaxBeforeDiscount));
    // paymentDetailModel.deliveryDiscount = double.parse(numFormat.format(deliveryDiscount));
    // paymentDetailModel.deliveryChargeBeforeDiscount = double.parse(numFormat.format(deliveryPrice));
    // paymentDetailModel.deliveryChargeAfterDiscount = double.parse(numFormat.format(deliveryPrice - deliveryDiscount));
    // paymentDetailModel.distance =
    //     b2bOrderModel.deliveryAddress != null ? double.parse((b2bOrderModel.deliveryAddress!.distance! / 1000).toStringAsFixed(3)) : 0;
    paymentDetailModel.toPay = double.parse(numFormat.format(totalPrice + deliveryPrice - deliveryDiscount + paymentDetailModel.tip!));

    /// --- tax Tyepe
    if (b2bOrderModel.deliveryAddress != null &&
        b2bOrderModel.myStoreModel!.state!.toLowerCase() == b2bOrderModel.businessStoreModel!.state!.toLowerCase()) {
      paymentDetailModel.taxType = "SGST";
      paymentDetailModel.taxBreakdown = [
        {"type": "CGST", "value": (paymentDetailModel.totalTaxAfterDiscount! / 2).toStringAsFixed(2)},
        {"type": paymentDetailModel.taxType!, "value": (paymentDetailModel.totalTaxAfterDiscount! / 2).toStringAsFixed(2)}
      ];
    } else if (b2bOrderModel.deliveryAddress != null &&
        b2bOrderModel.myStoreModel!.state!.toLowerCase() != b2bOrderModel.businessStoreModel!.state!.toLowerCase()) {
      paymentDetailModel.taxType = "IGST";
      paymentDetailModel.taxBreakdown = [
        {"type": "CGST", "value": (paymentDetailModel.totalTaxAfterDiscount! / 2).toStringAsFixed(2)},
        {"type": paymentDetailModel.taxType!, "value": (paymentDetailModel.totalTaxAfterDiscount! / 2).toStringAsFixed(2)}
      ];
    }

    return paymentDetailModel;
  }
}
