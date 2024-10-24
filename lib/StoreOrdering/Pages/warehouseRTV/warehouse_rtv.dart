// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/warehouseRTV/wareahouse_rtv_search.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/AppConstants.dart';
import '../../StoreOrderingProvider/StoreOrderingProvider.dart';
import '../MyOrders/storeItemsAcceptanace.dart';

class ReturnWarehouseItemsPage extends StatefulWidget {
  const ReturnWarehouseItemsPage({Key? key}) : super(key: key);

  @override
  State<ReturnWarehouseItemsPage> createState() =>
      _ReturnWarehouseItemsPageState();
}

class _ReturnWarehouseItemsPageState extends State<ReturnWarehouseItemsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedOrder =
        context.watch<StoreOrderProvider>().warehouseReturnItem?.d;
    return WillPopScope(
      onWillPop: () async {
        context.read<StoreOrderProvider>().warehouseReturnItem?.d = [];
        context.read<StoreOrderProvider>().dateValue = DateTime.now();
        await context.read<StoreOrderProvider>().checkQr(false);
        await context.read<StoreOrderProvider>().checkAllItems(false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('new_comp_id', "0");
        context.read<StoreOrderProvider>().companyName = "";
        context.read<StoreOrderProvider>().storeName = "";
        context.read<StoreOrderProvider>().query = "";
        context.read<StoreOrderProvider>().selectedWarehouse = "0";
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            context
                        .read<StoreOrderProvider>()
                        .warehouseUserDetails!
                        .d
                        .warehouseName !=
                    null
                ? ' ${context.read<StoreOrderProvider>().warehouseUserDetails!.d.warehouseName} Warehouse RTV'
                : "Warehouse RTV Receive",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await context
                                .read<StoreOrderProvider>()
                                .getWarehouseCompany();
                            showModalBottomSheet(
                                isDismissible: false,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  final scrollController =
                                      ScrollController(initialScrollOffset: 0);
                                  return Container(
                                    decoration: BoxDecoration(
                                      // color: kCardBackgroundColor,
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    child: ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            // color: kCardBackgroundColor,
                                            color: kMainColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Select Company",
                                                  style: TextStyle(
                                                      color: kWhiteColor,
                                                      fontSize: 14),
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Icon(
                                                    Icons.cancel,
                                                    size: 22,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Scrollbar(
                                          thumbVisibility: true,
                                          controller: scrollController,
                                          thickness: 8,
                                          trackVisibility: true,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.60,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 100),
                                              child: ListView.builder(
                                                  controller: scrollController,
                                                  shrinkWrap: true,
                                                  itemCount: context
                                                      .read<
                                                          StoreOrderProvider>()
                                                      .warehouseCompany
                                                      ?.d
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var company = context
                                                        .watch<
                                                            StoreOrderProvider>()
                                                        .warehouseCompany
                                                        ?.d[index];
                                                    return Stack(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                SharedPreferences
                                                                    prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                prefs.setString(
                                                                    'new_comp_id',
                                                                    company
                                                                        .compId);
                                                                context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .storeName = "";
                                                                await context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .selectedCompanyName(
                                                                        company
                                                                            .compName);
                                                                context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .selectedWarehouse = "0";
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: SizedBox(
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .store,
                                                                          color:
                                                                              kMainColor,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.80,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(company!.compName.toString(),
                                                                                  overflow: TextOverflow.clip,
                                                                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                                        fontSize: 14,
                                                                                      )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 3,
                                                              color:
                                                                  kCardBackgroundColor,
                                                            ),
                                                          ],
                                                        ),
                                                        Positioned(
                                                          top: 4,
                                                          right: 4,
                                                          bottom: 5,
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: context
                                                                          .watch<
                                                                              StoreOrderProvider>()
                                                                          .companyName ==
                                                                      company
                                                                          .compName
                                                                  ? Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      child: Center(
                                                                          child: Icon(
                                                                              Icons.check_rounded,
                                                                              color: kTransparentColor)),
                                                                    )
                                                                  : null,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: searchDesign(
                              colors: Colors.white,
                              text: context
                                          .watch<StoreOrderProvider>()
                                          .companyName !=
                                      ""
                                  ? context
                                      .read<StoreOrderProvider>()
                                      .companyName
                                  : "--- Select Company ---",
                              icon: Icons.keyboard_arrow_down_sharp,
                              iconSize: 15.0,
                              width: MediaQuery.of(context).size.width * 0.95,
                              textboxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Select Company",
                          style: TextStyle(fontSize: 12, color: kWhiteColor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await context
                                        .read<StoreOrderProvider>()
                                        .checkQr(false);
                                    await context
                                        .read<StoreOrderProvider>()
                                        .checkAllItems(false);
                                    showDatePicker(
                                        context: context,
                                        initialEntryMode:
                                            DatePickerEntryMode.calendarOnly,
                                        initialDate: context
                                            .read<StoreOrderProvider>()
                                            .dateValue,
                                        firstDate: DateTime.now()
                                            .subtract(Duration(days: 60)),
                                        lastDate: DateTime.now(),
                                        builder: (BuildContext context, child) {
                                          return Theme(
                                              data: Theme.of(context).copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                          primary: kMainColor,
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              kMainColor)),
                                              child: child!);
                                        }).then((value) async {
                                      if (value != null) {
                                        await context
                                            .read<StoreOrderProvider>()
                                            .notifyDate(value);
                                      }
                                    });
                                  },
                                  child: searchDesign(
                                    colors: Colors.white,
                                    text: context
                                                    .watch<StoreOrderProvider>()
                                                    .dateValue !=
                                                null &&
                                            context
                                                    .watch<StoreOrderProvider>()
                                                    .dateValue !=
                                                ""
                                        ? DateFormat('dd/MM/yyyy').format(
                                            context
                                                .watch<StoreOrderProvider>()
                                                .dateValue)
                                        : "Select Date",
                                    icon: Icons.date_range,
                                    iconSize: 20.0,
                                    width: MediaQuery.of(context).size.width *
                                        0.34,
                                    textboxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.23,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Receive Date",
                                  style: TextStyle(
                                      fontSize: 12, color: kWhiteColor),
                                )
                              ],
                            ),
                            context.read<StoreOrderProvider>().companyName == ""
                                ? SizedBox.shrink()
                                : Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await context
                                              .read<StoreOrderProvider>()
                                              .getWarehouseStore();
                                          showModalBottomSheet(
                                              isDismissible: false,
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                final scrollController =
                                                    ScrollController(
                                                        initialScrollOffset: 0);
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    // color: kCardBackgroundColor,
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.50,
                                                  child: ListView(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: kCardBackgroundColor,
                                                          color: kMainColor,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Select Store",
                                                                style: TextStyle(
                                                                    color:
                                                                        kWhiteColor,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              Spacer(),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Icon(
                                                                  Icons.cancel,
                                                                  size: 22,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Scrollbar(
                                                        thumbVisibility: true,
                                                        controller:
                                                            scrollController,
                                                        thickness: 8,
                                                        trackVisibility: true,
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.60,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 8,
                                                                    bottom:
                                                                        100),
                                                            child: ListView
                                                                .builder(
                                                                    controller:
                                                                        scrollController,
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: context
                                                                        .read<
                                                                            StoreOrderProvider>()
                                                                        .warehouseStores
                                                                        ?.d
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      var store = context
                                                                          .watch<
                                                                              StoreOrderProvider>()
                                                                          .warehouseStores
                                                                          ?.d[index];
                                                                      return Stack(
                                                                        children: [
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  context.read<StoreOrderProvider>().selectedStoreName(store.warehouseName);
                                                                                  context.read<StoreOrderProvider>().selectedWarehouseId(store.warehouseId);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.store,
                                                                                            color: Colors.green,
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 10,
                                                                                          ),
                                                                                          Container(
                                                                                            width: MediaQuery.of(context).size.width * 0.80,
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(store!.warehouseName.toString(),
                                                                                                    overflow: TextOverflow.clip,
                                                                                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                                                          fontSize: 14,
                                                                                                        )),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )),
                                                                                ),
                                                                              ),
                                                                              Divider(
                                                                                thickness: 3,
                                                                                color: kCardBackgroundColor,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Positioned(
                                                                            top:
                                                                                4,
                                                                            right:
                                                                                4,
                                                                            bottom:
                                                                                5,
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: context.watch<StoreOrderProvider>().storeName == store.warehouseName
                                                                                    ? Container(
                                                                                        decoration: BoxDecoration(
                                                                                          shape: BoxShape.circle,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                        child: Center(child: Icon(Icons.check_rounded)),
                                                                                      )
                                                                                    : null,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    }),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: searchDesign(
                                          colors: Colors.white,
                                          text: context
                                                      .watch<
                                                          StoreOrderProvider>()
                                                      .storeName !=
                                                  ""
                                              ? context
                                                  .read<StoreOrderProvider>()
                                                  .storeName
                                              : "--- All Store---",
                                          icon: Icons.keyboard_arrow_down_sharp,
                                          iconSize: 15.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          textboxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "Select Store",
                                        style: TextStyle(
                                            fontSize: 12, color: kWhiteColor),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                await context
                                    .read<StoreOrderProvider>()
                                    .checkQr(false);
                                await context
                                    .read<StoreOrderProvider>()
                                    .checkAllItems(false);
                                await context
                                    .read<StoreOrderProvider>()
                                    .getWarehouseItemsApi();
                                showSearch(
                                    context: context,
                                    delegate: WarehouseItemSearch());
                              },
                              child: searchDesign(
                                colors: Colors.white,
                                text: context
                                            .watch<StoreOrderProvider>()
                                            .query !=
                                        ""
                                    ? context.watch<StoreOrderProvider>().query
                                    : "Search Items",
                                icon: Icons.search,
                                iconSize: 15.0,
                                width: MediaQuery.of(context).size.width * 0.32,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "Search Items",
                              style:
                                  TextStyle(fontSize: 12, color: kWhiteColor),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 115,
                                height: 40,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(

                                        // shadowColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        backgroundColor: Colors.green),
                                    onPressed: () async {
                                      await context
                                          .read<StoreOrderProvider>()
                                          .checkQr(false);
                                      await context
                                          .read<StoreOrderProvider>()
                                          .checkAllItems(true);
                                      context.read<StoreOrderProvider>().query =
                                          "";
                                      await context
                                          .read<StoreOrderProvider>()
                                          .returnWarehouseStoreItemsApi(
                                              deliveryDate: context
                                                  .read<StoreOrderProvider>()
                                                  .dateValue
                                                  .toString(),
                                              loading: true,
                                              qr: "",
                                              itemName: "");
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: kWhiteColor,
                                    ),
                                    label: Text(
                                      "All Items",
                                      style:
                                          TextStyle(color: Colors.white),
                                    ))),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Spacer(),
                        Text(
                          "(OR)",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            InkWell(
                                onTap: () async {
                                  await context
                                      .read<StoreOrderProvider>()
                                      .checkQr(true);
                                  await context
                                      .read<StoreOrderProvider>()
                                      .checkAllItems(false);
                                  context.read<StoreOrderProvider>().query = "";
                                  try {
                                    final qrCode =
                                        await FlutterBarcodeScanner.scanBarcode(
                                            '#ff6666',
                                            'Cancel',
                                            true,
                                            ScanMode.BARCODE);
                                    await context
                                        .read<StoreOrderProvider>()
                                        .notifyQr(qrCode);
                                    print("qr code data ${qrCode.toString()}");
                                    if (!mounted) return;
                                    if (qrCode != '-1') {
                                      context
                                          .read<StoreOrderProvider>()
                                          .returnWarehouseStoreItemsApi(
                                              deliveryDate: context
                                                  .read<StoreOrderProvider>()
                                                  .dateValue
                                                  .toString(),
                                              loading: true,
                                              qr: context
                                                  .read<StoreOrderProvider>()
                                                  .qrcode,
                                              itemName: "");
                                    } else {
                                      await context
                                          .read<StoreOrderProvider>()
                                          .checkQr(false);
                                      await context
                                          .read<StoreOrderProvider>()
                                          .checkAllItems(false);
                                      print('cancel triggred');
                                    }
                                  } on PlatformException {
                                    print('Failed to scan QR Code.');
                                  }
                                },
                                child: Icon(
                                  Icons.qr_code,
                                  color: Colors.white,
                                  size: 35,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Scan QR",
                              style:
                                  TextStyle(fontSize: 10, color: kWhiteColor),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(175)),
        ),
        body: selectedOrder == null || selectedOrder.isEmpty
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Please Select Company,Store and Receive date to get Item List \n (OR) \n Select Receive date and Scan QR",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Divider(
                          color: kCardBackgroundColor,
                          thickness: 8.0,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20.0),
                          child: Text('ITEM(S)',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Color(0xffadadad),
                                      fontWeight: FontWeight.bold)),
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.0),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: selectedOrder.length,
                              itemBuilder: (context, index) {
                                final items = selectedOrder[index];
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Container(
                                        width: 50.0,
                                        decoration: BoxDecoration(
                                            image: items.imageName == null ||
                                                    items.imageName == ""
                                                ? DecorationImage(
                                                    image: AssetImage(
                                                    'images/logos/not-available.png',
                                                  ))
                                                : DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            BaseUrl +
                                                                skuImges +
                                                                items.imageName,
                                                            cacheKey: items
                                                                .imageName),
                                                    onError: (exception,
                                                        stackTrace) {
                                                      items.imageName = "";
                                                    },
                                                  )),
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.90,
                                            child: Text(
                                              items.storename.toString(),
                                              overflow: TextOverflow.clip,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.green),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            items.itemname.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: kMainColor),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Order No -",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(fontSize: 13),
                                              ),
                                              Spacer(),
                                              Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                    child: Text(
                                                      '${items.orderno}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.blue),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Return Qty -",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(fontSize: 13),
                                              ),
                                              Spacer(),
                                              Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                    child: Text(
                                                      '${double.parse(items.returnqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                            fontSize: 13,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Receive Qty -",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontSize: 13,
                                                        color: Colors.red),
                                              ),
                                              Spacer(),
                                              Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '${double.parse(items.recieveqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        items.receiveStatus !=
                                                                "0"
                                                            ? SizedBox.shrink()
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                  context
                                                                      .read<
                                                                          StoreOrderProvider>()
                                                                      .reason = "";
                                                                  await context
                                                                      .read<
                                                                          StoreOrderProvider>()
                                                                      .getReasons();

                                                                  showDialog(
                                                                      barrierDismissible:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        var _formkey =
                                                                            GlobalKey<FormState>();
                                                                        TextEditingController
                                                                            orderController =
                                                                            TextEditingController();
                                                                        orderController
                                                                            .text = items.recieveqty !=
                                                                                ""
                                                                            ? double.parse(items.returnqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'),
                                                                                '')
                                                                            : "0";

                                                                        return StatefulBuilder(builder:
                                                                            (context,
                                                                                setState) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Receive Quantity",
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    context.read<StoreOrderProvider>().reason = "";
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: CircleAvatar(
                                                                                    backgroundColor: Colors.white.withOpacity(0),
                                                                                    child: Icon(
                                                                                      Icons.cancel,
                                                                                      color: Colors.red,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            content:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Form(
                                                                                  key: _formkey,
                                                                                  child: TextFormField(
                                                                                    keyboardType: TextInputType.number,
                                                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                    inputFormatters: [
                                                                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                                    ],
                                                                                    validator: (value) {
                                                                                      if (value!.length < 1) {
                                                                                        return "please enter quantity";
                                                                                      }
                                                                                      //  else if (double.parse(
                                                                                      //         value) >
                                                                                      //     double.parse(
                                                                                      //         checkValue)) {
                                                                                      //   return 'value is greater then Bal quantity';
                                                                                      // }

                                                                                      return null;
                                                                                    },
                                                                                    textAlign: TextAlign.center,
                                                                                    controller: orderController,
                                                                                    decoration: InputDecoration(
                                                                                      hintText: 'Qty',
                                                                                      suffixIcon: Padding(
                                                                                        padding: const EdgeInsets.only(right: 8),
                                                                                        child: Icon(
                                                                                          Icons.edit,
                                                                                          size: 16,
                                                                                        ),
                                                                                      ),
                                                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                                                                                      border: new OutlineInputBorder(
                                                                                        borderSide: const BorderSide(width: 2.0),
                                                                                        borderRadius: BorderRadius.circular(5.0),
                                                                                      ),
                                                                                      contentPadding: EdgeInsets.only(),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () async {
                                                                                    setState(() {});
                                                                                    await context.read<StoreOrderProvider>().getReasons();

                                                                                    showModalBottomSheet(
                                                                                        isDismissible: false,
                                                                                        backgroundColor: Colors.transparent,
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          final scrollController = ScrollController(initialScrollOffset: 0);
                                                                                          return Container(
                                                                                            decoration: BoxDecoration(
                                                                                              // color: kCardBackgroundColor,
                                                                                              color: Colors.white,
                                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                                                                            ),
                                                                                            width: MediaQuery.of(context).size.width * 0.5,
                                                                                            height: MediaQuery.of(context).size.height * 0.50,
                                                                                            child: ListView(
                                                                                              physics: NeverScrollableScrollPhysics(),
                                                                                              children: [
                                                                                                Container(
                                                                                                  height: 40,
                                                                                                  decoration: BoxDecoration(
                                                                                                    // color: kCardBackgroundColor,
                                                                                                    color: kMainColor,
                                                                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          "Select Reason",
                                                                                                          style: TextStyle(color: kWhiteColor, fontSize: 14),
                                                                                                        ),
                                                                                                        Spacer(),
                                                                                                        InkWell(
                                                                                                          onTap: () {
                                                                                                            Navigator.pop(context);
                                                                                                            FocusScope.of(context).unfocus();
                                                                                                          },
                                                                                                          child: Icon(
                                                                                                            Icons.cancel,
                                                                                                            size: 22,
                                                                                                            color: Colors.red,
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Scrollbar(
                                                                                                  thumbVisibility: true,
                                                                                                  controller: scrollController,
                                                                                                  thickness: 8,
                                                                                                  trackVisibility: true,
                                                                                                  child: Container(
                                                                                                    height: MediaQuery.of(context).size.height * 0.60,
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                                                                                                      child: ListView.builder(
                                                                                                          controller: scrollController,
                                                                                                          shrinkWrap: true,
                                                                                                          itemCount: context.read<StoreOrderProvider>().reasons?.d.length,
                                                                                                          itemBuilder: (context, index) {
                                                                                                            var reason = context.watch<StoreOrderProvider>().reasons?.d[index];
                                                                                                            return Stack(
                                                                                                              children: [
                                                                                                                Column(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    InkWell(
                                                                                                                      onTap: () async {
                                                                                                                        await context.read<StoreOrderProvider>().selectReason(reason.reason);

                                                                                                                        Navigator.pop(context);
                                                                                                                        FocusScope.of(context).unfocus();
                                                                                                                      },
                                                                                                                      child: SizedBox(
                                                                                                                        child: Padding(
                                                                                                                            padding: const EdgeInsets.all(5.0),
                                                                                                                            child: Row(
                                                                                                                              children: [
                                                                                                                                Icon(
                                                                                                                                  Icons.feedback_outlined,
                                                                                                                                  color: Colors.green,
                                                                                                                                ),
                                                                                                                                SizedBox(
                                                                                                                                  width: 10,
                                                                                                                                ),
                                                                                                                                Container(
                                                                                                                                  width: MediaQuery.of(context).size.width * 0.80,
                                                                                                                                  child: Column(
                                                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                    children: [
                                                                                                                                      Text(reason!.reason.toString(),
                                                                                                                                          overflow: TextOverflow.clip,
                                                                                                                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                                                                                                fontSize: 14,
                                                                                                                                              )),
                                                                                                                                    ],
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ],
                                                                                                                            )),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Divider(
                                                                                                                      thickness: 3,
                                                                                                                      color: kCardBackgroundColor,
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
                                                                                                                      child: context.watch<StoreOrderProvider>().reason == reason.reason
                                                                                                                          ? Container(
                                                                                                                              decoration: BoxDecoration(
                                                                                                                                shape: BoxShape.circle,
                                                                                                                                color: Colors.green,
                                                                                                                              ),
                                                                                                                              child: Center(child: Icon(Icons.check_rounded)),
                                                                                                                            )
                                                                                                                          : null,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            );
                                                                                                          }),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                        });
                                                                                  },
                                                                                  child: searchDesign(colors: kMainColor, text: context.watch<StoreOrderProvider>().reason != "" ? context.watch<StoreOrderProvider>().reason : 'Select Reason', width: MediaQuery.of(context).size.width * 0.80, textboxWidth: MediaQuery.of(context).size.width * 0.50, icon: Icons.keyboard_arrow_down_sharp),
                                                                                ),
                                                                                Container(
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      ElevatedButton.icon(
                                                                                          icon: Icon(Icons.save),
                                                                                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(kMainColor)),
                                                                                          onPressed: () async {
                                                                                            FocusScope.of(context).unfocus();
                                                                                            if (context.read<StoreOrderProvider>().reason != "") {
                                                                                              if (_formkey.currentState!.validate()) {
                                                                                                var shrtQty = double.parse(items.returnqty) - double.parse(orderController.text);
                                                                                                Navigator.pop(context);
                                                                                                showDialog(
                                                                                                    context: context,
                                                                                                    barrierDismissible: false,
                                                                                                    builder: (BuildContext context) {
                                                                                                      return AlertDialog(
                                                                                                        title: Text(
                                                                                                          'Receive Quantity',
                                                                                                        ),
                                                                                                        content: Column(
                                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              'You Can Receive Qty one time only,',
                                                                                                              style: TextStyle(color: Color.fromARGB(255, 5, 103, 179)),
                                                                                                            ),
                                                                                                            Text(
                                                                                                              'Are you sure you want to receive this?',
                                                                                                              style: TextStyle(color: Colors.red),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        actions: <Widget>[
                                                                                                          ElevatedButton(
                                                                                                            child: Text(
                                                                                                              'No',
                                                                                                            ),
                                                                                                            style: ElevatedButton.styleFrom(
                                                                                                              backgroundColor: Colors.red,
                                                                                                              textStyle: TextStyle(color: kWhiteColor),
                                                                                                              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.red)),
                                                                                                            ),
                                                                                                            onPressed: () => Navigator.pop(context),
                                                                                                          ),
                                                                                                          ElevatedButton(
                                                                                                              child: Text(
                                                                                                                'Yes',
                                                                                                              ),
                                                                                                              style: ElevatedButton.styleFrom(
                                                                                                                backgroundColor: Colors.green,
                                                                                                                textStyle: TextStyle(color: kWhiteColor),
                                                                                                                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.green)),
                                                                                                              ),
                                                                                                              onPressed: () async {
                                                                                                                await context.read<StoreOrderProvider>().WareHouseItemReceive(
                                                                                                                      rtnId: items.rtnId,
                                                                                                                      shrtQty: shrtQty,
                                                                                                                      skuId: items.skuid,
                                                                                                                      qty: orderController.text,
                                                                                                                      reason: context.read<StoreOrderProvider>().reason,
                                                                                                                      skusid: items.skusid,
                                                                                                                    );
                                                                                                                await context.read<StoreOrderProvider>().selectedQr == false
                                                                                                                    ? await context.read<StoreOrderProvider>().allItems == false
                                                                                                                        ? await context.read<StoreOrderProvider>().returnWarehouseStoreItemsApi(qr: "", deliveryDate: context.read<StoreOrderProvider>().dateValue.toString(), loading: true, itemName: context.read<StoreOrderProvider>().query)
                                                                                                                        : await context.read<StoreOrderProvider>().returnWarehouseStoreItemsApi(qr: "", deliveryDate: context.read<StoreOrderProvider>().dateValue.toString(), loading: true, itemName: "")
                                                                                                                    : await context.read<StoreOrderProvider>().returnWarehouseStoreItemsApi(deliveryDate: context.read<StoreOrderProvider>().dateValue.toString(), loading: true, qr: context.read<StoreOrderProvider>().qrcode, itemName: "");
                                                                                                                Navigator.pop(context);
                                                                                                              })
                                                                                                        ],
                                                                                                      );
                                                                                                    });
                                                                                              }
                                                                                            } else {
                                                                                              showMessage('Please Select Reason');
                                                                                            }
                                                                                          },
                                                                                          label: Text("Receive Qty"))
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        });
                                                                      });
                                                                },
                                                                child:
                                                                    Image.asset(
                                                                  'images/logos/received.png',
                                                                  height: 17,
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          items.receiveStatus != "1"
                                              ? SizedBox.shrink()
                                              : Row(
                                                  children: [
                                                    Text(
                                                      "Balance Qty -",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontSize: 13),
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          child: Text(
                                                            '${double.parse(items.BalQty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodySmall!
                                                                .copyWith(
                                                                  fontSize: 13,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          items.reason == ""
                                              ? SizedBox.shrink()
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Reason -',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          child: Text(
                                                              '${items.reason}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .purple)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          items.returnBy == ""
                                              ? SizedBox.shrink()
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Return by -',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          child: Text(
                                                              '${items.returnBy.replaceAll("|", "")}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .purple)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          items.receiveBy == ""
                                              ? SizedBox.shrink()
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Received by - ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          child: Text(
                                                              '${items.receiveBy.replaceAll("|", "")}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .purple)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 4.0,
                                    ),
                                  ],
                                );
                              }),
                        ),
                        Divider(
                          color: kCardBackgroundColor,
                          thickness: 8.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  searchOrderby({
    context,
    title,
    hint,
    phone,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          var _formkey = GlobalKey<FormState>();
          TextEditingController orderController = TextEditingController();
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Form(
                  key: _formkey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value!.length < 1 ? hint : null,
                    textAlign: TextAlign.center,
                    controller: orderController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      hintText: hint,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                        ),
                      ),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: EdgeInsets.only(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.red)),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel),
                          label: Text("Cancel")),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.green)),
                          onPressed: () async {
                            print(orderController.text);
                            if (phone == true) {
                              var response = await context
                                  .read<StoreOrderProvider>()
                                  .checkMobileNumber(
                                      mobileNumber: orderController.text);
                              if (response != "0") {
                                context
                                    .read<StoreOrderProvider>()
                                    .geInvoiceData(
                                        loading: true,
                                        orderNo: phone == false
                                            ? orderController.text
                                            : "",
                                        scanner: "",
                                        phoneNumber: phone == true
                                            ? orderController.text
                                            : "",
                                        itemName: "");
                                context.read<StoreOrderProvider>().phoneOrOrder(
                                    orderController.text,
                                    phone == true ? true : false);
                                Navigator.pop(context);
                              } else {
                                showMessage("Invalid Mobile Number");
                              }
                            } else if (phone == false) {
                              context.read<StoreOrderProvider>().geInvoiceData(
                                  loading: true,
                                  orderNo: phone == false
                                      ? orderController.text
                                      : "",
                                  scanner: "",
                                  phoneNumber:
                                      phone == true ? orderController.text : "",
                                  itemName: "");
                              context.read<StoreOrderProvider>().phoneOrOrder(
                                  orderController.text,
                                  phone == true ? true : false);
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(Icons.search),
                          label: Text("search")),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  // ignore: override_on_non_overriding_member
  bool get wantKeepAlive => true;
}
