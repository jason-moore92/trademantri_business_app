import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/DrawerFooter.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/string_helper.dart';
import 'package:trapp/src/models/index.dart';
import 'package:trapp/src/pages/AboutUsPage/index.dart';
import 'package:trapp/src/pages/AnnouncementListPage/index.dart';
import 'package:trapp/src/pages/AppointmentListPage/index.dart';
import 'package:trapp/src/pages/BargainRequestListPage/index.dart';
import 'package:trapp/src/pages/BookAppointmentListPage/index.dart';
import 'package:trapp/src/pages/ChatListPage/index.dart';
import 'package:trapp/src/pages/CouponListPage/index.dart';
import 'package:trapp/src/pages/HelpSupportPage/index.dart';
import 'package:trapp/src/pages/InvoiceListPage/index.dart';
import 'package:trapp/src/pages/KYCDocsPage/index.dart';
import 'package:trapp/src/pages/NewCustomerForChatPage/index.dart';
import 'package:trapp/src/pages/NotificationListPage/notification_list_page.dart';
import 'package:trapp/src/pages/OrderListPage/index.dart';
import 'package:trapp/src/pages/PaymentLinkListPage/index.dart';
import 'package:trapp/src/pages/ReferEarnPage/index.dart';
import 'package:trapp/src/pages/ReverseAuctionListPage/index.dart';
import 'package:trapp/src/pages/RewardPointsForCustomerPage/index.dart';
import 'package:trapp/src/pages/RewardPointsForStorePage/index.dart';
import 'package:trapp/src/pages/Settlements/index.dart';
import 'package:trapp/src/pages/StoreJobPostingsListPage/index.dart';
import 'package:trapp/src/pages/Wallet/index.dart';
import 'package:trapp/src/pages/dashboard.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/pages/ContactUsPage/index.dart';
import 'dart:io';

import 'package:trapp/src/pages/LegalResourcesPage/index.dart';
import 'package:trapp/src/pages/SettingsPage/index.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';

import 'keicy_progress_dialog.dart';
import 'package:trapp/config/app_config.dart' as config;

class DrawerWidget extends StatelessWidget {
  var userData;
  File? _image;
  String? imagePath;

  KeicyProgressDialog? keicyProgressDialog;

