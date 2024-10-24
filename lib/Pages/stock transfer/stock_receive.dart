// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Components/bottom_bar.dart';
import 'package:delivoo_stores/StoreOrdering/Models/getstock_receive_mode.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../StoreOrdering/StoreOrderingProvider/StoreOrderingProvider.dart';

class StoreStockReceive extends StatefulWidget {
  const StoreStockReceive({Key? key}) : super(key: key);

  @override
  State<StoreStockReceive> createState() => _StoreStockReceiveState();
}

class _StoreStockReceiveState extends State<StoreStockReceive> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedOrder =
        context.watch<StoreOrderProvider>().getStockReceive_Data?.d;
    final scrollController = ScrollController(initialScrollOffset: 0);
    return WillPopScope(
      onWillPop: () async {
        context.read<StoreOrderProvider>().getStockReceive_Data?.d = [];
        context.read<StoreOrderProvider>().fromDate = DateTime.now();
        context.read<StoreOrderProvider>().toDate = DateTime.now();

        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Store Receive Items",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 2, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await context
                                .read<StoreOrderProvider>()
                                .checkQr(false);
                            showDatePicker(
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate:
                                    context.read<StoreOrderProvider>().fromDate,
                                firstDate:
                                    DateTime.now().subtract(Duration(days: 60)),
                                lastDate: DateTime.now(),
                                builder: (BuildContext context, child) {
                                  return Theme(
                                      data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                              primary: kMainColor,
                                              onPrimary: Colors.white,
                                              onSurface: kMainColor)),
                                      child: child!);
                                }).then((value) async {
                              if (value != null) {
                                await context
                                    .read<StoreOrderProvider>()
                                    .notifyFromDate(value);
                              }
                            });
                          },
                          child: Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      context
                                                      .watch<
                                                          StoreOrderProvider>()
                                                      .fromDate !=
                                                  null &&
                                              context
                                                      .watch<
                                                          StoreOrderProvider>()
                                                      .fromDate !=
                                                  ""
                                          ? DateFormat('dd/MM/yyyy').format(
                                              context
                                                  .watch<StoreOrderProvider>()
                                                  .fromDate)
                                          : "Select Date",
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: 12),
                                    ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                    // Icon(
                                    //   Icons.date_range,
                                    //   color: kWhiteColor,
                                    //   size: 20,
                                    // ),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "From Date",
                          style: TextStyle(fontSize: 12, color: kWhiteColor),
                        )
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            showDatePicker(
                                helpText: "Select Last Date",
                                context: context,
                                initialEntryMode:
                                    DatePickerEntryMode.calendarOnly,
                                initialDate:
                                    context.read<StoreOrderProvider>().toDate,
                                firstDate: DateTime(1960),
                                lastDate:
                                    DateTime.now().add(Duration(seconds: 20)),
                                builder: (BuildContext context, child) {
                                  return Theme(
                                      data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                              primary: kMainColor,
                                              onPrimary: Colors.white,
                                              onSurface: kMainColor)),
                                      child: child!);
                                }).then((value) async {
                              await context
                                  .read<StoreOrderProvider>()
                                  .notifyToDate(value);
                            });
                          },
                          child: Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      context
                                                      .watch<
                                                          StoreOrderProvider>()
                                                      .toDate !=
                                                  null &&
                                              context
                                                      .watch<
                                                          StoreOrderProvider>()
                                                      .toDate !=
                                                  ""
                                          ? DateFormat('dd/MM/yyyy').format(
                                              context
                                                  .watch<StoreOrderProvider>()
                                                  .toDate)
                                          : "Select Date",
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: 12),
                                    ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                    // Icon(
                                    //   Icons.date_range,
                                    //   color: kWhiteColor,
                                    //   size: 20,
                                    // ),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "To Date",
                          style: TextStyle(fontSize: 12, color: kWhiteColor),
                        )
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: BottomBar(
                        onTap: () async {
                          context
                              .read<StoreOrderProvider>()
                              .resetStoreReceiveData();
                        },
                        text: "",
                        width: 45,
                        height: 40,
                        iconsize: 25,
                        color: Colors.red,
                        icon: Icons.clear,
                        textColor: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: BottomBar(
                        onTap: () async {
                          await context
                              .read<StoreOrderProvider>()
                              .getStockReceiveData(
                                  fromDate: DateFormat('dd/MM/yyyy').format(
                                      context
                                          .read<StoreOrderProvider>()
                                          .fromDate),
                                  toDate: DateFormat('dd/MM/yyyy').format(
                                      context
                                          .read<StoreOrderProvider>()
                                          .toDate));
                        },
                        text: "Show All",
                        width: 100,
                        height: 40,
                        color: Colors.green,
                        icon: Icons.remove_red_eye,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(50)),
        ),
        body: selectedOrder == null || selectedOrder.isEmpty
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Please Select From Date and To Date ",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                thickness: 5,
                trackVisibility: true,
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: <Widget>[
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 8.0,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
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
                                itemCount: selectedOrder.length,
                                itemBuilder: (context, index) {
                                  final items = selectedOrder[index];
                                  return Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Container(
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                              image: items.imgpath == null ||
                                                      items.imgpath == ""
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                      'images/logos/not-available.png',
                                                    ))
                                                  : DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              BaseUrl +
                                                                  skuImges +
                                                                  items.imgpath,
                                                              cacheKey: items
                                                                  .imgpath),
                                                      onError: (exception,
                                                          stackTrace) {
                                                        items.imgpath = "";
                                                      },
                                                    )),
                                        ),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              items.transferFrom.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: kMainColor),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              items.itemName.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.green),
                                            ),
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Trans Qty: ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 13),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        '${double.parse(items.transferqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .blue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  "Bal Qty: ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 13),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        '${double.parse(items.balanceqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .blue),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Receive Status -',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(items.receiveStatus,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            color: items.receiveStatus ==
                                                                    "Received"
                                                                ? Colors.green
                                                                : items.receiveStatus ==
                                                                        "Pending"
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .blue)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Receive Qty:',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  double.parse(
                                                          items.receiveStatus ==
                                                                  "Pending"
                                                              ? items
                                                                  .transferqty
                                                              : items
                                                                  .receiveqty)
                                                      .toStringAsFixed(2)
                                                      .replaceFirst(
                                                          RegExp(r'\.?0*$'),
                                                          ''),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color: kMainColor),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                items.receiveStatus == "Pending"
                                                    ? InkWell(
                                                        onTap: () async {
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
                                                                    UpdateController =
                                                                    TextEditingController();
                                                                UpdateController
                                                                    .text = items.transferqty !=
                                                                            null ||
                                                                        items.transferqty !=
                                                                            ""
                                                                    ? double.parse(items
                                                                            .transferqty
                                                                            .toString())
                                                                        .toStringAsFixed(
                                                                            2)
                                                                        .replaceFirst(
                                                                            RegExp(r'\.?0*$'),
                                                                            '')
                                                                    : "0";

                                                                return AlertDialog(
                                                                  title: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Edit Transfer Quantity",
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                              "Transfer qty:"),
                                                                          SizedBox(
                                                                            width:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                            items.transferqty == null || items.transferqty == ""
                                                                                ? "0.0"
                                                                                : '${double.parse(items.transferqty).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                                            style:
                                                                                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15, color: Colors.blue),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
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
                                                                          inputFormatters: [
                                                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                                          ],
                                                                          validator:
                                                                              (value) {
                                                                            if (value!.length <
                                                                                1) {
                                                                              return "please enter quantity";
                                                                            } else if (double.parse(value) >
                                                                                double.parse(items.transferqty)) {
                                                                              return 'value is greater then stock quantity';
                                                                            } else if (double.parse(value) == double.parse("0")) {
                                                                              return 'Enter value should be greater than 0';
                                                                            }

                                                                            return null;
                                                                          },
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          controller:
                                                                              UpdateController,
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
                                                                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.red)),
                                                                                onPressed: () async {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: Icon(Icons.cancel),
                                                                                label: Text("Cancel")),
                                                                            ElevatedButton.icon(
                                                                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                                                                                onPressed: () async {
                                                                                  if (_formkey.currentState!.validate()) {
                                                                                    Navigator.pop(context);
                                                                                    await updateQtyDialog(context: context, items: items, receiveQty: UpdateController.text);
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
                                                        },
                                                        child: Container(
                                                            width: 50,
                                                            child: Icon(
                                                              Icons.edit,
                                                              size: 20,
                                                            )),
                                                      )
                                                    : SizedBox.shrink(),
                                                Spacer(),
                                                items.receiveStatus == "Pending"
                                                    ? InkWell(
                                                        onTap: () async {
                                                          await updateQtyDialog(
                                                              context: context,
                                                              items: items,
                                                              receiveQty: items
                                                                  .transferqty);
                                                        },
                                                        child: Container(
                                                          width: 50,
                                                          child: Image.asset(
                                                            'images/logos/received.png',
                                                            height: 17,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Divider(
                                              color:
                                                  Theme.of(context).cardColor,
                                              thickness: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Transfer By: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Spacer(),
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
                                                              0.45,
                                                      child: Text(
                                                        ' ${items.transferBy.replaceAll("|", "")}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .purple),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Receive By: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: Text(
                                                        '${items.receiveBy.replaceAll("|", "")}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color: Colors
                                                                    .redAccent),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color:
                                                  Theme.of(context).cardColor,
                                              thickness: 4,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  updateQtyDialog({BuildContext? context, D? items, receiveQty}) async {
    showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              'Receive Items',
            ),
            content: Text(
              'Are You Sure to Receive Full Qty? \nOnce accepted, it cannot be reverted',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 15, color: Colors.red),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  'No',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(color: kWhiteColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.red)),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                  child: Text(
                    'Yes',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: TextStyle(color: kWhiteColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.green)),
                  ),
                  onPressed: () async {
                    var res = await context
                        .read<StoreOrderProvider>()
                        .StoreTransferitemReceived(
                            balQty: items?.balanceqty,
                            recQty: receiveQty,
                            transId: items?.transId);
                    Navigator.pop(context);
                    if (res == "sucess") {
                      await context
                          .read<StoreOrderProvider>()
                          .getStockReceiveData(
                              fromDate: DateFormat('dd/MM/yyyy').format(
                                  context.read<StoreOrderProvider>().fromDate),
                              toDate: DateFormat('dd/MM/yyyy').format(
                                  context.read<StoreOrderProvider>().toDate));
                    }
                  })
            ],
          );
        });
  }

  @override
  // ignore: override_on_non_overriding_member
  bool get wantKeepAlive => true;
}
