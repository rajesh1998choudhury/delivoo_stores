import 'dart:convert';
import 'dart:io';


import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;
import '../../Models/razorpayauthModel.dart';
import '../../Provider/login_provider.dart';
import '../../Service/Api_Provider.dart';
import 'package:provider/provider.dart';

import 'package:delivoo_stores/main.dart';

import '../Models/wallet_model.dart';

class PaymentProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();
  String? razorpayId;
  String? orderId;
  String? email;
  String? transId;
  RazorpayAuthModel? razorpayauth;
  WalletDetailsModel? walletdetails;
  var walletAmount = "";
// PayUHashModel  ? payUDetails;

  getrazorpayId(useWallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("walletSTatus" + useWallet);
        print("ware house id ${prefs.getString('ware_house')}");
        print("storeLocation${prefs.getString('store_Location')}");
        String requestJson = jsonEncode({
          "orderid": prefs.getString('orderid'),
          "CompanyId": prefs.getString("com_id"),
          "WarehouseId": prefs.getString('ware_house'),
          "StoreLococation": prefs.getString('store_Location'),
          "usewallet": useWallet,
        });
        final response =
            await apiProvider.post(Appconstants.RAZORPAY_ORDERID, requestJson);
        if (response != null && response['d'] != null) {
          hideLoading();
          razorpayId = response["d"]["RazorpayorderId"];
          email = response["d"]["EmailID"];
          transId = response["d"]["TrasactionId"];

          print("razorpayId    ${razorpayId}");
          print("email ${email}");
          return "orderId";
        } else {
          hideLoading();
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      hideLoading();
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  getrazorpayreply(paymentId, ctx) async {
    print("razorpay id" + razorpayId.toString());
    print("payment id" + paymentId.toString());
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "Rezorpayorderid": razorpayId,
          "PaymentID": paymentId,
          "trasactionId": "",
          "PaymentStatus": "Success"
        });
        print(razorpayId.toString() + '-----' + paymentId);
        final response =
            await apiProvider.post(Appconstants.RAZORPAY_REPLY, requestJson);
        if (response["d"] != null) {
          print('razorpayreply ' + response["d"].toString());
          orderId = response['d']['OrderNo'];
          hideLoading();
          return "success";
        } else {
          hideLoading();
          print('razorpayreply ' + response["d"].toString());
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      hideLoading();
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  razorpayfail() async {
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "Rezorpayorderid": razorpayId,
          "PaymentID": "",
          "trasactionId": "",
          "PaymentStatus": "fail"
        });
        final response =
            await apiProvider.post(Appconstants.RAZORPAY_REPLY, requestJson);
        if (response['d'] != null) {
          hideLoading();
          print('razorpayreply ' + response["d"].toString());
        }

        notifyListeners();
      } else {
        hideLoading();
      }
    } on SocketException catch (e) {
      hideLoading();
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  razorpayAuth() async {
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await apiProvider.authGet(
          Appconstants.razorpPayAuth + '${razorpayId}/payments',
          Appconstants.rzrpy,
          Appconstants.rzrpySecret,
        );
        if (response != null) {
          hideLoading();
          razorpayauth = RazorpayAuthModel.fromJson(response);
          if (razorpayauth?.items.length != 0 &&
              razorpayauth?.items[0].status == 'failed') {
            await razorpayfail();
          }
          print('razorpayreply ' + response["d"].toString());
        }

        notifyListeners();
      } else {
        hideLoading();
      }
    } on SocketException catch (e) {
      hideLoading();
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  getwalletdetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("comp id${prefs.getString(
          "com_id",
        )}");
        print("warehouse id ${prefs.getString(
          "ware_house",
        )}");
        print("stpore location ${prefs.getString(
          "store_Location",
        )}");
        String requestJson = jsonEncode({
          "companyId": prefs.getString(
            "com_id",
          ),
          "warehouse_id": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response = await apiProvider.post(
            Appconstants.GET_WALLET_DETAILS, requestJson);
        walletdetails = WalletDetailsModel.fromJson(response);
        print('wallet details------ ' + response["d"].toString());
        notifyListeners();
        hideLoading();
        return walletdetails;
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      // showMessage('No Internet connection');
      print(e);
    }
  }

  paybywallet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "orderid": prefs.getString('orderid'),
          "CompanyId": prefs.getString("com_id"),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location'),
          "MobileNo": prefs.getString("mob_no")
        });
        print('-----paybywallet');
        final response =
            await apiProvider.post(Appconstants.PAY_BY_WALLET, requestJson);
        if (response != null || response['d'] != null) {
          orderId = response['d'];
        }
        notifyListeners();
        hideLoading();
        showMessage('Payment for order ${response["d"]} is successful');
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      // showMessage('No Internet connection');
      print(e);
    }
  }

  getwalletAmount() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "companyId": prefs.getString(
            "com_id",
          ),
          "warehouse_id": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await apiProvider.post(Appconstants.GET_WALLET_AMOUNT, requestJson);
        if (response != null || response['d'] != null) {
          walletAmount = response["d"];
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      // showMessage('No Internet connection');
      print(e);
    }
  }

  // getPayUHash(usewallet) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('orderid ${prefs.getString('orderid')}');
  //       print('catId ${prefs.getString('catId')}');
  //       print('com_id ${prefs.getString('com_id')}');
  //       print('ware_house ${prefs.getString('ware_house')}');
  //       print('store_Location ${prefs.getString('store_Location')}');
  //       print(' mob_no ${prefs.getString('mob_no')}');
  //       showLoading();
  //       String requestJson = jsonEncode({
  //         "orderid": prefs.getString('orderid'),
  //         "categryid": prefs.getString('catId'),
  //         "CompanyId": prefs.getString("com_id"),
  //         "WarehouseId": prefs.getString('ware_house'),
  //         "StoreLococation": prefs.getString('store_Location'),
  //         "gltype": "4",
  //         "usewallet": usewallet,
  //         "skuname": "fruit and vegetable",
  //         "MobileNo": prefs.getString("mob_no"),
  //       });
  //       final response =
  //           await apiProvider.post(Appconstants.PayUMoneyHash, requestJson);
  //       if (response != null && response["d"] != null) {
  //         hideLoading();
  //         payUDetails = PayUHashModel.fromJson(response);
  //       } else {
  //         hideLoading();
  //       }

  //       notifyListeners();
  //     }
  //   } on SocketException catch (e) {
  //     navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
  //         ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
  //         : "";
  //     // showMessage('No Internet connection');
  //     print(e);
  //   }
  // }

  // getPayUreply(PayuTrasactionId) async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       showLoading();
  //       String requestJson = jsonEncode({"PayuTrasactionId": PayuTrasactionId});
  //       print('-----' + PayuTrasactionId);
  //       final response =
  //           await apiProvider.post(Appconstants.PayUReply, requestJson);
  //       if (response != null) {
  //         hideLoading();
  //         orderId = response['d']['orderno'];
  //           return "success";
  //       } else {
  //         hideLoading();
  //       }
  //       notifyListeners();
  //     }
  //   } on SocketException catch (e) {
  //     navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
  //         ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
  //         : "";
  //     // showMessage('No Internet connection');
  //     print(e);
  //   }
  // }

  // getPayUreplyCancel(PayuTrasactionId, response) async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');

  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       String requestJson = jsonEncode({
  //         "PayuTrasactionId": PayuTrasactionId,
  //         "orderstatus": "Cancel",
  //         "failure_message": response
  //       });
  //       print('-----' + PayuTrasactionId);
  //       await apiProvider.post(Appconstants.PayUReplyCancel, requestJson);
  //       notifyListeners();
  //     }
  //   } on SocketException catch (e) {
  //     navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
  //         ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
  //         : "";
  //     // showMessage('No Internet connection');
  //     print(e);
  //   }
  // }
}
