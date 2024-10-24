// To parse this JSON data, do
//
//     final razorPayReplyManuallyModel = razorPayReplyManuallyModelFromJson(jsonString);

import 'dart:convert';

RazorPayReplyManuallyModel razorPayReplyManuallyModelFromJson(String str) =>
    RazorPayReplyManuallyModel.fromJson(json.decode(str));

String razorPayReplyManuallyModelToJson(RazorPayReplyManuallyModel data) =>
    json.encode(data.toJson());

class RazorPayReplyManuallyModel {
  RazorPayReplyManuallyModel({
    required this.d,
  });

  D d;

  factory RazorPayReplyManuallyModel.fromJson(Map<String, dynamic> json) =>
      RazorPayReplyManuallyModel(
        d: D.fromJson(json["d"]),
      );

  Map<String, dynamic> toJson() => {
        "d": d.toJson(),
      };
}

class D {
  D({
    required this.type,
    required this.paymentId,
    required this.trasactionId,
    required this.paymentStatus,
    required this.orderNo,
    required this.orderId,
  });

  String type;
  String paymentId;
  String trasactionId;
  String paymentStatus;
  String orderNo;
  String orderId;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        paymentId: json["PaymentId"],
        trasactionId: json["TrasactionId"],
        paymentStatus: json["PaymentStatus"],
        orderNo: json["OrderNo"],
        orderId: json["OrderId"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "PaymentId": paymentId,
        "TrasactionId": trasactionId,
        "PaymentStatus": paymentStatus,
        "OrderNo": orderNo,
        "OrderId": orderId,
      };
}
