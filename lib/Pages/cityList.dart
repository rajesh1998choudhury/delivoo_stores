import 'package:delivoo_stores/Pages/storeList.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Themes/colors.dart';

class CityList extends StatefulWidget {
  CityList({Key? key}) : super(key: key);

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  @override
  void initState() {
    context.read<LoginProvider>().loadCities();
    super.initState();
  }

  var wareHouse;

  @override
  Widget build(BuildContext context) {
    final cityList = context.watch<LoginProvider>().cityList?.d;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Select City",
        style: TextStyle(fontSize: 16, color: Colors.white),
      )),
      body: Container(
        child: Scrollbar(
          thickness: 10,
          thumbVisibility: true,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cityList?.length ?? 0,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString(
                              "com_id", cityList[index].companyId);
                          await prefs.setString(
                              'city_name', cityList[index].cityName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoreList()),
                          );
                        },
                        leading: Image.asset(
                          'images/account/city.png',
                          height: 50.3,
                        ),
                        title: Text(cityList![index].cityName,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 15,
                                    color: kMainColor,
                                    fontWeight: FontWeight.w500)),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cityList[index].companyName.toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 6.0,
                      ),
                    ],
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    bottom: 5,
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: context.watch<LoginProvider>().city ==
                                cityList[index].cityName
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: Center(
                                    child: Icon(Icons.check_rounded,
                                        color: kTransparentColor)),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
