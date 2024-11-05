import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class ViewShopModel {
  static Future<MerchantDataInfo> merchantPage(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'merchant-page.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final merchantDataInfo = merchantDataInfoFromJson(response);
        return merchantDataInfo;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

MerchantDataInfo merchantDataInfoFromJson(String str) =>
    MerchantDataInfo.fromJson(json.decode(str));

String merchantDataInfoToJson(MerchantDataInfo data) =>
    json.encode(data.toJson());

class MerchantDataInfo {
  MerchantDataInfo({
    this.merchantDetailId,
    this.userId,
    this.contactNo,
    this.email,
    this.userName,
    this.fullName,
    this.image,
    this.dateJoin,
    this.courses,
    this.product,
    this.service,
    this.coursesList,
    this.productList,
    this.serviceList,
  });

  String merchantDetailId;
  String userId;
  String contactNo;
  String email;
  String userName;
  String fullName;
  String image;
  String dateJoin;
  String courses;
  String product;
  String service;
  List<CoursesList> coursesList;
  List<ProductList> productList;
  List<ServiceList> serviceList;

  factory MerchantDataInfo.fromJson(Map<String, dynamic> json) =>
      MerchantDataInfo(
        merchantDetailId: json["merchant_detail_id"],
        userId: json["user_id"],
        contactNo: json["contact_no"],
        email: json["email"],
        userName: json["user_name"],
        fullName: json["full_name"],
        image: json["image"],
        dateJoin: json["date_join"],
        courses: json["courses"],
        product: json["product"],
        service: json["service"],
        coursesList: List<CoursesList>.from(
            json["coursesList"].map((x) => CoursesList.fromJson(x))),
        productList: List<ProductList>.from(
            json["productList"].map((x) => ProductList.fromJson(x))),
        serviceList: List<ServiceList>.from(
            json["serviceList"].map((x) => ServiceList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "merchant_detail_id": merchantDetailId,
        "user_id": userId,
        "contact_no": contactNo,
        "email": email,
        "user_name": userName,
        "full_name": fullName,
        "image": image,
        "date_join": dateJoin,
        "courses": courses,
        "product": product,
        "service": service,
        "coursesList": List<dynamic>.from(coursesList.map((x) => x.toJson())),
        "productList": List<dynamic>.from(productList.map((x) => x.toJson())),
        "serviceList": List<dynamic>.from(serviceList.map((x) => x.toJson())),
      };
}

class CoursesList {
  CoursesList({
    this.coursesId,
    this.coursesCode,
    this.title,
    this.fees,
    this.discountOff,
    this.priceDiscount,
    this.icon,
    this.rating,
  });

  String coursesId;
  String coursesCode;
  String title;
  String fees;
  String discountOff;
  String priceDiscount;
  String icon;
  int rating;

  factory CoursesList.fromJson(Map<String, dynamic> json) => CoursesList(
        coursesId: json["courses_id"],
        coursesCode: json["courses_code"],
        title: json["title"],
        fees: json["fees"],
        discountOff: json["discount_off"],
        priceDiscount: json["price_discount"],
        icon: json["icon"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "courses_id": coursesId,
        "courses_code": coursesCode,
        "title": title,
        "fees": fees,
        "discount_off": discountOff,
        "price_discount": priceDiscount,
        "icon": icon,
        "rating": rating,
      };
}

class ProductList {
  ProductList({
    this.productId,
    this.productCode,
    this.name,
    this.price,
    this.discountOff,
    this.priceDiscount,
    this.picture,
    this.rating,
  });

  String productId;
  String productCode;
  String name;
  String price;
  String discountOff;
  String priceDiscount;
  String picture;
  int rating;

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        productId: json["product_id"],
        productCode: json["product_code"],
        name: json["name"],
        price: json["price"],
        discountOff: json["discount_off"],
        priceDiscount: json["price_discount"],
        picture: json["picture"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_code": productCode,
        "name": name,
        "price": price,
        "discount_off": discountOff,
        "price_discount": priceDiscount,
        "picture": picture,
        "rating": rating,
      };
}

class ServiceList {
  ServiceList({
    this.serviceId,
    this.serviceCode,
    this.name,
    this.cost,
    this.discountOff,
    this.priceDiscount,
    this.image,
    this.rating,
  });

  String serviceId;
  String serviceCode;
  String name;
  String cost;
  String discountOff;
  String priceDiscount;
  String image;
  int rating;

  factory ServiceList.fromJson(Map<String, dynamic> json) => ServiceList(
        serviceId: json["service_id"],
        serviceCode: json["service_code"],
        name: json["name"],
        cost: json["cost"],
        discountOff: json["discount_off"],
        priceDiscount: json["price_discount"],
        image: json["image"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "service_code": serviceCode,
        "name": name,
        "cost": cost,
        "discount_off": discountOff,
        "price_discount": priceDiscount,
        "image": image,
        "rating": rating,
      };
}
