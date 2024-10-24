import 'dart:convert';

StoreOrderingSubcategoryModel StoreOrderingSubcategoryModelFromJson(
        String str) =>
    StoreOrderingSubcategoryModel.fromJson(json.decode(str));

String StoreOrderingSubcategoryModelToJson(
        StoreOrderingSubcategoryModel data) =>
    json.encode(data.toJson());

class StoreOrderingSubcategoryModel {
  StoreOrderingSubcategoryModel({
    this.d,
  });

  List<D>? d;

  factory StoreOrderingSubcategoryModel.fromJson(Map<String, dynamic> json) =>
      StoreOrderingSubcategoryModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.sectionid,
    this.sectionName,
    this.sectionimg,
    this.sdatetime,
  });

  String? type;
  String? sectionid;
  String? sectionName;
  String? sectionimg;
  String? sdatetime;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        sectionid: json["Sectionid"],
        sectionName: json["SectionName"],
        sectionimg: json["Sectionimg"],
        sdatetime: json["Sdatetime"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "Sectionid": sectionid,
        "SectionName": sectionName,
        "Sectionimg": sectionimg,
        "Sdatetime": sdatetime,
      };
}
