import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Components/custom_appbar.dart';
import 'package:delivoo_stores/Components/search_delegate.dart';
import 'package:delivoo_stores/Provider/CategoryProvider.dart';
import 'package:delivoo_stores/Provider/ProductProvider.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryItemsPage extends StatefulWidget {
  final String? catName;
  CategoryItemsPage({this.catName});

  @override
  _CategoryItemsPageState createState() => _CategoryItemsPageState();
}

class _CategoryItemsPageState extends State<CategoryItemsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabcontroller;

  bool switchValue = false;

  @override
  void initState() {
    final subcategories = context.read<CategoryProvider>().subcategories?.d;
    _tabcontroller = TabController(
      initialIndex: context.read<ProductProvider>().tabIndex,
      length: subcategories!.length,
      vsync: this,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final products = context.watch<ProductProvider>().products?.d;
    final subcategories = context.read<CategoryProvider>().subcategories?.d;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            child: DefaultTabController(
              length: subcategories!.length,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(140),
                  child: CustomAppBar(
                    titleWidget: Text(widget.catName.toString(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            )),
                    actions: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: InkWell(
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: CustomSearchDelegate());
                          },
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () async {
                            try {
                              final qrCode =
                                  await FlutterBarcodeScanner.scanBarcode(
                                      '#ff6666', 'Cancel', true, ScanMode.QR);
                              if (!mounted) return;

                              if (qrCode != '-1') {
                                _tabcontroller?.index = await 0;
                                await context
                                    .read<ProductProvider>()
                                    .getProductsByScan(
                                      qrCode,
                                    );
                              }
                            } on PlatformException {
                              print('Failed to scan QR Code.');
                            }
                          },
                          child: Icon(Icons.qr_code, color: Colors.white),
                        ),
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TabBar(
                            tabAlignment: TabAlignment.start,
                            controller: _tabcontroller,
                            onTap: (value) {
                              Future.delayed(Duration(milliseconds: 300),
                                  () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setString('my_sectionId',
                                    subcategories[value].sectionid.toString());
                                await context
                                    .read<ProductProvider>()
                                    .getProductsByCategory(
                                        catId: prefs.getString('my_catId'),
                                        sectionId:
                                            subcategories[value].sectionid!,
                                        searchtxt: '',
                                        loading: true);
                              });
                            },
                            tabs: List.generate(
                              subcategories.length,
                              (index) => Tab(
                                  height: 100,
                                  icon: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      subcategories[index].sectionimg != null &&
                                              subcategories[index].sectionimg !=
                                                  '0' &&
                                              subcategories[index].sectionimg !=
                                                  ""
                                          ? CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.white,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      BaseUrl +
                                                          SUBCAT_IMAGES +
                                                          subcategories[index]
                                                              .sectionimg!,
                                                      cacheKey:
                                                          subcategories[index]
                                                              .sectionimg!,
                                                      errorListener:
                                                          ((VoidCallbackIntent) {
                                                subcategories[index]
                                                    .sectionimg = "";
                                              })),
                                            )
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
                                                0.17,
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
                            enableFeedback: true,
                            isScrollable: true,
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            unselectedLabelColor: kLightTextColor,
                            labelPadding: EdgeInsets.all(3),
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
                                : RefreshIndicator(
                                    color: kMainColor,
                                    onRefresh: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await context
                                          .read<ProductProvider>()
                                          .getProductsByCategory(
                                              catId:
                                                  prefs.getString('my_catId'),
                                              sectionId: subcategories[index]
                                                  .sectionid!,
                                              searchtxt: '',
                                              loading: false);
                                    },
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics(),
                                        ),
                                        shrinkWrap: true,
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Divider(
                                                color:
                                                    Theme.of(context).cardColor,
                                                thickness: 8.0,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 100,
                                                      width: 90,
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
                                                                colorFilter: products[index].productDetails![products[index].productDetailsIndex].outofstock !=
                                                                            0 ||
                                                                        products[index].productDetails![products[index].productDetailsIndex].stock ==
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
                                                                    // fit: BoxFit.cover,
                                                                    errorListener:
                                                                        ((VoidCallbackIntent) {
                                                                  products[
                                                                          index]
                                                                      .productDetails![
                                                                          products[index]
                                                                              .productDetailsIndex]
                                                                      .productimage = "";
                                                                }),
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
                                                            : products[index].productImage ==
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
                                                                  ))
                                                                : DecorationImage(
                                                                    colorFilter: products[index].productDetails![products[index].productDetailsIndex].outofstock !=
                                                                                0 ||
                                                                            products[index].productDetails![products[index].productDetailsIndex].stock ==
                                                                                0
                                                                        ? ColorFilter
                                                                            .mode(
                                                                            Colors.black.withOpacity(1), // 0 = Colored, 1 = Black & White
                                                                            BlendMode.saturation,
                                                                          )
                                                                        : ColorFilter
                                                                            .mode(
                                                                            Colors.black.withOpacity(0), // 0 = Colored, 1 = Black & White
                                                                            BlendMode.screen,
                                                                          ),
                                                                    image: CachedNetworkImageProvider(
                                                                        errorListener:
                                                                            (VoidCallbackIntent) {
                                                                      products[
                                                                              index]
                                                                          .productImage = "";
                                                                    },
                                                                        BaseUrl +
                                                                            'skuimages/' +
                                                                            products[index]
                                                                                .productImage!,
                                                                        // fit: BoxFit.cover,
                                                                        cacheKey:
                                                                            products[index].productImage),
                                                                    onError:
                                                                        (exception,
                                                                            stackTrace) {
                                                                      products[
                                                                              index]
                                                                          .productImage = "";
                                                                    },
                                                                  ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
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
                                                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                                                    color: products[index].productDetails![products[index].productDetailsIndex].outofstock != 0 ||
                                                                            products[index].productDetails![products[index].productDetailsIndex].stock ==
                                                                                0
                                                                        ? Colors
                                                                            .grey
                                                                        : kMainTextColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis)),
                                                          ),

                                                          SizedBox(height: 8.0),

                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right:
                                                                        22.0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    '\₹ ${products[index].productDetails![products[index].productDetailsIndex].productRate!}',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                            color: products[index].productDetails![products[index].productDetailsIndex].outofstock != 0 || products[index].productDetails![products[index].productDetailsIndex].stock == 0
                                                                                ? Colors.grey
                                                                                : kMainTextColor)),
                                                                Spacer(),
                                                                products[index]
                                                                            .productDetails![products[index]
                                                                                .productDetailsIndex]
                                                                            .productQty! >
                                                                        0
                                                                    ? Text(
                                                                        '\₹ ${(products[index].productDetails![products[index].productDetailsIndex].productRate! * products[index].productDetails![products[index].productDetailsIndex].productQty!.toDouble()).toDouble().toStringAsFixed(2)}',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall)
                                                                    : Container(),
                                                                Text(
                                                                    "Stock :" +
                                                                        products[index]
                                                                            .productDetails![products[index]
                                                                                .productDetailsIndex]
                                                                            .stock
                                                                            .toString(),
                                                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                                        color: products[index].productDetails![products[index].productDetailsIndex].outofstock != 0 || products[index].productDetails![products[index].productDetailsIndex].stock == 0
                                                                            ? Colors
                                                                                .grey
                                                                            : kMainTextColor,
                                                                        fontSize:
                                                                            12,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                products[index].productDetails![products[index].productDetailsIndex].outofstock !=
                                                                            0 ||
                                                                        products[index].productDetails![products[index].productDetailsIndex].stock ==
                                                                            0
                                                                    ? SizedBox
                                                                        .shrink()
                                                                    : products[index].lockstatus ==
                                                                            "0"
                                                                        ? SizedBox
                                                                            .shrink()
                                                                        : InkWell(
                                                                            onTap:
                                                                                () {
                                                                              showDialog(
                                                                                  barrierDismissible: false,
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    var stock = products[index].productDetails![products[index].productDetailsIndex].stock.toString();
                                                                                    var _formkey = GlobalKey<FormState>();
                                                                                    TextEditingController orderController = TextEditingController();
                                                                                    orderController.text = stock != "" ? int.parse(stock).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '') : "0";

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
                                                                                                }

                                                                                                return null;
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
                                                                                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.red)),
                                                                                                    onPressed: () async {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    icon: Icon(Icons.cancel),
                                                                                                    label: Text("Cancel")),
                                                                                                ElevatedButton.icon(
                                                                                                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                                                                                                    onPressed: () async {
                                                                                                      FocusScope.of(context).unfocus();
                                                                                                      if (_formkey.currentState!.validate()) {
                                                                                                        stock = await orderController.text;
                                                                                                        var result = await context.read<ProductProvider>().sortQuantity(index: index, newQty: stock != "" ? int.parse(stock.toString()).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '') : "0", productId: products[index].productDetails![products[index].productDetailsIndex].productCode);
                                                                                                        // Navigator.pop(context);
                                                                                                        print(result);
                                                                                                        if (result == "locked") {
                                                                                                          await context.read<ProductProvider>().getProductsByCategory(catId: subcategories[index].sectionid!, searchtxt: '', loading: false);
                                                                                                        }
                                                                                                      }
                                                                                                    },
                                                                                                    icon: Icon(Icons.done),
                                                                                                    label: Text("ok")),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  });
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.edit,
                                                                              size: 15.0,
                                                                              color: products[index].productDetails![products[index].productDetailsIndex].outofstock != 0 || products[index].productDetails![products[index].productDetailsIndex].stock == 0 ? Colors.grey : kMainColor,
                                                                            )),
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
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                                                          ),
                                                                          height:
                                                                              280,
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
                                                                child:
                                                                    Container(
                                                                  height: 30.0,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              12.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .cardColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        products[index].productDetails![products[index].productDetailsIndex].productWeight ??
                                                                            '',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall!
                                                                            .copyWith(color: products[index].productDetails![products[index].productDetailsIndex].outofstock != 0 || products[index].productDetails![products[index].productDetailsIndex].stock == 0 ? Colors.grey : kMainTextColor),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8.0,
                                                                      ),
                                                                      Icon(
                                                                          Icons
                                                                              .keyboard_arrow_down,
                                                                          color:
                                                                              kMainColor),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Switch(
                                                                            activeColor: Colors
                                                                                .grey,
                                                                            value: products[index].productDetails![products[index].productDetailsIndex].outofstock != 0 || products[index].productDetails![products[index].productDetailsIndex].stock == 0
                                                                                ? true
                                                                                : false,
                                                                            onChanged:
                                                                                (value) async {
                                                                              if (products[index].productDetails![products[index].productDetailsIndex].stock == 0) {
                                                                              } else
                                                                                showDialog(
                                                                                    barrierDismissible: false,
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return AlertDialog(
                                                                                        title: Text("Are you sure you want to change the status of this product?"),
                                                                                        content: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                Icon(Icons.info),
                                                                                                Container(
                                                                                                  width: 200,
                                                                                                  child: Text(
                                                                                                    "issues, I want to change the status of the product.",
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                            Row(
                                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                              children: [
                                                                                                Spacer(),
                                                                                                Container(
                                                                                                  child: ElevatedButton.icon(
                                                                                                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                                                                                                      onPressed: () async {
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      icon: Icon(Icons.cancel, color: Colors.white),
                                                                                                      label: Text("No", style: TextStyle(color: Colors.white))),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: 10,
                                                                                                ),
                                                                                                Container(
                                                                                                  child: ElevatedButton.icon(
                                                                                                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.red)),
                                                                                                      onPressed: () async {
                                                                                                        print("items id:${products[index].id}");
                                                                                                        print("product id:${products[index].productDetails![products[index].productDetailsIndex].productCode}");
                                                                                                        await context.read<ProductProvider>().productOutOfStock(
                                                                                                              itemId: products[index].id,
                                                                                                              productId: products[index].productDetails![products[index].productDetailsIndex].productCode,
                                                                                                              status: products[index].productDetails![products[index].productDetailsIndex].outofstock == 0 ? "1" : "0",
                                                                                                            );
                                                                                                        print(value);
                                                                                                        await context.read<ProductProvider>().getSwitchValue(products[index], index, value == true ? 1 : 0);
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      icon: Icon(Icons.done, color: Colors.white),
                                                                                                      label: Text("Yes", style: TextStyle(color: Colors.white))),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    });
                                                                            }),
                                                                        Text(
                                                                          products[index].productDetails![products[index].productDetailsIndex].outofstock == 1 || products[index].productDetails![products[index].productDetailsIndex].stock == 0
                                                                              ? 'OutOfStock'
                                                                              : 'InStock',
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: products[index].productDetails![products[index].productDetailsIndex].outofstock == 1 || products[index].productDetails![products[index].productDetailsIndex].stock == 0 ? Colors.grey : kMainColor),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
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
                                  ),
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
        ],
      ),
    );
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
    final products = context.watch<ProductProvider>().products?.d;
    return FadedSlideAnimation(
      child: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: kTransparentColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
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
          ListView.builder(
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
                    .productDetails![products[widget.index].productDetailsIndex]
                    .productWeight,
                onChanged: (value) {
                  context
                      .read<ProductProvider>()
                      .selectedItemWeight(widget.index, index);
                  Navigator.pop(context);
                },
                activeColor: kMainColor,
              );
            },
          ),
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}
