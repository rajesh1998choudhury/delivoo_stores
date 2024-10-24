// ignore_for_file: unused_local_variable, deprecated_member_use, unused_element

import 'dart:io';

import 'package:delivoo_stores/Chat/UI/animated_bottom_bar.dart';
import 'package:delivoo_stores/OrderItemAccount/Order/UI/OrderTab.dart';
import 'package:delivoo_stores/Pages/category.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/store_category_main_page.dart';
// import 'package:delivoo_stores/StoreOrdering/Pages/store_category_page.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:delivoo_stores/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/OrderProvider.dart';
import '../Provider/login_provider.dart';
import 'Account/UI/account_page.dart';
import 'package:provider/provider.dart';

class OrderItemAccount extends StatefulWidget {
  @override
  _OrderItemAccountState createState() => _OrderItemAccountState();
}

class _OrderItemAccountState extends State<OrderItemAccount> {
  Permission _permission = Permission.location;
  double? opac;
  // ignore: unused_field
  PermissionStatus? _status;
  getDetails() async {
    print("Push Notification");
    await context.read<LoginProvider>().pushNotifications("1");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await context
        .read<LoginProvider>()
        .getStoreLocationonStart(await prefs.getString('ware_house'));
    if (prefs.getString("skipNotification") == null) {
      if (mounted) return;
      context.read<LoginProvider>().storeType == "0"
          ? SizedBox.shrink()
          : await notification_warning(prefs);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () async {
      Platform.isAndroid ? await checkVersion(context) : '';
      if (context.read<LoginProvider>().banner != null &&
          context.read<LoginProvider>().banner?.d != null &&
          context.read<LoginProvider>().banner?.d!.length != 0) {
        await banner(context.read<LoginProvider>().banner?.d![0].bannerimg);
      }
      await getDetails();
    }).whenComplete(() async {
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {});

      //Foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        AppleNotification? apple = message.notification?.apple;
        if (notification != null && android != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    icon: "alphastore_icon",
                    channelShowBadge: false,
                    playSound: false,
                    fullScreenIntent: true,
                    importance: Importance.high,
                    ongoing: true

                    // sound: RawResourceAndroidNotificationSound('notification'),
                    ),
              ));
          Future.delayed(Duration(milliseconds: 1500), () {
            if (notification.title == "New Order" ||
                notification.title == "New_Order") {
              showCallkitIncoming();
            }
          });
        } else if (notification != null && apple != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                iOS: IOSNotificationDetails(
                    presentAlert: true, presentBadge: true, presentSound: true),
              ));
          Future.delayed(Duration(milliseconds: 1500), () {
            if (notification.title == "New Order" ||
                notification.title == "New_Order") {
              showCallkitIncoming();
            }
          });
        }
      });
      //background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        //background message event here
      });
    });

    super.initState();
    _listenForPermissionStatus();
    requestPermission(_permission);

    //out of stack
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) {});

    // //Foreground
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   AppleNotification? apple = message.notification?.apple;
    //   if (notification != null && android != null && !kIsWeb) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(channel.id, channel.name,
    //               channelDescription: channel.description,
    //               icon: "alphastore_icon",
    //               channelShowBadge: false,
    //               playSound: false,
    //               fullScreenIntent: true,
    //               importance: Importance.high,
    //               ongoing: true

    //               // sound: RawResourceAndroidNotificationSound('notification'),
    //               ),
    //         ));
    //     Future.delayed(Duration(milliseconds: 1500), () {
    //       if (notification.title == "New Order" ||
    //           notification.title == "New_Order") {
    //         showCallkitIncoming();
    //       }
    //     });
    //   } else if (notification != null && apple != null && !kIsWeb) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           iOS: IOSNotificationDetails(
    //               presentAlert: true, presentBadge: true, presentSound: true),
    //         ));
    //     Future.delayed(Duration(milliseconds: 1500), () {
    //       if (notification.title == "New Order" ||
    //           notification.title == "New_Order") {
    //         showCallkitIncoming();
    //       }
    //     });
    //   }
    // });
    // //background
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   //background message event here
    // });
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _status = status);
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
  }

  final List<BarItem> barItems = [
    BarItem(
        text: 'Order',
        image: bottomIconOrder,
        opacity:
            navigatorKey.currentContext!.read<LoginProvider>().storeType == "0"
                ? 0.5
                : 1),
    BarItem(
        text: 'Product',
        image: bottomIconItem,
        opacity:
            navigatorKey.currentContext!.read<LoginProvider>().storeType == "0"
                ? 0.5
                : 1),
    BarItem(text: 'Shop Ordering', image: bottomIconShop, opacity: 1.0),
    BarItem(text: 'Account', image: bottomIconAccount, opacity: 1.0),
  ];

  final List<Widget> _children = [
    OrderTab(),
    CategoryPage(),
    // StoreCategoryPage(),
    StoreCategoryMainPage(),
    AccountPage(),
  ];

  static String bottomIconItem = 'images/footermenu/ic_item.png';
  static String bottomIconOrder = 'images/footermenu/ic_orders.png';
  static String bottomIconAccount = 'images/footermenu/ic_profile.png';
  static String bottomIconShop = 'images/footermenu/warehouse.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[context.watch<LoginProvider>().currentIndex!],
      bottomNavigationBar: Material(
        shadowColor: Colors.amber,
        color: Colors.indigo,
        child: AnimatedBottomBar(
            barItems: barItems,
            onBarTap: (index) {
              context.read<OrderProvider>().timer?.cancel();

              if (navigatorKey.currentContext!
                      .read<LoginProvider>()
                      .storeType !=
                  "0") {
                context.read<LoginProvider>().onTapped(index);
              } else if (navigatorKey.currentContext!
                      .read<LoginProvider>()
                      .storeType ==
                  "0") {
                if (index > 1) {
                  context.read<LoginProvider>().onTapped(index);
                }
              }
            }),
      ),
    );
  }
}
