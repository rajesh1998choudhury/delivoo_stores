import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Provider/login_provider.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../OrderItemAccount/order_item_account.dart';
import '../Themes/colors.dart';
import '../Utils/AppConstants.dart';

class StoreList extends StatefulWidget {
  StoreList({Key? key}) : super(key: key);

  @override
  State<StoreList> createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  @override
  void initState() {
    context.read<LoginProvider>().loadStores();
    super.initState();
  }

  var wareHouse;

  @override
  Widget build(BuildContext context) {
    final storeList = context.watch<LoginProvider>().storesList?.d;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Store",
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
      body: Container(
        child: Scrollbar(
          thickness: 10,
          thumbVisibility: true,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: storeList?.length ?? 0,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () async {
                      showLoading();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('skippedOnboard', 'true');
                      await context.read<LoginProvider>().getStoreLocation(
                          storeList[index].warehouseId,
                          storeList[index].storeLocation);
                      hideLoading();
                      await context.read<LoginProvider>().onTapped(0);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderItemAccount()),
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
                                        storeList[index].storeImage.toString(),
                                    cacheKey: storeList[index].storeImage
                                    // fit: BoxFit.cover,
                                    ),
                                onError: (exception, stackTrace) {
                                  storeList[index].storeImage = null;
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15,
                            color: kMainColor,
                            fontWeight: FontWeight.w500)),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address:" + storeList[index].address1.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Picode:" + storeList[index].pincode.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Contact:" + storeList[index].contactNo.toString(),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
