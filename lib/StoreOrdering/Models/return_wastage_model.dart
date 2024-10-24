// To parse this JSON data, do
//
//     final returnStoreWastageModel = returnStoreWastageModelFromJson(jsonString);

import 'dart:convert';

ReturnStoreWastageModel returnStoreWastageModelFromJson(String str) =>
    ReturnStoreWastageModel.fromJson(json.decode(str));

String returnStoreWastageModelToJson(ReturnStoreWastageModel data) =>
    json.encode(data.toJson());

class ReturnStoreWastageModel {
  ReturnStoreWastageModel({
    required this.d,
  });

  List<D> d;

  factory ReturnStoreWastageModel.fromJson(Map<String, dynamic> json) =>
      ReturnStoreWastageModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  D({
    required this.type,
    required this.skuid,
    required this.skusid,
    required this.itemname,
    required this.imgpath,
    required this.wastageqty,
    required this.returnqty,
    required this.stockqty,
    required this.orderqty,
    required this.orderno,
    required this.orderid,
    required this.receiveqty,
    this.wastageBy,
    required this.balqty,
    required this.wastageDetails,
    required this.prevWastageqty,
  });

  String type;
  String skuid;
  String skusid;
  String itemname;
  String imgpath;
  String wastageqty;
  String returnqty;
  String stockqty;
  String orderqty;
  String orderno;
  String orderid;
  String receiveqty;
  dynamic wastageBy;
  String balqty;
  String wastageDetails;
  String prevWastageqty;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        skuid: json["skuid"],
        skusid: json["skusid"],
        itemname: json["itemname"],
        imgpath: json["imgpath"],
        wastageqty: json["wastageqty"],
        returnqty: json["returnqty"],
        stockqty: json["stockqty"],
        orderqty: json["orderqty"],
        orderno: json["orderno"],
        orderid: json["orderid"],
        receiveqty: json["receiveqty"],
        wastageBy: json["WastageBy"],
        balqty: json["balqty"],
        wastageDetails: json["WastageDetails"],
        prevWastageqty: json["PrevWastageqty"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "skuid": skuid,
        "skusid": skusid,
        "itemname": itemname,
        "imgpath": imgpath,
        "wastageqty": wastageqty,
        "returnqty": returnqty,
        "stockqty": stockqty,
        "orderqty": orderqty,
        "orderno": orderno,
        "orderid": orderid,
        "receiveqty": receiveqty,
        "WastageBy": wastageBy,
        "balqty": balqty,
        "WastageDetails": wastageDetails,
        "PrevWastageqty": prevWastageqty,
      };
}
