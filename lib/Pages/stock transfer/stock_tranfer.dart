// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Pages/stock%20transfer/stock_transfer_search.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/bottom_bar.dart';
import '../../Provider/login_provider.dart';
import '../../StoreOrdering/Pages/MyOrders/storeItemsAcceptanace.dart';
import '../../StoreOrdering/StoreOrderingProvider/StoreOrderingProvider.dart';
import '../../Utils/AppConstants.dart';

class StockTranserPage extends StatefulWidget {
  const StockTranserPage({Key? key}) : super(key: key);

  @override
  State<StockTranserPage> createState() => _StockTranserPageState();
}

class _StockTranserPageState extends State<StockTranserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController(initialScrollOffset: 0);
    final selectedOrder =
        context.watch<StoreOrderProvider>().getAvailableStock?.d;
    final transferData =
        context.watch<StoreOrderProvider>().getStockTransferData?.d;
    context.read<StoreOrderProvider>().checkCategoryData();

    return WillPopScope(
      onWillPop: () async {
        context.read<StoreOrderProvider>().loadstoresku_type?.d = [];
        context.read<StoreOrderProvider>().dateValue = DateTime.now();
        await context.read<StoreOrderProvider>().checkQr(false);
        await context.read<StoreOrderProvider>().checkAllItems(false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('new_CatId', "1");
        await prefs.setString('new_store_id', "");
        context.read<StoreOrderProvider>().skuname = "Fruit and Vegetable";
        context.read<StoreOrderProvider>().storeName = "";
        context.read<StoreOrderProvider>().query = "";
        // context.read<StoreOrderProvider>().selectedWarehouse = "0";
        context.read<StoreOrderProvider>().getAvailableStock?.d = [];
        context.read<StoreOrderProvider>().getStockTransferData?.d = [];
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            context.watch<LoginProvider>().storeLocationName != null
                ? ' ${context.watch<LoginProvider>().storeLocationName} Store Stock Transfer'
                : "Store Stock Transfer",
            style: TextStyle(fontSize: 18, color: kWhiteColor),
          ),
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 0, top: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Text(
                            "Select Category",
                            style: TextStyle(fontSize: 12, color: kWhiteColor),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        InkWell(
                          onTap: () async {
                            await context
                                .read<StoreOrderProvider>()
                                .loadStoreSkuType();
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
                                        MediaQuery.of(context).size.width * 1.0,
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
                                                  "Select Category",
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
                                                      .loadstoresku_type
                                                      ?.d
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var skutype = context
                                                        .watch<
                                                            StoreOrderProvider>()
                                                        .loadstoresku_type
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
                                                                    'new_CatId',
                                                                    skutype
                                                                        .categoryId);
                                                                context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .storeName = "";
                                                                await context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .selectedSkuCategory(
                                                                        skutype
                                                                            .categoryName);
                                                                // context
                                                                //     .read<
                                                                //         StoreOrderProvider>()
                                                                //     .selectedWarehouse = "0";
                                                                Navigator.pop(
                                                                    context);
                                                                context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .query = "";
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
                                                                              Text(skutype!.categoryName.toString(),
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
                                                                          .skuname ==
                                                                      skutype
                                                                          .categoryName
                                                                  ? Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      child: Center(
                                                                          child:
                                                                              Icon(Icons.check_rounded)),
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
                                          .skuname !=
                                      ""
                                  ? context.read<StoreOrderProvider>().skuname
                                  : context
                                              .watch<StoreOrderProvider>()
                                              .tempCatId ==
                                          "1"
                                      ? "Fruit and Vegetable"
                                      : "--- Select Category ---",
                              icon: Icons.keyboard_arrow_down_sharp,
                              iconSize: 15.0,
                              width: MediaQuery.of(context).size.width * 0.95,
                              textboxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 2.0,
                          ),
                          child: Text(
                            "Select Stock Transfer Store",
                            style: TextStyle(fontSize: 12, color: kWhiteColor),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await context
                                .read<StoreOrderProvider>()
                                .getStoresForStockTransfer();
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
                                        MediaQuery.of(context).size.width * 1.0,
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
                                                  "Select Store",
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
                                                      .getstoresforStockTransfer
                                                      ?.d
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var store = context
                                                        .watch<
                                                            StoreOrderProvider>()
                                                        .getstoresforStockTransfer
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
                                                                    'new_store_id',
                                                                    store
                                                                        .storeId);
                                                                context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .storeName = "";
                                                                await context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .selectedStoreName(
                                                                        store
                                                                            .storeName);
                                                                // context
                                                                //     .read<
                                                                //         StoreOrderProvider>()
                                                                //     .selectedWarehouse = "0";

                                                                context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .query = "";
                                                                await context
                                                                    .read<
                                                                        StoreOrderProvider>()
                                                                    .getTransferData(
                                                                        loading:
                                                                            true);
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
                                                                              Text(store!.storeName.toString(),
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
                                                                          .storeName ==
                                                                      store
                                                                          .storeName
                                                                  ? Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      child: Center(
                                                                          child:
                                                                              Icon(Icons.check_rounded)),
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
                                          .storeName !=
                                      ""
                                  ? context.read<StoreOrderProvider>().storeName
                                  : "--- Select Store ---",
                              icon: Icons.keyboard_arrow_down_sharp,
                              iconSize: 15.0,
                              width: MediaQuery.of(context).size.width * 0.95,
                              textboxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    context.watch<StoreOrderProvider>().storeName == ""
                        ? SizedBox.shrink()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 2.0, left: 5),
                                    child: Text(
                                      "Search Items",
                                      style: TextStyle(
                                          fontSize: 12, color: kWhiteColor),
                                    ),
                                  ),
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
                                          .getCurrentStoreItemsApi();
                                      showSearch(
                                          context: context,
                                          delegate: StockTransferSearch());
                                    },
                                    child: searchDesign(
                                      colors: Colors.white,
                                      textboxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.50,
                                      text: context
                                                  .watch<StoreOrderProvider>()
                                                  .query !=
                                              ""
                                          ? context
                                              .watch<StoreOrderProvider>()
                                              .query
                                          : "search Items",
                                      icon: Icons.search,
                                      iconSize: 15.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                "(OR)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 2.0, right: 5),
                                    child: Text(
                                      "Scan QR",
                                      style: TextStyle(
                                          fontSize: 12, color: kWhiteColor),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        await context
                                            .read<StoreOrderProvider>()
                                            .checkQr(true);
                                        await context
                                            .read<StoreOrderProvider>()
                                            .checkAllItems(false);
                                        context
                                            .read<StoreOrderProvider>()
                                            .query = "";
                                        try {
                                          final qrCode =
                                              await FlutterBarcodeScanner
                                                  .scanBarcode(
                                                      '#ff6666',
                                                      'Cancel',
                                                      true,
                                                      ScanMode.BARCODE);
                                          await context
                                              .read<StoreOrderProvider>()
                                              .notifyQr(qrCode);
                                          print(
                                              "qr code data ${qrCode.toString()}");
                                          if (!mounted) return;
                                          if (qrCode != '-1') {
                                            await context
                                                .read<StoreOrderProvider>()
                                                .returnAvailableStoreItemsApi(
                                                    action: "1",
                                                    loading: true,
                                                    itemName: "",
                                                    qr: context
                                                        .read<
                                                            StoreOrderProvider>()
                                                        .qrcode);
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
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(
                  context.read<StoreOrderProvider>().storeName == ""
                      ? 110
                      : 160)),
        ),
        body: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          thickness: 5,
          trackVisibility: true,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: <Widget>[
                    Divider(
                      color: kCardBackgroundColor,
                      thickness: 8.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text('SEARCH ITEM(S)',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: Color(0xffadadad),
                                  fontWeight: FontWeight.bold)),
                      color: Colors.white,
                    ),
                    selectedOrder == null || selectedOrder.isEmpty
                        ? SizedBox(height: 100)
                        : Padding(
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
                                              image: items.imgpath == null ||
                                                      items.imgpath == ""
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                      'images/logos/not-available.png',
                                                    ))
                                                  : DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              BaseUrl +
                                                                  skuImges +
                                                                  items.imgpath,
                                                              cacheKey: items
                                                                  .imgpath),
                                                      onError: (exception,
                                                          stackTrace) {
                                                        items.imgpath = "";
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
                                                items.itemName,
                                                overflow: TextOverflow.clip,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.green),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
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
                                                  "Available Stock -",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 15,
                                                          color: kMainColor),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        items.stockUnit ==
                                                                    null ||
                                                                items.stockUnit ==
                                                                    ""
                                                            ? "0.0"
                                                            : '${double.parse(items.stockUnit).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .blue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (context) {
                                                          var _formkey =
                                                              GlobalKey<
                                                                  FormState>();
                                                          TextEditingController
                                                              orderController =
                                                              TextEditingController();
                                                          // orderController
                                                          //     .text = items
                                                          //                 .stockUnit !=
                                                          //             null ||
                                                          //         items.stockUnit !=
                                                          //             ""
                                                          //     ? double.parse(items
                                                          //             .stockUnit
                                                          //             .toString())
                                                          //         .toStringAsFixed(
                                                          //             2)
                                                          //         .replaceFirst(
                                                          //             RegExp(
                                                          //                 r'\.?0*$'),
                                                          //             '')
                                                          //     : "0";

                                                          return AlertDialog(
                                                            title: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Transfer Stock",
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "Available Qty:"),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Text(
                                                                      items.stockUnit == null ||
                                                                              items.stockUnit == ""
                                                                          ? "0.0"
                                                                          : '${double.parse(items.stockUnit).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .copyWith(
                                                                              fontSize: 15,
                                                                              color: Colors.blue),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Form(
                                                                  key: _formkey,
                                                                  child:
                                                                      TextFormField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    autovalidateMode:
                                                                        AutovalidateMode
                                                                            .onUserInteraction,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter
                                                                          .allow(
                                                                              RegExp(r'[0-9]')),
                                                                    ],
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                              .length <
                                                                          1) {
                                                                        return "please enter quantity";
                                                                      } else if (double.parse(
                                                                              value) >
                                                                          double.parse(items
                                                                              .stockUnit)) {
                                                                        return 'value is greater then available Qty';
                                                                      } else if (double.parse(
                                                                              value) ==
                                                                          double.parse(
                                                                              "0")) {
                                                                        return 'value is not equal to 0';
                                                                      }

                                                                      return null;
                                                                    },
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    controller:
                                                                        orderController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'Qty',
                                                                      suffixIcon:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                8),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .edit,
                                                                          size:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                              borderSide: BorderSide(width: 1)),
                                                                      border:
                                                                          new OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(width: 2.0),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                      ),
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .only(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      ElevatedButton.icon(
                                                                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.red)),
                                                                          onPressed: () async {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.cancel,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          label: Text(
                                                                            "Cancel",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                      ElevatedButton.icon(
                                                                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                                                                          onPressed: () async {
                                                                            if (_formkey.currentState!.validate()) {
                                                                              if (double.parse(double.parse(items.transferqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')) <= 0.0) {
                                                                                //add
                                                                                await context.read<StoreOrderProvider>().StockTransferQuantity(Qty: orderController.text, sku_sid: items.skuSid);
                                                                                context.read<StoreOrderProvider>().getAvailableStock?.d = [];
                                                                                context.read<StoreOrderProvider>().query = "";

                                                                                // await context.read<StoreOrderProvider>().selectedQr == false ? await context.read<StoreOrderProvider>().returnAvailableStoreItemsApi(action: "8", loading: true, itemName: context.read<StoreOrderProvider>().query, qr: "") : await context.read<StoreOrderProvider>().returnAvailableStoreItemsApi(action: "1", loading: true, itemName: "", qr: context.read<StoreOrderProvider>().qrcode);
                                                                                Navigator.pop(context);
                                                                                await context.read<StoreOrderProvider>().getTransferData(loading: true);
                                                                              } else {
                                                                                //update
                                                                                await context.read<StoreOrderProvider>().UpdateStockTransferQuantity(Qty: orderController.text, sku_sid: items.skuSid);
                                                                                context.read<StoreOrderProvider>().getAvailableStock?.d = [];
                                                                                context.read<StoreOrderProvider>().query = "";
                                                                                Navigator.pop(context);
                                                                                await context.read<StoreOrderProvider>().getTransferData(loading: true);
                                                                                // await context.read<StoreOrderProvider>().selectedQr == false ? await context.read<StoreOrderProvider>().returnAvailableStoreItemsApi(action: "8", loading: true, itemName: context.read<StoreOrderProvider>().query, qr: "") : await context.read<StoreOrderProvider>().returnAvailableStoreItemsApi(action: "1", loading: true, itemName: "", qr: context.read<StoreOrderProvider>().qrcode);
                                                                              }
                                                                            }
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.done,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          label: Text(
                                                                            "ok",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.red)),
                                                    width: 50,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.add,
                                                          size: 20,
                                                          color: Colors.red,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .transfer_within_a_station_sharp,
                                                          size: 20,
                                                          color: Colors.blue,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                    Divider(
                      color: Colors.grey,
                      thickness: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Text('TRANSFER ITEM(S)',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: Color(0xffadadad),
                                  fontWeight: FontWeight.bold)),
                      color: Colors.white,
                    ),
                    transferData == null || transferData.isEmpty
                        ? Center(
                            child: Container(
                              margin: EdgeInsets.all(15),
                              child: Text(
                                "No Transfer Items Found",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.0),
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: transferData.length,
                                itemBuilder: (context, index) {
                                  final transferItems = transferData[index];
                                  return Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Container(
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                              image: transferItems.imgpath ==
                                                          null ||
                                                      transferItems.imgpath ==
                                                          ""
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                      'images/logos/not-available.png',
                                                    ))
                                                  : DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              BaseUrl +
                                                                  skuImges +
                                                                  transferItems
                                                                      .imgpath,
                                                              cacheKey:
                                                                  transferItems
                                                                      .imgpath),
                                                      onError: (exception,
                                                          stackTrace) {
                                                        transferItems.imgpath =
                                                            "";
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
                                                transferItems.itemName,
                                                overflow: TextOverflow.clip,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.green),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
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
                                                  "Available Stock -",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 15,
                                                          color: kMainColor),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        transferItems.stockUnit ==
                                                                    null ||
                                                                transferItems
                                                                        .stockUnit ==
                                                                    ""
                                                            ? "0.0"
                                                            : '${double.parse(transferItems.stockUnit).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .blue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Transfer Qty -",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 15,
                                                          color: kMainColor),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        transferItems.transferqty ==
                                                                    null ||
                                                                transferItems
                                                                        .transferqty ==
                                                                    ""
                                                            ? "0.0"
                                                            : '${double.parse(transferItems.transferqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .blue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (context) {
                                                          var _formkey =
                                                              GlobalKey<
                                                                  FormState>();
                                                          TextEditingController
                                                              UpdateController =
                                                              TextEditingController();
                                                          UpdateController
                                                              .text = transferItems
                                                                          .transferqty !=
                                                                      null ||
                                                                  transferItems
                                                                          .transferqty !=
                                                                      ""
                                                              ? double.parse(transferItems
                                                                      .transferqty
                                                                      .toString())
                                                                  .toStringAsFixed(
                                                                      2)
                                                                  .replaceFirst(
                                                                      RegExp(
                                                                          r'\.?0*$'),
                                                                      '')
                                                              : "0";

                                                          return AlertDialog(
                                                            title: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Transfer Quantity!",
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "Available Qty:"),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Text(
                                                                      transferItems.stockUnit == null ||
                                                                              transferItems.stockUnit == ""
                                                                          ? "0.0"
                                                                          : '${double.parse(transferItems.stockUnit).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .copyWith(
                                                                              fontSize: 15,
                                                                              color: Colors.blue),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Form(
                                                                  key: _formkey,
                                                                  child:
                                                                      TextFormField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    autovalidateMode:
                                                                        AutovalidateMode
                                                                            .onUserInteraction,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter
                                                                          .allow(
                                                                              RegExp(r'[0-9]')),
                                                                    ],
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                              .length <
                                                                          1) {
                                                                        return "please enter quantity";
                                                                      } else if (double.parse(
                                                                              value) >
                                                                          double.parse(transferItems
                                                                              .stockUnit)) {
                                                                        return 'value is greater then stock quantity';
                                                                      } else if (double.parse(
                                                                              value) ==
                                                                          double.parse(
                                                                              "0")) {
                                                                        return 'value is not equal to 0';
                                                                      }

                                                                      return null;
                                                                    },
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    controller:
                                                                        UpdateController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'Qty',
                                                                      suffixIcon:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                8),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .edit,
                                                                          size:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                              borderSide: BorderSide(width: 1)),
                                                                      border:
                                                                          new OutlineInputBorder(
                                                                        borderSide:
                                                                            const BorderSide(width: 2.0),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                      ),
                                                                      contentPadding:
                                                                          EdgeInsets
                                                                              .only(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      ElevatedButton.icon(
                                                                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.red)),
                                                                          onPressed: () async {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.cancel,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          label: Text(
                                                                            "Cancel",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                      ElevatedButton.icon(
                                                                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                                                                          onPressed: () async {
                                                                            if (_formkey.currentState!.validate()) {
                                                                              await context.read<StoreOrderProvider>().UpdateStockTransferQuantity(Qty: UpdateController.text, sku_sid: transferItems.skuSid);
                                                                              context.read<StoreOrderProvider>().getAvailableStock?.d = [];
                                                                              Navigator.pop(context);
                                                                              await context.read<StoreOrderProvider>().getTransferData(loading: true);
                                                                            }
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.done,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          label: Text(
                                                                            "ok",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    width: 50,
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            title: Text(
                                                              'Remove Item',
                                                            ),
                                                            content: Text(
                                                                'Are you sure to remove this Item from the Stock Transfer list',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                            actions: <Widget>[
                                                              ElevatedButton(
                                                                child: Text(
                                                                    'No',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white)),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  textStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              kWhiteColor),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      side: BorderSide(
                                                                          color:
                                                                              Colors.green)),
                                                                ),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                              ),
                                                              ElevatedButton(
                                                                  child: Text(
                                                                      'Yes',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white)),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .redAccent,
                                                                    textStyle:
                                                                        TextStyle(
                                                                            color:
                                                                                kWhiteColor),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        side: BorderSide(
                                                                            color:
                                                                                Colors.redAccent)),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    await context
                                                                        .read<
                                                                            StoreOrderProvider>()
                                                                        .deleteStockRecord(
                                                                            trnsId:
                                                                                transferItems.transId);
                                                                    Navigator.pop(
                                                                        context);
                                                                  })
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    width: 50,
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text("Transfer By :",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: kMainColor)),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Text(
                                                      '${transferItems.transferBy.replaceAll("|", "")}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .purple)),
                                                ),
                                              ],
                                            )
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
                    transferData == null || transferData.isEmpty
                        ? SizedBox.shrink()
                        : BottomBar(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      title: Text(
                                        'Submit ',
                                      ),
                                      content: Text(
                                          'Are you sure want to Transfer the Stock',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text('No',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            textStyle:
                                                TextStyle(color: kWhiteColor),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color: Colors.red)),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        ElevatedButton(
                                            child: Text('Yes',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              textStyle:
                                                  TextStyle(color: kWhiteColor),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                      color: Colors.green)),
                                            ),
                                            onPressed: () async {
                                              var res = await context
                                                  .read<StoreOrderProvider>()
                                                  .submitStock();
                                              Navigator.pop(context);
                                              if (res == "1") {
                                                showMessage(
                                                    "Stock Transfer Submitted");
                                              } else if (res == "0") {
                                                showMessage(
                                                    "Available Stock Quntity has been change, kindly check and reassign.");
                                              }
                                            })
                                      ],
                                    );
                                  });
                            },
                            text: "Submit",
                            color: Colors.green,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  bool get wantKeepAlive => true;
}
