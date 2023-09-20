import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trapp/config/global.dart';
import 'package:trapp/src/elements/DrawerWidget.dart';
import 'package:trapp/src/elements/cart_of_all_store_widget.dart';
import 'package:trapp/src/elements/profile_icon_widget.dart';
import 'package:trapp/src/elements/qrcode_icon_widget.dart';
import 'package:trapp/src/pages/AnnouncementListForOtherPage/announcement_list_for_other_page.dart';
import 'package:trapp/src/pages/home.dart';
import 'package:trapp/src/pages/NotificationListPage/index.dart';
import 'package:trapp/src/services/dynamic_link_service.dart';

import 'NewCustomerForChatPage/index.dart';
import 'OrderListPage/index.dart';
import 'dashboard.dart';

class PagesTestWidget extends StatefulWidget {
  int? currentTab = 2;
  String currentTitle = 'Home';
  Widget currentPage = HomeWidget();
  Map<String, dynamic>? categoryData;

  PagesTestWidget({
    Key? key,
    this.currentTab,
    this.categoryData,
  }) : super(key: key);

  @override
  _PagesTestWidgetState createState() {
    return _PagesTestWidgetState();
  }
}

class _PagesTestWidgetState extends State<PagesTestWidget> {
  @override
  void initState() {
    super.initState();

    _selectTab(widget.currentTab!);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      GlobalVariables.dynamicLinkService.retrieveDynamicLink(context, isFirst: false);
    });
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentTitle = 'Customers';
          widget.currentPage = NewCustomerForChatPage(fromBottomBar: true, haveAppbar: false);
          break;
        case 1:
          widget.currentTitle = 'My Notifications';
          widget.currentPage = NotificationListPage();

          break;
        case 2:
          widget.currentTitle = 'Home';
          widget.currentPage = HomeWidget();
          break;
        case 3:
          widget.currentTitle = 'My Orders';
          widget.currentPage = OrderListPage();
          // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)));
          break;
        case 4:
          widget.currentTitle = 'Dashboard';
          widget.currentPage = DashboardPage(haveAppBar: false);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);

    return Scaffold(
      drawer: DrawerWidget(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        title: Center(
          child: Text(
            widget.currentTitle,
            style: Theme.of(context).textTheme.headline6!.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => AnnouncementListForOtherPage(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 5),
                  color: Colors.transparent,
                  child: Image.asset("img/announcements.png", width: heightDp * 35, height: heightDp * 35, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: heightDp * 40,
                height: heightDp * 30,
                child: QRCodeIconWidget(),
              ),
              SizedBox(width: 8),
              ProfileIconWidget(),
              SizedBox(width: 15),
            ],
          ),
        ],
      ),
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
        currentIndex: widget.currentTab!,
        onTap: (int i) {
          widget.categoryData = null;
          this._selectTab(i);
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
              title: new Container(height: 5.0),
              icon: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    // BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                    BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                  ],
                ),
                child: new Icon(Icons.home, color: Theme.of(context).primaryColor),
              )),
          BottomNavigationBarItem(
            icon: new Icon(Icons.bookmarks_rounded),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.dashboard),
            title: new Container(height: 0.0),
          ),
        ],
      ),
    );
  }
}
