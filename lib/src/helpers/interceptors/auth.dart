import 'package:http_interceptor/http_interceptor.dart';
import 'package:trapp/src/helpers/http_plus.dart';
import 'package:trapp/src/providers/BridgeProvider/bridge_provider.dart';
import 'package:trapp/src/providers/BridgeProvider/bridge_state.dart';
import 'package:trapp/environment.dart';

class AuthInterceptor implements InterceptorContract {
  //Note:: URLs for which should not send token in any case.
  List<String> blacklist = ["auth/login", "auth/register", "auth/registerstore"];

  @override
  Future<RequestData> interceptRequest({RequestData? data}) async {
    String currentRoute = data!.url.replaceAll(Environment.apiBaseUrl!, "");
    if (!blacklist.contains(currentRoute)) {
      String? authToken = await getAuthToken();
      if (authToken != null) {
        data.headers["authorization"] = "Bearer " + authToken;
      }
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData? data}) async {
    if (data!.statusCode == 401) {
      //TODO:: In future, api should return json and json decode the data.
      if (data.body == "Unauthorized") {
        BridgeProvider().update(
          BridgeState(
            event: "log_out",
            data: {
              "message": "Invalid token",
            },
          ),
        );
      }
    }
    return data;
  }
}
