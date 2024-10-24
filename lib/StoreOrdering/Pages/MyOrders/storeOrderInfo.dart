// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Components/custom_appbar.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/MyOrders/product_search.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/MyOrders/storeItemsAcceptanace.dart';

import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../StoreOrderingProvider/StoreOrderingProvider.dart';

class StoreOrderInfo extends StatefulWidget {
  @override
  _StoreOrderInfoState createState() => _StoreOrderInfoState();
}

class _StoreOrderInfoState extends State<StoreOrderInfo> {
  Future<void> _makePhoneCall(String url, scheme) async {
    try {
      await launchUrl(
        Uri(scheme: scheme, path: url),
      );
    } on Exception {
      throw 'Could not launch $url';
    }
  }

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
              tag: 'past_order_info',
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
                            width: MediaQuery.of(context).size.width * 0.77,
                            child: Text(
                              '${selectedItems!.customerName}',
                              overflow: TextOverflow.clip,
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
                                    selectedItems.mobileNo.toString(), 'tel');
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
                          context, 'Order Date:', selectedItems.orderDate),
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
                          '\₹ ${selectedItems.totalamount}'),
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
                              text: "Search Items",
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
      body: Stack(
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
                                                cacheKey: items.imagename!
                                                // fit: BoxFit.cover,
                                                ),
                                            onError: (exception, stackTrace) {
                                              items.imagename = null;
                                            },
                                          )),
                              ),
                              title: Text(
                                items.itemName.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w500),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Qty:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Text(
                                        '${items.qty == null || items.qty == "" ? "" : double.parse(items.qty!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color:
                                                    items.qty == items.delUnit
                                                        ? Colors.black
                                                        : Colors.red,
                                                decorationColor: Colors.black,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                decorationThickness: 3,
                                                decoration:
                                                    items.qty == items.delUnit
                                                        ? TextDecoration.none
                                                        : TextDecoration
                                                            .lineThrough),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      items.qty != items.delUnit
                                          ? Text(
                                              '${items.delUnit == null || items.delUnit == "" ? "" : double.parse(items.delUnit!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            )
                                          : Text("")
                                    ],
                                  ),
                                  SizedBox(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 2.0, left: 1.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                          'Rev On: ${items.Receivedon == null || items.Receivedon == "" ? "" : items.Receivedon!.replaceFirst(RegExp(r'\.?0*$'), '')}',
                                          // items.Receivedon.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.06,
                                              )),
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 2.0, left: 1.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                          'Rev By : ${items.Receivedby == null || items.Receivedby == "" ? "" : items.Receivedby!.replaceFirst(RegExp(r'\.?0*$'), '')}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.06,
                                              )),
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    '₹ ${items.totalamount == null || items.totalamount == "" ? "" : double.parse(items.totalamount!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '₹ ${items.itemRate == null || items.itemRate == "" ? "" : double.parse(items.itemRate!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
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
                        selectedItems.delcharge == "0" ||
                        selectedItems.delcharge == ""
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
        ],
      ),
    );
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
