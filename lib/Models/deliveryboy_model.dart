// To parse this JSON data, do
//
//     final deliveryBoyListModel = deliveryBoyListModelFromJson(jsonString);

import 'dart:convert';

DeliveryBoyListModel deliveryBoyListModelFromJson(String str) =>
    DeliveryBoyListModel.fromJson(json.decode(str));

String deliveryBoyListModelToJson(DeliveryBoyListModel data) =>
    json.encode(data.toJson());

class DeliveryBoyListModel {
  DeliveryBoyListModel({
    required this.d,
  });

  List<D> d;

  factory DeliveryBoyListModel.fromJson(Map<String, dynamic> json) =>
      DeliveryBoyListModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  D({
    required this.type,
    required this.delboyid,
    required this.delboyName,
    required this.status,
  });

  String type;
  String delboyid;
  String delboyName;
  String status;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        delboyid: json["delboyid"],
        delboyName: json["delboyName"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "delboyid": delboyid,
        "delboyName": delboyName,
        "Status": status,
      };
}
