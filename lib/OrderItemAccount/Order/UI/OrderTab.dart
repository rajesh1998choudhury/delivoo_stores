// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/OrderItemAccount/Order/PastOrderPage.dart';
import 'package:delivoo_stores/OrderItemAccount/Order/UI/NewOrderPage.dart';
import 'package:delivoo_stores/OrderItemAccount/Order/UI/NextdayOrderPage.dart';
import 'package:delivoo_stores/OrderItemAccount/Order/UI/check_payment.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/OrderProvider.dart';
import '../../../Utils/AppConstants.dart';
import '../../../main.dart';
import '../../order_item_account.dart';

class OrderTab extends StatefulWidget {
  OrderTab({Key? key}) : super(key: key);

  @override
  State<OrderTab> createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Tab> tabs = <Tab>[
    Tab(text: 'NEW ORDERS'),
    Tab(text: 'NEXT DAY ORDERS'),
    Tab(text: 'PAST ORDERS'),
  ];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await context.read<LoginProvider>().getData();
      await context.read<OrderProvider>().getPaymentDetails();
    });
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
      length: 3,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
                context.watch<LoginProvider>().userType == "2" ? 118 : 100.0),
            child: AppBar(
              centerTitle: false,
              title: Row(
                children: [
                  navigatorKey.currentContext!
                                  .watch<LoginProvider>()
                                  .storeLocation ==
                              "0" &&
                          navigatorKey.currentContext!
                                  .watch<LoginProvider>()
                                  .wareHouse ==
                              "0"
                      ? Consumer<LoginProvider>(builder: (context, model, _) {
                          return InkWell(
                            onTap: () async {
                              showLoading();
                              await model.loadStores();
                              hideLoading();
                              storeListBottomSheet(context, model);
                            },
                            child: Container(
                                constraints: BoxConstraints(),
                                //color: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors
                                        .black26, //kMainColor.withOpacity(0.075)

                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.store, color: Colors.white),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Container(
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            context
                                                    .watch<LoginProvider>()
                                                    .storeLocationName ??
                                                'Select Shop',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                            ),
                                            overflow: TextOverflow.fade,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.keyboard_arrow_down,
                                        color: Colors.white),
                                  ],
                                )),
                          );
                        })
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.store,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                context
                                    .watch<LoginProvider>()
                                    .storeLocationName
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ],
                          )),
                  Spacer(),
                  Column(
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: () async {
                              // await context
                              //     .read<OrderProvider>()
                              //     .getPaymentDetails();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return CheckPayment();
                              })));
                            },
                            child: Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.yellow,
                              size: 30,
                            ),
                          ),
                          PositionedDirectional(
                            child: Container(
                              height: 14,
                              width: 20,
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  context
                                              .watch<OrderProvider>()
                                              .paymentStatusDetails
                                              ?.d
                                              .length !=
                                          null
                                      ? context
                                          .watch<OrderProvider>()
                                          .paymentStatusDetails!
                                          .d
                                          .length
                                          .toString()
                                      : '0',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            top: 1,
                            end: -1,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          "Chk Pymt Status",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Container(
                        height: 38,
                        width: 48,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Switch(
                                activeColor: Colors.white,
                                activeTrackColor: Colors.green,
                                // inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.red,
                                value: context
                                            .read<LoginProvider>()
                                            .NotificatonStatus ==
                                        "1"
                                    ? true
                                    : false,
                                onChanged: (value) {
                                  context.read<LoginProvider>().setOnlineStatus(
                                      status: context
                                                  .read<LoginProvider>()
                                                  .NotificatonStatus ==
                                              "1"
                                          ? "0"
                                          : "1");
                                }),
                          ),
                        ),
                      ),
                      Text(
                        context.read<LoginProvider>().NotificatonStatus == "1"
                            ? "Online"
                            : "Ofline",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  )
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    context.watch<LoginProvider>().userType == "2"
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_city,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                Text(
                                  context.watch<LoginProvider>().city ?? "",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    TabBar(
                      onTap: ((value) async {
                        print("value $value");
                        context.read<OrderProvider>().timer?.cancel();
                      }),
                      labelStyle: TextStyle(fontSize: 13),
                      controller: _tabController,
                      tabs: tabs,
                      isScrollable: false,
                      labelColor: kWhiteColor,
                      indicatorColor: Colors.white,

                      ///indic
                      unselectedLabelColor: kLightTextColor,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              NewOrderPage(),
              NextDayOrderPage(),
              PastOrderPage(),
            ],
          ),
        ),
      ),
    );
  }

  storeListBottomSheet(BuildContext context, LoginProvider model) async {
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          final storeList = model.storesList?.d;
          return Container(
            decoration: BoxDecoration(
              // color: kCardBackgroundColor,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: ListView(
              physics: ScrollPhysics(),
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          'Select Shop',
                          style: TextStyle(color: kWhiteColor, fontSize: 20),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: kWhiteColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )),
                Container(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: storeList?.length ?? 0,
                    itemBuilder: (context, index) {
                      print(storeList?.length);
                      return Stack(
                        children: [
                          Column(
                            children: [
                              ListTile(
                                onTap: () async {
                                  await model.getStoreLocation(
                                      storeList[index].warehouseId,
                                      storeList[index].storeLocation);

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OrderItemAccount()),
                                      (route) => false);
                                },
                                leading: Container(
                                  height: 100,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    image: storeList![index].storeImage != null
                                        ? DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                BaseUrl +
                                                    'companyImages/' +
                                                    storeList[index]
                                                        .storeImage
                                                        .toString(),
                                                cacheKey:
                                                    storeList[index].storeImage
                                                // fit: BoxFit.cover,
                                                ),
                                            onError: (exception, stackTrace) {
                                              storeList[index].storeImage =
                                                  null;
                                            },
                                          )
                                        : DecorationImage(
                                            image: AssetImage(
                                              'images/logos/alphastore_icon.png',
                                            ),
                                          ),
                                  ),
                                ),
                                title: Text(storeList[index].storeLocation!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            fontSize: 15,
                                            color: kMainColor,
                                            fontWeight: FontWeight.w500)),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Address:" + storeList[index].address1!,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "Contact:" + storeList[index].contactNo!,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Theme.of(context).cardColor,
                                thickness: 6.0,
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
                                child: context
                                            .watch<LoginProvider>()
                                            .storeLocationName ==
                                        storeList[index].storeLocation!
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                        child: Center(
                                            child: Icon(Icons.check_rounded)),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
