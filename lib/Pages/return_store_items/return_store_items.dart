// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Pages/return_store_items/return_strore_items_search.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../StoreOrdering/Pages/MyOrders/storeItemsAcceptanace.dart';
import '../../StoreOrdering/StoreOrderingProvider/StoreOrderingProvider.dart';

class ReturnStoreItemsPage extends StatefulWidget {
  const ReturnStoreItemsPage({Key? key}) : super(key: key);

  @override
  State<ReturnStoreItemsPage> createState() => _ReturnStoreItemsPageState();
}

class _ReturnStoreItemsPageState extends State<ReturnStoreItemsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedOrder =
        context.watch<StoreOrderProvider>().returnStoreItemsDetails?.d;
    return WillPopScope(
      onWillPop: () async {
        context.read<StoreOrderProvider>().returnStoreItemsDetails?.d = [];
        context.read<StoreOrderProvider>().dateValue = DateTime.now();
        await context.read<StoreOrderProvider>().checkQr(false);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Store Return Items",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 2, top: 10),
                child: Row(
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
                            showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate: context
                                    .read<StoreOrderProvider>()
                                    .dateValue,
                                firstDate:
                                    DateTime.now().subtract(Duration(days: 60)),
                                lastDate: DateTime.now(),
                                builder: (BuildContext context, child) {
                                  return Theme(
                                      data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                              primary: kMainColor,
                                              onPrimary: Colors.white,
                                              onSurface: kMainColor)),
                                      child: child!);
                                }).then((value) async {
                              if (value != null) {
                                await context
                                    .read<StoreOrderProvider>()
                                    .notifyDate(value);
                              }
                            });
                          },
                          child: Container(
                              width: 115,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      context
                                                      .watch<
                                                          StoreOrderProvider>()
                                                      .dateValue !=
                                                  null &&
                                              context
                                                      .watch<
                                                          StoreOrderProvider>()
                                                      .dateValue !=
                                                  ""
                                          ? DateFormat('dd/MM/yyyy').format(
                                              context
                                                  .watch<StoreOrderProvider>()
                                                  .dateValue)
                                          : "Select Date",
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.date_range,
                                      color: kWhiteColor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Delivery Date",
                          style: TextStyle(fontSize: 12, color: kWhiteColor),
                        )
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await context
                                .read<StoreOrderProvider>()
                                .checkQr(false);
                            await context
                                .read<StoreOrderProvider>()
                                .getItemsApi();
                            showSearch(
                                context: context, delegate: StoreItemSearch());
                          },
                          child: searchDesign(
                            colors: Colors.white,
                            text: "search Items",
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
                          style: TextStyle(fontSize: 12, color: kWhiteColor),
                        )
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
                                      .returnStoreItemsApi(
                                          deliveryDate: "",
                                          loading: true,
                                          skuid: context
                                              .read<StoreOrderProvider>()
                                              .qrcode,
                                          itemName: "");
                                } else {
                                  await context
                                      .read<StoreOrderProvider>()
                                      .checkQr(false);
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
                          style: TextStyle(fontSize: 10, color: kWhiteColor),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(50)),
        ),
        body: selectedOrder == null || selectedOrder.isEmpty
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Please Select Delivery date to get Item List  (OR) Scan QR",
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
                                            image: items.image == null ||
                                                    items.image == ""
                                                ? DecorationImage(
                                                    image: AssetImage(
                                                    'images/logos/not-available.png',
                                                  ))
                                                : DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            BaseUrl +
                                                                skuImges +
                                                                items.image,
                                                            cacheKey:
                                                                items.image),
                                                    onError: (exception,
                                                        stackTrace) {
                                                      items.image = "";
                                                    },
                                                  )),
                                      ),
                                      title: Text(
                                        items.itemname.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                color: kMainColor),
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
                                                "Order No: ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(fontSize: 13),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.50,
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
                                                'Order Qty: ${double.parse(items.orderqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              Spacer(),
                                              Text(
                                                'Stock Qty: ${double.parse(items.stockqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Store Receive Qty: ${double.parse(items.receiveqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Return Qty:',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.10,
                                                    child: Text(
                                                      ' ${double.parse(items.prevReturnqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Column(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      'Wastage Qty: ${double.parse(items.wastageqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Prvs Return Details:',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    child: Text(
                                                      '${items.returnDetails}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .redAccent),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Theme.of(context).cardColor,
                                            thickness: 4,
                                          ),
                                          items.returnlockstatus == "0"
                                              ? SizedBox.shrink()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
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
                                                              var checkValue;
                                                              if (double.parse(items
                                                                      .stockqty) >
                                                                  double.parse(items
                                                                      .balQty)) {
                                                                // orderController
                                                                //     .text = items
                                                                //                 .balQty !=
                                                                //             null ||
                                                                //         items.balQty !=
                                                                //             ""
                                                                //     ? double.parse(items
                                                                //             .balQty
                                                                //             .toString())
                                                                //         .toStringAsFixed(
                                                                //             2)
                                                                //         .replaceFirst(
                                                                //             RegExp(
                                                                //                 r'\.?0*$'),
                                                                //             '')
                                                                //     : "0";
                                                                checkValue = items.balQty !=
                                                                            null ||
                                                                        items.balQty !=
                                                                            ""
                                                                    ? double.parse(items
                                                                            .balQty
                                                                            .toString())
                                                                        .toStringAsFixed(
                                                                            2)
                                                                        .replaceFirst(
                                                                            RegExp(
                                                                                r'\.?0*$'),
                                                                            '')
                                                                    : double.parse("0.0"
                                                                            .toString())
                                                                        .toStringAsFixed(
                                                                            2)
                                                                        .replaceFirst(
                                                                            RegExp(r'\.?0*$'),
                                                                            '');
                                                              } else {
                                                                // orderController
                                                                //     .text = items
                                                                //                 .stockqty !=
                                                                //             null ||
                                                                //         items.stockqty !=
                                                                //             ""
                                                                //     ? double.parse(items
                                                                //             .orderqty
                                                                //             .toString())
                                                                //         .toStringAsFixed(
                                                                //             2)
                                                                //         .replaceFirst(
                                                                //             RegExp(
                                                                //                 r'\.?0*$'),
                                                                //             '')
                                                                //     : "0";
                                                                checkValue = items.stockqty !=
                                                                            null ||
                                                                        items.stockqty !=
                                                                            ""
                                                                    ? double.parse(items
                                                                            .stockqty
                                                                            .toString())
                                                                        .toStringAsFixed(
                                                                            2)
                                                                        .replaceFirst(
                                                                            RegExp(
                                                                                r'\.?0*$'),
                                                                            '')
                                                                    : double.parse("0.0"
                                                                            .toString())
                                                                        .toStringAsFixed(
                                                                            2)
                                                                        .replaceFirst(
                                                                            RegExp(r'\.?0*$'),
                                                                            '');
                                                              }

                                                              return AlertDialog(
                                                                title: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Return Quantity",
                                                                        ),
                                                                        Text(
                                                                          "Balance Quantity: ${checkValue}",
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundColor: Colors
                                                                            .white
                                                                            .withOpacity(0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .cancel,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                content: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Form(
                                                                      key:
                                                                          _formkey,
                                                                      child:
                                                                          TextFormField(
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        autovalidateMode:
                                                                            AutovalidateMode.onUserInteraction,
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(
                                                                              RegExp(r'[0-9]')),
                                                                        ],
                                                                        validator:
                                                                            (value) {
                                                                          if (value!.length <
                                                                              1) {
                                                                            return "please enter quantity";
                                                                          } else if (double.parse(value) >
                                                                              double.parse(checkValue)) {
                                                                            return 'value is greater then Bal quantity';
                                                                          }

                                                                          return null;
                                                                        },
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        controller:
                                                                            orderController,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              'Qty',
                                                                          suffixIcon:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 8),
                                                                            child:
                                                                                Icon(
                                                                              Icons.edit,
                                                                              size: 16,
                                                                            ),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(borderSide: BorderSide(width: 1)),
                                                                          border:
                                                                              new OutlineInputBorder(
                                                                            borderSide:
                                                                                const BorderSide(width: 2.0),
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                          ),
                                                                          contentPadding:
                                                                              EdgeInsets.only(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          ElevatedButton(
                                                                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(kMainColor)),
                                                                              onPressed: () async {
                                                                                FocusScope.of(context).unfocus();
                                                                                if (_formkey.currentState!.validate()) {
                                                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                  await context.read<StoreOrderProvider>().StoreItemReturn(orderId: items.orderid, skuId: items.skuid, qty: orderController.text, skusid: items.skusid, openTime: items.rtvOpenTime, closeTime: items.rtvCloseTime);
                                                                                  context.read<StoreOrderProvider>().selectedQr == false ? await context.read<StoreOrderProvider>().returnStoreItemsApi(skuid: items.skuid, deliveryDate: context.read<StoreOrderProvider>().dateValue.toString(), loading: false, itemName: prefs.getString('searchReturnItem')) : context.read<StoreOrderProvider>().returnStoreItemsApi(deliveryDate: "", loading: false, skuid: context.read<StoreOrderProvider>().qrcode, itemName: "");
                                                                                  ;
                                                                                  // Navigator.pop(context);
                                                                                }
                                                                              },
                                                                              child: Text("Return Qty"))
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
                                                            border: Border.all(
                                                                color:
                                                                    kMainColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          "Return Qty +",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  color:
                                                                      kMainColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 1.0,
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