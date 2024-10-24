import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/StoreOrdering/Models/storeOrdering_product_model.dart';
import 'package:delivoo_stores/StoreOrdering/Pages/storeOrdering_searchDelegate.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/custom_appbar.dart';
import '../../Provider/login_provider.dart';
import '../../Routes/routes.dart';
import '../../Themes/colors.dart';
import '../../Utils/AppConstants.dart';
import '../StoreOrderingProvider/storeOrdering_category_provider.dart';
import '../StoreOrderingProvider/store_product_provider.dart';

class StoreOrderingCategoryItemPage extends StatefulWidget {
  final String? catName;
  const StoreOrderingCategoryItemPage({Key? key, this.catName})
      : super(key: key);

  @override
  State<StoreOrderingCategoryItemPage> createState() =>
      _StoreOrderingCategoryItemPageState();
}

class _StoreOrderingCategoryItemPageState
    extends State<StoreOrderingCategoryItemPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabcontroller;
  @override
  void initState() {
    final subcategories =
        context.read<StoreOrderingCategoryProvider>().subcategories?.d;
    _tabcontroller = TabController(
      initialIndex: context.read<StoreOrderingProductProvider>().tabIndex,
      length: subcategories!.length,
      vsync: this,
    );
    if (context.read<StoreOrderingProductProvider>().cartitems != null ||
        context.read<StoreOrderingProductProvider>().cartitems?.d?.length !=
            0) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final products = context.watch<StoreOrderingProductProvider>().products?.d;
    final subcategories =
        context.read<StoreOrderingCategoryProvider>().subcategories?.d;
    final checkout = context.watch<StoreOrderingProductProvider>().cartTotal?.d;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: context
                            .read<StoreOrderingProductProvider>()
                            .cartitems
                            ?.d!
                            .length !=
                        0 &&
                    context
                            .watch<StoreOrderingProductProvider>()
                            .cartitems
                            ?.d !=
                        null
                ? size.height * 0.90
                : size.height,
            child: DefaultTabController(
              length: subcategories!.length,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(140.0),
                  child: CustomAppBar(
                    titleWidget: Text(widget.catName ?? "",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            )),
                    actions: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: InkWell(
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: StoreOrderingCustomSearchDelegate());
                          },
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                      )
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TabBar(
                            tabAlignment: TabAlignment.start,
                            controller: _tabcontroller,
                            onTap: (value) {
                              Future.delayed(Duration(milliseconds: 300),
                                  () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await context
                                    .read<StoreOrderingProductProvider>()
                                    .getProductsByCategory(
                                        catId: prefs.getString('catId'),
                                        sectionId:
                                            subcategories[value].sectionid!,
                                        searchtxt: '');
                              });
                            },
                            tabs: List.generate(
                              subcategories.length,
                              (index) => Tab(
                                  height: 100,
                                  icon: Column(
                                    children: [
                                      SizedBox(
                                        height: 2,
                                      ),
                                      subcategories[index].sectionimg != null &&
                                              subcategories[index].sectionimg !=
                                                  ''
                                          ? CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.white,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      BaseUrl +
                                                          SUBCAT_IMAGES +
                                                          subcategories[index]
                                                              .sectionimg!,
                                                      errorListener:
                                                          (VoidCallbackIntent) {
                                                subcategories[index]
                                                    .sectionimg = "";
                                              },
                                                      cacheKey:
                                                          subcategories[index]
                                                              .sectionimg!))
                                          : CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                  'images/logos/not-available.png'),
                                            ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Text(
                                          subcategories[index].sectionName!,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            isScrollable: true,
                            labelColor: Colors.white,
                            unselectedLabelColor: kLightTextColor,
                            labelPadding: EdgeInsets.all(4),
                            indicatorColor: Colors.white,
                            // indicatorPadding:
                            //     EdgeInsets.symmetric(horizontal: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: products != null
                    ? TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabcontroller,
                        children:
                            List.generate(subcategories.length, (int index) {
                          return FadedScaleAnimation(
                            child: products.length == 0
                                ? Center(
                                    child: Image.asset(
                                      'images/logos/soldout.png',
                                      scale: 5,
                                    ),
                                  )
                                : ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Divider(
                                            color: Theme.of(context).cardColor,
                                            thickness: 8.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: products[index]
                                                              .productDetails![
                                                                  products[
                                                                          index]
                                                                      .productDetailsIndex]
                                                              .outofstock ==
                                                          0
                                                      ? null
                                                      : () async {
                                                          await context
                                                              .read<
                                                                  StoreOrderingProductProvider>()
                                                              .getProductIndex(
                                                                  products[
                                                                      index],
                                                                  index);

                                                          Navigator.pushNamed(
                                                            context,
                                                            PageRoutes
                                                                .storeProductDescription,
                                                          );
                                                        },
                                                  child: Container(
                                                    height: 100,
                                                    width: 90,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: products[index]
                                                                            .productDetails![products[index]
                                                                                .productDetailsIndex]
                                                                            .discountPercentage !=
                                                                        '0' &&
                                                                    products[index]
                                                                            .productDetails![products[index]
                                                                                .productDetailsIndex]
                                                                            .discountPercentage !=
                                                                        '0.00'
                                                                ? Container(
                                                                    width: 60,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .indigo,
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(7),
                                                                            bottomRight: Radius.circular(7))),
                                                                    child: Padding(
                                                                        padding: EdgeInsets.only(left: 2),
                                                                        child: Center(
                                                                          child: Text(
                                                                              '${double.parse(products[index].productDetails![products[index].productDetailsIndex].discountPercentage!).toStringAsFixed(0)}' + '% off',
                                                                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                                                        )))
                                                                : Container())
                                                      ],
                                                    ),
                                                    decoration: BoxDecoration(
                                                        image: products[index].productDetails![products[index].productDetailsIndex].productimage !=
                                                                    null &&
                                                                products[index]
                                                                        .productDetails![products[index]
                                                                            .productDetailsIndex]
                                                                        .productimage !=
                                                                    "0" &&
                                                                products[index]
                                                                        .productDetails![products[index]
                                                                            .productDetailsIndex]
                                                                        .productimage !=
                                                                    ""
                                                            ? DecorationImage(
                                                                colorFilter: products[index]
                                                                            .productDetails![products[index]
                                                                                .productDetailsIndex]
                                                                            .outofstock ==
                                                                        0
                                                                    ? ColorFilter
                                                                        .mode(
                                                                        Colors
                                                                            .black
                                                                            .withOpacity(1), // 0 = Colored, 1 = Black & White
                                                                        BlendMode
                                                                            .saturation,
                                                                      )
                                                                    : ColorFilter
                                                                        .mode(
                                                                        Colors
                                                                            .black
                                                                            .withOpacity(0), // 0 = Colored, 1 = Black & White
                                                                        BlendMode
                                                                            .screen,
                                                                      ),
                                                                image: CachedNetworkImageProvider(
                                                                    BaseUrl +
                                                                        'skuimages/' +
                                                                        products[index]
                                                                            .productDetails![products[index]
                                                                                .productDetailsIndex]
                                                                            .productimage!,
                                                                    errorListener:
                                                                        (VoidCallbackIntent) {
                                                                  products[
                                                                          index]
                                                                      .productDetails![
                                                                          products[index]
                                                                              .productDetailsIndex]
                                                                      .productimage = "";
                                                                },
                                                                    cacheKey: products[
                                                                            index]
                                                                        .productDetails![
                                                                            products[index].productDetailsIndex]
                                                                        .productimage!),
                                                                onError: (exception,
                                                                    stackTrace) {
                                                                  products[
                                                                          index]
                                                                      .productDetails![
                                                                          products[index]
                                                                              .productDetailsIndex]
                                                                      .productimage = "";
                                                                },
                                                              )
                                                            : products[index]
                                                                            .productImage ==
                                                                        null &&
                                                                    products[index]
                                                                            .productImage ==
                                                                        "0" &&
                                                                    products[index]
                                                                            .productImage ==
                                                                        ""
                                                                ? DecorationImage(
                                                                    image:
                                                                        AssetImage(
                                                                      'images/logos/not-available.png',
                                                                    ),
                                                                  )
                                                                : DecorationImage(
                                                                    image: CachedNetworkImageProvider(
                                                                        BaseUrl +
                                                                            'skuimages/' +
                                                                            products[index].productImage!,
                                                                        errorListener:
                                                                            (void
                                                                                function) {
                                                                      products[
                                                                              index]
                                                                          .productImage = "";
                                                                    },
                                                                        cacheKey:
                                                                            products[index].productImage),
                                                                    onError:
                                                                        (exception,
                                                                            stackTrace) {
                                                                      products[
                                                                              index]
                                                                          .productImage = "";
                                                                    },
                                                                  )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                            products[index]
                                                                    .productName ??
                                                                '',
                                                            maxLines: 3,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headlineLarge!
                                                                .copyWith(
                                                                    color: products[index].productDetails![products[index].productDetailsIndex].outofstock ==
                                                                            1
                                                                        ? kMainTextColor
                                                                        : Colors
                                                                            .grey,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis)),
                                                      ),
                                                      // SizedBox(
                                                      //     height: context
                                                      //                 .read<
                                                      //                     LoginProvider>()
                                                      //                 .storeType ==
                                                      //             "1"
                                                      //         ? 5.0
                                                      //         : 10),
                                                      context
                                                                  .read<
                                                                      LoginProvider>()
                                                                  .storeType ==
                                                              "0"
                                                          ? SizedBox.shrink()
                                                          : products[index]
                                                                      .productDetails![
                                                                          products[index]
                                                                              .productDetailsIndex]
                                                                      .stock ==
                                                                  0
                                                              ? SizedBox
                                                                  .shrink()
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              22.0,
                                                                          bottom:
                                                                              5),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        "In Stock:",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall!,
                                                                      ),
                                                                      Container(
                                                                        child: Text(
                                                                            products[index].productDetails![products[index].productDetailsIndex].stock.toString(),
                                                                            maxLines: 3,
                                                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                                  color: products[index].productDetails![products[index].productDetailsIndex].outofstock == 1 ? kMainTextColor : Colors.grey,
                                                                                )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 22.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            products[index]
                                                                            .productDetails![products[index]
                                                                                .productDetailsIndex]
                                                                            .avgSale !=
                                                                        null &&
                                                                    double.tryParse(products[index]
                                                                            .productDetails![products[index].productDetailsIndex]
                                                                            .avgSale!)! >
                                                                        0.00
                                                                ? Text(
                                                                    'Projected Sale:  ${products[index].productDetails![products[index].productDetailsIndex].avgSale!.toString()}',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                          color: products[index].productDetails![products[index].productDetailsIndex].outofstock == 1
                                                                              ? kMainTextColor
                                                                              : Colors.grey,
                                                                        ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 22.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                '\₹ ${products[index].productDetails![products[index].productDetailsIndex].productRate!.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        color: products[index].productDetails![products[index].productDetailsIndex].outofstock ==
                                                                                1
                                                                            ? kMainTextColor
                                                                            : Colors.grey)),
                                                            SizedBox(width: 5),
                                                            products[index]
                                                                        .productDetails![products[index]
                                                                            .productDetailsIndex]
                                                                        .productMrp !=
                                                                    '0'
                                                                ? Text(
                                                                    '\₹ ${double.parse(products[index].productDetails![products[index].productDetailsIndex].productMrp!).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.grey,
                                                                            decoration: TextDecoration.lineThrough))
                                                                : Container(),
                                                            Spacer(),
                                                            products[index]
                                                                        .productDetails![products[index]
                                                                            .productDetailsIndex]
                                                                        .productQty! >
                                                                    0
                                                                ? Text(
                                                                    '\₹ ${(products[index].productDetails![products[index].productDetailsIndex].productRate! * products[index].productDetails![products[index].productDetailsIndex].productQty!.toDouble()).toDouble().toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!)
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),

                                                      // SizedBox(height: 10.0),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              showModalBottomSheet(
                                                                // shape:
                                                                //     RoundedRectangleBorder(
                                                                //   borderRadius:
                                                                //       BorderRadius
                                                                //           .only(
                                                                //     topLeft: Radius
                                                                //         .circular(
                                                                //             20.0),
                                                                //     topRight: Radius
                                                                //         .circular(
                                                                //             20.0),
                                                                //   ),
                                                                // ),
                                                                // isScrollControlled:
                                                                //     true,
                                                                // isDismissible:
                                                                //     true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(20),
                                                                            topRight: Radius.circular(20)),
                                                                      ),
                                                                      height:
                                                                          310,
                                                                      child:
                                                                          BottomSheetWidget(
                                                                        catName:
                                                                            widget.catName,
                                                                        index:
                                                                            index,
                                                                      ));
                                                                },
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 30.0,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          08.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <Widget>[
                                                                  Text(
                                                                      products[index]
                                                                              .productDetails![products[index]
                                                                                  .productDetailsIndex]
                                                                              .productWeight ??
                                                                          '',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodySmall!
                                                                          .copyWith(
                                                                              color: products[index].productDetails![products[index].productDetailsIndex].outofstock == 1 ? kMainTextColor : Colors.grey)),
                                                                  SizedBox(
                                                                    width: 5.0,
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down,
                                                                    color: products[index].productDetails![products[index].productDetailsIndex].outofstock ==
                                                                            1
                                                                        ? kMainColor
                                                                        : Colors
                                                                            .grey,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          products[index]
                                                                      .productDetails![
                                                                          products[index]
                                                                              .productDetailsIndex]
                                                                      .outofstock ==
                                                                  1
                                                              ? products[index]
                                                                              .productDetails![products[index]
                                                                                  .productDetailsIndex]
                                                                              .productQty !=
                                                                          0 &&
                                                                      products[index]
                                                                              .productDetails![products[index]
                                                                                  .productDetailsIndex]
                                                                              .productQty !=
                                                                          null
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        editQuantity(
                                                                            context,
                                                                            products,
                                                                            index);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .edit,
                                                                        size:
                                                                            15,
                                                                        color:
                                                                            kMainColor,
                                                                      ),
                                                                    )
                                                                  : SizedBox
                                                                      .shrink()
                                                              : SizedBox
                                                                  .shrink(),
                                                          Spacer(),
                                                          products[index]
                                                                      .productDetails![
                                                                          products[index]
                                                                              .productDetailsIndex]
                                                                      .outofstock ==
                                                                  1
                                                              ? products[index]
                                                                              .productDetails![products[index]
                                                                                  .productDetailsIndex]
                                                                              .productQty ==
                                                                          0 ||
                                                                      products[index]
                                                                              .productDetails![products[index]
                                                                                  .productDetailsIndex]
                                                                              .productQty ==
                                                                          null
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              6.0),
                                                                      child: products[index].isloading ==
                                                                              true
                                                                          ? SizedBox(
                                                                              child: CircularProgressIndicator(
                                                                                color: kMainColor,
                                                                                strokeWidth: 2,
                                                                              ),
                                                                              width: MediaQuery.of(context).size.width * 0.1)
                                                                          : InkWell(
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                                                      border: Border.all(
                                                                                        color: kMainColor,
                                                                                      )),
                                                                                  height: MediaQuery.of(context).size.height * 0.05,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.shopping_cart_outlined,
                                                                                          color: kMainColor,
                                                                                          size: 15,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        Text(
                                                                                          'Add',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kMainColor, fontWeight: FontWeight.bold),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )),
                                                                              onTap: () {
                                                                                context.read<StoreOrderingProductProvider>().increaseCount(index);
                                                                              }),
                                                                    )
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              6.0),
                                                                      child: products[index].isloading ==
                                                                              true
                                                                          ? SizedBox(
                                                                              child: CircularProgressIndicator(
                                                                                color: kMainColor,
                                                                                strokeWidth: 2,
                                                                              ),
                                                                              width: MediaQuery.of(context).size.width * 0.1)
                                                                          : Container(
                                                                              alignment: Alignment.center,
                                                                              height: MediaQuery.of(context).size.height * 0.05,
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: kMainColor),
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                              ),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  IconButton(
                                                                                    padding: EdgeInsets.all(2),
                                                                                    icon: Icon(Icons.remove),
                                                                                    color: kMainColor,
                                                                                    onPressed: () {
                                                                                      context.read<StoreOrderingProductProvider>().decreaseCount(index);
                                                                                    },
                                                                                  ),
                                                                                  InkWell(
                                                                                      onTap: () {
                                                                                        editQuantity(context, products, index);
                                                                                      },
                                                                                      child: Text(products[index].productDetails![products[index].productDetailsIndex].productQty.toString(), style: Theme.of(context).textTheme.bodySmall!)),
                                                                                  IconButton(
                                                                                      padding: EdgeInsets.all(2.0),
                                                                                      icon: Icon(
                                                                                        Icons.add,
                                                                                      ),
                                                                                      color: kMainColor,
                                                                                      onPressed: () {
                                                                                        context.read<StoreOrderingProductProvider>().increaseCount(index);
                                                                                      }),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                    )
                                                              : Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
                                                                  child: Text(
                                                                    'Out of Stock',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.grey),
                                                                  )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                          );
                        }).toList(),
                      )
                    : Container(
                        child: Center(
                          child: Image.asset(
                            'images/logos/soldout.png',
                            scale: 5,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          context.watch<StoreOrderingProductProvider>().cartitems?.d?.length !=
                      0 &&
                  context.watch<StoreOrderingProductProvider>().cartitems?.d !=
                      null
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/icons/cart.png',
                          height: 19.0,
                          width: 18.3,
                        ),
                        SizedBox(width: 20.7),
                        Text(
                          'Items: ${context.watch<StoreOrderingProductProvider>().cartitems?.d?.length} | \u{20B9} ${checkout?[0].posttaxamount != null ? checkout![0].posttaxamount : "0"}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                        Spacer(),
                        FadedScaleAnimation(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              context
                                  .read<StoreOrderingProductProvider>()
                                  .getcartitems();
                              context
                                  .read<StoreOrderingProductProvider>()
                                  .getcarttotal();
                              Navigator.pushNamed(
                                  context, PageRoutes.storeViewCart);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'View Cart',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: kMainColor,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    color: kMainColor.withOpacity(0.5),
                    height: 60.0,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  editQuantity(BuildContext context, List<D> products, int index) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          var stock = products[index]
              .productDetails![products[index].productDetailsIndex]
              .productQty
              .toString();
          bool tap = false;
          var _formkey = GlobalKey<FormState>();
          TextEditingController orderController = TextEditingController();

          orderController.text = stock != ""
              ? int.parse(stock)
                  .toStringAsFixed(2)
                  .replaceFirst(RegExp(r'\.?0*$'), '')
              : "0";

          return AlertDialog(
            title: Text(
              "Update Quantity",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formkey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.length < 1) {
                        return "please enter quantity";
                      } else if (value == stock) {
                        return "please enter valid quantity";
                      }

                      return null;
                    },
                    onTap: () {
                      tap = true;
                    },
                    textAlign: TextAlign.center,
                    controller: orderController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    cursorColor: kMainColor,
                    decoration: InputDecoration(
                      hintText: 'Qty',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: kMainColor,
                        ),
                      ),
                      focusColor: kMainColor,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 1,
                      )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: kMainColor),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: BorderSide(color: kMainColor, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: EdgeInsets.only(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.red)),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel, color: Colors.white),
                          label: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.green)),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              stock = await orderController.text;
                              if (tap == true) {
                                context
                                    .read<StoreOrderingProductProvider>()
                                    .increaseCountbyEditing(
                                        index: index,
                                        qty: int.parse(stock.toString()));
                              }
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          label: Text(
                            "ok",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class BottomSheetWidget extends StatefulWidget {
  final index;
  final catName;
  BottomSheetWidget({this.index, this.catName});
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final products = context.watch<StoreOrderingProductProvider>().products?.d;
    return FadedSlideAnimation(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: kTransparentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: ListTile(
                title: Text(products![widget.index].productName!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kWhiteColor)),
                subtitle: Text(widget.catName.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 15, color: kWhiteColor)),
              ),
            ),
            Container(
              height: 230,
              width: 490,
              child: Scrollbar(
                trackVisibility: true,
                thickness: 10.0,
                radius: Radius.circular(20.0),
                thumbVisibility: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products[widget.index].productDetails!.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                        title: Text(products[widget.index]
                            .productDetails![index]
                            .productWeight!),
                        value: products[widget.index]
                            .productDetails![index]
                            .productWeight
                            .toString(),
                        groupValue: products[widget.index]
                            .productDetails![
                                products[widget.index].productDetailsIndex]
                            .productWeight,
                        onChanged: (value) {
                          context
                              .read<StoreOrderingProductProvider>()
                              .selectedItemWeight(widget.index, index);
                          Navigator.pop(context);
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}
