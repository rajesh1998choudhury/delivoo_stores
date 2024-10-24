import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/insight_last_week.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/insight_page.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';

class InsightTab extends StatefulWidget {
  InsightTab({Key? key}) : super(key: key);

  @override
  State<InsightTab> createState() => _InsightTabState();
}

class _InsightTabState extends State<InsightTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Tab> tabs = <Tab>[
    Tab(
      text: 'Today',
    ),
    Tab(text: 'Last 7 days'),
  ];
  @override
  void initState() {
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
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
                'Insight',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: TabBar(
                  labelStyle: TextStyle(fontSize: 13),
                  controller: _tabController,
                  tabs: tabs,
                  isScrollable: false,
                  labelColor: Colors.white,
                  indicatorColor: Colors.white,
                  unselectedLabelColor: kLightTextColor,
                  // indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
                ),
              ),
            ),
          ),
          body: TabBarView(
              // physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                InsightPage(),
                InsightLastWeekPage(),
              ])),
    );
  }
}
