// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.d,
  });

  List<D>? d;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
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
    this.delivaryLocatrion,
    this.delAddress,
    this.mobileNo,
    this.orderStatus,
    this.paymentStatus,
    this.paymentmode,
    this.deltype,
    this.delSlot,
    this.delstarttime,
    this.delendtime,
    this.orderDate,
    this.deliverydate,
    this.totalamount,
    this.packingcount,
    this.storeLOcation,
    this.deliveryCharge,
    this.couponName,
    this.couponamt,
    this.shoplongitude,
    this.shoplatitude,
    this.orderPin,
    this.delbyname,
    this.delboyMobile,
    this.mapAddress,
    this.latitude,
    this.longitude,
    this.delboyName,
    this.delTime,
  });

  String? type;
  String? orderid;
  String? orderNo;
  String? itemCount;
  String? qty;
  String? wt;
  String? customerName;
  String? delivaryLocatrion;
  String? delAddress;
  String? mobileNo;
  String? orderStatus;
  String? paymentStatus;
  String? paymentmode;
  String? deltype;
  String? delSlot;
  String? delstarttime;
  String? delendtime;
  String? orderDate;
  String? deliverydate;
  String? totalamount;
  String? packingcount;
  String? storeLOcation;
  String? deliveryCharge;
  String? couponName;
  String? couponamt;
  String? shoplongitude;
  String? shoplatitude;
  String? orderPin;
  String? delbyname;
  String? delboyMobile;
  String? mapAddress;
  String? latitude;
  String? longitude;
  String? delboyName;
  String? delTime;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        orderid: json["orderid"],
        orderNo: json["orderNo"],
        itemCount: json["ItemCount"],
        qty: json["Qty"],
        wt: json["wt"],
        customerName: json["CustomerName"],
        delivaryLocatrion: json["DelivaryLocatrion"],
        delAddress: json["DelAddress"],
        mobileNo: json["MobileNo"],
        orderStatus: json["OrderStatus"],
        paymentStatus: json["PaymentStatus"],
        paymentmode: json["Paymentmode"],
        deltype: json["Deltype"],
        delSlot: json["DelSlot"],
        delstarttime: json["Delstarttime"],
        delendtime: json["Delendtime"],
        orderDate: json["OrderDate"],
        deliverydate: json["Deliverydate"],
        totalamount: json["Totalamount"],
        packingcount: json["Packingcount"],
        storeLOcation: json["StoreLOcation"],
        deliveryCharge: json["DeliveryCharge"],
        couponName: json["CouponName"],
        couponamt: json["Couponamt"],
        shoplongitude: json["shoplongitude"],
        shoplatitude: json["shoplatitude"],
        orderPin: json["OrderPin"],
        delbyname: json["Delbyname"],
        delboyMobile: json["DelboyMobile"],
        mapAddress: json["MapAddress"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        delboyName: json["DelboyName"],
        delTime: json["DelTime"],
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "orderid": orderid,
        "orderNo": orderNo,
        "ItemCount": itemCount,
        "Qty": qty,
        "wt": wt,
        "CustomerName": customerName,
        "DelivaryLocatrion": delivaryLocatrion,
        "DelAddress": delAddress,
        "MobileNo": mobileNo,
        "OrderStatus": orderStatus,
        "PaymentStatus": paymentStatus,
        "Paymentmode": paymentmode,
        "Deltype": deltype,
        "DelSlot": delSlot,
        "Delstarttime": delstarttime,
        "Delendtime": delendtime,
        "OrderDate": orderDate,
        "Deliverydate": deliverydate,
        "Totalamount": totalamount,
        "Packingcount": packingcount,
        "StoreLOcation": storeLOcation,
        "DeliveryCharge": deliveryCharge,
        "CouponName": couponName,
        "Couponamt": couponamt,
        "shoplongitude": shoplongitude,
        "shoplatitude": shoplatitude,
        "OrderPin": orderPin,
        "Delbyname": delbyname,
        "DelboyMobile": delboyMobile,
        "MapAddress": mapAddress,
        "Latitude": latitude,
        "Longitude": longitude,
        "DelboyName": delboyName,
        "DelTime": delTime,
      };
}
