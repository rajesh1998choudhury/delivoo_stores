// To parse this JSON data, do
//
//     final warehouseStoresModel = warehouseStoresModelFromJson(jsonString);

import 'dart:convert';

WarehouseStoresModel warehouseStoresModelFromJson(String str) =>
    WarehouseStoresModel.fromJson(json.decode(str));

String warehouseStoresModelToJson(WarehouseStoresModel data) =>
    json.encode(data.toJson());

class WarehouseStoresModel {
  List<D> d;

  WarehouseStoresModel({
    required this.d,
  });

  factory WarehouseStoresModel.fromJson(Map<String, dynamic> json) =>
      WarehouseStoresModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  String type;
  dynamic bOrderId;
  dynamic bOrderNo;
  dynamic orderamt;
  dynamic compId;
  dynamic compName;
  String warehouseId;
  String warehouseName;
  dynamic datetim;
  dynamic createdby;
  dynamic totalsale;
  dynamic orderCount;
  dynamic noofPacks;
  dynamic cashOrderamount;
  dynamic onlineOrderamount;
  dynamic skuname;
  dynamic saleunit;
  dynamic returnqty;
  dynamic returnAmount;
  dynamic rtvPercentage;
  dynamic rtvThreshold;
  dynamic saleTarget;
  dynamic saleAfterAdj;
  dynamic adjustmentPer;
  dynamic adjustedAmount;
  dynamic pvSaleAfterAdjustment;
  dynamic pvAdjustedPercentage;
  dynamic pvAdjustedAmount;
  dynamic sameDayRtvAmount;
  dynamic sameDayRtv;
  dynamic nvSaleAfterAdjustment;
  dynamic nvAdjustedAmount;
  dynamic nvAdjustedPercentage;
  dynamic targetPercentage;
  dynamic returnCost;

  D({
    required this.type,
    this.bOrderId,
    this.bOrderNo,
    this.orderamt,
    this.compId,
    this.compName,
    required this.warehouseId,
    required this.warehouseName,
    this.datetim,
    this.createdby,
    this.totalsale,
    this.orderCount,
    this.noofPacks,
    this.cashOrderamount,
    this.onlineOrderamount,
    this.skuname,
    this.saleunit,
    this.returnqty,
    this.returnAmount,
    this.rtvPercentage,
    this.rtvThreshold,
    this.saleTarget,
    this.saleAfterAdj,
    this.adjustmentPer,
    this.adjustedAmount,
    this.pvSaleAfterAdjustment,
    this.pvAdjustedPercentage,
    this.pvAdjustedAmount,
    this.sameDayRtvAmount,
    this.sameDayRtv,
    this.nvSaleAfterAdjustment,
    this.nvAdjustedAmount,
    this.nvAdjustedPercentage,
    this.targetPercentage,
    this.returnCost,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        bOrderId: json["b_order_id"],
        bOrderNo: json["b_order_no"],
        orderamt: json["Orderamt"],
        compId: json["comp_id"],
        compName: json["comp_name"],
        warehouseId: json["warehouse_id"],
        warehouseName: json["warehouse_name"],
        datetim: json["datetim"],
        createdby: json["createdby"],
        totalsale: json["totalsale"],
        orderCount: json["OrderCount"],
        noofPacks: json["NoofPacks"],
        cashOrderamount: json["CashOrderamount"],
        onlineOrderamount: json["OnlineOrderamount"],
        skuname: json["skuname"],
        saleunit: json["saleunit"],
        returnqty: json["Returnqty"],
        returnAmount: json["ReturnAmount"],
        rtvPercentage: json["RtvPercentage"],
        rtvThreshold: json["RTVThreshold"],
        saleTarget: json["SaleTarget"],
        saleAfterAdj: json["sale_after_adj"],
        adjustmentPer: json["adjustment_per"],
        adjustedAmount: json["AdjustedAmount"],
        pvSaleAfterAdjustment: json["PvSaleAfterAdjustment"],
        pvAdjustedPercentage: json["PvAdjustedPercentage"],
        pvAdjustedAmount: json["PvAdjustedAmount"],
        sameDayRtvAmount: json["SameDayRtvAmount"],
        sameDayRtv: json["SameDayRtv"],
        nvSaleAfterAdjustment: json["NvSaleAfterAdjustment"],
        nvAdjustedAmount: json["NvAdjustedAmount"],
        nvAdjustedPercentage: json["NvAdjustedPercentage"],
        targetPercentage: json["TargetPercentage"],
        returnCost: json["ReturnCost"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "b_order_id": bOrderId,
        "b_order_no": bOrderNo,
        "Orderamt": orderamt,
        "comp_id": compId,
        "comp_name": compName,
        "warehouse_id": warehouseId,
        "warehouse_name": warehouseName,
        "datetim": datetim,
        "createdby": createdby,
        "totalsale": totalsale,
        "OrderCount": orderCount,
        "NoofPacks": noofPacks,
        "CashOrderamount": cashOrderamount,
        "OnlineOrderamount": onlineOrderamount,
        "skuname": skuname,
        "saleunit": saleunit,
        "Returnqty": returnqty,
        "ReturnAmount": returnAmount,
        "RtvPercentage": rtvPercentage,
        "RTVThreshold": rtvThreshold,
        "SaleTarget": saleTarget,
        "sale_after_adj": saleAfterAdj,
        "adjustment_per": adjustmentPer,
        "AdjustedAmount": adjustedAmount,
        "PvSaleAfterAdjustment": pvSaleAfterAdjustment,
        "PvAdjustedPercentage": pvAdjustedPercentage,
        "PvAdjustedAmount": pvAdjustedAmount,
        "SameDayRtvAmount": sameDayRtvAmount,
        "SameDayRtv": sameDayRtv,
        "NvSaleAfterAdjustment": nvSaleAfterAdjustment,
        "NvAdjustedAmount": nvAdjustedAmount,
        "NvAdjustedPercentage": nvAdjustedPercentage,
        "TargetPercentage": targetPercentage,
        "ReturnCost": returnCost,
      };
}
