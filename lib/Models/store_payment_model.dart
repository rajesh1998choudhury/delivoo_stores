// To parse this JSON data, do
//
//     final checkPaymentStatusModel = checkPaymentStatusModelFromJson(jsonString);

import 'dart:convert';

CheckPaymentStatusModel checkPaymentStatusModelFromJson(String str) =>
    CheckPaymentStatusModel.fromJson(json.decode(str));

String checkPaymentStatusModelToJson(CheckPaymentStatusModel data) =>
    json.encode(data.toJson());

class CheckPaymentStatusModel {
  CheckPaymentStatusModel({
    required this.d,
  });

  List<D> d;

  factory CheckPaymentStatusModel.fromJson(Map<String, dynamic> json) =>
      CheckPaymentStatusModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d.map((x) => x.toJson())),
      };
}

class D {
  D({
    required this.type,
    required this.cname,
    required this.deliveryDate,
    required this.transactionAmt,
    required this.paymentstatus,
    required this.getwaytype,
    required this.mobileNo,
    required this.razorpayorderid,
    required this.temporderid,
    required this.slotTime,
    required this.transactionidforword,
  });

  String type;
  String cname;
  String deliveryDate;
  String transactionAmt;
  String paymentstatus;
  String getwaytype;
  String mobileNo;
  String razorpayorderid;
  String temporderid;
  String slotTime;
  String transactionidforword;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        cname: json["Cname"],
        deliveryDate: json["delivery_date"],
        transactionAmt: json["transaction_amt"],
        paymentstatus: json["paymentstatus"],
        getwaytype: json["getwaytype"],
        mobileNo: json["mobileNo"],
        razorpayorderid: json["razorpayorderid"],
        temporderid: json["temporderid"],
        slotTime: json["SlotTime"],
        transactionidforword: json["transactionidforword"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "Cname": cname,
        "delivery_date": deliveryDate,
        "transaction_amt": transactionAmt,
        "paymentstatus": paymentstatus,
        "getwaytype": getwaytype,
        "mobileNo": mobileNo,
        "razorpayorderid": razorpayorderid,
        "temporderid": temporderid,
        "SlotTime": slotTime,
        "transactionidforword": transactionidforword,
      };
}
