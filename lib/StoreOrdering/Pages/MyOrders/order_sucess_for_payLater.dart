// ignore_for_file: deprecated_member_use

import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/MyOrders/storeOrdering_myOrdersTab.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../OrderItemAccount/order_item_account.dart';

import '../../StoreOrderingProvider/paylaterProvider.dart';

class PayLaterOrderPlacedSuccessfully extends StatelessWidget {
  const PayLaterOrderPlacedSuccessfully({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 5)),
                  margin: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.done,
                    size: 45,
                    color: Colors.green,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Order Placed Sucessfully!!",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(
              height: 10,
            ),
            context.watch<PayLaterProvider>().orderId != null
                ? Text(
                    "Order #${context.watch<PayLaterProvider>().orderId}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : Text(
                    "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
            Spacer(),
            InkWell(
              onTap: () async {
                await context.read<LoginProvider>().onTapped(3);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => OrderItemAccount()),
                    (route) => false);
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => StoreOrderingOrderTab()),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "VIEW DETAILS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () async {
                await context.read<LoginProvider>().storeType == "0"
                    ? context.read<LoginProvider>().onTapped(2)
                    : context.read<LoginProvider>().onTapped(0);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => OrderItemAccount()),
                    (route) => false);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                decoration: BoxDecoration(
                  color: kMainColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "GO HOME",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
