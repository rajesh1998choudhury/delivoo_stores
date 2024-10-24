// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Components/card_content.dart';
import 'package:delivoo_stores/Components/loading_shimmer.dart';
import 'package:delivoo_stores/Components/reusable_card.dart';
import 'package:delivoo_stores/Pages/categoryItems.dart';
import 'package:delivoo_stores/Provider/CategoryProvider.dart';
import 'package:delivoo_stores/Provider/ProductProvider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/login_provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<CategoryProvider>().getCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories?.d;
    return WillPopScope(
      onWillPop: () {
        context.read<LoginProvider>().onTapped(0);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Category',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
        body: context.watch<CategoryProvider>().Loading
            ? LoadingShimmer()
            : categories?.length == null || categories?.length == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No Category Found"),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(kMainColor)),
                            onPressed: () async {
                              showLoading();
                              await context
                                  .read<CategoryProvider>()
                                  .getCategory();
                              hideLoading();
                            },
                            icon: Icon(Icons.refresh, color: Colors.white),
                            label: Text(
                              "Click to Refresh",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: kMainColor,
                    onRefresh: () async {
                      await context.read<CategoryProvider>().getCategory();
                    },
                    child: Container(
                      child: GridView.builder(
                        padding: EdgeInsets.all(8),
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height / 1.25),
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                        primary: true,
                        shrinkWrap: true,
                        itemCount: categories?.length,
                        itemBuilder: (context, index) {
                          return ReusableCard(
                              cardChild: categories?[index].catStatus == "0"
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                image: categories?[index]
                                                                .catimg !=
                                                            null &&
                                                        categories?[index]
                                                                .catimg !=
                                                            ''
                                                    ? DecorationImage(
                                                        opacity: 0.7,
                                                        invertColors: true,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          Colors.black.withOpacity(
                                                              1), // 0 = Colored, 1 = Black & White
                                                          BlendMode.saturation,
                                                        ),
                                                        onError: (exception,
                                                            stackTrace) {
                                                          categories[index]
                                                              .catimg = null;
                                                        },
                                                        image: CachedNetworkImageProvider(
                                                            BaseUrl +
                                                                SUBCAT_IMAGES +
                                                                categories![
                                                                        index]
                                                                    .catimg
                                                                    .toString(),
                                                            cacheKey:
                                                                categories[
                                                                        index]
                                                                    .catimg))
                                                    : DecorationImage(
                                                        invertColors: true,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          Colors.black.withOpacity(
                                                              1), // 0 = Colored, 1 = Black & White
                                                          BlendMode.saturation,
                                                        ),
                                                        image: AssetImage(
                                                          'images/logos/not-available.png',
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              categories![index].catName,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge,
                                            ))
                                      ],
                                    )
                                  : CardContent(
                                      image: categories?[index].catimg !=
                                                  null &&
                                              categories?[index].catimg != ''
                                          ? DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  BaseUrl +
                                                      SUBCAT_IMAGES +
                                                      categories![index]
                                                          .catimg
                                                          .toString(),
                                                  cacheKey:
                                                      categories[index].catimg),
                                              onError: (exception, stackTrace) {
                                                categories[index].catimg = null;
                                              },
                                            )
                                          : DecorationImage(
                                              image: AssetImage(
                                                  'images/logos/not-available.png')),
                                      text: categories?[index].catName,
                                    ),
                              onPress: categories?[index].catStatus == "0"
                                  ? () {
                                      null;
                                    }
                                  : () async {
                                      await context
                                          .read<ProductProvider>()
                                          .setTabIndex(index);
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString('my_catId',
                                          categories![index].catid.toString());
                                      prefs.setString(
                                          'my_sectionId',
                                          categories[index]
                                              .sectionid
                                              .toString());

                                      var response = await context
                                          .read<CategoryProvider>()
                                          .getSubcategory(
                                              categories[index].catid);
                                      await context
                                          .read<ProductProvider>()
                                          .getProductsByCategory(
                                              catId: categories[index].catid,
                                              sectionId:
                                                  categories[index].sectionid,
                                              searchtxt: '',
                                              loading: true);
                                      var subcat = await context
                                          .read<CategoryProvider>()
                                          .subcategories
                                          ?.d;
                                      print("subcat ${subcat?.length}");
                                      if (response == "success" &&
                                          subcat!.length != 0) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryItemsPage(
                                                        catName:
                                                            categories[index]
                                                                .catName)));
                                      } else
                                        showMessageDialog(context,
                                            'No items in this category at this moment');
                                    });
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
