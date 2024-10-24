// To parse this JSON data, do
//
//     final reasonModel = reasonModelFromJson(jsonString);

import 'dart:convert';

ReasonModel reasonModelFromJson(String str) =>
    ReasonModel.fromJson(json.decode(str));

String reasonModelToJson(ReasonModel data) => json.encode(data.toJson());

class ReasonModel {
  List<D> d;

  ReasonModel({
    required this.d,
  });

  factory ReasonModel.fromJson(Map<String, dynamic> json) => ReasonModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  String type;
  dynamic storename;
  dynamic itemname;
  dynamic returnqty;
  dynamic warehouse;
  dynamic rtnId;
  dynamic recieveqty;
  dynamic shortqty;
  String reasonid;
  String reason;
  dynamic orderno;
  dynamic skuid;
  dynamic skusid;
  dynamic storeId;
  dynamic returnBy;
  dynamic receiveBy;
  dynamic returnRate;
  dynamic receiveRate;
  dynamic difdays;
  dynamic warehouseRecovery;
  dynamic wastage;
  dynamic recoveryIncharge;
  dynamic recoveryqty;
  dynamic recoveryUoMid;
  dynamic recoveryMname;
  dynamic wasteqty;
  dynamic wasteUoMid;
  dynamic wasteMname;
  dynamic wastageDisplay;

  D({
    required this.type,
    this.storename,
    this.itemname,
    this.returnqty,
    this.warehouse,
    this.rtnId,
    this.recieveqty,
    this.shortqty,
    required this.reasonid,
    required this.reason,
    this.orderno,
    this.skuid,
    this.skusid,
    this.storeId,
    this.returnBy,
    this.receiveBy,
    this.returnRate,
    this.receiveRate,
    this.difdays,
    this.warehouseRecovery,
    this.wastage,
    this.recoveryIncharge,
    this.recoveryqty,
    this.recoveryUoMid,
    this.recoveryMname,
    this.wasteqty,
    this.wasteUoMid,
    this.wasteMname,
    this.wastageDisplay,
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
      );

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
      };
}
