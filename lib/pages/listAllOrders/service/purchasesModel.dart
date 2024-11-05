import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class PurchasesModel {
  static Future<List<PurchasesData>> purchasesItemPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'purchases-Item.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final purchasesData = purchasesDataFromJson(response);
        return purchasesData;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<PurchasesData> purchasesDataFromJson(String str) =>
    List<PurchasesData>.from(
        json.decode(str).map((x) => PurchasesData.fromJson(x)));

String purchasesDataToJson(List<PurchasesData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PurchasesData {
  PurchasesData({
    this.purchasesId,
    this.invoiceNo,
    this.userId,
    this.datetime,
    this.grandTotal,
    this.earnedMospoint,
    this.shippingStatus,
    this.rateStatus,
    this.adminFeedback,
    this.action,
    this.referral,
    this.type,
    this.status,
    this.totalPrice,
    this.listItem,
  });

  String purchasesId;
  String invoiceNo;
  String userId;
  DateTime datetime;
  String grandTotal;
  String earnedMospoint;
  ShippingStatus shippingStatus;
  String rateStatus;
  AdminFeedback adminFeedback;
  String action;
  String referral;
  Type type;
  String status;
  double totalPrice;
  List<ListItem> listItem;

  factory PurchasesData.fromJson(Map<String, dynamic> json) => PurchasesData(
        purchasesId: json["purchases_id"],
        invoiceNo: json["invoice_no"],
        userId: json["user_id"],
        datetime: DateTime.parse(json["datetime"]),
        grandTotal: json["grand_total"],
        earnedMospoint: json["earned_mospoint"],
        shippingStatus: shippingStatusValues.map[json["shipping_status"]],
        rateStatus: json["rate_status"],
        adminFeedback: adminFeedbackValues.map[json["admin_feedback"]],
        action: json["action"],
        referral: json["referral"],
        type: typeValues.map[json["type"]],
        status: json["status"],
        totalPrice: json["totalPrice"].toDouble(),
        listItem: List<ListItem>.from(
            json["listItem"].map((x) => ListItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "purchases_id": purchasesId,
        "invoice_no": invoiceNo,
        "user_id": userId,
        "datetime": datetime.toIso8601String(),
        "grand_total": grandTotal,
        "earned_mospoint": earnedMospoint,
        "shipping_status": shippingStatusValues.reverse[shippingStatus],
        "rate_status": rateStatus,
        "admin_feedback": adminFeedbackValues.reverse[adminFeedback],
        "action": action,
        "referral": referral,
        "type": typeValues.reverse[type],
        "status": status,
        "totalPrice": totalPrice,
        "listItem": List<dynamic>.from(listItem.map((x) => x.toJson())),
      };
}

enum AdminFeedback { VVVV, EMPTY, YTYRT }

final adminFeedbackValues = EnumValues({
  "": AdminFeedback.EMPTY,
  "vvvv": AdminFeedback.VVVV,
  "ytyrt": AdminFeedback.YTYRT
});

class ListItem {
  ListItem({
    this.purchasesItemId,
    this.purchasesId,
    this.itemType,
    this.itemId,
    this.packageItemId,
    this.listItemMerchantId,
    this.priceUnit,
    this.discount,
    this.priceDiscount,
    this.voucherId,
    this.voucherPercent,
    this.priceVoucher,
    this.quantity,
    this.itemName,
    this.itemImage,
    this.itemPrice,
    this.merchantId,
    this.merchantName,
    this.merchantImage,
  });

  String purchasesItemId;
  String purchasesId;
  Type itemType;
  String itemId;
  String packageItemId;
  String listItemMerchantId;
  String priceUnit;
  String discount;
  String priceDiscount;
  String voucherId;
  String voucherPercent;
  String priceVoucher;
  String quantity;
  String itemName;
  String itemImage;
  String itemPrice;
  String merchantId;
  String merchantName;
  String merchantImage;

  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
        purchasesItemId: json["purchases_item_id"],
        purchasesId: json["purchases_id"],
        itemType: typeValues.map[json["item_type"]],
        itemId: json["item_id"],
        packageItemId: json["package_item_id"],
        listItemMerchantId: json["merchant_id"],
        priceUnit: json["price_unit"],
        discount: json["discount"],
        priceDiscount: json["price_discount"],
        voucherId: json["voucher_id"],
        voucherPercent: json["voucher_percent"],
        priceVoucher: json["price_voucher"],
        quantity: json["quantity"],
        itemName: json["itemName"],
        itemImage: json["itemImage"],
        itemPrice: json["itemPrice"],
        merchantId: json["merchantId"],
        merchantName: json["merchantName"],
        merchantImage: json["merchantImage"],
      );

  Map<String, dynamic> toJson() => {
        "purchases_item_id": purchasesItemId,
        "purchases_id": purchasesId,
        "item_type": typeValues.reverse[itemType],
        "item_id": itemId,
        "package_item_id": packageItemId,
        "merchant_id": listItemMerchantId,
        "price_unit": priceUnit,
        "discount": discount,
        "price_discount": priceDiscount,
        "voucher_id": voucherId,
        "voucher_percent": voucherPercent,
        "price_voucher": priceVoucher,
        "quantity": quantity,
        "itemName": itemName,
        "itemImage": itemImage,
        "itemPrice": itemPrice,
        "merchantId": merchantId,
        "merchantName": merchantNameValues.reverse[merchantName],
        "merchantImage": merchantImageValues.reverse[merchantImage],
      };
}

enum Type { PRODUCT, COURSES, SERVICE }

final typeValues = EnumValues({
  "courses": Type.COURSES,
  "product": Type.PRODUCT,
  "service": Type.SERVICE
});

enum MerchantImage { SHOP2_8634110876_PNG, DEFAULT_PNG }

final merchantImageValues = EnumValues({
  "default.png": MerchantImage.DEFAULT_PNG,
  "shop2-8634110876.png": MerchantImage.SHOP2_8634110876_PNG
});

enum MerchantName { MER1, MER2 }

final merchantNameValues =
    EnumValues({"mer1": MerchantName.MER1, "mer2": MerchantName.MER2});

enum ShippingStatus { COMPLETED, RETURN, CANCELLED, TO_RECEIVED, TO_DELIVERY }

final shippingStatusValues = EnumValues({
  "cancelled": ShippingStatus.CANCELLED,
  "completed": ShippingStatus.COMPLETED,
  "return": ShippingStatus.RETURN,
  "to_receive": ShippingStatus.TO_RECEIVED,
  "to_delivery": ShippingStatus.TO_DELIVERY,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
