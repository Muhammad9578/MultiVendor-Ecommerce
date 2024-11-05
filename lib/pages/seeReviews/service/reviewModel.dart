import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class ReviewModel {
  static Future<List<ReviewData>> reviewModelPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'seeReview.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final reviewData = reviewDataFromJson(response);
        return reviewData;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<ReviewData> reviewDataFromJson(String str) =>
    List<ReviewData>.from(json.decode(str).map((x) => ReviewData.fromJson(x)));

String reviewDataToJson(List<ReviewData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewData {
  ReviewData({
    this.feedbackId,
    this.itemType,
    this.itemId,
    this.feedback,
    this.rating,
    this.purchasesId,
    this.purchasesItemId,
    this.userId,
    this.dateTime,
  });

  String feedbackId;
  String itemType;
  String itemId;
  String feedback;
  String rating;
  String purchasesId;
  String purchasesItemId;
  String userId;
  DateTime dateTime;

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        feedbackId: json["feedback_id"],
        itemType: json["item_type"],
        itemId: json["item_id"],
        feedback: json["feedback"],
        rating: json["rating"],
        purchasesId: json["purchases_id"],
        purchasesItemId: json["purchases_item_id"],
        userId: json["user_id"],
        dateTime: DateTime.parse(json["date_time"]),
      );

  Map<String, dynamic> toJson() => {
        "feedback_id": feedbackId,
        "item_type": itemType,
        "item_id": itemId,
        "feedback": feedback,
        "rating": rating,
        "purchases_id": purchasesId,
        "purchases_item_id": purchasesItemId,
        "user_id": userId,
        "date_time": dateTime.toIso8601String(),
      };
}
