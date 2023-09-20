import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/environment.dart';

class ReferralRewardU2SOffersApiProvider {
  // static addRewardPoint({
  //   // @required String referredByUserId,
  //   String referralStoreId = "",
  //   @required String? referredBy,
  //   @required String? appliedFor,
  //   @required String? storeName,
  //   @required String? storeMobile,
  //   @required String? storeAddress,
  // }) async {
  //   String apiUrl = 'referralRewardUserToStoreOffers/add/';

  //   try {
  //     String url = Environment.apiBaseUrl! + apiUrl;
  //     var response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({
  //         // "referredByUserId": referredByUserId,
  //         "referralStoreId": referralStoreId,
  //         "referredBy": referredBy,
  //         "appliedFor": appliedFor,
  //         "storeName": storeName,
  //         "storeMobile": storeMobile,
  //         "storeAddress": storeAddress,
  //       }),
  //     );
  //     return json.decode(response.body);
  //   } on SocketException catch (e) {
  //     return {
  //       "success": false,
  //       "message": "Something went wrong",
  //       // "message": e.osError!.errorCode == 110 || e.osError!.errorCode == 101 ? "Something went wrong" : e.osError!.message,
  //       "errorCode": e.osError!.errorCode,
  //     };
  //   } on PlatformException catch (e) {
  //     print(e);
  //     return {
  //       "success": false,
  //       "message": "Something went wrong",
  //     };
  //   } catch (e) {
  //     print(e);
  //     return {
  //       "success": false,
  //       "message": "Something went wrong",
  //     };
  //   }
  // }

  // static getReferralStoreData({@required String? storeName, @required String? storeMobile}) async {
  //   String apiUrl = 'referralRewardUserToStoreOffers/get';
  //   apiUrl += '?storeName=' + storeName!;
  //   apiUrl += '&storeMobile=' + storeMobile!;

  //   try {
  //     String url = Environment.apiBaseUrl! + apiUrl;
  //     var response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     return json.decode(response.body);
  //   } on SocketException catch (e) {
  //     return {
  //       "success": false,
  //       "message": "Something went wrong",
  //       // "message": e.osError!.errorCode == 110 || e.osError!.errorCode == 101 ? "Something went wrong" : e.osError!.message,
  //       "errorCode": e.osError!.errorCode,
  //     };
  //   } on PlatformException catch (e) {
  //     print(e);
  //     return {
  //       "success": false,
  //       "message": "Something went wrong",
  //     };
  //   } catch (e) {
  //     print(e);
  //     return {
  //       "success": false,
  //       "message": "Something went wrong",
  //     };
  //   }
  // }

  // static update({@required Map<String, dynamic>? referralRewardOffersForStore}) async {
  //   String apiUrl = 'referralRewardUserToStoreOffers/update/';

  //   try {
  //     String url = Environment.apiBaseUrl! + apiUrl;
  //     var response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode(referralRewardOffersForStore),
  //     );
  //     return json.decode(response.body);
  //   } on SocketException catch (e) {
  //     return {
  //       "success": false,
  //       "message": "Something went wrong",
  //       // "message": e.osError!.errorCode == 110 || e.osError!.errorCode == 101 ? "Something went wrong" : e.osError!.message,
  //       "errorCode": e.osError!.errorCode,
  //     };
  //   } on PlatformException catch (e) {
  //     print(e);
  //     return {
  //       "success": false,
  //       "message": "Something went wrong",
  //     };
  //   } catch (e) {
  //     print(e);
  //     return {
  //       "success": false,
  //       "message": "Something went wrong",
  //     };
  //   }
  // }

}
