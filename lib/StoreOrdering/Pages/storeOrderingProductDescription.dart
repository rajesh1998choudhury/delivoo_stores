import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:delivoo_stores/Routes/routes.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../Utils/AppConstants.dart';
import '../StoreOrderingProvider/store_product_provider.dart';

class StoreProductDescription extends StatefulWidget {
  const StoreProductDescription({Key? key}) : super(key: key);

  @override
  State<StoreProductDescription> createState() =>
      _StoreProductDescriptionState();
}

class _StoreProductDescriptionState extends State<StoreProductDescription> {
  @override
  Widget build(BuildContext context) {
    final products =
        context.watch<StoreOrderingProductProvider>().selectedProducts;
    final index = context.watch<StoreOrderingProductProvider>().productIndex;
    final checkout = context.watch<StoreOrderingProductProvider>().cartTotal?.d;
    return Scaffold(
      appBar: AppBar(
        title: Text(products!.productName!),
      ),
      body: Stack(
        children: [
          ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InteractiveViewer(
                  panEnabled: false, // Set it to false to prevent panning.
                  boundaryMargin: EdgeInsets.all(80),
                  minScale: 0.8,
                  maxScale: 1.3,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    // child: Image.asset(products.productImage!,
                    //     fit: BoxFit.cover),
                    decoration: BoxDecoration(
                      image: products.productImage != null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                  BaseUrl +
                                      'skuimages/' +
                                      products.productImage!,
                                  cacheKey: products.productImage!
                                  // fit: BoxFit.cover,
                                  ),
                              onError: (exception, stackTrace) {
                                products.productImage = null;
                              },
                            )
                          : DecorationImage(
                              image: AssetImage(
                                'images/logos/not-available.png',
                              ),
                            ),
                    ),
                  )),
              SizedBox(height: 10),
              Center(
                child: Text(
                    '\₹ ${products.productDetails![products.productDetailsIndex].productRate}'),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              height: 280,
                              child: BottomSheetWidget(
                                  index: products.productDetailsIndex));
                        },
                      );
                    },
                    child: Container(
                      height: 30.0,
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            products
                                .productDetails![products.productDetailsIndex]
                                .productWeight
                                .toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: kMainColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  products.productDetails![products.productDetailsIndex]
                              .productQty ==
                          0
                      ? products.isloading == true
                          ? SizedBox(
                              child: CircularProgressIndicator(),
                              width: MediaQuery.of(context).size.width * 0.1)
                          : Container(
                              height: 30.0,
                              child: ElevatedButton(
                                child: Text(
                                  'Add',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: kMainColor),
                                onPressed: () {
                                  context
                                      .read<StoreOrderingProductProvider>()
                                      .increaseCount(index);
                                },
                              ),
                            )
                      : products.isloading == true
                          ? SizedBox(
                              child: CircularProgressIndicator(
                                color: kMainColor,
                              ),
                              width: MediaQuery.of(context).size.width * 0.1)
                          : Container(
                              height: 30.0,
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: kMainColor),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<StoreOrderingProductProvider>()
                                          .decreaseCount(index);
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: kMainColor,
                                      size: 20.0,
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            var stock = products
                                                .productDetails![products
                                                    .productDetailsIndex]
                                                .productQty
                                                .toString();
                                            var _formkey =
                                                GlobalKey<FormState>();
                                            TextEditingController
                                                orderController =
                                                TextEditingController();
                                            orderController.text = stock != ""
                                                ? int.parse(stock)
                                                    .toStringAsFixed(2)
                                                    .replaceFirst(
                                                        RegExp(r'\.?0*$'), '')
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
                                                      keyboardType:
                                                          TextInputType.number,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: (value) {
                                                        if (value!.length < 1) {
                                                          return "please enter quantity";
                                                        } else if (value ==
                                                            stock) {
                                                          return "please enter valid quantity";
                                                        }

                                                        return null;
                                                      },
                                                      textAlign:
                                                          TextAlign.center,
                                                      controller:
                                                          orderController,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'[0-9]')),
                                                      ],
                                                      cursorColor: kMainColor,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Qty',
                                                        suffixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8),
                                                          child: Icon(
                                                            Icons.edit,
                                                            size: 16,
                                                            color: kMainColor,
                                                          ),
                                                        ),
                                                        focusColor: kMainColor,
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                          width: 1,
                                                        )),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          borderSide: BorderSide(
                                                              color:
                                                                  kMainColor),
                                                        ),
                                                        border:
                                                            new OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: kMainColor,
                                                              width: 2.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.only(),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        ElevatedButton.icon(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    WidgetStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .red)),
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: Icon(
                                                                Icons.cancel),
                                                            label:
                                                                Text("Cancel")),
                                                        ElevatedButton.icon(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    WidgetStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .green)),
                                                            onPressed:
                                                                () async {
                                                              if (_formkey
                                                                  .currentState!
                                                                  .validate()) {
                                                                stock =
                                                                    await orderController
                                                                        .text;
                                                                context
                                                                    .read<
                                                                        StoreOrderingProductProvider>()
                                                                    .increaseCountbyEditing(
                                                                        index:
                                                                            index,
                                                                        qty: int.parse(
                                                                            stock.toString()));
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            icon: Icon(
                                                                Icons.done),
                                                            label: Text("ok")),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(
                                        products
                                            .productDetails![
                                                products.productDetailsIndex]
                                            .productQty
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(fontSize: 18)),
                                  ),
                                  SizedBox(width: 8.0),
                                  InkWell(
                                    onTap: () {
                                      if (products
                                              .productDetails![
                                                  products.productDetailsIndex]
                                              .productQty! <
                                          products
                                              .productDetails![
                                                  products.productDetailsIndex]
                                              .orderLimt!) {
                                        context
                                            .read<
                                                StoreOrderingProductProvider>()
                                            .increaseCount(
                                              index,
                                            );
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Max limit reached",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: kMainColor,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Theme.of(context).cardColor,
                thickness: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Description'),
              ),
            ],
          ),
          products.productDetails![products.productDetailsIndex].productQty != 0
              ? Positioned(
                  width: MediaQuery.of(context).size.width,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/icons/ic_cart.png',
                          height: 19.0,
                          width: 18.3,
                        ),
                        SizedBox(width: 20.7),
                        Text(
                          'Items: ${context.watch<StoreOrderingProductProvider>().cartitems?.d?.length} | \u{20B9} ${checkout?[0].posttaxamount}',
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
                          onPressed: () {
                            context
                                .read<StoreOrderingProductProvider>()
                                .getcartitems();
                            Navigator.pushNamed(
                                context, PageRoutes.storeViewCart);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'view Cart',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: kMainColor,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                        // : Container(),
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
}

class BottomSheetWidget extends StatefulWidget {
  final index;
  BottomSheetWidget({this.index});
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
    final products =
        context.watch<StoreOrderingProductProvider>().selectedProducts;
    return FadedSlideAnimation(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: kTransparentColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: ListTile(
              title: Text(products!.productName!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: kWhiteColor)),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: products.productDetails!.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                  title: Text(products.productDetails![index].productWeight!),
                  value:
                      products.productDetails![index].productWeight.toString(),
                  groupValue: products
                      .productDetails![products.productDetailsIndex]
                      .productWeight,
                  onChanged: (value) {
                    context
                        .read<StoreOrderingProductProvider>()
                        .selectedDescItemWeight(products, index);
                    Navigator.pop(context);
                  });
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
