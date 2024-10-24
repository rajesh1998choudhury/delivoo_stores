// ignore_for_file: unused_element, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:delivoo_stores/Auth/MobileNumber/UI/phone_number.dart';
import 'package:delivoo_stores/Auth/Registration/UI/register_page.dart';
import 'package:delivoo_stores/Models/LoadLocationModel.dart';
import 'package:delivoo_stores/Models/LoadStateModel.dart';
import 'package:delivoo_stores/Models/PincodeModel.dart';
import 'package:delivoo_stores/Models/city_list_model.dart';
import 'package:delivoo_stores/Models/company_info_model.dart';
import 'package:delivoo_stores/Models/stores_list_Model.dart';
import 'package:delivoo_stores/OrderItemAccount/order_item_account.dart';
import 'package:delivoo_stores/Pages/approval.dart';
import 'package:delivoo_stores/Pages/cityList.dart';
import 'package:delivoo_stores/Pages/storeList.dart';
import 'package:delivoo_stores/Service/Api_Provider.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/warehouseRTV/warehouse_mainpage.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:delivoo_stores/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart' as Appconstants;
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/banner_model.dart';

class LoginProvider extends ChangeNotifier with DiagnosticableTreeMixin {
  final ApiProvider _apiProvider = ApiProvider();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var deviceData = <String, dynamic>{};
  String? _fcmToken;
  String? _os;
  String? _deviceId;
  String deviceName = "";
  String brandName = "";
  String? mno;
  get getmno => mno;
  File? image;
  String? comid;
  get getid => comid;
  String? userType;
  get getuserType => userType;
  var storeType = '';
  String? storeLocation = "";
  String? wareHouse = "";
  String? storeLocationName;
  String? NotificatonStatus;
  String? city;

  LoadState? state;
  LoadState? get getstate => state;

  Loadlocation? loc;
  Loadlocation? get getloc => loc;
  PincodeModel? pincodes;
  BannerModel? banner;
  String? OTP;
  bool isnumselected = false;
  var mobile;
  CompanyInfoModel? companyInfoDetais;
  StoresListModel? storesList;
  CityLIstModel? cityList;

  String? _locationId;
  get getlocationId => _locationId;
  int? currentIndex = 0;
  int? selectedBarIndex = 0;
  bool? isLoading = true;
  var sessionId = "0";
  bool no_internet = true;

