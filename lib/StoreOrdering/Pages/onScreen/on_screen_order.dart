// // // ignore_for_file: deprecated_member_use

// // import 'package:delivoo_stores/Auth/MobileNumber/UI/phone_number.dart';
// // import 'package:delivoo_stores/OrderItemAccount/Order/UI/NewOrderPage.dart';
// // import 'package:delivoo_stores/OrderItemAccount/Order/UI/NextdayOrderPage.dart';
// // import 'package:delivoo_stores/Provider/OrderProvider.dart';
// // import 'package:delivoo_stores/Provider/login_provider.dart';
// // import 'package:delivoo_stores/Themes/colors.dart';
// // import 'package:delivoo_stores/Utils/CommonWidget.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class OnScreenOrder extends StatefulWidget {
// //   const OnScreenOrder({Key? key}) : super(key: key);

// //   @override
// //   State<OnScreenOrder> createState() => _OnScreenOrderState();
// // }

// // class _OnScreenOrderState extends State<OnScreenOrder>
// //     with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   final List<Tab> tabs = <Tab>[
// //     Tab(text: 'NEW ORDERS'),
// //     Tab(text: 'NEXT DAY ORDERS'),
// //   ];

// //   @override
// //   void initState() {
// //     _tabController = TabController(length: tabs.length, vsync: this);
// //     Future.delayed(Duration.zero, () async {
// //       await context.read<LoginProvider>().getData();
// //       // await checkVersion(context);
// //       // await context.read<LoginProvider>().pushNotifications("1");
// //     });
// //     // _tabController = TabController(length: tabs.length, vsync: );
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// // ignore_for_file: deprecated_member_use

// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 2,
// //       child: WillPopScope(
// //         onWillPop: onWillPop,
// //         child: Scaffold(
// //           appBar: PreferredSize(
// //             preferredSize: Size.fromHeight(
// //                 context.watch<LoginProvider>().userType == "2" ? 118 : 100.0),
// //             child: AppBar(
// //               title: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     'Order Details',
// //                     style: TextStyle(fontSize: 20, color: Colors.white),
// //                   ),
// //                   SizedBox(
// //                     width: 20,
// //                   ),
// //                   IconButton(
// //                       onPressed: () async {
// //                         showDialog(
// //                             context: context,
// //                             barrierDismissible: false,
// //                             builder: (BuildContext context) {
// //                               return AlertDialog(
// //                                 title: Text(
// //                                   'Logging Out',
// //                                   style: TextStyle(fontWeight: FontWeight.bold),
// //                                 ),
// //                                 content: Text(
// //                                   'Are you sure?',
// //                                 ),
// //                                 actions: <Widget>[
// //                                   ElevatedButton(
// //                                     child: Text(
// //                                       'No',
// //                                       style: TextStyle(color: Colors.white),
// //                                     ),
// //                                     style: ElevatedButton.styleFrom(
// //                                       backgroundColor: Colors.green,
// //                                       shape: RoundedRectangleBorder(
// //                                           side:
// //                                               BorderSide(color: Colors.green)),
// //                                     ),
// //                                     onPressed: () => Navigator.pop(context),
// //                                   ),
// //                                   ElevatedButton(
// //                                       child: Text(
// //                                         'Yes',
// //                                         style: TextStyle(color: Colors.white),
// //                                       ),
// //                                       style: ElevatedButton.styleFrom(
// //                                         backgroundColor: Colors.redAccent,
// //                                         shape: RoundedRectangleBorder(
// //                                             side: BorderSide(
// //                                                 color: Colors.redAccent)),
// //                                       ),
// //                                       onPressed: () async {
// //                                         await context
// //                                             .read<LoginProvider>()
// //                                             .pushNotifications("2");
// //                                         SharedPreferences _prefs =
// //                                             await SharedPreferences
// //                                                 .getInstance();
// //                                         await _prefs.clear();
// //                                         await _prefs.setString(
// //                                             'skipNotification', 'true');
// //                                         Navigator.pushAndRemoveUntil(
// //                                             context,
// //                                             MaterialPageRoute(
// //                                                 builder: (context) =>
// //                                                     PhoneNumber()),
// //                                             (route) => false);
// //                                       })
// //                                 ],
// //                               );
// //                             });
// //                       },
// //                       icon: Icon(
// //                         Icons.logout_rounded,
// //                         color: Colors.white,
// //                       ))
// //                 ],
// //               ),
// //               bottom: PreferredSize(
// //                 preferredSize: Size.fromHeight(0.0),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.start,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     TabBar(
// //                       onTap: ((value) async {
// //                         print("value $value");
// //                         context.read<OrderProvider>().timer?.cancel();
// //                       }),
// //                       labelStyle: TextStyle(fontSize: 13),
// //                       controller: _tabController,
// //                       tabs: tabs,
// //                       isScrollable: false,
// //                       labelColor: kWhiteColor,
// //                       indicatorColor: Colors.white,
// //                       unselectedLabelColor: kLightTextColor,
// //                       indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //           body: TabBarView(
// //             controller: _tabController,
// //             children: [
// //               NewOrderPage(),
// //               NextDayOrderPage(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:delivoo_stores/Auth/MobileNumber/UI/phone_number.dart';
// import 'package:delivoo_stores/Provider/OrderProvider.dart';
// import 'package:delivoo_stores/Provider/login_provider.dart';
// import 'package:delivoo_stores/StoreOrdering/Pages/onScreen/new.dart';
// import 'package:delivoo_stores/Themes/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OnScreenOrder extends StatefulWidget {
//   const OnScreenOrder({Key? key}) : super(key: key);

