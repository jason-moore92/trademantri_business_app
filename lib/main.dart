import 'package:trapp/bootstrap.dart';
import 'package:trapp/environment.dart';

void main() async {
  Environment(
    debug: true,
    envName: "development",
    // apiBaseUrl: "http://192.168.43.57:8001/api/v1/",
    // apiBaseUrl: "http://192.168.1.198:8001/api/v1/",
    apiBaseUrl: "http://192.168.1.24:8001/api/v1/",
    // apiBaseUrl: "http://192.168.0.136:8001/api/v1/",
    // apiBaseUrl: "http://192.168.100.17:8001/api/v1/",
    // apiBaseUrl: "http://192.168.14.115:8001/api/v1/",
    // apiBaseUrl: "http://192.168.1.106:8001/api/v1/",
    // apiBaseUrl: "https://qa.api.trademantri.in/api/v1/",
    googleApiKey: "AIzaSyBfkIHqXazhle5rR1znrtxCU53cpHgVFkQ",
    checkUpdates: true,
    enableFBEvents: false,
    enableFirebaseEvents: false,
    freshChatId: "0f4a3e09-8291-4bc6-a857-4590c167a41d",
    freshChatKey: "810d2f29-cfcc-434e-b63b-692a1199dbcb",
    freshChatDomain: "msdk.in.freshchat.com",
    enableFreshChatEvents: false,
    vapidKey: "BE8QNT4FPufcL-ZCdDR7VMHsIuBPCG8_Mzn0uHYffPnYgMQVuO3-1KoJra9a9bvSTldKhTNejUHXRiTGYk2Ggqw",
    dynamicLinkBase: "https://trademantriqa.page.link",
    infoUrl: "https://qa.trademantri.in",
    businessUrl: "https://qa.business.trademantri.in",
    // logsEncryptionKey: "%C*F-JaNdRfUjXn2r5u8x/A?D(G+KbPe",
  );

  bootstrap();
}
