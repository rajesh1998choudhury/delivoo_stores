import 'dart:convert';
import 'dart:io';

import 'package:delivoo_stores/Models/ProductModel.dart';
import 'package:delivoo_stores/Models/searchModel.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;
import 'package:provider/provider.dart';

import '../main.dart';

class ProductProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  ProductModel? products;
  ProductModel? selectedProducts;
  List<SearchModel> search = [];
  int cartindex = 0;
  int index1 = 0;
  int? productIndex = 0;
  int numberOfItems = 0;
  int productDetailsIndex = 0;
  List<String> items = [];
  var _catId = "0";
  int tabIndex = 0;

  String? orderid = '';

  getSwitchValue(product, index, int value) {
    // print("value " + value.toString());
    products!.d![index].productDetails![products!.d![index].productDetailsIndex]
        .outofstock = value;

    notifyListeners();
  }

  setTabIndex(value) {
    tabIndex = value;
    notifyListeners();
  }

  selectedItemWeight(widgetIndex, index) async {
    products!.d![widgetIndex].productDetailsIndex = index;
    notifyListeners();
  }

  getProductsByCategory({catId, searchtxt, required loading, sectionId}) async {
    _catId = catId;
    print("catId $_catId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        loading == true ? showLoading() : "";
        String requestJson = jsonEncode({
          "subtypeid": sectionId,
          "sku_cat_id": catId,
          //"FlagAll": "1",
          "SearchText": "$searchtxt",
          // "offset": "0",
          "shopid": prefs.getString('com_id'),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location'),
        });
        final response =
            await apiProvider.post(Appconstants.GET_PRODUCTS, requestJson);

        if (response != null && response["d"] != null) {
          loading == true ? hideLoading() : "";
          products = ProductModel.fromJson(response);
          if (searchtxt == null || searchtxt == "") {
            items = List.generate(products!.d!.length,
                (index) => products!.d![index].productName.toString());
          }
        } else {
          loading == true ? hideLoading() : "";
          products?.d = [];

          // await processResponse();
        }
        notifyListeners();

        return products?.d;
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  notify() async {
    notifyListeners();
  }

  getProductsByScan(productCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "subtypeid": '0',
          "sku_cat_id": "1",
          "ItemId": '$productCode',
          "SearchText": "",
          "shopid": prefs.getString('com_id'),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location'),
        });
        final response = await apiProvider.post(
            Appconstants.GET_PRODUCTS_By_Scan, requestJson);

        if (response == null || response["d"] == null) {
          products?.d = [];
          hideLoading();
          showMessage("Invalid Barcode or QR");
        } else if (response["d"] != null && response["d"].length != 0) {
          products = await ProductModel.fromJson(response);
          hideLoading();
          notifyListeners();
          items = List.generate(products!.d!.length,
              (index) => products!.d![index].productName.toString());
          return 'sucess';
        } else if (response["d"].length == 0 && productCode != "") {
          products?.d = [];
          hideLoading();
          print("wrong qr");
          showMessage("Invalid Barcode or QR");
        } else {
          hideLoading();
        }
        notifyListeners();

        return products?.d;
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  productOutOfStock({
    itemId,
    productId,
    status,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "companyid": prefs.getString('com_id'),
          "ItemId": itemId,
          "ProductId": productId,
          "Status": status,
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });

        final response =
            await apiProvider.post(Appconstants.productOutofStock, requestJson);
        if (response["d"] != null) {
          hideLoading();

          notifyListeners();

          print("response ${response["d"]}");
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  sortQuantity({productId, newQty, index}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "shopid": prefs.getString('com_id'),
          "ItemId": "$productId",
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location'),
          "UpdateStock": "$newQty",
          "mobileNo": prefs.getString('mob_no'),
        });
        final response =
            await apiProvider.post(Appconstants.updateMystock, requestJson);
        if (response["d"] != null) {
          hideLoading();
          if (response["d"][0]['Lockstatus'] == "0") {
            hideLoading();
            print("Statessss" + response["d"][0]['Lockstatus']);
            Future.delayed(Duration(milliseconds: 300), () {
              showMessage("Permission denied.\nPlease contact approver");
            });

            return "locked";
          } else {
            products!
                .d![index]
                .productDetails![products!.d![index].productDetailsIndex]
                .stock = int.parse(newQty);
            hideLoading();
            notifyListeners();
          }
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);

      notifyListeners();
    }
  }
}
