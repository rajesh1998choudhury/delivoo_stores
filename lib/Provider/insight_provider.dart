import 'package:delivoo_stores/Models/EarningsModel.dart';
import 'package:delivoo_stores/Models/TopSellingModel.dart';
import 'package:delivoo_stores/Models/bar_chart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class InsightProvider extends ChangeNotifier {
  late List<charts.Series<Pollution, String>>? seriesData = [];
  List<TotalItemSold>? totalItemSold = [];
  List<EarningModel>? earnings = [];

  itemSells() async {
    await ProcessResponse();
    notifyListeners();
  }

  earning() async {
    await processResponseEarning();
    notifyListeners();
  }

  ProcessResponse() async {
    TotalItemSold t1 = TotalItemSold(totalItemSold: '10', topSelling: []);
    TopSellingModel t1t1 = TopSellingModel(
      productImage: 'images/veg/Vegetables/onion.png',
      productName: 'Onion',
      totalSales: '110',
    );
    totalItemSold?.clear();
    totalItemSold?.add(t1);
    TopSellingModel t1t2 = TopSellingModel(
      productImage: 'images/veg/Vegetables/tomato.png',
      productName: 'Fresh Red Tomato',
      totalSales: '520',
    );
    TopSellingModel t1t3 = TopSellingModel(
      productImage: "images/veg/Vegetables/Cauliflower.png",
      productName: 'Cauliflower',
      totalSales: '90',
    );

    t1.topSelling?.add(t1t1);
    t1.topSelling?.add(t1t2);
    t1.topSelling?.add(t1t3);
  }

  processResponseEarning() async {
    EarningModel e1 = EarningModel(
        totalItemsSold: '500',
        totalOrders: '50',
        totalEarnings: '5000',
        totalComission: "1000");
    earnings?.clear();
    earnings?.add(e1);
  }

  generateData() async {
    var data1 = [
      new Pollution(1, 'Mon', 30),
      new Pollution(2, 'Tue', 40),
      new Pollution(3, 'Wed', 50),
      new Pollution(4, 'Thu', 240),
      new Pollution(5, 'Fri', 50),
      new Pollution(6, 'Sat', 150),
      new Pollution(7, 'Sun', 50),
    ];
    var data2 = [
      new Pollution(1, 'Mon', 20),
      new Pollution(2, 'Tue', 30),
      new Pollution(3, 'Wed', 40),
      new Pollution(4, 'Thu', 200),
      new Pollution(5, 'Fri', 40),
      new Pollution(6, 'Sat', 120),
      new Pollution(7, 'Sun', 40),
    ];

    seriesData?.clear();
    seriesData?.add(
      charts.Series(
        displayName: 'Earning',
        domainFn: (Pollution pollution, _) => pollution.place!,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
        labelAccessorFn: (Pollution pollution, _) => '${pollution.quantity}',
        colorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );
    seriesData?.add(
      charts.Series(
        displayName: 'commission',
        domainFn: (Pollution pollution, _) => pollution.place!,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2017',
        data: data2,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffF75C1E)),
        labelAccessorFn: (Pollution pollution, _) => '${pollution.quantity}',
        colorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffF75C1E)),
      ),
    );
    notifyListeners();
  }

  /* processResponse() async {
    ProductModel p1 = ProductModel(
      id: 1,
      productDetailsIndex: 0,
      productName: "Onion",
      productImage: 'images/veg/Vegetables/onion.png',
      productDescription:
          "Onions are cultivated and used around the world. As a food item, they are usually served cooked, as a vegetable or part of a prepared savoury dish, but can also be eaten raw or used to make pickles or chutneys. They are pungent when chopped and contain certain chemical substances which may irritate the eyes.",
      productDetails: [],
    );

    ProductDetailModel p1d1 = ProductDetailModel(
        id: 1,
        discountPercentage: 10,
        productCode: "Onion100gm",
        productMrp: 50,
        productQty: 0,
        productRate: 40,
        productWeight: "100gm",
        maxcount: 7);
    ProductDetailModel p1d2 = ProductDetailModel(
        id: 2,
        discountPercentage: 10,
        productCode: "Onion1kg",
        productMrp: 100,
        productQty: 0,
        productRate: 90,
        productWeight: "1kg");

    p1.productDetails!.add(p1d1);
    p1.productDetails!.add(p1d2);
    ProductModel p2 = ProductModel(
        id: 2,
        productDetailsIndex: 0,
        productName: "Tomato",
        productImage: 'images/veg/Vegetables/tomato.png',
        productDescription:
            "The tomato (Solanum lycopersicum) is a culinary vegetable/botanical fruit, or specifically, a berry (but not a fruit as ordinary people use the word). It is shiny and smooth. It has many small seeds. It is also very good for health. Most tomatoes are red.",
        productDetails: []);

    ProductDetailModel p2d1 = ProductDetailModel(
        id: 1,
        discountPercentage: 10,
        productCode: "Tomato1kg",
        productMrp: 100,
        productQty: 0,
        productRate: 90,
        productWeight: "1kg",
        maxcount: 5);
    ProductDetailModel p2d2 = ProductDetailModel(
        id: 2,
        discountPercentage: 10,
        productCode: "Tomato100gm",
        productMrp: 50,
        productQty: 0,
        productRate: 40,
        productWeight: "100gm");

    p2.productDetails!.add(p2d1);
    p2.productDetails!.add(p2d2);
    ProductModel p3 = ProductModel(
        id: 3,
        productDetailsIndex: 0,
        productName: "Onion Small",
        productImage: 'images/veg/Vegetables/onion.png',
        productDescription: "Fresh small onoion",
        productDetails: []);
    ProductDetailModel p3d1 = ProductDetailModel(
        id: 1,
        discountPercentage: 10,
        productCode: "Small Onion1kg",
        productMrp: 100,
        productQty: 0,
        productRate: 90,
        productWeight: "1kg");
    p3.productDetails!.add(p3d1);
    ProductModel p4 = ProductModel(
        id: 4,
        productDetailsIndex: 0,
        productName: "Small Tomato",
        productImage: 'images/veg/Vegetables/tomato.png',
        productDescription: "Fresh small tomato",
        productDetails: []);
    ProductDetailModel p4d1 = ProductDetailModel(
        id: 1,
        discountPercentage: 10,
        productCode: "Small Tomato1kg",
        productMrp: 100,
        productQty: 0,
        productRate: 90,
        productWeight: "1kg");
    p4.productDetails!.add(p4d1);
    products.clear();
    products.add(p1);
    products.add(p2);
    products.add(p3);
    products.add(p4);
    CartModel c1 = CartModel(
        productCode: "Tomato1kg",
        productName: "Tomato",
        productWeight: "1kg",
        productQty: 3,
        productRate: 90,
        productImage: 'images/veg/Vegetables/tomato.png');
    CartModel c2 = CartModel(
        productCode: "Onion1kg",
        productName: "Onion",
        productWeight: "1kg",
        productQty: 4,
        productRate: 90,
        productImage: 'images/veg/Vegetables/onion.png');
    cartitems!.clear();
    cartitems!.add(c1);
    cartitems!.add(c2);
  } */
}
