import 'dart:convert';

// To parse this JSON data, do
//
//     final StoreOrderingCartModel = StoreOrderingCartModelFromJson(jsonString);

StoreOrderingCartModel StoreOrderingCartModelFromJson(String str) =>
    StoreOrderingCartModel.fromJson(json.decode(str));

String StoreOrderingCartModelToJson(StoreOrderingCartModel data) =>
    json.encode(data.toJson());

class StoreOrderingCartModel {
  StoreOrderingCartModel({
    this.d,
  });

  List<D>? d;

  factory StoreOrderingCartModel.fromJson(Map<String, dynamic> json) =>
      StoreOrderingCartModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.productCode,
    this.productQty,
    this.productName,
    this.productWeight,
    this.productRate,
    this.productMrp,
    this.productStock,
    this.productImage,
    this.maxcount,
    this.totalamount,
    this.totWeight,
    this.cgsttax,
    this.sgsttax,
    this.orderid,
  });

  String? type;
  String? productCode;
  int? productQty;
  String? productName;
  String? productWeight;
  String? productRate;
  String? productMrp;
  int? productStock;
  String? productImage;
  int? maxcount;
  String? totalamount;
  double? totWeight;
  String? cgsttax;
  String? sgsttax;
  String? orderid;
  bool? isloading = false;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        productCode: json["productCode"],
        productQty: json["productQty"],
        productName: json["productName"],
        productWeight: json["productWeight"],
        productRate: json["productRate"],
        productMrp: json["productMrp"],
        productStock: json["productStock"],
        productImage: json["productImage"],
        maxcount: json["maxcount"] == 0 ? 999 : json["maxcount"],
        totalamount: json["totalamount"],
        totWeight: json["totWeight"].toDouble(),
        cgsttax: json["cgsttax"],
        sgsttax: json["sgsttax"],
        orderid: json["Orderid"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "productCode": productCode,
        "productQty": productQty,
        "productName": productName,
        "productWeight": productWeight,
        "productRate": productRate,
        "productMrp": productMrp,
        "productStock": productStock,
        "productImage": productImage,
        "maxcount": maxcount,
        "totalamount": totalamount,
        "totWeight": totWeight,
        "cgsttax": cgsttax,
        "sgsttax": sgsttax,
        "Orderid": orderid,
      };
}
