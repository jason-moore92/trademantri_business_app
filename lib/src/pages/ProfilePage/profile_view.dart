import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/QRCodePage/index.dart';
import 'package:trapp/src/pages/UPIStand/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/pages/BusinessDetailPage/index.dart';
import 'package:trapp/src/pages/ContactDetailPage/index.dart';
import 'package:trapp/src/pages/DeliverySettingsPage/index.dart';
import 'package:trapp/src/pages/GSTDetailPage/index.dart';
import 'package:trapp/src/pages/TermsDetailPage/index.dart';
import 'package:trapp/src/pages/PrivacyDetailPage/index.dart';
import 'package:trapp/src/pages/StoreTimingDetailPage/index.dart';
import 'package:trapp/src/pages/BankDetailPage/index.dart';

import 'index.dart';
import '../../elements/keicy_progress_dialog.dart';

class ProfileView extends StatefulWidget {
  final bool haveAppbar;

  ProfileView({Key? key, this.haveAppbar = true}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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

  AuthProvider? _authProvider;
  StoreProvider? _storeProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  StoreModel _storeModel = StoreModel();

  ImagePicker picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();

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

    _authProvider = AuthProvider.of(context);
    _storeProvider = StoreProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _storeModel = StoreModel.copy(_authProvider!.authState.storeModel!);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _storeProvider!.addListener(_storeProviderListener);
    });
  }

  @override
  void dispose() {
    _storeProvider!.removeListener(_storeProviderListener);
    super.dispose();
  }

  void _storeProviderListener() async {
    if (_storeProvider!.storeState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }

    if (_storeProvider!.storeState.progressState == 2) {
      _authProvider!.setAuthState(
        _authProvider!.authState.update(storeModel: _storeModel),
      );

      setState(() {});
      SuccessDialog.show(context, heightDp: heightDp, fontSp: fontSp);
    } else if (_storeProvider!.storeState.progressState == -1) {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: _storeProvider!.storeState.message!,
      );
    }
  }

  void _saveHandler() async {
    if (_imageFile == null) return;
    await _keicyProgressDialog!.show();
    _storeProvider!.setStoreState(_storeProvider!.storeState.update(progressState: 1), isNotifiable: false);
    _storeProvider!.updateStore(id: _storeModel.id, storeData: _storeModel.toJson(), imageFile: _imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.haveAppbar
          ? AppBar(
              backgroundColor: config.Colors().mainColor(1),
              centerTitle: true,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                ProfilePageString.appbarTitle,
                style: TextStyle(fontSize: fontSp * 20, color: Colors.white),
              ),
              elevation: 0,
            )
          : null,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: deviceWidth,
            child: Column(
              children: [
                _profileImagePanel(),
                _listPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileImagePanel() {
    return Center(
      child: Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 20),
        color: config.Colors().mainColor(1),
        child: Center(
          child: Column(
            children: [
              Container(
                width: widthDp * 180,
                height: widthDp * 180,
                child: KeicyAvatarImage(
                  url: _storeModel.profile!["image"],
                  width: widthDp * 180,
                  height: widthDp * 180,
                  backColor: Colors.grey.withOpacity(0.4),
                  borderRadius: heightDp * 6,
                  imageFile: _imageFile,
                  textStyle: TextStyle(fontSize: fontSp * 22, color: Colors.black),
                  errorWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(heightDp * 6),
                    child: Image.asset(
                      "img/store-icon/${_storeModel.subType!.toLowerCase()}-store.png",
                      width: widthDp * 80,
                      height: widthDp * 80,
                    ),
                  ),
                ),
              ),
              SizedBox(height: heightDp * 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectOptionBottomSheet();
                    },
                    child: Icon(Icons.edit_outlined, size: heightDp * 30, color: Colors.white),
                  ),
                  SizedBox(width: widthDp * 15),
                  GestureDetector(
                    onTap: _saveHandler,
                    child: Container(
                      padding: EdgeInsets.all(heightDp * 5),
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: fontSp * 20, color: Colors.white.withOpacity(_imageFile != null ? 1 : 0.6)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectOptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(heightDp * 8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: deviceWidth,
                    padding: EdgeInsets.all(heightDp * 10.0),
                    child: Text(
                      "Choose Option",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _getAvatarImage(ImageSource.camera);
                    },
                    child: Container(
                      width: deviceWidth,
                      padding: EdgeInsets.all(heightDp * 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt,
                            color: Colors.black.withOpacity(0.7),
                            size: heightDp * 25.0,
                          ),
                          SizedBox(width: widthDp * 10.0),
                          Text(
                            "From Camera",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _getAvatarImage(ImageSource.gallery);
                    },
                    child: Container(
                      width: deviceWidth,
                      padding: EdgeInsets.all(heightDp * 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.photo, color: Colors.black.withOpacity(0.7), size: heightDp * 25),
                          SizedBox(width: widthDp * 10.0),
                          Text(
                            "From Gallery",
                            style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future _getAvatarImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, maxWidth: 500, maxHeight: 500);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      FlutterLogs.logInfo(
        "profile_view",
        "_getAvatarImage",
        "No image selected.",
      );
    }
  }

  Widget _listPanel() {
    return Column(
      children: [
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0)),
        ListTile(
          dense: true,
          title: Text(
            "Qr code",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            onPressed: null,
          ),
          onTap: () async {
            _storeProvider!.removeListener(_storeProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => QRCodePage(),
              ),
            );
            _storeProvider!.addListener(_storeProviderListener);
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        if (Environment.envName != "production") ...[
          ListTile(
            dense: true,
            title: Text(
              "UPI",
              style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            ),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
              onPressed: null,
            ),
            onTap: () async {
              _storeProvider!.removeListener(_storeProviderListener);
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => UPIStandPage(),
                ),
              );
              _storeProvider!.addListener(_storeProviderListener);
            },
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        ],
        ListTile(
          dense: true,
          title: Text(
            "Bank Detail",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            onPressed: null,
          ),
          onTap: () async {
            _storeProvider!.removeListener(_storeProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => BankDetailPage(),
              ),
            );
            _storeProvider!.addListener(_storeProviderListener);
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        ListTile(
          dense: true,
          title: Text(
            "Business Detail",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            onPressed: null,
          ),
          onTap: () async {
            _storeProvider!.removeListener(_storeProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => BusinessDetailPage(),
              ),
            );
            _storeProvider!.addListener(_storeProviderListener);
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        ListTile(
          dense: true,
          title: Text(
            "Contact Detail",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            onPressed: null,
          ),
          onTap: () async {
            _storeProvider!.removeListener(_storeProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ContactDetailPage(),
              ),
            );
            _storeProvider!.addListener(_storeProviderListener);
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        ListTile(
          dense: true,
          title: Text(
            "Delivery Settings",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            onPressed: null,
          ),
          onTap: () async {
            _storeProvider!.removeListener(_storeProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => DeliverySettingsPage(),
              ),
            );
            _storeProvider!.addListener(_storeProviderListener);
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        ListTile(
          dense: true,
          title: Text(
            "Gst Detail",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            onPressed: null,
          ),
          onTap: () async {
            _storeProvider!.removeListener(_storeProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => GSTDetailPage(),
              ),
            );
            _storeProvider!.addListener(_storeProviderListener);
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        ListTile(
          dense: true,
          title: Text(
            "Store Timing",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            onPressed: null,
          ),
          onTap: () async {
            _storeProvider!.removeListener(_storeProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => StoreTimingDetailPage(),
              ),
            );
            _storeProvider!.addListener(_storeProviderListener);
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        ListTile(
          dense: true,
          title: Text(
            "Terms and Conditions",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            onPressed: null,
          ),
          onTap: () async {
            _storeProvider!.removeListener(_storeProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => TermsDetailPage(),
              ),
            );
            _storeProvider!.addListener(_storeProviderListener);
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
        ListTile(
          dense: true,
          title: Text(
            "Privacy Policy",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
          ),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: heightDp * 20, color: Colors.black),
            onPressed: null,
          ),
          onTap: () async {
            _storeProvider!.removeListener(_storeProviderListener);
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => PrivacyDetailPage(),
              ),
            );
            _storeProvider!.addListener(_storeProviderListener);
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
      ],
    );
  }
}
