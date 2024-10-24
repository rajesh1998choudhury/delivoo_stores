// ignore_for_file: deprecated_member_use

import 'package:delivoo_stores/Components/loading_shimmer.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/store_category_page.dart';
import 'package:delivoo_stores/StoreOrdering/StoreOrderingProvider/storeOrdering_category_provider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class StoreCategoryMainPage extends StatefulWidget {
  StoreCategoryMainPage({Key? key}) : super(key: key);

  @override
  State<StoreCategoryMainPage> createState() => _StoreCategoryMainPageState();
}

class _StoreCategoryMainPageState extends State<StoreCategoryMainPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await context.read<LoginProvider>().getUserStatus(context);
      await context.read<StoreOrderingCategoryProvider>().getCategory();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        context.watch<StoreOrderingCategoryProvider>().categories?.d;

    context.watch<StoreOrderingCategoryProvider>().subcategories?.d;

    return WillPopScope(
      onWillPop: context.read<LoginProvider>().storeType == "1" ||
              context.read<LoginProvider>().storeType == "2"
          ? () {
              context.read<LoginProvider>().onTapped(0);
              return Future.value(false);
            }
          : () {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      Duration(seconds: 2)) {
                currentBackPressTime = now;
                Fluttertoast.showToast(
                    msg: "Press again to exit",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    fontSize: 14.0);
                return Future.value(false);
              }
              ;
              return Future.value(true);
            },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Store Ordering Category',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        body: context.read<StoreOrderingCategoryProvider>().Loading
            ? LoadingShimmer()
            : categories?.length == null || categories?.length == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No Category Found"),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          kMainColor)),
                              onPressed: () async {
                                showLoading();
                                await context
                                    .read<StoreOrderingCategoryProvider>()
                                    .getCategory();
                                hideLoading();
                              },
                              icon: Icon(Icons.refresh, color: Colors.white),
                              label: Text("Click to Refresh",
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: kMainColor,
                    onRefresh: () async {
                      await context
                          .read<StoreOrderingCategoryProvider>()
                          .getCategory();
                    },
                    child: Container(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  await context
                                      .read<StoreOrderingCategoryProvider>()
                                      .getCategory();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoreCategoryPage(),
                                    ),
                                  );
                                  // Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kMainColor,
                                      border: Border.all(color: kWhiteColor),
                                      borderRadius: BorderRadius.circular(10)),
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.1,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Normal Order",
                                      style: TextStyle(color: kWhiteColor),
                                    ),
                                  )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  await context
                                      .read<StoreOrderingCategoryProvider>()
                                      .getCategory();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoreCategoryPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kMainColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      "Direct Supplier Order",
                                      style: TextStyle(color: kWhiteColor),
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ),
      ),
    );
  }
}
