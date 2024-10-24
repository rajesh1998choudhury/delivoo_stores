// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;

import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/login_provider.dart';
import '../../main.dart';
import '../Models/storeOrdering_TimeSlotModel.dart';
import 'package:provider/provider.dart';
import '../Models/storeOrdering_storeModel.dart' as StoreModel;

class StoreOrderingStoreProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  StoreModel.StoreModel? stores;
  StoreModel.D? selectedstore;
  StoreModel.StoreModel? allstores;
  TimeslotModel? timeslots;
  D? selectedtimeslot;

  selectstore(String storeid) async {
    var store = stores?.d?.firstWhere((e) => e.shopid == storeid);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("shopid", store!.shopid!);

    selectedstore = store;

    notifyListeners();
    return store.shopid;
  }

  selecttimeslot(timeslotid) {
    selectedtimeslot = timeslots?.d?.firstWhere((e) => e.slotid == timeslotid);
    notifyListeners();
  }

  getstoredetailsbylocation(String locationid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "Action": "1",
          "latitude": "",
          "longitude": "",
          "membershipno": "1138",
          "adid": ""
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_STORES, requestJson);
        stores = StoreModel.StoreModel.fromJson(response);
        print('---------------getstoredetailsbylocation');
        print(response["d"]);
        //await processResponse();
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  getstoredetailsbyaddressid(addressid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "Action": "1",
          "latitude": "",
          "longitude": "",
          "membershipno": "1138",
          "adid": addressid
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_STORES, requestJson);
        stores = StoreModel.StoreModel.fromJson(response);
        print('---------------getstoredetailsbyaddressid');
        print(response["d"]);
        //await processResponse();
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  getallstores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "Action": "2",
          "latitude": "",
          "longitude": "",
          "membershipno": "1138",
          "adid": ""
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_STORES, requestJson);
        allstores = StoreModel.StoreModel.fromJson(response);
        print('---------------getstoredetailsbyaddressid');
        print(response["d"]);
        //await processResponse();
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  getstoredetailsbypincode(String pincode) async {
    notifyListeners();
  }

  gettimeslots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson =
            jsonEncode({"membershipno": "1138", "shopid": "1"});
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_TIMESLOTS, requestJson);
        timeslots = TimeslotModel.fromJson(response);

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
