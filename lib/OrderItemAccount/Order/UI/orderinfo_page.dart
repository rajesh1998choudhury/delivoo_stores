// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/Components/custom_appbar.dart';
import 'package:delivoo_stores/Provider/OrderProvider.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class OrderInfo extends StatefulWidget {
  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
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
  void initState() {
    super.initState();
    if (mounted) return null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedOrder = context.watch<OrderProvider>().orderDetails?.d;
    final selectedItems = context.watch<OrderProvider>().selectedOrder;
    return WillPopScope(
      onWillPop: () async {
        context.read<OrderProvider>().packed = "";
        await context.read<OrderProvider>().getOrdersPeriodic();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(280.0),
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
                            Text(
                              '${selectedItems!.customerName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      fontSize: 15.3, letterSpacing: 0.07),
                            ),
                            selectedItems.mobileNo == null ||
                                    selectedItems.mobileNo == "" ||
                                    selectedItems.mobileNo == "null"
                                ? SizedBox.shrink()
                                : IconButton(
                                    icon: Icon(
                                      Icons.phone,
                                      color: kMainColor,
                                      size: 18.0,
                                    ),
                                    onPressed: () {
                                      _makePhoneCall(
                                          selectedItems.mobileNo.toString(),
                                          'tel');
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
                            double.parse(selectedItems.wt.toString())
                                    .toStringAsFixed(2)
                                    .replaceFirst(RegExp(r'\.?0*$'), '') +
                                " Kg"),
                        orderDetails(
                            context, 'Order No:', selectedItems.orderNo),
                        // selectedItems.deliveryCharge == null ||
                        //         selectedItems.deliveryCharge == "0.00"
                        //     ? SizedBox.shrink()
                        //     : orderDetails(context, 'Delivery Charge:',
                        //         '\Rs. ${selectedItems.deliveryCharge}'),
                        orderDetails(context, 'Order Value:',
                            '₹ ${selectedItems.totalamount}'),
                        orderDetails(
                            context,
                            'Payment Status:',
                            selectedItems.paymentStatus == "1"
                                ? "Paid"
                                : "Not Paid"),
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
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          final items = selectedOrder?[index];
                          return Column(
                            children: <Widget>[
                              ListTile(
                                leading: Container(
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    image: items!.imagename != null
                                        ? DecorationImage(
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
                                          )
                                        : DecorationImage(
                                            image: AssetImage(
                                              'images/logos/not-available.png',
                                            ),
                                          ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
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
                                          '₹ ${items.totalamount == null || items.totalamount == "" ? "" : double.parse(items.totalamount!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '₹ ${items.itemRate == null || items.itemRate == "" ? "" : double.parse(items.itemRate!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
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
                                      '${items.qty == null || items.qty == "" ? "" : double.parse(items.qty!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: 12,
                                              decoration: items.qty !=
                                                      items.delUnit
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                    ),
                                    SizedBox(width: 8),
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
                                    context
                                                .read<OrderProvider>()
                                                .selectedPage ==
                                            true
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: selectedItems
                                                              .orderStatus !=
                                                          "Packed and Ready"
                                                      ? () {
                                                          showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                var _formkey =
                                                                    GlobalKey<
                                                                        FormState>();
                                                                TextEditingController
                                                                    orderController =
                                                                    TextEditingController();
                                                                orderController
                                                                    .text = items.delUnit !=
                                                                            null ||
                                                                        items.delUnit !=
                                                                            ""
                                                                    ? double.parse(items
                                                                            .delUnit
                                                                            .toString())
                                                                        .toStringAsFixed(
                                                                            2)
                                                                        .replaceFirst(
                                                                            RegExp(r'\.?0*$'),
                                                                            '')
                                                                    : "0";

                                                                return AlertDialog(
                                                                  title: Text(
                                                                    "Update Quantity",
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
                                                                          validator:
                                                                              (value) {
                                                                            if (value!.length <
                                                                                1) {
                                                                              return "please enter quantity";
                                                                            } else if (double.parse(value) >
                                                                                double.parse(items.qty!)) {
                                                                              return 'value is greater then quantity';
                                                                            }
                                                                            // else if (double.parse(value) == double.parse(items.qty!)) {
                                                                            //   return 'please enter valid quantity';
                                                                            // }
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
                                                                              padding: const EdgeInsets.only(right: 8),
                                                                              child: Icon(
                                                                                Icons.edit,
                                                                                size: 16,
                                                                              ),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(borderSide: BorderSide(width: 1)),
                                                                            border:
                                                                                new OutlineInputBorder(
                                                                              borderSide: const BorderSide(width: 2.0),
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                            contentPadding:
                                                                                EdgeInsets.only(),
                                                                          ),
                                                                          // onChanged:
                                                                          //     (value) {
                                                                          //   if (value != "") {
                                                                          //     // items.delUnit = value;
                                                                          //     // context.read<OrderProvider>().chngeQuatity(
                                                                          //     //       index: index,
                                                                          //     //       quantity: value,
                                                                          //     //       orderid: selectedItems.orderid,
                                                                          //     //       productId: items.itemsubId,
                                                                          //     //     );
                                                                          //   }
                                                                          // },
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
                                                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                                                                                onPressed: () async {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(Icons.cancel),
                                                                                label: Text("Cancel")),
                                                                            ElevatedButton.icon(
                                                                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                                                                                onPressed: () async {
                                                                                  if (_formkey.currentState!.validate()) {
                                                                                    items.delUnit = await orderController.text;
                                                                                    await context.read<OrderProvider>().sortQuantity(
                                                                                          index: index,
                                                                                          delQty: items.delUnit != null || items.delUnit != "" ? double.parse(items.delUnit.toString()).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '') : "0",
                                                                                          orderid: selectedItems.orderid,
                                                                                          productId: items.itemsubId,
                                                                                        );

                                                                                    Navigator.pop(context);
                                                                                  }
                                                                                },
                                                                                icon: Icon(Icons.done),
                                                                                label: Text("ok")),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        }
                                                      : null,
                                                  icon: Icon(
                                                    Icons.edit,
                                                    size: 14.0,
                                                    color: Colors.grey,
                                                  )),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Switch(
                                                    value:
                                                        items.itemStatus != ""
                                                            ? true
                                                            : false,
                                                    onChanged: selectedItems
                                                                .orderStatus !=
                                                            "Packed and Ready"
                                                        ? (value) async {
                                                            await context
                                                                .read<
                                                                    OrderProvider>()
                                                                .changeSwitchStatus(
                                                                    index:
                                                                        index,
                                                                    value:
                                                                        value,
                                                                    orderid:
                                                                        selectedItems
                                                                            .orderid,
                                                                    productId: items
                                                                        .itemsubId,
                                                                    status: value !=
                                                                            false
                                                                        ? "1"
                                                                        : "0");
                                                          }
                                                        : null,
                                                  ),
                                                  Text(
                                                    items.itemStatus != ""
                                                        ? "Packed and Ready"
                                                        : "Not Packed",
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Container(),
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
                  context.read<OrderProvider>().selectedPage == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          selectedItems.orderStatus !=
                                                  "Packed and Ready"
                                              ? kMainColor
                                              : Colors.grey),
                                  onPressed: selectedItems.orderStatus !=
                                          "Packed and Ready"
                                      ? () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Are you sure?"),
                                                  content: Text(
                                                      "Are you sure want to mark all items as packed!"),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      child: Text(
                                                        'No',
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.green,
                                                          textStyle: TextStyle(
                                                              color:
                                                                  kWhiteColor),
                                                          shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .green))),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                    ElevatedButton(
                                                        child: Text(
                                                          'Yes',
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                          textStyle: TextStyle(
                                                              color:
                                                                  kWhiteColor),
                                                          shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .redAccent)),
                                                        ),
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  OrderProvider>()
                                                              .allPackingDone(
                                                                orderid:
                                                                    selectedItems
                                                                        .orderid,
                                                              );
                                                          Navigator.pop(
                                                              context);
                                                        })
                                                  ],
                                                );
                                              });
                                        }
                                      : null,
                                  icon: Icon(Icons.done, color: Colors.white),
                                  label: Text(
                                    "All Items Packed",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        )
                      : Container(),
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
                  selectedItems.couponamt == null ||
                          selectedItems.couponamt == "0.00" ||
                          selectedItems.couponamt == "0" ||
                          selectedItems.couponamt == ""
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
                  selectedItems.deliveryCharge == null ||
                          selectedItems.deliveryCharge == "0.00" ||
                          selectedItems.deliveryCharge == "0" ||
                          selectedItems.deliveryCharge == ""
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
                                  '₹ ${selectedItems.deliveryCharge != null ? selectedItems.deliveryCharge : "0.00"}',
                                  style: Theme.of(context).textTheme.bodySmall,
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
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Received by : ',
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 11.7,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.06,
                                    ),
                          ),
                        ],
                      )),
                  Divider(
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
            context.read<OrderProvider>().selectedPage == true
                ? selectedItems.orderStatus != "Packed and Ready" &&
                        selectedItems.orderStatus != "Out for Delivery" &&
                        context.watch<OrderProvider>().packed != "packed"
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            BottomBar(
                                text: 'Ready to Deliver',
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Are you sure?"),
                                          content: Text(
                                              "Are you sure want to mark as ready to deliver. if yes then you can\'t able to edit products again."),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                textStyle: TextStyle(
                                                    color: kWhiteColor),
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors.green)),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            ElevatedButton(
                                                child: Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  textStyle: TextStyle(
                                                      color: kWhiteColor),
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors
                                                              .redAccent)),
                                                ),
                                                onPressed:
                                                    selectedItems.deltype == "2"
                                                        ? () async {
                                                            await context.read<OrderProvider>().readyToPickUp(
                                                                orderid:
                                                                    selectedItems
                                                                        .orderid,
                                                                brandName: context
                                                                    .read<
                                                                        LoginProvider>()
                                                                    .brandName,
                                                                modelName: context
                                                                    .read<
                                                                        LoginProvider>()
                                                                    .deviceName);
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        : () async {
                                                            await context.read<OrderProvider>().readyToPickUp(
                                                                orderid:
                                                                    selectedItems
                                                                        .orderid,
                                                                brandName: context
                                                                    .read<
                                                                        LoginProvider>()
                                                                    .brandName,
                                                                modelName: context
                                                                    .read<
                                                                        LoginProvider>()
                                                                    .deviceName);
                                                            context
                                                                .read<
                                                                    OrderProvider>()
                                                                .packed = "";
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          })
                                          ],
                                        );
                                      });
                                })
                          ],
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            BottomBar(
                                color: selectedItems.orderStatus ==
                                        "Out for Delivery"
                                    ? Colors.orangeAccent
                                    : selectedItems.orderStatus ==
                                            "Packed and Ready"
                                        ? Colors.teal
                                        : Colors.green,
                                text: selectedItems.deltype == "2" ||
                                        context.watch<OrderProvider>().packed ==
                                            "packed"
                                    ? "Mark as Delivered"
                                    : selectedItems.deltype != "2" &&
                                            selectedItems.orderStatus ==
                                                "Packed and Ready"
                                        ? "Mark as Out for Delivery"
                                        : selectedItems.orderStatus,
                                onTap: selectedItems.deltype == "2"
                                    ? () async {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Are you sure?"),
                                                content: Text(
                                                    "Are you sure want to mark as InStore-Pickup is Delivered. if yes then you can\'t able to edit products again."),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: Text('No'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      textStyle: TextStyle(
                                                          color: kWhiteColor),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .green)),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  ElevatedButton(
                                                      child: Text(
                                                        'Yes',
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        textStyle: TextStyle(
                                                            color: kWhiteColor),
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .redAccent)),
                                                      ),
                                                      onPressed: () async {
                                                        await context
                                                            .read<
                                                                OrderProvider>()
                                                            .deliveryDone(
                                                                orderid:
                                                                    selectedItems
                                                                        .orderid,
                                                                brandName: context
                                                                    .read<
                                                                        LoginProvider>()
                                                                    .brandName,
                                                                modelName: context
                                                                    .read<
                                                                        LoginProvider>()
                                                                    .deviceName);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      })
                                                ],
                                              );
                                            });
                                      }
                                    : selectedItems.orderStatus ==
                                            "Out for Delivery"
                                        ? () {
                                            Navigator.pop(context);
                                          }
                                        : () async {
                                            await context
                                                .read<OrderProvider>()
                                                .sendOtpToDeliveryBoy(
                                                  selectedItems.orderid,
                                                );
                                            context
                                                .read<OrderProvider>()
                                                .setTimer();
                                            _timerFun(
                                              context: context,
                                              orderId: selectedItems.orderid,
                                            ).then(
                                              (value) => context
                                                  .read<OrderProvider>()
                                                  .timer!
                                                  .cancel(),
                                            );
                                          })
                          ],
                        ),
                      )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Future<dynamic> _timerFun({BuildContext? context, orderId}) {
    var _formkey = GlobalKey<FormState>();
    TextEditingController otpController = TextEditingController();
    return showDialog(
        barrierDismissible: false,
        context: context!,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Text(
                  "Verify order $orderId",
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ))
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formkey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.length < 1) {
                        return "please enter otp";
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    controller: otpController,
                    decoration: InputDecoration(
                      hintText: 'Verify Otp',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: kMainColor,
                        ),
                      ),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kMainColor, width: 1)),
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
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      context.watch<OrderProvider>().counter < 1
                          ? ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kMainColor,
                                  textStyle: TextStyle(color: Colors.white)),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                otpController.clear();
                                await context
                                    .read<OrderProvider>()
                                    .sendOtpToDeliveryBoy(
                                      orderId,
                                    );
                                context.read<OrderProvider>().setTimer();
                              },
                              icon: Icon(Icons.refresh, color: Colors.white),
                              label: Text(
                                "Resend Otp",
                                style: TextStyle(color: Colors.white),
                              ))
                          : Text(
                              '${context.watch<OrderProvider>().counter} sec',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: kMainColor),
                            ),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green)),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formkey.currentState!.validate()) {
                              var response = await context
                                  .read<OrderProvider>()
                                  .outForDelivery(
                                      orderid: orderId,
                                      otp: otpController.text,
                                      context: context,
                                      brandName: context
                                          .read<LoginProvider>()
                                          .brandName,
                                      modelName: context
                                          .read<LoginProvider>()
                                          .deviceName);
                              if (response == "Sucess") {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            }
                          },
                          icon: Icon(Icons.done, color: Colors.white),
                          label: Text(
                            "Verify",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ],
            ),
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
