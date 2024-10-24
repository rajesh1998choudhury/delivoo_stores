//import 'dart:convert';
import 'package:delivoo_stores/JsonFiles/Support/support_json.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  final url = 'http://opuslabs.in:9502/api';

  Future<Null> support(String name, String email, String message) async {
    Support support = Support(name: name, email: email, message: message);
    http.Response response = await http.post(Uri.parse(url + '/support'),
        headers: {'Accept': 'application/json'}, body: support.toJson());
    if (response.statusCode != 201) throw Exception();
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token')!;
  }
}
