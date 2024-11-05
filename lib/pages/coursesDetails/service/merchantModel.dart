import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class MerchantModel {
  static Future<MerchantInfo> merchantInfoPhp(merchantId) async {
    try {
      var jsons = {};
      jsons["merchantId"] = merchantId;
      var result = await GetAPI.providers(jsons, 'get-merchant-info.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final merchantInfo = merchantInfoFromJson(response);
        return merchantInfo;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

MerchantInfo merchantInfoFromJson(String str) =>
    MerchantInfo.fromJson(json.decode(str));

String merchantInfoToJson(MerchantInfo data) => json.encode(data.toJson());

class MerchantInfo {
    MerchantInfo({
        this.merchantDetailId,
        this.userId,
        this.contactNo,
        this.email,
        this.address,
        this.billingAddress,
        this.product,
        this.service,
        this.course,
        this.referCode,
        this.addBy,
        this.dateAdd,
        this.status,
        this.gender,
        this.dob,
        this.bankName,
        this.bankNoAccount,
        this.userName,
        this.fullName,
        this.userType,
        this.referral,
        this.image,
    });

    String merchantDetailId;
    String userId;
    String contactNo;
    String email;
    String address;
    String billingAddress;
    String product;
    String service;
    String course;
    String referCode;
    String addBy;
    DateTime dateAdd;
    String status;
    String gender;
    String dob;
    String bankName;
    String bankNoAccount;
    String userName;
    String fullName;
    String userType;
    String referral;
    String image;

    factory MerchantInfo.fromJson(Map<String, dynamic> json) => MerchantInfo(
        merchantDetailId: json["merchant_detail_id"],
        userId: json["user_id"],
        contactNo: json["contact_no"],
        email: json["email"],
        address: json["address"],
        billingAddress: json["billing_address"],
        product: json["product"],
        service: json["service"],
        course: json["course"],
        referCode: json["refer_code"],
        addBy: json["add_by"],
        dateAdd: DateTime.parse(json["date_add"]),
        status: json["status"],
        gender: json["gender"],
        dob: json["dob"],
        bankName: json["bank_name"],
        bankNoAccount: json["bank_no_account"],
        userName: json["user_name"],
        fullName: json["full_name"],
        userType: json["user_type"],
        referral: json["referral"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "merchant_detail_id": merchantDetailId,
        "user_id": userId,
        "contact_no": contactNo,
        "email": email,
        "address": address,
        "billing_address": billingAddress,
        "product": product,
        "service": service,
        "course": course,
        "refer_code": referCode,
        "add_by": addBy,
        "date_add": dateAdd.toIso8601String(),
        "status": status,
        "gender": gender,
        "dob": dob,
        "bank_name": bankName,
        "bank_no_account": bankNoAccount,
        "user_name": userName,
        "full_name": fullName,
        "user_type": userType,
        "referral": referral,
        "image": image,
    };
}
