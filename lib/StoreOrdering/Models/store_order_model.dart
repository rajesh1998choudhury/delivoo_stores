// To parse this JSON data, do
//
//     final storeOrderModel = storeOrderModelFromJson(jsonString);

import 'dart:convert';

StoreOrderModel storeOrderModelFromJson(String str) =>
    StoreOrderModel.fromJson(json.decode(str));

String storeOrderModelToJson(StoreOrderModel data) =>
    json.encode(data.toJson());

class StoreOrderModel {
  StoreOrderModel({
    this.d,
  });

  List<D>? d;

  factory StoreOrderModel.fromJson(Map<String, dynamic> json) =>
      StoreOrderModel(
        d: List<D>.from(json["d"].map((x) => D.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "d": List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

class D {
  D({
    this.type,
    this.orderid,
    this.orderNo,
    this.itemCount,
    this.qty,
    this.wt,
    this.customerName,
    this.deliveryLocation,
    this.addressLine1,
    this.addressLine2,
    this.mobileNo,
    this.orderStatus,
    this.paymentStatus,
    this.paymentmode,
    this.deltype,
    this.orderDate,
    this.deliverydate,
    this.totalamount,
    this.storeLOcation,
    this.delcharge,
    this.couponName,
    this.couponamt,
    this.disper,
    this.disamt,
    this.Receivedby,
    this.Receivedon
  });

  String? type;
  String? orderid;
  String? orderNo;
  String? itemCount;
  String? qty;
  String? wt;
  String? customerName;
  String? deliveryLocation;
  String? addressLine1;
  String? addressLine2;
  String? mobileNo;
  String? orderStatus;
  String? paymentStatus;
  String? paymentmode;
  String? deltype;
  String? orderDate;
  String? deliverydate;
  String? totalamount;
  String? storeLOcation;
  String? delcharge;
  String? couponName;
  String? couponamt;
  String? disper;
  String? disamt;
  String? Receivedby;
  String? Receivedon;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        orderid: json["orderid"],
        orderNo: json["orderNo"],
        itemCount: json["ItemCount"],
        qty: json["Qty"],
        wt: json["wt"],
        customerName: json["CustomerName"],
        deliveryLocation: json["DeliveryLocation"],
        addressLine1: json["AddressLine1"],
        addressLine2: json["AddressLine2"],
        mobileNo: json["MobileNo"],
        orderStatus: json["OrderStatus"],
        paymentStatus: json["PaymentStatus"],
        paymentmode: json["Paymentmode"],
        deltype: json["Deltype"],
        orderDate: json["OrderDate"],
        deliverydate: json["Deliverydate"],
        totalamount: json["Totalamount"],
        storeLOcation: json["StoreLOcation"],
        delcharge: json["Delcharge"],
        couponName: json["CouponName"],
        couponamt: json["Couponamt"],
        disper: json["Disper"],
        disamt: json["Disamt"],
        Receivedby: json['Receivedby'],
        Receivedon: json['Receivedon']
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "orderid": orderid,
        "orderNo": orderNo,
        "ItemCount": itemCount,
        "Qty": qty,
        "wt": wt,
        "CustomerName": customerName,
        "DeliveryLocation": deliveryLocation,
        "AddressLine1": addressLine1,
        "AddressLine2": addressLine2,
        "MobileNo": mobileNo,
        "OrderStatus": orderStatus,
        "PaymentStatus": paymentStatus,
        "Paymentmode": paymentmode,
        "Deltype": deltype,
        "OrderDate": orderDate,
        "Deliverydate": deliverydate,
        "Totalamount": totalamount,
        "StoreLOcation": storeLOcation,
        "Delcharge": delcharge,
        "CouponName": couponName,
        "Couponamt": couponamt,
        "Disper": disper,
        "Disamt": disamt,
        'Receivedby': Receivedby,
        'Receivedon': Receivedon,
      };
}
