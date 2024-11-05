import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class ListProductModel {
  static Future<List<Product>> listProductPhp(jsons, context) async {
    List<Product> productFromJson(String str) =>
        List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));
    try {
      var result = await GetAPI.providers(jsons, 'listProduct.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final listProduct = productFromJson(response);
        return listProduct;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  String productToJson(List<Product> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

class Product {
  Product({
    this.productId,
    this.productCode,
    this.merchantId,
    this.name,
    this.shortDescription,
    this.description,
    this.sku,
    this.productCategoryId,
    this.productBrandId,
    this.productTag,
    this.startDate,
    this.endDate,
    this.publishStatus,
    this.currencyId,
    this.price,
    this.oldPrice,
    this.commission,
    this.buyButton,
    this.taxExempt,
    this.picture,
    this.status,
    this.addBy,
    this.addDate,
    this.quantity,
    this.merchantName,
    this.merchantImage,
    this.totalDiscount,
    this.priceAfterDiscount,
  });

  String productId;
  String productCode;
  String merchantId;
  String name;
  String shortDescription;
  String description;
  String sku;
  String productCategoryId;
  String productBrandId;
  String productTag;
  DateTime startDate;
  DateTime endDate;
  String publishStatus;
  String currencyId;
  String price;
  String oldPrice;
  String commission;
  String buyButton;
  String taxExempt;
  dynamic picture;
  String status;
  String addBy;
  DateTime addDate;
  String quantity;
  String merchantName;
  String merchantImage;
  double totalDiscount;
  double priceAfterDiscount;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      productId: json["product_id"],
      productCode: json["product_code"],
      merchantId: json["merchant_id"],
      name: json["name"],
      shortDescription: json["short_description"],
      description: json["description"],
      sku: json["sku"],
      productCategoryId: json["product_category_id"],
      productBrandId: json["product_brand_id"],
      productTag: json["product_tag"],
      startDate: DateTime.parse(json["start_date"]),
      endDate: DateTime.parse(json["end_date"]),
      publishStatus: json["publish_status"],
      currencyId: json["currency_id"],
      price: json["price"],
      oldPrice: json["old_price"],
      commission: json["commission"],
      buyButton: json["buy_button"],
      taxExempt: json["tax_exempt"],
      picture: json["picture"],
      status: json["status"],
      addBy: json["add_by"],
      addDate: DateTime.parse(json["add_date"]),
      quantity: json["quantity"],
      merchantName: json['merchantName'],
      merchantImage: json['merchantImage'],
      totalDiscount: json["totalDiscount"],
      priceAfterDiscount: json["priceAfterDiscount"]);

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_code": productCode,
        "merchant_id": merchantId,
        "name": name,
        "short_description": shortDescription,
        "description": description,
        "sku": sku,
        "product_category_id": productCategoryId,
        "product_brand_id": productBrandId,
        "product_tag": productTag,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "publish_status": publishStatus,
        "currency_id": currencyId,
        "price": price,
        "old_price": oldPrice,
        "commission": commission,
        "buy_button": buyButton,
        "tax_exempt": taxExempt,
        "picture": picture.replaceAll('%22', ''),
        "status": status,
        "add_by": addBy,
        "add_date": addDate.toIso8601String(),
        "quantity": quantity,
        "merchantName": merchantName,
        "merchantImage": merchantImage,
        "totalDiscount": totalDiscount,
        "priceAfterDiscount": priceAfterDiscount,
      };
}
