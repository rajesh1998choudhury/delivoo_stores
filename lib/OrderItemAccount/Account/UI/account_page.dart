// ignore_for_file: deprecated_member_use
import 'package:app_settings/app_settings.dart';
import 'package:delivoo_stores/Auth/MobileNumber/UI/phone_number.dart';
import 'package:delivoo_stores/Components/list_tile.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/insight_tab.dart';
import 'package:delivoo_stores/OrderItemAccount/Account/UI/ListItems/privacy_policy.dart';
import 'package:delivoo_stores/Pages/cityList.dart';
import 'package:delivoo_stores/Pages/return_items/return_items.dart';
import 'package:delivoo_stores/Provider/insight_provider.dart';
import 'package:delivoo_stores/Provider/profileProvider.dart';
import 'package:delivoo_stores/Routes/routes.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Pages/return_store_items/return_store_items.dart';
import '../../../Pages/stock transfer/stock_receive.dart';
import '../../../Pages/stock transfer/stock_tranfer.dart';
import '../../../Provider/login_provider.dart';
import '../../../StoreOrdering/Pages/MyOrders/storeOrdering_myOrdersTab.dart';
import '../../../StoreOrdering/StoreOrderingProvider/paymentProvider.dart';
import '../../../StoreOrdering/StoreOrderingProvider/store_product_provider.dart';
import 'ListItems/support_page.dart';
import 'ListItems/wallet_page.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<LoginProvider>().onTapped(
            context.read<LoginProvider>().storeType == "1" ||
                    context.read<LoginProvider>().storeType == "2"
                ? 0
                : 2);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Account',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Account(),
      ),
    );
  }
}

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? number;

  @override
  void initState() {
    super.initState();
    context.read<LoginProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(),
        Divider(
          color: kCardBackgroundColor,
          thickness: 8.0,
        ),
        Column(
          children: <Widget>[
            // context.watch<LoginProvider>().storeType == "0"
            //     ? SizedBox.shrink():
            BuildListTile(
              image: 'images/account/user.png',
              text: 'Edit Profile',
              onTap: () async {
                await context.read<ProfileProvider>().getCustomerInfo();
                var response = await context
                    .read<LoginProvider>()
                    .assignAvailablePincode(context
                                    .read<ProfileProvider>()
                                    .companyInfoDetais!
                                    .d!
                                    .companyinfo!
                                    .comppincode ==
                                null ||
                            context
                                    .read<ProfileProvider>()
                                    .companyInfoDetais!
                                    .d!
                                    .companyinfo!
                                    .comppincode ==
                                ""
                        ? "411007"
                        : context
                            .read<ProfileProvider>()
                            .companyInfoDetais!
                            .d!
                            .companyinfo!
                            .comppincode);
                if (response == "0") {
                  await context
                      .read<LoginProvider>()
                      .assignAvailablePincode("411007");
                  context
                      .read<ProfileProvider>()
                      .companyInfoDetais!
                      .d!
                      .companyinfo!
                      .comppincode = "411007";
                }
                Navigator.pushNamed(context, PageRoutes.editProfile);
              },
            ),
            context.watch<LoginProvider>().storeType == "0"
                ? SizedBox.shrink()
                : BuildListTile(
                    image: 'images/account/checklist.png',
                    text: 'Schedule Delivery Slots',
                    onTap: () async {
                      await context.read<ProfileProvider>().getCustomerInfo();
                      if (await context
                                  .read<ProfileProvider>()
                                  .companyInfoDetais!
                                  .d!
                                  .companyinfo!
                                  .deliveryType ==
                              "1" ||
                          await context
                                  .read<ProfileProvider>()
                                  .companyInfoDetais!
                                  .d!
                                  .companyinfo!
                                  .deliveryType !=
                              "2") {
                        showMessage(
                            "Please Change Delivery Type into Slot Delivery");
                      } else if (await context
                                  .read<ProfileProvider>()
                                  .companyInfoDetais!
                                  .d!
                                  .companyinfo!
                                  .openTime ==
                              "" ||
                          await context
                                  .read<ProfileProvider>()
                                  .companyInfoDetais!
                                  .d!
                                  .companyinfo!
                                  .closeTime ==
                              "") {
                        showMessage(
                            "Update Time Slots First From Edit Profile Page");
                      } else {
                        await context.read<ProfileProvider>().updateSlots(
                            action: "4",
                            slotonoff: "",
                            slotId: "",
                            orderLimit: "");
                        context
                                    .read<ProfileProvider>()
                                    .deliverySlot!
                                    .d!
                                    .length ==
                                0
                            ? showMessage(
                                "No slots Available, Please Update Slots or Change Delivery Type.")
                            : showModalBottomSheet(
                                isDismissible: false,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: kCardBackgroundColor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: kMainColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Spacer(),
                                                Text(
                                                  'Select Time Slot',
                                                  style: TextStyle(
                                                      color: kWhiteColor,
                                                      fontSize: 20),
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.45,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: GridView.builder(
                                            padding: EdgeInsets.all(8),
                                            physics: ScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    childAspectRatio:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                1.7),
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5),
                                            primary: true,
                                            shrinkWrap: true,
                                            itemCount: context
                                                .watch<ProfileProvider>()
                                                .deliverySlot
                                                ?.d
                                                ?.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: context
                                                                    .read<
                                                                        ProfileProvider>()
                                                                    .deliverySlot!
                                                                    .d![index]
                                                                    .slotstatus !=
                                                                '0'
                                                            ? kMainColor
                                                            : Colors.grey)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      context
                                                          .watch<
                                                              ProfileProvider>()
                                                          .deliverySlot!
                                                          .d![index]
                                                          .slotstarttime!
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      "To",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      context
                                                          .watch<
                                                              ProfileProvider>()
                                                          .deliverySlot!
                                                          .d![index]
                                                          .slotendtime!
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Switch(
                                                              activeColor:
                                                                  kMainColor,
                                                              inactiveTrackColor:
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          0.5),
                                                              inactiveThumbColor:
                                                                  Colors.white,
                                                              value: context
                                                                          .read<
                                                                              ProfileProvider>()
                                                                          .deliverySlot!
                                                                          .d![
                                                                              index]
                                                                          .slotstatus !=
                                                                      '0'
                                                                  ? true
                                                                  : false,
                                                              onChanged:
                                                                  (value) async {
                                                                var slotOnOff =
                                                                    value ==
                                                                            false
                                                                        ? "0"
                                                                        : "1";
                                                                await context.read<ProfileProvider>().updateSlots(
                                                                    action: "1",
                                                                    slotonoff:
                                                                        slotOnOff,
                                                                    slotId: context
                                                                        .read<
                                                                            ProfileProvider>()
                                                                        .deliverySlot!
                                                                        .d![
                                                                            index]
                                                                        .slotid,
                                                                    orderLimit: context
                                                                        .read<
                                                                            ProfileProvider>()
                                                                        .deliverySlot!
                                                                        .d![index]
                                                                        .orderlimit);
                                                              }),
                                                        ),
                                                        Text(
                                                          context
                                                                      .read<
                                                                          ProfileProvider>()
                                                                      .deliverySlot!
                                                                      .d![index]
                                                                      .slotstatus !=
                                                                  '0'
                                                              ? "Active"
                                                              : "InActive",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: context
                                                                          .read<
                                                                              ProfileProvider>()
                                                                          .deliverySlot!
                                                                          .d![
                                                                              index]
                                                                          .slotstatus !=
                                                                      '0'
                                                                  ? kMainColor
                                                                  : Colors
                                                                      .grey),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "OrderLimit: " +
                                                          context
                                                              .watch<
                                                                  ProfileProvider>()
                                                              .deliverySlot!
                                                              .d![index]
                                                              .orderlimit
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                      }
                    },
                  ),
            BuildListTile(
                image: 'images/account/ic_menu_wallet.png',
                text: "Wallet",
                onTap: () async {
                  var x =
                      await context.read<PaymentProvider>().getwalletdetails();
                  context.read<PaymentProvider>().getwalletAmount();
                  if (x != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WalletPage();
                    }));
                  }
                }),
            context.watch<LoginProvider>().userType != "2"
                ? SizedBox.shrink()
                : BuildListTile(
                    image: 'images/account/city.png',
                    text: 'Change City',
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityList();
                      }));
                    },
                  ),
            BuildListTile(
                image: 'images/footermenu/shopping-bag.png',
                text: "My Orders",
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StoreOrderingOrderTab();
                  }));
                }),
            context.watch<LoginProvider>().storeType == "0"
                ? SizedBox.shrink()
                : BuildListTile(
                    image: 'images/account/return.png',
                    text: 'Customer Return Items',
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ReturnItemsPage();
                      }));
                    },
                  ),
            context.watch<LoginProvider>().storeType == "0"
                ? SizedBox.shrink()
                : BuildListTile(
                    image: 'images/account/basket.png',
                    text: 'Store Return Items (RTV)',
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ReturnStoreItemsPage();
                      }));
                    },
                  ),
            context.watch<LoginProvider>().storeType == "0"
                ? SizedBox.shrink()
                : Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    child: ExpansionTile(
                      iconColor: kMainColor,
                      textColor: kMainColor,
                      leading: Image.asset(
                        'images/account/goods.png',
                        height: 30.3,
                      ),
                      title: Text(
                        "Stock Transfer",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      children: [
                        BuildListTile(
                            image: 'images/account/exchange.png',
                            text: 'Store Stock Transfer',
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('new_CatId', "1");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StockTranserPage()));
                            }),
                        BuildListTile(
                            image: 'images/logos/received.png',
                            text: 'Store Stock Received',
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StoreStockReceive()));
                            }),
                      ],
                    ),
                  ),
            context.watch<LoginProvider>().storeType == "0"
                ? SizedBox.shrink()
                : BuildListTile(
                    image: 'images/account/ic_menu_insight.png',
                    text: 'Insight',
                    onTap: () async {
                      await context.read<InsightProvider>().earning();
                      await context.read<InsightProvider>().generateData();
                      await context.read<InsightProvider>().itemSells();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return InsightTab();
                      }));
                    }),
            context.watch<LoginProvider>().storeType == "0"
                ? SizedBox.shrink()
                : BuildListTile(
                    image: 'images/account/calendar.png',
                    text: 'Holiday Listing',
                    onTap: () async {
                      var response = await context
                          .read<ProfileProvider>()
                          .updateHoliday(
                              action: 5, holidayDate: "", holidayId: "");
                      response == "sucess"
                          ? Navigator.pushNamed(
                              context, PageRoutes.holidayListing)
                          : "";
                    },
                  ),
            BuildListTile(
              image: 'images/account/notification.png',
              text: 'Notification Settings',
              onTap: () async {
                AppSettings.openNotificationSettings();
              },
            ),
            BuildListTile(
              image: 'images/account/battery.png',
              text: 'Battery Optimization',
              onTap: () async {
                AppSettings.openBatteryOptimizationSettings();
              },
            ),
            BuildListTile(
              image: 'images/account/ic_menu_supportact.png',
              text: 'Support',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupportPage(
                            number: 'number',
                          ))),
            ),
            BuildListTile(
              image: 'images/account/ic_menu_tncact.png',
              text: 'Privacy Policy',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => PrivacyPolicy()))),
            ),
            DeleteTile(),
            LogoutTile(),
          ],
        ),
      ],
    );
  }
}

