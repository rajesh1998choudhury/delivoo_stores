// ignore_for_file: unnecessary_null_comparison

import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:place_picker/place_picker.dart';
import 'package:delivoo_stores/geo/map_picker.dart' as placePicker;

class LocationServiceProvider extends ChangeNotifier {
  Location location = new Location();
  bool? _serviceEnabled;
  bool _loading = true;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  LocationResult? locationResult;
  var _timeCalculate;
  var _formattedAddress;

  get getLocationData => locationResult;
  get getTimeCalculate => _timeCalculate;
  get getAddress => _formattedAddress;

  bool? get serviceEnabled => _serviceEnabled;
  bool get isLoading => _loading;
  String? address;

  getLocationAccess() async {
    try {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      } else if (_permissionGranted == PermissionStatus.granted) {
        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled!) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled!) {
            return;
          }
        }
        locationData = await location.getLocation();

        _loading = false;
        notifyListeners();
      }
    } on Exception catch (e) {
      _loading = false;
      print(e);
    }
    //location.enableBackgroundMode(enable: true);
  }

  Future<dynamic> getContinuousCallBack() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    } else if (_permissionGranted == PermissionStatus.granted) {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled!) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled!) {
          return;
        }
      }
    }
  }

  showPlacePicker(context) async {
    LocationResult result =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return placePicker.PlacePicker(GoogleApiKey);
    }));
    if (result != null) {
      locationResult = result;
      _formattedAddress = result.formattedAddress;
      print(locationResult);
      print('llllllllllatitude${result.latLng?.latitude}');
      print('llllllllllongitude${result.latLng?.longitude}');
      print(_formattedAddress);
      notifyListeners();
      return _formattedAddress;
    }
  }

  /*  timeCalulate(dlat, dlon) async {
    try {
      Dio dio = new Dio();
      Response response = await dio.get(GoogleDistCal +
          "${locationData!.latitude},${locationData!.longitude}&destinations=$dlat,$dlon&key=$GoogleApiKey");
      // ignore: unnecessary_null_comparison
      if (response != null) {
        _timeCalculate = ((response.data['rows'][0]['elements'][0]['duration']
                    ['value']) /
                60)
            .floor()
            .toInt();
      }
      notifyListeners();
    } on Exception catch (e) {
      notifyListeners();
      print(e);
    }
  } */

  // void fetchAdddress(double lat, double lng) async {
  //   try {
  //     Dio dio = new Dio();
  //     Response response = await dio.get(
  //         FetchAddress + "?key=$GoogleApiKey&language=en&latlng=$lat,$lng");
  //     // ignore: unnecessary_null_comparison
  //     if (response != null) {
  //       _formattedAddress = response.data["results"][0]["formatted_address"];
  //       print("response ==== $_formattedAddress");
  //       notifyListeners();
  //     }
  //   } on Exception catch (e) {
  //     notifyListeners();
  //     print(e);
  //   }
  // }

  getLatitude() {
    if (locationResult != null) {
      return locationResult?.latLng?.latitude;
    } else if (locationData != null && locationData!.latitude != null) {
      return locationData!.latitude;
    }
  }

  getLongitude() {
    if (locationResult != null) {
      return locationResult?.latLng?.longitude;
    } else if (locationData != null && locationData!.longitude != null) {
      return locationData!.longitude;
    }
  }
}