  verifyExistingNumber(String mobile) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({"Mobileno": mobile, "appid": "2"});
        final response = await _apiProvider.post(
            Appconstants.checkExistingUser, requestJson);
        if (response['d'] != null) {
          hideLoading();
        } else {
          hideLoading();
          showMessage(
              "This Number is already Register with Kisanserv Kindly use another Number");
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  /// store type info
  storeInfoId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "shopid": prefs.getString("com_id"),
          "WarehouseID": prefs.getString('ware_house'),
          "StoreLocation": prefs.getString('store_Location')
        });
        final response =
            await _apiProvider.post(Appconstants.checkStore, requestJson);
        if (response['d'] != null) {
          storeType = response['d'];
          print("StoreType $storeType");
          // print(response["d"]);
          print("response .......${response["d"]}");
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      showSnackBar(
          context: navigatorKey.currentContext!,
          content: "No Internet Connection Found. check your connection");
      print(e);
    }
  }

  sendOtp(String mobile, appid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "membermobileno": mobile,
          "ApplicationId": "KisanservStore",
          "appid": "2",
        });
        mno = mobile;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("mob_no", mobile);
        notifyListeners();
        final response =
            await _apiProvider.post(Appconstants.SEND_OTP, requestJson);
        hideLoading();
        return response["d"];
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobile = prefs.getString('mob_no')!;
    notifyListeners();
  }

  verifyOtp(String mobile, String otp, BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({"Mobilenonew": mobile, "votp": otp});
        final response =
            await _apiProvider.post(Appconstants.VERIFY_OTP, requestJson);
        if (response["d"] == null ||
            response["d"] == 'null' ||
            response['d'] == '') {
          hideLoading();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage(mobile)),
          );
        } else if (response["d"]['companyId'] == '0') {
          hideLoading();
          showMessage('Wrong OTP');
        } else if (response["d"] == 'false') {
          print("response .......${response["d"]}");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Approval()));
        } else {
          comid = response["d"]['companyId'];
          storeLocation = response['d']['StoreLocation'];
          wareHouse = response['d']['WarehouseID'];
          print("wareeeeeeeeeeeeeeeeeehouse $wareHouse");
          storeLocationName = response['d']['StoreLocationName'];
          userType = response['d']['UserType'];
          print("comid.......... $comid");
          print("response .......${response["d"]}");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("com_id", comid!);
          prefs.setString('userType', userType!);
          storeLocation != "0"
              ? prefs.setString("store_Location", storeLocation ?? "0")
              : prefs.setString('storeLocation', storeLocation ?? "0");
          wareHouse != "0"
              ? prefs.setString("ware_house", wareHouse ?? "0")
              : prefs.setString("wareHouse", wareHouse ?? "0");
          prefs.setString("storeLocationName", storeLocationName ?? "---");
          // print(
          //     "Store Location" + prefs.getString("store_Location").toString());
          // print("Ware House" + prefs.getString("ware_house").toString());
          await storeInfoId();
          await setIndex();
          if (storeType == "3") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Approval()),
                (route) => false);
          } else if (storeType == "5") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WareHouseMainPage()),
                (route) => false);
            // } else if (storeType == "") {
            //   Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(builder: (context) => OnScreenOrder()),
            //       (route) => false);
          } else if (storeLocation == "0" &&
              wareHouse == "0" &&
              userType == "2") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => CityList()),
                (route) => false);
          } else if (storeLocation == "0" &&
              wareHouse == "0" &&
              userType == "1") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StoreList()),
                (route) => false);
          } else {
            await getBanner();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OrderItemAccount()),
                (route) => false);
          }
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  getOTP() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson =
            jsonEncode({"Mobileno": prefs.getString("mob_no")});
        final response =
            await _apiProvider.post(Appconstants.GET_OTP, requestJson);
        OTP = response["d"];
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  register({
    lat,
    long,
    name,
    pincode,
    email,
    shopName,
    address1,
    address2,
    mapadress,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("lat" + lat);
    print("lng" + long);
    print("pincode" + pincode);
    print("shopName" + shopName);
    print("mobileNumber" + prefs.getString("mob_no").toString());
    print("locationId" + prefs.getString('LocationId').toString());
    print("mapAddress" + mapadress);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String requestJson = jsonEncode({
          "Company_Name": shopName.toString(),
          "ContpersonName": name != null ? name.toString() : "",
          "Email_id": email != null ? email.toString() : "",
          "Mobileno": prefs.getString("mob_no"),
          "Latitude": lat != null ? lat.toString() : "",
          "Longitude": long.toString(),
          "Pincode": pincode.toString(),
          "LocationId": prefs.getString('LocationId'),
          "Address1": address1 != null ? address1.toString() : "",
          "Address2": address2 != null ? address2.toString() : "",
          "mapaddress": mapadress != null ? mapadress.toString() : ""
        });
        final response = await _apiProvider.post(
            Appconstants.Register_Form_Store, requestJson);

        if (response["d"] != null || response["d"] != '') {
          hideLoading();
          prefs.setString("com_id", response["d"]);
          return 'success';
        } else {
          hideLoading();
          showMessage(response["Message"]);
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  checkpincode(pincode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"Pincode": pincode});
        final response =
            await _apiProvider.post(Appconstants.CHECK_PINCODE, requestJson);
        print('---------------pincode');
        print(response["d"]);
        return response["d"];
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  checkAvailablePincode(pincode) async {
    print('pincode is $pincode');
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"Pincode": pincode});
        showLoading();
        final response = await _apiProvider.post(
            Appconstants.CHECK_AVAILABLE_PINCODE, requestJson);
        print('---------------pincode location check ');
        print("pincode availability    ${response["d"]}");
        if (response["d"].length == 0) {
          hideLoading();
          showMessage('Pincode not available');

          return "0";
        } else {
          hideLoading();
          pincodes = PincodeModel.fromJson(response);

          notifyListeners();
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  assignAvailablePincode(pincode) async {
    print('pincode is $pincode');
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"Pincode": pincode});
        showLoading();
        final response = await _apiProvider.post(
            Appconstants.CHECK_AVAILABLE_PINCODE, requestJson);
        print('---------------pincode location check ');
        print("pincode availability    ${response["d"]}");
        if (response["d"].length == 0) {
          hideLoading();

          return "0";
        } else {
          hideLoading();
          pincodes = PincodeModel.fromJson(response);
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";

      print(e);
    }
  }

  CheckUserInfo(mobile, email) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode(
            {"UserName": mobile, "Email_Id": email, "mobileno": mobile});
        final response =
            await _apiProvider.post(Appconstants.CheckUserInfo, requestJson);
        print('---------------checkuserinfo');
        print("userInfo" + response["d"]);
        if (response['d'] == '3') {
          hideLoading();
          showMessage('Userid $mobile already exists. Please try another one');
        } else if (response['d'] == '4') {
          hideLoading();
          showMessage('Email already registered.Please try another one');
        } else if (response['d'] == '5') {
          hideLoading();
          showMessage(
              'Mobile number $mobile already registered. Please try another one');
        } else {
          hideLoading();
          return 'validUser';
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  loadState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"status": "5"});
        final response =
            await _apiProvider.post(Appconstants.LOAD_STATE, requestJson);
        print(response["d"]);
        state = LoadState.fromJson(response);
        notifyListeners();
        print(state);
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  loadlocation(String? cityid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({"status": "5", "City_Id": cityid});
        final response =
            await _apiProvider.post(Appconstants.LOAD_LOCATION, requestJson);
        print(response["d"]);
        loc = Loadlocation.fromJson(response);
        notifyListeners();
        print(loc);
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  getFcmToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      _fcmToken = value;
      print("fcm token  $_fcmToken");
    });
  }

  getOS() {
    if (Platform.isAndroid) {
      _os = 'Android';
    } else if (Platform.isIOS) {
      _os = 'IOS';
    }
    print('Os is $_os');
    return _os;
  }

  initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
      if (Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    _deviceId = deviceId;
    deviceName = deviceData["model"];
    brandName = deviceData["brand"] == null ? "" : deviceData["brand"];
    notifyListeners();
    return;
  }

  pushNotifications(String loginStatus) async {
    // if loginStatus == 1 its for login if loginStatus ==2 then it is for logout.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print("membershipno..." + prefs.getString("com_id").toString());
      print("WareHouse..." + prefs.getString("ware_house").toString());
      print("MobileNo..." + prefs.getString("mob_no").toString());
      print("device id..." + _deviceId.toString());
      print("fcm token..." + _fcmToken.toString());
      print("Os..." + _os.toString());
      print("loginstatus...." + loginStatus.toString());
      print("app version..." + prefs.getString("app_version").toString());
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String responseJson = jsonEncode({
          "membershipno": prefs.getString("ware_house").toString(),
          "MobileNo": prefs.getString("mob_no"),
          "MobiledevId": _deviceId,
          "fcmId": _fcmToken,
          "Os": _os == 'Android' ? "1" : "2",
          "appid": "2",
          "loginstatus": loginStatus,
          "appversion": prefs.getString("app_version"),
        });
        final response =
            await _apiProvider.post(Appconstants.Notification, responseJson);
        if (response != null) {}
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e.toString());
    }
  }

  setImage(_image) {
    image = _image;
    notifyListeners();
  }

  loadCities() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({"storetype": "1"});
        final response =
            await _apiProvider.post(Appconstants.cityList, requestJson);
        if (response['d'] != null) {
          cityList = CityLIstModel.fromJson(response);
          hideLoading();
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);

      notifyListeners();
    }
  }

  loadStores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson =
            jsonEncode({"CompanyId": prefs.getString("com_id")});
        final response =
            await _apiProvider.post(Appconstants.storesList, requestJson);
        if (response['d'] != null) {
          storesList = StoresListModel.fromJson(response);
          hideLoading();
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);

      notifyListeners();
    }
  }

  getStoreLocation(warehouseId, storeLocationNames) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ware_house", warehouseId);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String responseJson = jsonEncode({"warehouseId": warehouseId});
        final response = await _apiProvider.post(
            Appconstants.getStoreLocation, responseJson);
        if (response != null) {
          prefs.setString('store_Location', response['d']);
          prefs.setString('storeLocationName', storeLocationNames);
          storeLocationName = storeLocationNames;
          print(response['d']);
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e.toString());
      notifyListeners();
    }
  }

  getStoreLocationonStart(
    warehouseId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String responseJson = jsonEncode({"warehouseId": warehouseId});
        final response = await _apiProvider.post(
            Appconstants.getStoreLocation, responseJson);
        if (response != null) {
          prefs.setString('store_Location', response['d']);
          print("local store location ${prefs.getString('store_Location')}");
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      print(e.toString());
      notifyListeners();
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storeLocationName = prefs.getString('storeLocationName');
    storeLocation = prefs.getString('storeLocation');
    wareHouse = prefs.getString('wareHouse');
    city = prefs.getString('city_name');
    userType = prefs.getString('userType');
    await getOnlineStatus();

    notifyListeners();
  }

  setIndex() {
    currentIndex = storeType == "0" ? 2 : 0;
    selectedBarIndex = storeType == "0" ? 2 : 0;
    notifyListeners();
  }

  onTapped(index) {
    currentIndex = index;
    selectedBarIndex = index;
    notifyListeners();
  }

  Future<Null> getBanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson =
            jsonEncode({"storeid": prefs.getString("com_id"), "flashimg": "1"});
        final response =
            await _apiProvider.post(Appconstants.banner, requestJson);
        if (response != null && response['d'] != null) {
          banner = BannerModel.fromJson(response);
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      print(e);
    }
  }

  setOnlineStatus({String? status}) async {
    print("statussssss $status");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("mob_no");
    print(prefs.getString("mob_no"));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showLoading();
        String requestJson = jsonEncode({
          "Mobileno": prefs.getString("mob_no"),
          "warehouseID": prefs.getString('ware_house'),
          "status": status
        });
        final response = await _apiProvider.post(
            Appconstants.setNotificationStatus, requestJson);
        if (response != null && response["d"] != null) {
          await getOnlineStatus();
          hideLoading();
        } else {
          hideLoading();
          showMessage("Unable to Process request");
        }

        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  getOnlineStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("mob_no");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "MobileNo": prefs.getString("mob_no"),
          "WarehouseId": prefs.getString('ware_house'),
        });
        final response =
            await _apiProvider.post(Appconstants.getOnlineStatus, requestJson);
        if (response != null && response["d"] != null) {
          print("online STatus${response["d"]}");
          NotificatonStatus = response["d"];
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }

  void noInternet() {
    no_internet = false;
    print("no Internet");
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: Center(
                  child: AlertDialog(
                content: Material(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'images/logos/no-signal.png',
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Ooops!"),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "No Internet Connection Found",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text("check your connection",
                          style: TextStyle(fontSize: 14)),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kMainColor,
                              fixedSize: Size.fromWidth(100)),
                          onPressed: () {
                            no_internet = true;
                            Navigator.pop(context);
                          },
                          child: Text(
                            "ok",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
              )),
            ));
    notifyListeners();
  }

  getUserStatus(ctx) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("mob_no");

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String requestJson = jsonEncode({
          "MobileNo": prefs.getString("mob_no"),
          "warehouse_id": prefs.getString('ware_house'),
        });
        final response =
            await _apiProvider.post(Appconstants.checkUserStatus, requestJson);
        if (response != null && response["d"] != null) {
          if (response['d'] == "0") {
            await prefs.clear();
            Navigator.pushAndRemoveUntil(
                ctx,
                MaterialPageRoute(builder: (context) => PhoneNumber()),
                (route) => false);
          }
        }
        notifyListeners();
      }
    } on SocketException catch (e) {
      no_internet == true ? noInternet() : "";
      print(e);
    }
  }
}
