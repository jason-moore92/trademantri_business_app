import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/models/business_connection_model.dart';
import 'package:trapp/src/pages/BusinessInvitationsPage/business_invitations_page.dart';
import 'package:trapp/src/pages/BusinessStoresPage/business_stores_page.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/providers/index.dart';

class BusinessNetworkView extends StatefulWidget {
  BusinessNetworkView({Key? key}) : super(key: key);

  @override
  _BusinessNetworkViewState createState() => _BusinessNetworkViewState();
}

class _BusinessNetworkViewState extends State<BusinessNetworkView> with SingleTickerProviderStateMixin {
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

  BusinessNetworkStatusProvider? _businessNetworkStatusProvider;

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

    _businessNetworkStatusProvider = BusinessNetworkStatusProvider.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _businessNetworkStatusProvider!.networkStatus(storeId: AuthProvider.of(context).authState.storeModel!.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Manage My Network",
          style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Consumer<BusinessNetworkStatusProvider>(builder: (context, businessNetworkStatusProvider, _) {
        if (businessNetworkStatusProvider.businessInvitationsPageState.progressState == 0 ||
            businessNetworkStatusProvider.businessInvitationsPageState.progressState == 1) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (businessNetworkStatusProvider.businessInvitationsPageState.progressState == -1) {
          return ErrorPage(
            message: businessNetworkStatusProvider.businessInvitationsPageState.message,
            callback: () {
              businessNetworkStatusProvider.setBusinessNetworkStatusState(
                businessNetworkStatusProvider.businessInvitationsPageState.update(progressState: 1),
              );

              _businessNetworkStatusProvider!.networkStatus(storeId: AuthProvider.of(context).authState.storeModel!.id);
            },
          );
        }

        return Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 2, height: heightDp * 2),
              ListTile(
                dense: false,
                title: Row(
                  children: [
                    Icon(Icons.contact_page_outlined, size: heightDp * 25),
                    SizedBox(width: widthDp * 10),
                    Text(
                      "Connections",
                      style: TextStyle(fontSize: fontSp * 18),
                    ),
                  ],
                ),
                trailing: Text(
                  "${businessNetworkStatusProvider.businessInvitationsPageState.networkStatus!["connections"]}",
                  style: TextStyle(fontSize: fontSp * 14),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BusinessStoresPage(status: ConnectionStatus.active),
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 2, height: heightDp * 2),
              ListTile(
                dense: false,
                title: Row(
                  children: [
                    Icon(Icons.people_outline, size: heightDp * 25),
                    SizedBox(width: widthDp * 10),
                    Text(
                      "Groups",
                      style: TextStyle(fontSize: fontSp * 18),
                    ),
                  ],
                ),
                trailing: Text(
                  "0",
                  style: TextStyle(fontSize: fontSp * 14),
                ),
                onTap: () {
                  ComingSoonDialog.show(context);
                },
              ),
              Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 2, height: heightDp * 2),
              ListTile(
                dense: false,
                title: Row(
                  children: [
                    Icon(Icons.insert_invitation_outlined, size: heightDp * 25),
                    SizedBox(width: widthDp * 10),
                    Text(
                      "Invitations",
                      style: TextStyle(fontSize: fontSp * 18),
                    ),
                  ],
                ),
                trailing: Text(
                  "${businessNetworkStatusProvider.businessInvitationsPageState.networkStatus!["pending"]}",
                  style: TextStyle(fontSize: fontSp * 14),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BusinessInvitationsPage(status: [ConnectionStatus.pending]),
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 2, height: heightDp * 2),
              ListTile(
                dense: false,
                title: Row(
                  children: [
                    Icon(Icons.people_outline, size: heightDp * 25),
                    SizedBox(width: widthDp * 10),
                    Text(
                      "Rejected",
                      style: TextStyle(fontSize: fontSp * 18),
                    ),
                  ],
                ),
                trailing: Text(
                  "${businessNetworkStatusProvider.businessInvitationsPageState.networkStatus!["rejected"]}",
                  style: TextStyle(fontSize: fontSp * 14),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BusinessInvitationsPage(status: [ConnectionStatus.rejected]),
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey.withOpacity(0.6), thickness: heightDp * 2, height: heightDp * 2),
            ],
          ),
        );
      }),
    );
  }
}
