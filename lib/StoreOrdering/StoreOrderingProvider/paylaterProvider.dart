import 'dart:convert';
import 'dart:io';

import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/StoreOrdering/Models/storeOrdering_cartTotalModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;
import '../../Provider/login_provider.dart';
import '../../Utils/CommonWidget.dart';
import '../../main.dart';
import 'package:provider/provider.dart';

class PayLaterProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();
  String? razorpayId;
  String? orderId;
  String? email;
  String? transId;
  int? pageIndex = 0;
  StoreOrderingCartTotalModel? getCartToalForPayLater;
  // PayUHashModel? payUPayLaterDetails;
  getPageIndex(index) async {
    pageIndex = index;
    notifyListeners();
  }

  getrazorpayIdforPayLater(orderId, useWallet) async {
    print(useWallet);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("orderId  $orderId");
        print("ware house id ${prefs.getString('ware_house')}");
        print("storeLocation${prefs.getString('store_Location')}");
        print("CompanyId${prefs.getString('com_id')}");
        String requestJson = jsonEncode({
          "orderid": orderId.toString(),
          "CompanyId": prefs.getString("com_id"),
          "WarehouseId": prefs.getString('ware_house'),
          "StoreLococation": prefs.getString('store_Location'),
          "usewallet": useWallet
        });
        final response =
            await apiProvider.post(Appconstants.payLater, requestJson);
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

  getrazorpayLaterReply(paymentId, ctx) async {
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
        final response = await apiProvider.post(
            Appconstants.RazorPayLater_Reply, requestJson);
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

  razorpayLaterfail() async {
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("razorpay id" + razorpayId.toString());
        String requestJson = jsonEncode({
          "Rezorpayorderid": razorpayId,
          "PaymentID": "",
          "trasactionId": "",
          "PaymentStatus": "fail"
        });
        final response = await apiProvider.post(
            Appconstants.RazorPayLater_Reply, requestJson);
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

  cartTotalForPayLater(orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode(
            {"borderid": orderId, "shopid": prefs.getString("com_id")});
        final response = await apiProvider.post(
            Appconstants.CartTotalForPayLater, requestJson);
        if (response['d'] != null) {
          getCartToalForPayLater =
              StoreOrderingCartTotalModel.fromJson(response);
          hideLoading();
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

  paybywallet(odrId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "orderid": odrId,
          "CompanyId": prefs.getString("com_id"),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location'),
          "MobileNo": prefs.getString("mob_no")
        });
        print('-----paybywallet');
        final response = await apiProvider.post(
            Appconstants.PayByWallet_forPayLater, requestJson);
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

  // getPayUHash(usewallet, orderId) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('orderid $orderId');

  //       print('com_id ${prefs.getString('com_id')}');
  //       print('ware_house ${prefs.getString('ware_house')}');
  //       print('store_Location ${prefs.getString('store_Location')}');
  //       print(' mob_no ${prefs.getString('mob_no')}');
  //       showLoading();
  //       String requestJson = jsonEncode({
  //         "orderid": orderId,
  //         // "categryid": prefs.getString('catId'),
  //         "categryid": "1",
  //         "CompanyId": prefs.getString("com_id"),
  //         "WarehouseId": prefs.getString('ware_house'),
  //         "StoreLococation": prefs.getString('store_Location'),
  //         "gltype": "5",
  //         "usewallet": usewallet,
  //         "skuname": "fruit and vegetable",
  //         "MobileNo": prefs.getString("mob_no"),
  //       });
  //       final response =
  //           await apiProvider.post(Appconstants.PayUPayPaterHash, requestJson);
  //       if (response != null && response["d"] != null) {
  //         payUPayLaterDetails = PayUHashModel.fromJson(response);
  //         hideLoading();
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
