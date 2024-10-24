// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:delivoo_stores/Utils/AppConstants.dart';
import 'package:delivoo_stores/Utils/CommonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Components/bottom_bar.dart';
import '../StoreOrderingProvider/store_product_provider.dart';
import 'delivery_details.dart';

int? selected;
int? selected1;

class StoreViewCart extends StatefulWidget {
  @override
  _StoreViewCartState createState() => _StoreViewCartState();
}

class _StoreViewCartState extends State<StoreViewCart> {
  int? group = 1;
  int x = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartitems =
        context.watch<StoreOrderingProductProvider>().cartitems?.d;
    final checkout = context.watch<StoreOrderingProductProvider>().cartTotal?.d;
    // final timeslots = context.watch<StoreOrderingStoreProvider>().timeslots?.d;

    //loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: kWhiteColor)),
      ),
      body: cartitems != null && cartitems.length != 0
          ? Stack(
              children: <Widget>[
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    SizedBox(height: 10),
                    cartitems.length != 0 && cartitems.isNotEmpty
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.44,
                            child: ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: cartitems.length,
                              itemBuilder: (context, index) {
                                return cartOrderItemListTile(
                                    context: context,
                                    image: cartitems[index]
                                        .productImage
                                        .toString(),
                                    title:
                                        cartitems[index].productName.toString(),
                                    price:
                                        cartitems[index].productRate.toString(),
                                    itemCount: cartitems[index].productQty!,
                                    itemweight: cartitems[index].productWeight!,
                                    onPressedMinus: () => context
                                        .read<StoreOrderingProductProvider>()
                                        .decreaseCountincart(index),
                                    onPressedPlus: () => context
                                        .read<StoreOrderingProductProvider>()
                                        .increaseCountincart(
                                          index,
                                        ),
                                    onPressedDelete: () => context
                                        .read<StoreOrderingProductProvider>()
                                        .removefromcart(index),
                                    MRP: cartitems[index].productMrp!,
                                    totalamount: cartitems[index].totalamount!,
                                    isLoading: cartitems[index].isloading,
                                    index: index);
                              },
                            ),
                          )
                        : Container(),
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Item Count : ${cartitems.length != null ? cartitems.length : 0}',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                  letterSpacing: 0.05)),
                          Text(
                              cartitems.isNotEmpty
                                  ? 'Total no. of items : ${context.watch<StoreOrderingProductProvider>().numberOfItems}'
                                  : 'Total no. of items : 0',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                  letterSpacing: 0.05)),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          InkWell(
                            onTap: () {
                              if (cartitems.length != 0 &&
                                  cartitems.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => new AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    content: Text(
                                      'All products from the cart will be removed',
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent),
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        onPressed: () async {
                                          await context
                                              .read<
                                                  StoreOrderingProductProvider>()
                                              .removeallProducts();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Continue"),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                showMessage('No items in cart');
                              }
                            },
                            child: Text(
                              'Remove all',
                              style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.05,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 6.7,
                    ),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Text("Payment Info".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: kDisabledColor, fontSize: 12)),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Sub Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                            cartitems.isNotEmpty
                                ? Text(
                                    '\u{20B9} ${checkout?[0].posttaxamount}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )
                                : Text(
                                    '\u{20B9} 0',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  )
                          ]),
                    ),
                    checkout?[0].delcharge == null ||
                            checkout?[0].delcharge == "0.00"
                        ? SizedBox.shrink()
                        : Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Delivery Charges',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  ),
                                  cartitems.isNotEmpty
                                      ? Text(
                                          '\u{20B9} ${checkout?[0].delcharge == null ? "0" : checkout?[0].delcharge}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        )
                                      : Text(
                                          '\u{20B9} 0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        )
                                ]),
                          ),
                    checkout?[0].couponamt == null ||
                            checkout?[0].couponamt == "0.00"
                        ? SizedBox.shrink()
                        : Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    checkout![0].couponName ?? "Coupon",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  ),
                                  Spacer(),
                                  cartitems.isNotEmpty
                                      ? Text(
                                          '\u{20B9} ${checkout[0].couponamt == null ? "0.00" : checkout[0].couponamt}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        )
                                      : Text(
                                          '\u{20B9} 0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        ),
                                ]),
                          ),
                    checkout?[0].dicountamt == null ||
                            checkout?[0].dicountamt == "0.00"
                        ? SizedBox.shrink()
                        : Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Discount',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  ),
                                  Spacer(),
                                  cartitems.isNotEmpty
                                      ? Text(
                                          ' ${checkout?[0].dicountper == null || checkout?[0].dicountper == "" ? "" : '@ ${checkout?[0].dicountper}%'} ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        )
                                      : Text(
                                          '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  cartitems.isNotEmpty
                                      ? Text(
                                          '\u{20B9} ${checkout?[0].dicountamt == null ? "0" : checkout?[0].dicountamt}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        )
                                      : Text(
                                          '\u{20B9} 0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        ),
                                ]),
                          ),
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 1.0,
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Amount",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                            ),
                            Text(
                              cartitems.isNotEmpty
                                  ? '\u{20B9} ${checkout?[0].payamt}'
                                  : '\u{20B9} 0',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Savings',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 12),
                            ),
                            cartitems.isNotEmpty
                                ? Text(
                                    '\u{20B9} ${checkout?[0].savingamount}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  )
                                : Text(
                                    '\u{20B9} 0',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 12),
                                  )
                          ]),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Theme.of(context).cardColor,
                      thickness: 6.7,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      BottomBar(
                          text: 'Procced to Checkout',
                          onTap: () async {
                            if (int.parse(
                                    checkout![0].minimumbasket.toString()) <=
                                checkout[0].pretaxamount) {
                              var result = await context
                                  .read<StoreOrderingProductProvider>()
                                  .proccedToCheckout(context);
                              if (result == "success") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryDetails()));
                              }
                            } else {
                              showMessage(
                                  'Minimum order amount is \u{20B9} ${checkout[0].minimumbasket}');
                            }
                          }),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/icons/shoppingcart.png',
                        height: 200,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Your Cart is empty")
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Column cartOrderItemListTile(
      {context,
      image,
      title,
      price,
      itemCount,
      itemweight,
      onPressedMinus,
      onPressedPlus,
      onPressedDelete,
      MRP,
      totalamount,
      isLoading,
      index}) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: image != ''
              ? CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: CachedNetworkImageProvider(
                      BaseUrl + 'skuimages/' + image,
                      cacheKey: image), //AssetImage(image),
                  onBackgroundImageError: (exception, stackTrace) {
                    image = '';
                  },
                )
              : CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage('images/logos/not-available.png'),
                ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          overflow: TextOverflow.ellipsis,
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12),
                    ),
                  ),
                  Spacer(),
                  Text('\₹ $totalamount',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 12)),
                ],
              ),
              SizedBox(
                height: 3.0,
              ),
              Container(
                // width: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('\u{20B9} $price',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 12)),
                    SizedBox(width: 5),
                    MRP != null && MRP != ""
                        ? Text('\₹ $MRP',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough))
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 25.0,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: /* DropdownButtonHideUnderline(
                      child: DropdownButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 16.7,
                          ),
                          iconEnabledColor: Colors.green,
                          value: selected,
                          items: listDrop,
                          hint: Text(
                            '1 kg',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onChanged: (dynamic value) {
                            setState(() {
                              selected = value;
                            });
                          }),
                    ), */
                        Text(
                      itemweight,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 12),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  InkWell(
                    onTap: () {
                      editQuantity(context, itemCount, index);
                    },
                    child: Icon(
                      Icons.edit,
                      size: 15,
                      color: kMainColor,
                    ),
                  ),
                  Spacer(),

                  isLoading == true
                      ? SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: kMainColor,
                            strokeWidth: 2,
                          ))
                      : Container(
                          height: 25.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: kMainColor),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: isLoading == true
                              ? CircularProgressIndicator()
                              : Row(
                                  children: <Widget>[
                                    IconButton(
                                      iconSize: 12,
                                      padding: EdgeInsets.all(3),
                                      icon: Icon(Icons.remove),
                                      color: kMainColor,
                                      onPressed: (itemCount > 0)
                                          ? onPressedMinus as void Function()?
                                          : null,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        editQuantity(context, itemCount, index);
                                      },
                                      child: Text(itemCount.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 15)),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.all(3),
                                      icon: Icon(Icons.add),
                                      color: kMainColor,
                                      iconSize: 12,
                                      onPressed:
                                          onPressedPlus as void Function()?,
                                    ),
                                  ],
                                ),
                        ),

                  //Spacer(),
                  /*  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.indigo,
                    onPressed: onPressedDelete as void Function()?,
                  ), */
                  /*  Text(
                    '\u{20B9} $price',
                    style: Theme.of(context).textTheme.caption,
                  ), */
                ]),
          ),
        ),
        Divider(
          color: Theme.of(context).cardColor,
          thickness: 4,
        ),
      ],
    );
  }

  editQuantity(context, itemCount, index) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          var stock = itemCount.toString();
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
                                  MaterialStateProperty.all<Color>(Colors.red)),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel, color: Colors.white),
                          label: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          )),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green)),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              stock = await orderController.text;
                              context
                                  .read<StoreOrderingProductProvider>()
                                  .increaseCountincartbyEditing(
                                      index, int.parse(stock.toString()));
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          label: Text(
                            "ok",
                            style: TextStyle(color: Colors.white),
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
