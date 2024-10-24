// ignore_for_file: deprecated_member_use

library commonwidgets;

import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';

import 'package:place_picker/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

showLoading() {
  return showDialog(
      context: navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) => Center(
              child: Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(8),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: kMainColor,
            ),
          )));
}

void hideLoading() {
  Navigator.pop(navigatorKey.currentState!.context);
}

void showMessage(String message) {
  showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Center(
              child: AlertDialog(
            content: Material(
              color: Colors.white10,
              child: Text(
                message,
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kMainColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )));
}

// void noInternet() {
//   showDialog(
//       context: navigatorKey.currentContext!,
//       builder: (context) => Center(
//               child: AlertDialog(
//             content: Material(
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset(
//                     'images/logos/no-signal.png',
//                     height: 100,
//                     width: 100,
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text("Ooops!"),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "No Internet Connection Found",
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text("check your connection", style: TextStyle(fontSize: 14)),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           primary: kMainColor, fixedSize: Size.fromWidth(100)),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text("ok"))
//                 ],
//               ),
//             ),
//           )));
// }

showMessageDialog(context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => new AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        message,
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kMainColor),
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
        ),
      ],
    ),
  );
}

void showAlertMessage({String? title, message1, message2}) {
  showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Center(
              child: AlertDialog(
            title: Text(title!),
            content: Material(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message1,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    message2,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kMainColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          )));
}

Future<dynamic> errorDialog(context, String msg) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Alert !",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                          color: kMainColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text("OK",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                  )
                ],
              )),
        );
      });
}

var dateFormat = new DateFormat('dd-MM-yyyy');
var timeFormat = new DateFormat('hh:mm a');

DateTime? currentBackPressTime;
Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(
        msg: "Press again to exit",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        fontSize: 14.0);
    return Future.value(false);
  }
  return Future.value(true);
}

// callAlertScreen() async {
//   CallEvent callEvent = CallEvent(
//       sessionId: DateTime.now().toString(),
//       callType: 4,
//       callerId: 2,
//       callerName: 'KisanServ',
//       opponentsIds: {1, 3},
//       userInfo: {'KisanServ': 'notification'});
//   ConnectycubeFlutterCallKit.showCallNotification(callEvent);
//   ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);
//   ConnectycubeFlutterCallKit.initEventsHandler();
// }

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kMainColor,
      duration: Duration(seconds: 5),
      content: Text(
        content,
        textAlign: TextAlign.center,
      )));
}

clearCache() {
  return DefaultCacheManager().emptyCache();
}

banner(img) {
  return showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) => Material(
            color: Colors.white.withOpacity(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                      BaseUrl + "banners/" + img,
                    )),
                  ),
                  child: Stack(
                    children: [
                      PositionedDirectional(
                          top: 20,
                          end: 15,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel,
                                size: 40,
                                color: Colors.black,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ));
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

Future<void> showCallkitIncoming() async {
  var params = <String, dynamic>{
    'id': Uuid().generateV4(),
    'nameCaller': 'KisanServ',
    'appName': 'Callkit',
    'avatar': BaseUrl + 'img/' + 'android-chrome-192x192.png',
    'handle': '',
    'type': 0,
    'duration': 30000,
    'textAccept': 'Accept',
    'textDecline': 'Decline',
    'textMissedCall': 'Missed call',
    'textCallback': 'Call back',
    'extra': <String, dynamic>{'userId': 'Kisanserv'},
    'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    'android': <String, dynamic>{
      'isCustomNotification': true,
      'isShowLogo': false,
      'isShowCallback': false,
      'ringtonePath': 'system_ringtone_default',
      'backgroundColor': '#000000',
      'backgroundUrl': BaseUrl + 'img/' + 'Notification_bg_banner.JPG',
      'actionColor': '#4CAF50'
    },
    'ios': <String, dynamic>{
      'iconName': 'CallKitLogo',
      'handleType': '',
      'supportsVideo': true,
      'maximumCallGroups': 2,
      'maximumCallsPerCallGroup': 1,
      'audioSessionMode': 'default',
      'audioSessionActive': true,
      'audioSessionPreferredSampleRate': 44100.0,
      'audioSessionPreferredIOBufferDuration': 0.005,
      'supportsDTMF': true,
      'supportsHolding': true,
      'supportsGrouping': false,
      'supportsUngrouping': false,
      'ringtonePath': 'system_ringtone_default'
    }
  };
  await FlutterCallkitIncoming.showCallkitIncoming(
      CallKitParams.fromJson(params));
}

