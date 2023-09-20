import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/config.dart';
import 'package:trapp/config/global.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/BlockButtonWidget.dart';
import 'package:trapp/generated/l10n.dart';
import 'package:trapp/src/elements/keicy_progress_dialog.dart';
import 'package:trapp/src/pages/RegisterStorePage/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:trapp/config/app_config.dart' as config;

class LoginWidget extends StatefulWidget {
  final Function? callback;

  LoginWidget({this.callback});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  KeicyProgressDialog? _keicyProgressDialog;
  AuthProvider? _authProvider;

  bool obscureText = true;

  bool? isFirst;

  @override
  void initState() {
    super.initState();

    _keicyProgressDialog = KeicyProgressDialog.of(context);
    _authProvider = AuthProvider.of(context);

    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 0, message: "", callback: () {}),
      isNotifiable: false,
    );

    obscureText = true;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      isFirst = GlobalVariables.prefs!.getBool("isFirst") ?? true;

      if (isFirst!) {
        GlobalVariables.prefs!.setBool("isFirst", false);
        GlobalVariables.dynamicLinkService.retrieveDynamicLink(context, isFirst: true);
      }

      _authProvider!.addListener(_authProviderListener);
    });
  }

  @override
  void dispose() {
    _authProvider!.removeListener(_authProviderListener);
    super.dispose();
  }

  void _authProviderListener() async {
    if (_authProvider!.authState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_authProvider!.authState.progressState == 2 && _authProvider!.authState.loginState == LoginState.IsLogin) {
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        callBack: () {
          if (widget.callback != null) {
            Navigator.of(context).pop();
            widget.callback!();
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/Pages',
              ModalRoute.withName('/'),
              arguments: {"currentTab": 2},
            );
          }
        },
      );
    } else if (_authProvider!.authState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _authProvider!.authState.message!,
        isTryButton: _authProvider!.authState.message == "Something went wrong",
        callBack: _authProvider!.authState.message != "Something went wrong" ? null : _authProvider!.authState.callback,
        cancelCallback: () {
          _authProvider!.setAuthState(
            _authProvider!.authState.update(callback: () {}),
            isNotifiable: false,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;

    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    ///////////////////////////////

    return Scaffold(
      key: scaffoldKey,
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: SingleChildScrollView(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Container(width: deviceWidth, height: deviceHeight),
              Positioned(
                top: 0,
                child: Container(
                  width: deviceWidth,
                  height: heightDp1 * 250,
                  decoration: BoxDecoration(color: Theme.of(context).accentColor),
                ),
              ),
              Positioned(
                top: 0,
                child: Column(
                  children: [
                    SizedBox(height: statusbarHeight),
                    SizedBox(height: heightDp1 * 20),
                    Image.asset("img/logo_small.png", height: heightDp1 * 50, fit: BoxFit.fitHeight, color: Colors.white),
                    SizedBox(height: heightDp1 * 20),
                    Text(
                      'Let\'s Start with Login!',
                      style: Theme.of(context).textTheme.headline2!.merge(TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                    SizedBox(height: heightDp1 * 20),
                    Container(
                      width: deviceWidth * 0.88,
                      margin: EdgeInsets.symmetric(horizontal: widthDp * 20),
                      padding: EdgeInsets.symmetric(vertical: heightDp1 * 30, horizontal: widthDp * 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [BoxShadow(blurRadius: 50, color: Theme.of(context).hintColor.withOpacity(0.2))],
                      ),
                      child: Form(
                        key: loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: nameController,
                              // onSaved: (input) =>  authService.user.name  = input,
                              validator: (input) => input!.isEmpty ? S.of(context).should_be_a_name : null,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "UserName/Mobile",
                                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                contentPadding: EdgeInsets.all(12),
                                hintText: '',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                prefixIcon: Icon(Icons.person, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: passwordController,
                              // onSaved: (input) {
                              //   authService.user.password = input;
                              // },
                              validator: (input) => input!.length < 8 ? S.of(context).should_password_input : null,
                              obscureText: obscureText,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                contentPadding: EdgeInsets.all(12),
                                hintText: '••••••••••••',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                                prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: widthDp * 10),
                                    child: Image.asset(
                                      obscureText ? "img/show_password.png" : "img/hide-password.png",
                                      width: heightDp * 20 / 3 * 4,
                                      height: heightDp * 20,
                                      fit: BoxFit.cover,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                suffixIconConstraints: BoxConstraints(
                                  maxWidth: heightDp * 20 / 3 * 4 + widthDp * 10,
                                  maxHeight: heightDp * 20,
                                ),
                                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              ),
                            ),
                            SizedBox(height: 30),
                            BlockButtonWidget(
                              text: Text(
                                'Login',
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                _onLoginButtonPressed();
                              },
                            ),
                            SizedBox(height: 25),
                            FlatButton(
                              onPressed: () {
                                String link = "${Environment.businessUrl}/${AppConfig.forgotPasswordLink}";
                                _launchInBrowser(link);
                              },
                              textColor: Theme.of(context).hintColor,
                              child: Text('I forgot password ?'),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => RegisterStorePage(),
                                  ),
                                );
                              },
                              textColor: Theme.of(context).hintColor,
                              child: Text('Create an account'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onLoginButtonPressed() async {
    if (!loginFormKey.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    await _keicyProgressDialog!.show();
    _authProvider!.setAuthState(
      _authProvider!.authState.update(progressState: 1, callback: _onLoginButtonPressed),
      isNotifiable: false,
    );
    _authProvider!.login(name: nameController.text.trim(), password: passwordController.text.trim());
  }

  // Future<void> _launchInBrowser(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: false,
  //       forceWebView: false,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _launchInBrowser(String url) async {
    await launch(
      url,
      customTabsOption: CustomTabsOption(
        toolbarColor: config.Colors().mainColor(1),
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: Theme.of(context).primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }
}
