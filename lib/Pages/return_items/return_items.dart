// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Pages/return_items/items_serach.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../../StoreOrdering/Pages/MyOrders/storeItemsAcceptanace.dart';
import '../../StoreOrdering/StoreOrderingProvider/StoreOrderingProvider.dart';

class ReturnItemsPage extends StatefulWidget {
  const ReturnItemsPage({Key? key}) : super(key: key);

  @override
  State<ReturnItemsPage> createState() => _ReturnItemsPageState();
}

class _ReturnItemsPageState extends State<ReturnItemsPage> {
  @override
  void initState() {
    // context
    //     .read<StoreOrderProvider>()
    //     .getPastOrders(toDate: "", fromdate: "", searchText: "", orderNo: "");
    super.initState();
  }

  var _formkey = GlobalKey<FormState>();
  var formkey = GlobalKey<FormState>();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController orderController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final selectedOrder = context.watch<StoreOrderProvider>().invoiceDetails?.d;
    return WillPopScope(
      onWillPop: () {
        context.read<StoreOrderProvider>().invoiceDetails?.d = [];
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Customer Return Items",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 165,
                      child: Form(
                        key: formkey,
                        child: TextFormField(
                          cursorColor: kWhiteColor,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value!.length < 1 ? "Enter Phone number" : null,
                          textAlign: TextAlign.center,
                          controller: PhoneController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onChanged: (value) async {
                            if (value.length == 10) {
                              FocusScope.of(context).unfocus();
                              var response = await context
                                  .read<StoreOrderProvider>()
                                  .checkMobileNumber(
                                      mobileNumber: PhoneController.text);
                              if (response != "0") {
                                context
                                    .read<StoreOrderProvider>()
                                    .geInvoiceData(
                                        loading: true,
                                        orderNo: orderController.text,
                                        scanner: "",
                                        phoneNumber: PhoneController.text,
                                        itemName: "");
                              } else {
                                showMessage("Invalid Mobile Number");
                              }
                            }
                          },
                          // onEditingComplete: () async {
                          //   FocusScope.of(context).unfocus();
                          //   var response = await context
                          //       .read<StoreOrderProvider>()
                          //       .checkMobileNumber(
                          //           mobileNumber: PhoneController.text);
                          //   if (response != "0") {
                          //     context.read<StoreOrderProvider>().geInvoiceData(
                          //         loading: true,
                          //         orderNo: orderController.text,
                          //         scanner: "",
                          //         phoneNumber: PhoneController.text,
                          //         itemName: "");
                          //   } else {
                          //     showMessage("Invalid Mobile Number");
                          //   }
                          // },
                          decoration: InputDecoration(
                            hintText: "Phone number",
                            label: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "Phone Number",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: kWhiteColor,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: kWhiteColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(width: 1, color: kWhiteColor)),
                            border: new OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.0, color: kWhiteColor),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            contentPadding: EdgeInsets.only(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: kWhiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 165,
                      child: Form(
                        key: _formkey,
                        child: TextFormField(
                          cursorColor: kWhiteColor,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value!.length < 1 ? "Enter Order number" : null,
                          textAlign: TextAlign.center,
                          controller: orderController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onEditingComplete: () async {
                            FocusScope.of(context).unfocus();
                            await context
                                .read<StoreOrderProvider>()
                                .geInvoiceData(
                                    loading: true,
                                    orderNo: orderController.text,
                                    scanner: "",
                                    phoneNumber: PhoneController.text,
                                    itemName: "");
                          },
                          decoration: InputDecoration(
                            hintText: "Order number",
                            label: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "Order Number",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: kWhiteColor,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: kWhiteColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(width: 1, color: kWhiteColor)),
                            border: new OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.0, color: kWhiteColor),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            contentPadding: EdgeInsets.only(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: kWhiteColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton.icon(
                    //     style: ElevatedButton.styleFrom(
                    //         shape: RoundedRectangleBorder(
                    //             side: BorderSide(color: Colors.white),
                    //             borderRadius: BorderRadius.circular(15)),
                    //         backgroundColor: Colors.white.withOpacity(0)),
                    //     onPressed: () async {
                    //       searchOrderby(
                    //         context: context,
                    //         title: 'Search by Phone No.',
                    //         hint: 'Enter Phone No.',
                    //         phone: true,
                    //       );
                    //     },
                    //     icon: Icon(Icons.search),
                    //     label: Text('Search by phone')),
                    // Spacer(),
                    // ElevatedButton.icon(
                    //     style: ElevatedButton.styleFrom(
                    //         shape: RoundedRectangleBorder(
                    //             side: BorderSide(color: Colors.white),
                    //             borderRadius: BorderRadius.circular(15)),
                    //         backgroundColor: Colors.white.withOpacity(0)),
                    //     onPressed: () {
                    //       searchOrderby(
                    //           context: context,
                    //           title: 'Search by Order No.',
                    //           hint: 'Enter Order No.',
                    //           phone: false);
                    //     },
                    //     icon: Icon(Icons.search),
                    //     label: Text('Search by order')),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(70)),
        ),
        body: selectedOrder == null || selectedOrder.isEmpty
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Please Enter Phone Number or Order No. to get Item List",
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
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  showSearch(
                                      context: context, delegate: ItemSearch());
                                },
                                child: searchDesign(
                                  text: "Search Items",
                                  icon: Icons.search,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                  onTap: () async {
                                    try {
                                      final qrCode = await FlutterBarcodeScanner
                                          .scanBarcode('#ff6666', 'Cancel',
                                              true, ScanMode.BARCODE);
                                      print(
                                          "qr code data ${qrCode.toString()}");
                                      if (!mounted) return;
                                      if (qrCode != '-1') {
                                        context.read<StoreOrderProvider>().geInvoiceData(
                                            loading: true,
                                            orderNo: orderController.text,
                                            // context
                                            //             .read<
                                            //                 StoreOrderProvider>()
                                            //             .selectedPhone ==
                                            //         false
                                            //     ? context
                                            //         .read<StoreOrderProvider>()
                                            //         .phoneOrOrderNumber
                                            //     : "",
                                            scanner: qrCode,
                                            phoneNumber: PhoneController.text,
                                            // context
                                            //             .read<
                                            //                 StoreOrderProvider>()
                                            //             .selectedPhone ==
                                            //         true
                                            //     ? context
                                            //         .read<
                                            //             StoreOrderProvider>()
                                            //         .phoneOrOrderNumber
                                            //     : "",
                                            itemName: "");
                                      } else {
                                        print('cancel triggred');
                                      }
                                    } on PlatformException {
                                      print('Failed to scan QR Code.');
                                    }
                                  },
                                  child: searchDesign(
                                    text: "Scan Items",
                                    icon: Icons.qr_code,
                                  )),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  context.read<StoreOrderProvider>().geInvoiceData(
                                      loading: true,
                                      orderNo: orderController.text,
                                      // context
                                      //             .read<
                                      //                 StoreOrderProvider>()
                                      //             .selectedPhone ==
                                      //         false
                                      //     ? context
                                      //         .read<StoreOrderProvider>()
                                      //         .phoneOrOrderNumber
                                      //     : "",
                                      scanner: "",
                                      phoneNumber: PhoneController.text,
                                      // context
                                      //             .read<
                                      //                 StoreOrderProvider>()
                                      //             .selectedPhone ==
                                      //         true
                                      //     ? context
                                      //         .read<StoreOrderProvider>()
                                      //         .phoneOrOrderNumber
                                      //     : "",
                                      itemName: "");
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Icon(
                                      Icons.refresh,
                                      size: 20,
                                      color: kMainColor,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: kCardBackgroundColor,
                          thickness: 1.0,
                        ),
                        SizedBox(
                          height: 7.0,
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
                                            image: items.skuImage == null ||
                                                    items.skuImage == ""
                                                ? DecorationImage(
                                                    image: AssetImage(
                                                    'images/logos/not-available.png',
                                                  ))
                                                : DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            BaseUrl +
                                                                skuImges +
                                                                items.skuImage,
                                                            cacheKey:
                                                                items.skuImage),
                                                    onError: (exception,
                                                        stackTrace) {
                                                      items.skuImage = "";
                                                    },
                                                  )),
                                      ),
                                      title: Text(
                                        items.skuname.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Qty: ${double.parse(items.skuUnit).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          items.itemstatus == "2"
                                              ? Text(
                                                  "Item Replaced or may be Returned",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: kMainColor),
                                                )
                                              : Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        items.itemstatus == "2"
                                                            ? showMessage(
                                                                "Item Already Returned or May be Replaced")
                                                            : showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  var _formkey =
                                                                      GlobalKey<
                                                                          FormState>();
                                                                  TextEditingController
                                                                      orderController =
                                                                      TextEditingController();
                                                                  orderController
                                                                      .text = items.skuUnit !=
                                                                              null ||
                                                                          items.skuUnit !=
                                                                              ""
                                                                      ? double.parse(items
                                                                              .skuUnit
                                                                              .toString())
                                                                          .toStringAsFixed(
                                                                              2)
                                                                          .replaceFirst(
                                                                              RegExp(r'\.?0*$'),
                                                                              '')
                                                                      : "0";

                                                                  return AlertDialog(
                                                                    title: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Return Quantity",
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundColor:
                                                                                Colors.white.withOpacity(0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.cancel,
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    content:
                                                                        Column(
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
                                                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                            ],
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.length < 1) {
                                                                                return "please enter quantity";
                                                                              } else if (double.parse(value) > double.parse(items.skuUnit)) {
                                                                                return 'value is greater then quantity';
                                                                              }

                                                                              return null;
                                                                            },
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            controller:
                                                                                orderController,
                                                                            decoration:
                                                                                InputDecoration(
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
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              items.paymentmethod == "Cash"
                                                                                  ? ElevatedButton.icon(
                                                                                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                                                                                      onPressed: () async {
                                                                                        if (_formkey.currentState!.validate()) {
                                                                                          items.skuUnit = await orderController.text;
                                                                                          await context.read<StoreOrderProvider>().returnAndReplace(orderId: items.bOrderId, prtype: "2", refundType: "1", skuId: items.skuId, skuUnit: items.skuUnit, skusid: items.skusid);
                                                                                          await context.read<StoreOrderProvider>().geInvoiceData(loading: true, orderNo: orderController.text, scanner: "", phoneNumber: PhoneController.text, itemName: "");
                                                                                          Navigator.pop(context);
                                                                                        }
                                                                                      },
                                                                                      icon: Icon(Icons.money),
                                                                                      label: Text("Cash"))
                                                                                  : SizedBox.shrink(),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              ElevatedButton.icon(
                                                                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(kMainColor)),
                                                                                  onPressed: () async {
                                                                                    if (_formkey.currentState!.validate()) {
                                                                                      items.skuUnit = await orderController.text;

                                                                                      await context.read<StoreOrderProvider>().returnAndReplace(orderId: items.bOrderId, prtype: "2", refundType: "0", skuId: items.skuId, skuUnit: items.skuUnit, skusid: items.skusid);
                                                                                      await context.read<StoreOrderProvider>().geInvoiceData(loading: true, orderNo: orderController.text, scanner: "", phoneNumber: PhoneController.text, itemName: "");
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                  icon: Icon(Icons.wallet),
                                                                                  label: Text("Wallet"))
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
                                                          "Return",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        items.itemstatus == "2"
                                                            ? showMessage(
                                                                "Item Already Replaced or may be Returned")
                                                            : showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  var _formkey =
                                                                      GlobalKey<
                                                                          FormState>();
                                                                  TextEditingController
                                                                      orderController =
                                                                      TextEditingController();
                                                                  orderController
                                                                      .text = items.skuUnit !=
                                                                              null ||
                                                                          items.skuUnit !=
                                                                              ""
                                                                      ? double.parse(items
                                                                              .skuUnit
                                                                              .toString())
                                                                          .toStringAsFixed(
                                                                              2)
                                                                          .replaceFirst(
                                                                              RegExp(r'\.?0*$'),
                                                                              '')
                                                                      : "0";

                                                                  return AlertDialog(
                                                                    title: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "Replace Quantity",
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundColor:
                                                                                Colors.white.withOpacity(0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.cancel,
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    content:
                                                                        Column(
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
                                                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                            ],
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.length < 1) {
                                                                                return "please enter quantity";
                                                                              } else if (double.parse(value) > double.parse(items.skuUnit)) {
                                                                                return 'value is greater then quantity';
                                                                              }

                                                                              return null;
                                                                            },
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            controller:
                                                                                orderController,
                                                                            decoration:
                                                                                InputDecoration(
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
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              ElevatedButton.icon(
                                                                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.red)),
                                                                                  onPressed: () async {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  icon: Icon(Icons.cancel),
                                                                                  label: Text("Cancel")),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              ElevatedButton.icon(
                                                                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                                                                                  onPressed: () async {
                                                                                    if (_formkey.currentState!.validate()) {
                                                                                      items.skuUnit = await orderController.text;
                                                                                      await context.read<StoreOrderProvider>().returnAndReplace(orderId: items.bOrderId, prtype: "0", refundType: "", skuId: items.skuId, skuUnit: items.skuUnit, skusid: items.skusid);
                                                                                      await context.read<StoreOrderProvider>().geInvoiceData(loading: true, orderNo: orderController.text, scanner: "", phoneNumber: PhoneController.text, itemName: "");
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                  icon: Icon(Icons.done),
                                                                                  label: Text("Replace"))
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
                                                          "Replace",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                        ],
                                      ),
                                      trailing: Column(
                                        children: [
                                          Text(
                                            '₹ ${items.skuTotalAmt == null || items.skuTotalAmt == "" ? "" : double.parse(items.skuTotalAmt).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          Text(
                                            '₹ ${items.skuRate == null || items.skuRate == "" ? "" : double.parse(items.skuRate).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 1.0,
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
