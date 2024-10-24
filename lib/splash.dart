import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:delivoo_stores/Auth/MobileNumber/UI/phone_number.dart';
import 'package:delivoo_stores/OrderItemAccount/order_item_account.dart';
import 'package:delivoo_stores/Pages/approval.dart';
import 'package:delivoo_stores/Pages/cityList.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/warehouseRTV/warehouse_mainpage.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/GlobalService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/storeList.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  GlobalService globalService = GlobalService();
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var comid = prefs.getString('com_id');
    var mobile = prefs.getString('mob_no');
    var userType = prefs.getString('userType');
    // var onvalue = prefs.getString('skippedOnboard');
    var wareHouse = await prefs.getString('ware_house');
    print("mobile number ${prefs.getString('mob_no')}");
    print("company number ${prefs.getString('com_id')}");
    await context.read<LoginProvider>().getStoreLocationonStart(wareHouse);
    var storeLocation = prefs.getString('store_Location');

    await context.read<LoginProvider>().getFcmToken();
    await context.read<LoginProvider>().getOS();
    await context.read<LoginProvider>().initPlatformState();
    if (!globalService.hasLaunched) {
      if (comid != null && mobile != null && mobile != "") {
        print(comid + '-------' + mobile);
        await context.read<LoginProvider>().storeInfoId();
        await context.read<LoginProvider>().setIndex();
        await context.read<LoginProvider>().getBanner();

        Timer(
            Duration(seconds: 1),
            () => context.read<LoginProvider>().storeType == "3"
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Approval()),
                    (route) => false)
                : context.read<LoginProvider>().storeType == "4"
                    ? Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => PhoneNumber()),
                        (route) => false)
                    : context.read<LoginProvider>().storeType == "5"
                        ? Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WareHouseMainPage()),
                            (route) => false)
                        : storeLocation == "0" &&
                                wareHouse == null &&
                                userType == "2"
                            ? Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CityList()),
                                (route) => false)
                            : storeLocation == "0" &&
                                    wareHouse == null &&
                                    userType == "1"
                                ? Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoreList()),
                                    (route) => false)
                                : Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrderItemAccount()),
                                    (route) => false));
      } else if (comid != null && mobile == "") {
        // await context.read<LoginProvider>().storeInfoId();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Approval()),
            (route) => false);
      } else /* if (comid == null) */ {
        Timer(
            Duration(seconds: 2),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PhoneNumber())));
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300), () {
      getData();
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => WareHouseMainPage()),
      //     (route) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: AvatarGlow(
                glowColor: kMainColor,
                endRadius: 120.0,
                duration: Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/logos/alphastore_icon.png',
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("A Product Of",
                    style: TextStyle(fontSize: 12, color: Colors.black)),
                Image.asset(
                  'images/logos/Kisanserv.png',
                  height: 100,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
