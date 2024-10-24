import 'dart:convert';
import 'dart:io';

import 'package:delivoo_stores/Models/OrderDetailModel.dart';
import 'package:delivoo_stores/Models/PastOrderModel.dart';
import 'package:delivoo_stores/Models/getItems_model.dart';
import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/StoreOrdering/Models/loadsoreskutype_mode.dart';
import 'package:delivoo_stores/StoreOrdering/Models/return_store_items_model.dart';
import 'package:delivoo_stores/StoreOrdering/Models/store_order_model.dart'
    as Orders;
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;

import '../../Provider/login_provider.dart';
import '../../main.dart';
import '../Models/getTransferDataModel.dart';
import '../Models/get_availbale_stock_model.dart';
import '../Models/getstock_receive_mode.dart';
import '../Models/getstorck_transfer_allItems_model.dart';
import '../Models/getstoreforstock_tranfer.dart';
import '../Models/invoice_detail_model.dart';
import 'package:provider/provider.dart';

import '../Models/reason_model.dart';
import '../Models/return_wastage_model.dart';
import '../Models/warehouse_company_model.dart';
import '../Models/warehouse_return_item.dart';
import '../Models/warehouse_stores_model.dart';
import '../Models/warehouse_user_model.dart';

class StoreOrderProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
  final ApiProvider apiProvider = ApiProvider();
  Orders.StoreOrderModel? orders;
  OrderDetailModel? orderDetails;
  GetItemsModel? getItems;
  InvoiceDetailModel? invoiceDetails;
  ReturnStoreItemsModel? returnStoreItemsDetails;
  ReturnStoreWastageModel? returnStoreWastageDetails;
  WarehouseReturnItemModel? warehouseReturnItem;
  ReasonModel? reasons;
  WarehouseCompanyModel? warehouseCompany;
  WarehouseStoresModel? warehouseStores;
  WareHouseUserModel? warehouseUserDetails;
  Loadstoreskutypemodel? loadstoresku_type;
  GetStoreListForStockTramsfermodel? getstoresforStockTransfer;
  GetStockTransferAlItemsmodel? getAllItems;
  GetAvailableStockModel? getAvailableStock;
  GetTransferDataModel? getStockTransferData;
  GetStockReceiveDataModel? getStockReceive_Data;
  int? selectedsubcategoryindex;
  Orders.D? selectedOrder;
  int? orderIndex = 0;
  bool? newOrder = false;
  List<String> items = [];
  List<String> Invoiceitems = [];
  List<String> returnStoreItems = [];
  var companyName = "";
  var storeName = "";
  var reason = "";
  var skuname = "Fruit and Vegetable";

  var firstDay;
  var lastDay;
  bool selectedPage = false;
  var packStatus;
  var phoneOrOrderNumber = "";
  var selectedPhone;
  var dateValue = DateTime.now();
  var qrcode;
  bool selectedQr = false;
  var selectedWarehouse = "0";

  var query = "";
  var allItems = false;
  var fromDate = DateTime.now();
  var toDate = DateTime.now();
  var tempCatId = "";
  resetStoreReceiveData() {
    fromDate = DateTime.now();
    toDate = DateTime.now();
    getStockReceive_Data?.d = [];
    notifyListeners();
  }

  selectedCompanyName(value) {
    companyName = value;
    notifyListeners();
  }

  checkCategoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('new_CatId') == "1" ? tempCatId = "1" : "";
    notifyListeners();
  }

  selectedSkuCategory(value) {
    skuname = value;
    notifyListeners();
  }

  selectedQuery(value) {
    query = value;
    notifyListeners();
  }

  selectReason(value) {
    reason = value;
    notifyListeners();
  }

  selectedStoreName(value) {
    storeName = value;
    notifyListeners();
  }

  selectedWarehouseId(value) {
    selectedWarehouse = value;
    notifyListeners();
  }

  notifyDate(value) {
    dateValue = value;
    DateFormat('dd/MM/yyyy').format(dateValue);
    notifyListeners();
  }

  notifyFromDate(value) {
    fromDate = value;
    DateFormat('dd/MM/yyyy').format(fromDate);
    notifyListeners();
  }

  notifyToDate(value) {
    toDate = value;
    DateFormat('dd/MM/yyyy').format(value);
    notifyListeners();
  }

  notifyQr(value) {
    qrcode = value;
    notifyListeners();
  }

  checkQr(value) {
    selectedQr = value;
    notifyListeners();
  }

  checkAllItems(value) {
    allItems = value;
    notifyListeners();
  }

  phoneOrOrder(value, phone) async {
    phoneOrOrderNumber = value;
    selectedPhone = phone;

    notifyListeners();
  }

  orderInfoselectedPage(bool selected) {
    selectedPage = selected;
    notifyListeners();
  }

  changeSwitchStatus({orderid, productId, status, index, value}) async {
    await itemReceived(orderid: orderid, productId: productId, status: status);
    orderDetails?.d![index].itemStatus = await value == false ? "" : "1";
    notifyListeners();
  }

  PastOrderModel? selectedPastOrder;
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

  late String mono;
  get getmno => mono;
  String? otps;
  bool isnumselected = false;
  bool OTPflag = false;
  bool no_internet = true;
  late final String mobileNo;
  late final String otp;

  Future<Null> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    print(comid);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        print("comid" + comid.toString());
        print("warehouse ${prefs.getString('ware_house').toString()}");
        print("storelocation  ${prefs.getString('store_Location')}");

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
            await apiProvider.post(Appconstants.StoreGetOrderInfo, requestJson);
        if (response['d'] != null) {
          hideLoading();
          orders = Orders.StoreOrderModel.fromJson(response);
        } else {
          hideLoading();
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

  Future<Null> getOrderDetails(orderid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        print("orderid $orderid");
        String requestJson = jsonEncode({"orderid": orderid});
        final response = await apiProvider.post(
            Appconstants.StoreGetOrderDetails, requestJson);
        if (response["d"] != null) {
          hideLoading();
          orderDetails = await OrderDetailModel.fromJson(response);
          items = List.generate(orderDetails!.d!.length,
              (index) => orderDetails!.d![index].itemName.toString());
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

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();

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
            await apiProvider.post(Appconstants.StoreGetOrderInfo, requestJson);
        if (response['d'] != null) {
          hideLoading();
          orders = Orders.StoreOrderModel.fromJson(response);
          print("orders.d ${orders?.d!.length}");
          if (searchText == null || searchText == "") {
            items = List.generate(orders!.d!.length,
                (index) => orders!.d![index].customerName.toString());
          }
        } else {
          hideLoading();
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

  selectOrder(value) async {
    selectedOrder = await value;
    notifyListeners();
  }

  // Future<Null> readyToPickUp(orderid) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var comid = prefs.getString('com_id');
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       String requestJson = jsonEncode({
  //         "orderid": orderid,
  //         "companyid": comid,

  //       });
  //       final response =
  //           await apiProvider.post(Appconstants.ReadyToPick, requestJson);
  //       if (response["d"] != null) {
  //         getOrders();

  //         notifyListeners();
  //       }
  //     }
  //   } on SocketException catch (e) {
  //     navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
  //         ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
  //         : "";
  //     print(e);
  //   }
  // }

  Future<Null> itemReceived({orderid, productId, status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(orderid);
    print(productId);
    print(status);
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
            Appconstants.storeItemWiseReciveDone, requestJson);
        if (response["d"] != null) {
          hideLoading();
          print("product packed $response");
          notifyListeners();
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

  Future<Null> allItemReceivedDone({orderid, required String mobiles}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("orderid : $orderid");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "orderid": orderid,
          "status": "1",
          "MobileNo": prefs.getString('mob_no'),
          "RevMobileNo": mobiles
          // prefs.getString('mobile_no'),
        });
        print('${requestJson}');
        print('${mobiles}');

        final response = await apiProvider.post(
            Appconstants.storeAllItemsReceived, requestJson);
        if (response["d"] != null) {
          hideLoading();
          await getOrders();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("orderid : $orderid");
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
        final response = await apiProvider.post(
            Appconstants.storeMyOrderSortQty, requestJson);
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
    }
  }

  Future<Null> getOrderDetailsByName(
      {orderid, itemName, itemId, action, bool? loading}) async {
    print("orderId  $orderid");
    print("itemsname $itemName");
    print("itemId $itemId");
    print("action $action");

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        loading == false ? "" : showLoading();
        String requestJson = jsonEncode({
          "orderid": orderid,
          "ItemName": itemName,
          "itemid": itemId,
          "Action": action
        });
        final response = await apiProvider.post(
            Appconstants.GET_ORDER_DETAILSByName, requestJson);
        if (response == null || response["d"] == null) {
          loading == false ? "" : hideLoading();
          showMessage("no product found");
        } else if (response["d"] != null && response["d"].length != 0) {
          print(response["d"].length.toString());
          loading == false ? "" : hideLoading();
          orderDetails = await OrderDetailModel.fromJson(response);
          if (itemName == null || itemName == "") {
            items = await List.generate(orderDetails!.d!.length,
                (index) => orderDetails!.d![index].itemName.toString());
          }
        } else if (response["d"].length == 0 && itemId != "") {
          loading == false ? "" : hideLoading();
          print("wrong qr");
          showMessage("Invalid Barcode or QR");
        } else {
          loading == false ? "" : hideLoading();
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

  Future<Null> geInvoiceData(
      {orderNo, itemName, scanner, phoneNumber, bool? loading}) async {
    print("orderId  $orderNo");
    print("itemsname $itemName");
    print("phone  $phoneNumber");

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        loading == false ? "" : showLoading();
        String requestJson = jsonEncode({
          "mobileno": phoneNumber != null ? phoneNumber : "",
          "orderno": orderNo != null ? orderNo : "",
          "scannercode": scanner != null ? scanner : "",
          "itemname": itemName != null ? itemName : ""
        });
        final response =
            await apiProvider.post(Appconstants.getInvoiceData, requestJson);
        if (response == null && response["d"] == null) {
          loading == false ? "" : hideLoading();
          invoiceDetails?.d = [];
          showMessage("no product found");
        } else if (response == null || response["d"] == null) {
          loading == false ? "" : hideLoading();
          invoiceDetails?.d = [];
          showMessage("no product found");
        } else if (scanner == "" && response["d"].length == 0) {
          loading == false ? "" : hideLoading();
          invoiceDetails?.d = [];
          showMessage("no product found");
        } else if (response["d"] != null && response["d"].length != 0) {
          print(response["d"].length.toString());
          loading == false ? "" : hideLoading();
          invoiceDetails = await InvoiceDetailModel.fromJson(response);
          if (itemName == null || itemName == "") {
            Invoiceitems = await List.generate(invoiceDetails!.d.length,
                (index) => invoiceDetails!.d[index].skuname.toString());
          }
        } else if (response['d'] == null ||
            response["d"].length == 0 && scanner != "") {
          loading == false ? "" : hideLoading();
          print("wrong qr");
          showMessage("Invalid Barcode or QR");
        } else {
          loading == false ? "" : hideLoading();
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

  checkMobileNumber({mobileNumber}) async {
    print("orderid : $mobileNumber");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        invoiceDetails?.d = [];
        String requestJson = jsonEncode({"membermobileno": mobileNumber});
        final response =
            await apiProvider.post(Appconstants.checkMobileNo, requestJson);
        if (response["d"] != null) {
          hideLoading();

          return response["d"];
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

  returnAndReplace(
      {orderId, skuId, skusid, skuUnit, prtype, refundType}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "orderid": orderId,
          "skuid": skuId,
          "skusid": skusid,
          "skuunit": skuUnit,
          "prtype": prtype,
          "Refundtype": refundType,
          "warehouseId": prefs.getString('ware_house')
        });
        final response =
            await apiProvider.post(Appconstants.ReturnAndReplace, requestJson);
        if (response["d"] != null) {
          hideLoading();
          return response["d"];
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  returnStoreItemsApi({
    loading,
    deliveryDate,
    skuid,
    String? itemName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("itemsName$itemName");
        print(prefs.getString('com_id'));
        loading == false ? "" : showLoading();
        String requestJson = jsonEncode({
          "skusid": skuid != null ? skuid : "",
          "warehouseid": prefs.getString('ware_house'),
          "companyid": prefs.getString('com_id'),
          "deliverydate": deliveryDate != null && deliveryDate != ""
              ? DateFormat('dd/MM/yyyy').format(DateTime.parse(deliveryDate))
              : "",
          "Searchtext": itemName != null ? itemName : "",
        });
        final response =
            await apiProvider.post(Appconstants.returnStoreItems, requestJson);
        if (response == null && response["d"] == null) {
          loading == false ? "" : hideLoading();
          returnStoreItemsDetails?.d = [];
          showMessage("no product found");
        } else if (response == null || response["d"] == null) {
          loading == false ? "" : hideLoading();
          returnStoreItemsDetails?.d = [];
          showMessage("no product found");
        } else if (skuid == "" && response["d"].length == 0) {
          loading == false ? "" : hideLoading();
          returnStoreItemsDetails?.d = [];
          showMessage("no product found");
        } else if (response["d"] != null && response["d"].length != 0) {
          print(response["d"].length.toString());
          loading == false ? "" : hideLoading();
          returnStoreItemsDetails =
              await ReturnStoreItemsModel.fromJson(response);
        } else if (response['d'] == null ||
            response["d"].length == 0 && skuid != "") {
          loading == false ? "" : hideLoading();
          returnStoreItemsDetails?.d = [];
          print("wrong qr");
          showMessage("Invalid Barcode or QR");
        } else {
          returnStoreItemsDetails?.d = [];
          loading == false ? "" : hideLoading();
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

  StoreItemReturn({orderId, skuId, skusid, qty, openTime, closeTime}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print("mobile number ${prefs.getString('mob_no')}");
      print("orderId${orderId}");
      print("skuid${skuId}");
      print("skusid${skusid}");
      print("Returnqty${qty}");
      print("company_id${prefs.getString('com_id')}");
      print("warehouse_id${prefs.getString('ware_house')}");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "b_order_id": orderId,
          "skuid": skuId,
          "skusid": skusid,
          "MobileNo": prefs.getString('mob_no'),
          "Returnqty": qty,
          "company_id": prefs.getString('com_id'),
          "warehouse_id": prefs.getString('ware_house')
        });
        final response =
            await apiProvider.post(Appconstants.storeItemReturn, requestJson);
        if (response["d"] != null) {
          hideLoading();
          if (response['d'] == "0") {
            hideLoading();
            Future.delayed(Duration(milliseconds: 300), () {
              showAlertMessage(
                  title: "RTV booking time closed",
                  message1: openTime == "" ||
                          openTime == null ||
                          closeTime == "" ||
                          closeTime == null
                      ? ""
                      : "RTV Booking Time is Between",
                  message2: openTime == "" ||
                          openTime == null ||
                          closeTime == "" ||
                          closeTime == null
                      ? ""
                      : "${openTime} - ${closeTime}");
            });
          } else if (response["d"] == "1") {
            hideLoading();
          }
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  Future<Null> getItemsApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson =
            jsonEncode({"warehouseid": prefs.getString('ware_house')});
        final response =
            await apiProvider.post(Appconstants.getStoreItems, requestJson);
        if (response["d"] != null) {
          hideLoading();
          getItems = GetItemsModel.fromJson(response);
          // if (itemName == null || itemName == "") {
          //   returnStoreItems = await List.generate(getItems!.d.length, (index) {
          //     return getItems!.d[index].skuname;
          //   });
          // }
          returnStoreItems = await List.generate(getItems!.d.length, (index) {
            return getItems!.d[index].skuname;
          });
        } else {
          hideLoading();
          getItems?.d = [];
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

  returnStoreWastageItemsApi({
    loading,
    deliveryDate,
    skuid,
    String? itemName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        returnStoreWastageDetails?.d = [];
        loading == false ? "" : showLoading();
        String requestJson = jsonEncode({
          "skusid": skuid,
          "warehouseid": prefs.getString('ware_house'),
          "companyid": prefs.getString('com_id'),
          "deliverydate": deliveryDate != null && deliveryDate != ""
              ? DateFormat('dd/MM/yyyy').format(DateTime.parse(deliveryDate))
              : "",
          "Searchtext": itemName != null ? itemName : "",
        });
        final response = await apiProvider.post(
            Appconstants.returnStoreWastage, requestJson);
        if (response == null && response["d"] == null) {
          loading == false ? "" : hideLoading();
          returnStoreWastageDetails?.d = [];
          showMessage("no product found");
        } else if (response == null || response["d"] == null) {
          loading == false ? "" : hideLoading();
          returnStoreWastageDetails?.d = [];
          showMessage("no product found");
        } else if (skuid == "" && response["d"].length == 0) {
          loading == false ? "" : hideLoading();
          returnStoreWastageDetails?.d = [];
          showMessage("no product found");
        } else if (response["d"] != null && response["d"].length != 0) {
          print(response["d"].length.toString());
          loading == false ? "" : hideLoading();
          returnStoreWastageDetails =
              await ReturnStoreWastageModel.fromJson(response);
        } else if (response['d'] == null ||
            response["d"].length == 0 && skuid != "") {
          loading == false ? "" : hideLoading();
          returnStoreWastageDetails?.d = [];
          print("wrong qr");
          showMessage("Invalid Barcode or QR");
        } else {
          returnStoreWastageDetails?.d = [];
          loading == false ? "" : hideLoading();
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

  StoreItemWastageReturn({orderId, skuId, skusid, qty}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print("order id ${orderId}");
      print("skuid ${skuId}");
      print("skusid ${skusid}");
      print("qtyr ${qty}");
      print("company id ${prefs.getString('com_id')}");
      print("mobile number ${prefs.getString('mob_no')}");
      print("ware_house ${prefs.getString('ware_house')}");

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "b_order_id": orderId,
          "skuid": skuId,
          "skusid": skusid,
          "mobileNo": prefs.getString('mob_no'),
          "Wastageqty": qty,
          "company_id": prefs.getString('com_id'),
          "warehouse_id": prefs.getString('ware_house')
        });
        final response = await apiProvider.post(
            Appconstants.storeWastageRetrun, requestJson);
        if (response["d"] != null) {
          hideLoading();
          return "success";
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  Future<Null> getWarehouseItemsApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({"warehouseid": "0"});
        final response =
            await apiProvider.post(Appconstants.getStoreItems, requestJson);
        if (response["d"] != null) {
          hideLoading();
          getItems = GetItemsModel.fromJson(response);
          // if (itemName == null || itemName == "") {
          //   returnStoreItems = await List.generate(getItems!.d.length, (index) {
          //     return getItems!.d[index].skuname;
          //   });
          // }
          returnStoreItems = await List.generate(getItems!.d.length, (index) {
            return getItems!.d[index].skuname;
          });
        } else {
          hideLoading();
          getItems?.d = [];
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

  getWarehouseUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    print(comid);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "MobileNo": prefs.getString('mob_no'),
          "UserWarehouseid": prefs.getString('ware_house')
        });
        final response = await apiProvider.post(
            Appconstants.getWareHouseUserDetails, requestJson);
        if (response['d'] != null) {
          hideLoading();
          warehouseUserDetails = WareHouseUserModel.fromJson(response);
          print('cityId ${response['d']['CityId']}');
          prefs.setString("city_id", response['d']['CityId']);
          return 'success';
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

  Future<Null> getWarehouseCompany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cityId = prefs.getString('city_id');
    print('cityId  $cityId');
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();

        String requestJson = jsonEncode({"cityid": cityId});
        final response = await apiProvider.post(
            Appconstants.getWareHouseCompany, requestJson);
        if (response['d'] != null) {
          hideLoading();
          warehouseCompany = WarehouseCompanyModel.fromJson(response);
        } else {
          hideLoading();
          warehouseCompany?.d = [];
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

  Future<Null> getWarehouseStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson =
            jsonEncode({"compid": prefs.getString('new_comp_id')});
        final response =
            await apiProvider.post(Appconstants.getWarehouseStore, requestJson);
        if (response['d'] != null) {
          hideLoading();
          warehouseStores = WarehouseStoresModel.fromJson(response);
        } else {
          hideLoading();
          warehouseStores?.d = [];
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

  returnWarehouseStoreItemsApi({
    loading,
    deliveryDate,
    qr,
    String? itemName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("itemsName$itemName");
        print(prefs.getString('com_id'));
        print("city_id ${prefs.getString('city_id')}");
        print("ware_house ${prefs.getString('ware_house')}");
        print("selectedWarehouse $selectedWarehouse");
        print(
            "deliveryDate ${DateFormat('dd/MM/yyyy').format(DateTime.parse(deliveryDate))}");
        loading == false ? "" : showLoading();
        String requestJson = jsonEncode({
          "Action": "3",
          "city_id": prefs.getString('city_id'),
          "Revwarehouseid": prefs.getString('ware_house'),
          "warehouseid": selectedWarehouse,
          "ReturnDate": deliveryDate != null && deliveryDate != ""
              ? DateFormat('dd/MM/yyyy').format(DateTime.parse(deliveryDate))
              : "",
          // "SerachItemName": "ONION - 1 KGS",
          "SerachItemName": itemName != null ? itemName : "",
          "Scanqr": qr != null ? qr : "",
          "MobileNo": prefs.getString('mob_no')
        });
        final response = await apiProvider.post(
            Appconstants.warehouseReturnItems, requestJson);
        if (response == null && response["d"] == null) {
          loading == false ? "" : hideLoading();
          warehouseReturnItem?.d = [];
          showMessage("no product found");
        } else if (response == null || response["d"] == null) {
          loading == false ? "" : hideLoading();
          warehouseReturnItem?.d = [];
          showMessage("no product found");
        } else if (qr == "" && response["d"].length == 0) {
          loading == false ? "" : hideLoading();
          warehouseReturnItem?.d = [];
          showMessage("no product found");
        } else if (response["d"] != null && response["d"].length != 0) {
          print(response["d"].length.toString());
          loading == false ? "" : hideLoading();
          warehouseReturnItem =
              await WarehouseReturnItemModel.fromJson(response);
          notifyListeners();
          return "sucess";
        } else if (response['d'] == null ||
            response["d"].length == 0 && qr != "") {
          loading == false ? "" : hideLoading();
          warehouseReturnItem?.d = [];
          print("wrong qr");
          showMessage("Invalid Barcode or QR");
        } else {
          warehouseReturnItem?.d = [];
          loading == false ? "" : hideLoading();
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

  WareHouseItemReceive({
    rtnId,
    skuId,
    skusid,
    reason,
    shrtQty,
    qty,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print("mobile number ${prefs.getString('mob_no')}");
      print("skuid${skuId}");
      print("skusid${skusid}");
      print("Returnqty${qty}");
      print("warehouse_id${prefs.getString('ware_house')}");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Action": "4",
          "Rtn_ID": rtnId,
          "recieveqty": qty,
          "shortqty": shrtQty,
          "MobileNo": prefs.getString('mob_no'),
          "recieve_warehouse_id": prefs.getString('ware_house'),
          "reason": reason,
          "skuid": skuId,
          "skusid": skusid,
          "warehouse_id": selectedWarehouse
        });
        final response = await apiProvider.post(
            Appconstants.WareHouseSaveReturnQty, requestJson);
        if (response["d"] != null) {
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

  getReasons() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({});
        final response =
            await apiProvider.post(Appconstants.loadReasons, requestJson);
        if (response["d"] != null) {
          hideLoading();
          reasons = ReasonModel.fromJson(response);
          // if (itemName == null || itemName == "") {
          //   returnStoreItems = await List.generate(getItems!.d.length, (index) {
          //     return getItems!.d[index].skuname;
          //   });
          // }
          // returnStoreItems = await List.generate(getItems!.d.length, (index) {
          //   return getItems!.d[index].skuname;
          // });
        } else {
          hideLoading();
          reasons?.d = [];
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

  Future<Null> loadStoreSkuType() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();

        String requestJson = jsonEncode({"status": "1"});
        final response = await apiProvider.post(
            Appconstants.storeTransferLoadSkyuType, requestJson);
        if (response['d'] != null) {
          hideLoading();
          loadstoresku_type = Loadstoreskutypemodel.fromJson(response);
        } else {
          hideLoading();
          loadstoresku_type?.d = [];
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

  // "company_id": prefs.getString('com_id'),
  //       "warehouse_id": prefs.getString('ware_house')

  Future<Null> getStoresForStockTransfer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("ware_house ${prefs.getString('ware_house')}");
        showLoading();
        String requestJson = jsonEncode({
          "compid": prefs.getString('com_id'),
          "warehouseid": prefs.getString('ware_house')
        });
        final response = await apiProvider.post(
            Appconstants.getStoreforStockTransfer, requestJson);
        if (response['d'] != null) {
          hideLoading();
          getstoresforStockTransfer =
              GetStoreListForStockTramsfermodel.fromJson(response);
        } else {
          hideLoading();
          getstoresforStockTransfer?.d = [];
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

  Future<Null> getCurrentStoreItemsApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Action": "1",
          "warehouseid": prefs.getString('ware_house'),
          "category_id": prefs.getString('new_CatId')
        });
        final response = await apiProvider.post(
            Appconstants.storeTransfeAllItems, requestJson);
        if (response["d"] != null) {
          hideLoading();
          getAllItems = GetStockTransferAlItemsmodel.fromJson(response);
          // if (itemName == null || itemName == "") {
          //   returnStoreItems = await List.generate(getItems!.d.length, (index) {
          //     return getItems!.d[index].skuname;
          //   });
          // }
          returnStoreItems =
              await List.generate(getAllItems!.d.length, (index) {
            return getAllItems!.d[index].itemName;
          });
        } else {
          hideLoading();
          getAllItems?.d = [];
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

  returnAvailableStoreItemsApi({
    action,
    loading,
    qr,
    String? itemName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("ware_house ${prefs.getString('ware_house')}");
        print("action $action");
        print("itemname  $itemName");
        print("catID ${prefs.getString('new_CatId')}");
        print("transfer_warehouse_id ${prefs.getString('new_store_id')}");
        loading == false ? "" : showLoading();
        String requestJson = jsonEncode({
          "Action": action != null
              ? action
              : "8", ////     If Serchtext then Action "8" If Barcode Then Action "1"
          "warehouseid": prefs.getString('ware_house'),
          "category_id": prefs.getString('new_CatId'),
          "sku_sid": qr != null ? qr : "",
          "Searchtext": itemName,
          "transfer_warehouse_id": prefs.getString('new_store_id')
        });
        final response =
            await apiProvider.post(Appconstants.getAvailableStock, requestJson);
        if (response == null && response["d"] == null) {
          loading == false ? "" : hideLoading();
          getAvailableStock?.d = [];
          showMessage("no product found");
        } else if (response == null || response["d"] == null) {
          loading == false ? "" : hideLoading();
          getAvailableStock?.d = [];
          showMessage("no product found");
        } else if (qr == "" && response["d"].length == 0) {
          loading == false ? "" : hideLoading();
          getAvailableStock?.d = [];
          showMessage("no product found");
        } else if (response["d"] != null && response["d"].length != 0) {
          print(response["d"].length.toString());
          loading == false ? "" : hideLoading();
          getAvailableStock = await GetAvailableStockModel.fromJson(response);
          notifyListeners();
          return "sucess";
        } else if (response['d'] == null ||
            response["d"].length == 0 && qr != "") {
          loading == false ? "" : hideLoading();
          getAvailableStock?.d = [];
          print("wrong qr");
          showMessage("Invalid Barcode or QR");
        } else {
          getAvailableStock?.d = [];
          loading == false ? "" : hideLoading();
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

  Future StockTransferQuantity({
    sku_sid,
    Qty,
  }) async {
    // adding quantity
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("addd");
        print("warehouse id ${prefs.getString('ware_house')}");
        print('transfer warehouse ${prefs.getString('new_store_id')}');
        print("mobile number ${prefs.getString('mob_no')}");
        print("skuis $sku_sid");
        print("company id ${prefs.getString('com_id')}");

        showLoading();
        String requestJson = jsonEncode({
          "Action": "3",
          "warehouseid": prefs.getString('ware_house'),
          "scanid": "",
          "sku_id": "",
          "sku_sid": sku_sid,
          "transfer_warehouse_id": prefs.getString('new_store_id'),
          "comp_id": prefs.getString('com_id'),
          "Transferqty": Qty,
          "MobileNo": prefs.getString('mob_no')
        });
        final response =
            await apiProvider.post(Appconstants.add_transfer_qty, requestJson);
        if (response["d"] != null) {
          // orderDetails?.d![index].delUnit = delQty;
          // print("qty changed $response");

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
    }
  }

  Future UpdateStockTransferQuantity({
    sku_sid,
    Qty,
  }) async {
    //updating quantity
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Action": "5",
          "warehouseid": prefs.getString('ware_house'),
          "sku_sid": sku_sid,
          "transfer_warehouse_id": prefs.getString('new_store_id'),
          // "comp_id": prefs.getString('com_id'),
          "Transferqty": Qty,
          "MobileNo": prefs.getString('mob_no')
        });
        final response = await apiProvider.post(
            Appconstants.updateStockTranfer, requestJson);
        if (response["d"] != null) {
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
    }
  }

  getTransferData({
    loading,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("ware_house ${prefs.getString('ware_house')}");
        print("catID ${prefs.getString('new_CatId')}");
        print("transfer_warehouse_id ${prefs.getString('new_store_id')}");
        loading == false ? "" : showLoading();
        String requestJson = jsonEncode({
          "Action": "4",
          "warehouseid": prefs.getString('ware_house'),
          "transfer_warehouse_id": prefs.getString('new_store_id'),
          "category_id": prefs.getString('new_CatId'),
        });
        final response =
            await apiProvider.post(Appconstants.getTransferData, requestJson);

        if (response["d"] != null && response["d"].length != 0) {
          loading == false ? "" : hideLoading();
          getStockTransferData = await GetTransferDataModel.fromJson(response);
          notifyListeners();
          return "sucess";
        } else {
          getStockTransferData?.d = [];
          loading == false ? "" : hideLoading();
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

  Future deleteStockRecord({
    trnsId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Action": "6",
          "Trans_ID": trnsId,
          "MobileNo": prefs.getString('mob_no')
        });
        final response = await apiProvider.post(
            Appconstants.deleteTransferRecord, requestJson);
        if (response["d"] != null) {
          await getTransferData(loading: false);
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
    }
  }

  Future submitStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("transfer_warehouse_id ${prefs.getString('new_store_id')}");
        print("warehouse id ${prefs.getString('ware_house')}");
        print("mobileNO: ${prefs.getString('mob_no')}");
        showLoading();
        String requestJson = jsonEncode({
          "Action": "7",
          "warehouse_id": prefs.getString('ware_house'),
          "transfer_warehouse_id": prefs.getString('new_store_id'),
          "MobileNo": prefs.getString('mob_no')
        });
        final response =
            await apiProvider.post(Appconstants.stockSubmit, requestJson);
        if (response["d"] == "1") {
          await getTransferData(loading: false);
          hideLoading();
          notifyListeners();
          return response["d"];
        } else {
          hideLoading();
        }
        notifyListeners();
      }
    } on SocketException {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
    }
  }

  Future<Null> getStockReceiveData({required fromDate, required toDate}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      print(prefs.getString('ware_house'));
      print("from date ${fromDate.toString()}");
      print("toDate ${toDate.toString()}");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Action": "9",
          "receive_warehouse_id": prefs.getString('ware_house'),
          "fromDate": fromDate.toString(),
          "toDate": toDate.toString()
        });
        final response = await apiProvider.post(
            Appconstants.getStockReceiveData, requestJson);
        if (response["d"] != null) {
          hideLoading();
          getStockReceive_Data = GetStockReceiveDataModel.fromJson(response);
        } else {
          hideLoading();
          getStockReceive_Data?.d = [];
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

  Future StoreTransferitemReceived({recQty, balQty, transId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Action": "10",
          "receiveqty": recQty,
          "balanceqty": balQty,
          "Trans_ID": transId,
          "MobileNo": prefs.getString('mob_no')
        });
        final response =
            await apiProvider.post(Appconstants.receiveStockQty, requestJson);
        if (response["d"] != null) {
          hideLoading();
          notifyListeners();
          return "sucess";
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

  Future sendOtpRecItems(String mobileNo) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"Action": "1", "MobileNo": mobileNo});
        mono = mobileNo;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("mobile_no", mobileNo);
        notifyListeners();
        final response = await apiProvider.post(
            Appconstants.SEND_OTP_REV_ITEMS, requestJson);
        print('---------------sendotp');
        print('response is ${response["d"]}');
        if (response["d"] == '1') {
          return true;
        } else if (response["d"] == '2') {
          showMessage('Failed to Send OTP');
          return false;
        } else {
          hideLoading();
          return true;
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  Future verifyOtpStore(
      String mobileNo, String otp, BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"Mobileno": mobileNo, "otp": otp});
        print('${mobileNo}');
        print('${otp}');
        print('${requestJson}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("mobile_no", mobileNo);
        notifyListeners();
        final response =
            await apiProvider.post(Appconstants.VERIFYOTPSTORE, requestJson);
        print('-------------------verifyotp');
        print('response is ${response["d"]}');
        if (response["d"] == '1') {
          return true;
        } else if (response["d"] == '2') {
          showMessage("invalid OTP");
          return false;
        } else {
          hideLoading();
          return false;
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
