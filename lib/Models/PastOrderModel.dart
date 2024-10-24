import 'package:delivoo_stores/Models/OrderDetailModel.dart';

class PastOrderModel {
  String? orderId;
  String? orderDate;
  String? orderAddress;
  String? orderStatus;
  String? orderTotal;
  String? orderType;
  String? orderAmount;
  String? orderDiscount;
  String? userId;
  String? paymentType;
  String? serviceFee;
  String? totalSaving;
  String? custPhone;
  List<OrderDetailModel>? orderDetail;

  PastOrderModel(
      {this.orderId,
      this.orderDate,
      this.orderAddress,
      this.orderStatus,
      this.orderTotal,
      this.orderType,
      this.orderAmount,
      this.orderDiscount,
      this.userId,
      this.paymentType,
      this.orderDetail,
      this.serviceFee,
      this.totalSaving,
      this.custPhone});
}
