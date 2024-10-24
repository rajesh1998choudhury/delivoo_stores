// To parse this JSON data, do
//
//     final storeOrderingCategoryModel = storeOrderingCategoryModelFromJson(jsonString);

import 'dart:convert';

StoreOrderingCategoryModel storeOrderingCategoryModelFromJson(String str) =>
    StoreOrderingCategoryModel.fromJson(json.decode(str));

String storeOrderingCategoryModelToJson(StoreOrderingCategoryModel data) =>
    json.encode(data.toJson());

class StoreOrderingCategoryModel {
  List<D> d;

  StoreOrderingCategoryModel({
    required this.d,
  });

  factory StoreOrderingCategoryModel.fromJson(Map<String, dynamic> json) =>
      StoreOrderingCategoryModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  String type;
  String catid;
  String catName;
  String? catimg;
  String catdatetime;
  String catStatus;
  String subcatid;
  String sectionid;

  D({
    required this.type,
    required this.catid,
    required this.catName,
    this.catimg,
    required this.catdatetime,
    required this.catStatus,
    required this.subcatid,
    required this.sectionid,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        catid: json["Catid"],
        catName: json["CatName"],
        catimg: json["Catimg"],
        catdatetime: json["Catdatetime"],
        catStatus: json["CatStatus"],
        subcatid: json["Subcatid"],
        sectionid: json["Sectionid"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "Catid": catid,
        "CatName": catName,
        "Catimg": catimg,
        "Catdatetime": catdatetime,
        "CatStatus": catStatus,
        "Subcatid": subcatid,
        "Sectionid": sectionid,
      };
}
