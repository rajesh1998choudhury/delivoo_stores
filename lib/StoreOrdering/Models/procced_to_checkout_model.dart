// To parse this JSON data, do
//
//     final proccedToCheckoutModel = proccedToCheckoutModelFromJson(jsonString);

import 'dart:convert';

ProccedToCheckoutModel proccedToCheckoutModelFromJson(String str) =>
    ProccedToCheckoutModel.fromJson(json.decode(str));

String proccedToCheckoutModelToJson(ProccedToCheckoutModel data) =>
    json.encode(data.toJson());

class ProccedToCheckoutModel {
  ProccedToCheckoutModel({
    this.d,
  });

  List<D>? d;

  factory ProccedToCheckoutModel.fromJson(Map<String, dynamic> json) =>
      ProccedToCheckoutModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.delday,
    this.location,
    this.locationId,
    this.urDel,
    this.urDelTime,
    this.maxDelDay,
    this.minimumbasket,
    this.kisanservStore,
    this.payonDel,
    this.paymentStatus,
  });

  String? type;
  String? delday;
  String? location;
  String? locationId;
  String? urDel;
  String? urDelTime;
  String? maxDelDay;
  String? minimumbasket;
  String? kisanservStore;
  String? payonDel;
  String? paymentStatus;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        delday: json["Delday"],
        location: json["Location"],
        locationId: json["LocationID"],
        urDel: json["UrDel"],
        urDelTime: json["UrDelTime"],
        maxDelDay: json["MaxDelDay"],
        minimumbasket: json["Minimumbasket"],
        kisanservStore: json["KisanservStore"],
        payonDel: json["Payondel"],
        paymentStatus: json["PaymentStatus"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "Delday": delday,
        "Location": location,
        "LocationID": locationId,
        "UrDel": urDel,
        "UrDelTime": urDelTime,
        "MaxDelDay": maxDelDay,
        "Minimumbasket": minimumbasket,
        "KisanservStore": kisanservStore,
        "Payondel": payonDel,
        "PaymentStatus": paymentStatus,
      };
}
