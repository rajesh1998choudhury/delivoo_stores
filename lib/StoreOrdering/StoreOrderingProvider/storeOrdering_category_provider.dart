import 'dart:convert';
import 'dart:io';

import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/StoreOrdering/Models/storeOrdering_categoryModel.dart';
import 'package:delivoo_stores/StoreOrdering/Models/storeOrdering_subCategoryModel.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;
import 'package:delivoo_stores/Utils/CommonWidget.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../Provider/login_provider.dart';
import '../../main.dart';

class StoreOrderingCategoryProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();
  StoreOrderingCategoryModel? categories;

  StoreOrderingSubcategoryModel? selectedsubcategory;
  StoreOrderingSubcategoryModel? subcategories;
  int? selectedsubcategoryindex;
  bool _loading = true;
  bool get Loading => _loading;

  Future<Null> getCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("ware house id ${prefs.getString('ware_house')}");
        print("storeLocation ${prefs.getString('store_Location')}");
        _loading = true;
        String requestJson = jsonEncode({
          "storeid": comid,
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_CATEGORIES, requestJson);
        if (response['d'] != null) {
          categories = StoreOrderingCategoryModel.fromJson(response);
          _loading = false;
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  setSelectedIndex(int index) {
    selectedsubcategoryindex = index;
    notifyListeners();
  }

  getSubcategory(catId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "storeid": comid,
          "CatId": catId,
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });

        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_SUBCATEGORIES, requestJson);
        if (response['d'] != null) {
          hideLoading();
          subcategories = StoreOrderingSubcategoryModel.fromJson(response);
          return "success";
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }
}
