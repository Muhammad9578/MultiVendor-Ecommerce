import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class DiscountType {
  Future discountData(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'discount.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final discount = discountFromJson(response);
        return discount;
      } else {
        final discount = discountFromJson(response);
        return discount;
      }
    } catch (e) {}
  }
}

List<Discount> discountFromJson(String str) =>
    List<Discount>.from(json.decode(str).map((x) => Discount.fromJson(x)));

String discountToJson(List<Discount> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Discount {
  Discount({
    this.discountItemId,
    this.itemType,
    this.itemId,
    this.name,
    this.discountOff,
    this.startDate,
    this.endDate,
    this.purchaseLimit,
  });

  String discountItemId;
  String itemType;
  String itemId;
  String name;
  String discountOff;
  DateTime startDate;
  DateTime endDate;
  String purchaseLimit;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        discountItemId: json["discount_item_id"],
        itemType: json["item_type"],
        itemId: json["item_id"],
        name: json["name"],
        discountOff: json["discount_off"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        purchaseLimit: json["purchase_limit"],
      );

  Map<String, dynamic> toJson() => {
        "discount_item_id": discountItemId,
        "item_type": itemType,
        "item_id": itemId,
        "name": name,
        "discount_off": discountOff,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "purchase_limit": purchaseLimit,
      };
}
