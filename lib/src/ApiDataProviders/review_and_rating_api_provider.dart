// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:trapp/src/helpers/http_plus.dart';
// import 'package:trapp/environment.dart';

// class ReviewAndRatingApiProvider {
//   static getReviewAndRating({@required String? userId, @required String? storeId}) async {
//     String apiUrl = 'reward_and_rating/getReviewAndRating';
//     try {
//       String url = Environment.apiBaseUrl! + apiUrl + "?userId=$userId" + "&storeId=$storeId";

//       var response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
//       return json.decode(response.body);
//     } on SocketException catch (e) {
//       return {
//         "success": false,
//         "message": e.osError!.errorCode == 110 || e.osError!.errorCode == 101 ? "Something went wrong" : e.osError!.message,
//         "errorCode": e.osError!.errorCode,
//       };
//     } on PlatformException catch (e) {
//       return {
//         "success": false,
//         "message": e.message,
//       };
//     } catch (e) {
//       print(e);
//       return {
//         "success": false,
//         "message": "get /$apiUrl error",
//       };
//     }
//   }

//   static createReviewAndRating({@required Map<String, dynamic>? reviewAndRating}) async {
//     String apiUrl = 'reward_and_rating/add/';
//     try {
//       String url = Environment.apiBaseUrl! + apiUrl;

//       var response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(reviewAndRating),
//       );
//       return json.decode(response.body);
//     } on SocketException catch (e) {
//       return {
//         "success": false,
//         "message": e.osError!.errorCode == 110 || e.osError!.errorCode == 101 ? "Something went wrong" : e.osError!.message,
//         "errorCode": e.osError!.errorCode,
//       };
//     } on PlatformException catch (e) {
//       return {
//         "success": false,
//         "message": e.message,
//       };
//     } catch (e) {
//       print(e);
//       return {
//         "success": false,
//         "message": "get /$apiUrl error",
//       };
//     }
//   }

//   static updateReviewAndRating({@required Map<String, dynamic>? reviewAndRating}) async {
//     String apiUrl = 'reward_and_rating/update/';
//     try {
//       String url = Environment.apiBaseUrl! + apiUrl + reviewAndRating!["_id"];

//       var response = await http.put(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(reviewAndRating),
//       );
//       return json.decode(response.body);
//     } on SocketException catch (e) {
//       return {
//         "success": false,
//         "message": e.osError!.errorCode == 110 || e.osError!.errorCode == 101 ? "Something went wrong" : e.osError!.message,
//         "errorCode": e.osError!.errorCode,
//       };
//     } on PlatformException catch (e) {
//       return {
//         "success": false,
//         "message": e.message,
//       };
//     } catch (e) {
//       print(e);
//       return {
//         "success": false,
//         "message": "get /$apiUrl error",
//       };
//     }
//   }

//   static getAverageRating({@required String? storeId}) async {
//     String apiUrl = 'reward_and_rating/getAverageRating/';
//     try {
//       String url = Environment.apiBaseUrl! + apiUrl + storeId!;

//       var response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
//       return json.decode(response.body);
//     } on SocketException catch (e) {
//       return {
//         "success": false,
//         "message": e.osError!.errorCode == 110 || e.osError!.errorCode == 101 ? "Something went wrong" : e.osError!.message,
//         "errorCode": e.osError!.errorCode,
//       };
//     } on PlatformException catch (e) {
//       return {
//         "success": false,
//         "message": e.message,
//       };
//     } catch (e) {
//       print(e);
//       return {
//         "success": false,
//         "message": "get /$apiUrl error",
//       };
//     }
//   }

//   static getReviewList({
//     @required String? storeId,
//     @required int? limit,
//     int page = 1,
//   }) async {
//     String apiUrl = 'reward_and_rating/getReviewList';
//     try {
//       String url = Environment.apiBaseUrl! + apiUrl;
//       url += "?storeId=$storeId";
//       url += "&page=$page";
//       url += "&limit=$limit";

//       var response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
//       return json.decode(response.body);
//     } on SocketException catch (e) {
//       return {
//         "success": false,
//         "message": e.osError!.errorCode == 110 || e.osError!.errorCode == 101 ? "Something went wrong" : e.osError!.message,
//         "errorCode": e.osError!.errorCode,
//       };
//     } on PlatformException catch (e) {
//       return {
//         "success": false,
//         "message": e.message,
//       };
//     } catch (e) {
//       print(e);
//       return {
//         "success": false,
//         "message": "get /$apiUrl error",
//       };
//     }
//   }
// }
