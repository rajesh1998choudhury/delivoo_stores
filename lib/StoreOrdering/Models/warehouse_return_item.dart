// To parse this JSON data, do
//
//     final warehouseReturnItemModel = warehouseReturnItemModelFromJson(jsonString);

import 'dart:convert';

WarehouseReturnItemModel warehouseReturnItemModelFromJson(String str) =>
    WarehouseReturnItemModel.fromJson(json.decode(str));

String warehouseReturnItemModelToJson(WarehouseReturnItemModel data) =>
    json.encode(data.toJson());

class WarehouseReturnItemModel {
  List<D> d;

  WarehouseReturnItemModel({
    required this.d,
  });

  factory WarehouseReturnItemModel.fromJson(Map<String, dynamic> json) =>
      WarehouseReturnItemModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  String type;
  String storename;
  String itemname;
  String returnqty;
  String warehouse;
  String rtnId;
  String recieveqty;
  String shortqty;
  dynamic reasonid;
  String reason;
  String orderno;
  String skuid;
  String skusid;
  String storeId;
  String returnBy;
  String receiveBy;
  String returnRate;
  String receiveRate;
  String difdays;
  dynamic warehouseRecovery;
  String wastage;
  String recoveryIncharge;
  String recoveryqty;
  String recoveryUoMid;
  String recoveryMname;
  String wasteqty;
  String wasteUoMid;
  String wasteMname;
  String wastageDisplay;
  String receiveStatus;
  String BalQty;
  String imageName;

  D({
    required this.type,
    required this.storename,
    required this.itemname,
    required this.returnqty,
    required this.warehouse,
    required this.rtnId,
    required this.recieveqty,
    required this.shortqty,
    this.reasonid,
    required this.reason,
    required this.orderno,
    required this.skuid,
    required this.skusid,
    required this.storeId,
    required this.returnBy,
    required this.receiveBy,
    required this.returnRate,
    required this.receiveRate,
    required this.difdays,
    this.warehouseRecovery,
    required this.wastage,
    required this.recoveryIncharge,
    required this.recoveryqty,
    required this.recoveryUoMid,
    required this.recoveryMname,
    required this.wasteqty,
    required this.wasteUoMid,
    required this.wasteMname,
    required this.wastageDisplay,
    required this.receiveStatus,
    required this.BalQty,
    required this.imageName,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
      type: json["__type"],
      storename: json["storename"],
      itemname: json["itemname"],
      returnqty: json["returnqty"],
      warehouse: json["warehouse"],
      rtnId: json["Rtn_ID"],
      recieveqty: json["recieveqty"],
      shortqty: json["shortqty"],
      reasonid: json["reasonid"],
      reason: json["reason"],
      orderno: json["orderno"],
      skuid: json["skuid"],
      skusid: json["skusid"],
      storeId: json["store_id"],
      returnBy: json["returnBy"],
      receiveBy: json["receiveBy"],
      returnRate: json["ReturnRate"],
      receiveRate: json["ReceiveRate"],
      difdays: json["difdays"],
      warehouseRecovery: json["warehouse_recovery"],
      wastage: json["wastage"],
      recoveryIncharge: json["RecoveryIncharge"],
      recoveryqty: json["recoveryqty"],
      recoveryUoMid: json["recovery_UoMid"],
      recoveryMname: json["recovery_Mname"],
      wasteqty: json["wasteqty"],
      wasteUoMid: json["waste_UoMid"],
      wasteMname: json["waste_Mname"],
      wastageDisplay: json["wastageDisplay"],
      receiveStatus: json['receivestatus'],
      BalQty: json['Balqty'],
      imageName: json['Imagename']);

  Map<String, dynamic> toJson() => {
        "__type": type,
        "storename": storename,
        "itemname": itemname,
        "returnqty": returnqty,
        "warehouse": warehouse,
        "Rtn_ID": rtnId,
        "recieveqty": recieveqty,
        "shortqty": shortqty,
        "reasonid": reasonid,
        "reason": reason,
        "orderno": orderno,
        "skuid": skuid,
        "skusid": skusid,
        "store_id": storeId,
        "returnBy": returnBy,
        "receiveBy": receiveBy,
        "ReturnRate": returnRate,
        "ReceiveRate": receiveRate,
        "difdays": difdays,
        "warehouse_recovery": warehouseRecovery,
        "wastage": wastage,
        "RecoveryIncharge": recoveryIncharge,
        "recoveryqty": recoveryqty,
        "recovery_UoMid": recoveryUoMid,
        "recovery_Mname": recoveryMname,
        "wasteqty": wasteqty,
        "waste_UoMid": wasteUoMid,
        "waste_Mname": wasteMname,
        "wastageDisplay": wastageDisplay,
        "receivestatus": receiveStatus,
        "Balqty": BalQty,
        "Imagename": imageName
      };
}
