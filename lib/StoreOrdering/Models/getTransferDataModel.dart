// To parse this JSON data, do
//
//     final getTransferDataModel = getTransferDataModelFromJson(jsonString);

import 'dart:convert';

GetTransferDataModel getTransferDataModelFromJson(String str) =>
    GetTransferDataModel.fromJson(json.decode(str));

String getTransferDataModelToJson(GetTransferDataModel data) =>
    json.encode(data.toJson());

class GetTransferDataModel {
  List<D> d;

  GetTransferDataModel({
    required this.d,
  });

  factory GetTransferDataModel.fromJson(Map<String, dynamic> json) =>
      GetTransferDataModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  String type;
  String skuSid;
  String itemName;
  String imgpath;
  String skuId;
  String stockUnit;
  String transferqty;
  String transferBy;
  String transId;

  D({
    required this.type,
    required this.skuSid,
    required this.itemName,
    required this.imgpath,
    required this.skuId,
    required this.stockUnit,
    required this.transferqty,
    required this.transferBy,
    required this.transId,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        skuSid: json["sku_sid"],
        itemName: json["ItemName"],
        imgpath: json["imgpath"],
        skuId: json["sku_id"],
        stockUnit: json["stock_unit"],
        transferqty: json["Transferqty"],
        transferBy: json["TransferBy"],
        transId: json["Trans_ID"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "sku_sid": skuSid,
        "ItemName": itemName,
        "imgpath": imgpath,
        "sku_id": skuId,
        "stock_unit": stockUnit,
        "Transferqty": transferqty,
        "TransferBy": transferBy,
        "Trans_ID": transId,
      };
}
