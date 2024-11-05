// To parse this JSON data, do
//
//     final servicesCart = servicesCartFromJson(jsonString);

import 'dart:convert';

List<ServicesCart> servicesCartFromJson(String str) => List<ServicesCart>.from(
    json.decode(str).map((x) => ServicesCart.fromJson(x)));

String servicesCartToJson(List<ServicesCart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServicesCart {
  ServicesCart({
    this.serviceId,
    this.serviceCode,
    this.merchantId,
    this.name,
    this.gender,
    this.serviceCategoryId,
    this.subCategoryId,
    this.tagline,
    this.shortDesc,
    this.description,
    this.duration,
    this.durationType,
    this.currencyId,
    this.cost,
    this.currencyIdMember,
    this.costMember,
    this.commission,
    this.publishStatus,
    this.buyButton,
    this.taxExempt,
    this.image,
    this.status,
    this.addBy,
    this.dateAdd,
    this.sessionPackage,
    this.timeSession,
    this.quantityItem,
    this.totalPrice,
    this.selected,
    this.merchantName,
    this.merchantImage,
    this.totalDiscount,
    this.priceAfterDiscount,
  });

  String serviceId;
  String serviceCode;
  String merchantId;
  String name;
  String gender;
  String serviceCategoryId;
  String subCategoryId;
  String tagline;
  String shortDesc;
  String description;
  String duration;
  String durationType;
  String currencyId;
  String cost;
  String currencyIdMember;
  String costMember;
  String commission;
  String publishStatus;
  String buyButton;
  String taxExempt;
  String image;
  String status;
  String addBy;
  DateTime dateAdd;
  String sessionPackage;
  List<TimeSession> timeSession;
  String merchantName;
  String merchantImage;
  double totalDiscount;
  double priceAfterDiscount;
  int quantityItem = 1;
  double totalPrice;
  bool selected = false;

  factory ServicesCart.fromJson(Map<String, dynamic> json) => ServicesCart(
        serviceId: json["service_id"],
        serviceCode: json["service_code"],
        merchantId: json["merchant_id"],
        name: json["name"],
        gender: json["gender"],
        serviceCategoryId: json["service_category_id"],
        subCategoryId: json["sub_category_id"],
        tagline: json["tagline"],
        shortDesc: json["short_desc"],
        description: json["description"],
        duration: json["duration"],
        durationType: json["duration_type"],
        currencyId: json["currency_id"],
        cost: json["cost"],
        currencyIdMember: json["currency_id_member"],
        costMember: json["cost_member"],
        commission: json["commission"],
        publishStatus: json["publish_status"],
        buyButton: json["buy_button"],
        taxExempt: json["tax_exempt"],
        image: json["image"],
        status: json["status"],
        addBy: json["add_by"],
        dateAdd: DateTime.parse(json["date_add"]),
        sessionPackage: json["session_package"],
        timeSession: List<TimeSession>.from(
            json["timeSession"].map((x) => TimeSession.fromJson(x))),
        merchantName: json["merchantName"],
        merchantImage: json["merchantImage"],
        totalDiscount: double.parse(json["totalDiscount"]),
        priceAfterDiscount: double.parse(json["priceAfterDiscount"]),
        quantityItem: 1,
        totalPrice: 0,
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "service_code": serviceCode,
        "merchant_id": merchantId,
        "name": name,
        "gender": gender,
        "service_category_id": serviceCategoryId,
        "sub_category_id": subCategoryId,
        "tagline": tagline,
        "short_desc": shortDesc,
        "description": description,
        "duration": duration,
        "duration_type": durationType,
        "currency_id": currencyId,
        "cost": cost,
        "currency_id_member": currencyIdMember,
        "cost_member": costMember,
        "commission": commission,
        "publish_status": publishStatus,
        "buy_button": buyButton,
        "tax_exempt": taxExempt,
        "image": image,
        "status": status,
        "add_by": addBy,
        "date_add":
            "${dateAdd.year.toString().padLeft(4, '0')}-${dateAdd.month.toString().padLeft(2, '0')}-${dateAdd.day.toString().padLeft(2, '0')}",
        "session_package": sessionPackage,
        "timeSession": List<dynamic>.from(timeSession.map((x) => x.toJson())),
        "merchantName": merchantName,
        "merchantImage": merchantImage,
        "totalDiscount": totalDiscount,
        "priceAfterDiscount": priceAfterDiscount,
      };
}

class TimeSession {
  TimeSession({
    this.serviceSessionId,
    this.serviceId,
    this.day,
    this.time,
    this.quantityPerSession,
    this.available,
    this.booked,
    this.selectedMe,
  });

  String serviceSessionId;
  String serviceId;
  String day;
  String time;
  String quantityPerSession;
  String available;
  String booked;
  int selectedMe;

  factory TimeSession.fromJson(Map<String, dynamic> json) => TimeSession(
        serviceSessionId: json["service_session_id"],
        serviceId: json["service_id"],
        day: json["day"],
        time: json["time"],
        quantityPerSession: json["quantity_per_session"],
        available: json["available"],
        booked: json["booked"],
        selectedMe: json["selectedMe"],
      );

  Map<String, dynamic> toJson() => {
        "service_session_id": serviceSessionId,
        "service_id": serviceId,
        "day": day,
        "time": time,
        "quantity_per_session": quantityPerSession,
        "available": available,
        "booked": booked,
        "selectedMe": selectedMe,
      };
}
