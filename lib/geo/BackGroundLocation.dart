import 'package:background_location/background_location.dart';
import 'package:flutter/cupertino.dart';

class BackGroundLocationServiceProvider extends ChangeNotifier {
  Future<dynamic> handleBackGroundLocation() async {
    await BackgroundLocation.setAndroidNotification(
      title: 'Kisanserv is Assesing your Location',
      message: 'sharing current location',
      icon: '@mipmap/ic_launcher',
    );
    //await BackgroundLocation.setAndroidConfiguration(1000);
    await BackgroundLocation.startLocationService();
    BackgroundLocation.getLocationUpdates((location) {
      print("background fetch${location.latitude}");
      print("bg${location.longitude}");
    });
  }

  void stopService() async {
    await BackgroundLocation.stopLocationService();
  }
}
