import 'package:delivoo_stores/Components/order_search_delegate.dart';
import 'package:delivoo_stores/Provider/OrderProvider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/CommonWidget.dart';

class SeachByFilter extends StatefulWidget {
  const SeachByFilter({Key? key}) : super(key: key);

  @override
  State<SeachByFilter> createState() => _SeachByFilterState();
}

class _SeachByFilterState extends State<SeachByFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Search past orders by filter',
        style: TextStyle(fontSize: 16, color: Colors.white),
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  showLoading();
                  await context.read<OrderProvider>().getPastOrders(
                      fromdate: null, toDate: null, searchText: null);
                  hideLoading();
                  showSearch(
                      context: context, delegate: CustomSearchDelegateOrders());
                },
                child: Container(
                  //height: MediaQuery.of(context).size.height * 0.051,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: kMainColor,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Text("Search by name",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      Spacer(),
                      Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(child: Text('OR')),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        var _formkey = GlobalKey<FormState>();
                        TextEditingController orderController =
                            TextEditingController();
                        return AlertDialog(
                          title: Text(
                            "Search by Order No",
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Form(
                                key: _formkey,
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) => value!.length < 1
                                      ? 'Enter Order No'
                                      : null,
                                  textAlign: TextAlign.center,
                                  controller: orderController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Order No',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1)),
                                    border: new OutlineInputBorder(
                                      borderSide: const BorderSide(width: 2.0),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    contentPadding: EdgeInsets.only(),
                                  ),
                                ),
                              ),
                              Container(
                                child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                kMainColor)),
                                    onPressed: () async {
                                      print(orderController.text);
                                      await context
                                          .read<OrderProvider>()
                                          .getPastOrders(
                                              fromdate: "",
                                              toDate: "",
                                              searchText: "",
                                              orderNo: orderController.text);

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.done, color: Colors.white),
                                    label: Text(
                                      "ok",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Container(
                  //height: MediaQuery.of(context).size.height * 0.051,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: kMainColor,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Text("Search by Order No",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      Spacer(),
                      Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Text(
                'OR',
              )),
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Text(
                "Search by Date Range",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              SizedBox(height: 10),
              Text("Select From Date"),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      showDatePicker(
                          helpText: "Select First Date",
                          context: context,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now().add(Duration(seconds: 20)),
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
                            .read<OrderProvider>()
                            .DatePickerFirstDay(value);
                        // await context.read<OrderProvider>().getPastOrders(
                        //     fromdate:
                        //         context.read<OrderProvider>().firstDay ?? "",
                        //     toDate: context.read<OrderProvider>().lastDay ?? "",
                        //     searchText: null);
                      });
                    },
                    child: Container(
                      width: 150,
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
                          Icon(
                            Icons.calendar_today,
                            size: 15,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Center(
                            child: Text(
                              context.watch<OrderProvider>().firstDay ??
                                  "Select Date",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: 15,
                      child: IconButton(
                          color: kWhiteColor,
                          iconSize: 15,
                          onPressed: () async {
                            await context
                                .read<OrderProvider>()
                                .clearFirstDate();
                          },
                          icon: Icon(Icons.clear)))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text("Select Last Date"),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      showDatePicker(
                          helpText: "Select Last Date",
                          context: context,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now().add(Duration(seconds: 20)),
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
                            .read<OrderProvider>()
                            .DatePickerLastDay(value);
                      });
                    },
                    child: Container(
                      width: 150,
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
                          Icon(
                            Icons.calendar_today,
                            // color: kWhiteColor,
                            size: 15,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            context.watch<OrderProvider>().lastDay ??
                                "Select Date",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: 15,
                      child: IconButton(
                          color: kWhiteColor,
                          iconSize: 15,
                          onPressed: () async {
                            await context.read<OrderProvider>().clearLastDate();
                          },
                          icon: Icon(Icons.clear)))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: kMainColor),
                    onPressed: () async {
                      await context.read<OrderProvider>().getPastOrders(
                          fromdate:
                              context.read<OrderProvider>().firstDay ?? "",
                          toDate: context.read<OrderProvider>().lastDay ?? "",
                          searchText: null);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Search by date Range',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
