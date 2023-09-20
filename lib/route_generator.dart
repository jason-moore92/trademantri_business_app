import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/pages/check_update.dart';
import 'package:trapp/src/pages/languages.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/pages/pages.dart';
import 'package:trapp/src/pages/walkthrough.dart';
import 'package:trapp/src/pages/ProfilePage/index.dart';

import 'environment.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/CheckUpdates':
        return MaterialPageRoute(
          builder: (_) => CheckUpdate(),
          settings: RouteSettings(
            name: "CheckUpdates",
          ),
        );
      case '/':
        // if (Environment.checkUpdates) {
        //   return MaterialPageRoute(
        //     builder: (_) => CheckUpdate(),
        //     settings: RouteSettings(
        //       name: "CheckUpdates",
        //     ),
        //   );
        // }
        return MaterialPageRoute(
          builder: (_) => Walkthrough(),
          settings: RouteSettings(
            name: "Walkthrough",
          ),
        );
      case '/Login':
        return MaterialPageRoute(
          builder: (_) => LoginWidget(),
          settings: RouteSettings(
            name: "Login",
          ),
        );
      // case '/SignUp':
      //   return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Pages':
        Map<String, dynamic> params = json.decode(json.encode(args));
        return MaterialPageRoute(
          builder: (_) => PagesTestWidget(
            currentTab: params["currentTab"],
            categoryData: params["categoryData"],
          ),
          settings: RouteSettings(name: params["currentTab"] == 2 ? "home_page" : ""),
        );
      case '/Languages':
        return MaterialPageRoute(
          builder: (_) => LanguagesWidget(),
          settings: RouteSettings(
            name: "Languages",
          ),
        );
      case '/Profile':
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
          settings: RouteSettings(
            name: "Profile",
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
