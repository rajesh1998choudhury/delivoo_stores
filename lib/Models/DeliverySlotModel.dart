// To parse this JSON data, do
//
//     final deliverySlotModel = deliverySlotModelFromJson(jsonString);

import 'dart:convert';

DeliverySlotModel deliverySlotModelFromJson(String str) =>
    DeliverySlotModel.fromJson(json.decode(str));

String deliverySlotModelToJson(DeliverySlotModel data) =>
    json.encode(data.toJson());

class DeliverySlotModel {
  DeliverySlotModel({
    this.d,
  });

  List<D>? d;

  factory DeliverySlotModel.fromJson(Map<String, dynamic> json) =>
      DeliverySlotModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.slotid,
    this.slotstarttime,
    this.slotendtime,
    this.slotstatus,
    this.companyid,
    this.orderlimit,
  });

  String? type;
  String? slotid;
  String? slotstarttime;
  String? slotendtime;
  String? slotstatus;
  dynamic companyid;
  String? orderlimit;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        slotid: json["slotid"],
        slotstarttime: json["slotstarttime"],
        slotendtime: json["slotendtime"],
        slotstatus: json["slotstatus"],
        companyid: json["companyid"],
        orderlimit: json["Orderlimit"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "slotid": slotid,
        "slotstarttime": slotstarttime,
        "slotendtime": slotendtime,
        "slotstatus": slotstatus,
        "companyid": companyid,
        "Orderlimit": orderlimit,
      };
}