notification_warning(SharedPreferences prefs) async {
  showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("Allow Notification Sound"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '"Allow Notification and Sound" from app Settings to receive notifications and notification sound.')
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  textStyle: TextStyle(color: kWhiteColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.redAccent)),
                ),
                onPressed: () async {
                  await prefs.setString('skipNotification', 'true');
                  Navigator.pop(context);
                }),
            SizedBox(width: 5),
            ElevatedButton(
                child: Text("Open Settings"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(color: kWhiteColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green)),
                ),
                onPressed: () async {
                  await prefs.setString('skipNotification', 'true');
                  AppSettings.openNotificationSettings()
                      .whenComplete(() => Navigator.pop(context));
                })
          ],
        );
      });
}

urlLauncher({String? url, scheme}) async {
  try {
    await launchUrl(
      Uri(scheme: scheme, path: url),
    );
  } on Exception {
    throw 'Could not launch $url';
  }
}

Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
    'displaySizeInches':
        ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
    'displayWidthPixels': build.displayMetrics.widthPx,
    'displayWidthInches': build.displayMetrics.widthInches,
    'displayHeightPixels': build.displayMetrics.heightPx,
    'displayHeightInches': build.displayMetrics.heightInches,
    'displayXDpi': build.displayMetrics.xDpi,
    'displayYDpi': build.displayMetrics.yDpi,
  };
}

checkVersion(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final newVersion = NewVersion(
    androidId: "com.kisanserv.stores",
    iOSId: "com.kisanserv.store",
  );

  final status = await newVersion.getVersionStatus();
  print(status?.storeVersion);

  if (status!.localVersion.toString() != status.storeVersion.toString()) {
    // await updateApp();
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: "New Update Available!!!",
      dismissButtonText: "Maybe Later ",
      dialogText: "Updated version of the App is available. Please download",
      // allowDismissal: false,
      dismissAction: () {
        Navigator.pop(context);
      },
      updateButtonText: "Update",
    );
  }

  print("Device:" + status.localVersion.toString());
  print("Store:" + status.storeVersion.toString());
  prefs.setString('app_version', status.localVersion.toString());
}

// Future<dynamic> updateApp() {
//   return showDialog(
//       context: navigatorKey.currentContext!,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10.0))),
//           title: Text("New Update Available!!!"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Updated version of the App is available. Please download")
//             ],
//           ),
//           actions: <Widget>[
//             ElevatedButton(
//                 child: Text("Maybe Later"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   textStyle: TextStyle(color: kWhiteColor),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Colors.redAccent)),
//                 ),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                 }),
//             SizedBox(width: 5),
//             ElevatedButton(
//                 child: Text("Update"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   textStyle: TextStyle(color: kWhiteColor),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Colors.green)),
//                 ),
//                 onPressed: () async {
//                   if (Platform.isAndroid || Platform.isIOS) {
//                     final appId = Platform.isAndroid
//                         ? "com.kisanserv.stores"
//                         : "com.kisanserv.store";
//                     final url = Uri.parse(
//                       Platform.isAndroid
//                           ? "https://play.google.com/store/apps/details?id=$appId"
//                           : "https://apps.apple.com/app/id$appId",
//                     );
//                     launchUrl(
//                       url,
//                       mode: LaunchMode.externalApplication,
//                     ).whenComplete(() => Navigator.pop(context));
//                   }
//                 })
//           ],
//         );
//       });
// }

void navigateToMap(double lat, double lng) async {
  var uri = Uri.parse(Platform.isAndroid
      ? "https://www.google.com/maps/search/?api=1&query=$lat,$lng"
      : "maps:q=$lat,$lng&mode=d");
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Exception {
    throw 'Could not launch $uri';
  }
}
