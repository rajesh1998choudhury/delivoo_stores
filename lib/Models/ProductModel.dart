// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.d,
  });

  List<D>? d;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.id,
    this.productName,
    this.productImage,
    this.defaultid,
    this.topproductid,
    this.catid,
    this.subcatid,
    this.sectionid,
    this.productDescription,
    this.lockstatus,
    this.productDetails,
  });

  Type? type;
  String? id;
  String? productName;
  String? productImage;
  dynamic defaultid;
  dynamic topproductid;
  String? catid;
  dynamic subcatid;
  dynamic sectionid;
  dynamic productDescription;
  String? lockstatus;
  List<ProductDetail>? productDetails;
  int productDetailsIndex = 0;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: typeValues.map[json["__type"]],
        id: json["id"],
        productName: json["productName"],
        productImage: json["productImage"],
        defaultid: json["defaultid"],
        topproductid: json["topproductid"],
        catid: json["catid"],
        subcatid: json["subcatid"],
        sectionid: json["Sectionid"],
        productDescription: json["productDescription"],
        lockstatus: json["Lockstatus"],
        productDetails: List<ProductDetail>.from(
            json["productDetails"].map((x) => ProductDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__type": typeValues.reverse[type],
        "id": id,
        "productName": productName,
        "productImage": productImage,
        "defaultid": defaultid,
        "topproductid": topproductid,
        "catid": catid,
        "subcatid": subcatid,
        "Sectionid": sectionid,
        "productDescription": productDescription,
        "Lockstatus": lockstatus,
        "productDetails":
            List<dynamic>.from(productDetails!.map((x) => x.toJson())),
      };
}

class ProductDetail {
  ProductDetail({
    this.id,
    this.productCode,
    this.productWeight,
    this.orderLimt,
    this.productRate,
    this.productMrp,
    this.stock,
    this.offer,
    this.skuName,
    this.discountPercentage,
    this.productQty,
    this.outofstock,
    this.productimage,
    this.imgdatetime,
    this.productamount,
  });

  dynamic id;
  String? productCode;
  String? productWeight;
  int? orderLimt;
  double? productRate;
  String? productMrp;
  int? stock;
  String? offer;
  dynamic skuName;
  String? discountPercentage;
  int? productQty;
  int? outofstock;
  String? productimage;
  dynamic imgdatetime;
  String? productamount;

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json["id"],
        productCode: json["productCode"],
        productWeight: json["productWeight"],
        orderLimt: json["OrderLimt"] == 0 ? 50 : json["OrderLimt"],
        productRate: json["productRate"].toDouble(),
        productMrp: json["productMrp"],
        stock: json["Stock"],
        offer: json["Offer"],
        skuName: json["SkuName"],
        discountPercentage: json["discountPercentage"],
        productQty: json["productQty"],
        outofstock: json["outofstock"],
        productimage: json["productimage"],
        imgdatetime: json["imgdatetime"],
        productamount: json["productamount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productCode": productCode,
        "productWeight": productWeight,
        "OrderLimt": orderLimt,
        "productRate": productRate,
        "productMrp": productMrp,
        "Stock": stock,
        "Offer": offer,
        "SkuName": skuName,
        "discountPercentage": discountPercentage,
        "productQty": productQty,
        "outofstock": outofstock,
        "productimage": productimage,
        "imgdatetime": imgdatetime,
        "productamount": productamount,
      };
}

enum Type { BO_ADMIN_PRODUCT }

final typeValues = EnumValues({"BOAdmin.Product": Type.BO_ADMIN_PRODUCT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