class LogoutTile extends StatelessWidget {
  const LogoutTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildListTile(
      image: 'images/account/ic_menu_logoutact.png',
      text: 'Logout',
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Logging Out',
                ),
                content: Text(
                  'Are you sure?',
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(
                      'No',
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: TextStyle(color: kWhiteColor),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green)),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                      child: Text(
                        'Yes',
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        textStyle: TextStyle(color: kWhiteColor),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.redAccent)),
                      ),
                      onPressed: () async {
                        showLoading();
                        if (context
                                    .read<StoreOrderingProductProvider>()
                                    .cartitems
                                    ?.d
                                    ?.length !=
                                0 &&
                            context
                                    .read<StoreOrderingProductProvider>()
                                    .cartitems
                                    ?.d !=
                                null) {
                          await context
                              .read<StoreOrderingProductProvider>()
                              .removeallProducts();
                        }

                        await context
                            .read<LoginProvider>()
                            .pushNotifications("2");
                        SharedPreferences _prefs =
                            await SharedPreferences.getInstance();
                        await _prefs.clear();
                        await _prefs.setString('skipNotification', 'true');
                        hideLoading();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneNumber()),
                            (route) => false);
                      })
                ],
              );
            });
      },
    );
  }
}

class DeleteTile extends StatelessWidget {
  const DeleteTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildListTile(
      image: 'images/account/delete.png',
      text: "Delete Account",
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: Text(
                  "Delete Account!",
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Are you sure that you want to delete your kisanserv store account?",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Text(
                      "Please note that there is no option to restore the account or its data once it's deleted.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                    Text(
                      "If you still want to delete kisanserv account then hit Delete Account Button",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: TextStyle(color: kWhiteColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.green)),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                      child: Text("Delete Account"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        textStyle: TextStyle(color: kWhiteColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.redAccent)),
                      ),
                      onPressed: () async {
                        await context.read<ProfileProvider>().deleteAccount();
                      })
                ],
              );
            });
      },
    );
  }
}

class StoreDetails extends StatelessWidget {
  const StoreDetails();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Image(
            image: AssetImage("images/layer_1.png"), //delivoo logo
            height: 98.0,
            width: 98.0,
          ),
          SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Silver Leaf Vegetables',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 15.0, fontWeight: FontWeight.w500)),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: kLightTextColor,
                    size: 9.0,
                  ),
                  SizedBox(width: 5.0),
                  Text('Union Market',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Color(0xff4a4b48), fontSize: 13.3)),
                ],
              ),
              GestureDetector(
                  child: Text(
                    '\nStore Profile',
                    style: TextStyle(
                        color: kMainColor,
                        fontSize: 13.3,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () async {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    _prefs.clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => PhoneNumber()),
                        (route) => false);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
