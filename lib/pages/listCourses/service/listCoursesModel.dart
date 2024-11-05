import 'dart:convert';

import 'package:mos_beauty/provider/rest.dart';

class ListCoursesModel {
  static Future<List<Courses>> listProductPhp(jsons, context) async {
    try {
      var result = await GetAPI.providers(jsons, 'listProduct.php');
      var statusCode = result[0];
      var response = result[1];
      if (statusCode == 200) {
        final courses = coursesFromJson(response);
        return courses;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}

List<Courses> coursesFromJson(String str) =>
    List<Courses>.from(json.decode(str).map((x) => Courses.fromJson(x)));

String coursesToJson(List<Courses> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Courses {
  Courses({
    this.coursesId,
    this.coursesCode,
    this.terms,
    this.title,
    this.merchantId,
    this.startDate,
    this.timeFrom,
    this.timeTo,
    this.fees,
    this.commission,
    this.description,
    this.lecturer,
    this.icon,
    this.banner,
    this.status,
    this.addBy,
    this.dateAdd,
    this.minimum,
    this.maximum,
    this.available,
    this.booked,
    this.timeTable,
    this.merchantName,
    this.merchantImage,
    this.totalDiscount,
    this.priceAfterDiscount,
  });

  String coursesId;
  String coursesCode;
  String terms;
  String title;
  String merchantId;
  DateTime startDate;
  String timeFrom;
  String timeTo;
  String fees;
  String commission;
  String description;
  String lecturer;
  String icon;
  String banner;
  String status;
  DateTime addBy;
  String dateAdd;
  String minimum;
  String maximum;
  String available;
  String booked;
  List timeTable;
  String merchantName;
  String merchantImage;
  String totalDiscount;
  String priceAfterDiscount;

  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
      coursesId: json["courses_id"],
      coursesCode: json["courses_code"],
      terms: json["terms"],
      title: json["title"],
      merchantId: json["merchant_id"],
      startDate: DateTime.parse(json["start_date"]),
      timeFrom: json["time_from"],
      timeTo: json["time_to"],
      fees: json["fees"],
      commission: json["commission"],
      description: json["description"],
      lecturer: json["lecturer"],
      icon: json["icon"],
      banner: json["banner"],
      status: json["status"],
      addBy: DateTime.parse(json["add_by"]),
      dateAdd: json["date_add"],
      minimum: json["minimum"],
      maximum: json["maximum"],
      available: json["available"],
      booked: json["booked"],
      timeTable: json["timeTable"],
      merchantName: json['merchantName'],
      merchantImage: json['merchantImage'],
      totalDiscount: json["totalDiscount"],
      priceAfterDiscount: json["priceAfterDiscount"]);

  Map<String, dynamic> toJson() => {
        "courses_id": coursesId,
        "courses_code": coursesCode,
        "terms": terms,
        "title": title,
        "merchant_id": merchantId,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "time_from": timeFrom,
        "time_to": timeTo,
        "fees": fees,
        "commission": commission,
        "description": description,
        "lecturer": lecturer,
        "icon": icon,
        "banner": banner,
        "status": status,
        "add_by": addBy.toIso8601String(),
        "date_add": dateAdd,
        "minimum": minimum,
        "maximum": maximum,
        "available": available,
        "booked": booked,
        "timeTable": timeTable,
        "merchantName": merchantName,
        "merchantImage": merchantImage,
        "totalDiscount": totalDiscount,
        "priceAfterDiscount": priceAfterDiscount,
      };
}
