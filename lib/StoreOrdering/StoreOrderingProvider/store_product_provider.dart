// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/StoreOrdering/Models/procced_to_checkout_model.dart';
import 'package:delivoo_stores/StoreOrdering/Models/storeOrdering_cartModel.dart';
import 'package:delivoo_stores/StoreOrdering/Models/storeOrdering_cartTotalModel.dart';
import 'package:delivoo_stores/StoreOrdering/Models/storeOrdering_product_model.dart';
import 'package:delivoo_stores/StoreOrdering/Models/storeOrdering_searchModel.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/order_success_page.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:delivoo_stores/StoreOrdering/Models/storeOrdering_product_model.dart'
    as Products;

import '../../Provider/login_provider.dart';
import '../../main.dart';
import 'package:provider/provider.dart';

class StoreOrderingProductProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  StoreOrderingProductModel? products;
  Products.D? selectedProducts;
  StoreOrderingCartTotalModel? cartTotal;
  List<StoreOrderingSearchModel> search = [];
  ProccedToCheckoutModel? proccedToCheckoutData;
  var date;
  bool switchData = false;
  var urgentDelivery = '0';
  bool? isLoading = true;

  StoreOrderingCartModel? cartitems;
  int cartindex = 0;
  int index1 = 0;
  int? productIndex = 0;
  int numberOfItems = 0;
  int productDetailsIndex = 0;
  List<String> items = [];
  bool? isfirstproduct = false;

  String? orderid = '';
  var checkoutResponse;
  var orderId;
  DateTime? calenderDate;
  int tabIndex = 0;

  getTabIndex(index) async {
    tabIndex = index;
    notifyListeners();
  }

  getProductIndex(product, index) {
    selectedProducts = product;
    productIndex = index;
    notifyListeners();
  }

  changeSwitchStatus(value) async {
    if (proccedToCheckoutData?.d?[0].urDel == "0") {
      switchData = false;
      date = DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(
          days: int.parse(proccedToCheckoutData!.d![0].delday.toString()))));
    } else if (proccedToCheckoutData?.d?[0].urDel != "0") {
      if (value == false) {
        urgentDelivery = "0";
        calenderDate = DateTime.now().add(Duration(
            days: int.parse(proccedToCheckoutData!.d![0].delday.toString())));
        date = DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(
            days: int.parse(proccedToCheckoutData!.d![0].delday.toString()))));
        getcarttotal(orderType: urgentDelivery);
        switchData = value;
      } else if (value == true) {
        print("urgent Delivery");
        urgentDelivery = "1";
        date = DateFormat('dd/MM/yyyy').format(DateTime.now());
        getcarttotal(orderType: urgentDelivery);
        switchData = value;
      }
    }
    notifyListeners();
  }

  resetUrgentDelivery() async {
    urgentDelivery = "0";
    switchData = false;
    notifyListeners();
  }

  selectedDate(value) async {
    date = DateFormat('dd/MM/yyyy').format(value);
    calenderDate = value;
    notifyListeners();
  }

  mapcartwithproducts() {
    if (cartitems == null || cartitems?.d?.length == 0) {
      for (var j = 0; j < products!.d!.length; j++) {
        for (var k = 0; k < products!.d![j].productDetails!.length; k++) {
          products!.d![j].productDetails![k].productQty = 0;
        }
      }
    } else
      for (var i = 0; i < cartitems!.d!.length; i++) {
        int index = products!.d!.indexWhere(
            (element) => element.productName == cartitems?.d?[i].productName);
        if (index >= 0) {
          int productIndex = products!.d![index].productDetails!.indexWhere(
              (element) => element.productCode == cartitems?.d?[i].productCode);
          products!.d![index].productDetails![productIndex].productQty =
              cartitems!.d?[i].productQty;
        }
        //products[index].productImage = cartitems![i].productImage;
      }

    notifyListeners();
  }

  getProductsByCategory({catId, sectionId, searchtxt}) async {
    print("cat Id:" + catId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "companyid": prefs.getString("com_id"),
          "subtypeid": '$sectionId',
          "sku_cat_id": catId,
          "FlagAll": "1",
          "SearchText": "$searchtxt",
          "offset": "0",
          "orderid": prefs.getString('orderid'),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        print(catId + 'catid');
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_PRODUCTS, requestJson);
        if (response["d"] != null) {
          hideLoading();
          products = await StoreOrderingProductModel.fromJson(response);
          if (searchtxt == null || searchtxt == "") {
            items = List.generate(products!.d!.length,
                (index) => products!.d![index].productName.toString());
          }
        } else {
          hideLoading();
          products?.d = [];
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      products?.d = [];
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
      notifyListeners();
    }
  }

  increaseCountbyEditing({index, qty}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (prefs.getString('orderid') == '' ||
            prefs.getString('orderid') == null) {
          showLoading();
          isfirstproduct = true;
        }
        products?.d?[index].isloading = true;
        notifyListeners();

        int productIndex = products!.d![index].productDetailsIndex;
        if (cartitems?.d?.length == null) {
          orderid = '';
        }
        prefs.setString('orderid', orderid!);
        if (products!.d![index].productDetails![productIndex].orderLimt != 0) {
          if (qty <=
              products!.d![index].productDetails![productIndex].orderLimt!) {
            products!.d![index].productDetails![productIndex].productQty = qty;
            String requestJson = jsonEncode({
              "productcode":
                  "${products!.d![index].productDetails![productIndex].productCode}",
              "qty":
                  products!.d![index].productDetails![productIndex].productQty,
              "orderid": prefs.getString('orderid'),
              "shopid": prefs.getString('com_id'),
              "WarehouseID": prefs.getString('ware_house'),
              "StoreLocation": prefs.getString('store_Location')
            });
            final response = await apiProvider.post(
                Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
            cartitems = StoreOrderingCartModel.fromJson(response);

            orderid =
                cartitems?.d?.length == 0 ? "" : cartitems?.d?[0].orderid!;
            prefs.setString('orderid', orderid!);
          } else {
            Fluttertoast.showToast(
                msg: "Max limit reached",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          products!.d![index].productDetails![productIndex].productQty = qty;
          String requestJson = jsonEncode({
            "productcode":
                "${products!.d![index].productDetails![productIndex].productCode}",
            "qty": products!.d![index].productDetails![productIndex].productQty,
            "orderid": prefs.getString('orderid'),
            "shopid": prefs.getString('com_id'),
            "WarehouseID": prefs.getString('ware_house'),
            "StoreLocation": prefs.getString('store_Location')
          });
          final response = await apiProvider.post(
              Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
          if (response != null && response["d"].length != 0) {
            cartitems = StoreOrderingCartModel.fromJson(response);
            orderid = cartitems?.d?[0].orderid!;
            prefs.setString('orderid', orderid!);
          }
        }
        getcarttotal();
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        products?.d?[index].isloading = false;
        if (isfirstproduct == true) {
          hideLoading();
          isfirstproduct = false;
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      products?.d?[index].isloading = false;
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  increaseCount(
    index,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (prefs.getString('orderid') == '' ||
            prefs.getString('orderid') == null) {
          showLoading();
          isfirstproduct = true;
        }
        products?.d?[index].isloading = true;
        notifyListeners();

        int productIndex = products!.d![index].productDetailsIndex;
        if (cartitems?.d?.length == null) {
          orderid = '';
        }
        prefs.setString('orderid', orderid!);
        if (products!.d![index].productDetails![productIndex].orderLimt != 0) {
          print(
              "orderLImittttttt   ${products!.d![index].productDetails![productIndex].orderLimt.toString()}");
          if (products!.d![index].productDetails![productIndex].productQty! <
              products!.d![index].productDetails![productIndex].orderLimt!) {
            products!.d![index].productDetails![productIndex].productQty =
                products!.d![index].productDetails![productIndex].productQty! +
                    1;
            String requestJson = jsonEncode({
              "productcode":
                  "${products!.d![index].productDetails![productIndex].productCode}",
              "qty":
                  products!.d![index].productDetails![productIndex].productQty,
              "orderid": prefs.getString('orderid'),
              "shopid": prefs.getString('com_id'),
              "WarehouseID": prefs.getString('ware_house'),
              "StoreLocation": prefs.getString('store_Location')
            });
            final response = await apiProvider.post(
                Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
            cartitems = StoreOrderingCartModel.fromJson(response);

            print(cartitems?.d?[0].productName);
            orderid = cartitems?.d?[0].orderid!;
            prefs.setString('orderid', orderid!);
          } else {
            print('object');
            Fluttertoast.showToast(
                msg: "Max limit reached",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          products!.d![index].productDetails![productIndex].productQty =
              products!.d![index].productDetails![productIndex].productQty! + 1;
          String requestJson = jsonEncode({
            "productcode":
                "${products!.d![index].productDetails![productIndex].productCode}",
            "qty": products!.d![index].productDetails![productIndex].productQty,
            "orderid": prefs.getString('orderid'),
            "shopid": prefs.getString('com_id'),
            "WarehouseID": prefs.getString('ware_house'),
            "StoreLocation": prefs.getString('store_Location')
          });
          final response = await apiProvider.post(
              Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
          cartitems = StoreOrderingCartModel.fromJson(response);
          orderid = cartitems?.d?[0].orderid!;
          prefs.setString('orderid', orderid!);
        }
        getcarttotal();
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        products?.d?[index].isloading = false;
        if (isfirstproduct == true) {
          hideLoading();
          isfirstproduct = false;
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      products?.d?[index].isloading = false;
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  increaseCountincartbyEditing(cartindex, int? qty) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        cartitems!.d?[cartindex].isloading = true;
        notifyListeners();

        if (cartitems!.d?[cartindex].maxcount != 0) {
          if (qty! <= cartitems!.d![cartindex].maxcount!) {
            cartitems!.d?[cartindex].productQty = qty;
            String requestJson = jsonEncode({
              "productcode": "${cartitems!.d?[cartindex].productCode}",
              "qty": cartitems!.d![cartindex].productQty,
              "orderid": prefs.getString('orderid'),
              "shopid": prefs.getString('com_id'),
              "WarehouseID": prefs.getString('ware_house'),
              "StoreLocation": prefs.getString('store_Location')
            });
            final response = await apiProvider.post(
                Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
            cartitems = StoreOrderingCartModel.fromJson(response);

            orderid =
                cartitems?.d?.length == 0 ? "" : cartitems?.d?[0].orderid!;
            prefs.setString('orderid', orderid!);
          } else {
            Fluttertoast.showToast(
                msg: "Max limit reached",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          cartitems!.d![cartindex].productQty = qty;
          String requestJson = jsonEncode({
            "productcode": "${cartitems!.d?[cartindex].productCode}",
            "qty": cartitems!.d![cartindex].productQty,
            "orderid": prefs.getString('orderid'),
            "shopid": prefs.getString('com_id'),
            "WarehouseID": prefs.getString('ware_house'),
            "StoreLocation": prefs.getString('store_Location')
          });
          final response = await apiProvider.post(
              Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
          cartitems = StoreOrderingCartModel.fromJson(response);
          print(cartitems?.d?[0].productName);
          orderid = cartitems?.d?[0].orderid!;
          prefs.setString('orderid', orderid!);
        }
        if (products != null) {
          mapcartwithproducts();
        }
        getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        if (cartitems?.d?.length != 0) {
          cartitems!.d?[cartindex].isloading = false;
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      cartitems!.d?[cartindex].isloading = false;
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  increaseCountincart(cartindex) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        cartitems!.d?[cartindex].isloading = true;
        notifyListeners();

        if (cartitems!.d?[cartindex].maxcount != 0) {
          if (cartitems!.d![cartindex].productQty! <
              cartitems!.d![cartindex].maxcount!) {
            cartitems!.d?[cartindex].productQty =
                cartitems!.d![cartindex].productQty! + 1;
            String requestJson = jsonEncode({
              "productcode": "${cartitems!.d?[cartindex].productCode}",
              "qty": cartitems!.d![cartindex].productQty,
              "orderid": prefs.getString('orderid'),
              "shopid": prefs.getString('com_id'),
              "WarehouseID": prefs.getString('ware_house'),
              "StoreLocation": prefs.getString('store_Location')
            });
            final response = await apiProvider.post(
                Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
            cartitems = StoreOrderingCartModel.fromJson(response);
            print(cartitems?.d?[0].productName);
            orderid = cartitems?.d?[0].orderid!;
            prefs.setString('orderid', orderid!);
          } else {
            Fluttertoast.showToast(
                msg: "Max limit reached",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          cartitems!.d![cartindex].productQty =
              cartitems!.d![cartindex].productQty! + 1;
          String requestJson = jsonEncode({
            "productcode": "${cartitems!.d?[cartindex].productCode}",
            "qty": cartitems!.d![cartindex].productQty,
            "orderid": prefs.getString('orderid'),
            "shopid": prefs.getString('com_id'),
            "WarehouseID": prefs.getString('ware_house'),
            "StoreLocation": prefs.getString('store_Location')
          });
          final response = await apiProvider.post(
              Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
          cartitems = StoreOrderingCartModel.fromJson(response);
          print(cartitems?.d?[0].productName);
          orderid = cartitems?.d?[0].orderid!;
          prefs.setString('orderid', orderid!);
        }
        if (products != null) {
          mapcartwithproducts();
        }
        getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        cartitems!.d?[cartindex].isloading = false;

        notifyListeners();
      }
    } on SocketException catch (e) {
      cartitems!.d?[cartindex].isloading = false;
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  decreaseCount(index) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        products?.d?[index].isloading = true;
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int productIndex = products!.d![index].productDetailsIndex;

        cartindex = cartitems!.d!.indexWhere((element) =>
            element.productName == products!.d![index].productName);
        if (products!.d![index].productDetails![productIndex].productQty! > 0) {
          products!.d![index].productDetails![productIndex].productQty =
              products!.d![index].productDetails![productIndex].productQty! - 1;
        }
        String requestJson = jsonEncode({
          "productcode":
              "${products!.d![index].productDetails![productIndex].productCode}",
          "qty": products!.d![index].productDetails![productIndex].productQty,
          "orderid": prefs.getString('orderid'),
          "shopid": prefs.getString('com_id'),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
        cartitems = StoreOrderingCartModel.fromJson(response);
        orderid = cartitems?.d != null && cartitems!.d!.isNotEmpty
            ? (cartitems?.d?[0].orderid)
            : '';
        prefs.setString('orderid', orderid!);

        getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        products?.d?[index].isloading = false;
        notifyListeners();
      }
    } on SocketException catch (e) {
      products?.d?[index].isloading = false;
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  decreaseCountincart(cartindex) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        cartitems!.d?[cartindex].isloading = true;
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (cartitems!.d![cartindex].productQty! > 0) {
          cartitems!.d![cartindex].productQty =
              cartitems!.d![cartindex].productQty! - 1;
          if (products != null) {
            mapcartwithproducts();
          }
          String requestJson = jsonEncode({
            "productcode": "${cartitems!.d?[cartindex].productCode}",
            "qty": cartitems!.d![cartindex].productQty,
            "orderid": prefs.getString('orderid'),
            "shopid": prefs.getString('com_id'),
            "WarehouseID": prefs.getString('ware_house'),
            "StoreLocation": prefs.getString('store_Location')
          });
          final response = await apiProvider.post(
              Appconstants.STORE_ORDERING_ADD_PRODUCT, requestJson);
          cartitems = StoreOrderingCartModel.fromJson(response);
          orderid = cartitems?.d != null && cartitems!.d!.isNotEmpty
              ? (cartitems?.d?[0].orderid)
              : '';
          prefs.setString('orderid', orderid!);
        }

        notifyListeners();
        if (products != null) {
          mapcartwithproducts();
        }
        getcarttotal();
        numberOfItems = 0;
        for (int i = 0; i < cartitems!.d!.length; i++) {
          numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
        }
        cartitems!.d?[cartindex].isloading = false;
        notifyListeners();
      }
    } on SocketException catch (e) {
      cartitems!.d?[cartindex].isloading = false;
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  selectedItemWeight(widgetIndex, index) async {
    products!.d![widgetIndex].productDetailsIndex = index;
    notifyListeners();
  }

  selectedDescItemWeight(productIndex, index) async {
    productIndex.productDetailsIndex = index;
    notifyListeners();
  }

  addtocart(index) {
    int productIndex = products!.d![index].productDetailsIndex;
  }

  updateCart(index) {
    int productIndex = products!.d![index].productDetailsIndex;

    cartindex = cartitems!.d!.indexWhere((element) =>
        element.productCode ==
        products!.d![index].productDetails![productIndex].productCode);

    cartitems!.d![cartindex].productQty =
        products!.d![index].productDetails![productIndex].productQty;

    cartitems!.d![cartindex].productImage =
        products!.d![index].productDetails![productIndex].productimage;
    notifyListeners();
  }

  removefromcart(cartindex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String requestJson = jsonEncode({
      "productcode": cartitems?.d?[cartindex].productCode,
      "shopid": prefs.getString('com_id'),
      "borderid": prefs.getString('orderid'),
      "WarehouseID": prefs.getString('ware_house'),
      "StoreLocation": prefs.getString('store_Location')
    });
    final response = await apiProvider.post(
        Appconstants.STORE_ORDERING_REMOVE_PRODUCT, requestJson);
    cartitems = StoreOrderingCartModel.fromJson(response);
    orderid = cartitems?.d != null && cartitems!.d!.isNotEmpty
        ? (cartitems?.d?[0].orderid)
        : '';
    prefs.setString('orderid', orderid!);
    mapcartwithproducts();
    getcarttotal();
    numberOfItems = 0;
    for (int i = 0; i < cartitems!.d!.length; i++) {
      numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
    }

    notifyListeners();
  }

  removeallProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String requestJson = jsonEncode({
      "shopid": prefs.getString('com_id'),
      "borderid": prefs.getString('orderid'),
      "WarehouseID": prefs.getString('ware_house'),
      "StoreLocation": prefs.getString('store_Location')
    });
    final response = await apiProvider.post(
        Appconstants.STORE_ORDERING_REMOVE_ALLPRODUCTS, requestJson);
    cartitems = StoreOrderingCartModel.fromJson(response);
    orderid = cartitems?.d != null && cartitems!.d!.isNotEmpty
        ? (cartitems?.d?[0].orderid)
        : '';
    prefs.setString('orderid', orderid!);
    mapcartwithproducts();
    //getcarttotal();
    numberOfItems = 0;
    for (int i = 0; i < cartitems!.d!.length; i++) {
      numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
    }
    notifyListeners();
  }

  checkout({delDate, ordertype}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "borderid": prefs.getString('orderid'),
          "shopid": prefs.getString('com_id'),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location'),
          "DelDate": delDate,
          "Ordertype": ordertype
        });
        final response =
            await apiProvider.post(Appconstants.CHECKOUT, requestJson);
        if (response["d"] != null || response['d'] == '0') {
          hideLoading();
          checkoutResponse = response['d'];
          return "0";
        } else if (response["d"] != null || response['d'] == '2') {
          showMessage('Urgent Delivery is Allowed');
        } else if (response["d"] != null || response['d'] == '3') {
          showMessage("Invalid Date of Delivery");
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

  getcartitems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int l = 0;
    print('cartlength${cartitems?.d?.length}');
    numberOfItems = 0;
    if (cartitems == null) {
      l = 0;
    } else {
      l = cartitems!.d!.length;
    }

    String requestJson = jsonEncode({
      "borderid": prefs.getString('orderid'),
      "shopid": prefs.getString('com_id')
    });
    final response = await apiProvider.post(
        Appconstants.STORE_ORDERING_GET_CART_ITEMS, requestJson);

    if (response['d'] == null) {
      cartitems = null;
    } else if (response['d'] != null) {
      cartitems = StoreOrderingCartModel.fromJson(response);
      orderid = cartitems != null && cartitems!.d!.isNotEmpty
          ? (cartitems?.d?[0].orderid!)
          : '';
      print('orderId $orderid');
      for (int i = 0; i < l; i++) {
        numberOfItems = cartitems!.d![i].productQty! + numberOfItems;
      }
    }

    print('number of items' + '****${numberOfItems.toString()}');
    notifyListeners();
    //return cartitems;
  }

  getcarttotal({orderType}) async {
    print("orderType $orderType");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String requestJson = jsonEncode({
      "borderid": prefs.getString('orderid'),
      "shopid": prefs.getString('com_id'),
      "ordertype": orderType != null ? orderType : "0"
    });
    final response = await apiProvider.post(
        Appconstants.STORE_ORDERING_GET_CART_TOTAL, requestJson);
    print('response is ${response["d"]}');
    if (response['d'] == null) {
      cartTotal = null;
    } else if (response['d'] != null) {
      cartTotal = StoreOrderingCartTotalModel.fromJson(response);
    }
    notifyListeners();
  }

  proccedToCheckout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "borderid": prefs.getString('orderid'),
          "shopid": prefs.getString('com_id'),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await apiProvider.post(Appconstants.ProccedToCheckout, requestJson);
        hideLoading();
        if (response["d"] != null) {
          proccedToCheckoutData = ProccedToCheckoutModel.fromJson(response);
          return "success";
        } else {
          proccedToCheckoutData?.d = [];
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

  Future<Null> checkOutOrderWithoutPay({delDate, ordertype, ctx}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("order id ${prefs.getString('orderid')}");
    print("company id ${prefs.getString("com_id")}");
    print("del date ${delDate}");
    print("order type ${ordertype}");
    print("ware house id ${prefs.getString('ware_house')}");
    print("storeLocation${prefs.getString('store_Location')}");
    try {
      showLoading();
      String requestJson = jsonEncode({
        "orderid": prefs.getString('orderid'),
        "companyid": prefs.getString("com_id"),
        "Warehouseid": prefs.getString('ware_house'),
        "storeLocation": prefs.getString('store_Location'),
        "deldate": delDate.toString(),
        "ordertype": ordertype.toString()
      });
      final response = await apiProvider.post(
          Appconstants.CheckOutOrderWithoutPay, requestJson);
      if (response['d'] != null) {
        hideLoading();
        print("orderId ${response['d']}");
        orderId = response['d'];
        Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => OrderPlacedSuccessfully()),
            (route) => false);
        removeallProducts();
      } else {}

      notifyListeners();
    } on Exception catch (e) {
      hideLoading();
      print(e);
    }
  }
}
