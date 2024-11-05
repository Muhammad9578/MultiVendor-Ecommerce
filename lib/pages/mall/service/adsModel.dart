import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class AdsModel {
  static Future<List<AdsData>> adsPhp(jsons) async {
    try {
      var result = await GetAPI.providers(jsons, 'ads.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final adsData = adsDataFromJson(response);
        return adsData;
      } else {
        final adsData = adsDataFromJson(response);
        return adsData;
      }
    } catch (e) {
      return [];
    }
  }
}

List<AdsData> adsDataFromJson(String str) =>
    List<AdsData>.from(json.decode(str).map((x) => AdsData.fromJson(x)));

String adsDataToJson(List<AdsData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdsData {
  AdsData({
    this.adsId,
    this.img,
    this.title,
    this.link,
    this.publishStatus,
    this.addDate,
    this.addBy,
    this.status,
  });

  String adsId;
  String img;
  String title;
  String link;
  String publishStatus;
  DateTime addDate;
  String addBy;
  String status;

  factory AdsData.fromJson(Map<String, dynamic> json) => AdsData(
        adsId: json["ads_id"],
        img: json["img"],
        title: json["title"],
        link: json["link"],
        publishStatus: json["publish_status"],
        addDate: DateTime.parse(json["add_date"]),
        addBy: json["add_by"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "ads_id": adsId,
        "img": img,
        "title": title,
        "link": link,
        "publish_status": publishStatus,
        "add_date": addDate.toIso8601String(),
        "add_by": addBy,
        "status": status,
      };
}
