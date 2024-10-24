import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:delivoo_stores/Models/OrderDetailModel.dart';
import 'package:delivoo_stores/Models/OrderModel.dart' as Order;
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;

import '../Models/deliveryboy_model.dart';
import '../Models/razorpay_reply_manually_model.dart';
import '../Models/razorpayauthModel.dart';
import '../Models/store_payment_model.dart';
import '../main.dart';
import 'package:provider/provider.dart';

class OrderProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();
  Order.OrderModel? orders;
  OrderDetailModel? orderDetails;
  int? selectedsubcategoryindex;
  Order.D? selectedOrder;
  int? orderIndex = 0;
  bool? newOrder = false;
  List<String> items = [];
  var firstDay;
  var lastDay;
  bool selectedPage = false;
  var packStatus;
  bool _loading = true;
  bool get isLoading => _loading;
  var packed;
  int counter = 60;
  Timer? timer;
  DeliveryBoyListModel? deliveryboyList;
  CheckPaymentStatusModel? paymentStatusDetails;
  RazorpayAuthModel? razorpayauth;
  RazorPayReplyManuallyModel? razorPayReplyManuallyDetails;

  orderInfoselectedPage(bool selected) {
    selectedPage = selected;
    notifyListeners();
  }

  // chngeQuantity({index, quantity, orderid, productId}) {
  //   sortQuantity(
  //       orderid: orderid, productId: productId, delQty: quantity, index: index);

  //   notifyListeners();
  // }

  changeSwitchStatus({orderid, productId, status, index, value}) async {
    await productPacked(orderid: orderid, productId: productId, status: status);
    orderDetails?.d![index].itemStatus = await value == false ? "" : "1";
    notifyListeners();
  }

  int? pastOrderIndex = 0;

  DatePickerFirstDay(value) async {
    firstDay = DateFormat('dd/MM/yyyy').format(value);
    notifyListeners();
  }

  DatePickerLastDay(value) async {
    lastDay = DateFormat('dd/MM/yyyy').format(value);
    notifyListeners();
  }

  clearFirstDate() async {
    firstDay = null;
    notifyListeners();
  }

  clearLastDate() async {
    lastDay = null;
    notifyListeners();
  }

  orderStatus(bool value) {
    newOrder = value;
    notifyListeners();
  }

  Future<Null> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    print(comid);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _loading = true;
        String requestJson = jsonEncode({
          "storeid": comid,
          "Pastorder": "1",
          "frmdeldate": "",
          "todeldate": "",
          "customerName": "",
          "orderno": "",
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await apiProvider.post(Appconstants.GET_ORDER, requestJson);
        if (response['d'] != null) {
          _loading = false;
          orders = Order.OrderModel.fromJson(response);
        } else {
          _loading = false;
          orders?.d = [];
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

  Future<Null> getDeliveyBoyList(orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode(
            {"orderid": orderId, "warehouseid": prefs.getString('ware_house')});
        final response =
            await apiProvider.post(Appconstants.deliveryBoyList, requestJson);
        if (response["d"] != null) {
          hideLoading();
          deliveryboyList = DeliveryBoyListModel.fromJson(response);
        } else {
          hideLoading();
          deliveryboyList?.d = [];
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

  Future<Null> updateDeliveryBoy({String? orderId, delboyId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      print("orderId" + orderId.toString());
      print("delboy Id" + delboyId.toString());
      print("mobile" + prefs.getString("mob_no").toString());
      print("warehouse" + prefs.getString('ware_house').toString());
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "orderid": orderId,
          "mobileno": prefs.getString("mob_no"),
          "delboyid": delboyId,
          "warehouseid": prefs.getString('ware_house')
        });
        final response =
            await apiProvider.post(Appconstants.updateDeliveryBoy, requestJson);
        if (response["d"] != null) {
          await getOrders();
        }
        hideLoading();
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

  Future<Null> getOrderDetails(orderid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({"orderid": orderid});
        final response =
            await apiProvider.post(Appconstants.GET_ORDER_DETAILS, requestJson);
        if (response["d"] != null) {
          hideLoading();
          orderDetails = OrderDetailModel.fromJson(response);
        } else {
          hideLoading();
          orderDetails?.d = [];
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

  getPastOrders({String? fromdate, String? toDate, searchText, orderNo}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    print("$comid");
    _loading = true;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "storeid": comid,
          "Pastorder": "0",
          "frmdeldate": fromdate ?? "",
          "todeldate": toDate ?? "",
          "customerName": searchText ?? "",
          "orderno": orderNo ?? "",
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await apiProvider.post(Appconstants.GET_ORDER, requestJson);
        if (response['d'] != null) {
          //hideLoading();
          _loading = false;
          orders = Order.OrderModel.fromJson(response);
          print("orders.d ${orders?.d!.length}");
          print("$comid");
          if (searchText == null || searchText == "") {
            items = List.generate(orders!.d!.length,
                (index) => orders!.d![index].customerName.toString());
          }
        } else {
          // hideLoading();
          _loading = false;
          orders?.d = [];
          print("orders.d ${orders?.d!.length}");
          // showMessage('No Order Found');
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
    notifyListeners();
  }

  getNextDayOrders(
      {String? fromdate, String? toDate, searchText, orderNo}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    _loading = true;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "storeid": comid,
          "Pastorder": "2",
          "frmdeldate": fromdate ?? "",
          "todeldate": toDate ?? "",
          "customerName": searchText ?? "",
          "orderno": orderNo ?? "",
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await apiProvider.post(Appconstants.GET_ORDER, requestJson);
        if (response['d'] != null) {
          _loading = false;
          orders = Order.OrderModel.fromJson(response);
        } else {
          _loading = false;
          orders?.d = [];
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
    notifyListeners();
  }

  selectOrder(value) async {
    selectedOrder = await value;
    notifyListeners();
  }

  readyToPickUp({orderid, modelName, brandName}) async {
    print(brandName);
    print(modelName);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    print("mobile number ${prefs.getString('mob_no')}");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "orderid": orderid,
          "companyid": comid,
          "modelno": modelName,
          "brandname": brandName,
          "MobileNo": prefs.getString('mob_no')
        });
        final response =
            await apiProvider.post(Appconstants.ReadyToPick, requestJson);
        if (response["d"] != null) {
          await getOrders();
          await getOrderDetails(orderid);

          return packed = "packed";
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

  Future<Null> productPacked({orderid, productId, status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("mobile number ${prefs.getString('mob_no')}");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "orderid": orderid,
          "ProductId": productId,
          "status": status,
          "MobileNo": prefs.getString('mob_no')
        });
        final response = await apiProvider.post(
            Appconstants.productPacked_notPacked, requestJson);
        if (response["d"] != null) {
          hideLoading();
          print("product packed $response");
          notifyListeners();
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  Future<Null> allPackingDone({orderid}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("orderid : $orderid");
    print("mobile number ${prefs.getString('mob_no')}");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "orderid": orderid,
          "status": "1",
          "MobileNo": prefs.getString('mob_no')
        });
        final response =
            await apiProvider.post(Appconstants.allPackingDone, requestJson);
        if (response["d"] != null) {
          hideLoading();

          await getOrderDetails(orderid);
          print("all Items packed $response");
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  Future<Null> sortQuantity({orderid, productId, delQty, index}) async {
    print("orderid : $orderid");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("mobile number ${prefs.getString('mob_no')}");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "orderid": orderid,
          "ProductId": productId,
          "Delqty": delQty,
          "MobileNo": prefs.getString('mob_no')
        });
        final response =
            await apiProvider.post(Appconstants.sortQuantity, requestJson);
        if (response["d"] != null) {
          orderDetails?.d![index].delUnit = delQty;
          print("qty changed $response");
          hideLoading();
          notifyListeners();
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

  Future<Null> deliveryDone({orderid, modelName, brandName}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "orderid": orderid,
          "deltype": "2",
          "modelno": modelName,
          "brandname": brandName
        });
        final response =
            await apiProvider.post(Appconstants.deliveryDone, requestJson);
        if (response["d"] != null) {
          await getOrders();
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

  Future<Null> sendOtpToDeliveryBoy(
    orderid,
  ) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "orderid": orderid,
        });
        final response = await apiProvider.post(
            Appconstants.sendOtptoDeliveryBoy, requestJson);
        if (response["d"] != null) {
          hideLoading();
        } else {
          hideLoading();
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

  outForDelivery({orderid, otp, context, modelName, brandName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("mobile number ${prefs.getString('mob_no')}");
    print(otp);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "orderid": orderid,
          "deltype": "",
          "delboyotp": otp,
          "modelno": modelName,
          "brandname": brandName,
          "MobileNo": prefs.getString('mob_no')
        });
        final response =
            await apiProvider.post(Appconstants.outforDelivery, requestJson);
        if (response == null || response['d'] == null) {
          showMessage("Somethind went wrong contact customer care");
        } else if (response['d'] == "1") {
          hideLoading();
          await getOrders();
          return "Sucess";
        } else if (response['d'] == "0") {
          hideLoading();
          showMessage("Wrong Otp");
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

  setTimer() {
    counter = 60;
    timer = Timer.periodic(Duration(seconds: 1), (value) {
      counter > 0 ? counter-- : value.cancel();
      notifyListeners();
    });
  }

  getOrdersPeriodic() {
    // counter = 100;
    timer = Timer.periodic(Duration(seconds: 300), (value) async {
      // counter > 0 ? counter-- : value.cancel();
      await getOrders();
      await getPaymentDetails();
      print("timer of 5min");
    });
  }

  Future<Null> getPaymentDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    print(comid);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _loading = true;
        String requestJson = jsonEncode({
          "companyid": comid,
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location'),
          "businessmodel": "2"
        });
        final response = await apiProvider.post(
            Appconstants.getStorePayDetails, requestJson);
        if (response['d'] != null) {
          _loading = false;
          paymentStatusDetails =
              await CheckPaymentStatusModel.fromJson(response);
          notifyListeners();
        } else {
          paymentStatusDetails?.d = [];
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      _loading = false;
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  razorpayAuth({orderId, delDate}) async {
    try {
      showLoading();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await apiProvider.authGet(
          Appconstants.razorpPayAuth + '${orderId}/payments',
          Appconstants.rzrpy,
          Appconstants.rzrpySecret,
        );
        if (response != null) {
          hideLoading();
          razorpayauth = await RazorpayAuthModel.fromJson(response);
          if (razorpayauth?.items.length != 0 &&
              razorpayauth?.items[0].status == 'captured') {
            print("orderID: ${orderId}");
            print("delDate ${delDate}");
            print("payId: ${razorpayauth?.items[0].id}");
            await razorPayReplyManually(
                delDate: delDate,
                razorPayId: orderId,
                payId: razorpayauth?.items[0].id);
            showMessage(
                "Payment submitted Successfully\n OrderId: ${razorPayReplyManuallyDetails?.d.orderNo}");
            return "success";
          } else if (razorpayauth?.items.length != 0 &&
              razorpayauth?.items[0].status == 'failed') {
            showMessage(razorpayauth!.items[0].errorDescription.toString());
          } else if (razorpayauth?.items.length != 0 &&
              razorpayauth?.items[0].status == 'created') {
            showMessage("Payment Cancelled by the customer.");
          } else if (razorpayauth?.items.length != 0 &&
              razorpayauth?.items[0].status == 'refunded') {
            await razorPayReplyManually(
                delDate: delDate,
                razorPayId: orderId,
                payId: razorpayauth?.items[0].id);
            showMessage("Amount has been refunded in Customer wallet.");
          } else {
            showMessage("Payment not done by the customer");
          }
        } else {
          hideLoading();
        }
        notifyListeners();
      }
    } on Exception catch (e) {
      hideLoading();
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  Future<Null> razorPayReplyManually({razorPayId, payId, delDate}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Rezorpayorderid": razorPayId,
          "PaymentID": payId,
          "trasactionId": payId,
          "PaymentStatus": "Success",
          "deliveryDate": delDate
        });
        final response = await apiProvider.post(
            Appconstants.razorPayReplyManually, requestJson);
        if (response["d"] != null) {
          razorPayReplyManuallyDetails =
              await RazorPayReplyManuallyModel.fromJson(response);
          hideLoading();
          await getPaymentDetails();
        } else {
          hideLoading();
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }
}
