import 'package:delivoo_stores/StoreOrdering/Pages/warehouseRTV/warehouse_rtv.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Auth/MobileNumber/UI/phone_number.dart';
import '../../../Provider/login_provider.dart';
import '../../../Utils/CommonWidget.dart';
import '../../StoreOrderingProvider/StoreOrderingProvider.dart';

class WareHouseMainPage extends StatefulWidget {
  const WareHouseMainPage({super.key});

  @override
  State<WareHouseMainPage> createState() => _WareHouseMainPageState();
}

class _WareHouseMainPageState extends State<WareHouseMainPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await checkVersion(context);
      await context.read<LoginProvider>().pushNotifications("1");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Warehouse',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Logging Out',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Are you sure?',
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                // textStyle: TextStyle(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.green)),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  // textStyle: TextStyle(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Colors.redAccent)),
                                ),
                                onPressed: () async {
                                  await context
                                      .read<LoginProvider>()
                                      .pushNotifications("2");
                                  SharedPreferences _prefs =
                                      await SharedPreferences.getInstance();
                                  await _prefs.clear();
                                  await _prefs.setString(
                                      'skipNotification', 'true');
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PhoneNumber()),
                                      (route) => false);
                                })
                          ],
                        );
                      });
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ))
          ],
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  var res = await context
                      .read<StoreOrderProvider>()
                      .getWarehouseUserDetails();
                  res == 'success'
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReturnWarehouseItemsPage()))
                      : "";
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: kMainColor,
                      border: Border.all(color: kWhiteColor),
                      borderRadius: BorderRadius.circular(10)),
                  height: 100,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "WareHouse RTV",
                      style: TextStyle(color: kWhiteColor),
                    ),
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Coming Soon",
                    style: TextStyle(color: kWhiteColor),
                  )),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
