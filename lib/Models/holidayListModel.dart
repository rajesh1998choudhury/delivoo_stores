// To parse this JSON data, do
//
//     final holidayListModel = holidayListModelFromJson(jsonString);

import 'dart:convert';

HolidayListModel holidayListModelFromJson(String str) =>
    HolidayListModel.fromJson(json.decode(str));

String holidayListModelToJson(HolidayListModel data) =>
    json.encode(data.toJson());

class HolidayListModel {
  HolidayListModel({
    this.d,
  });

  List<D>? d;

  factory HolidayListModel.fromJson(Map<String, dynamic> json) =>
      HolidayListModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.holidayId,
    this.holidayDate,
    this.companyId,
  });

  String? type;
  String? holidayId;
  String? holidayDate;
  String? companyId;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        holidayId: json["HolidayId"],
        holidayDate: json["HolidayDate"],
        companyId: json["CompanyId"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "HolidayId": holidayId,
        "HolidayDate": holidayDate,
        "CompanyId": companyId,
      };
}
