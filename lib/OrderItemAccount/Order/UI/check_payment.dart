import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/OrderProvider.dart';
import '../../../Themes/colors.dart';
import '../../../Utils/CommonWidget.dart';

class CheckPayment extends StatefulWidget {
  const CheckPayment({super.key});

  @override
  State<CheckPayment> createState() => _CheckPaymentState();
}

class _CheckPaymentState extends State<CheckPayment> {
  ScrollController? scrollController;
  @override
  void initState() {
    context.read<OrderProvider>().getPaymentDetails();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payDetails = context.watch<OrderProvider>().paymentStatusDetails?.d;
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            Text("Resubmit Order",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 20,
                    color: kWhiteColor,
                    fontWeight: FontWeight.w500)),
            Spacer(),
            IconButton(
                onPressed: () async {
                  showLoading();
                  await context.read<OrderProvider>().getPaymentDetails();
                  hideLoading();
                },
                icon: Icon(Icons.refresh, color: Colors.white))
          ],
        )),
        body: payDetails == null || payDetails.length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No Payment Details Found"),
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
                            await context
                                .read<OrderProvider>()
                                .getPaymentDetails();
                            hideLoading();
                          },
                          icon: Icon(Icons.refresh, color: Colors.white),
                          label: Text(
                            "Click to Refresh",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              )
            : Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                thickness: 8,
                trackVisibility: true,
                child: Container(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: payDetails.length,
                    itemBuilder: (context, index) {
                      final pay = payDetails[index];
                      scrollController =
                          ScrollController(initialScrollOffset: 0);
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Name: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontSize: 13,
                                                    color: kTextColor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: Text(pay.cname,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 13,
                                                      color: kMainColor,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Pay Status: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: kTextColor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Text(pay.paymentstatus,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("TempOdr Id: ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 12,
                                                          color: kTextColor,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.30,
                                                child: Text(pay.temporderid,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("D-Date: ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 12,
                                                          color: kTextColor,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.20,
                                                child: Text(pay.deliveryDate,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .deepPurple,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.70,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.watch_later_outlined,
                                                size: 12,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text("SlotTime - ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontSize: 12,
                                                          color: kTextColor,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.38,
                                                child: Text(pay.slotTime,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 12,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text("Contact No: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontSize: 12,
                                                    color: kTextColor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                        InkWell(
                                          onTap: () {
                                            urlLauncher(
                                                url: pay.mobileNo.toString(),
                                                scheme: 'tel');
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30,
                                            child: Text(pay.mobileNo,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontSize: 12,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await context
                                              .read<OrderProvider>()
                                              .razorpayAuth(
                                                  delDate: pay.deliveryDate,
                                                  orderId: pay.razorpayorderid);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Check Status",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.refresh,
                                                  size: 15,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Theme.of(context).cardColor,
                            thickness: 6.0,
                          ),
                        ],
                      );
                    },
                  ),
                )));
  }
}
