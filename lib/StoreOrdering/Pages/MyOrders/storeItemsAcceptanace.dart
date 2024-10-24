// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/Components/custom_appbar.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/MyOrders/product_search.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../StoreOrderingProvider/StoreOrderingProvider.dart';

class StoreItemAcceptance extends StatefulWidget {
  @override
  _StoreItemAcceptanceState createState() => _StoreItemAcceptanceState();
}

class _StoreItemAcceptanceState extends State<StoreItemAcceptance> {
  Future<void> _makePhoneCall(String url, scheme) async {
    try {
      await launchUrl(
        Uri(scheme: scheme, path: url),
      );
    } on Exception {
      throw 'Could not launch $url';
    }
  }

  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void clearText() {
    _mobileController.clear();
    _otpController.clear();
  }

  late final String? mobileo;
  fk() => _formKey;
  int? m_no;
  bool isOTPSuccess = false;
  String? message;

  @override
  Widget build(BuildContext context) {
    final selectedOrder = context.watch<StoreOrderProvider>().orderDetails?.d;
    final selectedItems = context.watch<StoreOrderProvider>().selectedOrder;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(310.0),
        child: CustomAppBar(
          leading: null,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: Hero(
              tag: 'Customer',
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: ListTile(
                  title: Column(
                    children: [
                      Text(
                        'Order Details',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                fontSize: 15,
                                letterSpacing: 0.07,
                                color: kMainColor),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Text(
                              '${selectedItems?.customerName.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      fontSize: 15.3, letterSpacing: 0.07),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: kMainColor,
                              size: 18.0,
                            ),
                            onPressed: () {
                              setState(() {
                                _makePhoneCall(
                                    selectedItems!.mobileNo.toString(), 'tel');
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderDetails(
                          context, 'Order Date:', selectedItems!.orderDate),
                      orderDetails(
                          context, 'Total Products:', selectedItems.qty),
                      orderDetails(
                          context,
                          'Order Weight:',
                          selectedItems.wt == null || selectedItems.wt == ""
                              ? ""
                              : double.parse(selectedItems.wt.toString())
                                      .toStringAsFixed(2)
                                      .replaceFirst(RegExp(r'\.?0*$'), '') +
                                  " Kg"),
                      orderDetails(context, 'Order No:', selectedItems.orderNo),
                      orderDetails(context, 'Order Value:',
                          '₹ ${selectedItems.totalamount}'),
                      orderDetails(
                          context,
                          'Payment Status:',
                          selectedItems.paymentStatus == "1"
                              ? "Paid"
                              : "Not Paid"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showSearch(
                                  context: context,
                                  delegate: ProductSearch(
                                      orderId: selectedItems.orderid));
                            },
                            child: searchDesign(
                              text: "search Items",
                              icon: Icons.search,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () async {
                                try {
                                  final qrCode =
                                      await FlutterBarcodeScanner.scanBarcode(
                                          '#ff6666',
                                          'Cancel',
                                          true,
                                          ScanMode.BARCODE);

                                  if (!mounted) return;

                                  if (qrCode != '-1') {
                                    context
                                        .read<StoreOrderProvider>()
                                        .getOrderDetailsByName(
                                            loading: true,
                                            orderid: selectedItems.orderid,
                                            action: "2",
                                            itemId: qrCode,
                                            itemName: "");
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
                              await context
                                  .read<StoreOrderProvider>()
                                  .getOrderDetails(selectedItems.orderid);
                            },
                            child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.refresh,
                                  size: 20,
                                  color: kMainColor,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: kMainColor,
        onRefresh: () async {
          await context
              .read<StoreOrderProvider>()
              .getOrderDetails(selectedItems.orderid);
        },
        child: Stack(
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
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
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
                        itemCount: selectedOrder?.length ?? 0,
                        itemBuilder: (context, index) {
                          final items = selectedOrder?[index];
                          return Column(
                            children: <Widget>[
                              ListTile(
                                leading: Container(
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                      image: items!.imagename == null ||
                                              items.imagename == ""
                                          ? DecorationImage(
                                              image: AssetImage(
                                              'images/logos/not-available.png',
                                            ))
                                          : DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  BaseUrl +
                                                      skuImges +
                                                      items.imagename!,
                                                  cacheKey: items.imagename
                                                  // fit: BoxFit.cover,
                                                  ),
                                              onError: (exception, stackTrace) {
                                                items.imagename = null;
                                              },
                                            )),
                                ),
                                title: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        items.itemName.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          items.totalamount == null ||
                                                  items.totalamount == ""
                                              ? "0.0"
                                              : '₹ ${double.parse(items.totalamount!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          items.itemRate == null ||
                                                  items.itemRate == ""
                                              ? ""
                                              : '₹ ${double.parse(items.itemRate!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Qty:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${items.qty == null || items.qty == "" ? "" : double.parse(items.qty.toString()).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: items.qty == items.delUnit
                                                  ? Colors.black
                                                  : Colors.red,
                                              decorationColor: Colors.black,
                                              decorationStyle:
                                                  TextDecorationStyle.solid,
                                              decorationThickness: 3,
                                              decoration: items.qty ==
                                                      items.delUnit
                                                  ? TextDecoration.none
                                                  : TextDecoration.lineThrough),
                                    ),
                                    SizedBox(width: 5),
                                    items.delUnit != items.qty
                                        ? Text(
                                            '${items.delUnit == null || items.delUnit == "" ? "" : double.parse(items.delUnit!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          )
                                        : Text(""),
                                    IconButton(
                                        onPressed:
                                            items.itemStatus == "1" ||
                                                    items.itemStatus == "2" ||
                                                    items.unAvailable == "4"
                                                ? () {
                                                    showMessage(items
                                                                .unAvailable ==
                                                            "4"
                                                        ? "This item is Unavailable"
                                                        : "Can't edit this item as you marked as received.");
                                                  }
                                                : () {
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
                                                          orderController
                                                              .text = items
                                                                          .delUnit !=
                                                                      null ||
                                                                  items.delUnit !=
                                                                      ""
                                                              ? double.parse(items
                                                                      .delUnit
                                                                      .toString())
                                                                  .toStringAsFixed(
                                                                      2)
                                                                  .replaceFirst(
                                                                      RegExp(
                                                                          r'\.?0*$'),
                                                                      '')
                                                              : "0";

                                                          return AlertDialog(
                                                            title: Text(
                                                              "Update Quantity",
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
                                                                              .qty!)) {
                                                                        return 'value is greater then quantity';
                                                                      } else if (double.parse(
                                                                              value) ==
                                                                          double.parse(
                                                                              items.qty!)) {
                                                                        return 'value is equal to the quantity';
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
                                                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                                                                          onPressed: () async {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          icon: Icon(Icons.cancel, color: Colors.white),
                                                                          label: Text(
                                                                            "Cancel",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                      ElevatedButton.icon(
                                                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                                                                          onPressed: () async {
                                                                            if (_formkey.currentState!.validate()) {
                                                                              items.delUnit = await orderController.text;
                                                                              await context.read<StoreOrderProvider>().sortQuantity(
                                                                                    index: index,
                                                                                    delQty: items.delUnit != null || items.delUnit != "" ? double.parse(items.delUnit.toString()).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '') : "0",
                                                                                    orderid: selectedItems.orderid,
                                                                                    productId: items.itemsubId,
                                                                                  );
                                                                              Navigator.pop(context);
                                                                            }
                                                                          },
                                                                          icon: Icon(Icons.done, color: Colors.white),
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
                                        icon: Icon(
                                          Icons.edit,
                                          size: 14.0,
                                          color: Colors.grey,
                                        )),
                                    Column(
                                      children: [
                                        Switch(
                                          value: items.itemStatus != ""
                                              ? true
                                              : false,
                                          onChanged: (value) async {
                                            items.itemStatus != "2"
                                                ? context
                                                    .read<StoreOrderProvider>()
                                                    .changeSwitchStatus(
                                                        index: index,
                                                        value: value,
                                                        orderid: selectedItems
                                                            .orderid,
                                                        productId:
                                                            items.itemsubId,
                                                        status: value != false
                                                            ? "1"
                                                            : "0")
                                                : showMessage(
                                                    "Can't change, as you marked as received");
                                            ;
                                          },
                                          activeColor: kMainColor,
                                          inactiveTrackColor:
                                              Colors.grey.withOpacity(0.5),
                                          inactiveThumbColor: Colors.white,
                                        ),
                                        Text(
                                          items.itemStatus != ""
                                              ? "Received"
                                              : "Not Received",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 10, right: 10),
                  //       child: ElevatedButton.icon(
                  //           style: ElevatedButton.styleFrom(primary: kMainColor),
                  //           onPressed: () async {
                  //             context
                  //                 .read<StoreOrderProvider>()
                  //                 .allItemReceivedDone(
                  //                     orderid: selectedItems.orderid);
                  //           },
                  //           icon: Icon(Icons.done),
                  //           label: Text("All Items Received")),
                  //     ),
                  //   ],
                  // ),
                  Divider(
                    color: kCardBackgroundColor,
                    thickness: 8.0,
                  ),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Text('Payment Info',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: kDisabledColor,
                                fontWeight: FontWeight.bold)),
                    color: Colors.white,
                  ),
                  selectedItems.delcharge == null ||
                          selectedItems.delcharge == "0.00" ||
                          selectedItems.delcharge == "" ||
                          selectedItems.delcharge == "0"
                      ? SizedBox.shrink()
                      : Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Delivery Charges",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  '₹ ${selectedItems.delcharge != null ? selectedItems.delcharge : "0.00"}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ]),
                        ),
                  selectedItems.couponamt == null ||
                          selectedItems.couponamt == "0.00" ||
                          selectedItems.couponamt == "" ||
                          selectedItems.couponamt == "0"
                      ? SizedBox.shrink()
                      : Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  selectedItems.couponName.toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  '₹ ${selectedItems.couponamt != null ? selectedItems.couponamt : "0.00"}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ]),
                        ),
                  selectedItems.disamt == null ||
                          selectedItems.disamt == "0.00" ||
                          selectedItems.disamt == "" ||
                          selectedItems.disamt == "0"
                      ? SizedBox.shrink()
                      : Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Discount',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontSize: 12),
                                ),
                                Spacer(),
                                selectedItems.disamt!.isNotEmpty
                                    ? Text(
                                        ' ${selectedItems.disper == null || selectedItems.disper == "" ? "" : '@${selectedItems.disper} %'} ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 12),
                                      )
                                    : Text(
                                        '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 12),
                                      ),
                                SizedBox(
                                  width: 20,
                                ),
                                selectedItems.disamt!.isNotEmpty
                                    ? Text(
                                        '\u{20B9} ${selectedItems.disamt == null ? "0" : selectedItems.disamt}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 12),
                                      )
                                    : Text(
                                        '\u{20B9} 0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 12),
                                      ),
                              ]),
                        ),

                  Container(
                    color: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Sub Total',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '₹ ${selectedItems.totalamount}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ]),
                  ),
                  Divider(
                    color: kCardBackgroundColor,
                    thickness: 1.0,
                  ),
                  Container(
                    color: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Paid',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kMainColor),
                          ),
                          Text(
                            '₹ ${selectedItems.totalamount}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ]),
                  ),
                  Divider(
                    color: kCardBackgroundColor,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  Container(
                    height: 180.0,
                    color: kCardBackgroundColor,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  BottomBar(
                      text: 'Mark Order Status as "Delivered"',
                      onTap: () async {
                        _mobileController.text = "";
                        // showLoading();
                        _showMobileNumberDialog();
                        // Navigator.pop(context);
                        // await showDialog(
                        //     context: context,
                        //     barrierDismissible: false,
                        //     builder: (
                        //       BuildContext context,
                        //     ) {
                        //       return AlertDialog(
                        //           key: _formKey,
                        //           title: Text("Enter Mobile Number"),
                        //           content: TextFormField(
                        //             controller: _mobileController,
                        //             keyboardType: TextInputType.phone,
                        //             readOnly: false,
                        //             maxLength: 10,
                        //             decoration: InputDecoration(
                        //               border: InputBorder.none,
                        //               labelText: "Enter 10 Digit Number",
                        //             ),
                        //             validator: (value) {
                        //               if (value == null || value.isEmpty) {
                        //                 return 'Please Enter Mobile Number';
                        //               } else if (value.length < 10 ||
                        //                   value.startsWith(RegExp(r'[0]'))) {
                        //                 return 'Invalid Mobile Number';
                        //               }
                        //               return null;
                        //             },
                        //           ),
                        //           actions: <Widget>[
                        //             // ElevatedButton(
                        //             //     child: Text(
                        //             //       'Cancel',
                        //             //     ),
                        //             //     style: ElevatedButton.styleFrom(
                        //             //       backgroundColor: Colors.green,
                        //             //       textStyle:
                        //             //           TextStyle(color: kWhiteColor),
                        //             //       shape: RoundedRectangleBorder(
                        //             //           side: BorderSide(
                        //             //               color: Colors.green)),
                        //             //     ),
                        //             //     onPressed: () =>
                        //             //         Navigator.pop(context)),
                        //             ElevatedButton(
                        //                 child: Text(
                        //                   'Send OTP',
                        //                 ),
                        //                 style: ElevatedButton.styleFrom(
                        //                   backgroundColor: Colors.green,
                        //                   textStyle:
                        //                       TextStyle(color: kWhiteColor),
                        //                   shape: RoundedRectangleBorder(
                        //                       side: BorderSide(
                        //                           color: Colors.green)),
                        //                 ),
                        //                 onPressed: () async {
                        //                   // if (_formKey.currentState!.validate())
                        //                   await context
                        //                       .read<StoreOrderProvider>()
                        //                       .sendOtpRecItems(
                        //                           _mobileController.text);
                        //                   showDialog(
                        //                       context: context,
                        //                       barrierDismissible: false,
                        //                       builder: (BuildContext context) {
                        //                         return AlertDialog(
                        //                             title: Text("Enter OTP "),
                        //                             content: TextField(
                        //                               controller:
                        //                                   _otpController,
                        //                               decoration:
                        //                                   InputDecoration(
                        //                                       labelText:
                        //                                           'Enter OTP'),
                        //                               //                           validator: (value) {
                        //                               //   if (value == null ||value.isEmpty) {
                        //                               //     return 'Please enter the otp';
                        //                               //   }
                        //                               //   if (value.length < 6 ||
                        //                               //       value.startsWith(RegExp(r'[0]'))) {
                        //                               //     return 'Invalid Mobile Number';
                        //                               //   }
                        //                               //   return null;
                        //                               // },
                        //                               keyboardType:
                        //                                   TextInputType.number,
                        //                               inputFormatters: [
                        //                                 FilteringTextInputFormatter
                        //                                     .digitsOnly,
                        //                                 LengthLimitingTextInputFormatter(
                        //                                     6),
                        //                               ],
                        //                             ),
                        //                             actions: <Widget>[
                        //                               ElevatedButton(
                        //                                   child: Text(
                        //                                     'Verify OTP',
                        //                                   ),
                        //                                   style: ElevatedButton
                        //                                       .styleFrom(
                        //                                     backgroundColor:
                        //                                         Colors.red,
                        //                                     textStyle: TextStyle(
                        //                                         color:
                        //                                             kWhiteColor),
                        //                                     shape:
                        //                                         RoundedRectangleBorder(
                        //                                       side: BorderSide(
                        //                                           color: Colors
                        //                                               .red),
                        //                                     ),
                        //                                   ),
                        //                                   onPressed: () async {
                        //                                     // if (_formKey
                        //                                     //     .currentState!
                        //                                     //     .validate())
                        //                                     context
                        //                                         .read<
                        //                                             StoreOrderProvider>()
                        //                                         .verifyOtpStore(
                        //                                           _otpController
                        //                                               .text,
                        //                                           _mobileController
                        //                                               .text,
                        //                                         );
                        //                                     Navigator.pop(
                        //                                         context);
                        //                                   }),
                        //                             ]);
                        //                       });
                        //                 }),
                        //           ]);
                        //     });
                        // await showDialog(
                        //     context: context,
                        //     barrierDismissible: false,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         title: Text("Are you sure?"),
                        //         content: Text(
                        //             'Are you sure want to mark order status as "Delivered". if yes then you can\'t able to edit products again.'),
                        //         actions: <Widget>[
                        //           ElevatedButton(
                        //             child: Text(
                        //               'No',
                        //             ),
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor: Colors.green,
                        //               textStyle: TextStyle(color: kWhiteColor),
                        //               shape: RoundedRectangleBorder(
                        //                   side:
                        //                       BorderSide(color: Colors.green)),
                        //             ),
                        //             onPressed: () => Navigator.pop(context),
                        //           ),
                        //           ElevatedButton(
                        //               child: Text(
                        //                 'Yes',
                        //               ),
                        //               style: ElevatedButton.styleFrom(
                        //                 backgroundColor: Colors.redAccent,
                        //                 textStyle:
                        //                     TextStyle(color: kWhiteColor),
                        //                 shape: RoundedRectangleBorder(
                        //                     side: BorderSide(
                        //                         color: Colors.redAccent)),
                        //               ),
                        //               onPressed: () async {
                        //                 await context
                        //                     .read<StoreOrderProvider>()
                        //                     .allItemReceivedDone(
                        //                         orderid: selectedItems.orderid,
                        //                         mobiles: '');
                        //                 Navigator.pop(context);
                        //                 Navigator.pop(context);
                        //                 Navigator.pop(context);
                        //               })
                        //         ],
                        //       );
                        //     });
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showMobileNumberDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (
          BuildContext context,
        ) {
          return AlertDialog(
              key: _formKey,
              title: Text("Enter Mobile Number"),
              content: TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                readOnly: false,
                maxLength: 10,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Enter 10 Digit Number",
                    counterText: ''),
                onChanged: (value) async {
                  context.read<StoreOrderProvider>().isnumselected = false;
                  if (value.indexOf('1') == 0) {
                    setState(() {
                      m_no = 11;
                    });
                  } else
                    setState(() {
                      m_no = 10;
                    });
                  print(m_no);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Mobile Number';
                  } else if (value.length < 10 ||
                      value.startsWith(RegExp(r'[0]'))) {
                    return 'Invalid Mobile Number';
                  }
                  return null;
                },
              ),
              actions: <Widget>[
                // ElevatedButton(
                //     child: Text(
                //       'Cancel',
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.green,
                //       textStyle:
                //           TextStyle(color: kWhiteColor),
                //       shape: RoundedRectangleBorder(
                //           side: BorderSide(
                //               color: Colors.green)),
                //     ),
                //     onPressed: () =>
                //         Navigator.pop(context)),
                ElevatedButton(
                    child: Text(
                      'Send OTP',
                      style: TextStyle(color: kWhiteColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: TextStyle(color: kWhiteColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.green)),
                    ),
                    onPressed: () async {
                      if (_mobileController.text == '') {
                        "Enter Mobile Number";
                      } else if (_mobileController.text.length != 10) {
                        "Invalid Mobile Number";
                      } else {
                        var flag = await context
                            .read<StoreOrderProvider>()
                            .sendOtpRecItems(_mobileController.text);
                        _otpController.text = "";
                        if (flag == true) {
                          Navigator.pop(context);
                          _showOtpDialog();
                        }
                      }
                    }),
              ]);
        });
  }

  void _showOtpDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Enter OTP "),
              content: TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(color: kWhiteColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(color: kWhiteColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                    onPressed: () async {
                      if (_otpController.text == '') {
                        "Enter 6 digit Otp";
                      } else if (_otpController.text.length != 6) {
                        "Invalid Otp";
                      } else {
                        var flag = await context
                            .read<StoreOrderProvider>()
                            .verifyOtpStore(_mobileController.text,
                                _otpController.text, context);
                        print('${flag}');
                        if (flag == true) {
                          Navigator.pop(context);
                          _showPopDialog();
                        }
                      }
                    }),
              ]);
        });
  }

  void _showPopDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final selectedItems =
              context.watch<StoreOrderProvider>().selectedOrder;
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
                'Are you sure want to mark order status as "Delivered". if yes then you can\'t able to edit products again.'),
            actions: <Widget>[
              ElevatedButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: kWhiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: TextStyle(color: kWhiteColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.green)),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                  }),
              ElevatedButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: kWhiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    textStyle: TextStyle(color: kWhiteColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.redAccent)),
                  ),
                  onPressed: () async {
                    await context
                        .read<StoreOrderProvider>()
                        .allItemReceivedDone(
                          orderid: selectedItems!.orderid,
                          mobiles: _mobileController.text,
                        );
                    Navigator.pop(context);
                    Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Row orderDetails(BuildContext context, text, selectedOrder) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 14, letterSpacing: 0.06, color: kTextColor),
        ),
        Text(
          '${selectedOrder}',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontSize: 14, letterSpacing: 0.06, color: kTextColor),
        ),
      ],
    );
  }
}

class searchDesign extends StatelessWidget {
  final text;
  final icon;
  final colors;
  final width;
  final iconSize;
  final height;
  final textboxWidth;
  const searchDesign(
      {Key? key,
      this.text,
      this.icon,
      this.colors,
      this.width,
      this.iconSize,
      this.height,
      this.textboxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? width : MediaQuery.of(context).size.width * 0.35,
      height: height != null ? height : 40,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(
              color: colors != null ? colors : Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: textboxWidth != null ? textboxWidth : 82,
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: colors != null ? colors : Colors.black,
                    fontSize: 12)),
          ),
          Icon(
            icon,
            size: iconSize != null ? iconSize : 20,
            color: colors != null ? colors : Colors.black,
          ),
        ],
      ),
    );
  }
}
