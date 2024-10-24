// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:delivoo_stores/Components/loading_shimmer.dart';
import 'package:delivoo_stores/OrderItemAccount/Order/UI/express_invoice.dart';
import 'package:delivoo_stores/Provider/OrderProvider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/login_provider.dart';
import '../../../Routes/routes.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({Key? key}) : super(key: key);

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await context
          .read<OrderProvider>()
          .getOrders()
          .then((value) => context.read<OrderProvider>().getOrdersPeriodic());
      await context.read<LoginProvider>().getUserStatus(context);
    });

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders?.d;
    return RefreshIndicator(
      color: kMainColor,
      onRefresh: () => context
          .read<OrderProvider>()
          .getOrders()
          .then((value) => context.read<OrderProvider>().getOrdersPeriodic()),
      child: context.read<OrderProvider>().isLoading
          ? LoadingShimmer()
          : orders == null || orders.length == 0
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
                              showLoading();
                              await context.read<OrderProvider>().getOrders();
                              hideLoading();
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                          orders[index].mobileNo == null ||
                                                  orders[index].mobileNo ==
                                                      "" ||
                                                  orders[index].mobileNo ==
                                                      "null"
                                              ? SizedBox.shrink()
                                              : InkWell(
                                                  onTap: () {
                                                    urlLauncher(
                                                        scheme: 'tel',
                                                        url: orders[index]
                                                            .mobileNo
                                                            .toString());
                                                  },
                                                  child: Icon(
                                                    Icons.phone,
                                                    size: 15,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                          Text(
                                            '${orders[index].deliverydate}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .copyWith(
                                                    fontSize: 13.3,
                                                    letterSpacing: 0.07),
                                          ),
                                          Text(
                                            '\₹ ${orders[index].totalamount == null || orders[index].totalamount == "" ? 0.0 : double.parse(orders[index].totalamount!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                                'Order No: ${orders[index].orderNo}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontSize: 11.7,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.06,
                                                    )),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              context
                                                  .read<OrderProvider>()
                                                  .timer!
                                                  .cancel();
                                              await context
                                                  .read<OrderProvider>()
                                                  .selectOrder(orders[index]);
                                              await context
                                                  .read<OrderProvider>()
                                                  .getOrderDetails(
                                                      orders[index].orderid);
                                              await context
                                                  .read<OrderProvider>()
                                                  .orderInfoselectedPage(true);
                                              Navigator.pushNamed(context,
                                                  PageRoutes.orderInfoPage);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  // color: kMainColor,
                                                  border: Border.all(
                                                      color: kMainColor),
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
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
                                          )
                                        ],
                                      ),
                                    ),
                                    orders[index].mapAddress == null ||
                                            orders[index].mapAddress == ""
                                        ? SizedBox.shrink()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0,
                                                bottom: 10,
                                                left: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Location:",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                              fontSize: 11.7,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.06,
                                                            )),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                          child: Text(
                                                              ' ${orders[index].mapAddress}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        11,
                                                                    letterSpacing:
                                                                        0.06,
                                                                  )),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                orders[index].latitude ==
                                                            null ||
                                                        orders[index]
                                                                    .latitude ==
                                                                "" &&
                                                            orders[index]
                                                                    .longitude ==
                                                                null ||
                                                        orders[index]
                                                                .longitude ==
                                                            ""
                                                    ? SizedBox.shrink()
                                                    : InkWell(
                                                        onTap: () async {
                                                          navigateToMap(
                                                              double.parse(orders[
                                                                      index]
                                                                  .latitude
                                                                  .toString()),
                                                              double.parse(orders[
                                                                      index]
                                                                  .longitude
                                                                  .toString()));
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: kMainColor,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .red),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .directions,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 20,
                                                                ),
                                                                // Text(
                                                                //   "Map",
                                                                //   style: Theme.of(
                                                                //           context)
                                                                //       .textTheme
                                                                //       .caption!
                                                                //       .copyWith(
                                                                //           fontSize:
                                                                //               12,
                                                                //           fontWeight:
                                                                //               FontWeight
                                                                //                   .w500,
                                                                //           letterSpacing:
                                                                //               0.06,
                                                                //           color: Colors
                                                                //               .red),
                                                                // ),
                                                              ],
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                                'Address : ${orders[index].delAddress}',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontSize: 11.7,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.06,
                                                    )),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: ((context) {
                                                return ExpressInvoice(
                                                    orderId:
                                                        orders[index].orderid);
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
                                                padding:
                                                    const EdgeInsets.all(3.0),
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
                                          right: 10.0, bottom: 10, left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text('Delboy Name- ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 0.06,
                                                      )),
                                              orders[index].delbyname == null ||
                                                      orders[index].delbyname ==
                                                          "" ||
                                                      orders[index].delbyname ==
                                                          "null"
                                                  ? SizedBox.shrink()
                                                  : InkWell(
                                                      onTap: () async {
                                                        await context
                                                            .read<
                                                                OrderProvider>()
                                                            .getDeliveyBoyList(
                                                                orders[index]
                                                                    .orderid);

                                                        context
                                                                        .read<
                                                                            OrderProvider>()
                                                                        .deliveryboyList
                                                                        ?.d ==
                                                                    null ||
                                                                context
                                                                        .read<
                                                                            OrderProvider>()
                                                                        .deliveryboyList
                                                                        ?.d
                                                                        .length ==
                                                                    0 ||
                                                                context
                                                                        .read<
                                                                            OrderProvider>()
                                                                        .deliveryboyList ==
                                                                    ""
                                                            ? showMessage(
                                                                "DeliveryBoy not available, Try after some time.")
                                                            : await assignDeliveryBoy(
                                                                context,
                                                                orders[index]
                                                                    .orderid,
                                                                false,
                                                                orders[index]
                                                                    .delbyname);
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.50,
                                                        child: Row(
                                                          children: [
                                                            Transform.rotate(
                                                              angle: 280 *
                                                                  pi /
                                                                  180,
                                                              child: Icon(
                                                                Icons.edit,
                                                                color:
                                                                    Colors.red,
                                                                size: 12,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Container(
                                                              width: orders[index]
                                                                          .delbyname!
                                                                          .length >
                                                                      13
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.31
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.20,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      orders[index]
                                                                          .delbyname
                                                                          .toString(),
                                                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          letterSpacing:
                                                                              0.06,
                                                                          color:
                                                                              kMainColor)),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          orders[index].delbyname == null ||
                                                  orders[index].delbyname ==
                                                      "" ||
                                                  orders[index].delbyname ==
                                                      "null"
                                              ? InkWell(
                                                  onTap: () async {
                                                    await context
                                                        .read<OrderProvider>()
                                                        .getDeliveyBoyList(
                                                            orders[index]
                                                                .orderid);

                                                    context
                                                                    .read<
                                                                        OrderProvider>()
                                                                    .deliveryboyList
                                                                    ?.d ==
                                                                null ||
                                                            context
                                                                    .read<
                                                                        OrderProvider>()
                                                                    .deliveryboyList
                                                                    ?.d
                                                                    .length ==
                                                                0 ||
                                                            context
                                                                    .read<
                                                                        OrderProvider>()
                                                                    .deliveryboyList ==
                                                                ""
                                                        ? showMessage(
                                                            "DeliveryBoy not available, Try after some time.")
                                                        : await assignDeliveryBoy(
                                                            context,
                                                            orders[index]
                                                                .orderid,
                                                            true,
                                                            orders[index]
                                                                .delbyname);
                                                  },
                                                  child: Container(
                                                    height: 15,
                                                    width: 36,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: Colors.red)),
                                                    child: Center(
                                                      child: Text('Add +',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .red)),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                    orders[index].delboyMobile == null ||
                                            orders[index].delboyMobile == "" ||
                                            orders[index].delboyMobile == "null"
                                        ? SizedBox.shrink()
                                        : InkWell(
                                            onTap: () {
                                              urlLauncher(
                                                  url: orders[index]
                                                      .delboyMobile
                                                      .toString(),
                                                  scheme: 'tel');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0,
                                                  bottom: 10,
                                                  left: 10),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    size: 12,
                                                    color: Colors.green,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text('Delboy No -',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.06,
                                                          )),
                                                  Text(
                                                      orders[index]
                                                          .delboyMobile
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                            color: kMainColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.06,
                                                          )),
                                                ],
                                              ),
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 30.0, bottom: 10, left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              'Delivery Type: ${orders[index].deltype == "1" ? "Slot Delivery" : orders[index].deltype == "2" ? "In-Store Pickup" : "Quick Delivery"}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 11.7,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.06,
                                                      color: kMainColor)),
                                          orders[index].deltype != "1"
                                              ? Text("")
                                              : Text(
                                                  'Slot: ${orders[index].delstarttime} - ${orders[index].delendtime}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 11.7,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.06,
                                                          color: kMainColor)),
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
                                              'Weight: ${orders[index].wt == null || orders[index].wt == "" ? "" : double.parse(orders[index].wt!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), "")} kg',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 11.7,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.06,
                                                      color:
                                                          Color(0xff393939))),
                                          Text(
                                              'Total products: ${orders[index].qty == null || orders[index].qty == "" ? "" : double.parse(orders[index].qty!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 11.7,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.06,
                                                      color:
                                                          Color(0xff393939))),
                                          Text('${orders[index].orderStatus}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium!
                                                  .copyWith(
                                                      color: orders[index]
                                                                  .orderStatus ==
                                                              'Submitted and Paid'
                                                          ? Colors.green
                                                          : orders[index]
                                                                      .orderStatus ==
                                                                  'Cancelled'
                                                              ? Colors.red
                                                              : orders[index]
                                                                          .orderStatus ==
                                                                      'Packed and Ready'
                                                                  ? Colors.blue
                                                                  : Color(
                                                                      0xffffa025),
                                                      fontWeight:
                                                          FontWeight.bold,
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

  assignDeliveryBoy(
      BuildContext context, orderId, addNew, selectedDeliveryBoy) async {
    final scrollController = ScrollController(initialScrollOffset: 0);
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              // color: kCardBackgroundColor,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            // width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.50,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  height: 50,
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
                          addNew == true
                              ? "Assign Delivery Boy"
                              : "Change Delivery Boy",
                          style: TextStyle(color: kWhiteColor, fontSize: 14),
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
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: context
                              .watch<OrderProvider>()
                              .deliveryboyList
                              ?.d
                              .length,
                          itemBuilder: (context, index) {
                            var deliveryBoy = context
                                .watch<OrderProvider>()
                                .deliveryboyList
                                ?.d[index];
                            return Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await context
                                            .read<OrderProvider>()
                                            .updateDeliveryBoy(
                                                orderId: orderId,
                                                delboyId: deliveryBoy.delboyid);
                                        Navigator.pop(context);
                                      },
                                      child: SizedBox(
                                        child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.80,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          deliveryBoy!
                                                              .delboyName
                                                              .toString(),
                                                          overflow:
                                                              TextOverflow.clip,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
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
                                      color: kCardBackgroundColor,
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  bottom: 5,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: deliveryBoy.status != "0"
                                          ? Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green,
                                              ),
                                              child: Center(
                                                  child: Icon(
                                                      Icons.check_rounded)),
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
  }

  @override
  // ignore: override_on_non_overriding_member
  bool get wantKeepAlive => true;
}
