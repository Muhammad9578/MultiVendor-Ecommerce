import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class ProfileModel {
  Future profileUserPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'profile-user.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final profileUser = profileUserFromJson(response);

        print('Profile User model php Response $profileUser');
        return profileUser;
      } else {
        final profileUser = profileUserFromJson(response);
        return profileUser;
      }
    } catch (e) {}
  }
}

ProfileUser profileUserFromJson(String str) =>
    ProfileUser.fromJson(json.decode(str));

String profileUserToJson(ProfileUser data) => json.encode(data.toJson());

class ProfileUser {
  ProfileUser({
    this.userId,
    this.userName,
    this.userType,
    this.referral,
    this.fullName,
    this.image,
    this.status,
    this.contactNo,
    this.email,
    this.billingAddress,
    this.dob,
    this.gender,
    this.referCode,
    this.userCategory,
    this.addBy,
  });

  String userId;
  String userName;
  String userType;
  String referral;
  String fullName;
  String image;
  String status;
  String contactNo;
  String email;
  String billingAddress;
  DateTime dob;
  String gender;
  String referCode;
  String userCategory;
  String addBy;

  factory ProfileUser.fromJson(Map<String, dynamic> json) => ProfileUser(
        userId: json["userId"],
        userName: json["user_name"],
        userType: json["user_type"],
        referral: json["referral"],
        fullName: json["full_name"],
        image: json["image"],
        status: json["status"],
        contactNo: json["contact_no"],
        email: json["email"],
        billingAddress: json["billing_address"],
        dob: DateTime.parse(json["dob"]),
        gender: json["gender"],
        referCode: json["refer_code"],
        userCategory: json["user_category"],
        addBy: json["add_by"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "user_name": userName,
        "user_type": userType,
        "referral": referral,
        "full_name": fullName,
        "image": image,
        "status": status,
        "contact_no": contactNo,
        "email": email,
        "billing_address": billingAddress,
        "dob":
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "refer_code": referCode,
        "user_category": userCategory,
        "add_by": addBy,
      };
}
