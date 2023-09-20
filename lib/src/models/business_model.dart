import 'dart:convert';

import "package:equatable/equatable.dart";

class BusinessUserModel extends Equatable {
  String? id;
  String? name;
  String? email;
  String? mobile;
  String? password;
  String? role; // ['user', 'admin', 'storerep']
  List<dynamic>? extraRoles;
  String? verification;
  bool? verified;
  String? city;
  String? country;
  String? urlTwitter;
  String? urlGitHub;
  int? loginAttempts;
  DateTime? blockExpires;
  String? referralCode;
  String? referredBy;
  bool? iAgree;
  String? registeredVia; // ["Website", "Whatsapp", "FBMessenger" , "POS-ORDER"]
  String? locale; // ['en','ta', 'te', 'hi']
  Map<String, dynamic>? freshChat;
  Map<String, dynamic>? community;
  String? token;

  BusinessUserModel({
    this.id,
    this.name = "",
    this.email = "",
    this.mobile = "",
    this.password = "",
    this.role = "",
    this.extraRoles = const [],
    this.verification = "",
    this.verified = false,
    this.city = "",
    this.country = "",
    this.urlTwitter = "",
    this.urlGitHub = "",
    this.loginAttempts = 0,
    this.blockExpires,
    this.referralCode = "",
    this.referredBy = "",
    this.iAgree,
    this.registeredVia = "Website",
    this.locale = "en",
    this.freshChat,
    this.community,
    this.token,
  });

  factory BusinessUserModel.fromJson(Map<String, dynamic> map) {
    return BusinessUserModel(
      id: map["_id"] ?? null,
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      mobile: map["mobile"] ?? "",
      password: map["password"] ?? "",
      role: map["role"] ?? "",
      extraRoles: map["extraRoles"] ?? [],
      verification: map["verification"] ?? "",
      verified: map["verified"] ?? false,
      city: map["city"] ?? "",
      country: map["country"] ?? "",
      urlTwitter: map["urlTwitter"] ?? "",
      urlGitHub: map["urlGitHub"] ?? "",
      loginAttempts: map["loginAttempts"] ?? 0,
      blockExpires: map["blockExpires"] != null ? DateTime.tryParse(map["blockExpires"])!.toLocal() : null,
      referralCode: map["referralCode"] ?? "",
      referredBy: map["referredBy"] ?? "",
      iAgree: map["iAgree"] ?? null,
      registeredVia: map["registeredVia"] ?? "Website",
      locale: map["locale"] ?? "en",
      freshChat: map["freshChat"] ?? Map<String, dynamic>(),
      community: map["community"] ?? Map<String, dynamic>(),
      token: map["token"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "name": name ?? "",
      "email": email ?? "",
      "mobile": mobile ?? "",
      "password": password ?? "",
      "role": role ?? "",
      "extraRoles": extraRoles ?? [],
      "verification": verification ?? "",
      "verified": verified ?? false,
      "city": city ?? "",
      "country": country ?? "",
      "urlTwitter": urlTwitter ?? "",
      "urlGitHub": urlGitHub ?? "",
      "loginAttempts": loginAttempts ?? 0,
      "blockExpires": blockExpires != null ? blockExpires!.toUtc().toIso8601String() : null,
      "referralCode": referralCode ?? "",
      "referredBy": referredBy ?? "",
      "iAgree": iAgree ?? null,
      "registeredVia": registeredVia ?? "Website",
      "locale": locale ?? "en",
      "freshChat": freshChat ?? Map<String, dynamic>(),
      "community": community ?? Map<String, dynamic>(),
      "token": token ?? "",
    };
  }

  factory BusinessUserModel.copy(BusinessUserModel model) {
    return BusinessUserModel(
      id: model.id,
      name: model.name,
      email: model.email,
      mobile: model.mobile,
      password: model.password,
      role: model.role,
      extraRoles: List.from(model.extraRoles!),
      verification: model.verification,
      verified: model.verified,
      city: model.city,
      country: model.country,
      urlTwitter: model.urlTwitter,
      urlGitHub: model.urlGitHub,
      loginAttempts: model.loginAttempts,
      blockExpires: model.blockExpires,
      referralCode: model.referralCode,
      referredBy: model.referredBy,
      iAgree: model.iAgree,
      registeredVia: model.registeredVia,
      locale: model.locale,
      freshChat: json.decode(json.encode(model.freshChat!)),
      community: json.decode(json.encode(model.community!)),
      token: model.token,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        name!,
        email!,
        mobile!,
        password!,
        role!,
        extraRoles!,
        verification!,
        verified!,
        city!,
        country!,
        urlTwitter!,
        urlGitHub!,
        loginAttempts!,
        blockExpires!,
        referralCode!,
        referredBy!,
        iAgree ?? Object(),
        registeredVia!,
        locale!,
        freshChat!,
        community!,
        token!,
      ];

  @override
  bool get stringify => true;
}
