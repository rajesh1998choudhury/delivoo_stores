// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

OrderDetailModel orderDetailModelFromJson(String str) =>
    OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) =>
    json.encode(data.toJson());

class OrderDetailModel {
  OrderDetailModel({
    this.d,
  });

  List<D>? d;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D(
      {this.type,
      this.itemId,
      this.itemsubId,
      this.imagename,
      this.qty,
      this.itemName,
      this.itemRate,
      this.totalamount,
      this.itemStatus,
      this.delUnit,
      this.packingcount,
      this.unAvailable,
      this.Receivedby,
      this.Receivedon});

  String? type;
  String? itemId;
  String? itemsubId;
  String? imagename;
  String? qty;
  String? itemName;
  String? itemRate;
  String? totalamount;
  String? itemStatus;
  String? delUnit;
  String? packingcount;
  String? unAvailable;
  String? Receivedby;
  String? Receivedon;

  factory D.fromJson(Map<String, dynamic> json) => D(
      type: json["__type"],
      itemId: json["ItemId"],
      itemsubId: json["ItemsubId"],
      imagename: json["Imagename"],
      qty: json["Qty"],
      itemName: json["ItemName"],
      itemRate: json["ItemRate"],
      totalamount: json["Totalamount"],
      itemStatus: json["ItemStatus"] != null ? json["ItemStatus"] : false,
      delUnit: json["DelUnit"],
      packingcount: json["Packingcount"],
      unAvailable: json['unavailable'],
      Receivedby: json['Receivedby'],
      Receivedon: json['Receivedon']);

  Map<String, dynamic> toJson() => {
        "__type": type,
        "ItemId": itemId,
        "ItemsubId": itemsubId,
        "Imagename": imagename,
        "Qty": qty,
        "ItemName": itemName,
        "ItemRate": itemRate,
        "Totalamount": totalamount,
        "ItemStatus": itemStatus,
        "DelUnit": delUnit,
        "Packingcount": packingcount,
        'unavailable': unAvailable,
        'Receivedby': Receivedby,
        'Receivedon': Receivedon
      };
}
