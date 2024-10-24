// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;
import 'package:delivoo_stores/Models/CategoryModel.dart';
import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/SubcategoryModel.dart';
import '../main.dart';
import 'login_provider.dart';
import 'package:provider/provider.dart';

class CategoryProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  //CategoryModel? selectedcategory;
  CategoryModel? categories;

  SubcategoryModel? selectedsubcategory;
  SubcategoryModel? subcategories;
  int? selectedsubcategoryindex;
  bool _loading = true;
  bool get Loading => _loading;

  Future<Null> getCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("comdId ${prefs.getString('com_id')}");
        print("ware house id ${prefs.getString('ware_house')}");
        print("storeLocation${prefs.getString('store_Location')}");
        _loading = true;
        String requestJson = jsonEncode({
          "storeid": comid,
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await apiProvider.post(Appconstants.GET_CATEGORIES, requestJson);
        if (response['d'] != null) {
          _loading = false;
          categories = CategoryModel.fromJson(response);
        } else {
          _loading = false;
          categories?.d = [];
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
        final response =
            await apiProvider.post(Appconstants.GET_SUBCATEGORIES, requestJson);
        if (response['d'] != null) {
          hideLoading();
          subcategories = SubcategoryModel.fromJson(response);
          return "success";
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      ;
      print(e);
    }
  }
}
