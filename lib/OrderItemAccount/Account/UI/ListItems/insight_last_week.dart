import 'package:delivoo_stores/Components/bar_chart.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/insight_detail_page.dart';
import 'package:delivoo_stores/Provider/insight_provider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class InsightLastWeekPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Insight(),
    );
  }
}

class Insight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final earnings = context.watch<InsightProvider>().earnings;
    final totalItems = context.watch<InsightProvider>().totalItemSold;
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Divider(
          color: kCardBackgroundColor,
          thickness: 8.0,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      earnings![0].totalOrders.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    'Orders',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500, color: kTextColor),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      earnings[0].totalItemsSold.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    'Items Sold',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500, color: kTextColor),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '\₹ ${earnings[0].totalEarnings}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    'Earnings',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500, color: kTextColor),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '\₹ ${earnings[0].totalComission}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    "commission",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500, color: kTextColor),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '\₹ ${earnings[0].totalComission}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    "Delivery",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w500, color: kTextColor),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: kCardBackgroundColor,
          thickness: 6.7,
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text('Earnings',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 15.0, letterSpacing: 1.5)),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => InsightDetailPage())));
                },
                child: Container(
                  decoration: BoxDecoration(
                      // color: kMainColor,
                      border: Border.all(color: kMainColor),
                      borderRadius: BorderRadius.circular(7)),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      "View Details",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
          padding: EdgeInsets.all(20.0),
          child: Text('Earnings',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontSize: 15.0, letterSpacing: 1.5)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: BarChartDetails()),
        ),
        Divider(
          color: kCardBackgroundColor,
          thickness: 6.7,
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('TOP 5 SELLING ITEMS\n',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 11.7,
                      fontWeight: FontWeight.w500,
                      color: kTextColor)),
              Text('Total Items Sold ' +
                  totalItems![0].totalItemSold.toString()),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: totalItems[0].topSelling?.length,
              itemBuilder: (context, index) {
                final items = totalItems[0].topSelling;
                return Row(
                  children: <Widget>[
                    SizedBox(width: 5.0),
                    // Image(
                    //   image: AssetImage(items![index].productImage.toString()),
                    //   height: 61.3,
                    //   width: 61.3,
                    // ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(items![index].productName.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        Text(items[index].totalSales! + 'Sales',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 11.7)),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
