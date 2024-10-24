// ignore_for_file: deprecated_member_use

import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/paymentselection.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../StoreOrderingProvider/store_product_provider.dart';

class DeliveryDetails extends StatefulWidget {
  DeliveryDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  @override
  void initState() {
    context.read<StoreOrderingProductProvider>().date = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().add(Duration(
            days: context.read<StoreOrderingProductProvider>().urgentDelivery ==
                    "1"
                ? 0
                : context
                                .read<StoreOrderingProductProvider>()
                                .proccedToCheckoutData!
                                .d![0]
                                .delday !=
                            null &&
                        context
                                .read<StoreOrderingProductProvider>()
                                .proccedToCheckoutData!
                                .d![0]
                                .delday !=
                            ""
                    ? int.parse(context
                        .read<StoreOrderingProductProvider>()
                        .proccedToCheckoutData!
                        .d![0]
                        .delday
                        .toString())
                    : 1)));

    print(context.read<StoreOrderingProductProvider>().date.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartitems =
        context.watch<StoreOrderingProductProvider>().cartitems?.d;
    final checkout = context.watch<StoreOrderingProductProvider>().cartTotal?.d;
    final proccedToCheckout =
        context.watch<StoreOrderingProductProvider>().proccedToCheckoutData?.d;

    return Scaffold(
      appBar: AppBar(
          title: Text("Delivery Details",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kWhiteColor))),
      body: WillPopScope(
        onWillPop: () async {
          await context
              .read<StoreOrderingProductProvider>()
              .resetUrgentDelivery();
          await context
              .read<StoreOrderingProductProvider>()
              .getcarttotal(orderType: 0);

          if (context.read<StoreOrderingProductProvider>().cartTotal?.d ==
              null) {
            await context.read<StoreOrderingProductProvider>().getcartitems();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('orderid', '');
            await context
                .read<StoreOrderingProductProvider>()
                .getProductsByCategory(
                    catId: prefs.getString('catId'),
                    sectionId: prefs.getString('sectionId'),
                    searchtxt: '');
          }
          return Future.value(true);
        },
        child: cartitems == null
            ? SizedBox.shrink()
            : Stack(children: [
                ListView(
                  children: [
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 6.7,
                    ),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Text("Payment Info".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: kDisabledColor, fontSize: 12)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.checklist,
                              color: kMainColor,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Sub Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                            Spacer(),
                            cartitems.isNotEmpty
                                ? Text(
                                    '\u{20B9} ${checkout?[0].posttaxamount}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )
                                : Text(
                                    '\u{20B9} 0',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  )
                          ]),
                    ),
                    checkout?[0].delcharge == null ||
                            checkout?[0].delcharge == "0.00" ||
                            checkout?[0].delcharge == "" ||
                            checkout?[0].delcharge == "0"
                        ? SizedBox.shrink()
                        : Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.delivery_dining,
                                      color: Colors.brown),
                                  SizedBox(width: 5),
                                  Text(
                                    'Delivery Charges',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  ),
                                  Spacer(),
                                  cartitems.isNotEmpty
                                      ? Text(
                                          '\u{20B9} ${checkout?[0].delcharge == null ? "0" : checkout?[0].delcharge}',
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
                                        )
                                ]),
                          ),
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 1.0,
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.money,
                              color: kMainColor,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Amount",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                            ),
                            Spacer(),
                            Text(
                              cartitems.isNotEmpty
                                  ? '\u{20B9} ${checkout?[0].subtotal}'
                                  : '\u{20B9} 0',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                    checkout?[0].couponamt == null ||
                            checkout?[0].couponamt == "0.00" ||
                            checkout?[0].couponamt == "0" ||
                            checkout?[0].couponamt == ""
                        ? SizedBox.shrink()
                        : Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    checkout![0].couponName ?? "Coupon",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  ),
                                  Spacer(),
                                  cartitems.isNotEmpty
                                      ? Text(
                                          '\u{20B9} ${checkout[0].couponamt == null ? "0" : checkout[0].couponamt}',
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
                    checkout?[0].dicountamt == null ||
                            checkout?[0].dicountamt == "0.00" ||
                            checkout?[0].dicountamt == "" ||
                            checkout?[0].dicountamt == "0"
                        ? SizedBox.shrink()
                        : Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.discount,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Discount',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  ),
                                  Spacer(),
                                  cartitems.isNotEmpty
                                      ? Text(
                                          ' ${checkout?[0].dicountper == null || checkout?[0].dicountper == "" ? "" : '@${checkout?[0].dicountper} %'} ',
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
                                  cartitems.isNotEmpty
                                      ? Text(
                                          '\u{20B9} ${checkout?[0].dicountamt == null ? "0" : checkout?[0].dicountamt}',
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
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.green,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Wallet',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                            Spacer(),
                            cartitems.isNotEmpty
                                ? Text(
                                    '\u{20B9} ${checkout?[0].walletamt}',
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
                                  )
                          ]),
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Pay Amount",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                            ),
                            Text(
                              cartitems.isNotEmpty
                                  ? '\u{20B9} ${checkout?[0].payamt}'
                                  : '\u{20B9} 0',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Icon(
                                Icons.savings_outlined,
                                color: Colors.pink[200],
                                size: 20,
                              ),
                            ),
                            Text(
                              'Savings',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                            Spacer(),
                            cartitems.isNotEmpty
                                ? Text(
                                    '\u{20B9} ${checkout?[0].savingamount}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontSize: 12),
                                  )
                                : Text(
                                    '\u{20B9} 0',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  )
                          ]),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 6.7,
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Text("Enter Delivery Info".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: kDisabledColor, fontSize: 12)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 1.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.pin_drop,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Delivery Location:',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 12),
                          ),
                          Spacer(),
                          Text(
                            proccedToCheckout != null
                                ? proccedToCheckout[0].location!
                                : "",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.blue,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Delivery Date:',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 12),
                          ),
                          Spacer(),
                          context
                                      .read<StoreOrderingProductProvider>()
                                      .urgentDelivery ==
                                  "1"
                              ? Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'images/account/calendar.png',
                                        height: 14,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        context
                                                .watch<
                                                    StoreOrderingProductProvider>()
                                                .date ??
                                            'Select Date',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    print(
                                        "calendar date ${context.read<StoreOrderingProductProvider>().calenderDate}");
                                    showDatePicker(
                                        helpText: "Select Delivery Date",
                                        context: context,
                                        initialEntryMode:
                                            DatePickerEntryMode.calendarOnly,
                                        initialDate: context
                                                    .read<
                                                        StoreOrderingProductProvider>()
                                                    .calenderDate ==
                                                null
                                            ? DateTime.now().add(Duration(
                                                days: proccedToCheckout![0].delday ==
                                                            null &&
                                                        proccedToCheckout[0].delday ==
                                                            ""
                                                    ? int.parse(proccedToCheckout[0]
                                                        .delday
                                                        .toString())
                                                    : 1))
                                            : context
                                                .read<StoreOrderingProductProvider>()
                                                .calenderDate!,
                                        firstDate: DateTime.now().add(Duration(days: int.parse(proccedToCheckout![0].delday.toString()))),
                                        lastDate: DateTime.now().add(Duration(days: 1 + int.parse(proccedToCheckout[0].maxDelDay.toString()))),
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
                                      context
                                          .read<StoreOrderingProductProvider>()
                                          .selectedDate(value);
                                      print(context
                                          .read<StoreOrderingProductProvider>()
                                          .date);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kMainColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'images/account/calendar.png',
                                          height: 14,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          context
                                                  .watch<
                                                      StoreOrderingProductProvider>()
                                                  .date ??
                                              'Select Date',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.edit,
                                          size: 12,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    proccedToCheckout![0].urDelTime != null &&
                            proccedToCheckout[0].urDelTime != ""
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20.0),
                            child: Row(
                              children: [
                                Icon(Icons.delivery_dining_sharp,
                                    color: Colors.green),
                                SizedBox(width: 5),
                                Text(
                                  'Urgent Delivery:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontSize: 12),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Switch(
                                      value: proccedToCheckout[0].urDel == "0"
                                          ? false
                                          : context
                                              .watch<
                                                  StoreOrderingProductProvider>()
                                              .switchData,
                                      onChanged: (value) async {
                                        if (proccedToCheckout[0].urDel == "1") {
                                          if (context
                                                  .read<
                                                      StoreOrderingProductProvider>()
                                                  .switchData ==
                                              true) {
                                            await context
                                                .read<
                                                    StoreOrderingProductProvider>()
                                                .changeSwitchStatus(false);
                                          } else {
                                            await context
                                                .read<
                                                    StoreOrderingProductProvider>()
                                                .changeSwitchStatus(true);
                                            if (checkout?[0].delcharge !=
                                                    null &&
                                                checkout?[0].delcharge !=
                                                    "0.00" &&
                                                checkout?[0].delcharge != "" &&
                                                checkout?[0].delcharge != "0") {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                      title: Text(
                                                          "Urgent Delivery"),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Rs ${checkout?[0].delcharge} will be added to your invoice for Urgent Delivery request. Would you like to continue?",
                                                          ),
                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          child: Text("Cancel"),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            textStyle: TextStyle(
                                                                color:
                                                                    kWhiteColor),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .redAccent)),
                                                          ),
                                                          onPressed: () async {
                                                            await context
                                                                .read<
                                                                    StoreOrderingProductProvider>()
                                                                .changeSwitchStatus(
                                                                    false);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        SizedBox(width: 5),
                                                        ElevatedButton(
                                                            child: Text(
                                                                "Continue"),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              textStyle: TextStyle(
                                                                  color:
                                                                      kWhiteColor),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .green)),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                            })
                                                      ],
                                                    );
                                                  });
                                            }
                                          }
                                        }
                                      },
                                      activeColor: kMainColor,
                                      inactiveTrackColor:
                                          Colors.grey.withOpacity(0.5),
                                      inactiveThumbColor: Colors.white,
                                    ),
                                    Text(
                                      proccedToCheckout[0].urDel == "0"
                                          ? "No"
                                          : context
                                                      .watch<
                                                          StoreOrderingProductProvider>()
                                                      .switchData ==
                                                  true
                                              ? "Yes"
                                              : "No",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    context
                                    .read<StoreOrderingProductProvider>()
                                    .proccedToCheckoutData!
                                    .d![0]
                                    .urDel ==
                                "1" &&
                            proccedToCheckout[0].urDelTime != null &&
                            proccedToCheckout[0].urDelTime != ""
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20.0),
                            child: Text(
                              "Urgent delivery time is before ${proccedToCheckout[0].urDelTime!}",
                              style: TextStyle(fontSize: 12, color: kMainColor),
                            ),
                          )
                        : SizedBox.shrink(),
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 6.7,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      BottomBar(
                          text: 'Checkout',
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            print(prefs.getString('store_Location'));
                            if (double.parse(
                                    proccedToCheckout[0].minimumbasket!) >=
                                double.parse(checkout![0].posttaxamount!)) {
                              showMessage(
                                  "Minimum Basket Value is ${proccedToCheckout[0].minimumbasket!}");
                            } else if (proccedToCheckout[0].kisanservStore ==
                                    "0" &&
                                proccedToCheckout[0].paymentStatus == "0") {
                              print("delivery option" +
                                  context
                                      .read<StoreOrderingProductProvider>()
                                      .urgentDelivery);
                              var response = await context
                                  .read<StoreOrderingProductProvider>()
                                  .checkout(
                                    delDate: context
                                        .read<StoreOrderingProductProvider>()
                                        .date,
                                    ordertype: context
                                        .read<StoreOrderingProductProvider>()
                                        .urgentDelivery,
                                  );
                              if (response == "0") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentSelection()));
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Are you sure?"),
                                      content: Text(
                                          "Are you sure want to place this order ?"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            textStyle:
                                                TextStyle(color: kWhiteColor),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.redAccent)),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        ElevatedButton(
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              textStyle:
                                                  TextStyle(color: kWhiteColor),
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.green)),
                                            ),
                                            onPressed: () async {
                                              var response = await context
                                                  .read<
                                                      StoreOrderingProductProvider>()
                                                  .checkout(
                                                      delDate: context
                                                          .read<
                                                              StoreOrderingProductProvider>()
                                                          .date,
                                                      ordertype:
                                                          proccedToCheckout[0]
                                                              .urDel);
                                              if (response == "0") {
                                                await context
                                                    .read<
                                                        StoreOrderingProductProvider>()
                                                    .checkOutOrderWithoutPay(
                                                        delDate: context
                                                            .read<
                                                                StoreOrderingProductProvider>()
                                                            .date,
                                                        ordertype: context
                                                            .read<
                                                                StoreOrderingProductProvider>()
                                                            .urgentDelivery,
                                                        ctx: context);
                                              }
                                            })
                                      ],
                                    );
                                  });
                            }
                          })
                    ],
                  ),
                ),
              ]),
      ),
    );
  }
}
