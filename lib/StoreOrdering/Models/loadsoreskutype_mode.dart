// To parse this JSON data, do
//
//     final loadstoreskutypemodel = loadstoreskutypemodelFromJson(jsonString);

import 'dart:convert';

Loadstoreskutypemodel loadstoreskutypemodelFromJson(String str) => Loadstoreskutypemodel.fromJson(json.decode(str));

String loadstoreskutypemodelToJson(Loadstoreskutypemodel data) => json.encode(data.toJson());

class Loadstoreskutypemodel {
    List<D> d;

    Loadstoreskutypemodel({
        required this.d,
    });

    factory Loadstoreskutypemodel.fromJson(Map<String, dynamic> json) => Loadstoreskutypemodel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
    };
}

class D {
    String type;
    String categoryId;
    String categoryName;

    D({
        required this.type,
        required this.categoryId,
        required this.categoryName,
    });

    factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        categoryId: json["CategoryId"],
        categoryName: json["CategoryName"],
    );

    Map<String, dynamic> toJson() => {
        "__type": type,
        "CategoryId": categoryId,
        "CategoryName": categoryName,
    };
}
