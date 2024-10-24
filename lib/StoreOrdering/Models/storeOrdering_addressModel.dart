import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  AddressModel({
    this.d,
  });

  List<D>? d;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.addressId,
    this.address,
    this.title,
    this.latitude,
    this.longitude,
    this.pincode,
    this.membershipId,
    this.adstatus,
    this.address1,
    this.address2,
    this.duplicate,
  });

  String? type;
  String? addressId;
  String? address;
  String? title;
  String? latitude;
  String? longitude;
  String? pincode;
  String? membershipId;
  String? adstatus;
  String? address1;
  String? address2;
  String? duplicate;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        addressId: json["addressId"],
        address: json["address"],
        title: json["Title"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        pincode: json["pincode"],
        membershipId: json["membershipId"],
        adstatus: json["adstatus"],
        address1: json["address1"],
        address2: json["address2"],
        duplicate: json["duplicate"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "addressId": addressId,
        "address": address,
        "Title": title,
        "latitude": latitude,
        "longitude": longitude,
        "pincode": pincode,
        "membershipId": membershipId,
        "adstatus": adstatus,
        "address1": address1,
        "address2": address2,
        "duplicate": duplicate,
      };
}
