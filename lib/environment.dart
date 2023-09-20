import 'package:meta/meta.dart';

class Environment {
  static bool debug = true;
  static String? envName;
  static String? apiBaseUrl;
  static String? googleApiKey;
  static bool checkUpdates = false;
  static bool? enableFBEvents;
  static bool? enableFirebaseEvents;
  static String? freshChatId;
  static String? freshChatKey;
  static String? freshChatDomain;
  static bool? enableFreshChatEvents;
  static String? vapidKey;
  static String dynamicLinkBase = "https://example.com";
  static String infoUrl = "https://qa.trademantri.in";
  static String? businessUrl;
  static String? logsEncryptionKey;

  Environment({
    bool debug = true,
    @required String? envName,
    @required String? apiBaseUrl,
    @required String? googleApiKey,
    bool checkUpdates = false,
    @required bool? enableFBEvents,
    @required bool? enableFirebaseEvents,
    @required String? freshChatId,
    @required String? freshChatKey,
    @required String? freshChatDomain,
    @required bool? enableFreshChatEvents,
    @required String? vapidKey,
    String dynamicLinkBase = "https://example.com",
    String infoUrl = "https://qa.trademantri.in",
    @required String? businessUrl,
    String? logsEncryptionKey,
  }) {
    Environment.debug = debug;
    Environment.envName = envName;
    Environment.apiBaseUrl = apiBaseUrl;
    Environment.googleApiKey = googleApiKey;
    Environment.checkUpdates = checkUpdates;
    Environment.enableFBEvents = enableFBEvents;
    Environment.enableFirebaseEvents = enableFirebaseEvents;
    Environment.freshChatId = freshChatId;
    Environment.freshChatKey = freshChatKey;
    Environment.freshChatDomain = freshChatDomain;
    Environment.enableFreshChatEvents = enableFreshChatEvents;
    Environment.vapidKey = vapidKey;
    Environment.dynamicLinkBase = dynamicLinkBase;
    Environment.infoUrl = infoUrl;
    Environment.businessUrl = businessUrl;
    Environment.logsEncryptionKey = logsEncryptionKey;
  }
}
