// To parse this JSON data, do
//
//     final returnStoreItemsModel = returnStoreItemsModelFromJson(jsonString);

import 'dart:convert';

ReturnStoreItemsModel returnStoreItemsModelFromJson(String str) =>
    ReturnStoreItemsModel.fromJson(json.decode(str));

String returnStoreItemsModelToJson(ReturnStoreItemsModel data) =>
    json.encode(data.toJson());

class ReturnStoreItemsModel {
  ReturnStoreItemsModel({
    required this.d,
  });

  List<D> d;

  factory ReturnStoreItemsModel.fromJson(Map<String, dynamic> json) =>
      ReturnStoreItemsModel(
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
    required this.wastageqty,
    required this.returnqty,
    required this.stockqty,
    required this.orderqty,
    required this.orderno,
    required this.orderid,
    required this.receiveqty,
    required this.prevReturnqty,
    required this.returnDetails,
    required this.image,
    required this.balQty,
    required this.returnlockstatus,
    required this.rtvOpenTime,
    required this.rtvCloseTime,
  });

  String type;
  String skuid;
  String skusid;
  String itemname;
  String wastageqty;
  String returnqty;
  String stockqty;
  String orderqty;
  String orderno;
  String orderid;
  String receiveqty;
  String prevReturnqty;
  String returnDetails;
  String image;
  String balQty;
  String returnlockstatus;
  String rtvOpenTime;
  String rtvCloseTime;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        skuid: json["skuid"],
        skusid: json["skusid"],
        itemname: json["itemname"],
        wastageqty: json["wastageqty"],
        returnqty: json["returnqty"],
        stockqty: json["stockqty"],
        orderqty: json["orderqty"],
        orderno: json["orderno"],
        orderid: json["orderid"],
        receiveqty: json["receiveqty"],
        prevReturnqty: json["PrevReturnqty"],
        returnDetails: json["ReturnDetails"],
        image: json['imgpath'],
        balQty: json['BalQty'],
        returnlockstatus: json["Returnlockstatus"],
        rtvOpenTime: json["RTVOpenTime"],
        rtvCloseTime: json["RTVCloseTime"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "skuid": skuid,
        "skusid": skusid,
        "itemname": itemname,
        "wastageqty": wastageqty,
        "returnqty": returnqty,
        "stockqty": stockqty,
        "orderqty": orderqty,
        "orderno": orderno,
        "orderid": orderid,
        "receiveqty": receiveqty,
        "PrevReturnqty": prevReturnqty,
        "ReturnDetails": returnDetails,
        "imgpath": image,
        "BalQty": balQty,
        "Returnlockstatus": returnlockstatus,
        "RTVOpenTime": rtvOpenTime,
        "RTVCloseTime": rtvCloseTime,
      };
}
