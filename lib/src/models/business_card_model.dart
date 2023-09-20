import "package:equatable/equatable.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessCardModel extends Equatable {
  String? id;
  String? storeId;
  String? userId;
  String? firstname;
  String? lastname;
  String? businessName;
  String? caption;
  String? address;
  String? city;
  String? addressLine1;
  LatLng? location;
  String? phone;
  String? email;
  String? website;
  String? facebook;
  String? profileImage;
  String? companyLogo;
  List<dynamic>? productsList;
  List<dynamic>? gallery;
  String? aboutus;

  BusinessCardModel({
    String? id,
    String? storeId,
    String? userId,
    String? firstname,
    String? lastname,
    String? businessName,
    String? caption,
    String? address,
    String? city,
    String? addressLine1,
    LatLng? location,
    String? phone,
    String? email,
    String? website,
    String? facebook,
    String? profileImage,
    String? companyLogo,
    List<dynamic>? productsList,
    List<dynamic>? gallery,
    String? aboutus,
  }) {
    this.id = id ?? null;
    this.storeId = storeId ?? "";
    this.userId = userId ?? "";
    this.firstname = firstname ?? "";
    this.lastname = lastname ?? "";
    this.businessName = businessName ?? "";
    this.caption = caption ?? "";
    this.address = address ?? "";
    this.city = city ?? "";
    this.addressLine1 = addressLine1 ?? "";
    this.location = location ?? null;
    this.phone = phone ?? "";
    this.email = email ?? "";
    this.website = website ?? "";
    this.facebook = facebook ?? "";
    this.profileImage = profileImage ?? "";
    this.companyLogo = companyLogo ?? "";
    this.productsList = productsList ?? [];
    this.gallery = gallery ?? [];
    this.aboutus = aboutus ?? "";
  }

  factory BusinessCardModel.fromJson(Map<String, dynamic> map) {
    return BusinessCardModel(
      id: map["_id"] ?? null,
      storeId: map["storeId"] ?? "",
      userId: map["userId"] ?? "",
      firstname: map["firstname"] ?? "",
      lastname: map["lastname"] ?? "",
      businessName: map["businessName"] ?? "",
      caption: map["caption"] ?? "",
      address: map["address"] ?? "",
      city: map["city"] ?? "",
      addressLine1: map["addressLine1"] ?? "",
      location: (map["location"] != null && map["location"]["coordinates"].length > 0)
          ? LatLng(map["location"]["coordinates"][1], map["location"]["coordinates"][0])
          : null,
      phone: map["phone"] ?? "",
      email: map["email"] ?? "",
      website: map["website"] ?? "",
      facebook: map["facebook"] ?? "",
      profileImage: map["profileImage"] ?? "",
      companyLogo: map["companyLogo"] ?? "",
      productsList: map["productsList"] ?? [],
      gallery: map["gallery"] ?? [],
      aboutus: map["aboutus"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "storeId": storeId ?? "",
      "userId": userId ?? "",
      "firstname": firstname ?? "",
      "lastname": lastname ?? "",
      "businessName": businessName ?? "",
      "caption": caption ?? "",
      "address": address ?? "",
      "city": city ?? "",
      "addressLine1": addressLine1 ?? "",
      "location": location != null
          ? {
              "type": "Point",
              "coordinates": [location!.longitude, location!.latitude]
            }
          : null,
      "phone": phone ?? "",
      "email": email ?? "",
      "website": website ?? "",
      "facebook": facebook ?? "",
      "profileImage": profileImage ?? "",
      "companyLogo": companyLogo ?? "",
      "productsList": productsList ?? [],
      "gallery": gallery ?? [],
      "aboutus": aboutus ?? "",
    };
  }

  factory BusinessCardModel.copy(BusinessCardModel model) {
    return BusinessCardModel(
      id: model.id,
      storeId: model.storeId,
      userId: model.userId,
      firstname: model.firstname,
      lastname: model.lastname,
      businessName: model.businessName,
      caption: model.caption,
      address: model.address,
      city: model.city,
      addressLine1: model.addressLine1,
      location: model.location,
      phone: model.phone,
      email: model.email,
      website: model.website,
      facebook: model.facebook,
      profileImage: model.profileImage,
      companyLogo: model.companyLogo,
      productsList: List.from(model.productsList!),
      gallery: List.from(model.gallery!),
      aboutus: model.aboutus,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        storeId!,
        userId!,
        firstname!,
        lastname!,
        businessName!,
        caption!,
        address!,
        city!,
        addressLine1!,
        location ?? Object(),
        phone!,
        email!,
        website!,
        facebook!,
        profileImage!,
        companyLogo!,
        productsList!,
        gallery!,
        aboutus!,
      ];

  @override
  bool get stringify => true;
}
