// To parse this JSON data, do
//
//     final getItemsModel = getItemsModelFromJson(jsonString);

import 'dart:convert';

GetItemsModel getItemsModelFromJson(String str) =>
    GetItemsModel.fromJson(json.decode(str));

String getItemsModelToJson(GetItemsModel data) => json.encode(data.toJson());

class GetItemsModel {
  GetItemsModel({
    required this.d,
  });

  List<D> d;

  factory GetItemsModel.fromJson(Map<String, dynamic> json) => GetItemsModel(
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
    required this.skuSid,
  });

  String type;
  String skuname;
  String skuSid;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        skuname: json["skuname"],
        skuSid: json["sku_sid"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "skuname": skuname,
        "sku_sid": skuSid,
      };
}
