import 'dart:convert';
import 'dart:io';
import 'package:delivoo_stores/Models/DeliverySlotModel.dart';
import 'package:delivoo_stores/Models/company_info_model.dart';
import 'package:delivoo_stores/Models/holidayListModel.dart';
import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:delivoo_stores/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/MobileNumber/UI/phone_number.dart';
import 'package:provider/provider.dart';

import 'login_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final ApiProvider apiProvider = ApiProvider();
  CompanyInfoModel? companyInfoDetais;
  CompanyInfoModel? selectedcompanyInfoDetais;
  DeliverySlotModel? deliverySlot;
  HolidayListModel? holidayList;

  notifyImage() {
    companyInfoDetais?.d?.companyinfo?.imgpath = null;
    notifyListeners();
  }

  setDeliveryType(value) {
    companyInfoDetais!.d!.companyinfo!.deliveryType = value;
    print(companyInfoDetais!.d!.companyinfo!.deliveryType);
    notifyListeners();
  }

  getCustomerInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("company Id ${prefs.getString("com_id")}");
    try {
      print("ware house id ${prefs.getString('ware_house')}");
      print("storeLocation ${prefs.getString('store_Location')}");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "companyId": prefs.getString("com_id"),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await apiProvider.post(Appconstants.GET_COMPANY_INFO, requestJson);
        if (response != null && response["d"] != null) {
          hideLoading();
          companyInfoDetais = CompanyInfoModel.fromJson(response);
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

  UpdateProfile(
    lat,
    long,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("com_id"));
    // print(companyInfoDetais!.d!.companyinfo!.deliveryType);
    print(
      companyInfoDetais!.d!.companyinfo!.compaddress1,
    );
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "companyId": prefs.getString("com_id"),
          "Company_Name": companyInfoDetais!.d!.companyinfo!.companyName,
          "ContpersonName": companyInfoDetais!.d!.companyinfo!.contactPerson,
          "Email_id": "",
          "Mobileno": companyInfoDetais!.d!.companyinfo!.phone,
          "Latitude": lat,
          "Longitude": long,
          "Pincode": companyInfoDetais!.d!.companyinfo!.comppincode,
          "LocationId": companyInfoDetais!.d!.companyinfo!.locationid,
          "Address1": companyInfoDetais!.d!.companyinfo!.compaddress1,
          "Address2": companyInfoDetais!.d!.companyinfo!.compaddress2,
          "gstNo": companyInfoDetais!.d!.companyinfo!.gstin,
          "panNo": companyInfoDetais!.d!.companyinfo!.panNo,
          "fssainumber": companyInfoDetais!.d!.companyinfo!.fssainumber,
          "deliverytype":
              companyInfoDetais!.d!.companyinfo!.deliveryType != null
                  ? companyInfoDetais!.d!.companyinfo!.deliveryType.toString()
                  : "",
          "shopopentime": companyInfoDetais!.d!.companyinfo!.openTime,
          "shopclosetime": companyInfoDetais!.d!.companyinfo!.closeTime,
          "mapaddress": companyInfoDetais!.d!.companyinfo!.mapAddress,
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await apiProvider.post(Appconstants.Update_Profile, requestJson);
        if (response["d"] == '') {
          hideLoading();
          return 'success';
        } else if (response["d"] == "0") {
          hideLoading();
          showMessage("Company Name Already Exist");
        } else {
          hideLoading();
          showMessage(response["Message"] ?? "Something Went Wrong");
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  updateSlots({action, slotonoff, slotId, orderLimit}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Action": action,
          "comid": prefs.getString("com_id"),
          "slotId": slotId,
          "slotonoff": slotonoff,
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location'),
          "OrderLimit": orderLimit
        });

        final response = await apiProvider.post(
            Appconstants.UpdateDeliverySlots, requestJson);
        if (response["d"] != null) {
          hideLoading();
          deliverySlot = DeliverySlotModel.fromJson(response);
          notifyListeners();

          print("response ${response["d"]}");
        } else if (response["d"].length == 0) {
          hideLoading();
          showMessage("No Slots Available");
        } else {
          showMessage("Shop open or close Time not set ");
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  changeAddress(value) async {
    companyInfoDetais!.d!.companyinfo!.mapAddress = value;
    notifyListeners();
  }

  updateHoliday({action, holidayDate, holidayId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Action": action,
          "companyid": prefs.getString("com_id"),
          "Holidaydate": holidayDate,
          "holidayId": holidayId,
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });

        final response =
            await apiProvider.post(Appconstants.updateHoliday, requestJson);
        if (response["d"] != null) {
          hideLoading();
          holidayList = HolidayListModel.fromJson(response);

          notifyListeners();

          print("response ${response["d"]}");
          return "sucess";
        }
      }
    } on SocketException catch (e) {
      navigatorKey.currentContext?.read<LoginProvider>().no_internet == true
          ? navigatorKey.currentContext?.read<LoginProvider>().noInternet()
          : "";
      print(e);
    }
  }

  Future<Null> deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("com_id"));
    print(prefs.getString("ware_house"));
    print(prefs.getString("store_Location"));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "storeid": prefs.getString("com_id"),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await apiProvider.post(Appconstants.deleteAccount, requestJson);
        if (response["d"] == "1") {
          hideLoading();
          showDialog(
              barrierDismissible: false,
              context: navigatorKey.currentContext!,
              builder: (context) => Center(
                      child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    content: Material(
                      color: Colors.white,
                      child: Text("Your Account has been deleted Sucessfully"),
                    ),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kMainColor),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhoneNumber()));
                          },
                          child: Text("Ok"))
                    ],
                  )));
          prefs.clear();
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
}
