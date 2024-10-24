// ignore_for_file: deprecated_member_use

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo_stores/Auth/MobileNumber/UI/mobile_input.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

//first page that takes phone number as input for verification
class PhoneNumber extends StatefulWidget {
  static const String id = 'phone_number';

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () async {
      var status = await Permission.sms.status;

      print(status.toString());
      if (status != PermissionStatus.granted) {
        Permission.sms.request();
      }
      // Permission.sms.request();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadedSlideAnimation(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Image.asset("images/logos/kisanserv.gif"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: MobileInput(),
            ),
            SizedBox(
              height: 150,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Using the App indicates ",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () async {
                    final url = Uri.parse(
                        'https://www.kisanserv.com/termsandconditionsnew.aspx');
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Text(
                      "Acceptance of Terms and Conditions & Terms of Service",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
