import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart' as NotiPermission;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/global.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/entities/maintenance.dart';
import 'package:trapp/src/pages/app_update.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/pages/maintenance.dart';
import 'package:trapp/src/providers/index.dart';

enum WalkthroughStep {
  Welcome,
  AppUpdate,
  Maintenance,
  Walkthrough,
}

class Walkthrough extends StatefulWidget {
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  AuthProvider? _authProvider;

  WalkthroughStep _step = WalkthroughStep.Welcome;

  String updateResult = "";
  Maintenance? _activeMaintenance;

  @override
  void initState() {
    super.initState();

    _authProvider = AuthProvider.of(context);

    _step = WalkthroughStep.Welcome;

    AppDataProvider.of(context).init();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      //Note:: This is kept because, users need to view logo
      await Future.delayed(
        Duration(
          seconds: 2,
        ),
      );
      Maintenance? maintenanceConfig = await AppDataProvider.of(context).checkForMaintenance();

      if (maintenanceConfig != null) {
        setState(() {
          _activeMaintenance = maintenanceConfig;
          _step = WalkthroughStep.Maintenance;
        });
      } else {
        await checkUpdates();
      }

      _authProvider!.init();
      GlobalVariables.prefs ??= await SharedPreferences.getInstance();
    });
  }

  startWalkthrough() {
    setState(() {
      _step = WalkthroughStep.Walkthrough;
      _initPermission();
    });
  }

  startAppUpdate() {
    checkUpdates();
  }

  checkUpdates() async {
    if (Environment.checkUpdates) {
      String result = await AppDataProvider.of(context).checkForUpdates(
          // forceResult: "do_flexible_update",
          // delay: 1,
          );

      if (result == "navigate_walkthrough") {
        startWalkthrough();
      }

      if (result == "do_immediate_update" || result == "do_flexible_update") {
        setState(() {
          updateResult = result;
          _step = WalkthroughStep.AppUpdate;
        });
      }
    } else {
      startWalkthrough();
    }
  }

  @override
  void dispose() async {
    super.dispose();
  }

  /// ---- permission hadler ---- created by FlutterDev6778 ----
  Future<void> _initPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }

    NotiPermission.PermissionStatus notificationStatus = await NotiPermission.NotificationPermissions.getNotificationPermissionStatus();
    if (notificationStatus != NotiPermission.PermissionStatus.granted) {
      await NotiPermission.NotificationPermissions.requestNotificationPermissions(
        iosSettings: NotiPermission.NotificationSettingsIos(sound: true, badge: true, alert: true),
      );
    }
  }
  //////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    if (_step == WalkthroughStep.Welcome) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                config.Colors().mainColor(1).withOpacity(0.8),
                config.Colors().mainColor(1),
                config.Colors().mainColor(1).withOpacity(0.8),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: Image.asset(
              "img/logo_small.png",
              height: MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.fitHeight,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (_step == WalkthroughStep.AppUpdate) {
      return AppUpdate(
        updateType: updateResult,
        onSkip: () {
          startWalkthrough();
        },
        doReload: () async {
          await checkUpdates();
        },
      );
    }

    if (_step == WalkthroughStep.Maintenance) {
      return MaintenanceWidget(
        activeMaintenance: _activeMaintenance,
        onSkip: () {
          startAppUpdate();
        },
      );
    }

    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        if (authProvider.authState.progressState == 2 && authProvider.authState.loginState == LoginState.IsLogin) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/Pages',
            ModalRoute.withName('/'),
            arguments: {"currentTab": 2},
          );
        } else if (authProvider.authState.progressState != 0 &&
            (authProvider.authState.progressState == -1 || authProvider.authState.loginState == LoginState.IsNotLogin)) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginWidget()));
        }
      });

      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CupertinoActivityIndicator()),
      );
    });
  }
}
