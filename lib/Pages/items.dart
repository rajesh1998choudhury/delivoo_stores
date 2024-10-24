// import 'package:delivoo_stores/Components/custom_appbar.dart';
// import 'package:delivoo_stores/Locale/locales.dart';
// import 'package:delivoo_stores/Routes/routes.dart';
// import 'package:delivoo_stores/Themes/colors.dart';
// import 'package:flutter/material.dart';

// class ItemsPage extends StatefulWidget {
//   @override
//   _ItemsPageState createState() => _ItemsPageState();
// }

// class _ItemsPageState extends State<ItemsPage> {
//   List<DropdownMenuItem<int>> listDrop = [];
//   int? selected;

//   void loadData() {
//     listDrop = [];
//     listDrop.add(DropdownMenuItem(
//       child: Text('0.25 kg'),
//       value: 1,
//     ));
//     listDrop.add(DropdownMenuItem(
//       child: Text('0.5 kg'),
//       value: 2,
//     ));
//     listDrop.add(DropdownMenuItem(
//       child: Text('1 kg'),
//       value: 3,
//     ));
//   }

//   final List<Tab> tabs = <Tab>[
//     Tab(text: 'VEGETABLES'),
//     Tab(text: 'FRUITS'),
//     Tab(text: 'HERBS'),
//     Tab(text: 'DAIRY'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     loadData();
//     return DefaultTabController(
//       length: tabs.length,
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(100.0),
//           child: CustomAppBar(
//             titleWidget: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Center(child: Text(AppLocalizations.of(context)!.product!)),
// //                SizedBox(
// //                  height: 5.0,
// //                ),
//               ],
//             ),
//             actions: <Widget>[
//               IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     // CustomSearchBar(hint: 'Search item');
//                   }),
//             ],
//             bottom: TabBar(
//               tabs: tabs,
//               isScrollable: true,
//               labelColor: kWhiteColor,
//               unselectedLabelColor: kLightTextColor,
//               indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
//             ),
//           ),
//         ),
//         body: TabBarView(
//           children: tabs.map((Tab tab) {
//             return ListView(
//               children: <Widget>[
//                 Divider(
//                   color: kCardBackgroundColor,
//                   thickness: 6.3,
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.all(10.0),
//                       child: Image.asset(
//                         'images/veg/Vegetables/onion.png',
//                         scale: 2.5,
//                         height: 93.3,
//                         width: 93.3,
//                       ),
//                     ),
//                     InkWell(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(AppLocalizations.of(context)!.onion! + '\n',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline4!
//                                   .copyWith(
//                                       fontSize: 15.0,
//                                       fontWeight: FontWeight.w500)),
//                           Text('\$ 3.00\n',
//                               style: Theme.of(context).textTheme.caption),
//                           Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget>[
//                               Container(
//                                 height: 30.0,
//                                 padding: EdgeInsets.symmetric(horizontal: 12.0),
//                                 decoration: BoxDecoration(
//                                   color: kCardBackgroundColor,
//                                   borderRadius: BorderRadius.circular(30.0),
//                                 ),
//                                 child: DropdownButtonHideUnderline(
//                                   child: DropdownButton(
//                                       icon: Icon(
//                                         Icons.keyboard_arrow_down,
//                                         size: 16.7,
//                                       ),
//                                       iconEnabledColor: Colors.green,
//                                       value: selected,
//                                       items: listDrop,
//                                       hint: Text(
//                                         '1 kg',
//                                         style:
//                                             Theme.of(context).textTheme.caption,
//                                       ),
//                                       onChanged: (value) {
//                                         setState(() {
//                                           selected = value as int?;
//                                         });
//                                       }),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 70.0,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 20.0),
//                                 child: Text(
//                                   AppLocalizations.of(context)!.stock!,
//                                   style: TextStyle(
//                                       color: kMainColor,
//                                       fontSize: 13.3,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       onTap: () =>
//                           Navigator.pushNamed(context, PageRoutes.editItem),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => Navigator.pushNamed(context, PageRoutes.addItem),
//           tooltip: 'ADD PRODUCT',
//           child: Icon(
//             Icons.add,
//             size: 15.7,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }
