// To parse this JSON data, do
//
//     final StoreOrderingSearchModel = StoreOrderingSearchModelFromJson(jsonString);

//import 'dart:convert';

// List<StoreOrderingSearchModel> StoreOrderingSearchModelFromJson(String str) => List<StoreOrderingSearchModel>.from(
//     json.decode(str).map((x) => StoreOrderingSearchModel.fromJson(x)));

// String StoreOrderingSearchModelToJson(List<StoreOrderingSearchModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreOrderingSearchModel {
  StoreOrderingSearchModel({
    this.id,
    this.name,
    this.type,
  });

  int? id;
  Name? name;
  String? type;

  factory StoreOrderingSearchModel.fromJson(Map<String, dynamic> json) => StoreOrderingSearchModel(
        id: json["id"],
        name: Name.fromJson(json["name"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name!.toJson(),
        "type": type,
      };
}

class Name {
  Name({
    this.en,
  });

  String? en;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        en: json["en"],
        //  ar: json["ar"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        //  "ar": ar,
      };
}
