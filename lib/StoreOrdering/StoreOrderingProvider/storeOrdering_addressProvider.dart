// ignore_for_file: unused_local_variable, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;

import '../../Provider/login_provider.dart';
import '../../Service/Api_Provider.dart';
import '../../Utils/CommonWidget.dart';
import '../../main.dart';
import '../Models/storeOrdering_addressModel.dart';
import 'package:provider/provider.dart';

class StoreOrderingAddressprovider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();

  AddressModel? addresses;

  D? selectedAddress;

  String? selectedPincode;
  double? lat;
  double? long;
  bool addrediting = false;
  int addressindex = 0;
  String? addresstype = 'Home';
  bool? changelocation = false;

  changecolor() {
    notifyListeners();
  }

  selectaddress(addrid) async {
    var addr = addresses?.d?.firstWhere((e) => e.addressId == addrid);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString("addid", addr!.addressId!);

    selectedAddress = addr;
    notifyListeners();
    //return addr.addressId;
  }

  getaddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "5",
          "membershipno": "1138",
          "Address": "",
          "adid": "",
          "address1": "",
          "address2": "",
          "title": "",
          "latitude": "",
          "longitude": "",
          "pincode": "",
          "addstatus": ""
        });
        showLoading();
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_ADDRESSES, requestJson);
        addresses = AddressModel.fromJson(response);
        hideLoading();
        //selectedAddress = addresses?.d?[0];
        // await processresponse();
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  updateaddress(addr1, addr2, address, title, lat, long, pincode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "2",
          "membershipno": "1138",
          "Address": address,
          "adid": addresses?.d?[addressindex].addressId,
          "address1": addr1,
          "address2": addr2,
          "title": title,
          "latitude": lat,
          "longitude": long,
          "pincode": pincode,
          "addstatus": "1"
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_ADDRESSES, requestJson);
        addresses = AddressModel.fromJson(response);

        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  updatelocation(addr1, addr2, address, title, lat, long, pincode, adid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "2",
          "membershipno": "1138",
          "Address": address,
          "adid": adid,
          "address1": addr1,
          "address2": addr2,
          "title": title,
          "latitude": lat,
          "longitude": long,
          "pincode": pincode,
          "addstatus": "1"
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_ADDRESSES, requestJson);
        addresses = AddressModel.fromJson(response);
        /* addresses?.d?[addressindex].address = address;
    addresses?.d?[addressindex].pincode = pincode;
    addresses?.d?[addressindex].type = type; */
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  getaddressid(String addresstype) async {
    var address = addresses?.d?.firstWhere((e) => e.title == addresstype);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "6",
          "membershipno": "1138",
          "Address": "",
          "adid": address?.addressId,
          "address1": "",
          "address2": "",
          "title": "",
          "latitude": "",
          "longitude": "",
          "pincode": "",
          "addstatus": "1"
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_ADDRESSES, requestJson);
        addresses = AddressModel.fromJson(response);
        selectedAddress = address!;
        print('aaaaaaaaaaaa${selectedAddress?.title}');
        prefs.setString("addid", address.addressId!);
        notifyListeners();
        return address.addressId;
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  addaddress(String addr1, String addr2, String type, lat, long, address,
      String pincode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "1",
          "membershipno": "1138",
          "Address": address,
          "adid": "",
          "address1": addr1,
          "address2": addr2,
          "title": type,
          "latitude": lat,
          "longitude": long,
          "pincode": pincode,
          "addstatus": "1"
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_ADDRESSES, requestJson);
        addresses = AddressModel.fromJson(response);
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  removeaddress(index) async {
    //addresses.removeAt(index);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String? userId = prefs.getString('userid');
        String requestJson = jsonEncode({
          "Action": "3",
          "membershipno": "1138",
          "Address": "",
          "adid": addresses?.d?[index].addressId,
          "address1": "",
          "address2": "",
          "title": "",
          "latitude": "",
          "longitude": "",
          "pincode": "",
          "addstatus": ""
        });
        final response = await apiProvider.post(
            Appconstants.STORE_ORDERING_GET_ADDRESSES, requestJson);
        addresses = AddressModel.fromJson(response);
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
