import 'dart:convert';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:http/http.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/config/global.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/RegisterStorePage/index.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicLinkService {
  static Future<Uri> createStoreDynamicLink(StoreModel? storeModel) async {
    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Environment.dynamicLinkBase,
      link: Uri.parse('${Environment.infoUrl}/store?id=${storeModel!.id}'),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'AppConfig.appStoreId',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: storeModel.profile!["image"] != null ? Uri.parse(storeModel.profile!["image"]) : null,
        title: storeModel.name,
        description: storeModel.description,
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createProductDynamicLink({
    @required Map<String, dynamic>? itemData,
    @required StoreModel? storeModel,
    @required String? type,
    @required bool? isForCart,
  }) async {
    String url = '${Environment.infoUrl}/product_item';
    url += '?storeId=${storeModel!.id}';
    url += '&itemId=${itemData!["_id"]}';
    url += '&type=$type';
    url += '&isForCart=$isForCart';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'AppConfig.appStoreId',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(itemData["images"][0]),
        title: itemData["name"],
        description: "Store Name: ${storeModel.name}",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createCouponDynamicLink({
    @required CouponModel? couponModel,
    @required StoreModel? storeModel,
  }) async {
    String url = '${Environment.infoUrl}/coupon';
    url += '?storeId=${storeModel!.id}';
    url += '&couponId=${couponModel!.id}';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'AppConfig.appStoreId',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(couponModel.images!.isNotEmpty ? couponModel.images![0] : AppConfig.discountTypeImages[couponModel.discountType]),
        title: couponModel.discountCode,
        description: "Store Name: ${storeModel.name}",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createAnnouncementDynamicLink({
    @required Map<String, dynamic>? announcementData,
    @required StoreModel? storeModel,
  }) async {
    String url = '${Environment.infoUrl}/announcement';
    url += '?storeId=${storeModel!.id}';
    url += '&announcementId=${announcementData!["_id"]}';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Environment.dynamicLinkBase,
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'AppConfig.appStoreId',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(announcementData["images"].isNotEmpty ? announcementData["images"][0] : AppConfig.announcementImage[0]),
        title: announcementData["title"],
        description: "Store Name: ${storeModel.name}",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createJobDynamicLink({
    @required StoreJobPostModel? storeJobPostModel,
    @required StoreModel? storeModel,
  }) async {
    String url = '${Environment.infoUrl}/job';
    url += '?storeId=${storeModel!.id}';
    url += '&jobId=${storeJobPostModel!.id}';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'AppConfig.appStoreId',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: storeJobPostModel.jobTitle,
        description: "Store Name: ${storeModel.name}",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  //@deprecated
  static Future<Uri> createBusinessCardDynamicLink({
    @required BusinessCardModel? businessCardModel,
  }) async {
    String userName = (businessCardModel!.firstname! + " " + businessCardModel.lastname!).replaceAll(" ", "-");
    String businessLink = "/vcard/" + businessCardModel.businessName!.replaceAll(" ", "-") + "/" + userName;

    String url = '${Environment.businessUrl}$businessLink';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(businessCardModel.profileImage!),
        title: businessCardModel.firstname! + " " + businessCardModel.lastname! + "(${businessCardModel.caption})",
        description: businessCardModel.aboutus ?? "",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createBusinessCardIDDynamicLink({
    @required BusinessCardModel? businessCardModel,
  }) async {
    String businessLink = "/vCardId/" + businessCardModel!.storeId.toString() + "/" + businessCardModel.userId.toString();

    String url = '${Environment.businessUrl}$businessLink';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(businessCardModel.profileImage!),
        title: businessCardModel.firstname! + " " + businessCardModel.lastname! + "(${businessCardModel.caption})",
        description: businessCardModel.aboutus ?? "",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createReferUserLink({
    @required String? description,
    @required String? referralCode,
    @required String? referredByStoreId,
    @required String? appliedFor,
  }) async {
    String url = '${Environment.infoUrl}/refer_store_to_user';
    url += '?referralCode=$referralCode';
    url += '&referredByStoreId=$referredByStoreId';
    url += '&appliedFor=$appliedFor';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: 'AppConfig.appStoreId',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Join TradeMantri and shop from near by stores.",
        description: description! + "\nTradeMantri helps to reachout to near by stores and service providers to fullfill your needs.",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createReferStoreLink({
    @required String? description,
    @required String? referralCode,
    @required String? referredByStoreId,
    @required String? appliedFor,
  }) async {
    String url = '${Environment.infoUrl}/refer_store_to_store';
    url += '?referralCode=$referralCode';
    url += '&referredByStoreId=$referredByStoreId';
    url += '&appliedFor=$appliedFor';

    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.tradeMantriBiz',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.tradeMantriBiz',
        minimumVersion: '1',
        appStoreId: 'AppConfig.appStoreId',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Join TradeMantri and and increase your sales.",
        description: description! +
            "\nTradeMantri helps increase the reach of your business to wider audience and helps you grow your business in multiple ways.",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  static Future<Uri> createAppointmentDynamicLink({
    @required AppointmentModel? appointmentModel,
  }) async {
    String url = '${Environment.infoUrl}/appointment';
    url += '?id=${appointmentModel!.id}';
    url += '&storeId=${appointmentModel.id}';

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: '${Environment.dynamicLinkBase}',
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: 'com.tradilligence.TradeMantri',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.tradilligence.TradeMantri',
        minimumVersion: '1',
        appStoreId: AppConfig.appStoreId,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Appointment",
        description: "Store Name: ${appointmentModel.storeModel!.name}",
      ),
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
    );
    var dynamicUrl = await parameters.buildUrl();
    final shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  /**
   * Used to expand the firebase dynamic shor url
   * Example:
   * ```
   *  DynamicLinkService.expandShortUrl(shortUrl: "https://trademantriqa.page.link/XH3T").then((value) => print(value.queryParameters));
   * ```
   * Result: {id: 613e1ed011b0300009e492b2}
   * ```
   * ```
   */
  static Future<Uri> expandShortUrl({@required String? shortUrl}) async {
    Request req = Request("Get", Uri.parse(shortUrl!))..followRedirects = false;
    Client baseClient = Client();
    StreamedResponse response = await baseClient.send(req);
    Uri redirectUri = Uri.parse(response.headers['location']!);
    return redirectUri;
  }

  Future<void> retrieveDynamicLink(BuildContext context, {bool isFirst = false}) async {
    try {
      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          FlutterLogs.logInfo("dynamic_link_service", "retrieveDynamicLink", "on success called");
          _dynamicLinkHandler(context, dynamicLink, isFirst: isFirst, isFrom: "onLink");
        },
        onError: (error) async {
          FlutterLogs.logThis(
            tag: "dynamic_link_service",
            subTag: "retrieveDynamicLink:onError",
            level: LogLevel.ERROR,
            exception: error,
          );
        },
      );
    } catch (e) {
      FlutterLogs.logThis(
        tag: "dynamic_link_service",
        subTag: "retrieveDynamicLink:catch",
        level: LogLevel.ERROR,
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }

    FlutterLogs.logInfo(
      "dynamic_link_service",
      "retrieveDynamicLink",
      {
        "getInitialLink": GlobalVariables.isCalledGetInitialDynamicLink,
      }.toString(),
    );

    if (GlobalVariables.isCalledGetInitialDynamicLink == null) {
      PendingDynamicLinkData? dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
      _dynamicLinkHandler(context, dynamicLink, isFirst: isFirst);
      GlobalVariables.isCalledGetInitialDynamicLink = true;
    }
  }

  void _dynamicLinkHandler(
    BuildContext context,
    PendingDynamicLinkData? dynamicLink, {
    bool isFirst = false,
    String isFrom = "init",
  }) async {
    if (dynamicLink == null) return;
    Uri deepLink = dynamicLink.link;
    FlutterLogs.logInfo(
      "dynamic_link_service",
      "_dynamicLinkHandler",
      {
        "deepLink": deepLink,
        "isFirst": isFirst,
        "isFrom": isFrom,
      }.toString(),
    );

    dynamic params = dynamicLink.link.queryParameters;
    switch (dynamicLink.link.pathSegments[0]) {
      case "refer_store":
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => RegisterStorePage(
              referredBy: params["referredBy"],
              referredByUserId: params["referredByUserId"],
              appliedFor: "UserToStore",
            ),
          ),
          (route) => false,
        );
        break;
      case "refer_user_to_store":
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => RegisterStorePage(
              referredBy: params["referralCode"],
              referredByUserId: params["referredByUserId"],
              appliedFor: params["appliedFor"],
            ),
          ),
          (route) => false,
        );
        break;
      case "refer_store_to_store":
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => RegisterStorePage(
              referredBy: params["referralCode"],
              referredByUserId: params["referredByStoreId"],
              appliedFor: params["appliedFor"],
            ),
          ),
          (route) => false,
        );
        break;
      case "login":
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginWidget(),
          ),
          (route) => false,
        );
        break;
      default:
    }
  }
}
