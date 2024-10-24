// To parse this JSON data, do
//
//     final companyInfoModel = companyInfoModelFromJson(jsonString);

import 'dart:convert';

CompanyInfoModel companyInfoModelFromJson(String str) =>
    CompanyInfoModel.fromJson(json.decode(str));

String companyInfoModelToJson(CompanyInfoModel data) =>
    json.encode(data.toJson());

class CompanyInfoModel {
  CompanyInfoModel({
    this.d,
  });

  D? d;

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) =>
      CompanyInfoModel(
        d: D.fromJson(json["d"]),
      );

  Map<String, dynamic> toJson() => {
        "d": d?.toJson(),
      };
}

class D {
  D({
    this.type,
    this.gstin,
    this.ifscCode,
    this.panNo,
    this.accountType,
    this.companyCode,
    this.nameAsPerBank,
    this.companyinfo,
  });

  String? type;
  dynamic gstin;
  dynamic ifscCode;
  dynamic panNo;
  dynamic accountType;
  dynamic companyCode;
  dynamic nameAsPerBank;
  Companyinfo? companyinfo;

  factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"],
        gstin: json["GSTIN"],
        ifscCode: json["IFSCCode"],
        panNo: json["pan_no"],
        accountType: json["AccountType"],
        companyCode: json["company_code"],
        nameAsPerBank: json["NameAsPerBank"],
        companyinfo: Companyinfo.fromJson(json["companyinfo"]),
      );

  Map<String, dynamic> toJson() => {
        "__type": type,
        "GSTIN": gstin,
        "IFSCCode": ifscCode,
        "pan_no": panNo,
        "AccountType": accountType,
        "company_code": companyCode,
        "NameAsPerBank": nameAsPerBank,
        "companyinfo": companyinfo?.toJson(),
      };
}

class Companyinfo {
  Companyinfo({
    this.expresDeliStore,
    this.radiusMaps,
    this.orderAllow,
    this.contactPerson,
    this.deliveryType,
    this.companyrole,
    this.cityid,
    this.companyaddress,
    this.stateid,
    this.locationid,
    this.compaddress1,
    this.compaddress2,
    this.comppincode,
    this.openTime,
    this.closeTime,
    this.latitude,
    this.longitude,
    this.phone,
    this.paymentmethod,
    this.companyId,
    this.companyName,
    this.companyCode,
    this.logoName,
    this.imgpath,
    this.gstin,
    this.panNo,
    this.nameAsPerBank,
    this.accountType,
    this.ifscCode,
    this.userName,
    this.membershipClubId,
    this.markasConsolidtion,
    this.resuser,
    this.retailPartner,
    this.vendorCode,
    this.dDay,
    this.pOqty,
    this.hidePoQty,
    this.hideMrp,
    this.fssainumber,
    this.locationName,
    this.mapAddress,
    this.kisanservstore,
    this.uDay,
    this.withoutpaidallow,
  });
  String? imgpath;
  String? expresDeliStore;
  String? radiusMaps;
  String? orderAllow;
  String? contactPerson;
  String? deliveryType;
  String? companyrole;
  String? cityid;
  dynamic companyaddress;
  String? stateid;
  String? locationid;
  String? compaddress1;
  String? compaddress2;
  String? comppincode;
  String? openTime;
  String? closeTime;
  String? latitude;
  String? longitude;
  String? phone;
  String? paymentmethod;
  dynamic companyId;
  String? companyName;
  String? companyCode;
  dynamic logoName;
  String? gstin;
  String? panNo;
  String? nameAsPerBank;
  String? accountType;
  String? ifscCode;
  dynamic userName;
  String? membershipClubId;
  String? markasConsolidtion;
  String? resuser;
  String? retailPartner;
  String? vendorCode;
  String? dDay;
  String? pOqty;
  String? hidePoQty;
  String? hideMrp;
  String? fssainumber;
  String? locationName;
  String? mapAddress;
  String? kisanservstore;
  String? uDay;
  dynamic withoutpaidallow;

  factory Companyinfo.fromJson(Map<String, dynamic> json) => Companyinfo(
        expresDeliStore: json["Expres_Deli_Store"],
        radiusMaps: json["radius_maps"],
        orderAllow: json["order_allow"],
        contactPerson: json["contact_person"],
        deliveryType: json["deliveryType"],
        companyrole: json["companyrole"],
        cityid: json["cityid"],
        companyaddress: json["companyaddress"],
        stateid: json["stateid"],
        locationid: json["locationid"],
        compaddress1: json["compaddress1"],
        compaddress2: json["compaddress2"],
        comppincode: json["comppincode"],
        openTime: json["OpenTime"],
        closeTime: json["CloseTime"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        phone: json["phone"],
        paymentmethod: json["paymentmethod"],
        companyId: json["Company_Id"],
        companyName: json["Company_Name"],
        companyCode: json["company_code"],
        logoName: json["logo_name"],
        imgpath: json["imgpath"],
        gstin: json["GSTIN"],
        panNo: json["pan_no"],
        nameAsPerBank: json["NameAsPerBank"],
        accountType: json["AccountType"],
        ifscCode: json["IFSCCode"],
        userName: json["UserName"],
        membershipClubId: json["MembershipClubId"],
        markasConsolidtion: json["MarkasConsolidtion"],
        resuser: json["resuser"],
        retailPartner: json["RetailPartner"],
        vendorCode: json["VendorCode"],
        dDay: json["DDay"],
        pOqty: json["POqty"],
        hidePoQty: json["HidePOQty"],
        hideMrp: json["HideMRP"],
        fssainumber: json["fssainumber"],
        locationName: json["LocationName"],
        mapAddress: json["MapAddress"],
        kisanservstore: json["kisanservstore"],
        uDay: json["UDay"],
        withoutpaidallow: json["withoutpaidallow"],
      );

  Map<String, dynamic> toJson() => {
        "Expres_Deli_Store": expresDeliStore,
        "radius_maps": radiusMaps,
        "order_allow": orderAllow,
        "contact_person": contactPerson,
        "deliveryType": deliveryType,
        "companyrole": companyrole,
        "cityid": cityid,
        "companyaddress": companyaddress,
        "stateid": stateid,
        "locationid": locationid,
        "compaddress1": compaddress1,
        "compaddress2": compaddress2,
        "comppincode": comppincode,
        "OpenTime": openTime,
        "CloseTime": closeTime,
        "Latitude": latitude,
        "Longitude": longitude,
        "phone": phone,
        "paymentmethod": paymentmethod,
        "Company_Id": companyId,
        "Company_Name": companyName,
        "company_code": companyCode,
        "logo_name": logoName,
        "imgpath": imgpath,
        "GSTIN": gstin,
        "pan_no": panNo,
        "NameAsPerBank": nameAsPerBank,
        "AccountType": accountType,
        "IFSCCode": ifscCode,
        "UserName": userName,
        "MembershipClubId": membershipClubId,
        "MarkasConsolidtion": markasConsolidtion,
        "resuser": resuser,
        "RetailPartner": retailPartner,
        "VendorCode": vendorCode,
        "DDay": dDay,
        "POqty": pOqty,
        "HidePOQty": hidePoQty,
        "HideMRP": hideMrp,
        "fssainumber": fssainumber,
        "LocationName": locationName,
        "MapAddress": mapAddress,
        "kisanservstore": kisanservstore,
        "UDay": uDay,
        "withoutpaidallow": withoutpaidallow
      };
}
