import 'package:delivoo_stores/StoreOrdering/Pages/MyOrders/storeOrdering_myOrders.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/MyOrders/storeOrdering_pastorderPage.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../StoreOrderingProvider/paylaterProvider.dart';

class StoreOrderingOrderTab extends StatefulWidget {
  StoreOrderingOrderTab({Key? key}) : super(key: key);

  @override
  State<StoreOrderingOrderTab> createState() => _StoreOrderingOrderTabState();
}

class _StoreOrderingOrderTabState extends State<StoreOrderingOrderTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Tab> tabs = <Tab>[
    Tab(
      text: 'NEW ORDERS',
    ),
    Tab(
      text: 'PAST ORDERS',
    ),
  ];
  @override
  void initState() {
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    Future.delayed(Duration(milliseconds: 300), () async {
      await context
          .read<PayLaterProvider>()
          .getPageIndex(_tabController?.index);
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: AppBar(
              centerTitle: true,
              title: Text(
                "My Orders",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: Align(
                  alignment: Alignment.center,
                  child: TabBar(
                    onTap: (value) async {
                      _tabController?.index = value;
                      await context
                          .read<PayLaterProvider>()
                          .getPageIndex(_tabController?.index);
                      print("value ${_tabController?.index}");
                    },
                    controller: _tabController,
                    tabs: tabs,
                    isScrollable: false,
                    indicatorColor: Colors.white,
                    labelColor: kWhiteColor,
                    unselectedLabelColor: kLightTextColor,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 25.0),
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              StoreNewOrderPage(),
              // StoreReturnOrderPage(),
              StorePastOrderPage(),
            ],
          )),
    );
  }
}
