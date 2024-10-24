// ignore_for_file: must_be_immutable, unused_local_variable, deprecated_member_use

import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';

import '../../../Utils/CommonWidget.dart';
import '../../StoreOrderingProvider/StoreOrderingProvider.dart';
import '../../StoreOrderingProvider/paylaterProvider.dart';
import 'order_sucess_for_payLater.dart';

class PayLaterScreen extends StatefulWidget {
  String orderId;

  PayLaterScreen(
    this.orderId,
  );

  @override
  _PayLaterScreenState createState() => _PayLaterScreenState();
}

class _PayLaterScreenState extends State<PayLaterScreen> {
  var _razorpay = Razorpay();
  var orderDetails;
  // late PayUCheckoutProFlutter _checkoutPro;
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // _checkoutPro = PayUCheckoutProFlutter(this);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Success: " + response.paymentId.toString());
    print("Payment orderid: " + response.orderId.toString());
    print("Payment signature: " + response.signature.toString());
    var result = await context
        .read<PayLaterProvider>()
        .getrazorpayLaterReply(response.paymentId, context);
    if (result == "success") {
      Navigator.pop(context);
      context.read<PayLaterProvider>().pageIndex == 0
          ? await context.read<StoreOrderProvider>().getOrders()
          : await context.read<StoreOrderProvider>().getPastOrders(
              toDate: "", fromdate: "", searchText: "", orderNo: "");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    await context.read<PayLaterProvider>().razorpayLaterfail();
    //  Navigator.pop(context);
    showMessage('Payment Failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: " + response.walletName.toString());
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  int? group;
  @override
  Widget build(BuildContext context) {
    final checkout =
        context.watch<PayLaterProvider>().getCartToalForPayLater?.d;
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment Selection',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white)),
        ),
        body: Stack(children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    color: Theme.of(context).cardColor,
                    thickness: 1.0,
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Pay Amount",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          // double.parse(checkout![0].posttaxamount!) >
                          //         double.parse(checkout[0].walletamt.toString())
                          //     ? Text(
                          //         '\u{20B9} ${double.parse(checkout[0].posttaxamount!) - double.parse(checkout[0].walletamt.toString())}',
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .caption!
                          //             .copyWith(
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 18),
                          //       )
                          //     :
                          Text(
                            '\u{20B9} ${double.parse(checkout![0].payamt!)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ]),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Using Wallet amount : \u{20B9} ',
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                        Text(
                          double.parse(checkout[0].posttaxamount!) >=
                                  double.parse(checkout[0].walletamt.toString())
                              ? checkout[0].walletamt == ''
                                  ? '0'
                                  : checkout[0].walletamt.toString()
                              : (double.parse(checkout[0].payamt!)).toString(),
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1.0,
                  ),
                  double.parse(checkout[0].posttaxamount!) >
                          double.parse(checkout[0].walletamt.toString())
                      ? ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Select a payment option to proceed',
                                style: TextStyle(
                                    fontSize: 20, letterSpacing: 0.005),
                              ),
                            ),
                            SizedBox(height: 20),
                            RadioListTile(
                                tileColor: Theme.of(context).cardColor,
                                selectedTileColor: Colors.red,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: /* Image.asset('images/logos/Razorpay_logo.png',
                          scale: 20, alignment: Alignment.centerLeft), */
                                    Text(
                                  'Debit Card/Credit Card/ATM Card',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                subtitle: Image.asset('images/logos/all.png',
                                    scale: 1,
                                    alignment: Alignment.centerLeft,
                                    height: 70),
                                value: 1,
                                groupValue: group,
                                onChanged: (value) {
                                  setState(() {
                                    group = value;
                                  });
                                }),
                            Divider(
                              color: Theme.of(context).cardColor,
                              thickness: 1.0,
                            ),
                            RadioListTile(
                                tileColor: Theme.of(context).cardColor,
                                selectedTileColor: Colors.red,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Image.asset('images/logos/upi.png',
                                    scale: 1,
                                    alignment: Alignment.centerLeft,
                                    height: 40),
                                value: 2,
                                groupValue: group,
                                onChanged: (value) {
                                  setState(() {
                                    group = value;
                                  });
                                }),
                            Divider(
                              color: Theme.of(context).cardColor,
                              thickness: 1.0,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: BottomBar(
                  onTap: () async {
                    if (double.parse(checkout[0].posttaxamount!) >
                        double.parse(checkout[0].walletamt.toString())) {
                      if (group == 1) {
                        paymentGatewaySelection(
                            context,
                            "Select Payment Gateway for Card Payment",
                            checkout);
                        // var res = await context
                        //     .read<PayLaterProvider>()
                        //     .getrazorpayIdforPayLater(
                        //         widget.orderId,
                        //         double.parse(
                        //                     checkout[0].walletamt.toString()) !=
                        //                 0
                        //             ? '1'
                        //             : '0');
                        // print(context.read<PayLaterProvider>().razorpayId);
                        // if (res == "orderId") {
                        //   var options = {
                        //     'key': rzrpy,
                        //     'amount': (double.parse(
                        //             '${double.parse(checkout[0].payamt!)}') *
                        //         100),
                        //     //in the format of paise: eg. "500" = Rs 5.00
                        //     'name': 'KisanServ',
                        //     'order_id':
                        //         context.read<PayLaterProvider>().razorpayId,
                        //     //'order_9A33XWu170gUtm',
                        //     //Generate order_id using Orders API
                        //     'description':
                        //         'Payment for ${context.read<PayLaterProvider>().transId}',
                        //     'timeout': 300,
                        //     // time in seconds to timeout
                        //     'prefill': {
                        //       'contact': prefs.getString('mob_no'),
                        //       'email': context
                        //           .read<PayLaterProvider>()
                        //           .email
                        //           .toString()
                        //     },
                        //     "notify": {"sms": true, "email": false},
                        //     "method": {
                        //       "netbanking": true,
                        //       "card": true,
                        //       "upi": false,
                        //       "wallet": false,
                        //       "emi": false,
                        //       "paylater": false
                        //     }
                        //   };
                        //   _razorpay.open(
                        //     options,
                        //   );
                        // }
                      } else if (group == 2) {
                        paymentGatewaySelection(context,
                            "Select Payment Gateway for UPI Payment", checkout);
                        // var res = await context
                        //     .read<PayLaterProvider>()
                        //     .getrazorpayIdforPayLater(
                        //         widget.orderId,
                        //         double.parse(
                        //                     checkout[0].walletamt.toString()) !=
                        //                 0
                        //             ? '1'
                        //             : '0');
                        // if (res == "orderId") {
                        //   var options = {
                        //     'key': rzrpy,
                        //     //'key': rzrpy_TEST,
                        //     'amount': (double.parse(
                        //             '${double.parse(checkout[0].payamt!)}') *
                        //         100),
                        //     //in the format of paise: eg. "500" = Rs 5.00ss
                        //     'name': 'KisanServ',
                        //     'order_id':
                        //         context.read<PayLaterProvider>().razorpayId,
                        //     // 'order_9A33XWu170gUtm',
                        //     //Generate order_id using Orders API
                        //     'description':
                        //         'Payment for ${context.read<PayLaterProvider>().transId} ',
                        //     'timeout': 300,
                        //     // time in seconds to timeout
                        //     'prefill': {
                        //       'contact': prefs.getString('mob_no'),
                        //       'email': context
                        //           .read<PayLaterProvider>()
                        //           .email
                        //           .toString()
                        //     },
                        //     "notify": {"sms": true, "email": false},
                        //     "method": {
                        //       "netbanking": false,
                        //       "card": false,
                        //       "upi": true,
                        //       "wallet": false,
                        //       "emi": false,
                        //       "paylater": false
                        //     }
                        //   };
                        //   _razorpay.open(
                        //     options,
                        //   );
                        // }
                      } else {
                        showMessage('Please select a payment option.');
                      }
                    } else {
                      await context
                          .read<PayLaterProvider>()
                          .paybywallet(widget.orderId);
                      context.read<PayLaterProvider>().pageIndex == 0
                          ? await context.read<StoreOrderProvider>().getOrders()
                          : await context
                              .read<StoreOrderProvider>()
                              .getPastOrders(
                                  toDate: "",
                                  fromdate: "",
                                  searchText: "",
                                  orderNo: "");
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (c) =>
                                  PayLaterOrderPlacedSuccessfully()),
                          (route) => false);
                    }
                  },
                  text: 'Pay now'))
        ]));
  }

  Future<dynamic> paymentGatewaySelection(
      BuildContext context, String? title, checkout) async {
    int? paymentGroup;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.92,
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: kMainColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                // height: 80,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.70,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  title!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall!
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        letterSpacing:
                                                            0.07, /* color: Color(0xffc1c1c1) */
                                                      ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.cancel_rounded,
                                              color: Colors.red,
                                              size: 25,
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile(
                                    activeColor: Colors.green,
                                    tileColor: Theme.of(context).cardColor,
                                    selectedTileColor: Colors.red,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    title: Image.asset(
                                        'images/logos/Razorpay_logo.png',
                                        scale: 10,
                                        alignment: Alignment.centerLeft,
                                        height: 30),
                                    value: 1,
                                    groupValue: paymentGroup,
                                    onChanged: (value) async {
                                      setState(() {
                                        paymentGroup = value;
                                      });
                                      // await context.read<StoreProvider>().gettimeslots();
                                    }),
                                RadioListTile(
                                    activeColor: Colors.green,
                                    tileColor: Theme.of(context).cardColor,
                                    selectedTileColor: Colors.red,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    title: /* Image.asset('images/logos/Razorpay_logo.png',
                        scale: 20, alignment: Alignment.centerLeft), */
                                        Image.asset(
                                      'images/logos/PayU.png',
                                      scale: 1,
                                      alignment: Alignment.centerLeft,
                                      height: 40,
                                      // fit: BoxFit.fitWidth,
                                    ),
                                    value: 2,
                                    groupValue: paymentGroup,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentGroup = value;
                                      });
                                    }),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // editAddress(context);
                                          },
                                          child: Text("Cancel")),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kMainColor,
                                          ),
                                          onPressed: () async {
                                            if (paymentGroup == 1) {
                                              if (group == 1) {
                                                razorpayCardPaymnet(checkout);

                                                Navigator.pop(context);
                                              } else {
                                                razorPayUPIPayment(checkout);

                                                Navigator.pop(context);
                                              }
                                            }
                                            // else if (paymentGroup == 2) {
                                            //   await context
                                            //       .read<PayLaterProvider>()
                                            //       .getPayUHash(
                                            //           context
                                            //                       .read<
                                            //                           StoreOrderingProductProvider>()
                                            //                       .cartTotal
                                            //                       ?.d?[0]
                                            //                       .walletamt !=
                                            //                   "0"
                                            //               ? "1"
                                            //               : "0",
                                            //           widget.orderId);
                                            //   _checkoutPro.openCheckoutScreen(
                                            //     payUPaymentParams: PayUParams
                                            //         .createPayUPaymentParams(
                                            //             context
                                            //                 .read<
                                            //                     PayLaterProvider>()
                                            //                 .payUPayLaterDetails!,
                                            //             prefs.getString(
                                            //                 'mob_no')),
                                            //     payUCheckoutProConfig:
                                            //         PayUParams
                                            //             .createPayUConfigParams(
                                            //                 group == 1
                                            //                     ? "CARD"
                                            //                     : "UPI"),
                                            //   );
                                            //   Navigator.pop(context);
                                            // }
                                            else {
                                              showMessage(
                                                  "Please Select Payment Gateway");
                                            }
                                          },
                                          child: Text("Pay Now")),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  razorpayCardPaymnet(checkout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await context.read<PayLaterProvider>().getrazorpayIdforPayLater(
        widget.orderId,
        double.parse(checkout[0].walletamt.toString()) != 0 ? '1' : '0');
    var options = {
      'key': rzrpy,
      // 'key': rzrpy_TEST,
      'amount': (double.parse('${double.parse(checkout[0].payamt!)}') * 100),
      // (double.parse('${checkout[0].posttaxamount}') *
      //     100),
      //in the format of paise: eg. "500" = Rs 5.00
      'name': 'KisanServ',
      'order_id':
          context.read<PayLaterProvider>().razorpayId, //'order_9A33XWu170gUtm',
      //Generate order_id using Orders API
      'description': 'Payment for ${context.read<PayLaterProvider>().transId}',
      'timeout': 300,
      // time in seconds to timeout
      'prefill': {
        'contact': prefs.getString('mob_no'),
        'email': context.read<PayLaterProvider>().email
      },
      "notify": {"sms": true, "email": false},
      "method": {
        "netbanking": true,
        "card": true,
        "upi": false,
        "wallet": false,
        "emi": false,
        "paylater": false
      }
    };
    _razorpay.open(
      options,
    );
  }

  razorPayUPIPayment(checkout) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var options = {
      'key': rzrpy,
      //'key': rzrpy_TEST,
      'amount': (double.parse('${double.parse(checkout[0].payamt!)}') * 100),
      // double.parse('${checkout[0].posttaxamount}') * 100,
      //in the format of paise: eg. "500" = Rs 5.00
      'name': 'KisanServ',
      'order_id': context
          .read<PayLaterProvider>()
          .razorpayId, // 'order_9A33XWu170gUtm',
      //Generate order_id using Orders API
      'description': 'Payment for ${context.read<PayLaterProvider>().transId} ',
      'timeout': 300,
      // time in seconds to timeout
      'prefill': {
        'contact': prefs.getString('mob_no'),
        'email': context.read<PayLaterProvider>().email
      },
      "notify": {"sms": true, "email": false},
      "method": {
        "netbanking": false,
        "card": false,
        "upi": true,
        "wallet": false,
        "emi": false,
        "paylater": false
      }
    };
    _razorpay.open(
      options,
    );
  }

  // @override
  // generateHash(Map response) {
  //   Map hashResponse = {};
  //   hashResponse = HashService.generateHash(response);
  //   _checkoutPro.hashGenerated(hash: hashResponse);
  // }

  // @override
  // onError(Map? response) {
  //   print(response.toString());
  //   showAlertDialog(context, "onError", response.toString());
  // }

  // @override
  // onPaymentCancel(Map? response) async {
  //   await context.read<PayLaterProvider>().getPayUreply(
  //       context.read<PayLaterProvider>().payUPayLaterDetails!.d.udf5);
  //   showMessage("Payment Cancel");
  // }

  // @override
  // onPaymentFailure(response) async {
  //   print(response.toString());
  //   await context.read<PayLaterProvider>().getPayUreply(
  //       context.read<PayLaterProvider>().payUPayLaterDetails!.d.udf5);
  //   showMessage("Payment failed");
  // }

  // @override
  // onPaymentSuccess(response) async {
  //   await context.read<PayLaterProvider>().getPayUreply(
  //       context.read<PayLaterProvider>().payUPayLaterDetails!.d.udf5);
  //   Navigator.pop(context);
  //   context.read<PayLaterProvider>().pageIndex == 0
  //       ? await context.read<StoreOrderProvider>().getOrders()
  //       : await context.read<StoreOrderProvider>().getPastOrders(
  //           toDate: "", fromdate: "", searchText: "", orderNo: "");
  // }
}
