import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:delivoo_stores/Utils/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ApiProvider {
  String? _baseUrl = BaseUrl;
  Cookie? cook;

  //prefs
  getToken() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("token");
  }

  getCookie() async {
    var res;
    print(_baseUrl! + GET_COOKIES + '--------api');

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http.post(Uri.parse(_baseUrl! + GET_COOKIES),
            body: jsonEncode({"cmemno": "4"}),
            headers: {
              //"Authorization": token,
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            });
        print(response.body.toString() + '----------response');
        res = json.decode(response.body)["d"]["Cookieslist"];
        print('res = ' + res);
        // print(json.decode(json.decode(response.body)["d"]["Cookieslist"]));
        // responseJson = _response(response, GET_COOKIES);
      }
    } on SocketException {}
    return res;
  }

  //Social Auth get
  Future<dynamic> authPost(
    String url,
    String username,
    String password,
    var requstjson,
  ) async {
    var responseJson = {};
    try {
      print('Calling $_baseUrl $url');
      showLoading();
      final response = await http
          .post(
              Uri.parse(
                _baseUrl! + url,
              ),
              headers: {
                'authorization': 'Basic ' +
                    base64.encode(utf8.encode('$username:$password')),
                "Content-Type": "application/json",
              },
              body: requstjson)
          .timeout(
            Duration(seconds: 30),
          )
          .onError((error, stackTrace) {
        hideLoading();
        showSnackBar(
            context: navigatorKey.currentContext!,
            content: "No Internet Connection Found. check your connection");
        throw error.toString();
      });
      print('reposne = ' + response.statusCode.toString());
      responseJson = _response(response, url);
    } on SocketException {
      hideLoading();
      showMessage('Error While Communicating With Server');
      //throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  //Social Auth get
  Future<dynamic> authGet(
    String url,
    String username,
    String password,
  ) async {
    var responseJson;
    try {
      print('Calling $url');

      final response = await http
          .get(
            Uri.parse(
              url,
            ),
            headers: {
              'authorization':
                  'Basic ' + base64.encode(utf8.encode('$username:$password')),
              "Content-Type": "application/json",
            },
          )
          .timeout(
            Duration(seconds: 30),
          )
          .onError((error, stackTrace) {
            showSnackBar(
                context: navigatorKey.currentContext!,
                content: "No Internet Connection Found. check your connection");
            throw error.toString();
          });
      print('reposne = ' + response.statusCode.toString());
      responseJson = _response(response, url);
    } on Exception {
      //throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  //future get
  Future<dynamic> get(String url) async {
    var responseJson;
    String token = await getToken();
    try {
      //showLoading();
      final response = await http
          .get(Uri.parse(_baseUrl! + url), headers: {
            "Authorization": token,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Cache-Control': 'no-cache',
          })
          .timeout(Duration(seconds: 30))
          .onError((error, stackTrace) {
            hideLoading();
            throw error.toString();
          });
      responseJson = _response(response, url);
      print(_baseUrl! + url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  //delete
  Future<dynamic> delete(String url) async {
    var responseJson;
    String token = await getToken();
    try {
      //showLoading();
      final response = await http
          .delete(Uri.parse(_baseUrl! + url), headers: {
            "Authorization": token,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          })
          .timeout(Duration(seconds: 30))
          .onError((error, stackTrace) {
            hideLoading();
            throw error.toString();
          });
      responseJson = _response(response, url);
      print(_baseUrl! + url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  //future post
  Future<dynamic> post(String url, requestJson) async {
    var responseJson;
    try {
      // var cookie = await getCookie();

      // print('cookie value ' + cookie.toString());

      print(_baseUrl! + url + '--------api');
      final response = await http
          .post(Uri.parse(_baseUrl! + url), body: requestJson, headers: {
            //"Authorization": token,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Cookie': cookie.toString()
          })
          .timeout(
            Duration(seconds: 30),
          )
          .onError((error, stackTrace) {
            showSnackBar(
                context: navigatorKey.currentContext!,
                content: "No Internet Connection Found. check your connection");

            throw error.toString();
          });

      print('response of api  = ' + response.statusCode.toString());
      responseJson = _response(response, url);
    } on Exception catch (e) {
      print(e);
    }
    return responseJson;
  }

  //future put
  Future<dynamic> put(String url, requestJson) async {
    var responseJson;
    String token = await getToken();
    print(_baseUrl! + url);
    try {
      final response = await http
          .put(Uri.parse(_baseUrl! + url), body: requestJson, headers: {
        "Authorization": token,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      responseJson = _response(response, url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
      //throw showMessage('No Internet connection') as  Void;
    }
    return responseJson;
  }

  Future<dynamic> putImage(String url, image) async {
    String token = await getToken();
    print(_baseUrl! + url);

    var request =
        new http.MultipartRequest("PUT", (Uri.parse(_baseUrl! + url)));
    var pic = await http.MultipartFile.fromPath("files", image.path);
    request.files.add(pic);
    request.headers["Authorization"] = token;
    var response = await request.send();
    return response;
  }

  dynamic _response(http.Response response, String url) async {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(utf8.decode(response.bodyBytes));
        print(responseJson.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        hideLoading();
        showMessage(response.body.toString());
        break;
      case 403:
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.clear();
        throw UnauthorisedException(response.body.toString());

      case 404:
      case 500:
        showMessage('Internal Server error');
        break;
      default:
        showMessage('Some error occured');
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode} in url : $url');
    }
  }
}

void onError(error) {
  return showMessage('');
}
