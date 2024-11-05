import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class FlashSaleDataModel {
  static Future<FlashSaleData> flashSaleModelPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'flash-sale-item.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final flashSaleData = flashSaleDataFromJson(response);
        return flashSaleData;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

FlashSaleData flashSaleDataFromJson(String str) =>
    FlashSaleData.fromJson(json.decode(str));

String flashSaleDataToJson(FlashSaleData data) => json.encode(data.toJson());

class FlashSaleData {
  FlashSaleData({
    this.countDown,
    this.flashSale,
  });

  DateTime countDown;
  List<FlashSale> flashSale;

  factory FlashSaleData.fromJson(Map<String, dynamic> json) => FlashSaleData(
        countDown: DateTime.parse(json["countDown"]),
        flashSale: List<FlashSale>.from(
            json["flashSale"].map((x) => FlashSale.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countDown": countDown.toIso8601String(),
        "flashSale": List<dynamic>.from(flashSale.map((x) => x.toJson())),
      };
}

class FlashSale {
  FlashSale({
    this.flashSaleItemId,
    this.flashSaleId,
    this.itemType,
    this.itemId,
    this.offType,
    this.flashSaleOff,
    this.title,
    this.banner,
    this.startDate,
    this.endDate,
    this.price,
    this.dateAdd,
    this.status,
  });

  String flashSaleItemId;
  String flashSaleId;
  String itemType;
  String itemId;
  String offType;
  String flashSaleOff;
  String title;
  String banner;
  String startDate;
  DateTime endDate;
  String price;
  String dateAdd;
  String status;

  factory FlashSale.fromJson(Map<String, dynamic> json) => FlashSale(
        flashSaleItemId: json["flash_sale_item_id"],
        flashSaleId: json["flash_sale_id"],
        itemType: json["item_type"],
        itemId: json["item_id"],
        offType: json["off_type"],
        flashSaleOff: json["flash_sale_off"],
        title: json["title"],
        banner: json["banner"],
        startDate: json["start_date"],
        endDate: DateTime.parse(json["end_date"]),
        price: json["price"],
        dateAdd: json["date_add"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "flash_sale_item_id": flashSaleItemId,
        "flash_sale_id": flashSaleId,
        "item_type": itemType,
        "item_id": itemId,
        "off_type": offType,
        "flash_sale_off": flashSaleOff,
        "title": title,
        "banner": banner,
        "start_date": startDate,
        "end_date": endDate.toIso8601String(),
        "price": price,
        "date_add": dateAdd,
        "status": status,
      };
}