//   @override
//   State<OnScreenOrder> createState() => _OnScreenOrderState();
// }

// class _OnScreenOrderState extends State<OnScreenOrder>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final List<Tab> tabs = <Tab>[
//     const Tab(text: 'NEW ORDERS'),
//     const Tab(text: 'NEXT DAY ORDERS'),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: tabs.length, vsync: this);

//     // Moved Future.delayed into initState with proper async handling
//     Future.microtask(() async {
//       await context.read<LoginProvider>().getData();
//       // Any other async tasks like checking version or push notifications
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: WillPopScope(
//         onWillPop: onWillPop,
//         child: Scaffold(
//           appBar: PreferredSize(
//             preferredSize: Size.fromHeight(
//                 context.watch<LoginProvider>().userType == "2" ? 118 : 100.0),
//             child: AppBar(
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Order Details',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   const SizedBox(width: 20),
//                   IconButton(
//                     onPressed: () => _showLogoutDialog(context),
//                     icon: const Icon(
//                       Icons.logout_rounded,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               bottom: PreferredSize(
//                 preferredSize: const Size.fromHeight(0.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TabBar(
//                       onTap: (value) {
//                         // Cancel timer if there is one
//                         context.read<OrderProvider>().timer?.cancel();
//                       },
//                       labelStyle: const TextStyle(fontSize: 13),
//                       controller: _tabController,
//                       tabs: tabs,
//                       isScrollable: false,
//                       labelColor: kWhiteColor,
//                       indicatorColor: Colors.white,
//                       unselectedLabelColor: kLightTextColor,
//                       indicatorPadding:
//                           const EdgeInsets.symmetric(horizontal: 24.0),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           body: TabBarView(
//             controller: _tabController,
//             children: [
//               // NewOrderPage(),
//               // NextDayOrderPage(),
//               NewScreen(),
//               NewScreen(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Logout dialog method
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Logging Out',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text('Are you sure?'),
//           actions: <Widget>[
//             ElevatedButton(
//               child: const Text('No', style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.green),
//                 ),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//             ElevatedButton(
//               child: const Text('Yes', style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(color: Colors.redAccent),
//                 ),
//               ),
//               onPressed: () async {
//                 await context.read<LoginProvider>().pushNotifications("2");
//                 SharedPreferences _prefs =
//                     await SharedPreferences.getInstance();
//                 await _prefs.clear();
//                 await _prefs.setString('skipNotification', 'true');
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => PhoneNumber()),
//                   (route) => false,
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Handle back button press
//   Future<bool> onWillPop() async {
//     // Your custom logic for back button handling, if any
//     return true; // Return true to allow back navigation, false otherwise
//   }
// }
