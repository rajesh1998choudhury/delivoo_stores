import 'package:delivoo_stores/Provider/profileProvider.dart';
import 'package:delivoo_stores/Provider/select_time_provider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HolidayListing extends StatefulWidget {
  const HolidayListing({Key? key}) : super(key: key);

  @override
  State<HolidayListing> createState() => _HolidayListingState();
}

class _HolidayListingState extends State<HolidayListing> {
  @override
  Widget build(BuildContext context) {
    final holiday = context.watch<ProfileProvider>().holidayList?.d;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Holiday Listing',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  context.read<SelectTimeProvider>().pickDate(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kMainColor,
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
                        color: kWhiteColor,
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Choose Holiday",
                        style: TextStyle(color: kWhiteColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              context.watch<SelectTimeProvider>().selectedDate != null &&
                      context.watch<SelectTimeProvider>().selectedDate != ""
                  ? Row(
                      children: [
                        Text("Date :"),
                        Text(
                            dateFormat.format(DateTime.parse(context
                                .watch<SelectTimeProvider>()
                                .selectedDate
                                .toString())),
                            style: TextStyle(
                                color: kMainColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Spacer(),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kMainColor),
                            onPressed: () async {
                              context.read<ProfileProvider>().updateHoliday(
                                  action: "1",
                                  holidayDate: DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(context
                                          .read<SelectTimeProvider>()
                                          .selectedDate
                                          .toString())),
                                  holidayId: "");
                            },
                            icon: Icon(Icons.save, color: Colors.white),
                            label: Text("Save Date",
                                style: TextStyle(color: Colors.white)))
                      ],
                    )
                  : Container(),
              Divider(
                color: kCardBackgroundColor,
                thickness: 8.0,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text("All Holiday Dates"),
              ),
              Divider(
                color: kCardBackgroundColor,
                thickness: 8.0,
              ),
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        context.watch<ProfileProvider>().holidayList?.d?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            holiday != null ? holiday[index].holidayDate! : "",
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        leading: Icon(
                          Icons.calendar_today_outlined,
                          color: kMainColor,
                        ),
                        onTap: () async {
                          showDatePicker(
                              context: context,
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              initialDate:
                                  new DateTime.now().add(Duration(days: 1)),
                              firstDate: DateTime.now().add(Duration(days: 1)),
                              lastDate: DateTime.now().add(Duration(days: 31)),
                              builder: (BuildContext context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: kMainColor,
                                        onPrimary: Colors.white,
                                      ),
                                    ),
                                    child: child!);
                              }).then((value) async {
                            if (value != null) {
                              await context
                                  .read<ProfileProvider>()
                                  .updateHoliday(
                                      action: "2",
                                      holidayDate: DateFormat('dd/MM/yyyy')
                                          .format(
                                              DateTime.parse(value.toString())),
                                      holidayId: holiday?[index].holidayId);
                            }
                          });
                        },
                        trailing: InkWell(
                          onTap: () async {
                            await context.read<ProfileProvider>().updateHoliday(
                                action: "3",
                                holidayDate: "",
                                holidayId: holiday?[index].holidayId);
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
