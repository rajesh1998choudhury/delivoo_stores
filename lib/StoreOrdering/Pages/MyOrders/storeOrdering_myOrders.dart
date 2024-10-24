// ignore_for_file: unnecessary_null_comparison

import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Routes/routes.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/MyOrders/paylater.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../OrderItemAccount/Order/UI/order_invoice.dart';
import '../../StoreOrderingProvider/StoreOrderingProvider.dart';
import '../../StoreOrderingProvider/paylaterProvider.dart';

class StoreNewOrderPage extends StatefulWidget {
  const StoreNewOrderPage({Key? key}) : super(key: key);

  @override
  State<StoreNewOrderPage> createState() => _StoreNewOrderPageState();
}

class _StoreNewOrderPageState extends State<StoreNewOrderPage> {
  @override
  void initState() {
    context.read<StoreOrderProvider>().getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<StoreOrderProvider>().orders?.d;
    return RefreshIndicator(
      color: kMainColor,
      onRefresh: () => context.read<StoreOrderProvider>().getOrders(),
      child: orders == null || orders.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("No Orders Found"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(kMainColor)),
                        onPressed: () async {
                          await context.read<StoreOrderProvider>().getOrders();
                        },
                        icon: Icon(Icons.refresh, color: Colors.white),
                        label: Text("Click to Refresh",
                            style: TextStyle(color: Colors.white))),
                  ),
                ],
              ),
            )
          : Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orders != null ? orders.length : 0,
                  itemBuilder: (context, index) {
                    return orders.length < 0
                        ? Container()
                        : Card(
                            elevation: 5,
                            shadowColor: kMainColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Divider(
                                  color: Colors.white10,
                                  thickness: 5.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          '${orders[index].customerName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 13.3,
                                                  letterSpacing: 0.07),
                                        ),
                                      ),
                                      Text(
                                        '${orders[index].orderDate}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                                fontSize: 13.3,
                                                letterSpacing: 0.07),
                                      ),
                                      Text(
                                        '\₹ ${orders[index].totalamount == "" || orders[index].totalamount == null ? "" : double.parse(orders[index].totalamount!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                                fontSize: 13.3,
                                                letterSpacing: 0.07),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0,
                                      bottom: 10,
                                      left: 10,
                                      top: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                            'Order No: ${orders[index].orderNo}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 11.7,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.06,
                                                )),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          await context
                                              .read<StoreOrderProvider>()
                                              .selectOrder(orders[index]);
                                          await context
                                              .read<StoreOrderProvider>()
                                              .getOrderDetails(
                                                  orders[index].orderid);
                                          Navigator.pushNamed(context,
                                              PageRoutes.storeItemAcceptance);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              // color: kMainColor,
                                              border:
                                                  Border.all(color: kMainColor),
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              "View Details",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.06,
                                                      color: kMainColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, bottom: 10, left: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                            'Location : ${orders[index].deliveryLocation}',
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 11.7,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.06,
                                                )),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: ((context) {
                                            return Invoice(
                                                orderId: orders[index].orderid);
                                          })));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              // color: kMainColor,
                                              border: Border.all(
                                                  color: Colors.green),
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              "Invoice",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.06,
                                                      color: Colors.green),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, bottom: 10, left: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                        'Address : ${orders[index].addressLine1}',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontSize: 11.7,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.06,
                                            )),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, bottom: 10, left: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          'Delivery Type: ${orders[index].deltype == "1" ? "Slot Delivery" : "Quick Delivery"}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontSize: 11.7,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.06,
                                                  color: kMainColor)),
                                      // orders[index].deltype == "0"
                                      //     ? Text("")
                                      //     : Text(
                                      //         'Slot: ${orders[index].delstarttime} - ${orders[index].delendtime}',
                                      //         style: Theme.of(context)
                                      //             .textTheme
                                      //             .caption!
                                      //             .copyWith(
                                      //                 fontSize: 11.7,
                                      //                 fontWeight:
                                      //                     FontWeight.w500,
                                      //                 letterSpacing: 0.06,
                                      //                 color: kMainColor)),
                                      context.read<LoginProvider>().storeType ==
                                              "0"
                                          ? orders[index].paymentStatus != "1"
                                              ? SizedBox(
                                                  height: 30,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.green),
                                                      onPressed: () async {
                                                        await context
                                                            .read<
                                                                PayLaterProvider>()
                                                            .cartTotalForPayLater(
                                                                orders[index]
                                                                    .orderid
                                                                    .toString());
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return PayLaterScreen(
                                                            orders[index]
                                                                .orderid
                                                                .toString(),
                                                          );
                                                        }));
                                                      },
                                                      child: Text("Pay Now")),
                                                )
                                              : SizedBox.shrink()
                                          : SizedBox.shrink()
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                          'Weight: ${orders[index].wt == "" || orders[index].wt == null ? "" : double.parse(orders[index].wt!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), "")} kg',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontSize: 11.7,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.06,
                                                  color: Color(0xff393939))),
                                      Text(
                                          'Total products: ${orders[index].qty == "" || orders[index].qty == null ? "" : double.parse(orders[index].qty!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  fontSize: 11.7,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.06,
                                                  color: Color(0xff393939))),
                                      Text('${orders[index].orderStatus}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: orders[index]
                                                              .orderStatus ==
                                                          'Submitted'
                                                      ? Colors.green
                                                      : orders[index]
                                                                  .orderStatus ==
                                                              'Cancelled'
                                                          ? Colors.red
                                                          : orders[index]
                                                                      .orderStatus ==
                                                                  'pending'
                                                              ? Colors.blue
                                                              : Color(
                                                                  0xffffa025),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11.7,
                                                  letterSpacing: 0.06)),
                                    ],
                                  ),
                                ),
                                // Divider(
                                //   color: kCardBackgroundColor,
                                //   thickness: 8.0,
                                // ),
                              ],
                            ),
                          );
                  }),
            ),
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  bool get wantKeepAlive => true;
}
