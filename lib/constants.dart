import 'package:shared_preferences/shared_preferences.dart';

String? currencyIcon;
String? terms;
String? aboutUs;
String? privacyPolicy;
String? taxInPercent;
String? deliveryFee;
void settings() async {
  final prefs = await SharedPreferences.getInstance();
  currencyIcon = prefs.getString('currencyIcon');
  terms = prefs.getString('terms');
  aboutUs = prefs.getString('aboutUs');
  privacyPolicy = prefs.getString('privacyPolicy');
  taxInPercent = prefs.getString('taxInPercent');
  deliveryFee = prefs.getString('deliveryFee');
}
