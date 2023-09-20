// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:trapp/config/app_config.dart' as config;
// import 'package:trapp/generated/l10n.dart';
// import 'package:trapp/src/dialogs/index.dart';
// import 'package:trapp/src/dialogs/success_dialog.dart';
// import 'package:trapp/src/elements/BlockButtonWidget.dart';
// import 'package:trapp/src/elements/keicy_progress_dialog.dart';
// import 'package:trapp/src/models/index.dart';
// import 'package:trapp/src/pages/login.dart';
// import 'package:trapp/src/providers/index.dart';
// import 'package:trapp/src/services/keicy_fcm_for_mobile.dart';

// class SignUpWidget extends StatefulWidget {
//   final Function callback;

//   SignUpWidget({this.callback});

//   @override
//   _SignUpWidgetState createState() => _SignUpWidgetState();
// }

// class _SignUpWidgetState extends State<SignUpWidget> {
//   /// Responsive design variables
//   double deviceWidth = 0;
//   double deviceHeight = 0;
//   double statusbarHeight = 0;
//   double bottomBarHeight = 0;
//   double appbarHeight = 0;
//   double widthDp = 0;
//   double heightDp = 0;
//   double heightDp1 = 0;
//   double fontSp = 0;
//
//   ///////////////////////////////

//   final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> navigatorKey = GlobalKey<ScaffoldState>();

//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   final FocusNode _firstNameFocusNode = FocusNode();
//   final FocusNode _lastNameFocusNode = FocusNode();
//   final FocusNode _emailFocusNode = FocusNode();
//   final FocusNode _phoneFocusNode = FocusNode();
//   final FocusNode _passwordFocusNode = FocusNode();
//   final FocusNode _confirmPasswordFocusNode = FocusNode();

//   UserModel _userModel = UserModel();
//   KeicyProgressDialog _keicyProgressDialog;
//   AuthProvider _authProvider;

//   @override
//   void initState() {
//     super.initState();

//     _keicyProgressDialog = KeicyProgressDialog.of(context);
//     _authProvider = AuthProvider.of(context);

//     _authProvider.setAuthState(
//       _authProvider.authState.update(progressState: 0, message: "", callback: () {}),
//       isNotifiable: false,
//     );

//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       _authProvider.addListener(_authProviderListener);
//     });
//   }

//   @override
//   void dispose() {
//     _authProvider.removeListener(_authProviderListener);
//     super.dispose();
//   }

//   void _authProviderListener() async {
//     if (_authProvider.authState.progressState != 1 && _keicyProgressDialog.isShowing()) {
//       await _keicyProgressDialog.hide();
//     }

//     if (_authProvider.authState.progressState == 2 && _authProvider.authState.loginState == LoginState.IsNotLogin) {
//       SuccessDialog.show(
//         context,
//         heightDp: heightDp,
//         fontSp: fontSp,
//         text: "Singup Success!\nPlease check your email to verify",
//         callBack: () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (BuildContext context) => LoginWidget(callback: widget.callback),
//             ),
//           );
//         },
//       );
//     } else if (_authProvider.authState.progressState == -1) {
//       ErrorDialog.show(
//         context,
//         widthDp: widthDp,
//         heightDp: heightDp,
//         fontSp: fontSp,
//         text: _authProvider.authState.message,
//         callBack: _authProvider.authState.callback,
//         cancelCallback: () {
//           _authProvider.setAuthState(
//             _authProvider.authState.update(callback: () {}),
//             isNotifiable: false,
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     /// Responsive design variables
//     deviceWidth = 1.sw;
//     deviceHeight = 1.sh;
//     statusbarHeight = ScreenUtil().statusBarHeight;
//     bottomBarHeight = ScreenUtil().bottomBarHeight;
//     appbarHeight = AppBar().preferredSize.height;

//     widthDp = ScreenUtil().setWidth(1);
//     heightDp = ScreenUtil().setWidth(1);
//     heightDp1 = ScreenUtil().setHeight(1);
//     fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
//
//     ///////////////////////////////

