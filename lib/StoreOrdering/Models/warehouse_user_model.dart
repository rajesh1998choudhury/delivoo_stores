// To parse this JSON data, do
//
//     final wareHouseUserModel = wareHouseUserModelFromJson(jsonString);

import 'dart:convert';

WareHouseUserModel wareHouseUserModelFromJson(String str) =>
    WareHouseUserModel.fromJson(json.decode(str));

String wareHouseUserModelToJson(WareHouseUserModel data) =>
    json.encode(data.toJson());

class WareHouseUserModel {
  D d;

  WareHouseUserModel({
    required this.d,
  });

  factory WareHouseUserModel.fromJson(Map<String, dynamic> json) =>
      WareHouseUserModel(
        d: D.fromJson(json["d"]),
      );

  Map<String, dynamic> toJson() => {
        "d": d.toJson(),
      };
}

class D {
  String type;
  String cityId;
  String warehouseName;
  String currentDate;

  D({
    required this.type,
    required this.cityId,
    required this.warehouseName,
    required this.currentDate,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        cityId: json["CityId"],
        warehouseName: json["WarehouseName"],
        currentDate: json["CurrentDate"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "CityId": cityId,
        "WarehouseName": warehouseName,
        "CurrentDate": currentDate,
      };
}
