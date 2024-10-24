// To parse this JSON data, do
//
//     final cityLIstModel = cityLIstModelFromJson(jsonString);

import 'dart:convert';

CityLIstModel cityLIstModelFromJson(String str) =>
    CityLIstModel.fromJson(json.decode(str));

String cityLIstModelToJson(CityLIstModel data) => json.encode(data.toJson());

class CityLIstModel {
  List<D> d;

  CityLIstModel({
    required this.d,
  });

  factory CityLIstModel.fromJson(Map<String, dynamic> json) => CityLIstModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  String type;
  String cityName;
  String cityId;
  String companyId;
  String companyName;

  D({
    required this.type,
    required this.cityName,
    required this.cityId,
    required this.companyId,
    required this.companyName,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        cityName: json["CityName"],
        cityId: json["CityId"],
        companyId: json["companyId"],
        companyName: json["CompanyName"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "CityName": cityName,
        "CityId": cityId,
        "companyId": companyId,
        "CompanyName": companyName,
      };
}
