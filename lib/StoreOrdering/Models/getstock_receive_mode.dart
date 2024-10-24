// To parse this JSON data, do
//
//     final getStockReceiveDataModel = getStockReceiveDataModelFromJson(jsonString);

import 'dart:convert';

GetStockReceiveDataModel getStockReceiveDataModelFromJson(String str) =>
    GetStockReceiveDataModel.fromJson(json.decode(str));

String getStockReceiveDataModelToJson(GetStockReceiveDataModel data) =>
    json.encode(data.toJson());

class GetStockReceiveDataModel {
  List<D> d;

  GetStockReceiveDataModel({
    required this.d,
  });

  factory GetStockReceiveDataModel.fromJson(Map<String, dynamic> json) =>
      GetStockReceiveDataModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  String type;
  dynamic skuId;
  String itemName;
  dynamic storeId;
  dynamic storeName;
  String skuSid;
  String dSkuId;
  dynamic stockUnit;
  String transferqty;
  String transferBy;
  String transId;
  String transferFrom;
  String receiveqty;
  String balanceqty;
  String receiveBy;
  String receiveStatus;
  String imgpath;

  D({
    required this.type,
    required this.skuId,
    required this.itemName,
    required this.storeId,
    required this.storeName,
    required this.skuSid,
    required this.dSkuId,
    required this.stockUnit,
    required this.transferqty,
    required this.transferBy,
    required this.transId,
    required this.transferFrom,
    required this.receiveqty,
    required this.balanceqty,
    required this.receiveBy,
    required this.receiveStatus,
    required this.imgpath,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        skuId: json["SkuId"],
        itemName: json["ItemName"],
        storeId: json["store_id"],
        storeName: json["store_name"],
        skuSid: json["sku_sid"],
        dSkuId: json["sku_id"],
        stockUnit: json["stock_unit"],
        transferqty: json["Transferqty"],
        transferBy: json["TransferBy"],
        transId: json["Trans_ID"],
        transferFrom: json["TransferFrom"],
        receiveqty: json["receiveqty"],
        balanceqty: json["balanceqty"],
        receiveBy: json["ReceiveBy"],
        receiveStatus: json["ReceiveStatus"],
        imgpath: json["imgpath"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "SkuId": skuId,
        "ItemName": itemName,
        "store_id": storeId,
        "store_name": storeName,
        "sku_sid": skuSid,
        "sku_id": dSkuId,
        "stock_unit": stockUnit,
        "Transferqty": transferqty,
        "TransferBy": transferBy,
        "Trans_ID": transId,
        "TransferFrom": transferFrom,
        "receiveqty": receiveqty,
        "balanceqty": balanceqty,
        "ReceiveBy": receiveBy,
        "ReceiveStatus": receiveStatus,
        "imgpath": imgpath,
      };
}
