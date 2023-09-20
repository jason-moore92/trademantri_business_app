import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/models/user_model.dart';
import 'package:trapp/src/providers/BridgeProvider/bridge_provider.dart';
import 'package:trapp/src/providers/ChatProvider/index.dart';
import 'package:trapp/src/providers/fb_analytics.dart';
import 'package:trapp/src/providers/firebase_analytics.dart';
import 'package:trapp/src/services/keicy_fcm_for_mobile.dart';
import 'package:trapp/src/services/keicy_firebase_auth.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:trapp/environment.dart';

import 'index.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider of(BuildContext context, {bool listen = false}) => Provider.of<AuthProvider>(context, listen: listen);

  AuthState _authState = AuthState.init();
  AuthState get authState => _authState;

  String _rememberUserKey = "remember_me";
  String _otherCreds = "other_creds";

  void setAuthState(AuthState authState, {bool isNotifiable = true}) {
    if (_authState != authState) {
      _authState = authState;
      if (isNotifiable) notifyListeners();
    }
  }

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void init() async {
    await KeicyFCMForMobile.init();
    _prefs = await SharedPreferences.getInstance();
    listenForFreshChatRestoreId();

    var rememeberBusinessData = _prefs!.getString(_rememberUserKey) == null ? null : json.decode(_prefs!.getString(_rememberUserKey)!);
    if (rememeberBusinessData != null) {
      if (rememeberBusinessData["_id"] != null && rememeberBusinessData["_id"] != "")
        loginWithRemeber(BusinessUserModel.fromJson(rememeberBusinessData));
      else
        clearAuthState();
    } else {
      clearAuthState();
    }
  }

  void loginWithRemeber(BusinessUserModel businessUserModel) async {
    var storeData = await StoreApiProvider.getMyStore();
    if (storeData["success"] && storeData["data"] != null && storeData["data"].isNotEmpty) {
      StoreModel storeModel = StoreModel.fromJson(storeData["data"]);

      var businessCardData = await BusinessCardApiProvider.getMyBusinessCard();
      BusinessCardModel businessCardModel = BusinessCardModel();
      if (businessCardData.runtimeType.toString() != "String") {
        try {
          businessCardModel = BusinessCardModel.fromJson(businessCardData);
        } catch (e) {}
      }

      var galleryData = await StoreGalleryApiProvider.get(storeId: storeModel.id);
      if (!galleryData["success"] || galleryData["data"] == null || galleryData["data"].isEmpty) {
        galleryData = {
          "storeId": storeModel.id,
          "images": Map<String, dynamic>(),
          "videos": Map<String, dynamic>(),
        };
      } else {
        galleryData = galleryData["data"];
      }

      var firebaseResult = await setUpAfterLogin(businessUserModel, storeModel);

      if (firebaseResult!["success"]) {
        _authState = _authState.update(
          progressState: 2,
          businessUserModel: businessUserModel,
          storeModel: storeModel,
          businessCardModel: businessCardModel,
          galleryData: galleryData,
          message: "",
          loginState: LoginState.IsLogin,
        );
        PushSubscriptionApiProvider.add(fcmToken: KeicyFCMForMobile.token);
        updateChatRoomInfo(storeData["data"], KeicyFCMForMobile.token);
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: "Something was wrong",
          errorCode: 500,
          loginState: LoginState.IsNotLogin,
        );
      }
    } else if (storeData["success"] && (storeData["data"] == null || storeData["data"].isEmpty)) {
      _authState = _authState.update(
        progressState: -1,
        message: "No Store Data",
        loginState: LoginState.IsNotLogin,
      );
    } else {
      _authState = _authState.update(
        progressState: -1,
        message: storeData["message"],
        loginState: LoginState.IsNotLogin,
      );
    }

    notifyListeners();
  }

  void login({@required String? name, @required String? password}) async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }

      var result = await UserApiProvider.login(name!, password!);
      if (result["success"]) {
        BusinessUserModel businessUserModel = BusinessUserModel.fromJson(result["data"]["user"]);
        businessUserModel.token = result["data"]["token"];
        businessUserModel.referralCode = result["data"]["referralCode"];
        await _prefs!.setString(_rememberUserKey, json.encode(businessUserModel.toJson()));

        var storeData = await StoreApiProvider.getMyStore();
        if (storeData["success"] && storeData["data"] != null && storeData["data"].isNotEmpty) {
          StoreModel storeModel = StoreModel.fromJson(storeData["data"]);

          var businessCardData = await BusinessCardApiProvider.getMyBusinessCard();
          BusinessCardModel businessCardModel = BusinessCardModel();
          if (businessCardData.runtimeType.toString() != "String") {
            try {
              businessCardModel = BusinessCardModel.fromJson(businessCardData);
            } catch (e) {}
          }

          var galleryData = await StoreGalleryApiProvider.get(storeId: storeModel.id);
          if (!galleryData["success"] || galleryData["data"] == null || galleryData["data"].isEmpty) {
            galleryData = {
              "storeId": storeModel.id,
              "images": Map<String, dynamic>(),
              "videos": Map<String, dynamic>(),
            };
          } else {
            galleryData = galleryData["data"];
          }

          var firebaseResult = await setUpAfterLogin(businessUserModel, storeModel);

          if (firebaseResult!["success"]) {
            if (Environment.enableFBEvents!) {
              getFBAppEvents().logEvent(name: "loggedin");
            }

            if (Environment.enableFirebaseEvents!) {
              getFirebaseAnalytics().logLogin(loginMethod: "email_password");
            }

            if (Environment.enableFreshChatEvents!) {
              Freshchat.trackEvent("loggedin");
            }

            _authState = _authState.update(
              progressState: 2,
              businessUserModel: businessUserModel,
              storeModel: storeModel,
              businessCardModel: businessCardModel,
              galleryData: galleryData,
              message: "",
              loginState: LoginState.IsLogin,
            );

            // /// referral store handler
            // ReferralRewardU2SOffersApiProvider.update(
            //   referralRewardOffersForStore: {
            //     "referralStoreId": storeModel.id,
            //     "referralOfferType": "SignUpAndLogin",
            //     "referredBy": storeModel.referredBy,
            //   },
            // );
            PushSubscriptionApiProvider.add(fcmToken: KeicyFCMForMobile.token);
            updateChatRoomInfo(storeData["data"], KeicyFCMForMobile.token);
          } else {
            _authState = _authState.update(
              progressState: -1,
              message: "Something was wrong",
              errorCode: 500,
              loginState: LoginState.IsNotLogin,
            );
          }
        } else if (storeData["success"] && (storeData["data"] == null || storeData["data"].isEmpty)) {
          _authState = _authState.update(
            progressState: -1,
            message: "No Store Data",
            loginState: LoginState.IsNotLogin,
          );
        } else {
          _authState = _authState.update(
            progressState: -1,
            message: storeData["message"],
            loginState: LoginState.IsNotLogin,
          );
        }
      } else {
        // if (result["errorCode"] == 401) {
        //   _prefs.setString(_rememberUserKey, json.encode(null));
        // }
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
          errorCode: result["errorCode"],
          loginState: LoginState.IsNotLogin,
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
        loginState: LoginState.IsNotLogin,
      );
    }

    notifyListeners();
  }

  Future<Map<String, dynamic>?> setUpAfterLogin(BusinessUserModel businessUserModel, StoreModel storeModel) async {
    try {
      Map<String, dynamic> otherCreds = await UserApiProvider.getOtherCreds();
      await _prefs!.setString(_otherCreds, json.encode(otherCreds["data"]));
      Map<String, dynamic> firebaseResult = await KeicyAuthentication.instance.signInWithCustomToken(
        token: otherCreds["data"]["firebase"]["token"],
      );

      getFBAppEvents().setUserID(businessUserModel.id);
      getFBAppEvents().setUserData(
        // email: userData["email"],
        // firstName: userData["firstName"],
        // lastName: userData["lastName"],
        firstName: businessUserModel.name,
      );

      getFirebaseAnalytics().setUserId(businessUserModel.id);
      getFirebaseAnalytics().setUserProperty(name: "role", value: "store_rep");

      Freshchat.setPushRegistrationToken(KeicyFCMForMobile.token ?? "");
      Freshchat.identifyUser(
        externalId: businessUserModel.id!,
        restoreId: businessUserModel.freshChat != null ? businessUserModel.freshChat!["restoreId"] : null,
      );
      FreshchatUser freshchatUser = FreshchatUser(
        businessUserModel.id,
        businessUserModel.freshChat != null ? businessUserModel.freshChat!["restoreId"] : null,
      );
      // freshchatUser.setFirstName(userData["firstName"]);
      // freshchatUser.setLastName(userData["lastName"]);
      freshchatUser.setFirstName(businessUserModel.name!);
      // freshchatUser.setEmail(userData["email"]);
      freshchatUser.setPhone("+91", businessUserModel.mobile!);
      Freshchat.setUser(freshchatUser);
      Freshchat.setUserProperties({"role": "store_rep"});

      return firebaseResult;
    } catch (e) {
      return {"success": false};
    }
  }

  void updateChatRoomInfo(Map<String, dynamic> newStoreData, fcmToken) async {
    try {
      var result = await ChatRoomFirestoreProvider.getChatRoomsData(
        chatRoomType: ChatRoomTypes.b2c,
        wheres: [
          {"key": "ids", "cond": "arrayContains", "val": "Business-${newStoreData["_id"]}"}
        ],
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"].length; i++) {
          if (result["data"][i]["firstUserData"]["_id"] == newStoreData["_id"]) {
            result["data"][i]["firstUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["firstUserType"],
              userData: newStoreData,
            );
            result["data"][i]["firstUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["firstUserType"],
              userData: newStoreData,
            );
          } else {
            result["data"][i]["secondUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["secondUserType"],
              userData: newStoreData,
            );
            result["data"][i]["secondUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["secondUserType"],
              userData: newStoreData,
            );
          }

          ChatRoomFirestoreProvider.updateChatRoom(
            chatRoomType: result["data"][i]["type"],
            id: result["data"][i]["id"],
            data: result["data"][i],
            changeUpdateAt: false,
          );
        }
      }

      result = await ChatRoomFirestoreProvider.getChatRoomsData(
        chatRoomType: ChatRoomTypes.b2b,
        wheres: [
          {"key": "ids", "cond": "arrayContains", "val": "Business-${newStoreData["_id"]}"}
        ],
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"].length; i++) {
          if (result["data"][i]["firstUserData"]["_id"] == newStoreData["_id"]) {
            result["data"][i]["firstUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["firstUserType"],
              userData: newStoreData,
            );
            result["data"][i]["firstUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["firstUserType"],
              userData: newStoreData,
            );
          } else {
            result["data"][i]["secondUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["secondUserType"],
              userData: newStoreData,
            );
            result["data"][i]["secondUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["secondUserType"],
              userData: newStoreData,
            );
          }

          ChatRoomFirestoreProvider.updateChatRoom(
            chatRoomType: result["data"][i]["type"],
            id: result["data"][i]["id"],
            data: result["data"][i],
            changeUpdateAt: false,
          );
        }
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "auth_provider",
        subTag: "updateChatRoomInfo",
        level: LogLevel.ERROR,
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<bool> logout() async {
    try {
      var result = await UserApiProvider.logout(token: _authState.businessUserModel!.token);
      if (result["logOutSuccess"] == "true") {
        await clearAuthState();
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    return _authState.progressState == 2;
  }

  void listenForFreshChatRestoreId() {
    var restoreStream = Freshchat.onRestoreIdGenerated;
    restoreStream.listen((event) async {
      FreshchatUser user = await Freshchat.getUser;
      var restoreId = user.getRestoreId();
      String previousRestoreId = _authState.businessUserModel!.freshChat != null ? _authState.businessUserModel!.freshChat!["restoreId"] : null;
      if (restoreId != previousRestoreId) {
        await UserApiProvider.updateFreshChatRestoreId(restoreId: restoreId);
      }
    });
  }

  clearAuthState({bool isNotifiable = true}) async {
    await KeicyAuthentication.instance.signOut();
    Freshchat.resetUser();
    if (Environment.enableFreshChatEvents!) {
      Freshchat.trackEvent("loggedout");
    }
    if (Environment.enableFBEvents!) {
      getFBAppEvents().logEvent(name: "loggedout");
      getFBAppEvents().clearUserData();
      getFBAppEvents().clearUserID();
    }
    if (Environment.enableFirebaseEvents!) {
      getFirebaseAnalytics().logEvent(name: "logout");
      getFirebaseAnalytics().resetAnalyticsData();
    }
    await _prefs!.setString(_rememberUserKey, json.encode(null));
    await _prefs!.setString(_otherCreds, json.encode(null));
    _authState = _authState.update(
      progressState: 2,
      message: "",
      loginState: LoginState.IsNotLogin,
      businessUserModel: BusinessUserModel(),
      businessCardModel: BusinessCardModel(),
      storeModel: StoreModel(),
    );

    if (isNotifiable) notifyListeners();
  }
}
