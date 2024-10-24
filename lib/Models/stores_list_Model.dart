// To parse this JSON data, do
//
//     final storesListModel = storesListModelFromJson(jsonString);

import 'dart:convert';

StoresListModel storesListModelFromJson(String str) =>
    StoresListModel.fromJson(json.decode(str));

String storesListModelToJson(StoresListModel data) =>
    json.encode(data.toJson());

class StoresListModel {
  StoresListModel({
    this.d,
  });

  List<D>? d;

  factory StoresListModel.fromJson(Map<String, dynamic> json) =>
      StoresListModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.warehouseId,
    this.storeLocation,
    this.address1,
    this.address2,
    this.city,
    this.pincode,
    this.contactNo,
    this.storeImage,
    this.storeLocationName,
  });

  String? type;
  String? warehouseId;
  String? storeLocation;
  String? address1;
  String? address2;
  dynamic city;
  String? pincode;
  String? contactNo;
  String? storeImage;
  String? storeLocationName;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        warehouseId: json["WarehouseID"],
        storeLocation: json["StoreLocation"],
        address1: json["Address1"],
        address2: json["Address2"],
        city: json["City"],
        pincode: json["Pincode"],
        contactNo: json["contactNo"],
        storeImage: json["StoreImage"],
        storeLocationName: json["StoreLocationName"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "WarehouseID": warehouseId,
        "StoreLocation": storeLocation,
        "Address1": address1,
        "Address2": address2,
        "City": city,
        "Pincode": pincode,
        "contactNo": contactNo,
        "StoreImage": storeImage,
        "StoreLocationName": storeLocationName,
      };
}
