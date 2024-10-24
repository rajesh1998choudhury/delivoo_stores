// To parse this JSON data, do
//
//     final getStockTransferAlItemsmodel = getStockTransferAlItemsmodelFromJson(jsonString);

import 'dart:convert';

GetStockTransferAlItemsmodel getStockTransferAlItemsmodelFromJson(String str) => GetStockTransferAlItemsmodel.fromJson(json.decode(str));

String getStockTransferAlItemsmodelToJson(GetStockTransferAlItemsmodel data) => json.encode(data.toJson());

class GetStockTransferAlItemsmodel {
    List<D> d;

    GetStockTransferAlItemsmodel({
        required this.d,
    });

    factory GetStockTransferAlItemsmodel.fromJson(Map<String, dynamic> json) => GetStockTransferAlItemsmodel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
    };
}

class D {
    Type type;
    String skuSid;
    String itemName;
    dynamic skuId;
    dynamic stockUnit;

    D({
        required this.type,
        required this.skuSid,
        required this.itemName,
        this.skuId,
        this.stockUnit,
    });

    factory D.fromJson(Map<String, dynamic> json) => D(
        type: typeValues.map[json["__type"]]!,
        skuSid: json["sku_sid"],
        itemName: json["ItemName"],
        skuId: json["sku_id"],
        stockUnit: json["stock_unit"],
    );

    Map<String, dynamic> toJson() => {
        "__type": typeValues.reverse[type],
        "sku_sid": skuSid,
        "ItemName": itemName,
        "sku_id": skuId,
        "stock_unit": stockUnit,
    };
}

enum Type {
    BO_ADMIN_BO_STORE_STOCK_ITEMS
}

final typeValues = EnumValues({
    "BOAdmin.BOStore_stock_items": Type.BO_ADMIN_BO_STORE_STOCK_ITEMS
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
