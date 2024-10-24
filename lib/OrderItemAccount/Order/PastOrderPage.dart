// ignore_for_file: unnecessary_null_comparison

import 'package:delivoo_stores/Components/loading_shimmer.dart';
import 'package:delivoo_stores/OrderItemAccount/Order/UI/express_invoice.dart';
import 'package:delivoo_stores/OrderItemAccount/Order/UI/past_orders_by_filter.dart';
import 'package:delivoo_stores/Provider/OrderProvider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Routes/routes.dart';

class PastOrderPage extends StatefulWidget {
  const PastOrderPage({Key? key}) : super(key: key);

  @override
  State<PastOrderPage> createState() => _PastOrderPageState();
}

class _PastOrderPageState extends State<PastOrderPage> {
  @override
  void initState() {
    context
        .read<OrderProvider>()
        .getPastOrders(toDate: "", fromdate: "", searchText: "", orderNo: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders?.d;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // showSearch(
                      //     context: context,
                      //     delegate: CustomSearchDelegateOrders());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SeachByFilter()));
                    },
                    child: Container(
                      //  height: MediaQuery.of(context).size.height * 0.051,
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Search Past Order",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(0)),
      ),
      body: RefreshIndicator(
        color: kMainColor,
        onRefresh: () => context.read<OrderProvider>().isLoading
            ? LoadingShimmer()
            : context
                .read<OrderProvider>()
                .getPastOrders(toDate: "", fromdate: "", searchText: ""),
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
                                      WidgetStateProperty.all<Color>(
                                          kMainColor)),
                              onPressed: () async {
                                showLoading();
                                await context
                                    .read<OrderProvider>()
                                    .getPastOrders(
                                        fromdate: "",
                                        toDate: "",
                                        searchText: "",
                                        orderNo: "");
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
                : Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: orders != null ? orders.length : 0,
                        itemBuilder: (context, index) {
                          return Card(
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
                                        '${orders[index].deliverydate}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                                fontSize: 13.3,
                                                letterSpacing: 0.07),
                                      ),
                                      Text(
                                        '\₹ ${orders[index].totalamount == null || orders[index].totalamount == "" ? "" : double.parse(orders[index].totalamount!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
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
                                              .read<OrderProvider>()
                                              .selectOrder(orders[index]);
                                          await context
                                              .read<OrderProvider>()
                                              .getOrderDetails(
                                                  orders[index].orderid);
                                          await context
                                              .read<OrderProvider>()
                                              .orderInfoselectedPage(false);
                                          Navigator.pushNamed(context,
                                              PageRoutes.orderInfoPage);
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
                                      orders[index].mapAddress == null ||
                                              orders[index].mapAddress == ""
                                          ? SizedBox.shrink()
                                          : Row(
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
                                                              FontWeight.w500,
                                                          letterSpacing: 0.06,
                                                        )),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      child: Text(
                                                          ' ${orders[index].mapAddress}',
                                                          style:
                                                              Theme.of(context)
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
                                      InkWell(
                                        onTap: () async {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: ((context) {
                                            return ExpressInvoice(
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
                                        'Address : ${orders[index].delAddress}',
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
                                                  fontWeight: FontWeight.w500,
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
                                      right: 20.0, bottom: 10, left: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                        'Delivered By: ${orders[index].delboyName}',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontSize: 11.7,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.06,
                                                color: Colors.blue)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20.0, bottom: 10, left: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                        'Delivery Time: ${orders[index].delTime}',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontSize: 11.7,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.06,
                                                color: Colors.orange)),
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
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.06,
                                                  color: Color(0xff393939))),
                                      Text(
                                          'Total products: ${orders[index].qty == null || orders[index].qty == "" ? "" : double.parse(orders[index].qty!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
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
                              ],
                            ),
                          );
                        }),
                  ),
      ),
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  bool get wantKeepAlive => true;
}
