// To parse this JSON data, do
//
//     final invoiceDetailModel = invoiceDetailModelFromJson(jsonString);

import 'dart:convert';

InvoiceDetailModel invoiceDetailModelFromJson(String str) =>
    InvoiceDetailModel.fromJson(json.decode(str));

String invoiceDetailModelToJson(InvoiceDetailModel data) =>
    json.encode(data.toJson());

class InvoiceDetailModel {
  InvoiceDetailModel({
    required this.d,
  });

  List<D> d;

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) =>
      InvoiceDetailModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  D({
    required this.type,
    required this.skuname,
    required this.bOrderNo,
    required this.membershipNo,
    required this.bOrderId,
    required this.skuId,
    required this.skusid,
    required this.skuImage,
    required this.skuUnit,
    required this.delUnit,
    required this.skuRate,
    required this.skuTotalAmt,
    required this.itemstatus,
    required this.paymentmethod,
  });

  String type;
  String skuname;
  String bOrderNo;
  String membershipNo;
  String bOrderId;
  String skuId;
  String skusid;
  String skuImage;
  String skuUnit;
  String delUnit;
  String skuRate;
  String skuTotalAmt;
  String itemstatus;
  String paymentmethod;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        skuname: json["skuname"],
        bOrderNo: json["b_order_no"],
        membershipNo: json["membership_no"],
        bOrderId: json["b_order_id"],
        skuId: json["sku_id"],
        skusid: json["skusid"],
        skuImage: json["sku_image"],
        skuUnit: json["sku_unit"],
        delUnit: json["DelUnit"],
        skuRate: json["sku_rate"],
        skuTotalAmt: json["sku_total_amt"],
        itemstatus: json["itemstatus"],
        paymentmethod: json["paymentmethod"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "skuname": skuname,
        "b_order_no": bOrderNo,
        "membership_no": membershipNo,
        "b_order_id": bOrderId,
        "sku_id": skuId,
        "skusid": skusid,
        "sku_image": skuImage,
        "sku_unit": skuUnit,
        "DelUnit": delUnit,
        "sku_rate": skuRate,
        "sku_total_amt": skuTotalAmt,
        "itemstatus": itemstatus,
        "paymentmethod": paymentmethod,
      };
}
