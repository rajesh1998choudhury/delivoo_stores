// To parse this JSON data, do
//
//     final getStoreListForStockTramsfermodel = getStoreListForStockTramsfermodelFromJson(jsonString);

import 'dart:convert';

GetStoreListForStockTramsfermodel getStoreListForStockTramsfermodelFromJson(
        String str) =>
    GetStoreListForStockTramsfermodel.fromJson(json.decode(str));

String getStoreListForStockTramsfermodelToJson(
        GetStoreListForStockTramsfermodel data) =>
    json.encode(data.toJson());

class GetStoreListForStockTramsfermodel {
  List<D> d;

  GetStoreListForStockTramsfermodel({
    required this.d,
  });

  factory GetStoreListForStockTramsfermodel.fromJson(
          Map<String, dynamic> json) =>
      GetStoreListForStockTramsfermodel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  Type type;
  String storeId;
  String storeName;

  D({
    required this.type,
    required this.storeId,
    required this.storeName,
  });

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: typeValues.map[json["__type"]]!,
        storeId: json["store_id"],
        storeName: json["store_name"],
      );

  Map<String, dynamic> toJson() => {
        "__type": typeValues.reverse[type],
        "store_id": storeId,
        "store_name": storeName,
      };
}

enum Type { BO_ADMIN_BO_STORE_STOCK }

final typeValues =
    EnumValues({"BOAdmin.BOStore_stock": Type.BO_ADMIN_BO_STORE_STOCK});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
