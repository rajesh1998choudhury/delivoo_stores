import 'package:avatar_glow/avatar_glow.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/MobileNumber/UI/phone_number.dart';
import '../Provider/login_provider.dart';

class Approval extends StatefulWidget {
  const Approval({Key? key}) : super(key: key);

  @override
  State<Approval> createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  checkAprroved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("mob_no", "");
    await context.read<LoginProvider>().storeInfoId();
    if (context.read<LoginProvider>().storeType != "3" &&
        context.read<LoginProvider>().storeType != "4" &&
        context.read<LoginProvider>().storeType != "5") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PhoneNumber()),
          (route) => false);
    }
  }

  @override
  void initState() {
    checkAprroved();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarGlow(
            glowColor: kMainColor,
            endRadius: 90.0,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            child: Image.asset(
              'images/logos/alphastore_icon.png',
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Company Registered but Approval Pending.\n \n WhatsApp Customer Care at \n +91 7391054201',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: kMainColor),
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();
                _prefs.clear();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => PhoneNumber()),
                    (route) => false);
              },
              icon: Icon(Icons.logout),
              label: Text("Back"))
        ],
      ),
    );
  }
}
