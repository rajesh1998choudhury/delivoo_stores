import 'package:delivoo_stores/Provider/OrderProvider.dart';
import 'package:delivoo_stores/Provider/ProductProvider.dart';
import 'package:delivoo_stores/Provider/insight_provider.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Provider/profileProvider.dart';
import 'package:delivoo_stores/Provider/select_time_provider.dart';
import 'package:delivoo_stores/Routes/routes.dart';
import 'package:delivoo_stores/StoreOrdering/StoreOrderingProvider/paylaterProvider.dart';
import 'package:delivoo_stores/Themes/style.dart';
import 'package:delivoo_stores/geo/LocationProvider.dart';
import 'package:delivoo_stores/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'Provider/CategoryProvider.dart';
import 'StoreOrdering/StoreOrderingProvider/StoreOrderingProvider.dart';
import 'StoreOrdering/StoreOrderingProvider/StoreOrdering_storeProvider.dart';
import 'StoreOrdering/StoreOrderingProvider/paymentProvider.dart';
import 'StoreOrdering/StoreOrderingProvider/storeOrdering_addressProvider.dart';
import 'StoreOrdering/StoreOrderingProvider/storeOrdering_category_provider.dart';
import 'StoreOrdering/StoreOrderingProvider/store_product_provider.dart';
import 'Utils/CommonWidget.dart';

final navigatorKey = GlobalKey<NavigatorState>();
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
  if (message.notification!.title == "New Order" ||
      message.notification!.title == "New_Order") {
    Future.delayed(Duration(milliseconds: 1500), () {
      showCallkitIncoming();
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      //'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
      showBadge: true,
      enableLights: true,
      enableVibration: true,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    LocaStores(),
  );
}

class LocaStores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<ProductProvider>(
            create: (_) => ProductProvider()),
        ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
        ChangeNotifierProvider<InsightProvider>(
            create: (_) => InsightProvider()),
        ChangeNotifierProvider<LocationServiceProvider>(
            create: (_) => LocationServiceProvider()),
        ChangeNotifierProvider<CategoryProvider>(
            create: (_) => CategoryProvider()),
        ChangeNotifierProvider<SelectTimeProvider>(
            create: (_) => SelectTimeProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider()),
        ChangeNotifierProvider<StoreOrderingProductProvider>(
            create: (_) => StoreOrderingProductProvider()),
        ChangeNotifierProvider<StoreOrderingCategoryProvider>(
            create: (_) => StoreOrderingCategoryProvider()),
        ChangeNotifierProvider<StoreOrderingStoreProvider>(
            create: (_) => StoreOrderingStoreProvider()),
        ChangeNotifierProvider<StoreOrderingAddressprovider>(
            create: (_) => StoreOrderingAddressprovider()),
        ChangeNotifierProvider<PaymentProvider>(
            create: (_) => PaymentProvider()),
        ChangeNotifierProvider<StoreOrderProvider>(
            create: (_) => StoreOrderProvider()),
        ChangeNotifierProvider<PayLaterProvider>(
            create: (_) => PayLaterProvider()),
      ],
      child: MaterialApp(
        title: 'Kisanserv Store',
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1.0)),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: appTheme,
        home: Splash(),
        routes: PageRoutes().routes(),
      ),
    );
  }
}
