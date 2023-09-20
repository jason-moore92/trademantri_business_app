import 'package:trapp/bootstrap.dart';
import 'package:trapp/environment.dart';

void main() async {
  Environment(
    debug: false,
    envName: "production",
    apiBaseUrl: "https://api.trademantri.in/api/v1/",
    googleApiKey: "AIzaSyBfkIHqXazhle5rR1znrtxCU53cpHgVFkQ",
    checkUpdates: true,
    enableFBEvents: true,
    enableFirebaseEvents: true,
    freshChatId: "0f4a3e09-8291-4bc6-a857-4590c167a41d",
    freshChatKey: "810d2f29-cfcc-434e-b63b-692a1199dbcb",
    freshChatDomain: "msdk.in.freshchat.com",
    enableFreshChatEvents: true,
    vapidKey: "BEceWxyRTl3ns2Ic7I0sC-n3_HeP03c0bL50SYYFJbzYf4pVxVIo74yuCwcw-FcGl7UG9lgJywQ9rM1As8Uiras",
    dynamicLinkBase: "https://trademantri.page.link",
    infoUrl: "https://trademantri.in",
    businessUrl: "https://business.trademantri.in",
    logsEncryptionKey: ")H@McQeThWmZq4t7w!z%C*F-JaNdRgUj",
  );

  bootstrap();
}