//     return Scaffold(
//       key: navigatorKey,
//       body: Container(
//         width: deviceWidth,
//         height: deviceHeight,
//         child: SingleChildScrollView(
//           child: Stack(
//             alignment: Alignment.topCenter,
//             children: <Widget>[
//               Container(width: deviceWidth, height: deviceHeight),
//               Positioned(
//                 top: 0,
//                 child: Container(
//                   width: deviceWidth,
//                   height: heightDp1 * 250,
//                   decoration: BoxDecoration(color: Theme.of(context).accentColor),
//                 ),
//               ),
//               Positioned(
//                 top: heightDp1 * (250 - 120),
//                 child: Text(
//                   'Let\'s Start with register!',
//                   style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Theme.of(context).primaryColor)),
//                 ),
//               ),
//               Positioned(
//                 top: heightDp1 * (250 - 70),
//                 child: Container(
//                   width: deviceWidth * 0.88,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor,
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     boxShadow: [BoxShadow(blurRadius: 50, color: Theme.of(context).hintColor.withOpacity(0.2))],
//                   ),
//                   margin: EdgeInsets.symmetric(horizontal: widthDp * 20),
//                   padding: EdgeInsets.symmetric(vertical: heightDp1 * 30, horizontal: widthDp * 20),
//                   child: Form(
//                     key: signUpFormKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         TextFormField(
//                           keyboardType: TextInputType.text,
//                           controller: firstNameController,
//                           focusNode: _firstNameFocusNode,
//                           validator: (input) => input.length < 1 ? S.of(context).input_first_name : null,
//                           decoration: InputDecoration(
//                             labelText: "First Name",
//                             labelStyle: TextStyle(color: Theme.of(context).accentColor),
//                             contentPadding: EdgeInsets.all(12),
//                             hintText: '',
//                             hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
//                             prefixIcon: Icon(Icons.person_rounded, color: Theme.of(context).accentColor),
//                             border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                             focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
//                             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                           ),
//                           onSaved: (input) => _userModel.firstName = input.trim(),
//                           onFieldSubmitted: (input) {
//                             FocusScope.of(context).requestFocus(_lastNameFocusNode);
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           keyboardType: TextInputType.text,
//                           controller: lastNameController,
//                           focusNode: _lastNameFocusNode,
//                           validator: (input) => input.length < 1 ? S.of(context).input_last_name : null,
//                           decoration: InputDecoration(
//                             labelText: "Last Name",
//                             labelStyle: TextStyle(color: Theme.of(context).accentColor),
//                             contentPadding: EdgeInsets.all(12),
//                             hintText: '',
//                             hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
//                             prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
//                             border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                             focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
//                             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                           ),
//                           onSaved: (input) => _userModel.lastName = input.trim(),
//                           onFieldSubmitted: (input) {
//                             FocusScope.of(context).requestFocus(_emailFocusNode);
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           keyboardType: TextInputType.emailAddress,
//                           controller: emailController,
//                           focusNode: _emailFocusNode,
//                           validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
//                           decoration: InputDecoration(
//                             labelText: "Email",
//                             labelStyle: TextStyle(color: Theme.of(context).accentColor),
//                             contentPadding: EdgeInsets.all(12),
//                             hintText: '',
//                             hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
//                             prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
//                             border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                             focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
//                             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                           ),
//                           onSaved: (input) => _userModel.email = input.trim(),
//                           onFieldSubmitted: (input) {
//                             FocusScope.of(context).requestFocus(_phoneFocusNode);
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           keyboardType: TextInputType.phone,
//                           controller: phoneController,
//                           focusNode: _phoneFocusNode,
//                           validator: (input) => input.isNotEmpty && input.length < 9 ? S.of(context).not_a_valid_phone : null,
//                           decoration: InputDecoration(
//                             labelText: "Phone Number",
//                             labelStyle: TextStyle(color: Theme.of(context).accentColor),
//                             contentPadding: EdgeInsets.all(12),
//                             hintText: '',
//                             hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
//                             prefixIcon: Icon(Icons.phone_android_outlined, color: Theme.of(context).accentColor),
//                             border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                             focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
//                             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                           ),
//                           onSaved: (input) => _userModel.mobile = input.trim(),
//                           onFieldSubmitted: (input) {
//                             FocusScope.of(context).requestFocus(_passwordFocusNode);
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           keyboardType: TextInputType.text,
//                           controller: passwordController,
//                           focusNode: _passwordFocusNode,
//                           validator: (input) => input.length < 8
//                               ? S.of(context).should_password_input
//                               : passwordController.text.trim() != confirmPasswordController.text.trim()
//                                   ? S.of(context).should_password_match
//                                   : null,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: "Password",
//                             labelStyle: TextStyle(color: Theme.of(context).accentColor),
//                             contentPadding: EdgeInsets.all(12),
//                             hintText: '••••••••••••',
//                             hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
//                             prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
//                             // suffixIcon: Icon(Icons.remove_red_eye, color: Theme.of(context).focusColor),
//                             border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                             focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
//                             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                           ),
//                           onSaved: (input) => _userModel.password = input.trim(),
//                           onFieldSubmitted: (input) {
//                             FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
//                           },
//                         ),
//                         SizedBox(height: 10),
//                         TextFormField(
//                           keyboardType: TextInputType.text,
//                           controller: confirmPasswordController,
//                           focusNode: _confirmPasswordFocusNode,
//                           validator: (input) => input.length < 8
//                               ? S.of(context).should_password_input
//                               : passwordController.text.trim() != confirmPasswordController.text.trim()
//                                   ? S.of(context).should_password_match
//                                   : null,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: "Confirm Password",
//                             labelStyle: TextStyle(color: Theme.of(context).accentColor),
//                             contentPadding: EdgeInsets.all(12),
//                             hintText: '••••••••••••',
//                             hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
//                             prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
//                             // suffixIcon: Icon(Icons.remove_red_eye, color: Theme.of(context).focusColor),
//                             border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                             focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
//                             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
//                           ),
//                           onSaved: (input) => _userModel.password = input.trim(),
//                           onFieldSubmitted: (input) {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                           },
//                         ),
//                         SizedBox(height: 30),
//                         BlockButtonWidget(
//                           text: Text(
//                             S.of(context).register,
//                             style: TextStyle(color: Theme.of(context).primaryColor),
//                           ),
//                           color: Theme.of(context).accentColor,
//                           onPressed: () {
//                             _onSignUpButtonPressed();
//                           },
//                         ),
//                         SizedBox(height: 25),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 10,
//                 child: FlatButton(
//                   onPressed: () {
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                         builder: (BuildContext context) => LoginWidget(callback: widget.callback),
//                       ),
//                     );
//                   },
//                   textColor: Theme.of(context).hintColor,
//                   child: Text('I have account? Back to login'),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   _onSignUpButtonPressed() async {
//     if (!signUpFormKey.currentState.validate()) return;

//     signUpFormKey.currentState.save();

//     await _keicyProgressDialog.show();

//     _userModel.fcmToken = KeicyFCMForMobile.token;

//     _authProvider.setAuthState(
//       _authProvider.authState.update(progressState: 1, callback: _onSignUpButtonPressed),
//       isNotifiable: false,
//     );

//     _authProvider.registerUser(_userModel);
//   }
// }