  @override
  Widget build(BuildContext context) {
    keicyProgressDialog = KeicyProgressDialog.of(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
              ),
              accountName: Text(
                StringHelper.getUpperCaseString(
                  "${AuthProvider.of(context).authState.storeModel!.profile!['ownerInfo']['firstName']}"
                  " "
                  "${AuthProvider.of(context).authState.storeModel!.profile!['ownerInfo']['lastName']}",
                ),
                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 20, color: Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              accountEmail: Text(
                "${AuthProvider.of(context).authState.storeModel!.email!}",
                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16, color: Colors.black),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: KeicyAvatarImage(
                    url: AuthProvider.of(context).authState.storeModel!.profile!["image"] ?? "",
                    userName: AuthProvider.of(context).authState.businessUserModel!.name,
                    width: 135,
                    height: 135,
                    backColor: Colors.grey.withOpacity(0.5),
                    textStyle: TextStyle(fontSize: 25, color: Colors.black),
                    errorWidget: ClipRRect(
                      child: Image.asset(
                        "img/store-icon/${AuthProvider.of(context).authState.storeModel!.subType}-store.png",
                        width: 135,
                        height: 135,
                      ),
                    ),
                  ),
                ),
                radius: 50.0,
                // backgroundImage: NetworkImage('https://via.placeholder.com/300'),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/Pages',
                ModalRoute.withName('/'),
                arguments: {"currentTab": 2},
              );
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Home",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => DashboardPage(),
                ),
              );
            },
            leading: Icon(
              Icons.dashboard,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Dashboard",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => NotificationListPage(haveAppBar: true)),
              );
            },
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Notifications",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)),
                );
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)),
                  );
                });
              }
            },
            leading: Icon(
              Icons.fastfood,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "My Orders",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => BookAppointmentListPage(),
                  ),
                );
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BookAppointmentListPage(),
                    ),
                  );
                });
              }
            },
            leading: Icon(
              Icons.event,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Bookings",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),

          if (Environment.envName != "production")
            ListTile(
              onTap: () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => WalletPage(
                        haveAppBar: true,
                      ),
                    ),
                  );
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => WalletPage(
                          haveAppBar: true,
                        ),
                      ),
                    );
                  });
                }
              },
              leading: Icon(
                Icons.account_balance_wallet,
                color: Theme.of(context).focusColor.withOpacity(1),
              ),
              title: Text(
                "Wallet",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          if (Environment.envName != "production")
            ListTile(
              onTap: () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => SettlementsPage(
                        haveAppBar: true,
                      ),
                    ),
                  );
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SettlementsPage(
                          haveAppBar: true,
                        ),
                      ),
                    );
                  });
                }
              },
              leading: Icon(
                Icons.save_alt,
                color: Theme.of(context).focusColor.withOpacity(1),
              ),
              title: Text(
                "Settlements",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),

          ListTile(
            onTap: () async {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => NewCustomerForChatPage(fromSidebar: true),
                ),
              );
            },
            leading: Icon(
              Icons.people_sharp,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Customers",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
          //       Navigator.of(context).pop();
          //       Navigator.of(context).push(
          //         MaterialPageRoute(builder: (BuildContext context) => PaymentLinkListPage()),
          //       );
          //     } else {
          //       LoginAskDialog.show(context, callback: () {
          //         Navigator.of(context).pop();
          //         Navigator.of(context).push(
          //           MaterialPageRoute(builder: (BuildContext context) => PaymentLinkListPage()),
          //         );
          //       });
          //     }
          //   },
          //   leading: Image.asset(
          //     "img/payment.png",
          //     width: 25,
          //     height: 25,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     "Payment Links",
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => InvoiceListPage()),
                );
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => InvoiceListPage()),
                  );
                });
              }
            },
            leading: Image.asset(
              "img/payment.png",
              width: 25,
              height: 25,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Invoices",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => ChatListPage()),
                );
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => ChatListPage()),
                  );
                });
              }
            },
            leading: Icon(
              Icons.chat,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Chats",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => BargainRequestListPage(haveAppBar: true)),
              );
            },
            leading: Image.asset(
              "img/bargain-icon.png",
              width: 25,
              height: 25,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Bargain Request",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => ReverseAuctionListPage(haveAppBar: true)),
              );
            },
            leading: Image.asset(
              "img/reverse_auction-icon.png",
              width: 25,
              height: 25,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Reverse Auction",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RewardPointsForCustomerPage()));
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RewardPointsForCustomerPage()));
                });
              }
            },
            leading: Image.asset(
              "img/reward_points_icon.png",
              width: 25,
              height: 25,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Customer Reward Points",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RewardPointsForStorePage()));
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RewardPointsForStorePage()));
                });
              }
            },
            leading: Image.asset(
              "img/reward_points_icon.png",
              width: 25,
              height: 25,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "My Store Reward Points",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => StoreJobPostingsListPage()),
                );
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => StoreJobPostingsListPage()),
                  );
                });
              }
            },
            leading: Image.asset(
              "img/jobs.png",
              width: 25,
              height: 25,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Jobs",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CouponListPage(
                      storeModel: AuthProvider.of(context).authState.storeModel,
                    ),
                  ),
                );
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => CouponListPage(
                        storeModel: AuthProvider.of(context).authState.storeModel,
                      ),
                    ),
                  );
                });
              }
            },
            leading: Image.asset(
              "img/coupons.png",
              width: 25,
              height: 25,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Coupons",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AnnouncementListPage(
                      storeModel: AuthProvider.of(context).authState.storeModel,
                    ),
                  ),
                );
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => AnnouncementListPage(
                        storeModel: AuthProvider.of(context).authState.storeModel,
                      ),
                    ),
                  );
                });
              }
            },
            leading: Image.asset(
              "img/announcements_grey.png",
              width: 25,
              height: 25,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Announcements",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => AppointmentListPage()),
                );
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => AppointmentListPage()),
                  );
                });
              }
            },
            leading: Icon(
              Icons.event,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Appointments",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ReferEarnPage()));
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ReferEarnPage()));
                });
              }
            },
            leading: Image.asset(
              "img/reward_points_icon.png",
              width: 25,
              height: 25,
              // color: Theme.of(context).iconTheme.color,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Refer & Earn",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/Profile');
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/Profile');
                });
              }
            },
            leading: Icon(
              Icons.person,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SettingsPage()));
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Settings",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => HelpSupportPage()),
              );
            },
            leading: Icon(
              Icons.help,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Help",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
          //       Navigator.of(context).pop();
          //       _launchCommunity(context);
          //     } else {
          //       LoginAskDialog.show(context, callback: () {
          //         Navigator.of(context).pop();
          //         _launchCommunity(context);
          //       });
          //     }
          //   },
          //   leading: Icon(
          //     Icons.people,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     "Community",
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          ListTile(
            onTap: () {
              if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                Navigator.of(context).pop();
                Freshchat.showConversations();
              } else {
                LoginAskDialog.show(context, callback: () {
                  Navigator.of(context).pop();
                  Freshchat.showConversations();
                });
              }
            },
            leading: Icon(
              Icons.chat_bubble,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Customer Support",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            trailing: SizedBox(
              width: 32,
              child: StreamBuilder<dynamic>(
                stream: Freshchat.onMessageCountUpdate,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red[500]!,
                        ),
                        color: Colors.red[500],
                        borderRadius: BorderRadius.all(
                          Radius.circular(32),
                        ),
                      ),
                      child: FutureBuilder<Map<dynamic, dynamic>>(
                        future: Freshchat.getUnreadCountAsync,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!["count"].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            );
                          }
                          return Text(
                            "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Languages",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LegalResourcesPage()));
            },
            leading: Image.asset(
              "img/lega.png",
              width: 25,
              height: 25,
            ),
            title: Text(
              "Legal Resources",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => KYCDocsPage()));
            },
            leading: Image.asset(
              "img/lega.png",
              width: 25,
              height: 25,
            ),
            title: Text(
              "KYC Documents",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => AboutUsPage()),
              );
            },
            leading: Image.asset(
              "img/aboutus.png",
              width: 25,
              height: 25,
            ),
            title: Text(
              "About us",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => ContactUsPage()),
              );
            },
            leading: Image.asset(
              "img/contactus.png",
              width: 25,
              height: 25,
            ),
            title: Text(
              "Contact us",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () async {
              try {
                await keicyProgressDialog!.show();
                var result = await AuthProvider.of(context).logout();
                await keicyProgressDialog!.hide();

                if (result) {
                  AppDataProvider.of(context).initProviderHandler(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => LoginWidget()),
                    (route) => false,
                  );
                }
              } catch (e) {}
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Log out",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Divider(),
          DrawerFooterWidget(),
        ],
      ),
    );
  }

  void _launchCommunity(context) async {
    try {
      String? otherCreds = AppDataProvider.of(context).prefs!.getString("other_creds");
      if (AuthProvider.of(context).authState.storeModel != null && AuthProvider.of(context).authState.storeModel!.id != null) {
        if (AuthProvider.of(context).authState.storeModel!.email != null) {
          Fluttertoast.showToast(
            msg: "Please update your email in profile, to access community discussions.",
          );
          return;
        }
      }
      if (otherCreds == null) {
        return;
      }
      Map<String, dynamic> otherCredsData = jsonDecode(otherCreds);

      if (!otherCredsData.containsKey('community')) {
        return;
      }
      await launch(
        otherCredsData['community']['login_url'],
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
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
