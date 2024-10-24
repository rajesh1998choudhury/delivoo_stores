// To parse this JSON data, do
//
//     final storeOrderingCartTotalModel = storeOrderingCartTotalModelFromJson(jsonString);

import 'dart:convert';

StoreOrderingCartTotalModel storeOrderingCartTotalModelFromJson(String str) =>
    StoreOrderingCartTotalModel.fromJson(json.decode(str));

String storeOrderingCartTotalModelToJson(StoreOrderingCartTotalModel data) =>
    json.encode(data.toJson());

class StoreOrderingCartTotalModel {
  StoreOrderingCartTotalModel({
    this.d,
  });

  List<D>? d;

  factory StoreOrderingCartTotalModel.fromJson(Map<String, dynamic> json) =>
      StoreOrderingCartTotalModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.totalQty,
    this.totalWeight,
    this.totalcount,
    this.pretaxamount,
    this.posttaxamount,
    this.cgsttax,
    this.sgsttax,
    this.igsttax,
    this.savingamount,
    this.minimumbasket,
    this.orderid,
    this.walletamt,
    this.payamt,
    this.delcharge,
    this.subtotal,
    this.dicountper,
    this.dicountamt,
    this.subtotalfinal,
    this.couponName,
    this.couponamt,
  });

  String? type;
  String? totalQty;
  String? totalWeight;
  String? totalcount;
  var pretaxamount;
  String? posttaxamount;
  String? cgsttax;
  String? sgsttax;
  String? igsttax;
  String? savingamount;
  int? minimumbasket;
  String? orderid;
  String? walletamt;
  String? payamt;
  dynamic delcharge;
  dynamic subtotal;
  String? dicountper;
  String? dicountamt;
  String? subtotalfinal;
  String? couponName;
  String? couponamt;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        totalQty: json["totalQty"],
        totalWeight: json["totalWeight"],
        totalcount: json["totalcount"],
        pretaxamount: json["pretaxamount"],
        posttaxamount: json["posttaxamount"],
        cgsttax: json["cgsttax"],
        sgsttax: json["sgsttax"],
        igsttax: json["Igsttax"],
        savingamount: json["Savingamount"],
        minimumbasket: json["Minimumbasket"],
        orderid: json["Orderid"],
        walletamt: json["Walletamt"],
        payamt: json["payamt"],
        delcharge: json["Delcharge"],
        subtotal: json["subtotal"],
        dicountper: json["Dicountper"],
        dicountamt: json["Dicountamt"],
        subtotalfinal: json["subtotalfinal"],
        couponName: json["CouponName"],
        couponamt: json["Couponamt"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "totalQty": totalQty,
        "totalWeight": totalWeight,
        "totalcount": totalcount,
        "pretaxamount": pretaxamount,
        "posttaxamount": posttaxamount,
        "cgsttax": cgsttax,
        "sgsttax": sgsttax,
        "Igsttax": igsttax,
        "Savingamount": savingamount,
        "Minimumbasket": minimumbasket,
        "Orderid": orderid,
        "Walletamt": walletamt,
        "payamt": payamt,
        "Delcharge": delcharge,
        "subtotal": subtotal,
        "Dicountper": dicountper,
        "Dicountamt": dicountamt,
        "subtotalfinal": subtotalfinal,
        "CouponName": couponName,
        "Couponamt": couponamt
      };
}
