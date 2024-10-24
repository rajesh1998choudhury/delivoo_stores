import 'package:delivoo_stores/Auth/login_navigator.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/about_us_page.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/addtobank_page.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/insight_page.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/support_page.dart';

import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/wallet_page.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/UI/account_page.dart';

import 'package:delivoo_stores/OrderItemAccount/Order/UI/orderinfo_page.dart';
import 'package:delivoo_stores/OrderItemAccount/StoreProfile/store_profile.dart';
import 'package:delivoo_stores/Pages/additem.dart';
import 'package:delivoo_stores/Pages/edit_profile.dart';
import 'package:delivoo_stores/Pages/edititem.dart';
import 'package:delivoo_stores/Pages/holiday_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../StoreOrdering/Pages/MyOrders/storeItemsAcceptanace.dart';
import '../StoreOrdering/Pages/MyOrders/storeOrderInfo.dart';
import '../StoreOrdering/Pages/storeOrderingProductDescription.dart';
import '../StoreOrdering/Pages/storeViewCart.dart';

class PageRoutes {
  static const String locationPage = 'location_page';
  static const String accountPage = 'account_page';
//  static const String orderPage = 'order_page';
  static const String orderInfoPage = 'orderinfo_page';
  static const String aboutUsPage = 'about_us_page';
  static const String savedAddressesPage = 'saved_addresses_page';
  static const String supportPage = 'support_page';
  static const String walletPage = 'wallet_page';
  static const String loginNavigator = 'login_navigator';
  static const String chatPage = 'chat_page';
  static const String insightPage = 'insight_page';
  static const String storeProfile = 'store_profile';
  static const String addItem = 'additem';
  static const String editItem = 'edititem';
  static const String Items = 'items';
  static const String addToBank = 'addtobank_page';
  static const String editProfile = 'edit_profile';
  static const String holidayListing = 'holiday_listing';
  static const String storeProductDescription = 'product_description';
  static const String storeViewCart = 'view_cart';
  static const String storeOrderInfo = 'store_order_info';
  static const String storeItemAcceptance = 'store_item_acceptance';

  Map<String, WidgetBuilder> routes() {
    return {
      // orderPage: (context) => OrderPage(),
      orderInfoPage: (context) => OrderInfo(),
      accountPage: (context) => AccountPage(),
      aboutUsPage: (context) => AboutUsPage(),
      supportPage: (context) => SupportPage(),
      loginNavigator: (context) => LoginNavigator(),
      walletPage: (context) => WalletPage(),
      editProfile: (context) => EditProfile(),
      insightPage: (context) => InsightPage(),
      storeProfile: (context) => ProfilePage(),
      addItem: (context) => AddItem(),
      editItem: (context) => EditItem(),
      addToBank: (context) => AddToBank(),
      // Items: (context) => ItemsPage(),
      holidayListing: (context) => HolidayListing(),
      storeProductDescription: (context) => StoreProductDescription(),
      storeViewCart: (context) => StoreViewCart(),
      storeOrderInfo: (context) => StoreOrderInfo(),
      storeItemAcceptance: (context) => StoreItemAcceptance(),
    };
  }
}
